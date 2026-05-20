@echo off
REM VERIFICAR.bat - Checa se o servidor tem a mesma versao que o local

if "%~1"=="STAYOPEN" goto :MAIN
start "AUVORATA - Verificar" cmd /k call "%~f0" STAYOPEN
exit /b

:MAIN
cd /d "%~dp0"
title AUVORATA - Verificar deploy

echo.
echo ===============================================
echo   AUVORATA - Verificar deploy
echo ===============================================
echo.

if not exist "version.txt" (
  echo [ERRO] version.txt nao existe localmente.
  echo Rode PUBLICAR.bat ao menos uma vez antes.
  echo.
  pause >nul
  exit /b 1
)

set "LOCAL="
set /p LOCAL=<version.txt
echo Versao local:  %LOCAL%
echo.

echo Baixando do servidor...
curl -sk "https://auvorata.com.br/version.txt?nocache=%RANDOM%" > "%TEMP%\v.txt" 2>nul
set "REMOTE="
set /p REMOTE=<"%TEMP%\v.txt"
del "%TEMP%\v.txt" 2>nul

if "%REMOTE%"=="" (
  echo [AVISO] Servidor nao retornou version.txt.
  echo  Possivel motivo: o repo no cPanel ainda nao foi clonado
  echo  diretamente na pasta publica. Configure conforme o guia.
  echo.
  pause >nul
  exit /b 1
)

echo Versao servidor: %REMOTE%
echo.

if "%REMOTE%"=="%LOCAL%" (
  color 0A
  echo ===============================================
  echo   [OK] LOCAL == SERVIDOR
  echo   O site ja esta na versao mais recente
  echo ===============================================
) else (
  color 0C
  echo ===============================================
  echo   [FALHOU] LOCAL != SERVIDOR
  echo   O servidor ainda esta com versao antiga.
  echo ===============================================
  echo.
  echo  - Voce fez push pro GitHub? (rode PUBLICAR.bat)
  echo  - O cPanel puxou do GitHub? (Update from Remote)
  echo  - O repo cPanel esta clonado na pasta publica?
)
echo.
start https://auvorata.com.br?check=%RANDOM%
pause >nul
exit /b 0
