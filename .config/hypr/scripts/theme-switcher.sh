#!/bin/bash

THEMES_DIR="$HOME/.local/share/themes"

entries=""
for dir in "$THEMES_DIR"/*; do
    name=$(basename "$dir")
    icon="$dir/preview.png"
    if [[ ! -f "$icon" ]]; then
        icon="$dir/wallpaper.png"
    fi
    entries+="$name\x00icon\x1f$icon"$'\n'
done

selected=$(echo -e "$entries" | rofi -dmenu -show-icons -theme ~/.config/rofi/themes/theme-switcher.rasi -p "Select Theme")
[ -z "$selected" ] && exit

theme="${selected%% *}"
theme_dir="$THEMES_DIR/$theme"
wall="$theme_dir/wallpaper.png"

# Start daemon if not already running
pgrep -x awww-daemon > /dev/null || awww-daemon &
sleep 0.3  # give daemon a moment to init if it just launched

# Apply wallpaper and save as last used
echo "$wall" > ~/.cache/current-wallpaper
awww img "$wall" --transition-type any --transition-fps 60 --transition-duration 1 --transition-pos 0.5,0.5


sleep 0.5
bash "$theme_dir/theme.sh"
