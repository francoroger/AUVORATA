@echo off
REM =====================================================
REM   cpanel-config.exemplo.bat - AUVORATA
REM
REM   ESTE E UM ARQUIVO DE EXEMPLO. NAO MEXA NELE.
REM
REM   Para usar a automacao de deploy do cPanel:
REM     1. COPIE este arquivo, RENOMEIE para: cpanel-config.bat
REM        (na mesma pasta - C:\Users\roger\OneDrive\Documents\Claude\Projects\AUVORATA SITE\auvorata-site\)
REM     2. ABRA cpanel-config.bat com Notepad/VSCode/etc
REM     3. PREENCHA as 3 variaveis abaixo com seus dados reais
REM     4. SALVE e rode PUBLICAR.bat normalmente
REM
REM   O cpanel-config.bat NAO vai pro GitHub (esta no .gitignore).
REM   Voce pode revogar o token a qualquer momento no cPanel se preferir.
REM =====================================================


REM ---------------------------------------------
REM 1) ENDERECO DO CPANEL
REM ---------------------------------------------
REM Eh o endereco onde voce faz login no cPanel.
REM Geralmente um destes formatos:
REM   - cpanel.SEUDOMINIO.com.br
REM   - SEUSERVIDOR.HOSTING.com.br
REM   - SEUDOMINIO.com.br (com porta 2083 implicita)
REM
REM Olhe na URL do navegador quando esta logado no cPanel.
REM Exemplo: se a URL e "https://servidor123.minhahosting.com.br:2083/cpsess.../"
REM voce coloca:  servidor123.minhahosting.com.br
REM
REM NAO coloque "https://" nem "/cpsess..." - SO O HOST.

set "https://rogerfranco.com.br:2083"


REM ---------------------------------------------
REM 2) USUARIO DO CPANEL
REM ---------------------------------------------
REM Eh o usuario que voce usa pra logar no cPanel.
REM No seu caso, pelo path /home/rogerfra/, e provavelmente:

set "CPANEL_USER=rogerfra"


REM ---------------------------------------------
REM 3) API TOKEN (NAO E SUA SENHA!)
REM ---------------------------------------------
REM PASSO A PASSO para gerar:
REM
REM   a) Entre no cPanel normalmente
REM   b) Procure "Manage API Tokens" (ou "Gerenciar Tokens de API")
REM      - Geralmente esta na secao "Security" / "Seguranca"
REM      - Se nao achar, use a busca do cPanel: digite "token"
REM   c) Clique "Create" / "Criar"
REM   d) De um nome ao token. Sugestao: AUVORATA-DEPLOY
REM   e) Em "Expira em", escolha "Nunca" (ou uma data longa, ex: 2030)
REM   f) Em privilegios: deixe TODOS marcados (ou pelo menos
REM      "Version Control" e "Version Control Deployment")
REM   g) Clique "Create" e COPIE O TOKEN
REM      ATENCAO: o token so aparece UMA VEZ. Se fechar a tela
REM      sem copiar, voce tem que gerar outro.
REM   h) Cole o token aqui embaixo, entre as aspas:

set "C6Q4U32VZR0P9HEZDORAS6AWYNEFJ0Q6"


REM ---------------------------------------------
REM 4) CAMINHO DO REPOSITORIO NO CPANEL
REM ---------------------------------------------
REM Eh o caminho que voce informou ao criar o repositorio
REM em "Controle de Versao do Git". Padrao para Auvorata:

set "CPANEL_REPO=/home/rogerfra/repositories/AUVORATA"


REM ---------------------------------------------
REM FIM DO ARQUIVO
REM ---------------------------------------------
REM Salve e feche.
REM Rode PUBLICAR.bat - ele vai detectar este config e ativar
REM o deploy automatico do cPanel.
