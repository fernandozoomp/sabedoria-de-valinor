#!/bin/bash
# generate-images.sh — Gera imagens IA para um Content Pack
# Uso: ./generate-images.sh <path-to-content-pack>
#
# Requer: API key configurada para autoglm-generate-image
# As imagens são geradas em 1080x1920 (TikTok vertical)

set -euo pipefail

PACK_DIR="${1:?Uso: $0 <content-pack-path>}"
CENAS_FILE="$PACK_DIR/cenas.md"
IMG_DIR="$PACK_DIR/imagens"

if [ ! -f "$CENAS_FILE" ]; then
    echo "❌ Arquivo cenas.md não encontrado em $PACK_DIR"
    exit 1
fi

mkdir -p "$IMG_DIR"

echo "🎨 Gerando imagens para: $PACK_DIR"
echo "📁 Pasta de saída: $IMG_DIR"
echo ""

# Extrair prompts de cena do tipo CENA_IA
# Formato esperado no cenas.md:
# ## Cena N — Descrição (tempo)
# - **Tipo:** CENA_IA
# - **Prompt de imagem:** "prompt aqui"

SCENE_NUM=0
CURRENT_TYPE=""
CURRENT_PROMPT=""

while IFS= read -r line; do
    if [[ "$line" =~ ^##\ Cena\ ([0-9]+) ]]; then
        # Salvar cena anterior se existir
        if [ -n "$CURRENT_PROMPT" ] && [ "$CURRENT_TYPE" = "CENA_IA" ]; then
            printf -v SCENE_PAD "%02d" "$SCENE_NUM"
            OUTPUT="$IMG_DIR/cena-${SCENE_PAD}.png"
            echo "  📸 Cena $SCENE_PAD: $CURRENT_PROMPT"
            echo "     → $OUTPUT"
            # Aqui seria chamada à API de geração de imagem
            # Ex: generate-image --prompt "$CURRENT_PROMPT" --output "$OUTPUT" --width 1080 --height 1920
        fi
        SCENE_NUM="${BASH_REMATCH[1]}"
        CURRENT_TYPE=""
        CURRENT_PROMPT=""
    elif [[ "$line" =~ Prompt\ de\ imagem:\ *\"(.+)\" ]]; then
        CURRENT_PROMPT="${BASH_REMATCH[1]}"
    elif [[ "$line" =~ Tipo:\ CENA_IA ]]; then
        CURRENT_TYPE="CENA_IA"
    fi
done < "$CENAS_FILE"

# Salvar última cena
if [ -n "$CURRENT_PROMPT" ] && [ "$CURRENT_TYPE" = "CENA_IA" ]; then
    printf -v SCENE_PAD "%02d" "$SCENE_NUM"
    OUTPUT="$IMG_DIR/cena-${SCENE_PAD}.png"
    echo "  📸 Cena $SCENE_PAD: $CURRENT_PROMPT"
    echo "     → $OUTPUT"
fi

echo ""
echo "✅ Processamento concluído. Verifique $IMG_DIR"
