#!/bin/bash
# Pipeline: OpenSCAD -> STL + PNG preview -> PrusaSlicer G-code
# Usage: ./render.sh path/to/model.scad

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROFILE="$SCRIPT_DIR/profiles/artillery-genius-pro.ini"
OCTOPRINT_UPLOADS="$HOME/homelab/octoprint/config/octoprint/uploads"
TAILSCALE_HOST="thevault"
NOTIFY_URL="http://127.0.0.1:9876/hook"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <file.scad>"
    exit 1
fi

SCAD_FILE="$1"

if [ ! -f "$SCAD_FILE" ]; then
    echo "Error: file not found: $SCAD_FILE"
    exit 1
fi

DIR="$(dirname "$SCAD_FILE")"
BASE="$(basename "$SCAD_FILE" .scad)"
STL_FILE="$DIR/$BASE.stl"
PNG_FILE="$DIR/$BASE.png"
GCODE_FILE="$DIR/$BASE.gcode"

echo "=== Rendering STL: $STL_FILE ==="
xvfb-run -a openscad -o "$STL_FILE" "$SCAD_FILE"

echo "=== Rendering PNG preview: $PNG_FILE ==="
xvfb-run -a openscad -o "$PNG_FILE" \
    --imgsize=1920,1080 \
    --projection=perspective \
    --colorscheme=DeepOcean \
    --autocenter \
    --viewall \
    --camera=0,0,0,55,0,25,0 \
    "$SCAD_FILE"

echo "=== Slicing G-code: $GCODE_FILE ==="
prusa-slicer --export-gcode \
    --load "$PROFILE" \
    --output "$GCODE_FILE" \
    "$STL_FILE"

echo "=== Copying G-code to OctoPrint ==="
cp "$GCODE_FILE" "$OCTOPRINT_UPLOADS/"
echo "Copied to: $OCTOPRINT_UPLOADS/$(basename "$GCODE_FILE")"

GALLERY_URL="http://$TAILSCALE_HOST/3d.html"
OCTOPRINT_URL="http://$TAILSCALE_HOST:5000"

echo ""
echo "=== Done ==="
echo "STL:   $STL_FILE"
echo "PNG:   $PNG_FILE"
echo "GCODE: $GCODE_FILE"
echo "OCTO:  $OCTOPRINT_UPLOADS/$(basename "$GCODE_FILE")"
echo ""
echo "Gallery: $GALLERY_URL"
echo "OctoPrint: $OCTOPRINT_URL"

# Notify via Telegram
curl -s -X POST "$NOTIFY_URL" \
    -H "Content-Type: application/json" \
    -d "{\"event_type\": \"Notification\", \"data\": {\"reason\": \"[3d-design] Render complete: $BASE\nGallery: $GALLERY_URL\nOctoPrint: $OCTOPRINT_URL\"}}" \
    >/dev/null 2>&1 || true
