#!/usr/bin/env bash
# Compose un short depuis un dossier de frames VNC + une spec JSON.
#   ./make_short.sh <spec.json> <frames_dir> <out.mp4> [speed]
# speed : facteur de compression temporelle (0.42 = ~100 s -> ~42 s)
set -euo pipefail

SPEC="${1:?spec.json}"
FRAMES="${2:?frames dir}"
OUT="${3:?output.mp4}"
SPEED="${4:-0.42}"

PY="${PY:-/home/hermes/.hermes/cache/scratch/vmrec-venv/bin/python}"
COMPOSE_DIR="$(mktemp -d)"
trap 'rm -rf "$COMPOSE_DIR"' EXIT

"$PY" "$(dirname "$0")/compose_short.py" "$SPEC" "$FRAMES" "$COMPOSE_DIR"

ffmpeg -y -framerate 2 -i "$COMPOSE_DIR/f_%04d.png" \
  -vf "setpts=${SPEED}*PTS,fps=30" \
  -c:v libx264 -preset medium -crf 20 -pix_fmt yuv420p -movflags +faststart \
  "$OUT"

echo "OK -> $OUT"
ffprobe -v error -show_entries format=duration,size \
  -show_entries stream=width,height -of default=noprint_wrappers=1 "$OUT"
