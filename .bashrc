# ~/.bashrc: executed by bash(1) for non-login shells.
# for examples
#

#### Exports ===================================================================
export EDITOR="nvim"
export STEAM_FORCE_DESKTOPUI_SCALING=2
export PATH="$PATH:$HOME/.local/bin/"

#### Interactive Check =========================================================
[[ $- != *i* ]] && return

#### Options ===================================================================
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=200000
shopt -s histappend
shopt -s checkwinsize
shopt -s globstar

#### Shell =====================================================================
PS1='\[\033[01;32m\]\u\[\033[00m\]@\h:\[\033[01;34m\]\w\[\033[00m\]\$ '

#### Experimintal ==============================================================
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#### Colors
test -r ~/.config/dircolors && eval "$(dircolors -b ~/.config/dircolors)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

#### Programs ==================================================================
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

if type mise &>/dev/null; then
	eval "$(mise activate bash)"
fi

#### Aliases ===================================================================
[ -f ~/.local/src/dotfiles/aliasrc ] && . ~/.local/src/dotfiles/aliasrc
