# Changelog — Auvorata

Hist&oacute;rico de altera&ccedil;&otilde;es do site auvorata.com.br.

Formato: cada vers&atilde;o documenta **o qu&ecirc;** mudou, **por qu&ecirc;** mudou, e o que foi adicionado/removido/alterado.

---

## [0.3.0] — 2026-05-19 — Landing clean (paleta clara)

### Mudou
- **Paleta invertida**: fundo creme warm (`#f4efe6`) no lugar do preto profundo
- **Logo escurecido** via filtro CSS (`invert + hue-rotate + multiply`) para combinar com fundo claro mantendo a tonalidade dourada
- **Dourado velho** (`#8a6e2f`) como cor de destaque, no lugar do dourado bright
- **Tipografia de contato** agora em Inter uppercase com letter-spacing maior
- **Sublinhado decorativo** acima do bloco de contato (linha curta dourada)
- **Textura sutil de papel** via radial-gradients no body (quase invis&iacute;vel, d&aacute; profundidade)
- **Anima&ccedil;&otilde;es mais lentas** (1.8s em vez de 1.6s) para sensa&ccedil;&atilde;o mais contemplativa

### Por qu&ecirc;
Roger pediu uma vers&atilde;o "mais clean". Paleta escura passa peso e dramaticidade; paleta clara passa leveza, galeria de arte, papelaria fina. Mais arejada visualmente e mais moderna.

### Arquivos afetados
- `index.html` — limpeza do glow (removido), font Inter adicionada
- `style.css` — reescrita completa com vari&aacute;veis CSS de paleta clara

---

## [0.2.0] — 2026-05-19 — Landing minimalista (preto + dourado)

### Mudou
- **Estrutura simplificada para uma tela s&oacute;** (sem scroll, sem se&ccedil;&otilde;es)
- **Removido todo o conte&uacute;do editorial** (manifesto, cole&ccedil;&otilde;es, atelier, contato em cards)
- **Mantido apenas**: logo + tagline + contato discreto no rodap&eacute;
- **Brilho dourado pulsante** atr&aacute;s do logo (radial gradient com anima&ccedil;&atilde;o `breathe`)

### Por qu&ecirc;
A vers&atilde;o "maison editorial" (v0.1.x) ficou pesada e pretendia ter cole&ccedil;&otilde;es de produto que ainda n&atilde;o existem. Roger pediu algo mais clean, sem for&ccedil;ar conte&uacute;do que n&atilde;o existe.

### Arquivos afetados
- `index.html` — reduzido de ~270 linhas para 26
- `style.css` — reduzido para o essencial
- `script.js` — n&atilde;o necess&aacute;rio mais (mas mantido)
- SVGs de pe&ccedil;as (`atelier.svg`, `hero-piece.svg`, `piece-*.svg`) — n&atilde;o usados mais

---

## [0.1.0] — 2026-05-19 — Vers&atilde;o inicial (Maison editorial)

### Criado
- **Estrutura tipo Bvlgari/Boucheron**: header fixo, hero em grid, manifesto editorial, 3 cole&ccedil;&otilde;es, atelier, contato em cards
- **SVGs de "fotografias" de produto** renderizados em close macro (Solene/Aurum/Origem)
- **Tipografia mista**: Cormorant Garamond (display) + Inter (UI)
- **Numera&ccedil;&atilde;o romana** das se&ccedil;&otilde;es
- **C&oacute;digos de pe&ccedil;a** ("N&deg; 001") estilo joalheria de luxo
- **Paleta**: preto profundo `#0a0807` + dourado `#d4af5f`

### Infraestrutura adicionada
- `.htaccess` — for&ccedil;a HTTPS, configura cache, headers de seguran&ccedil;a
- `robots.txt` + `sitemap.xml` — SEO b&aacute;sico
- `.gitignore` — ignora SO, editores, credenciais
- `README.md` + `SETUP.md` — documenta&ccedil;&atilde;o inicial
- Scripts `.bat`: `primeiro-setup.bat`, `deploy.bat`, `preview.bat`

---

## Ferramentas de publica&ccedil;&atilde;o

### `PUBLICAR.bat` (atual, recomendado)
Script &uacute;nico que: limpa locks, faz commit, faz push pro GitHub, com janela self-relaunch em `cmd /k` que NUNCA fecha sozinha mesmo em erro. Substitui os scripts antigos.

### Scripts legados (ser&atilde;o removidos)
- `primeiro-setup.bat` — usado uma vez para configurar SSH, agora dispens&aacute;vel
- `deploy.bat` — vers&atilde;o anterior do PUBLICAR.bat
- `preview.bat` — mantido (abre o site localmente para testar)
- `SETUP.md` — substitu&iacute;do por este CHANGELOG.md + README.md atualizado

---

## Roadmap (pr&oacute;ximos passos)

- [ ] **Integra&ccedil;&atilde;o com cPanel API** no PUBLICAR.bat — eliminar a etapa manual de "Update from Remote" no cPanel
- [ ] **Conex&atilde;o do reposit&oacute;rio** no Git Version Control do cPanel (pasta `/home/rogerfra/auvorata.com.br`)
- [ ] **SSL/HTTPS** via AutoSSL no cPanel
- [ ] **WhatsApp** adicionar contato direto quando Roger definir o n&uacute;mero
- [ ] **Quando posicionamento da marca fechar**: expandir landing com se&ccedil;&otilde;es de cole&ccedil;&atilde;o, sobre, etc.
