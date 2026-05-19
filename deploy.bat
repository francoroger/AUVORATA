@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title Auvorata - Deploy

echo.
echo ===============================================
echo   AUVORATA - Deploy de Atualizacao
echo ===============================================
echo.

where git >nul 2>nul
if errorlevel 1 (
    echo [ERRO] Git nao encontrado.
    pause
    exit /b 1
)

if not exist ".git" (
    echo [ERRO] Esta pasta nao eh um repositorio Git.
    echo Rode primeiro o "primeiro-setup.bat"
    pause
    exit /b 1
)

git status --porcelain > "%TEMP%\auvorata_status.txt"
for /f %%i in ("%TEMP%\auvorata_status.txt") do set TAMANHO=%%~zi
del "%TEMP%\auvorata_status.txt"

if "%TAMANHO%"=="0" (
    echo Nenhuma alteracao detectada.
    echo Tudo ja esta sincronizado com o GitHub.
    echo.
    pause
    exit /b 0
)

echo Alteracoes detectadas:
echo.
git status --short
echo.
echo ===============================================
echo.

set /p MSG="Descreva a mudanca (ex: 'ajuste no manifesto'): "

if "%MSG%"=="" set MSG=atualizacao do site

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /value') do set DT=%%I
set DATA=%DT:~6,2%/%DT:~4,2%/%DT:~0,4% %DT:~8,2%:%DT:~10,2%
set MSG_COMPLETA=%MSG% [%DATA%]

echo.
echo Mensagem do commit: %MSG_COMPLETA%
echo.

echo Adicionando arquivos...
git add .
if errorlevel 1 goto :erro

echo Criando commit...
git commit -m "%MSG_COMPLETA%"
if errorlevel 1 goto :erro

echo.
echo Enviando para o GitHub...
git push origin main
if errorlevel 1 (
    echo.
    echo [AVISO] Push falhou. Tentando rebase...
    git pull --rebase origin main
    if errorlevel 1 goto :erro
    git push origin main
    if errorlevel 1 goto :erro
)

echo.
echo ===============================================
echo   ENVIADO COM SUCESSO PARA O GITHUB
echo ===============================================
echo.
echo Agora atualize no cPanel:
echo.
echo   1. Entre no cPanel
echo   2. Va em "Git Version Control"
echo   3. Clique em "Manage" no repositorio Auvorata
echo   4. Aba "Pull or Deploy":
echo      - "Update from Remote"
echo      - "Deploy HEAD Commit"
echo.
echo OU, se voce configurou o webhook automatico,
echo o cPanel ja atualizou sozinho. Verifique em
echo https://auvorata.com.br em 1-2 minutos.
echo.
pause
exit /b 0

:erro
echo.
echo [ERRO] Algo deu errado.
echo.
pause
exit /b 1
