# vim:	noet sw=4 ts=4
#zmodload zsh/zprof

### herd ======================================================================
if [[ -d ~/"Library/Application Support/Herd" ]] then
	# herd php
	export HERD_PHP_81_INI_SCAN_DIR=~/"Library/Application Support/Herd/config/php/81/"
	export HERD_PHP_82_INI_SCAN_DIR=~/"Library/Application Support/Herd/config/php/82/"
	export HERD_PHP_83_INI_SCAN_DIR=~/"Library/Application Support/Herd/config/php/83/"
	export HERD_PHP_84_INI_SCAN_DIR=~/"Library/Application Support/Herd/config/php/84/"
	export HERD_PHP_85_INI_SCAN_DIR=~/"Library/Application Support/Herd/config/php/85/"
	export PATH=~/"Library/Application Support/Herd/bin/":$PATH

	# herd nvm
	export NVM_DIR=~/"Library/Application Support/Herd/config/nvm"
fi

### programs ==================================================================
if type mise &>/dev/null; then
	eval "$(mise activate zsh)"
fi

# use fzf for history
if type fzf &> /dev/null; then
	eval "$(fzf --zsh)"
fi

if type brew &> /dev/null; then
	export HOMEBREW_NO_ANALYTICS=1

	eval "$(/opt/homebrew/bin/brew shellenv)"

	# brew completions
	FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

	# ungoogled chromium path for node tests
	export CHROME_BIN=/System/Volumes/Data/Applications/Chromium.app/Contents/MacOS/Chromium
fi

if [[ -z ~/".docker/completions" ]] then
	fpath=(~/.docker/completions $fpath)
fi

if type bun &> /dev/null; then
	# bun completions
	[ -s ~/".bun/_bun" ] && source ~/".bun/_bun"

	# path
	export PATH=~/".bun/bin:$PATH"

	# angular completions
	#source <(ng completion script)
fi

### config ====================================================================

# history
HISTSIZE=10000000
SAVEHIST=10000000
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_save_no_dups

# use nvim over vim
if type nvim &> /dev/null; then
	export EDITOR="nvim"
else
	export EDITOR="vim"
fi

### functions =================================================================
function git-cherry-pick-as-is() {
	local commit

	for commit in "$@"; do
		GIT_COMMITTER_DATE=$(git show -s --format=%aD "$commit") \
		GIT_COMMITTER_NAME=$(git show -s --format=%aN "$commit") \
		GIT_COMMITTER_EMAIL=$(git show -s --format=%aE "$commit") \
		git cherry-pick --keep-redundant-commits --allow-empty --no-edit "$commit" || return 1
	done
}

#### aliases ===================================================================
[ -f ~/.local/src/dotfiles/aliasrc ] && . ~/.local/src/dotfiles/aliasrc

#### device ===================================================================
[ -f ~/.config/shellrc ] && . ~/.config/shellrc

# autocomplete
autoload -Uz compinit && compinit

# colors
autoload -U colors && colors

#zprof
