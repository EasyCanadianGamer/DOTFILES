#!/bin/bash

THEMES_DIR="$HOME/.local/share/themes"

entries=""
for dir in "$THEMES_DIR"/*; do
    name=$(basename "$dir")
    icon="$dir/preview.png"
    # fallback to wallpaper.png if preview.png doesn't exist
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

# Apply wallpaper with swww and animation
swww init &> /dev/null
swww img "$wall" --transition-type any --transition-fps 60 --transition-duration 1 --transition-pos 0.5,0.5

# Optional: slight delay to ensure smooth load
sleep 0.5

# Run theme script
bash "$theme_dir/theme.sh"
