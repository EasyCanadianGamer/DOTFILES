#!/bin/bash
window=$(hyprctl activewindow -j | jq -r '.class + " - " + .title')
echo "{\"text\": \"$window\"}"
