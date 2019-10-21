#!/bin/bash

# This script cleans up old processes used by widgets which run persistently
# in the background and therefore could possibly run indefinitely if not
# killed.

# Kill all instances of compton and polybar
killall -q compton
while pgrep -x compton >/dev/null; do
	sleep 1;
done

killall -q polybar
while pgrep -x polybar >/dev/null; do
	sleep 1;
done

# Kill all instances of blueman-applet
killall -q blueman-applet

# Kill all instances of dropbox client
killall -q dropbox

# Kill all instances of alarm clock applet
killall -q alarm-clock-applet

# Clear the temporary directory (used for spotify)
rm -rf ${HOME}/.config/awesome/.tmp/*

# Stopping libinput extended gestures
libinput-gestures-setup start

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
