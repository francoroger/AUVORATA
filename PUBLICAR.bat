@echo off
REM =====================================================
REM   PUBLICAR.bat - AUVORATA
REM   - Self-relaunch em cmd /k para janela NUNCA fechar
REM   - Logs tudo em publicar.log
REM   - Pausa em cada erro
REM =====================================================

REM --- Self-relaunch: se nao tem o argumento STAYOPEN, abre cmd /k e roda ---
if "%~1"=="STAYOPEN" goto :MAIN
start "AUVORATA - Publicar" cmd /k ""%~f0" STAYOPEN"
exit /b

:MAIN
title AUVORATA - Publicar site
cd /d "%~dp0"

REM --- Inicia o log ---
set "LOG=%~dp0publicar.log"
echo. > "%LOG%"
echo [%date% %time%] Iniciando PUBLICAR.bat >> "%LOG%"

echo.
echo ===============================================
echo   AUVORATA - Publicar site
echo ===============================================
echo.
echo Pasta atual:
echo   %CD%
echo.
echo Log completo em: %LOG%
echo.
echo ===============================================
echo.

REM --- Verificar Git ---
echo [1/5] Verificando Git...
where git >nul 2>>"%LOG%"
if errorlevel 1 (
  echo.
  echo  [ERRO] Git nao esta instalado.
  echo  Baixe em: https://git-scm.com/download/win
  echo.
  echo Pressione qualquer tecla para fechar...
  pause >nul
  exit /b 1
)
git --version
echo   [OK]
echo.

REM --- Verificar repositorio Git ---
echo [2/5] Verificando repositorio Git nesta pasta...
if not exist ".git" (
  echo.
  echo  [ERRO] Esta pasta nao tem repositorio Git.
  echo  Pasta: %CD%
  echo.
  echo  Coloque o PUBLICAR.bat dentro da pasta do site
  echo  ^(onde existe index.html e a pasta .git^).
  echo.
  echo Pressione qualquer tecla para fechar...
  pause >nul
  exit /b 1
)
echo   [OK] Repositorio Git encontrado
echo.

REM --- Verificar index.html ---
echo [3/5] Verificando arquivos do site...
if not exist "index.html" (
  echo.
  echo  [ERRO] index.html nao encontrado.
  echo  Pasta: %CD%
  echo.
  echo Pressione qualquer tecla para fechar...
  pause >nul
  exit /b 1
)
echo   [OK] index.html presente
echo.

REM --- Testar SSH com GitHub (com timeout curto) ---
echo [4/5] Testando conexao SSH com GitHub...
ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new -T git@github.com >>"%LOG%" 2>&1
REM ssh -T retorna 1 mesmo quando autentica com sucesso - precisa procurar a string
ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 | findstr /C:"successfully authenticated" >nul
if errorlevel 1 (
  echo.
  echo  [ERRO] Conexao SSH com GitHub nao autenticou.
  echo.
  echo  Veja detalhes no log: %LOG%
  echo.
  echo  Solucao rapida:
  echo    1^) Abra o Git Bash
  echo    2^) Cole:   ssh -T git@github.com
  echo    3^) Se pedir, digite:  yes
  echo    4^) Rode este PUBLICAR.bat de novo
  echo.
  echo Pressione qualquer tecla para fechar...
  pause >nul
  exit /b 1
)
echo   [OK] GitHub autenticou voce
echo.

REM --- Detectar se ha mudancas ---
echo [5/5] Verificando mudancas locais...
git status --porcelain > "%TEMP%\auvorata_status.txt" 2>>"%LOG%"
for %%A in ("%TEMP%\auvorata_status.txt") do set TAMANHO=%%~zA
del "%TEMP%\auvorata_status.txt" 2>nul

if "%TAMANHO%"=="0" (
  echo   [INFO] Nenhuma mudanca local.
  echo   Vou apenas tentar empurrar commits pendentes.
  echo.
  goto PUSH
)

echo   Mudancas detectadas:
git status --short
echo.

REM --- Mensagem do commit ---
set "DATAHORA=%date% %time%"
set "MENSAGEM=Atualizacao do site - %DATAHORA%"
echo Mensagem de commit padrao:
echo   %MENSAGEM%
echo.
set /p "NOVAMENSAGEM=Aperte ENTER para usar essa, ou digite outra: "
if not "%NOVAMENSAGEM%"=="" set "MENSAGEM=%NOVAMENSAGEM%"

echo.
echo ===============================================
echo   Salvando alteracoes (commit)
echo ===============================================
git add . 2>>"%LOG%"
git commit -m "%MENSAGEM%" 2>>"%LOG%"
if errorlevel 1 (
  echo.
  echo  [ERRO] Falha no commit. Veja: %LOG%
  echo.
  echo Pressione qualquer tecla para fechar...
  pause >nul
  exit /b 1
)
echo [OK] Commit criado
echo.

:PUSH
echo ===============================================
echo   Enviando para o GitHub
echo ===============================================
git push -u origin main 2>>"%LOG%"
if errorlevel 1 (
  echo.
  echo  [AVISO] Push direto falhou. Tentando sincronizar primeiro...
  git pull origin main --no-edit --allow-unrelated-histories 2>>"%LOG%"
  echo.
  echo  Tentando push novamente...
  git push -u origin main 2>>"%LOG%"
  if errorlevel 1 (
    echo.
    echo  [ERRO] Push falhou. Veja detalhes em: %LOG%
    echo.
    echo Pressione qualquer tecla para fechar...
    pause >nul
    exit /b 1
  )
)

echo.
echo ===============================================
echo   PUBLICADO COM SUCESSO!
echo ===============================================
echo.
echo  GitHub: https://github.com/francoroger/AUVORATA
echo.
echo  Proximo passo (so na primeira vez):
echo  cPanel ^> Git Version Control ^> Manage
echo  ^> Update from Remote ^> Deploy HEAD Commit
echo.
echo ===============================================
echo.
echo Abrindo o GitHub no navegador...
start https://github.com/francoroger/AUVORATA
echo.
echo Pressione qualquer tecla para fechar esta janela...
pause >nul
exit /b 0
