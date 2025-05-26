#!/bin/bash
# twitch_stream.sh - Play Twitch stream via streamlink + mpv with passthrough

if [ -z "$1" ]; then
  echo "Usage: $0 <twitch_channel>"
  exit 1
fi

streamlink --player-passthrough=hls "https://www.twitch.tv/$1" best --player=mpv
