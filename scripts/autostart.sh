#! /bin/bash

theme=$THEME
if [ -n "$1" ]; then
    theme=$1
fi

# Set natural scrolling and Velocity Scaling
$HOME/utilities/general/touchpad/natural-scrolling.sh &
$HOME/utilities/general/touchpad/tapping.sh &
$HOME/utilities/general/touchpad/disabled-while-typing.sh -v &

# Make numpad like in Microsoft
setxkbmap -option 'numpad:microsoft' -option 'caps:escape' -option 'escape:caps'

# Make temporary directory for awesome
mkdir -p $HOME/.config/awesome/.tmp

# Sourcing Xresources
xrdb ~/.Xresources

# Running Pulseaudio
volume set +0

# Run Compton
picom --config=$HOME/.config/picom/$theme.config -b --experimental-backends

# Run dropbox client
dropbox &

# Run blueman-applet
blueman-applet &

# Run xss-clock
xss-clock slock &

wal --theme $theme -o $HOME/.config/awesome/scripts/theme-config
