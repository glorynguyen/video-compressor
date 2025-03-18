#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Detect package manager (Homebrew or APT)
if command_exists brew; then
  PACKAGE_MANAGER="brew"
elif command_exists apt; then
  PACKAGE_MANAGER="apt"
else
  echo "No supported package manager found (Homebrew or APT). Exiting..."
  exit 1
fi

# Function to install a package
install_package() {
  PACKAGE=$1
  if [ "$PACKAGE_MANAGER" = "brew" ]; then
    brew list "$PACKAGE" &>/dev/null || brew install "$PACKAGE"
  elif [ "$PACKAGE_MANAGER" = "apt" ]; then
    dpkg -s "$PACKAGE" &>/dev/null || (sudo apt update && sudo apt install -y "$PACKAGE")
  fi
}

# Ensure ffmpeg and zenity are installed
install_package ffmpeg
install_package zenity

# Open a file selection dialog to choose a video file
INPUT_FILE=$(zenity --file-selection --title="Select a Video File to Compress")

# Exit if no file is selected
if [ -z "$INPUT_FILE" ]; then
  echo "No file selected. Exiting..."
  exit 1
fi

# Get the directory and filename of the selected file
DIR=$(dirname "$INPUT_FILE")
BASENAME=$(basename "$INPUT_FILE")
FILENAME="${BASENAME%.*}"

# Define the output file path
OUTPUT_FILE="$DIR/${FILENAME}_compressed.mov"

# If the output file already exists, remove it
if [ -f "$OUTPUT_FILE" ]; then
  rm "$OUTPUT_FILE"
fi

zenity --progress --text="Compression in progress..." --title="Processing Video" --no-cancel &
ZENITY_PID=$!
# Run the FFmpeg command to compress the video
ffmpeg -i "$INPUT_FILE" -vcodec libx264 -crf 28 -preset fast -acodec aac -b:a 128k "$OUTPUT_FILE"

kill $ZENITY_PID

# Notify the user when the process is complete
if [ $? -eq 0 ]; then
  open "$DIR"  # On macOS
  zenity --info --text="Compression completed successfully!\nOutput File: $OUTPUT_FILE"
else
  zenity --error --text="Compression failed. Please check the input file and try again."
fi