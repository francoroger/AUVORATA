@echo off
REM =====================================================
REM   PUBLICAR.bat - AUVORATA
REM   - Self-relaunch em cmd /k (janela NUNCA fecha)
REM   - Push pro GitHub
REM   - Chama cpanel-deploy.bat no final
REM =====================================================

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

REM --- Limpar lock orfao ---
if exist ".git\index.lock" (
  echo [SETUP] Removendo lock orfao do git
  del /f /q ".git\index.lock" >>"%LOG%" 2>&1
)

REM --- Limpar arquivos obsoletos ---
set "L=0"
for %%F in (
  "images\atelier.svg" "images\hero-piece.svg"
  "images\piece-aurum.svg" "images\piece-origem.svg" "images\piece-solene.svg"
  "deploy.bat" "primeiro-setup.bat" "setup-ssh.bat" "SETUP.md"
) do (
  if exist "%%~F" (
    if "!L!"=="0" echo [SETUP] Removendo arquivos obsoletos:
    echo   - %%~F
    del /f /q "%%~F" >>"%LOG%" 2>&1
    set "L=1"
  )
)
if "!L!"=="1" echo.

echo [1/4] Git instalado?
where git >nul 2>>"%LOG%" || goto :ERR_GIT
echo   [OK]
echo.

echo [2/4] Repositorio Git presente?
if not exist ".git" goto :ERR_NOREPO
echo   [OK]
echo.

echo [3/4] SSH com GitHub?
ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | findstr /C:"successfully authenticated" >nul || goto :ERR_SSH
echo   [OK]
echo.

echo [4/4] Mudancas locais?
git status --porcelain > "%TEMP%\auv_st.txt" 2>>"%LOG%"
for %%A in ("%TEMP%\auv_st.txt") do set TAM=%%~zA
del "%TEMP%\auv_st.txt" 2>nul
if "%TAM%"=="0" (
  echo   [INFO] Nenhuma mudanca. Tentando push de commits pendentes.
  echo.
  goto :PUSH
)
echo   Mudancas detectadas:
git status --short
echo.

set "MSG=Atualizacao do site - %date% %time%"
echo Mensagem padrao: %MSG%
set /p "USERMSG=Aperte ENTER ou digite outra: "
if not "%USERMSG%"=="" set "MSG=%USERMSG%"
echo.

echo === Commit ===
git add . 2>>"%LOG%"
git commit -m "%MSG%" 2>>"%LOG%" || goto :ERR_COMMIT
echo [OK] Commit criado
echo.

:PUSH
echo === Push pro GitHub ===
git push -u origin main 2>>"%LOG%"
if errorlevel 1 (
  echo [AVISO] Push falhou. Sincronizando...
  git pull origin main --no-edit --allow-unrelated-histories 2>>"%LOG%"
  git push -u origin main 2>>"%LOG%" || goto :ERR_PUSH
)
echo.
echo [OK] GitHub atualizado
echo  https://github.com/francoroger/AUVORATA
echo.

REM --- Chamar deploy do cPanel ---
call "%~dp0cpanel-deploy.bat"
echo.

start https://github.com/francoroger/AUVORATA
echo ===============================================
echo Pressione qualquer tecla para fechar...
pause >nul
exit /b 0

:ERR_GIT
echo [ERRO] Git nao instalado. Baixe em: https://git-scm.com/download/win
echo Pressione qualquer tecla...
pause >nul
exit /b 1

:ERR_NOREPO
echo [ERRO] Esta pasta nao tem repositorio Git: %CD%
echo Pressione qualquer tecla...
pause >nul
exit /b 1

:ERR_SSH
echo [ERRO] SSH com GitHub nao autenticou.
echo  Abra Git Bash, rode: ssh -T git@github.com
echo  Se pedir, digite: yes
echo Pressione qualquer tecla...
pause >nul
exit /b 1

:ERR_COMMIT
echo [ERRO] Falha no commit. Veja: %LOG%
echo Pressione qualquer tecla...
pause >nul
exit /b 1

:ERR_PUSH
echo [ERRO] Push falhou. Veja: %LOG%
echo Pressione qualquer tecla...
pause >nul
exit /b 