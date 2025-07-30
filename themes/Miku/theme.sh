#!/bin/bash

# Apply wallpaper via pywal
wal -i ~/.local/share/themes/miku/wallpaper.png

# Modify Hyprland borders directly (optional live reload if you want)
sed -i '/col.active_border/c\col.active_border = rgba(b6fff6bd) rgba(3bd6c6d9) 45deg' ~/.config/hypr/hyprland.conf

# Restart Hyprland to apply border changes if needed (optional):
hyprctl reload

# Replace Waybar style.css with themed version
cp ~/.local/share/themes/Miku/style.css ~/.config/waybar/style.css

# Reload Waybar
pkill waybar
waybar &
