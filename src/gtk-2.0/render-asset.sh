#!/usr/bin/env bash
set -ueo pipefail

# Set the timeout duration (in seconds)
TIMEOUT_DURATION=2

FORCE_INKSCAPE="$(echo "${FORCE_INKSCAPE-False}" | tr '[:upper:]' '[:lower:]')"
if [[ "${FORCE_INKSCAPE}" == "true" ]]; then
  RENDER_SVG=""
else
  RENDER_SVG="$(command -v rendersvg)" || true
fi
INKSCAPE="$(command -v inkscape)" || true
OPTIPNG="$(command -v optipng)" || true

if [[ -n "${INKSCAPE}" ]]; then
  if "$INKSCAPE" --help | grep -e "--export-filename" >/dev/null; then
    EXPORT_FILE_OPTION="--export-filename"
  elif "$INKSCAPE" --help | grep -e "--export-file" >/dev/null; then
    EXPORT_FILE_OPTION="--export-file"
  elif "$INKSCAPE" --help | grep -e "--export-png" >/dev/null; then
    EXPORT_FILE_OPTION="--export-png"
  fi
fi

if [[ "$1" == "dark" ]]; then
  SRC_FILE="assets-dark.svg"
  ASSETS_DIR="assets-dark"
else
  SRC_FILE="assets.svg"
  ASSETS_DIR="assets"
fi

i="$2"

# @TODO: remove $ZOOM when it will be fixed/implemented in resvg
GTK2_HIDPI="$(echo "${GTK2_HIDPI-False}" | tr '[:upper:]' '[:lower:]')"
if [[ "${GTK2_HIDPI}" == "true" ]]; then
  DPI=192
  ZOOM=2
else
  DPI=96
  ZOOM=1
fi

echo "Rendering '$ASSETS_DIR/$i.png'"

if [[ -n "${RENDER_SVG}" ]]; then
  # Use timeout for RENDER_SVG
  timeout "$TIMEOUT_DURATION" "$RENDER_SVG" --export-id "$i" \
    --dpi ${DPI} \
    --zoom ${ZOOM} \
    "$SRC_FILE" "$ASSETS_DIR/$i.png"
else
  # Use timeout for Inkscape
  timeout "$TIMEOUT_DURATION" "$INKSCAPE" --export-id="$i" \
    --export-id-only \
    --export-dpi=${DPI} \
    "$EXPORT_FILE_OPTION=$ASSETS_DIR/$i.png" "$SRC_FILE" >/dev/null
fi

# Optimize PNGs if optipng is available
if [[ -n "${OPTIPNG}" ]]; then
  timeout "$TIMEOUT_DURATION" "$OPTIPNG" -o7 --quiet "$ASSETS_DIR/$i.png"
fi
