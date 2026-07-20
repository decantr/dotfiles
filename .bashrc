# ~/.bashrc
#

export EDITOR="nvim"
export STEAM_FORCE_DESKTOPUI_SCALING=2

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Use bash-completion, if available, and avoid double-sourcing
if [[ $PS1 && ! ${BASH_COMPLETION_VERSINFO:-} && -f /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi

eval "$(mise activate bash)"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias \
  e="\$EDITOR" \
  g="git" \
  p="sudo pacman" \
  S="systemctl --user " \
  SS="sudo systemctl"
