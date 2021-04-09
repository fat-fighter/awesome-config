#! /bin/bash

theme=$THEME
if [ -n "$1" ]; then
    theme=$1
fi

# Touchpad settings
$HOME/.config/awesome/scripts/touchpad

# Make numpad like in Microsoft
setxkbmap -option 'numpad:microsoft' -option 'caps:escape' -option 'escape:caps'

# Sourcing Xresources
xrdb ~/.Xresources

# Run Composite Manager
picom --config=$HOME/.config/picom/$theme.config -b --experimental-backends

# Run libinput gestures
libinput-gestures restart

# Running blueman
blueman-applet &

# Run xss-clock
# xss-clock slock &

wal --theme $theme -o $HOME/.config/awesome/scripts/theme-config
