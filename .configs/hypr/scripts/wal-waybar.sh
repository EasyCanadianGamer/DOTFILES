#!/bin/bash

# Get the current wallpaper path
WALLPAPER=$(grep -oP '(?<=wallpaper = ).*' ~/.config/hypr/hyprland.conf | head -n 1 | cut -d',' -f2)

# If the path is relative or missing, fallback
if [[ ! -f "$WALLPAPER" ]]; then
    WALLPAPER=$(find ~/.config/hypr/wallpapers -type f | shuf -n 1)
fi

# Run pywal to generate color scheme
wal -i "$WALLPAPER"

# Copy pywal CSS to Waybar config
cp ~/.cache/wal/colors-waybar.css ~/.config/waybar/colors.css

# Restart Waybar
pkill waybar && waybar &
