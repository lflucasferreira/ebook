#!/bin/bash
# ============================================================
# SCRIPT DE COMPILAÇÃO DO LIVRO
# Requer: pandoc (https://pandoc.org/installing.html)
# Para PDF também requer: TinyTeX ou MiKTeX (LaTeX)
#   Instalar TinyTeX: Rscript -e "tinytex::install_tinytex()"
# ============================================================

TITULO="back-to-feedback"
CAPITULOS="00-prefacio.md 01-capitulo.md 02-capitulo.md 99-conclusao.md"

echo "📚 Compilando o livro..."

# ── PDF ──────────────────────────────────────────────────────
echo "→ Gerando PDF..."
pandoc metadata.yaml $CAPITULOS \
  --output="${TITULO}.pdf" \
  --pdf-engine=xelatex \
  --table-of-contents \
  --toc-depth=2 \
  --number-sections \
  --highlight-style=tango
echo "   ✅ ${TITULO}.pdf gerado"

# ── HTML (para publicar online ou visualizar no browser) ─────
echo "→ Gerando HTML..."
pandoc metadata.yaml $CAPITULOS \
  --output="${TITULO}.html" \
  --standalone \
  --css=estilo.css \
  --table-of-contents \
  --toc-depth=2 \
  --number-sections \
  --highlight-style=tango \
  --metadata title="Back to Feedback"
echo "   ✅ ${TITULO}.html gerado"

# ── EPUB (para Kindle, Kobo, Google Play Books) ──────────────
echo "→ Gerando EPUB..."
pandoc metadata.yaml $CAPITULOS \
  --output="${TITULO}.epub" \
  --css=estilo.css \
  --table-of-contents \
  --toc-depth=2 \
  --number-sections \
  --epub-chapter-level=1
echo "   ✅ ${TITULO}.epub gerado"

echo ""
echo "🎉 Concluído! Arquivos gerados:"
echo "   📄 ${TITULO}.pdf  → vender no Hotmart, Gumroad, etc."
echo "   🌐 ${TITULO}.html → publicar online (GitHub Pages, etc.)"
echo "   📱 ${TITULO}.epub → Kindle (Amazon KDP), Kobo, etc."
