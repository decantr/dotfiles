#!/bin/bash
#
# boomer to zoomer
#
# a very low iq way to make edits to the LARBS
# files from github.com/lukesmithxyz/voidrice
#

# determine whether we are making a bridge or a node
printf "::    Is this display HiDPi [y/N] "
read -r REPLY
if [ "$REPLY" = "" ] || echo "$REPLY" | grep -qwE "^[Nn]$"; then
	hidpi=false
elif echo "$REPLY" | grep -qvwE "^[Yy]$"; then
	echo ::    Invalid && exit 1;
fi

# perform hidpi changes
if $hidpi ; then
	sed -i '9s/^/exec --no-startup-id xrandr --dpi 280\n/' .config/i3/config
	sed -i 's/350x5-0+24/700-0+64/' .config/dunst/dunstrc
	sed -i '3s/^/export GDK_SCALE=2\n/' .profile
fi

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
sed -i 's/exec --no-startup-id xcompmgr//' .config/i3/config
sed -i 's/gaps inner 15/gaps inner 5/' .config/i3/config
sed -i 's/gaps outer 15/gaps outer 0/' .config/i3/config
sed -i 's/exec --no-startup-id xcompmgr//' .config/i3/config
sed -i 's/bindsym $mod+w			exec $term -e nmtui/bindsym $mod+w			exec networkmanager_dmenu/' .config/i3/config
sed -i 's/gaps inner current set 15; gaps outer current set 15/gaps inner current set 5; gaps outer current set 0/' .config/i3/config
# i3blocks
# replace "[help] \n interval=once" with ""

# xinitrc
sed -ei "\$ixrandr --output eDP-1 --mode 1920x1080 --primary" .xinitrc
sed -ei "\$isetxkbmap -layout gb" .xinitrc

# vimrc
sed -i '12s/^/Plug "junegunn/limelight.vim"\n/' .config/nvim/init.vim
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
	let g:limelight_conceal_ctermfg = 'darkgray'
	map <leader>l :Limelight!!<CR>
' >> .config/nvim/init.vim

# exports
sed -i '4s/^/export XKB_DEFAULT_LAYOUT=gb\n/' .profile

# screenshots to Pictures
sed -i "s/pic-/Pictures\/Screenshots\/pic-/" .scripts/i3cmds/maimpick

# get the bibtorefer script
cp tools/* .scripts/tools/

# Fix compiler
sed -i "s/-kejpt/-kept/" .scripts/tools/compiler
