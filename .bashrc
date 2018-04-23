# useful
alias ident='curl ident.me'
alias o='xdg-open'
alias dirtree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'

# streaming
#alias dl='youtube-dl -r 250K -xf bestaudio --audio-format mp3 -o ~/Downloads/%\(title\)s.%\(ext\)s'
alias dl='youtube-dl -xf bestaudio --audio-format mp3'
alias squint='mpv -ytdl-format=43/worst'
alias wtch='mpv -ytdl-format=best[height=480]/22/135'
alias listen='mpv -ytdl-format=bestaudio'

# other
alias less='less -r'
alias ll='ls -l'
alias la='ls -la'
alias df='df -h'
alias du='du -h'
alias free='free -h'

export EDITOR=vim
