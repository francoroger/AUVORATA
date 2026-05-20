@echo off
REM =====================================================
REM   cpanel-deploy.bat - AUVORATA
REM   Chama a API do cPanel para fazer Update + Deploy.
REM   Chamado automaticamente pelo PUBLICAR.bat ao final.
REM =====================================================

setlocal enabledelayedexpansion
cd /d "%~dp0"

set "LOG=%~dp0publicar.log"

if not exist "cpanel-config.bat" (
  echo ===============================================
  echo  DEPLOY CPANEL - NAO CONFIGURADO
  echo ===============================================
  echo.
  echo  Faca o deploy manualmente:
  echo    cPanel ^> Git Version Control ^> Manage
  echo    ^> Update from Remote + Deploy HEAD Commit
  echo.
  echo  Para automatizar:
  echo    1^) Veja cpanel-config.exemplo.bat
  echo    2^) Copie e renomeie para cpanel-config.bat
  echo    3^) Preencha as 3 variaveis
  echo.
  exit /b 0
)

call cpanel-config.bat

if "%CPANEL_TOKEN%"=="" goto :CFG_VAZIO
if "%CPANEL_TOKEN%"=="COLE_O_TOKEN_AQUI" goto :CFG_VAZIO
if "%CPANEL_HOST%"=="" goto :CFG_VAZIO
if "%CPANEL_USER%"=="" goto :CFG_VAZIO

echo ===============================================
echo   DEPLOY AUTOMATICO NO CPANEL
echo ===============================================
echo   Host: %CPANEL_HOST%
echo   User: %CPANEL_USER%
echo   Repo: %CPANEL_REPO%
echo.

echo [cPanel 1/2] Update from Remote...
curl -sk -H "Authorization: cpanel %CPANEL_USER%:%CPANEL_TOKEN%" "https://%CPANEL_HOST%:2083/execute/VersionControl/update?repository_root=%CPANEL_REPO%" > "%TEMP%\auv_upd.json" 2>>"%LOG%"
type "%TEMP%\auv_upd.json" >> "%LOG%"
findstr /C:"\"status\":1" "%TEMP%\auv_upd.json" >nul
if errorlevel 1 (
  echo.
  echo   [ERRO] Update from Remote falhou.
  echo   Resposta da API:
  type "%TEMP%\auv_upd.json"
  echo.
  exit /b 1
)
echo   [OK] Update OK
echo.

echo [cPanel 2/2] Deploy HEAD Commit...
curl -sk -X POST -H "Authorization: cpanel %CPANEL_USER%:%CPANEL_TOKEN%" "https://%CPANEL_HOST%:2083/execute/VersionControlDeployment/create?repository_root=%CPANEL_REPO%" > "%TEMP%\auv_dep.json" 2>>"%LOG%"
type "%TEMP%\auv_dep.json" >> "%LOG%"
findstr /C:"\"status\":1" "%TEMP%\auv_dep.json" >nul
if errorlevel 1 (
  echo.
  echo   [ERRO] Deploy HEAD Commit falhou.
  echo   Resposta da API:
  type "%TEMP%\auv_dep.json"
  echo.
  exit /b 1
)
echo   [OK] Deploy OK
echo.
del "%TEMP%\auv_upd.json" 2>nul
del "%TEMP%\auv_dep.json" 2>nul

echo ===============================================
echo   SITE NO AR: https://auvorata.com.br
echo ===============================================
echo   (Ctrl+F5 pra forcar atualizacao sem cache)
echo.
exit /b 0

:CFG_VAZIO
echo.
echo ===============================================
echo  CONFIG INCOMPLETO
echo ===============================================
echo.
echo  Abra cpanel-config.bat e preencha:
echo    CPANEL_HOST, CPANEL_USER, CPANEL_TOKEN
echo.
echo  Faca o deploy manualmente esta vez no cPanel.
echo.
exit /b 0
