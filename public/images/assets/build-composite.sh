#!/usr/bin/env bash
#
# Regenerates the header background from its two source layers.
#
#   bg-pattern.jpg + bg-static.jpg  ->  bg-composite.png  ->  bg-composite.webp
#
# WHAT THIS REPRODUCES
#
# The site used to blend the two layers live, in CSS:
#
#   background-image: url(bg-pattern.jpg), url(bg-static.jpg);
#   background-blend-mode: difference;
#   background-size: cover, auto 232px;
#
# The pale dune minus the grey grain resolves to a dark warm maroon. Doing it
# at paint time had one flaw: the layers load independently, so whenever the
# grain arrived late the dune met the CSS brightness(2.15) with nothing to
# subtract from and clipped to white for a frame. This script performs the
# identical operation once, at build time, so there is only ever one image.
#
# WHY THE NUMBERS ARE WHAT THEY ARE  (changing them blindly will look wrong)
#
# The two layers are NOT sized the same way in CSS, so the composite has to
# reproduce each one's rendered scale:
#
#   dune   `cover`      -> width-driven, fills the element's width
#   grain  `auto 232px` -> pinned to a 232px-tall tile, repeated
#
# 232px is --band-h, the header band's height. A 1600x800 grain image scaled
# to 232px tall is 464x232, and that tile repeats across the element. So the
# grain is downscaled ~3.4x before it is ever differenced -- that averaging is
# what turns per-pixel noise into the smooth tone. Compositing the two images
# at 1:1 instead produces raw pixel noise the browser never showed, which
# looks nothing like the real thing.
#
# REF_W is the viewport width this is baked for. At that width the output is
# pixel-identical to the live blend; at other widths the browser scales the
# whole composite, so the grain scales with it rather than staying pinned.
#
# WHY PNG *AND* WEBP
#
# The .png is the lossless master. The .webp is what the site loads.
# Noise is the worst case for a DCT codec: a JPEG at this size destroys ~90%
# of the grain and leaves 8x8 blocks that CSS brightness(2.15) then amplifies.
# WebP does not block-quantise noise the same way, so q95 keeps the grain
# intact (measured below) at about a fifth of the PNG's size.
#
# Source images are only ever read, never modified.
#
# Requires: ImageMagick (magick) and cwebp (brew install imagemagick webp)

set -euo pipefail

cd "$(dirname "$0")"

PATTERN="bg-pattern.jpg"     # the dune photograph
STATIC="bg-static.jpg"       # the grain / noise layer
OUT_PNG="bg-composite.png"
OUT_WEBP="bg-composite.webp"

REF_W=1600                   # reference viewport width
REF_H=1200                   # REF_W * (dune aspect 2048:1536) = REF_W * 3/4
BAND_H=232                   # --band-h in style.css; the grain tile's height
WEBP_Q=95

for tool in magick cwebp; do
  command -v "$tool" >/dev/null || { echo "error: $tool not found" >&2; exit 1; }
done
for src in "$PATTERN" "$STATIC"; do
  [ -f "$src" ] || { echo "error: $src not found" >&2; exit 1; }
done

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

# The grain tile at its rendered size: the source scaled to BAND_H tall.
src_w="$(magick identify -format '%w' "$STATIC")"
src_h="$(magick identify -format '%h' "$STATIC")"
tile_w=$(( src_w * BAND_H / src_h ))

echo "compositing ${REF_W}x${REF_H}, grain tile ${tile_w}x${BAND_H} (from ${src_w}x${src_h})"

# 1. The dune at `cover` for a REF_W-wide element.
magick "$PATTERN" -resize "${REF_W}x${REF_H}!" "$tmp/dune.png"

# 2. The grain at `auto ${BAND_H}px`, then repeated to fill the frame.
magick "$STATIC" -resize "${tile_w}x${BAND_H}!" "$tmp/tile.png"
magick -size "${REF_W}x${REF_H}" "tile:$tmp/tile.png" "$tmp/grain.png"

# 3. difference blend, exactly as background-blend-mode does it.
magick "$tmp/dune.png" "$tmp/grain.png" -compose Difference -composite "$tmp/raw.png"

# 4. Lossless master, then the shipping WebP.
# -strip plus excluding the tIME chunk keeps repeat runs byte-identical;
# without them ImageMagick stamps each write with the current time.
magick "$tmp/raw.png" -strip \
  -define png:exclude-chunk=time,date \
  -define png:compression-level=9 -define png:compression-filter=5 "$OUT_PNG"
cwebp -quiet -q "$WEBP_Q" -m 6 "$OUT_PNG" -o "$OUT_WEBP"

# Verify: high-frequency grain amplitude (the thing a bad encode destroys),
# and how far the WebP drifts from the lossless master.
grain () {
  magick "$1" -colorspace Gray \( +clone -blur 0x0.8 \) \
    -compose Difference -composite -format '%[fx:standard_deviation*255]' info:
}
mb () { echo "scale=2; $(wc -c < "$1") / 1048576" | bc; }

printf '\n  %-20s %8s MB   grain %s\n' "$OUT_PNG"  "$(mb "$OUT_PNG")"  "$(grain "$OUT_PNG")"
printf '  %-20s %8s MB   grain %s   RMSE %s\n\n' "$OUT_WEBP" "$(mb "$OUT_WEBP")" "$(grain "$OUT_WEBP")" \
  "$(magick compare -metric RMSE "$OUT_PNG" "$OUT_WEBP" null: 2>&1 | sed 's/.*(\(.*\))/\1/')"

# For reference, the live CSS blend measures ~1.71 on the same grain metric.
# A healthy run lands near 1.67 for the PNG and 1.64 for the WebP. Anything
# under ~1.0 means the grain was resampled away and it will look like blobs.
echo "done. style.css loads $OUT_WEBP; keep $OUT_PNG as the master."
