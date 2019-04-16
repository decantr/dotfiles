#!/bin/bash
#
# boomer to zoomer
#
# a very low iq way to make edits to the LARBS
# files from github.com/lukesmithxyz/voidrice
#

# aliases
aliases="alias ytsquint='mpv --really-quiet -ytdl-format=43/worst' \\
	ytwatch='mpv --really-quiet -ytdl-format=best[height=480]/22/135' \\
	ytlisten='mpv --really-quiet -ytdl-format=bestaudio' \\
	steam='steam -no-browser -silent' \\
	wgon='sudo wg-quick up wg0 && notify_send \'Wireguard Activated\'' \\
	wgoff='sudo wg-quick down wg0 && notify_send \'Wireguard Deactivated\'' \\
	song='youtube-dl -i -f bestaudio -x --audio-format=mp3 --audio-quality 0 --embed-thumbnail -o \'~/Music-Inc/%(uploader)s - %(title)s.%(ext)s\'' \\
	ident='echo $(curl -s ident.me)' \\
	homegit='git --work-tree=$HOME --git-dir=$HOME/repos/voidrice'"
echo "$aliases" >> .config/aliasrc

# i3 changes
# TODO : Add in grep so no duplicates
sed -i '9s/^/exec --no-startup-id xrandr --dpi 280\n/' .config/i3/config
sed -i '9s/^/exec --no-startup-id setxkbmap -layout gb\n/' .config/i3/config
sed -i 's/exec --no-startup-id xcompmgr//' .config/i3/config
sed -i 's/gaps inner 15/gaps inner 5/' .config/i3/config
sed -i 's/gaps outer 15/gaps outer 10/' .config/i3/config
sed -i 's/exec --no-startup-id xcompmgr//' .config/i3/config
sed -i 's/bindsym $mod+w			exec $term -e nmtui/bindsym $mod+w			exec networkmanager_dmenu/' .config/i3/config

# i3blocks
# replace "[help] \n interval=once" with ""

# vimrc
sed -i '9s/^/set tabstop=2\n/' .vimrc
sed -i '9s/^/set shiftwidth=2\n/' .vimrc
sed -i 's/en_us/en_gb/' .vimrc

# dunst
sed -i 's/350x5-0+24/700-0+64/' .config/dunst/dunstrc

# exports
sed -i '3s/^/export GDK_SCALE=2\n/' ~/.profile
sed -i '4s/^/export XKB_DEFAULT_LAYOUT=gb\n/' ~/.profile

# screenshots to Pictures
sed -i "s/pic-/Pictures\/Screenshots\/pic-/" .scripts/i3cmds/maimpick

