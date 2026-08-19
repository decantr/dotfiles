# vim:	noet sw=4 ts=4
# ~/.bashrc: executed by bash(1) for non-login shells.

#### Exports ===================================================================
if type nvim &>/dev/null; then
	export EDITOR="nvim"
else
	export EDITOR="vim"
fi
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
if [ -f "$HOME/.local/src/dotfiles/custom_ps1.bash" ]; then
	source "$HOME/.local/src/dotfiles/custom_ps1.bash"
else
	PS1='\[\033[01;32m\]\u\[\033[00m\]@\h:\[\033[01;34m\]\w\[\033[00m\]\$ '
fi

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

		# force git for alias completion
		. /usr/share/bash-completion/completions/git
		__git_complete g __git_main

		# setup systemctl alias completion
		. /usr/share/bash-completion/completions/systemctl

		# the alias name is one word replaced by two, so the cursor index shifts by one
		_completeS() {
			COMP_WORDS=(systemctl --user "${COMP_WORDS[@]:1}")
			COMP_CWORD=$((COMP_CWORD + 1))
			_systemctl
		}
		_completeSS() {
			COMP_WORDS=(systemctl "${COMP_WORDS[@]:1}")
			_systemctl
		}

		complete -F _completeS S
		complete -F _completeSS SS

		if type pacman &>/dev/null; then
			if [ -n "$BASH_VERSION" ] && [ -f /usr/share/bash-completion/completions/pacman ]; then
				. /usr/share/bash-completion/completions/pacman

				_completeP() {
					COMP_WORDS[0]=pacman
					COMP_LINE="pacman${COMP_LINE:1}"
					COMP_POINT=$((COMP_POINT + 5))
					_pacman
				}

				complete -F _completeP p
			fi
		fi
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

if type mise &>/dev/null; then
	eval "$(mise activate bash)"
fi

if type fzf &>/dev/null; then
	eval "$(fzf --bash)"
fi

#### Aliases ===================================================================
[ -f ~/.local/src/dotfiles/aliasrc ] && . ~/.local/src/dotfiles/aliasrc

#### device ===================================================================
[ -f ~/.config/shellrc ] && . ~/.config/shellrc
