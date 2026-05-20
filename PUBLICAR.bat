@echo off
REM PUBLICAR.bat - AUVORATA - v4 (Update + Deploy)

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
echo   AUVORATA - Publicar + Verificar (v4)
echo ===============================================
echo Pasta: %CD%
echo.

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value 2^>nul') do set DT=%%a
set "STAMP=v0.5.0-%DT:~0,8%-%DT:~8,6%"
echo %STAMP%> version.txt
echo [STAMP] %STAMP%
echo.

if exist ".git\index.lock" del /f /q ".git\index.lock" >>"%LOG%" 2>&1

REM Remover arquivos obsoletos (nao usados na v0.5.0)
for %%F in ("script.js" "style.css" ".cpanel.yml" "cpanel-deploy.bat" "TESTE.bat" "images\auvorata-logo.png" "images\atelier.svg" "images\hero-piece.svg" "images\piece-aurum.svg" "images\piece-origem.svg" "images\piece-solene.svg" "deploy.bat" "primeiro-setup.bat" "setup-ssh.bat" "SETUP.md") do (
  if exist "%%~F" (
    echo [LIMPEZA] Removendo obsoleto: %%~F
    del /f /q "%%~F" >>"%LOG%" 2>&1
    git rm --cached "%%~F" >>"%LOG%" 2>&1
  )
)
echo.

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
  echo   Sem mudancas locais
)
git push -u origin main 2>>"%LOG%"
if errorlevel 1 (
  git pull origin main --no-edit --allow-unrelated-histories 2>>"%LOG%"
  git push -u origin main 2>>"%LOG%" || ( call :ERR "Push falhou" & exit /b 1 )
)
echo   [OK] Push pro GitHub
echo.

if exist "cpanel-config.bat" call cpanel-config.bat
if not "%CPANEL_TOKEN%"=="" if not "%CPANEL_TOKEN%"=="COLE_O_TOKEN_AQUI" (
  echo === cPanel ===
  echo   Repo: %CPANEL_REPO%
  echo.
  echo   [1/2] Update from Remote (fetch)...
  curl -sk -H "Authorization: cpanel %CPANEL_USER%:%CPANEL_TOKEN%" "https://%CPANEL_HOST%:2083/execute/VersionControl/update?repository_root=%CPANEL_REPO%" > "%TEMP%\auv_upd.json" 2>>"%LOG%"
  type "%TEMP%\auv_upd.json" >> "%LOG%"
  findstr /C:"\"status\":1" "%TEMP%\auv_upd.json" >nul && echo   [OK] Fetch OK || echo   [AVISO] Fetch falhou - veja log
  del "%TEMP%\auv_upd.json" 2>nul
  echo.
  echo   [2/2] Deploy HEAD Commit (checkout)...
  curl -sk -X POST -H "Authorization: cpanel %CPANEL_USER%:%CPANEL_TOKEN%" "https://%CPANEL_HOST%:2083/execute/VersionControlDeployment/create?repository_root=%CPANEL_REPO%" > "%TEMP%\auv_dep.json" 2>>"%LOG%"
  type "%TEMP%\auv_dep.json" >> "%LOG%"
  findstr /C:"\"status\":1" "%TEMP%\auv_dep.json" >nul && echo   [OK] Deploy OK || echo   [AVISO] Deploy falhou - veja log
  del "%TEMP%\auv_dep.json" 2>nul
  echo.
)

echo === VERIFICACAO ===
echo Aguardando 10s pro servidor processar...
ping -n 11 127.0.0.1 >nul

set "REMOTE=__VAZIO__"
curl -sk -o "%TEMP%\auv_rem.txt" -w "%%{http_code}" "https://auvorata.com.br/version.txt?nc=%RANDOM%" > "%TEMP%\auv_st.txt" 2>>"%LOG%"
set "HTTPCODE="
set /p HTTPCODE=<"%TEMP%\auv_st.txt"
del "%TEMP%\auv_st.txt" 2>nul

echo   HTTP: %HTTPCODE%

if "%HTTPCODE%"=="200" (
  for /f "usebackq delims=" %%L in ("%TEMP%\auv_rem.txt") do (
    if "!REMOTE!"=="__VAZIO__" set "REMOTE=%%L"
  )
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
) else (
  color 0C
  echo ===============================================
  echo   [FALHOU] Servidor desatualizado
  echo ===============================================
  echo   Se persistir, faca manual: cPanel - Git - Manage
  echo   - Pull or Deploy - Update + Deploy HEAD Commit
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
