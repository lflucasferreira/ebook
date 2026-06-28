# Template de Livro Digital em Markdown

Estrutura pronta para escrever, compilar e publicar um livro digital
em PDF, HTML e EPUB usando **Pandoc**.

---

## Estrutura de arquivos

```
meu-livro/
├── metadata.yaml       # Título, autor, idioma, configurações visuais
├── 00-prefacio.md      # Prefácio e introdução
├── 01-capitulo.md      # Capítulo 1 (template completo com comentários)
├── 02-capitulo.md      # Capítulo 2 (estrutura simplificada)
├── 99-conclusao.md     # Conclusão e referências
├── estilo.css          # Visual para HTML e EPUB
├── compilar.sh         # Script que gera PDF + HTML + EPUB de uma vez
└── assets/
    └── capa.png        # Imagem de capa (adicione você mesmo)
```

---

## Como usar

### 1. Instale o Pandoc

Baixe em: https://pandoc.org/installing.html

### 2. Edite os arquivos

- Abra `metadata.yaml` e preencha título, autor e descrição
- Escreva seu conteúdo nos arquivos `.md` (um por capítulo)
- Para adicionar um novo capítulo, crie `03-capitulo.md`, `04-capitulo.md`, etc.
- Adicione o nome do arquivo novo na lista `CAPITULOS` dentro de `compilar.sh`

### 3. Compile o livro

No terminal, dentro da pasta `meu-livro/`:

```bash
bash compilar.sh
```

Isso gera três arquivos:
- `meu-livro.pdf`  — para vender (Hotmart, Gumroad, etc.)
- `meu-livro.html` — para publicar online (GitHub Pages, etc.)
- `meu-livro.epub` — para lojas de e-book (Amazon KDP, Kobo, etc.)

### 4. Para gerar apenas o PDF (sem LaTeX instalado)

Use o motor `wkhtmltopdf` como alternativa:

```bash
# Gera HTML primeiro, depois converte para PDF via wkhtmltopdf
pandoc metadata.yaml 00-prefacio.md 01-capitulo.md 02-capitulo.md 99-conclusao.md \
  --output=meu-livro.html \
  --standalone \
  --css=estilo.css \
  --toc

# Depois abra o HTML no Chrome e use Ctrl+P > Salvar como PDF
```

---

## Dicas de escrita

- **Um arquivo por capítulo** — facilita organizar, reordenar e versionar no Git
- **Nomeie com números** — `01-`, `02-` garante ordem correta na compilação
- **Escreva todos os dias** — mesmo 30 minutos já avançam muito um livro
- **Não edite enquanto escreve** — termine o capítulo antes de revisar
- **Versione no GitHub** — você terá histórico completo de mudanças

---

## Onde vender

| Plataforma    | Taxa     | Melhor para           |
|---------------|----------|-----------------------|
| Hotmart       | 9,9%     | Mercado brasileiro    |
| Gumroad       | 10%      | Mercado internacional |
| Amazon KDP    | 30–65%   | Kindle (EPUB)         |
| Leanpub       | 20%      | Livros técnicos       |
| Eduzz         | 9,9%     | Mercado brasileiro    |

---

## Sintaxe Markdown essencial

```markdown
# Título do capítulo (H1)
## Seção (H2)
### Subseção (H3)

**negrito**   *itálico*   `código inline`

> Blockquote (dica ou aviso)

- item de lista
- outro item

1. passo numerado
2. outro passo

[texto do link](https://url.com)
![alt da imagem](assets/imagem.png)
```
