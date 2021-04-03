#!/bin/bash

# This script cleans up old processes used by widgets which run persistently
# in the background and therefore could possibly run indefinitely if not
# killed.

# Kill all instances of picom
killall -q picom
while pgrep -x picom >/dev/null; do
	sleep 1;
done

# Clear already running scripts to avoid unnecessarily running orphan processes
processes=(
	"sp.subscribe"    # Spotify
	"pactl subscribe" # Volume
	"connman-monitor" # Wifi
	"bluez-monitor"   # Bluetooth
)
for process in ${processes[@]}; do
	ps aux | grep $process | grep -v grep | awk '{print $2}' | xargs kill
done
