#!/bin/bash
systemctl --user stop pipewire pipewire-pulse wireplumber
pkill -f pipewire
rm -rf ~/.cache/pipewire ~/.local/state/pipewire ~/.config/pipewire
systemctl --user start pipewire pipewire-pulse wireplumber
