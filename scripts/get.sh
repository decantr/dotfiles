#!/bin/sh
#
# Pull a single file from repo and install it locally, without needing to clone.
#
# curl -fsSL "https://raw.githubusercontent.com/decantr/dotfiles/refs/heads/master/scripts/get.sh" | sh
#
# Skip the picker by naming paths:
#
# curl -fsSL "https://raw.githubusercontent.com/decantr/dotfiles/refs/heads/master/scripts/get.sh" | sh -s -- .zshrc .config/git/config
#
# Env: REPO, REF, IGNORE

set -e

REPO="${REPO:-decantr/dotfiles}"
REF="${REF:-master}"
IGNORE="${IGNORE:-scripts/get.sh install.sh readme.md wip}"

API="https://api.github.com/repos/$REPO/git/trees/$REF?recursive=1"
RAW="https://raw.githubusercontent.com/$REPO/$REF"

#### helpers ==================================================================

die() {
	echo "!! $*" >&2
	exit 1
}

command -v curl >/dev/null 2>&1 || die "missing: curl"
#command -v jq >/dev/null 2>&1 || die "missing: jq"

# list files from the endpoint
# format: file_permission_mode<TAB>file_path
list_files() {
	# curl -fsSL "$API" |
	# 	jq -r '.tree[] | select(.type == "blob") | "\(.mode)\t\(.path)"'
	{
		curl -fsSL "$API" | tr -d '\n'
		echo
	} | tr '{' '\n' |
		sed -n 's/.*"path": *"\([^"]*\)".*"mode": *"\([^"]*\)".*"type": *"blob".*/\2	\1/p'
}

# gets the file map defined in mise.toml
# format: source_path<TAB>target_path
list_map() {
	curl -fsSL "$RAW/mise.toml" 2>/dev/null | awk -F '"' '
		/^[[:space:]]*\[/ { dotfiles = ($0 ~ /^\[dotfiles\]/); next }
		# `"~/.zshrc" = { mode = "symlink" }` names no source, and its target is the default anyway
		dotfiles && NF > 3 && $0 !~ /{/ { print $4 "\t" $2 }
	'
}

# hide paths based on IGNORE set above
drop_ignored() {
	awk -v ignore="$IGNORE" '
		BEGIN { count = split(ignore, skip, " ") }
		{
			for (i = 1; i <= count; i++)
				if ($0 == skip[i] || index($0, skip[i] "/") == 1) next

			print
		}
	'
}

# targets come out of the toml with a literal leading tilde
# shellcheck disable=SC2088
dest_for() {
	dst=$(awk -F '\t' -v s="$1" '$1 == s { print $2; exit }' "$TMP/map")

	# no mapping in mise.toml, mirror the repo layout under $HOME
	[ -n "$dst" ] || dst="~/$1"

	case "$dst" in
	'~/'*) dst="$HOME/${dst#'~/'}" ;;
	esac

	printf '%s\n' "$dst"
}

ask() {
	{ : </dev/tty; } 2>/dev/null || return 0

	printf '?? %s [Y/n] ' "$1" >/dev/tty
	read -r reply </dev/tty || reply=n

	case "$reply" in
	[nN]*) return 1 ;;
	*) return 0 ;;
	esac
}

# numbered picker, used when there is no fzf
pick_plain() {
	printf '\n' >/dev/tty
	printf '%s\n' "$1" | awk '{ printf "  %3d  %s\n", NR, $0 }' >/dev/tty

	while :; do
		printf '\n:: number(s) to install, q to quit\n?? ' >/dev/tty
		read -r reply </dev/tty || return 1

		case "$reply" in
		q | Q) return 1 ;;
		esac

		picked=$(printf '%s\n' "$1" | awk -v sel="$reply" '
			BEGIN { count = split(sel, list, " "); for (i = 1; i <= count; i++) want[list[i] + 0] = 1 }
			want[NR]
		')

		[ -n "$picked" ] && break

		echo "!! not a valid selection" >/dev/tty
	done

	printf '%s\n' "$picked"
}

pick() {
	command -v fzf >/dev/null 2>&1 || {
		pick_plain "$1"
		return
	}

	printf '%s\n' "$1" | fzf \
		--multi \
		--reverse \
		--height=80% \
		--prompt='dotfile> ' \
		--header='tab to mark several, enter to install' \
		--preview="curl -fsSL '$RAW/{}' 2>/dev/null || echo '(no preview)'" \
		--preview-window=right,60%,border-left
}

install_file() {
	src="$1"
	dst=$(dest_for "$src")

	echo ":: $src -> $dst"

	curl -fsSL "$RAW/$src" >"$TMP/blob" || die "could not download \`$src\`"

	if [ -e "$dst" ] || [ -L "$dst" ]; then
		if [ -f "$dst" ] && cmp -s "$TMP/blob" "$dst"; then
			echo ":: already up to date"
			return 0
		fi

		ask "overwrite existing \`$dst\`?" || {
			echo ":: skipped"
			return 0
		}

		bak="$dst.$(date +%Y%m%d-%H%M%S)"
		echo ":: backing up to $bak"
		mv "$dst" "$bak"
	fi

	mkdir -p "$(dirname "$dst")"

	# cat so the file gets the usual umask instead of mktemp's 0600
	cat "$TMP/blob" >"$dst"

	case "$(awk -F '\t' -v s="$src" '$2 == s { print $1; exit }' "$TMP/files")" in
	*755) chmod +x "$dst" ;;
	esac
}

#### main =====================================================================

main() {
	TMP=$(mktemp -d)
	trap 'rm -rf "$TMP"' EXIT
	trap 'exit 130' INT TERM

	echo ":: fetching $REPO@$REF"

	list_files >"$TMP/files"
	[ -s "$TMP/files" ] || die "no files listed, check \`$REPO@$REF\` and the github rate limit"
	list_map >"$TMP/map"

	if [ "$#" -gt 0 ]; then
		for src in "$@"; do
			cut -f 2 "$TMP/files" | grep -qxF "$src" ||
				die "\`$src\` is not in the repo"
		done

		printf '%s\n' "$@" >"$TMP/selection"
	else
		# /dev/tty can exist and still refuse to open, so test a real open
		{ : </dev/tty; } 2>/dev/null || die "no tty, pass paths as arguments"

		# a cancelled picker is not an error
		pick "$(cut -f 2 "$TMP/files" | drop_ignored)" >"$TMP/selection" || true
	fi

	[ -s "$TMP/selection" ] || {
		echo ":: nothing selected"
		return 0
	}

	while IFS= read -r src; do
		install_file "$src"
	done <"$TMP/selection"
}

# brace group, so a truncated download cannot run half a script
{
	main "$@"
	exit
}
