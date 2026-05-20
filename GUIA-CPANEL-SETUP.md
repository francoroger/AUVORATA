# Reconfigurar cPanel — Solução Definitiva

## Por que reconfigurar

O .cpanel.yml com `Deploy HEAD Commit` nao funciona neste cPanel (varios deploys "OK" mas pasta publica nunca atualiza).

**Solucao**: fazer o cPanel clonar o repositorio **diretamente dentro da pasta publica** `/home/rogerfra/auvorata.com.br/`. Aí `Update from Remote` = arquivos atualizados na hora, sem deploy step.

## Passos no cPanel (5 minutos)

### Passo 1 — Backup da pasta publica atual

1. cPanel → **File Manager**
2. Navega ate `/home/rogerfra/`
3. Botao direito na pasta `auvorata.com.br` → **Rename** → muda para `auvorata.com.br_BACKUP`
4. cPanel cria automaticamente uma pasta `auvorata.com.br` vazia? Se nao, crie:
   - Botao **+ Pasta** no topo → nome `auvorata.com.br` → Criar

### Passo 2 — Remover repo antigo

1. cPanel → **Controle de Versao do Git** (busca "git")
2. Na linha do **Auvorata**, clica em **Gerenciar**
3. Clica em **Excluir Reposit** / **Remove Repository**
4. Confirma

### Passo 3 — Criar repo novo apontando pra pasta publica

1. Ainda em **Controle de Versao do Git**, clica em **Criar**
2. Preenche:

| Campo | Valor |
|---|---|
| **Clonar Reposit** (Clone URL) | `https://github.com/francoroger/AUVORATA.git` |
| **Caminho do Reposit** | `/home/rogerfra/auvorata.com.br` |
| **Nome** | `Auvorata` |
| **Clonar repositorio** | ✓ marcado |

3. Clica em **Criar**
4. Aguarda alguns segundos
5. Mensagem de sucesso deve aparecer

### Passo 4 — Verificar

1. cPanel → File Manager → entra em `/home/rogerfra/auvorata.com.br/`
2. Deve ter:
   - index.html (~5.8 KB)
   - version.txt
   - .htaccess
   - .git/ (oculto)
   - images/
   - script.js, style.css, etc

### Passo 5 — Teste a verificacao automatica

No seu PC, **duplo clique em VERIFICAR.bat**.

- Se aparecer **[OK] LOCAL == SERVIDOR** → tudo funcionando ✓
- Se aparecer **[FALHOU]** → me manda print

## A partir de agora, o fluxo de publicacao e:

1. Edita arquivos no seu PC
2. Duplo clique em **PUBLICAR.bat**
3. PUBLICAR.bat:
   - Atualiza version.txt com timestamp unico
   - Commita + faz push
   - Chama API do cPanel pra fazer Update from Remote
   - Aguarda 5s, baixa version.txt do servidor
   - Compara: igual = OK, diferente = FALHOU
4. Se OK, abre o site no navegador

## Como saber que o deploy funcionou

`version.txt` no servidor === `version.txt` local. PUBLICAR.bat mostra **[OK] DEPLOY VERIFICADO** em verde quando bate.

## E se a verificacao falhar?

- Espera mais 30 segundos e roda **VERIFICAR.bat** de novo (cPanel pode estar processando)
- Se persistir, abre o cPanel → Git Version Control → Manage no Auvorata → Pull or Deploy → clica **Update from Remote** manualmente
- Roda VERIFICAR.bat de novo
