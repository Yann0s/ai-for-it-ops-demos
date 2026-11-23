#!/usr/bin/env bash
# Compose une video 16:9 (1920x1080, format YouTube standard) depuis un dossier de frames VNC + une spec JSON.
#   ./make_video.sh <spec.json> <frames_dir> <out.mp4> [speed]
# speed : facteur de compression temporelle (0.42 = ~100 s -> ~42 s)
set -euo pipefail
SPEC="${1:?spec.json}"
FRAMES="${2:?frames_dir}"
OUT="${3:?output.mp4}"
SPEED="${4:-0.42}"
COMPOSE_DIR="$(dirname "$OUT")/compose_$(basename "${OUT%.mp4}")"
PY="${PY:-$HOME/.hermes/cache/scratch/vmrec-venv/bin/python}"

mkdir -p "$COMPOSE_DIR"
"$PY" "$(dirname "$0")/compose_wide.py" "$SPEC" "$FRAMES" "$COMPOSE_DIR"

ffmpeg -y -framerate 2 -i "$COMPOSE_DIR/f_%04d.png" \
  -vf "setpts=${SPEED}*PTS,fps=30" \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -movflags +faststart \
  "$OUT"

echo "OK -> $OUT"
ffprobe -v error -show_entries format=duration,size \
  -show_entries stream=width,height -of default=noprint_wrappers=1 "$OUT"
