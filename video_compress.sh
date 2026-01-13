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

# Show the initial menu with options
ACTION=$(zenity --list --title="Video Tool" --column="Action" "Compress Video" "Convert Video to GIF" "Convert Images to WebP" "Setup Alias" "Exit")

# Check the selected action
if [ "$ACTION" = "Exit" ]; then
  echo "Exiting..."
  exit 0
elif [ "$ACTION" = "Setup Alias" ]; then
  # Get the current script path
  SCRIPT_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
  
  # Prompt user for alias name
  ALIAS_NAME=$(zenity --entry --title="Setup Alias" --text="Enter the alias name you want to use (e.g., vtool, videotool):" --entry-text="vtool")
  
  # Exit if no alias name is provided
  if [ -z "$ALIAS_NAME" ]; then
    zenity --error --text="No alias name provided. Setup cancelled."
    exit 1
  fi
  
  # Validate alias name (alphanumeric and underscore only)
  if ! [[ "$ALIAS_NAME" =~ ^[a-zA-Z0-9_]+$ ]]; then
    zenity --error --text="Invalid alias name. Use only letters, numbers, and underscores."
    exit 1
  fi
  
  # Detect shell configuration file
  if [ -n "$ZSH_VERSION" ] || [ -f "$HOME/.zshrc" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
  elif [ -n "$BASH_VERSION" ] || [ -f "$HOME/.bashrc" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
  else
    SHELL_CONFIG="$HOME/.bash_profile"
  fi
  
  # Create alias command
  ALIAS_COMMAND="alias $ALIAS_NAME='$SCRIPT_PATH'"
  
  # Check if alias already exists
  if grep -q "alias $ALIAS_NAME=" "$SHELL_CONFIG" 2>/dev/null; then
    # Ask if user wants to replace existing alias
    zenity --question --title="Alias Already Exists" --text="An alias '$ALIAS_NAME' already exists in $SHELL_CONFIG.\n\nDo you want to replace it?"
    
    if [ $? -eq 0 ]; then
      # Remove old alias and add new one
      sed -i.bak "/alias $ALIAS_NAME=/d" "$SHELL_CONFIG"
      echo "$ALIAS_COMMAND" >> "$SHELL_CONFIG"
      zenity --info --text="Alias '$ALIAS_NAME' has been updated in $SHELL_CONFIG\n\nRun: source $SHELL_CONFIG\nOr restart your terminal to use it.\n\nUsage: $ALIAS_NAME"
    else
      zenity --info --text="Alias setup cancelled."
      exit 0
    fi
  else
    # Add new alias
    echo "$ALIAS_COMMAND" >> "$SHELL_CONFIG"
    zenity --info --text="Alias '$ALIAS_NAME' has been added to $SHELL_CONFIG\n\nRun: source $SHELL_CONFIG\nOr restart your terminal to use it.\n\nUsage: $ALIAS_NAME"
  fi
  
  exit 0
elif [ "$ACTION" = "Compress Video" ]; then
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

elif [ "$ACTION" = "Convert Video to GIF" ]; then
  # Open a file selection dialog to choose a video file
  INPUT_FILE=$(zenity --file-selection --title="Select a Video File to Convert to GIF")

  # Exit if no file is selected
  if [ -z "$INPUT_FILE" ]; then
    echo "No file selected. Exiting..."
    exit 1
  fi

  # Get the directory and filename of the selected file
  DIR=$(dirname "$INPUT_FILE")
  BASENAME=$(basename "$INPUT_FILE")
  FILENAME="${BASENAME%.*}"

  # Define the output file path for the GIF
  OUTPUT_FILE="$DIR/${FILENAME}.gif"

  # If the output file already exists, remove it
  if [ -f "$OUTPUT_FILE" ]; then
    rm "$OUTPUT_FILE"
  fi

  zenity --progress --text="Converting to GIF..." --title="Processing Video" --no-cancel &
  ZENITY_PID=$!
  # Run the FFmpeg command to convert the video to GIF
  ffmpeg -i "$INPUT_FILE" -vf "fps=10,scale=1000:-1:flags=lanczos" -c:v gif "$OUTPUT_FILE"

  kill $ZENITY_PID

  # Notify the user when the process is complete
  if [ $? -eq 0 ]; then
    open "$DIR"  # On macOS
    zenity --info --text="Conversion to GIF completed successfully!\nOutput File: $OUTPUT_FILE"
  else
    zenity --error --text="Conversion failed. Please check the input file and try again."
  fi

elif [ "$ACTION" = "Convert Images to WebP" ]; then
  # Open a file selection dialog to choose multiple image files
  INPUT_FILES=$(zenity --file-selection --multiple --separator="|" --title="Select Image Files to Convert to WebP" --file-filter="Image files (jpg,jpeg,png,gif,bmp) | *.jpg *.jpeg *.png *.gif *.bmp")

  # Exit if no files are selected
  if [ -z "$INPUT_FILES" ]; then
    echo "No files selected. Exiting..."
    exit 1
  fi

  # Split the input files by the pipe separator
  IFS='|' read -ra FILES <<< "$INPUT_FILES"
  TOTAL_FILES=${#FILES[@]}
  CONVERTED_COUNT=0
  FAILED_COUNT=0

  # Process each file
  for INPUT_FILE in "${FILES[@]}"; do
    # Get the directory and filename of the selected file
    DIR=$(dirname "$INPUT_FILE")
    BASENAME=$(basename "$INPUT_FILE")
    FILENAME="${BASENAME%.*}"

    # Define the output file path for WebP
    OUTPUT_FILE="$DIR/${FILENAME}.webp"

    # If the output file already exists, remove it
    if [ -f "$OUTPUT_FILE" ]; then
      rm "$OUTPUT_FILE"
    fi

    # Show progress
    PROGRESS=$((CONVERTED_COUNT * 100 / TOTAL_FILES))
    echo "$PROGRESS"
    echo "# Converting $BASENAME to WebP... ($((CONVERTED_COUNT + 1))/$TOTAL_FILES)"

    # Run the FFmpeg command to convert the image to WebP
    ffmpeg -i "$INPUT_FILE" -c:v libwebp -quality 85 "$OUTPUT_FILE" -y 2>/dev/null

    # Check if conversion was successful
    if [ $? -eq 0 ]; then
      ((CONVERTED_COUNT++))
    else
      ((FAILED_COUNT++))
    fi
  done | zenity --progress --title="Converting Images to WebP" --percentage=0 --auto-close

  # Get the directory of the first file to open
  FIRST_FILE="${FILES[0]}"
  FIRST_DIR=$(dirname "$FIRST_FILE")

  # Notify the user when all conversions are complete
  if [ $FAILED_COUNT -eq 0 ]; then
    open "$FIRST_DIR"  # On macOS
    zenity --info --text="All conversions completed successfully!\n$CONVERTED_COUNT file(s) converted to WebP."
  else
    open "$FIRST_DIR"  # On macOS
    zenity --warning --text="Conversion completed with some errors.\nSuccessful: $CONVERTED_COUNT\nFailed: $FAILED_COUNT"
  fi

else
  echo "Invalid selection. Exiting..."
  exit 1
fi