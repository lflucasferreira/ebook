#!/bin/bash
# ============================================================
# SCRIPT DE COMPILAÇÃO DO LIVRO
# Requer: pandoc (https://pandoc.org/installing.html)
# Para PDF também requer: TinyTeX ou MiKTeX (LaTeX)
#   Instalar TinyTeX: Rscript -e "tinytex::install_tinytex()"
# Saída: pasta dist/ (PDF, HTML, EPUB gerados localmente)
# ============================================================

set -euo pipefail

TITULO="back-to-feedback"
CAPITULOS="00-prefacio.md 01-capitulo.md 02-capitulo.md 99-conclusao.md 100-referencias.md"
SAIDA_DIR="dist"

erro() {
    echo "❌ $1" >&2
    exit 1
}

verificar_dependencia() {
    if ! command -v "$1" >/dev/null 2>&1; then
        erro "'$1' não encontrado. $2"
    fi
}

configurar_latex() {
    if command -v xelatex >/dev/null 2>&1; then
        return 0
    fi

    local candidatos=(
        "${LOCALAPPDATA}/Programs/MiKTeX/miktex/bin/x64"
        "/c/Program Files/MiKTeX/miktex/bin/x64"
        "$HOME/AppData/Local/Programs/MiKTeX/miktex/bin/x64"
    )

    for dir in "${candidatos[@]}"; do
        if [[ -x "${dir}/xelatex.exe" || -x "${dir}/xelatex" ]]; then
            export PATH="${dir}:${PATH}"
            export MIKTEX_ENABLE_INSTALLER=1
            return 0
        fi
    done

    return 1
}

gerar() {
    local descricao="$1"
    local arquivo="$2"
    shift 2

    echo "→ Gerando ${descricao}..."
    if "$@"; then
        if [[ -f "$arquivo" ]]; then
            echo "   ✅ ${arquivo} gerado"
            GERADOS+=("$arquivo")
        else
            erro "Falha ao gerar ${descricao}: ${arquivo} não foi criado."
        fi
    else
        erro "Falha ao gerar ${descricao}."
    fi
}

preparar_saida() {
    mkdir -p "$SAIDA_DIR"
    cp estilo.css "${SAIDA_DIR}/estilo.css"
    if [[ -d assets ]]; then
        cp -r assets "${SAIDA_DIR}/assets"
    fi
}

GERADOS=()

echo "📚 Compilando o livro..."

verificar_dependencia pandoc "Instale em https://pandoc.org/installing.html"

for capitulo in $CAPITULOS; do
    if [[ ! -f "$capitulo" ]]; then
        erro "Capítulo não encontrado: ${capitulo}"
    fi
done

if [[ ! -f metadata.yaml ]]; then
    erro "Arquivo metadata.yaml não encontrado."
fi

CAPA="assets/capa.png"

preparar_saida

PDF="${SAIDA_DIR}/${TITULO}.pdf"
HTML="${SAIDA_DIR}/${TITULO}.html"
EPUB="${SAIDA_DIR}/${TITULO}.epub"

# ── PDF ──────────────────────────────────────────────────────
if configurar_latex; then
    PDF_ARGS=(
        pandoc metadata.yaml $CAPITULOS
        --output="$PDF"
        --pdf-engine=xelatex
        --top-level-division=chapter
        --table-of-contents
        --toc-depth=2
        --syntax-highlighting=tango
    )
    if [[ -f "$CAPA" ]]; then
        PDF_ARGS+=(--include-in-header=capa-pdf.tex)
    else
        echo "⚠️  Capa não encontrada (${CAPA}); PDF será gerado sem imagem de capa."
    fi
    gerar "PDF" "$PDF" "${PDF_ARGS[@]}"
else
    echo "⚠️  Pulando PDF: 'xelatex' não encontrado."
    echo "   Instale MiKTeX (winget install MiKTeX.MiKTeX) ou TinyTeX para gerar PDF."
fi

# ── HTML (para publicar online ou visualizar no browser) ─────
gerar "HTML" "$HTML" \
    pandoc metadata.yaml $CAPITULOS \
    --output="$HTML" \
    --standalone \
    --css=estilo.css \
    --table-of-contents \
    --toc-depth=2 \
    --syntax-highlighting=tango \
    --metadata title="Back to Feedback"

# ── EPUB (para Kindle, Kobo, Google Play Books) ──────────────
gerar "EPUB" "$EPUB" \
    pandoc metadata.yaml $CAPITULOS \
    --output="$EPUB" \
    --css=estilo.css \
    --table-of-contents \
    --toc-depth=2 \
    --split-level=1

echo ""
if ((${#GERADOS[@]} == 0)); then
    erro "Nenhum arquivo foi gerado."
fi

echo "🎉 Concluído! Arquivos em ${SAIDA_DIR}/:"
for arquivo in "${GERADOS[@]}"; do
    case "$arquivo" in
        *.pdf)  echo "   📄 ${arquivo} → vender no Hotmart, Gumroad, etc." ;;
        *.html) echo "   🌐 ${arquivo} → publicar online (GitHub Pages, etc.)" ;;
        *.epub) echo "   📱 ${arquivo} → Kindle (Amazon KDP), Kobo, etc." ;;
        *)      echo "   📦 ${arquivo}" ;;
    esac
done
