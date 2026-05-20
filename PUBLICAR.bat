@echo off
REM PUBLICAR.bat - AUVORATA - v2 (com verificacao)

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

REM Atualiza version.txt com timestamp unico (forca git a detectar mudanca)
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value 2^>nul') do set DT=%%a
set "STAMP=v0.5.0-%DT:~0,8%-%DT:~8,6%"
echo %STAMP% > version.txt
echo [STAMP] Marcando esta publicacao como: %STAMP%
echo.

if exist ".git\index.lock" del /f /q ".git\index.lock" >>"%LOG%" 2>&1

echo [1/4] Git? & where git >nul 2>>"%LOG%" || ( call :ERR "Git nao instalado" & exit /b 1 )
echo   [OK]
echo.

echo [2/4] Repo? & if not exist ".git" ( call :ERR "Sem repo Git em %CD%" & exit /b 1 )
echo   [OK]
echo.

echo [3/4] SSH GitHub?
ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | findstr /C:"successfully authenticated" >nul || ( call :ERR "SSH falhou" & exit /b 1 )
echo   [OK]
echo.

echo [4/4] Mudancas?
git add . 2>>"%LOG%"
git diff --cached --quiet
if errorlevel 1 (
  echo   Mudancas detectadas, fazendo commit...
  git commit -m "deploy: %STAMP%" 2>>"%LOG%" || ( call :ERR "Commit falhou" & exit /b 1 )
  echo   [OK] Commit criado
) else (
  echo   Nenhuma mudanca, tentando push de commits pendentes
)
echo.

echo === Push pro GitHub ===
git push -u origin main 2>>"%LOG%"
if errorlevel 1 (
  git pull origin main --no-edit --allow-unrelated-histories 2>>"%LOG%"
  git push -u origin main 2>>"%LOG%" || ( call :ERR "Push falhou" & exit /b 1 )
)
echo [OK] Push OK
echo.

REM cPanel: chama Update from Remote (sem Deploy HEAD Commit)
if exist "cpanel-config.bat" call cpanel-config.bat
if not "%CPANEL_TOKEN%"=="" (
  if not "%CPANEL_TOKEN%"=="COLE_O_TOKEN_AQUI" (
    echo === cPanel Update from Remote ===
    curl -sk -H "Authorization: cpanel %CPANEL_USER%:%CPANEL_TOKEN%" "https://%CPANEL_HOST%:2083/execute/VersionControl/update?repository_root=%CPANEL_REPO%" > "%TEMP%\auv_upd.json" 2>>"%LOG%"
    type "%TEMP%\auv_upd.json" >> "%LOG%"
    findstr /C:"\"status\":1" "%TEMP%\auv_upd.json" >nul && echo   [OK] Pull no servidor || echo   [AVISO] Update from Remote retornou erro - veja %LOG%
    del "%TEMP%\auv_upd.json" 2>nul
    echo.
  )
)

REM ============================================
REM   VERIFICACAO AUTOMATICA
REM ============================================
echo === VERIFICACAO ===
echo Aguardando 5 segundos pro servidor processar...
ping -n 6 127.0.0.1 >nul

echo Baixando version.txt do servidor...
curl -sk "https://auvorata.com.br/version.txt?nocache=%RANDOM%" > "%TEMP%\remote_ver.txt" 2>>"%LOG%"

set "REMOTE="
set /p REMOTE=<"%TEMP%\remote_ver.txt"
set "LOCAL="
set /p LOCAL=<version.txt

echo.
echo   Local : %LOCAL%
echo   Servidor: %REMOTE%
echo.

if "%REMOTE%"=="%LOCAL%" (
  color 0A
  echo ===============================================
  echo   [OK] DEPLOY VERIFICADO - SITE ATUALIZADO!
  echo ===============================================
  echo  https://auvorata.com.br
  echo  Apertou Ctrl+F5 no navegador? Faca isso pra ver mudancas.
) else (
  color 0C
  echo ===============================================
  echo   [FALHOU] SERVIDOR NAO TEM A VERSAO NOVA
  echo ===============================================
  echo  O push pro GitHub funcionou mas o servidor nao puxou.
  echo  Possivel causa: repositorio do cPanel nao esta clonado
  echo  na pasta publica. Veja GUIA-CPANEL-SETUP.md para reconfigurar.
  echo.
  echo  Para forcar manualmente: cPanel - Git Version Control
  echo  - Manage - Update from Remote
)
del "%TEMP%\remote_ver.txt" 2>nul
echo.

start https://auvorata.com.br?v=%STAMP%
echo Pressione qualquer tecla para fechar...
pause >nul
exit /b 0

:ERR
echo.
echo [ERRO] %~1
echo.
pause >nul
goto :eof
