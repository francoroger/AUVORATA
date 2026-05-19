@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

title Auvorata - Setup Inicial

echo.
echo ===============================================
echo   AUVORATA - Configuracao Inicial do Git
echo ===============================================
echo.
echo Este script vai:
echo   1. Inicializar o repositorio Git nesta pasta
echo   2. Conectar ao repositorio do GitHub
echo   3. Fazer o primeiro envio (push)
echo.
echo IMPORTANTE: rode isso apenas UMA vez.
echo Para atualizacoes do dia-a-dia, use o deploy.bat
echo.
pause

where git >nul 2>nul
if errorlevel 1 (
    echo.
    echo [ERRO] Git nao encontrado no PATH do sistema.
    echo Baixe e instale em: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo.
echo [OK] Git encontrado.
git --version
echo.

if exist ".git" (
    echo [AVISO] Esta pasta ja eh um repositorio Git.
    echo Se quiser comecar do zero, delete a pasta .git primeiro.
    echo.
    pause
    exit /b 0
)

REM Repositorio do Roger (pre-configurado)
set REPO_URL=git@github.com:francoroger/AUVORATA.git

echo Repositorio configurado: %REPO_URL%
echo.
pause

echo.
echo ===============================================
echo  INICIALIZANDO REPOSITORIO LOCAL
echo ===============================================
echo.

git init
if errorlevel 1 goto :erro

git branch -M main
if errorlevel 1 goto :erro

git remote add origin %REPO_URL%
if errorlevel 1 goto :erro

git config user.name >nul 2>nul
if errorlevel 1 (
    set /p GIT_NAME="Seu nome para os commits: "
    git config user.name "!GIT_NAME!"
)

git config user.email >nul 2>nul
if errorlevel 1 (
    set /p GIT_EMAIL="Seu email para os commits: "
    git config user.email "!GIT_EMAIL!"
)

echo.
echo Adicionando arquivos ao Git...
git add .
if errorlevel 1 goto :erro

echo.
echo Fazendo primeiro commit...
git commit -m "Versao inicial do site Auvorata - Maison editorial"
if errorlevel 1 goto :erro

echo.
echo ===============================================
echo  ENVIANDO PARA O GITHUB
echo ===============================================
echo.

git push -u origin main
if errorlevel 1 (
    echo.
    echo [AVISO] O push falhou. Possiveis causas:
    echo   1. Voce nao configurou SSH no GitHub
    echo   2. O repositorio no GitHub ja tem commits
    echo      Solucao: rode "git pull origin main --allow-unrelated-histories"
    echo      e depois "git push -u origin main"
    echo.
    pause
    exit /b 1
)

echo.
echo ===============================================
echo   SUCESSO!
echo ===============================================
echo.
echo Veja em: https://github.com/francoroger/AUVORATA
echo.
echo PROXIMOS PASSOS NO cPANEL:
echo.
echo 1. Va ao cPanel - "Git Version Control"
echo 2. Clique em "Create" e preencha:
echo    - Clone URL: git@github.com:francoroger/AUVORATA.git
echo    - Repository Path: /home/rogerfra/auvorata.com.br
echo    - Repository Name: Auvorata
echo 3. Apos clonado, va em "Manage" - aba "Pull or Deploy"
echo    - "Update from Remote"
echo    - "Deploy HEAD Commit"
echo.
echo Veja o SETUP.md para o guia completo.
echo.
echo De agora em diante, use o deploy.bat para
echo atualizar o site.
echo.
pause
exit /b 0

:erro
echo.
echo [ERRO] Algo deu errado. Verifique a mensagem acima.
echo.
pause
exit /b 1
