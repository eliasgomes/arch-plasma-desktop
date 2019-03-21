#!/usr/bin/env zsh

sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# graphics
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto
xrandr --dpi 96

# keyboard
setxkbmap -model pc105 -layout us -variant intl

# mouse
# device_id=9
# xinput --set-prop ${device_id} 'libinput Accel Speed' -1
# xinput set-ptr-feedback ${device_id} 0 20 10
 
# background
xsetroot -solid '#000000'
feh --bg-fill --no-fehbg "$HOME/Pictures/cats_blue_eyes_animals_pets_4288x2848.jpg"

dunst &!
exec i3
