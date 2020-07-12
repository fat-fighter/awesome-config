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

# Starting libinput extended gestures
libinput-gestures-setup start

# Running Pulseaudio
volume set +0

# Run Compton
picom --config=$HOME/.config/picom/$THEME.config -b --experimental-backends

# Run dropbox client
dropbox &

# Run blueman-applet
blueman-applet &

# Run redshift
redshift -P -O 4500 &

# Run alarm clock applet
# alarm-clock-applet &

wal --theme $THEME -o $HOME/.config/awesome/scripts/theme-config
