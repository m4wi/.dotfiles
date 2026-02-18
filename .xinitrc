#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

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



# setxkbmap -model pc105 -layout latam -option caps:escape_shifted_capslock

#export XDG_RUNTIME_DIR=/run/user/$(id -u)
#sudo mkdir -p "$XDG_RUNTIME_DIR"
#sudo chmod 700 "$XDG_RUNTIME_DIR"
#sudo chown "$(id -u)":"$(id -g)" "$XDG_RUNTIME_DIR"

#if command -v dbus-launch >/dev/null 2>&1; then
#	eval "$(dbus-launch --sh-syntax --exit-with-session)"
#fi

#pipewire &
#pipewire-pulse &
        #wireplumber &

#exec bspwm
#exec startxfce4
#exec openbox-session
#setsid nohup dwmblocks >/dev/null 2>&1 &
#export DESKTOP_SESSION=plasma
#setsid dwmblocks >/dev/null 2>&1 & disown
#setsid nohup dwmblocks >/dev/null 2>&1 &
exec i3
#exec startplasma-x11
#exec cinnamon-session
