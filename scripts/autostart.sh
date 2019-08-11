#! /bin/bash

# Set natural scrolling and Velocity Scaling
$HOME/utilities/general/touchpad/natural-scrolling.sh &
$HOME/utilities/general/touchpad/tapping.sh &
$HOME/utilities/general/touchpad/disabled-while-typing.sh -v &

# Make numpad like in Microsoft
setxkbmap -option 'numpad:microsoft' &

# Make temporary directory for awesome
mkdir -p $HOME/.config/awesome/.tmp

# Sourcing Xresources
xrdb ~/.Xresources

# Running Pulseaudio
volume set +0

# Run Compton
compton --config=$HOME/.config/compton/config &

# Run dropbox client
dropbox &

# Run blueman-applet
blueman-applet &

# Run alarm clock applet
alarm-clock-applet &
