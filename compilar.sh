#!/bin/bash
# ============================================================
# SCRIPT DE COMPILAÇÃO DO LIVRO
# Requer: pandoc (https://pandoc.org/installing.html)
# Para PDF também requer: TinyTeX ou MiKTeX (LaTeX)
# Saída: pasta dist/
# ============================================================

set -euo pipefail

TITULO="back-to-feedback"
SAIDA_DIR="dist"

# Apenas o conteúdo PRONTO entra no build.
# (A Abertura foi fundida em parte-0-forcas.md — forcas-capitulo.md não é mais usado.)
CAPITULOS="00-prefacio.md 00b-introducao.md \
parte-0-forcas.md \
parte-1-comportamento.md 01-capitulo.md 02-capitulo.md \
parte-5-acao.md acao-plano.md acao-guia.md \
99-conclusao.md apendices.md 100-referencias.md"

# ── Rascunhos desabilitados temporariamente (capítulos 3 a 20) ──────────────
# Para REABILITAR: recoloque os trechos abaixo dentro de CAPITULOS, logo depois
# de "02-capitulo.md", mantendo a ordem original. As partes 2/3/4 saíram junto
# porque ficariam como capas vazias sem os seus capítulos.
#
#   03-capitulo.md 04-capitulo.md 05-capitulo.md 06-capitulo.md \
#   parte-2-processo-tecnico.md 07-capitulo.md 08-capitulo.md 09-capitulo.md 10-capitulo.md \
#   parte-3-colaboracao.md 11-capitulo.md 12-capitulo.md 13-capitulo.md 14-capitulo.md \
#   parte-4-carreira.md 15-capitulo.md 16-capitulo.md 17-capitulo.md 18-capitulo.md 19-capitulo.md 20-capitulo.md \
# ────────────────────────────────────────────────────────────────────────────

FILTROS=(--lua-filter=capitulo.lua --lua-filter=parte.lua --lua-filter=apendice.lua)

mkdir -p "$SAIDA_DIR"
cp estilo.css "${SAIDA_DIR}/estilo.css"
[[ -d assets ]] && cp -r assets "${SAIDA_DIR}/assets"

echo "📚 Compilando o livro..."

# ── PDF ──────────────────────────────────────────────────────
echo "→ Gerando PDF..."
if pandoc metadata.yaml $CAPITULOS \
  --output="${SAIDA_DIR}/${TITULO}.pdf" \
  --pdf-engine=xelatex \
  --include-in-header=capa-pdf.tex \
  --top-level-division=chapter \
  --table-of-contents \
  --toc-depth=2 \
  --highlight-style=tango \
  "${FILTROS[@]}"; then
  echo "   ✅ ${SAIDA_DIR}/${TITULO}.pdf gerado"
else
  echo "   ❌ Falha ao gerar PDF." >&2
  exit 1
fi

# ── HTML ─────────────────────────────────────────────────────
echo "→ Gerando HTML..."
pandoc metadata.yaml $CAPITULOS \
  --output="${SAIDA_DIR}/${TITULO}.html" \
  --standalone \
  --css=estilo.css \
  --table-of-contents \
  --toc-depth=2 \
  --highlight-style=tango \
  --metadata title="Back to Feedback" \
  "${FILTROS[@]}"
echo "   ✅ ${SAIDA_DIR}/${TITULO}.html gerado"

# ── EPUB ─────────────────────────────────────────────────────
echo "→ Gerando EPUB..."
pandoc metadata.yaml $CAPITULOS \
  --output="${SAIDA_DIR}/${TITULO}.epub" \
  --css=estilo.css \
  --table-of-contents \
  --toc-depth=2 \
  --epub-chapter-level=1 \
  "${FILTROS[@]}"
echo "   ✅ ${SAIDA_DIR}/${TITULO}.epub gerado"

echo ""
echo "🎉 Concluído! Arquivos em ${SAIDA_DIR}/"
