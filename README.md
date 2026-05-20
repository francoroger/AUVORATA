# Auvorata

Site institucional da Auvorata — landing page minimalista.

- **Site:** [auvorata.com.br](https://auvorata.com.br)
- **Repositorio:** [github.com/francoroger/AUVORATA](https://github.com/francoroger/AUVORATA)
- **Versao atual:** 0.3.0 (landing clean, paleta clara) — ver [CHANGELOG.md](CHANGELOG.md)

---

## Como publicar uma mudanca

1. Edite `index.html`, `style.css` ou troque o logo em `images/`
2. Duplo clique em **`PUBLICAR.bat`**
3. Aperte ENTER quando perguntar a mensagem do commit (ou digite uma descricao)
4. Esperar terminar — abre o GitHub automaticamente no navegador

A primeira publicacao no cPanel exige um passo manual (Git Version Control > Manage > Update from Remote > Deploy HEAD Commit). Depois disso, a automacao da API esta no roadmap.

---

## Estrutura

```
auvorata-site/
├── index.html         # Pagina unica (logo + tagline + contato)
├── style.css          # Paleta clara, animacoes de entrada
├── images/
│   └── auvorata-logo.png    # Logo original (gold on black)
├── .htaccess          # HTTPS forcado + cache + headers de seguranca
├── robots.txt         # SEO
├── sitemap.xml        # SEO
├── PUBLICAR.bat       # Script de publicacao (commit + push)
├── preview.bat        # Abre o site no navegador para testar localmente
├── CHANGELOG.md       # Historico de versoes
└── README.md          # Este arquivo
```

---

## Editando

| Quero mudar | Onde mexer |
|---|---|
| Texto da tagline | `index.html`, linha com `<p class="tagline">` |
| Email de contato | `index.html`, linha com `mailto:` |
| Instagram | `index.html`, linha com `instagram.com/auvorata