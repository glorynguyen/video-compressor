#!/bin/bash
VERSION="1.0.0"
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"

REPO_RAW_URL="https://raw.githubusercontent.com/glorynguyen/video-compressor/main"
SCRIPT_NAME="video_compress_automator.sh"
INSTALL_PATH="$HOME/.local/bin/$SCRIPT_NAME"

# Check for updates (user-initiated only)
_check_update() {
  REMOTE_VERSION=$(curl -sf --connect-timeout 5 "$REPO_RAW_URL/$SCRIPT_NAME" 2>/dev/null | head -5 | grep '^VERSION=' | cut -d'"' -f2)
  if [ -z "$REMOTE_VERSION" ]; then
    osascript -e 'display dialog "Could not reach GitHub to check for updates." buttons {"OK"} default button "OK" with icon stop'
    return 1
  fi
  if [ "$REMOTE_VERSION" = "$VERSION" ]; then
    osascript -e "display dialog \"Already up to date (v$VERSION).\" buttons {\"OK\"} default button \"OK\""
  else
    osascript -e "display dialog \"A new version (v$REMOTE_VERSION) is available (you have v$VERSION).\\n\\nTo update, run:\\n  bash install_quickaction.sh\" buttons {\"OK\"} default button \"OK\""
  fi
}

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
ACTION=$(osascript -e 'choose from list {"Compress Video", "Convert Video to GIF", "Convert Images to WebP", "Check for Updates"} with title "Video & Image Tool" default items {"Compress Video"}' 2>/dev/null)

# Exit if the user cancels the menu
if [ "$ACTION" = "false" ] || [ -z "$ACTION" ]; then
  exit 0
fi

# Handle update check
if [ "$ACTION" = "Check for Updates" ]; then
  _check_update
  exit 0
fi

TOTAL_FILES=$#
PROCESSED_COUNT=0

# Supported file extensions
VIDEO_EXTENSIONS="mp4|mov|avi|mkv|wmv|flv|webm|m4v|mpg|mpeg|3gp"
IMAGE_EXTENSIONS="png|jpg|jpeg|tiff|tif|bmp|heic|heif"

# Ask user where to save output
CUSTOM_OUTPUT=""
SAVE_CHOICE=$(osascript -e 'button returned of (display dialog "Where should the output be saved?" buttons {"Same Folder", "Choose Location…"} default button "Same Folder" with title "Video & Image Tool")' 2>/dev/null)
if [ "$SAVE_CHOICE" = "Choose Location…" ]; then
  if [ $TOTAL_FILES -eq 1 ]; then
    # Single file: let user pick filename and location
    FILE="$1"
    BASENAME=$(basename "$FILE")
    FILENAME="${BASENAME%.*}"
    if [ "$ACTION" = "Compress Video" ]; then
      DEFAULT_NAME="${FILENAME}_compressed.mp4"
    elif [ "$ACTION" = "Convert Video to GIF" ]; then
      DEFAULT_NAME="${FILENAME}.gif"
    else
      DEFAULT_NAME="${FILENAME}.webp"
    fi
    # Escape backslashes and double quotes for AppleScript string context
    SAFE_NAME=$(printf '%s' "$DEFAULT_NAME" | sed 's/\\/\\\\/g; s/"/\\\\"/g')
    CUSTOM_OUTPUT=$(osascript -e "POSIX path of (choose file name with prompt \"Save output as:\" default name \"$SAFE_NAME\")" 2>/dev/null)
    if [ -z "$CUSTOM_OUTPUT" ] || [ "$CUSTOM_OUTPUT" = "false" ]; then
      exit 0
    fi
  else
    # Multiple files: let user pick a folder
    CUSTOM_OUTPUT=$(osascript -e 'POSIX path of (choose folder with prompt "Choose output folder:")' 2>/dev/null)
    if [ -z "$CUSTOM_OUTPUT" ] || [ "$CUSTOM_OUTPUT" = "false" ]; then
      exit 0
    fi
  fi
fi

# Resolve the output path for a given input file
_output_path() {
  local FILE="$1" SUFFIX="$2" EXT="$3"
  local BASENAME FILENAME DIR
  BASENAME=$(basename "$FILE")
  FILENAME="${BASENAME%.*}"
  DIR=$(dirname "$FILE")

  if [ -n "$CUSTOM_OUTPUT" ] && [ $TOTAL_FILES -eq 1 ]; then
    echo "$CUSTOM_OUTPUT"
  elif [ -n "$CUSTOM_OUTPUT" ]; then
    echo "${CUSTOM_OUTPUT%/}/${FILENAME}${SUFFIX}.${EXT}"
  else
    echo "$DIR/${FILENAME}${SUFFIX}.${EXT}"
  fi
}

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
      OUTPUT_FILE=$(_output_path "$FILE" "_compressed" "mp4")

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
      OUTPUT_FILE=$(_output_path "$FILE" "" "gif")

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
      OUTPUT_FILE=$(_output_path "$FILE" "" "webp")

      ffmpeg -i "$FILE" -c:v libwebp -quality 85 "$OUTPUT_FILE" -y 2>/dev/null

      if [ $? -eq 0 ]; then ((PROCESSED_COUNT++)); fi
    fi
  done
  NOTIFY_MSG="Successfully converted $PROCESSED_COUNT of $TOTAL_FILES image(s) to WebP."
  if [ $SKIPPED_COUNT -gt 0 ]; then NOTIFY_MSG="$NOTIFY_MSG Skipped $SKIPPED_COUNT non-image file(s)."; fi
  osascript -e "display notification \"$NOTIFY_MSG\" with title \"Video Tool\""
fi
