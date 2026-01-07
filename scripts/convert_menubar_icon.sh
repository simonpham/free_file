#!/bin/bash

# Script to convert SVG to macOS menu bar icon
# Generates 1x (18x18), 2x (36x36), and 3x (54x54) PNG files
# Example usage:
# ./scripts/convert_menubar_icon.sh "core_packages/core_ui/assets/icons/files and folder/solid/folder 03.svg" "apps/ff_desktop/macos/Runner/Assets.xcassets/MenuBarIcon.imageset" "MenuBarIcon"

set -e

# Input SVG file
INPUT_SVG="$1"

# Output directory (defaults to current directory)
OUTPUT_DIR="${2:-.}"

# Output base name
OUTPUT_NAME="${3:-menubar_icon}"

# Check if input file exists
if [ ! -f "$INPUT_SVG" ]; then
    echo "Error: Input file '$INPUT_SVG' not found"
    echo "Usage: $0 <input.svg> [output_dir] [output_name]"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Check for available SVG converter
if command -v rsvg-convert &> /dev/null; then
    CONVERTER="rsvg"
elif command -v convert &> /dev/null; then
    CONVERTER="imagemagick"
else
    echo "Error: No SVG converter found."
    echo "Please install one of the following:"
    echo "  - librsvg: brew install librsvg"
    echo "  - ImageMagick: brew install imagemagick"
    exit 1
fi

echo "Using $CONVERTER for conversion..."

# Generate icons at different sizes
# macOS menu bar icons: 18pt is standard, so we need 18, 36, 54 pixels
SIZES=("18" "36" "54")
SUFFIXES=("" "@2x" "@3x")

for i in "${!SIZES[@]}"; do
    SIZE="${SIZES[$i]}"
    SUFFIX="${SUFFIXES[$i]}"
    OUTPUT_FILE="$OUTPUT_DIR/${OUTPUT_NAME}${SUFFIX}.png"
    
    echo "Generating ${SIZE}x${SIZE} -> $OUTPUT_FILE"
    
    if [ "$CONVERTER" = "rsvg" ]; then
        rsvg-convert -w "$SIZE" -h "$SIZE" "$INPUT_SVG" -o "$OUTPUT_FILE"
    else
        convert -background none -resize "${SIZE}x${SIZE}" "$INPUT_SVG" "$OUTPUT_FILE"
    fi
done

echo ""
echo "Done! Generated files:"
ls -la "$OUTPUT_DIR"/${OUTPUT_NAME}*.png

echo ""
echo "Next steps:"
echo "1. Copy these PNG files to your Xcode Assets.xcassets"
echo "2. Create an Image Set named '$OUTPUT_NAME'"
echo "3. Drag the files to the appropriate 1x, 2x, 3x slots"
echo "4. Set 'Render As' to 'Template Image' in the Attributes Inspector"
