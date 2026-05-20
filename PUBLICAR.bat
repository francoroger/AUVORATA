@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title AUVORATA - Publicar site

REM ============================================
REM   PUBLICAR.bat
REM   Um clique = site publicado no GitHub
REM   Localiza a propria pasta automaticamente
REM ============================================

cd /d "%~dp0"

color 0E
echo.
echo ===============================================
echo   AUVORATA - Publicar site
echo ===============================================
echo.
echo   Pasta detectada automaticamente:
echo   %CD%
echo.
echo ===============================================
echo.

REM --- Verificar se git esta instalado ---
where git >nul 2>nul
if errorlevel 1 (
  color 0C
  echo [ERRO] Git nao esta instalado neste computador.
  echo.
  echo   Baixe em: https://git-scm.com/download/win
  echo.
  pause
  exit /b 1
)

REM --- Verificar se esta dentro de um repositorio git ---
if not exist ".git" (
  color 0C
  echo [ERRO] Esta pasta nao tem repositorio Git inicializado.
  echo.
  echo   Pasta atual: %CD%
  echo.
  echo   Verifique se este arquivo PUBLICAR.bat esta dentro da
  echo   pasta do site (onde existe index.html e a pasta .git).
  echo.
  pause
  exit /b 1
)

REM --- Verificar se index.html existe ---
if not exist "index.html" (
  color 0C
  echo [ERRO] index.html nao encontrado nesta pasta.
  echo   Pasta atual: %CD%
  echo.
  pause
  exit /b 1
)

echo [OK] Git instalado
echo [OK] Repositorio Git encontrado
echo [OK] index.html presente
echo.

REM --- Verificar conexao SSH com GitHub (silencioso, com timeout) ---
echo Testando conexao com GitHub...
ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | findstr /C:"successfully authenticated" >nul
if errorlevel 1 (
  color 0C
  echo.
  echo [ERRO] Conexao SSH com GitHub falhou.
  echo.
  echo   Solucao rapida:
  echo   1) Abra o Git Bash
  echo   2) Cole este comando:  ssh -T git@github.com
  echo   3) Se pedir, digite:   yes
  echo   4) Se autenticar, rode este PUBLICAR.bat de novo
  echo.
  pause
  exit /b 1
)
echo [OK] GitHub respondeu (autenticacao SSH funcionando)
echo.

REM --- Detectar mudancas ---
git status --porcelain > "%TEMP%\auvorata_status.txt"
for /f %%A in ("%TEMP%\auvorata_status.txt") do set TAMANHO=%%~zA
del "%TEMP%\auvorata_status.txt" 2>nul

if "%TAMANHO%"=="0" (
  echo ===============================================
  echo   Nenhuma mudanca local detectada
  echo ===============================================
  echo.
  echo   Vou apenas tentar empurrar commits pendentes...
  echo.
  goto PUSH
)

REM --- Mostrar o que mudou ---
echo ===============================================
echo   Mudancas detectadas:
echo ===============================================
git status --short
echo.

REM --- Mensagem do commit (com padrao automatico) ---
for /f "tokens=1-3 delims=/. " %%a in ('date /t') do set DATA=%%a-%%b-%%c
for /f "tokens=1-2 delims=:. " %%a in ('time /t') do set HORA=%%a-%%b

set "MENSAGEM=Atualizacao do site - %DATA% %HORA%"
echo Mensagem do commit: %MENSAGEM%
echo.
echo (Aperte ENTER para usar essa mensagem, ou digite uma diferente)
set /p NOVAMENSAGEM="Descricao: "
if not "!NOVAMENSAGEM!"=="" set "MENSAGEM=!NOVAMENSAGEM!"

echo.
echo ===============================================
echo   Salvando alteracoes (commit)
echo ===============================================
git add .
git commit -m "%MENSAGEM%"
if errorlevel 1 (
  color 0C
  echo.
  echo [ERRO] Falha ao criar commit. Veja a mensagem acima.
  pause
  exit /b 1
)
echo [OK] Commit criado
echo.

:PUSH
echo ===============================================
echo   Enviando para o GitHub (push)
echo ===============================================
git push -u origin main
if errorlevel 1 (
  REM --- Tentar pull antes do push (caso GitHub tenha algo a mais) ---
  echo.
  echo [AVISO] Push falhou. Tentando sincronizar primeiro...
  git pull origin main --no-edit --allow-unrelated-histories
  echo.
  echo Tentando push novamente...
  git push -u origin main
  if errorlevel 1 (
    color 0C
    echo.
    echo [ERRO] Push falhou. Veja a mensagem acima.
    echo.
    echo   Se a mensagem disse "rejected", o GitHub tem algo
    echo   que o seu computador nao tem ainda. Solucao:
    echo.
    echo     git pull origin main
    echo     PUBLICAR.bat (rodar de novo)
    echo.
    pause
    exit /b 1
  )
)

color 0A
echo.
echo ===============================================
echo   PUBLICADO COM SUCESSO!
echo ===============================================
echo.
echo   GitHub: https://github.com/francoroger/AUVORATA
echo.
echo   Proximo passo (so na primeira vez):
echo   No cPanel ^> Git Version Control ^> Manage
echo   ^> "Update from Remote" ^> "Deploy HEAD Commit"
echo.
echo   Depois disso, o site fica no ar em:
echo   https://auvorata.com.br
echo.
echo ===============================================
echo.
echo Abrindo o GitHub no navegador...
start https://github.com/francoroger/AUVORATA
echo.
pause
exit /b 0
