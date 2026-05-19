# 🚀 Auvorata — Guia de Setup

**Repositório:** https://github.com/francoroger/AUVORATA
**Domínio:** https://auvorata.com.br
**Hospedagem:** cPanel — `/home/rogerfra/auvorata.com.br`

---

## ETAPA 1 — SSH com GitHub (se ainda não tem)

Abra **Git Bash** e teste:

```bash
ssh -T git@github.com
```

Se responder `Hi francoroger!` → pule pra Etapa 2.
Se der erro de permissão:

```bash
ssh-keygen -t ed25519 -C "seu@email.com"
clip < ~/.ssh/id_ed25519.pub
```

Cole a chave em https://github.com/settings/keys → New SSH key.

Teste novamente.

---

## ETAPA 2 — Primeiro push

1. Extraia o `auvorata-site.zip` em `C:\Sites\auvorata\`
2. Duplo clique em **`primeiro-setup.bat`**
3. Verifique em https://github.com/francoroger/AUVORATA

---

## ETAPA 3 — Conectar cPanel ao GitHub

### 3.1 — Criar chave SSH no cPanel

cPanel → **"SSH Access"** → **"Manage SSH Keys"** → **"Generate a New Key"**
- Nome: `auvorata_deploy`
- Senha: em branco
- Tipo: ED25519

Após criar, clique em **"View/Download"** na chave pública e copie tudo.

### 3.2 — Adicionar como Deploy Key no GitHub

https://github.com/francoroger/AUVORATA → **Settings** → **Deploy keys** → **Add deploy key**
- Title: `cPanel rogerfra`
- Key: cole a chave
- **NÃO marque** "Allow write access"
- **Add key**

### 3.3 — Clonar no cPanel

cPanel → **"Git Version Control"** → **Create**:
- Clone URL: `git@github.com:francoroger/AUVORATA.git`
- Repository Path: `/home/rogerfra/auvorata.com.br`
- Repository Name: `Auvorata`
- Marque "Clone a Repository"
- **Create**

---

## ETAPA 4 — Primeiro deploy

cPanel → Git Version Control → **Manage** → aba **"Pull or Deploy"**:
1. **Update from Remote**
2. **Deploy HEAD Commit**

Abra https://auvorata.com.br

---

## ETAPA 5 — Ativar HTTPS

cPanel → **"SSL/TLS Status"** → marque os domínios → **"Run AutoSSL"**.

---

## ⚡ Dia-a-dia

**Editar:** abra `C:\Sites\auvorata\` no VS Code, edite os arquivos.
**Testar:** duplo clique em `preview.bat`.
**Publicar:** duplo clique em `deploy.bat` → descreva a mudança → no cPanel: Update from Remote + Deploy HEAD Commit.

---

## 🔥 Bônus: Deploy automático via webhook

**No cPanel:** Git Version Control → Manage → **Basic Information** → copie a **Webhook URL**.

**No GitHub:** Settings → Webhooks → **Add webhook**:
- Payload URL: cole a URL do cPanel
- Content type: `application/json`
- **Add webhook**

Daí em diante, `deploy.bat` publica direto sem você tocar no cPanel.

---

## ❓ Erros comuns

- **"git: command not found"** → reinstale Git for Windows marcando "Add Git to PATH"
- **"Permission denied (publickey)"** → SSH não configurado, refaça Etapa 1
- **cPanel "Failed to clone"** → Deploy Key faltando ou errada, refaça 3.1 e 3.2
- **Site em branco** → arquivos no caminho errado. No File Manager veja se `index.html` está direto em `/home/rogerfra/auvorata.com.br/`
- **Mudou e não atualizou** → cache (Ctrl+F5) ou faltou Deploy HEAD Commit no cPanel
