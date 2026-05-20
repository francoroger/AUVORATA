@echo off
REM VERIFICAR.bat - Checa se servidor tem mesma versao local

if "%~1"=="STAYOPEN" goto :MAIN
start "AUVORATA - Verificar" cmd /k call "%~f0" STAYOPEN
exit /b

:MAIN
setlocal enabledelayedexpansion
cd /d "%~dp0"
title AUVORATA - Verificar deploy

echo.
echo ===============================================
echo   AUVORATA - Verificar deploy
echo ===============================================
echo.

if not exist "version.txt" (
  echo [ERRO] version.txt nao existe localmente.
  echo Rode PUBLICAR.bat antes.
  echo.
  pause >nul
  exit /b 1
)

set "LOCAL="
set /p LOCAL=<version.txt
echo Versao local: !LOCAL!
echo.

echo Baixando version.txt do servidor (com check de HTTP status)...
curl -sk -o "%TEMP%\auv_v.txt" -w "%%{http_code}" "https://auvorata.com.br/version.txt?nc=%RANDOM%" > "%TEMP%\auv_st.txt" 2>nul
set "HTTPCODE="
set /p HTTPCODE=<"%TEMP%\auv_st.txt"
del "%TEMP%\auv_st.txt" 2>nul

echo   HTTP status: !HTTPCODE!

set "REMOTE=__SEM_ARQUIVO__"
if "!HTTPCODE!"=="200" (
  for /f "usebackq delims=" %%L in ("%TEMP%\auv_v.txt") do (
    if "!REMOTE!"=="__SEM_ARQUIVO__" set "REMOTE=%%L"
  )
)
del "%TEMP%\auv_v.txt" 2>nul

echo.
echo   Versao servidor: !REMOTE!
echo.

if not "!HTTPCODE!"=="200" (
  color 0E
  echo ===============================================
  echo   [ALERTA] version.txt nao encontrado no servidor
  echo ===============================================
  echo   HTTP !HTTPCODE! = arquivo nao existe na pasta publica
  echo.
  echo   Causa: o repo do cPanel nao foi clonado dentro da
  echo   pasta publica auvorata.com.br/
  echo.
  echo   Solucao: siga GUIA-CPANEL-SETUP.md (4 passos)
  echo   - renomear pasta atual pra BACKUP
  echo   - criar nova pasta vazia auvorata.com.br
  echo   - excluir repo antigo no Git Version Control
  echo   - criar novo repo apontando pra /home/rogerfra/auvorata.com.br
  echo.
  pause >nul
  exit /b 1
)

if "!REMOTE!"=="!LOCAL!" (
  color 0A
  echo ===============================================
  echo   [OK] LOCAL == SERVIDOR
  echo   Site no ar esta na versao mais recente
  echo ===============================================
) else (
  color 0C
  echo ===============================================
  echo   [FALHOU] LOCAL != SERVIDOR
  echo ===============================================
  echo   Servidor tem versao antiga. Possiveis acoes:
  echo   - Rodar PUBLICAR.bat
  echo   - Aguardar 1 min e rodar VERIFICAR.bat de novo
  echo   - cPanel ^> Git ^> Manage ^> Update from Remote manual
)
echo.
start https://auvorata.com.br?check=%RANDOM%
pause >nul
exit /b 0
