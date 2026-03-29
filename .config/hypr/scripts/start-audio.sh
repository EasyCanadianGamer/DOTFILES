#!/bin/sh
pipewire &
# Wait max 10 seconds for PipeWire
for i in $(seq 1 20); do
    pactl info > /dev/null 2>&1 && break
    sleep 0.5
done
wireplumber &
pipewire-pulse &
# Wait max 10 seconds for PulseAudio compat
for i in $(seq 1 20); do
    pactl list sinks > /dev/null 2>&1 && break
    sleep 0.5
done
