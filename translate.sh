#!/bin/bash

set -e

USER_NAME=$(whoami)
MODEL_PATH="$HOME/$USER_NAME/translate-cli/models/ggml-base.en.bin"
AUDIO_DIR="$HOME/$USER_NAME/translate-cli/temp"
AUDIO_PATH="$AUDIO_DIR/output.wav"
OUTPUT_BASE="$AUDIO_DIR/output"
INPUT_DEVICE=":1"  # Adjust as needed (in my case it's the second device)

# You can list available devices with:
# ffmpeg -f avfoundation -list_devices true -i ""

mkdir -p "$AUDIO_DIR"

# Clean previous output
rm -f "$OUTPUT_BASE.txt"

trap 'kill 0' SIGINT SIGTERM EXIT

echo "🎙️ Recording... Press Z to stop."

# Start recording in background
ffmpeg -f avfoundation -i "$INPUT_DEVICE" -y "$AUDIO_PATH" >/dev/null 2>&1 &
FFMPEG_PID=$!

sleep 1  # Let ffmpeg start

# Wait for Z key
while true; do
  read -rsn1 key
  if [[ "$key" == "z" || "$key" == "Z" ]]; then
    echo "⏹️ Stopping recording..."
    kill -INT $FFMPEG_PID
    break
  fi
done

wait $FFMPEG_PID 2>/dev/null || true

# Run whisper-cli with all args inside the command
echo "🧠 Translating..."
whisper-cli \
  -m "$MODEL_PATH" \
  -f "$AUDIO_PATH" \
  -tr \
  -otxt \
  -of "$OUTPUT_BASE" \
  -l es \
  -bs 1 -bo 1 \
  -nt \
  -d 5000 \
  >/dev/null

# Copy result to clipboard
if [ -f "$OUTPUT_BASE.txt" ]; then
  cat "$OUTPUT_BASE.txt" | pbcopy
  echo "✅ Translation copied to clipboard."
else
  echo "❌ Translation failed: output file not found."
  exit 1
fi
