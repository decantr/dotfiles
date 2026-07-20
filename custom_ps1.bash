#!/usr/bin/env bash
# Prompt configuration
# Modified version of justaguylinux's butterbash prompt

# Git prompt helpers
_prompt_git() {
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local branch dirty
  branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null) || return

  # Fast dirtiness check
  if git status --porcelain --ignore-submodules=dirty -uno 2>/dev/null | read -r _; then
    dirty="*"
  else
    dirty=""
  fi

  printf ' (%s%s)' "$branch" "$dirty"
}

# Build PS1 each prompt so we can show last exit status.
# Colors are local: the \[\e...\] codes expand into PS1 here, so the
# variables don't need to persist (and don't pollute the global namespace).
_prompt_update() {
  local exit_code=$?

  local RED="\[\e[1;31m\]" GREEN="\[\e[1;32m\]" YELLOW="\[\e[1;33m\]"
  local BLUE="\[\e[1;34m\]" CYAN="\[\e[1;36m\]" WHITE="\[\e[1;37m\]"
  local GRAY="\[\e[1;90m\]" ENDC="\[\e[0m\]"

  local status_color status_icon
  if [[ $exit_code -eq 0 ]]; then
    status_color=${GREEN}
    status_icon=":"
  else
    status_color=${RED}
    status_icon="! $exit_code"
  fi

  local ssh_message
  if [[ -n "$SSH_CLIENT" ]]; then
    ssh_message=" ${RED}[ssh]${ENDC}"
  else
    ssh_message=""
  fi

  PS1="${GRAY}\t ${GREEN}\u ${ENDC}at ${YELLOW}\H${ssh_message} ${ENDC}in ${BLUE}\w${ENDC}\$(_prompt_git)\n${status_color}${status_icon} ${CYAN}\$${ENDC} "
}

# Ensure our prompt builder runs first
PROMPT_COMMAND="_prompt_update${PROMPT_COMMAND:+;$PROMPT_COMMAND}"

# Display system info once per session. Wrapped in a function so all the
# detection temporaries stay local instead of leaking into the shell.
_prompt_header() {
  local _wm _w _os _os_id _os_icon _kernel _kernel_short _shell_name _shell_ver

  _os=$(grep "^NAME" /etc/os-release 2>/dev/null | cut -d'"' -f2)
  _os_id=$(grep "^ID=" /etc/os-release 2>/dev/null | cut -d'=' -f2)
  case "${_os_id}" in
  debian) _os_icon=$'\uf306' ;;  # Debian swirl
  ubuntu) _os_icon=$'\uf31b' ;;  # Ubuntu circle
  arch) _os_icon=$'\uf303' ;;    # Arch logo
  fedora) _os_icon=$'\uf30a' ;;  # Fedora
  manjaro) _os_icon=$'\uf312' ;; # Manjaro
  *) _os_icon=$'\u2699' ;;       # Gear fallback
  esac
  _kernel=$(uname -r)
  _kernel_short=$(echo "${_kernel}" | awk -F'[.-]' '{print ($1 && $2 && $3) ? $1"."$2"."$3 : ($1 && $2) ? $1"."$2 : $1}')
  _shell_name="${SHELL##*/}"
  _shell_name="${_shell_name:-bash}"

  printf "\e[38;5;244m─ \e[38;5;199m%s \e[1;37m${_os:-Unknown}\e[0m \e[38;5;244m·\e[0m \e[36m${_kernel_short}\e[0m \e[38;5;244m·\e[0m \e[35m${_shell_name}\e[0m \e[38;5;244m─\e[0m\n" "${_os_icon}"
}

if [[ -n "$SSH_CLIENT" ]] && [ -n "$PS1" ] && [[ -z "$_PROMPT_HEADER_SHOWN" ]]; then
  _PROMPT_HEADER_SHOWN=1
  _prompt_header
fi
