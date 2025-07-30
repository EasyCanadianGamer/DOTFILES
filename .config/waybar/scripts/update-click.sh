#!/bin/bash

kitty -e bash -c 'echo "== PACMAN =="; sudo pacman -Syu; echo "== YAY (AUR) =="; yay -Sua; echo Done. Press Enter to close...; read'
