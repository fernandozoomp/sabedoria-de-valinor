#!/bin/bash
# compose-video.sh — Monta vídeo TikTok a partir de Content Pack
# Uso: ./compose-video.sh <path-to-content-pack> [--duration SECONDS]
#
# Requer: FFmpeg 6.0+
# Input: pasta com imagens/ + naracao.mp3 + trilha.mp3 (opcional)
# Output: video-final.mp4 (1080x1920, 30fps, H.264)

set -euo pipefail

PACK_DIR="${1:?Uso: $0 <content-pack-path>}"
DURATION="${2:-60}"
IMG_DIR="$PACK_DIR/imagens"
NARRATION="$PACK_DIR/narracao.mp3"
MUSIC="${PACK_DIR}/trilha.mp3:-}"
OUTPUT="$PACK_DIR/video-final.mp4"
TEMP_DIR=$(mktemp -d)
W=1080
H=1920
FPS=30

cleanup() {
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

echo "🎬 Compondo vídeo: $PACK_DIR"
echo "⏱  Duração alvo: ${DURATION}s"
echo ""

# 1. Verificar arquivos
if [ ! -d "$IMG_DIR" ] || [ -z "$(ls -A "$IMG_DIR"/*.png 2>/dev/null)" ]; then
    echo "❌ Nenhuma imagem encontrada em $IMG_DIR"
    exit 1
fi

if [ ! -f "$NARRATION" ]; then
    echo "❌ Narração não encontrada: $NARRATION"
    exit 1
fi

# 2. Obter duração real da narração
NARR_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$NARRATION" | cut -d. -f1)
echo "🎙  Narração: ${NARR_DUR}s"

# 3. Calcular duração por cena
IMAGES=($(ls "$IMG_DIR"/*.png | sort))
NUM_IMAGES=${#IMAGES[@]}
SECS_PER_CENA=$(( (NARR_DUR + NUM_IMAGES - 1) / NUM_IMAGES ))
echo "📸 ${NUM_IMAGES} imagens, ~${SECS_PER_CENA}s cada"

# 4. Gerar vídeo de cada cena com Ken Burns
for i in "${!IMAGES[@]}"; do
    printf -v PAD "%03d" "$i"
    OUTPUT_SEG="$TEMP_DIR/segment_${PAD}.mp4"
    
    # Ken Burns: zoom suave de 100% para 105%
    ffmpeg -y -loop 1 -i "${IMAGES[$i]}" -t "$SECS_PER_CENA" \
        -vf "scale=${W}:${H}:force_original_aspect_ratio=decrease,pad=${W}:${H}:(ow-iw)/2:(oh-ih)/2:color=#0D1117,zoompan=z='min(zoom+0.0008,1.05)':x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':d=$((SECS_PER_CENA * FPS)):s=${W}x${H},fps=${FPS}" \
        -c:v libx264 -pix_fmt yuv420p "$OUTPUT_SEG" 2>/dev/null
    
    echo "  ✅ Segmento $PAD: $(basename ${IMAGES[$i]}) → ${SECS_PER_CENA}s"
done

# 5. Concatenar segmentos
echo ""
echo "🔗 Concatenando segmentos..."
CONCAT_LIST="$TEMP_DIR/concat.txt"
for f in "$TEMP_DIR"/segment_*.mp4; do
    echo "file '$f'" >> "$CONCAT_LIST"
done
ffmpeg -y -f concat -safe 0 -i "$CONCAT_LIST" -c copy "$TEMP_DIR/video_no_audio.mp4" 2>/dev/null

# 6. Adicionar narração
echo "🎙  Mixando narração..."
ffmpeg -y -i "$TEMP_DIR/video_no_audio.mp4" -i "$NARRATION" \
    -c:v copy -c:a aac -b:a 192k \
    -shortest "$TEMP_DIR/video_with_narration.mp4" 2>/dev/null

# 7. Adicionar trilha sonora (se existir)
if [ -n "${MUSIC}" ] && [ -f "$MUSIC" ]; then
    echo "🎵 Mixando trilha sonora..."
    ffmpeg -y -i "$TEMP_DIR/video_with_narration.mp4" -i "$MUSIC" \
        -filter_complex "[1:a]volume=0.15[bg];[0:a][bg]amix=inputs=2:duration=shortest[aout]" \
        -map 0:v -map "[aout]" \
        -c:v copy -c:a aac -b:a 192k \
        -shortest "$OUTPUT" 2>/dev/null
else
    cp "$TEMP_DIR/video_with_narration.mp4" "$OUTPUT"
fi

# 8. Informações finais
FINAL_DUR=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$OUTPUT" | cut -d. -f1)
FINAL_SIZE=$(du -h "$OUTPUT" | cut -f1)

echo ""
echo "================================"
echo "✅ VÍDEO FINAL PRONTO"
echo "📁 $OUTPUT"
echo "⏱  ${FINAL_DUR}s"
echo "📐 ${W}x${H} @ ${FPS}fps"
echo "💾 ${FINAL_SIZE}"
echo "================================"
