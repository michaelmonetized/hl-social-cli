#!/bin/bash

# Load environment variables
source .env
CONFIG_DIR="$HOME/.config/hl-social-cli"

if [ ! -d "$CONFIG_DIR" ]; then
  mkdir -p "$CONFIG_DIR"
fi
CONFIG_FILE="$CONFIG_DIR/config"

# Check for override in $HOME/.config/hl-social-cli/config
if [ -f "$CONFIG_DIR/config" ]; then
  # shellcheck ignore=SC1090
  source "$CONFIG_FILE"
else
  touch "$CONFIG_FILE"
fi

# Check if the HUGGINGFACE_TOKEN is set
if [ -z "$HUGGINGFACE_TOKEN" ]; then
  echo "HUGGINGFACE_TOKEN is not set. Please paste it here…"

  read -r -p "Hugging Face Token: " HUGGINGFACE_TOKEN

  echo "HUGGINGFACE_TOKEN=$HUGGINGFACE_TOKEN" >>"$CONFIG_FILE"

  echo "Saved HUGGINGFACE_TOKEN=$HUGGINGFACE_TOKEN to $CONFIG_FILE"
fi

# JSON input array of captions to generate images for is $1
# Example:
# [
#   {
#     "title": "Title 1",
#     "caption": "Caption 1",
#     "hashtags": ["hashtag1", "hashtag2"]
#   },
#   {
#     "title": "Title 2",
#     "caption": "Caption 2",
#     "hashtags": ["hashtag3", "hashtag4"]
#   }
# ]

TMPDIR="$PWD/tmp"

# Generate photos
jq -c '.[]' "$1" | while read -r item; do
  # echo "$item"
  TITLE=$(echo "$item" | jq -r '.title')
  CAPTION=$(echo "$item" | jq -r '.caption')
  HASHTAGS=$(echo "$item" | jq -r '.hashtags | join(" ")')

  POST="$TITLE $CAPTION $HASHTAGS"

  PROMPT="A hyper-realistic photo shot with a sigma f1.4 lens on kodak gold 400 film that best suits this caption: $POST"

  TMPFILE=$(mktemp -u XXXXXXXXXXXXXXXX)
  FILENAME="$TMPDIR/$TITLE-$TMPFILE.png"
  SAFEFILENAME=$(echo "$FILENAME" | tr ' ' '-')

  curl https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-dev \
    -X POST \
    -d "{\"inputs\": \"$PROMPT\"}" \
    -H 'Content-Type: application/json' \
    -H "Authorization: Bearer $HUGGINGFACE_TOKEN" --output "$SAFEFILENAME"

  echo "Generated photo: $SAFEFILENAME"
done
