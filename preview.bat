@echo off
if not exist "index.html" (
    echo [ERRO] index.html nao encontrado.
    pause
    exit /b 1
)
echo Abrindo preview local da Auvorata...
start "" "index.html"
exit /b 0
