@echo off
REM PUBLICAR.bat - AUVORATA - v3 (verificacao tolerante)

if "%~1"=="STAYOPEN" goto :MAIN
start "AUVORATA - Publicar" cmd /k call "%~f0" STAYOPEN
exit /b

:MAIN
setlocal enabledelayedexpansion
title AUVORATA - Publicar + Verificar
cd /d "%~dp0"

set "LOG=%~dp0publicar.log"
echo. > "%LOG%"

echo.
echo ===============================================
echo   AUVORATA - Publicar + Verificar
echo ===============================================
echo Pasta: %CD%
echo.

REM Timestamp unico
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value 2^>nul') do set DT=%%a
set "STAMP=v0.5.0-%DT:~0,8%-%DT:~8,6%"
echo %STAMP%> version.txt
echo [STAMP] %STAMP%
echo.

if exist ".git\index.lock" del /f /q ".git\index.lock" >>"%LOG%" 2>&1

echo [1/4] Git?
where git >nul 2>>"%LOG%" || ( call :ERR "Git nao instalado" & exit /b 1 )
echo   [OK]

echo [2/4] Repo?
if not exist ".git" ( call :ERR "Sem repo Git" & exit /b 1 )
echo   [OK]

echo [3/4] SSH GitHub?
ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | findstr /C:"successfully authenticated" >nul || ( call :ERR "SSH falhou" & exit /b 1 )
echo   [OK]

echo [4/4] Commit + Push
git add . 2>>"%LOG%"
git diff --cached --quiet
if errorlevel 1 (
  git commit -m "deploy: %STAMP%" 2>>"%LOG%" || ( call :ERR "Commit falhou" & exit /b 1 )
  echo   [OK] Commit
) else (
  echo   Sem mudancas locais, indo direto pro push
)
git push -u origin main 2>>"%LOG%"
if errorlevel 1 (
  git pull origin main --no-edit --allow-unrelated-histories 2>>"%LOG%"
  git push -u origin main 2>>"%LOG%" || ( call :ERR "Push falhou" & exit /b 1 )
)
echo   [OK] Push pro GitHub
echo.

REM cPanel Update from Remote
if exist "cpanel-config.bat" call cpanel-config.bat
set "CPANEL_OK=0"
if not "%CPANEL_TOKEN%"=="" if not "%CPANEL_TOKEN%"=="COLE_O_TOKEN_AQUI" (
  echo === cPanel Update from Remote ===
  echo   Repo no cPanel: %CPANEL_REPO%
  curl -sk -H "Authorization: cpanel %CPANEL_USER%:%CPANEL_TOKEN%" "https://%CPANEL_HOST%:2083/execute/VersionControl/update?repository_root=%CPANEL_REPO%" > "%TEMP%\auv_upd.json" 2>>"%LOG%"
  type "%TEMP%\auv_upd.json" >> "%LOG%"
  findstr /C:"\"status\":1" "%TEMP%\auv_upd.json" >nul
  if not errorlevel 1 (
    echo   [OK] cPanel pull
    set "CPANEL_OK=1"
  ) else (
    echo   [ERRO] cPanel update falhou. Resposta no log: %LOG%
    echo   Provavel causa: voce ainda nao reconfigurou o repo no cPanel.
    echo   Veja GUIA-CPANEL-SETUP.md
  )
  del "%TEMP%\auv_upd.json" 2>nul
  echo.
)

REM Verificacao
echo === VERIFICACAO ===
echo Aguardando 5s pro servidor processar...
ping -n 6 127.0.0.1 >nul

set "REMOTE=__VAZIO__"
curl -sk -o "%TEMP%\auv_rem.txt" -w "%%{http_code}" "https://auvorata.com.br/version.txt?nc=%RANDOM%" > "%TEMP%\auv_status.txt" 2>>"%LOG%"
set "HTTPCODE="
set /p HTTPCODE=<"%TEMP%\auv_status.txt"
del "%TEMP%\auv_status.txt" 2>nul

echo   HTTP status do servidor: %HTTPCODE%

if "%HTTPCODE%"=="200" (
  REM Le primeira linha so se for arquivo texto pequeno
  for /f "usebackq delims=" %%L in ("%TEMP%\auv_rem.txt") do (
    if "!REMOTE!"=="__VAZIO__" set "REMOTE=%%L"
  )
) else (
  echo   [ALERTA] Servidor retornou %HTTPCODE% para /version.txt
  echo   Significa que o arquivo NAO existe na pasta publica.
  echo   Conclusao: cPanel nao puxou ou clonou em pasta errada.
)
del "%TEMP%\auv_rem.txt" 2>nul

set "LOCAL="
set /p LOCAL=<version.txt

echo.
echo   Local    : !LOCAL!
echo   Servidor : !REMOTE!
echo.

if "!REMOTE!"=="!LOCAL!" (
  color 0A
  echo ===============================================
  echo   [OK] DEPLOY VERIFICADO
  echo ===============================================
  echo   Site atualizado: https://auvorata.com.br
  echo   Ctrl+F5 no navegador pra ver
) else (
  color 0C
  echo ===============================================
  echo   [FALHOU] Servidor nao tem a versao nova
  echo ===============================================
  echo   Veja GUIA-CPANEL-SETUP.md
  echo   GitHub esta atualizado: https://github.com/francoroger/AUVORATA
)
echo.
start https://auvorata.com.br?v=%RANDOM%
pause >nul
exit /b 0

:ERR
echo.
echo [ERRO] %~1
echo.
pause >nul
goto :eof
