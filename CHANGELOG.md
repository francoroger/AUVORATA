# Changelog — Auvorata

Hist&oacute;rico de altera&ccedil;&otilde;es do site auvorata.com.br.

Formato: cada vers&atilde;o documenta **o qu&ecirc;** mudou, **por qu&ecirc;** mudou, e o que foi adicionado/removido/alterado.

---

## [0.4.0] — 2026-05-19 — Rollback para "em breve elegante" (v0.1.0)

### Voltou
- **Estrutura completa da v0.1.0**: hero com logo + tagline "em breve" + subline + formul&aacute;rio de captura de e-mail, 3 pilares (Ess&ecirc;ncia / Prop&oacute;sito / Presen&ccedil;a), rodap&eacute; com contato.
- **Paleta preto + dourado** novamente (`--bg: #0a0807`, `--gold: #d4af5f`)
- **Tipografia mista**: Cormorant Garamond (display) + Inter (UI)
- **Aurora dourada de fundo** pulsando lentamente (radial gradient com anima&ccedil;&atilde;o `breathe`)
- **`script.js` reintroduzido** com valida&ccedil;&atilde;o do formul&aacute;rio + ano din&acirc;mico

### Por qu&ecirc;
Roger viu a v0.3.0 (paleta clara) no ar e disse que ficou "horr&iacute;vel". Pediu pra voltar pra primeira vers&atilde;o de todas. Decis&atilde;o consciente de retornar pra estrutura mais completa (n&atilde;o s&oacute; logo + contato).

### Arquivos afetados
- `index.html` — reescrito com a estrutura completa (hero + form + pilares + footer)
- `style.css` — reescrito com paleta escura + aurora + estilos dos pilares + form pill
- `script.js` — recriado com valida&ccedil;&atilde;o de email + ano din&acirc;mico
- `.cpanel.yml` — atualizado pra deployer tamb&eacute;m o `script.js`
- `PUBLICAR.bat` — `script.js` removido da lista de arquivos obsoletos

### Pend&ecirc;ncia
- O formul&aacute;rio de email **n&atilde;o salva os endere&ccedil;os em lugar nenhum** ainda. Mostra mensagem de sucesso mas n&atilde;o envia pra ningu&eacute;m. Quando quiser ativar de verdade, integrar com Formspree, Mailchimp ou similar (instru&ccedil;&otilde;es em coment&aacute;rio dentro do `script.js`).

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
- **Numera&ccedil;&atilde;