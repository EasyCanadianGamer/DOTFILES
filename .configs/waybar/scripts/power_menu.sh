#!/bin/bash

chosen=$(printf " Shutdown\n Reboot\n󰤄 Logout\n Lock\n" | rofi -dmenu -i -p "Power Menu")

case "$chosen" in
  " Shutdown") systemctl poweroff ;;
  " Reboot") systemctl reboot ;;
  "󰤄 Logout") hyprctl dispatch exit ;;
  " Lock") hyprlock ;;
esac
