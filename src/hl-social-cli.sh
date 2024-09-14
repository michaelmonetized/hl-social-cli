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

# variables
# Variables are set on the command line or in the config file
# --company
# --url
# --campaign
# --goal
# --vibe

# Examaple hl-social-cli.sh --company="Hustle Launch" --url="https://www.hustlelaunch.com" --campaign="Launch a new product" --goal="Increase sales" --vibe="Funny"
# Examaple hl-social-cli.sh --goal="Increase brand awareness" --company="Hustle Launch" --url="https://www.hustlelaunch.com" --campaign="Launch a new product" --vibe="Funny"

# These could be set in any order

# Check if the variables are set
if [ -z "$COMPANY" ]; then
  # check if --company is set
  if [ -z "$*" ]; then
    echo "Please set the --company variable or pass it as an argument"
    exit 1
  else
    # set the company variable to whichever arg in $@ has --company before it
    for arg in "$@"; do
      if [[ $arg == *"--company"* ]]; then
        COMPANY="${arg#*=}"
        break
      else
        echo "Company not set"
        exit 1
      fi
    done
  fi
fi

echo "Company: $COMPANY"

if [ -z "$URL" ]; then
  # check if --url is set
  if [ -z "$*" ]; then
    echo "Please set the --url variable or pass it as an argument"
    exit 1
  else
    # set the url variable to whichever arg in $@ has --url before it
    for arg in "$@"; do
      if [[ $arg == *"--url"* ]]; then
        URL="${arg#*=}"
        break
      else
        echo "URL not set"
        exit 1
      fi
    done
  fi
fi

echo "URL: $URL"

if [ -z "$CAMPAIGN" ]; then
  # check if --campaign is set
  if [ -z "$*" ]; then
    echo "Please set the --campaign variable or pass it as an argument"
    exit 1
  else
    # set the campaign variable to whichever arg in $@ has --campaign before it
    for arg in "$@"; do
      if [[ $arg == *"--campaign"* ]]; then
        CAMPAIGN="${arg#*=}"
        break
      else
        echo "Campaign not set"
        exit 1
      fi
    done
  fi
fi

echo "Campaign: $CAMPAIGN"

if [ -z "$GOAL" ]; then
  # check if --goal is set
  if [ -z "$*" ]; then
    echo "Please set the --goal variable or pass it as an argument"
    exit 1
  else
    # set the goal variable to whichever arg in $@ has --goal before it
    for arg in "$@"; do
      if [[ $arg == *"--goal"* ]]; then
        GOAL="${arg#*=}"
        break
      else
        echo "Goal not set"
        exit 1
      fi
    done
  fi
fi

echo "Goal: $GOAL"

if [ -z "$VIBE" ]; then
  # check if --vibe is set
  if [ -z "$*" ]; then
    echo "Please set the --vibe variable or pass it as an argument"
    exit 1
  else
    # set the vibe variable to whichever arg in $@ has --vibe before it
    for arg in "$@"; do
      if [[ $arg == *"--vibe"* ]]; then
        VIBE="${arg#*=}"
        break
      else
        echo "Vibe not set"
        exit 1
      fi
    done
  fi
fi

echo "Vibe: $VIBE"
