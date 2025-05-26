#!/bin/bash

# Tokyo Night Storm theme colors for gum inputs
GUM_INPUT_PLACEHOLDER_FOREGROUND="#c0caf5"
GUM_INPUT_PROMPT_FOREGROUND="#7aa2f7"
GUM_INPUT_PROMPT_BACKGROUND="#1a1b26"
GUM_INPUT_CURSOR_FOREGROUND="#7dcfff"

echo "Enter a number of modules:"

NUM_MODULES=$(
  GUM_INPUT_PLACEHOLDER="1" \
  GUM_INPUT_PLACEHOLDER_FOREGROUND="$GUM_INPUT_PLACEHOLDER_FOREGROUND" \
  GUM_INPUT_PROMPT_FOREGROUND="$GUM_INPUT_PROMPT_FOREGROUND" \
  GUM_INPUT_PROMPT_BACKGROUND="$GUM_INPUT_PROMPT_BACKGROUND" \
  GUM_INPUT_CURSOR_FOREGROUND="$GUM_INPUT_CURSOR_FOREGROUND" \
  gum input
)

# Validate input is a positive integer
if ! [[ "$NUM_MODULES" =~ ^[0-9]+$ ]]; then
  echo "Please enter a valid number."
  exit 1
elif [[ "$NUM_MODULES" -eq 0 ]]; then
  echo "Goodbye :)!"
  exit 1
fi

for (( i = 1; i <= NUM_MODULES; i++ ))
do
    echo "Name module #$i:"
    name=$(
      GUM_INPUT_PLACEHOLDER="Music" \
      GUM_INPUT_PLACEHOLDER_FOREGROUND="$GUM_INPUT_PLACEHOLDER_FOREGROUND" \
      GUM_INPUT_PROMPT_FOREGROUND="$GUM_INPUT_PROMPT_FOREGROUND" \
      GUM_INPUT_PROMPT_BACKGROUND="$GUM_INPUT_PROMPT_BACKGROUND" \
      GUM_INPUT_CURSOR_FOREGROUND="$GUM_INPUT_CURSOR_FOREGROUND" \
      gum input
    )

    # Avoid loading module if name is empty
    if [[ -z "$name" ]]; then
      echo "No name entered, skipping module $i."
      continue
    fi

    gum spin --spinner dot --title "Loading module \"$name\"" -- \
        pactl load-module module-null-sink sink_name="$name" sink_properties=device.description="$name"
done
