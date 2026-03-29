#!/bin/bash

SCREENSHOT_DIR=~/Pictures/Screenshots

# Create folder if it doesn't exist
if [ ! -d "$SCREENSHOT_DIR" ]; then
    mkdir -p "$SCREENSHOT_DIR"
fi

CHOICE=$(echo -e "Fullscreen\nRegion\nWindow" | rofi -dmenu -p " Screenshot" -theme ~/.config/rofi/themes/screenshot.rasi)

case $CHOICE in
  "Fullscreen")
    grim "$SCREENSHOT_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
    ;;
  "Region")
    grim -g "$(slurp)" "$SCREENSHOT_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
    ;;
  "Window")
    grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$SCREENSHOT_DIR/$(date +%Y-%m-%d_%H-%M-%S).png"
    ;;
esac
