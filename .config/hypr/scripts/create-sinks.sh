#!/usr/bin/env bash
# Creates virtual null sinks + loopbacks for audio routing via PipeWire/PulseAudio.
# Sinks are lost on reboot — re-run this script to recreate them.
# Safe to re-run — skips already existing sinks AND loopbacks.
#
# Sink layout:
#   game_sink   → games
#   chat_sink   → Discord
#   music_sink  → Spotify / music players
#   system_sink → browsers (Firefox, Helium), misc
#
# Each sink has a loopback to OUTPUT_SINK so you can hear everything.
# OBS captures each sink's .monitor source as a separate track.

set -euo pipefail

# ── Output device — where you actually hear audio ────────────────────────────
OUTPUT_SINK="alsa_output.pci-0000_00_1f.3.analog-stereo"
# ─────────────────────────────────────────────────────────────────────────────

declare -A SINKS=(
    ["game_sink"]="Game"
    ["chat_sink"]="Chat"
    ["music_sink"]="Music"
    ["system_sink"]="System"
)

# Validate output sink exists
if ! pactl list sinks short | awk '{print $2}' | grep -qx "$OUTPUT_SINK"; then
    echo "WARNING: OUTPUT_SINK '$OUTPUT_SINK' not found, falling back to default"
    OUTPUT_SINK=$(pactl info | grep "Default Sink" | awk '{print $3}')
    echo "  Using: $OUTPUT_SINK"
fi

create_sink() {
    local name="$1"
    local desc="$2"
    if pactl list sinks short | awk '{print $2}' | grep -qx "$name"; then
        echo "  [skip] '$name' already exists"
    else
        pactl load-module module-null-sink \
            sink_name="$name" \
            sink_properties="device.description='$desc'" > /dev/null
        echo "  [ok]   '$name' created ($desc)"
    fi
}

create_loopback() {
    local name="$1"
    if pactl list modules short | grep -q "module-loopback.*source=${name}.monitor"; then
        echo "  [skip] loopback for '${name}' already exists"
    else
        pactl load-module module-loopback \
            source="${name}.monitor" \
            sink="$OUTPUT_SINK" \
            latency_msec=50 > /dev/null
        echo "  [ok]   loopback: ${name}.monitor → $OUTPUT_SINK"
    fi
}

echo "Creating virtual audio sinks..."
for name in game_sink chat_sink music_sink system_sink; do
    create_sink "$name" "${SINKS[$name]}"
done

echo ""
echo "Creating loopbacks to '$OUTPUT_SINK'..."
for name in game_sink chat_sink music_sink system_sink; do
    create_loopback "$name"
done

echo ""
echo "Setting system_sink as default (catches misc apps automatically)..."
pactl set-default-sink system_sink
echo "  [ok]   default sink → system_sink"

echo ""
echo "Done."
echo ""
echo "Next steps:"
echo "  1. Use qpwgraph to route apps to their sinks"
echo "  2. In OBS, add Audio Input Capture for each:"
echo "     - Monitor of Game   → game_sink.monitor"
echo "     - Monitor of Chat   → chat_sink.monitor"
echo "     - Monitor of Music  → music_sink.monitor"
echo "     - Monitor of System → system_sink.monitor"
echo "  3. Firefox/Helium needs --enable-features=PipeWireAudio flag"
echo "     to route through PipeWire instead of ALSA directly"
