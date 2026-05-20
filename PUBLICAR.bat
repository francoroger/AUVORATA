@echo off
REM PUBLICAR.bat - AUVORATA
REM Self-relaunch + push + chama cpanel-deploy.bat

if "%~1"=="STAYOPEN" goto :MAIN
start "AUVORATA - Publicar" cmd /k call "%~f0" STAYOPEN
exit /b

:MAIN
setlocal enabledelayedexpansion
title AUVORATA - Publicar
cd /d "%~dp0"

set "LOG=%~dp0publicar.log"
echo. > "%LOG%"
echo [%date% %time%] PUBLICAR.bat >> "%LOG%"

echo.
echo ===============================================
echo   AUVORATA - Publicar site
echo ===============================================
echo Pasta: %CD%
echo Log:   %LOG%
echo ===============================================
echo.

if exist ".git\index.lock" (
  echo [SETUP] Removendo lock orfao
  del /f /q ".git\index.lock" >>"%LOG%" 2>&1
)

REM --- SEGURANCA: remove do git qualquer cpanel-config*.bat vazado ---
git ls-files "cpanel-config*.bat" 2>nul | findstr /V "cpanel-config.exemplo.bat" > "%TEMP%\auv_leak.txt"
for /f "tokens=*" %%G in (%TEMP%\auv_leak.txt) do (
  echo [SECURITY] Removendo do git: %%G
  git rm --cached "%%G" >>"%LOG%" 2>&1
)
del "%TEMP%\auv_leak.txt" 2>nul

REM --- Limpar obsoletos ---
set "L=0"
for %%F in ("images\atelier.svg" "images\hero-piece.svg" "images\piece-aurum.svg" "images\piece-origem.svg" "images\piece-solene.svg" "deploy.bat" "primeiro-setup.bat" "setup-ssh.bat" "SETUP.md") do (
  if exist "%%~F" (
    if "!L!"=="0" echo [SETUP] Removendo obsoletos:
    echo   - %%~F
    del /f /q "%%~F" >>"%LOG%" 2>&1
    set "L=1"
  )
)
if "!L!"=="1" echo.

echo [1/4] Git? & where git >nul 2>>"%LOG%" || ( call :ERR "Git nao instalado." & exit /b 1 )
echo   [OK]
echo.

echo [2/4] Repo Git? & if not exist ".git" ( call :ERR "Pasta sem repo Git: %CD%" & exit /b 1 )
echo   [OK]
echo.

echo [3/4] SSH GitHub?
ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | findstr /C:"successfully authenticated" >nul || ( call :ERR "SSH com GitHub falhou. Abra Git Bash: ssh -T git@github.com" & exit /b 1 )
echo   [OK]
echo.

echo [4/4] Mudancas?
git status --porcelain > "%TEMP%\auv_st.txt" 2>>"%LOG%"
for %%A in ("%TEMP%\auv_st.txt") do set TAM=%%~zA
del "%TEMP%\auv_st.txt" 2>nul
if "%TAM%"=="0" ( echo   [INFO] Nenhuma mudanca local. & echo. & goto :PUSH )
echo   Detectadas:
git status --short
echo.

set "MSG=Atualizacao - %date% %time%"
echo Mensagem padrao: %MSG%
set /p "USERMSG=ENTER ou digite outra: "
if not "%USERMSG%"=="" set "MSG=%USERMSG%"
echo.

echo === Commit ===
git add . 2>>"%LOG%"
git commit -m "%MSG%" 2>>"%LOG%" || ( call :ERR "Commit falhou. Veja: %LOG%" & exit /b 1 )
echo [OK] Commit
echo.

:PUSH
echo === Push pro GitHub ===
git push -u origin main 2>>"%LOG%"
if errorlevel 1 (
  echo [AVISO] Push falhou. Sincronizando...
  git pull origin main --no-edit --allow-unrelated-histories 2>>"%LOG%"
  git push -u origin main 2>>"%LOG%" || ( call :ERR "Push falhou. Veja: %LOG%" & exit /b 1 )
)
echo [OK] GitHub atualizado
echo  https://github.com/francoroger/AUVORATA
echo.

call "%~dp0cpanel-deploy.bat"
echo.

start https://github.com/francoroger/AUVORATA
echo ===============================================
echo Pressione qualquer tecla para fechar...
pause >nul
exit /b 0

:ERR
echo.
echo [ERRO] %~1
echo.
echo Pressione qualquer tecla...
pause >nul
goto :eof
