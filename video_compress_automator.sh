#!/bin/bash
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

# 1. Verify FFmpeg is installed via Homebrew
if ! command -v ffmpeg &>/dev/null; then
  osascript -e 'display dialog "FFmpeg not found. Please install it via Homebrew first." buttons {"OK"} default button "OK" with icon stop'
  exit 1
fi

# 2. Check if files were passed from Finder; if not, prompt user to select one
if [ "$#" -eq 0 ]; then
  CHOSEN_FILE=$(osascript -e 'POSIX path of (choose file with prompt "Select a file to process:")' 2>/dev/null)
  if [ -z "$CHOSEN_FILE" ] || [ "$CHOSEN_FILE" = "false" ]; then
    exit 0
  fi
  set -- "$CHOSEN_FILE"
fi

# 3. Display the native macOS Action Menu
ACTION=$(osascript -e 'choose from list {"Compress Video", "Convert Video to GIF", "Convert Images to WebP"} with title "Video & Image Tool" default items {"Compress Video"}' 2>/dev/null)

# Exit if the user cancels the menu
if [ "$ACTION" = "false" ] || [ -z "$ACTION" ]; then
  exit 0
fi

TOTAL_FILES=$#
PROCESSED_COUNT=0

# Supported file extensions
VIDEO_EXTENSIONS="mp4|mov|avi|mkv|wmv|flv|webm|m4v|mpg|mpeg|3gp"
IMAGE_EXTENSIONS="png|jpg|jpeg|tiff|tif|bmp|heic|heif"

# 4. Process files based on selected action
if [ "$ACTION" = "Compress Video" ]; then
  SKIPPED_COUNT=0
  for FILE in "$@"; do
    if [ -f "$FILE" ]; then
      EXT="${FILE##*.}"
      EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
      if ! echo "$EXT_LOWER" | grep -qE "^($VIDEO_EXTENSIONS)$"; then
        ((SKIPPED_COUNT++))
        continue
      fi
      DIR=$(dirname "$FILE")
      BASENAME=$(basename "$FILE")
      FILENAME="${BASENAME%.*}"
      OUTPUT_FILE="$DIR/${FILENAME}_compressed.mp4"

      ffmpeg -i "$FILE" -vcodec libx264 -crf 28 -preset fast -acodec aac -b:a 128k "$OUTPUT_FILE" -y

      if [ $? -eq 0 ]; then ((PROCESSED_COUNT++)); fi
    fi
  done
  NOTIFY_MSG="Successfully compressed $PROCESSED_COUNT of $TOTAL_FILES video(s)."
  if [ $SKIPPED_COUNT -gt 0 ]; then NOTIFY_MSG="$NOTIFY_MSG Skipped $SKIPPED_COUNT non-video file(s)."; fi
  osascript -e "display notification \"$NOTIFY_MSG\" with title \"Video Tool\""

elif [ "$ACTION" = "Convert Video to GIF" ]; then
  SKIPPED_COUNT=0
  for FILE in "$@"; do
    if [ -f "$FILE" ]; then
      EXT="${FILE##*.}"
      EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
      if ! echo "$EXT_LOWER" | grep -qE "^($VIDEO_EXTENSIONS)$"; then
        ((SKIPPED_COUNT++))
        continue
      fi
      DIR=$(dirname "$FILE")
      BASENAME=$(basename "$FILE")
      FILENAME="${BASENAME%.*}"
      OUTPUT_FILE="$DIR/${FILENAME}.gif"

      ffmpeg -i "$FILE" -vf "fps=10,scale=1000:-1:flags=lanczos" -c:v gif "$OUTPUT_FILE" -y

      if [ $? -eq 0 ]; then ((PROCESSED_COUNT++)); fi
    fi
  done
  NOTIFY_MSG="Successfully converted $PROCESSED_COUNT of $TOTAL_FILES video(s) to GIF."
  if [ $SKIPPED_COUNT -gt 0 ]; then NOTIFY_MSG="$NOTIFY_MSG Skipped $SKIPPED_COUNT non-video file(s)."; fi
  osascript -e "display notification \"$NOTIFY_MSG\" with title \"Video Tool\""

elif [ "$ACTION" = "Convert Images to WebP" ]; then
  SKIPPED_COUNT=0
  for FILE in "$@"; do
    if [ -f "$FILE" ]; then
      EXT="${FILE##*.}"
      EXT_LOWER=$(echo "$EXT" | tr '[:upper:]' '[:lower:]')
      if ! echo "$EXT_LOWER" | grep -qE "^($IMAGE_EXTENSIONS)$"; then
        ((SKIPPED_COUNT++))
        continue
      fi
      DIR=$(dirname "$FILE")
      BASENAME=$(basename "$FILE")
      FILENAME="${BASENAME%.*}"
      OUTPUT_FILE="$DIR/${FILENAME}.webp"

      ffmpeg -i "$FILE" -c:v libwebp -quality 85 "$OUTPUT_FILE" -y 2>/dev/null

      if [ $? -eq 0 ]; then ((PROCESSED_COUNT++)); fi
    fi
  done
  NOTIFY_MSG="Successfully converted $PROCESSED_COUNT of $TOTAL_FILES image(s) to WebP."
  if [ $SKIPPED_COUNT -gt 0 ]; then NOTIFY_MSG="$NOTIFY_MSG Skipped $SKIPPED_COUNT non-image file(s)."; fi
  osascript -e "display notification \"$NOTIFY_MSG\" with title \"Video Tool\""
fi
