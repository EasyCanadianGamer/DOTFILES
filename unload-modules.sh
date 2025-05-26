#!/bin/bash
# Get all null-sink modules
LOADED_MODULES=$(pactl list short modules | grep module-null-sink)

# Exit if no modules found
if [[ -z "$LOADED_MODULES" ]]; then
  echo "No null-sink modules loaded."
  exit 0
fi

# Let user select one or more modules to unload
selected_modules=$(echo "$LOADED_MODULES" | gum choose --no-limit --header="Select modules to unload")

# Exit if none selected
if [[ -z "$selected_modules" ]]; then
  echo "No modules selected."
  exit 0
fi

# Confirm before proceeding
if ! gum confirm "Unload selected modules?"; then
  echo "Aborted."
  exit 0
fi

# Loop through selected modules and unload them
while IFS= read -r module_line; do
  module_id=$(echo "$module_line" | awk '{print $1}')
  pactl unload-module "$module_id"
  echo "Unloaded module ID $module_id"
done <<< "$selected_modules"
