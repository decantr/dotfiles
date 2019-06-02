#!/bin/bash
#
# boomer to zoomer
#
# a very low iq way to make edits to the LARBS
# files from github.com/lukesmithxyz/voidrice
#

if [ -d voidrice ] ; then
	cd voidrice || exit 1
	git reset --hard 1>/dev/null && echo "::  Resetting repo"
else
	git clone https://github.com/LukeSmithxyz/voidrice.git 1> /dev/null && echo "::  Cloned repo"
	cd voidrice || exit 1
fi

printf "::  Use \"i3\" or \"dwm\" [i/D]: "
read -r REPLY
if [ "$REPLY" = "" ] || echo "$REPLY" | grep -qwE "^[Dd]$"; then
	git checkout voiddwm 1> /dev/null
elif echo "$REPLY" | grep -qwE "^[Ii]$"; then
	git checkout archi3 1> /dev/null
else echo "::  Invalid" && exit 1
fi

git pull &> /dev/null

printf "::    Is this display HiDPi [y/N] "
read -r REPLY
if [ "$REPLY" = "" ] || echo "$REPLY" | grep -qwE "^[Nn]$"; then
	hidpi=false
elif echo "$REPLY" | grep -qvwE "^[Yy]$"; then
	echo ::    Invalid && exit 1;
fi

# copy files in
cp ../bin/* .local/bin/
cp ../.Xdefaults .
cp ../wall.png .config/
cp ~/.config/newsboat/urls .config/newsboat/
sudo cp -n ../xorg.conf.d/* /etc/X11/xorg.conf.d/

# perform hidpi changes
if $hidpi ; then
	sed -i '/dunst/a xrandr --output eDP-1 --dpi 192' .xprofile
	sed -i 's/350x5-0+24/700-0+48/' .config/dunst/dunstrc
	sed -i '3s/^/export GDK_SCALE=2\n/' .profile
fi

# keybinds
sed -i "s/wpa_cli/sudo -A nmtui/" .config/sxhkd/sxhkdrc
sed -i "s/transmission-remote-cli/tremc/" .local/bin/torwrap

# aliases
aliases="alias ytsquint='mpv --really-quiet -ytdl-format=43/worst' \\
	ytwatch='mpv --really-quiet -ytdl-format=18/best[height=480]/22/135' \\
	ytlisten='mpv --really-quiet -ytdl-format=171/250/bestaudio' \\
	steam='steam -no-browser -silent' \\
	wgon='sudo wg-quick up wg0 && notify_send \"Wireguard Activated\"' \\
	wgoff='sudo wg-quick down wg0 && notify_send \"Wireguard Deactivated\"' \\
	song='youtube-dl -i -f bestaudio -x --audio-format=mp3 --audio-quality 0 --embed-thumbnail -o \"~/Music-Inc/%(uploader)s - %(title)s.%(ext)s\"' \\
	ident='echo \$(curl -s ident.me)' \\
	p='sudo pacman' \\
	SS='sudo systemctl' \\
	"
echo "$aliases" >> .config/aliasrc

# repo specific changes
if [ -d .config/i3 ]; then
	# i3 changes
	sed -i 's/gaps inner 15/gaps inner 5/' .config/i3/config
	sed -i 's/gaps outer 15/gaps outer 0/' .config/i3/config
	sed -i 's/gaps inner current set 15; gaps outer current set 15/gaps inner current set 5; gaps outer current set 0/' .config/i3/config
	# changes that only need to be made on arch
	sed -i "s/-kejpt/-kept/" .local/bin/tools/compiler
	sed -i "s/pic-/Pictures\/Screenshots\/pic-/" .local/bin/i3cmds/maimpick
	sed -i 's/-variant altgr-intl //' .xprofile
else
	# script changes
	sed -i "s/-kejpt/-kept/" .local/bin/compiler
	sed -i "s/pic-/Pictures\/Screenshots\/pic-/" .local/bin/maimpick
	# void to arch changes
	sed -i "s/-A zzz/systemctl suspend/" .config/sxhkd/sxhkdrc
fi

# xprofile
sed -i 's/xcompmgr/#xcompmgr/' .xprofile
sed -i 's/setxkbmap/setxkbmap -layout gb/' .xprofile
sed -i '/unclutter/a xrdb ~/.Xdefaults &' .xprofile

# vimrc
sed -i "12s/^/Plug 'junegunn\/limelight.vim'\n/" .config/nvim/init.vim
sed -i 's/en_us/en_gb/' .config/nvim/init.vim
echo 'set tabstop=2' >> .config/nvim/init.vim
echo 'set shiftwidth=2' >> .config/nvim/init.vim
echo '
""" groff
	" Word Count
	autocmd FileType groff map <leader>w :w !watchwc <c-r>%<CR>
	" Code snippets
	autocmd FileType groff inoremap ,b <Enter>.B ""<Enter><++><Esc>ka
	autocmd FileType groff inoremap ,i <Enter>.I ""<Enter><++><Esc>ka
	autocmd FileType groff inoremap ,cw <Enter>.CW ""<Enter><++><Esc>kf"a
	autocmd FileType groff inoremap ,li <Enter>.IP \[bu]<Enter>
	autocmd FileType groff inoremap ,gli <Enter>.RS<Enter>.RS<Enter>.IP \[bu]<Enter>.RE<Enter>.RE<Esc>2kA<Enter>
	autocmd FileType groff inoremap ,gcode <Enter>.CW<Enter>.TS<Enter>box centre;<Enter>l.<Enter>.SM<Enter>$<Enter>.TE<Enter>.R<Enter>.REF "<++>"<Enter><++><Esc>4kA

	""" Refer
	inoremap ,gref <Enter>%K <Enter>%O <++><Enter>%D <++><Enter>%I <++><Enter>%A <++><Enter>%T <++><Enter><Esc>6kA

""" Limelight
	let g:limelight_conceal_ctermfg = "darkgray"
	map <leader>l :Limelight!!<CR>
' >> .config/nvim/init.vim
