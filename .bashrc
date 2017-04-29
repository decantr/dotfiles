if [ -f /usr/share/defaults/etc/profile ]; then
    source /usr/share/defaults/etc/profile
fi
if [ -f /usr/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh ]; then
source /usr/lib/python2.7/site-packages/powerline/bindings/bash/powerline.sh
fi

# personal aliases
alias dl='youtube-dl -xf bestaudio --audio-format mp3'
alias ip='curl ident.me'
alias up='sudo eopkg up'
alias o='xdg-open'
alias re='sudo !!'
alias bashrc='vim .bashrc; source .bashrc'

export LS_OPTIONS='--color=auto -l'
eval "`dircolors`"
alias less='less -r'                          # raw control characters
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias ls='ls --color=auto -h'
alias ll='ls -l'
alias la='ls -la'
alias l='ll'
alias df='df -h'
alias free='free -h'
export EDITOR=vim
