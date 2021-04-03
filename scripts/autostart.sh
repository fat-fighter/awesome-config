#! /bin/bash

theme=$THEME
if [ -n "$1" ]; then
    theme=$1
fi

# Set natural scrolling and Velocity Scaling
$HOME/.config/awesome/scripts/touchpad/natural-scrolling.sh &
$HOME/.config/awesome/scripts/touchpad/tapping.sh &
$HOME/.config/awesome/scripts/touchpad/disabled-while-typing.sh -v &

# Make numpad like in Microsoft
setxkbmap -option 'numpad:microsoft' -option 'caps:escape' -option 'escape:caps'

# Make temporary directory for awesome
mkdir -p $HOME/.config/awesome/.tmp

# Sourcing Xresources
xrdb ~/.Xresources

# Run Composite Manager
picom --config=$HOME/.config/picom/$theme.config -b --experimental-backends

# Run libinput gestures
libinput-gestures restart

# Run xss-clock
# xss-clock slock &

wal --theme $theme -o $HOME/.config/awesome/scripts/theme-config
