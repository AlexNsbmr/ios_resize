#!/bin/bash

SRC_FILE_SQUARE="$1"
SRC_FILE_RECTANGLE="$2"

# Check parameters
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_file_1024x1024> <source_file_1024x768>"
    exit 1
fi

# Check if source files exist
if [ ! -f "$SRC_FILE_SQUARE" ] || [ ! -f "$SRC_FILE_RECTANGLE" ]; then
    echo "Error: Source files do not exist"
    exit 1
fi

# Temporary directory for intermediate images
TMP_DIR="temp_images"
mkdir -p "$TMP_DIR"

# Function to generate images for square icons
generate_square_image() {
    local size=$1
    local name=$2
    local scale=$3
    local width=$(echo $size | cut -dx -f1)
    local height=$(echo $size | cut -dx -f2)

    convert "$SRC_FILE_SQUARE" -resize "${width}x${height}" "${name}${size}${scale}.png"
}

# Function to generate images for rectangular icons
generate_rectangle_image() {
    local resize_height=$2
    local width=$1
    local name=$3
    local scale=$4
    local filename="${name}${width}x${resize_height}${scale}.png"

   # Resize step
    convert "$SRC_FILE_RECTANGLE" -resize "${width}x${resize_height}!" "$TMP_DIR/temp.png"

    # Crop step
    local crop_size="${width}x${resize_height}"
    convert "$TMP_DIR/temp.png" -gravity Center -crop "${crop_size}+0+0" "$filename"
}

# Generate square images
generate_square_image "29x29" "iPhone-Settings-" "@2x"
generate_square_image "87x87" "iPhone-Settings-" "@3x"
generate_square_image "58x58" "iPad-Settings-" "@2x"
generate_square_image "58x58" "App-Store-iOS-" "@1x"
generate_square_image "1024x1024" "App-Store-" "@1x"

# Generate rectangular images
generate_rectangle_image 120 90 "Messages-iPhone-" "@2x"
generate_rectangle_image 180 135 "Messages-iPhone-" "@3x"
generate_rectangle_image 134 100 "Messages-iPad-" "@2x"
generate_rectangle_image 148 110 "Messages-iPad-Pro-" "@2x"
generate_rectangle_image 180 135 "Messages-iPhone-" "@3x"
generate_rectangle_image 54 40 "App-Store-" "@2x"
generate_rectangle_image 81 60 "App-Store-" "@3x"
generate_rectangle_image 64 48 "App-Store-" "@2x"
generate_rectangle_image 96 72 "App-Store-" "@3x"
generate_rectangle_image 1024 768 "App-Store-" "@1x"

# Cleanup temporary files
rm -rf "$TMP_DIR"

echo "All icons have been generated successfully!"
