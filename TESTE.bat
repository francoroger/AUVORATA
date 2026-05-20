@echo off
echo.
echo ===============================================
echo   TESTE DE EXECUCAO DE .BAT
echo ===============================================
echo.
echo Se voce esta vendo esta mensagem, .bat funciona aqui.
echo.
echo Pasta atual: %CD%
echo Caminho deste arquivo: %~f0
echo Argumentos recebidos: %*
echo.
echo Sistema:
ver
echo.
echo Git instalado?
where git 2>nul && echo SIM || echo NAO
echo.
echo ===============================================
echo Pressione qualquer tecla para fechar esta janela.
echo ===============================================
pause >nul
