#!/bin/bash

# Load environment variables
source .env

# Check for override in $HOME/.config/hl-social-cli/config
if [ -f "$HOME/.config/hl-social-cli/config" ]; then
  source "$HOME/.config/hl-social-cli/config"
fi

# Check if the HUGGINGFACE_TOKEN is set
if [ -z "$HUGGINGFACE_TOKEN" ]; then
  echo "HUGGINGFACE_TOKEN is not set. Please set it in $PWD/.env or in your dotfiles. $HOME/.config/hl-social-cli/config"
  exit 1
fi

# Parse command-line arguments
for arg in "$@"; do
  case $arg in
  --company=*)
    COMPANY="${arg#*=}"
    shift
    ;;
  --description=*)
    DESCRIPTION="${arg#*=}"
    shift
    ;;
  --url=*)
    URL="${arg#*=}"
    shift
    ;;
  --campaign=*)
    CAMPAIGN="${arg#*=}"
    shift
    ;;
  --goal=*)
    GOAL="${arg#*=}"
    shift
    ;;
  --vibe=*)
    VIBE="${arg#*=}"
    shift
    ;;
  *)
    # unknown option
    ;;
  esac
done

# Check if the variables are set
if [ -z "$COMPANY" ]; then
  read -rp "Company Name: " COMPANY
fi
echo "Company: $COMPANY"

if [ -z "$DESCRIPTION" ]; then
  read -rp "Description Name: " DESCRIPTION
fi
echo "Company: $DESCRIPTION"

if [ -z "$URL" ]; then
  read -rp "URL: " URL
fi
echo "URL: $URL"

if [ -z "$CAMPAIGN" ]; then
  read -rp "Campaign Name: " CAMPAIGN
fi
echo "Campaign: $CAMPAIGN"

if [ -z "$GOAL" ]; then
  read -rp "Campaign Goal: " GOAL
fi
echo "Goal: $GOAL"

if [ -z "$VIBE" ]; then
  read -rp "Vibe: " VIBE
fi
echo "Vibe: $VIBE"

CAPTION_PROMPT="Generate a json array of no less and no more than 42 (FORTY-TWO) total completely different engaging social media post captions for [company name: $COMPANY]($URL) [company description: $DESCRIPTION] [campaign name: $CAMPAIGN] [campaign goal(s): $GOAL] with the vibe [vibe: $VIBE] use a json array output following the example structure [\n\t{\n\t\ttitle: string,\n\t\tcaption: string,\n\t\thashtags: string[]\n\t}\n]\n\n [[it is highly important that there is strict adhearance to the output structure and the resulting array of EXACTLY 42 objects containg all three properties is at the top level and not nested inside any objects]]. you must write a unique relevant engaging title, you must write a unique relevant engaging caption, you must write at least 5 unique engaging hashtags, do not deviate from the task, do not write less than 42 array items containing separate title, caption and hashtags properties, do not write more than 42 array items. do not halluciante. do not provide any information that could be considered misinformation, disinformation, or factually untrue."
echo "Prompt: $CAPTION_PROMPT"

# generate a random filename 16 characters long
TMPDIR="$PWD/tmp"
TMPFILE=$(mktemp -u XXXXXXXXXXXXXXXX)
FILENAME="$TMPDIR/$TMPFILE.json"
echo "$FILENAME"

generate_captions() {
  # Generate captions
  ollama run llama3.1 "$CAPTION_PROMPT" --format json >>"$FILENAME"

  # Parse the JSON output
  # The format will be:
  # [{title: string, caption: string, hashtags: string[]}]

  COUNT=$(jq -c '.[] | length' "$FILENAME") # $COUNT is a string should be an integerecho "$COUNT"
  echo "$COUNT"

  if ! [[ "$COUNT" =~ ^[0-9]+$ ]]; then
    echo "Error: Unable to parse JSON output count"
    exit 1
  fi

  echo "Generated $COUNT items"

  if [ "$COUNT" -ne 42 ]; then
    echo "Expected 42 items, got $COUNT"

    if [ "$COUNT" -lt 42 ]; then
      echo "Renaming $FILENAME to $TMPDIR/incomplete-$(basename "$FILENAME")"
      mv "$FILENAME" "$TMPDIR/incomplete-$(basename "$FILENAME")"

      echo "Trying again…"
      generate_captions
    fi
  fi

  echo "now run flux.sh $FILENAME"
}

generate_captions
