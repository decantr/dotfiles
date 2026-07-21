#!/bin/sh
#
# curl -fsSl "https://raw.githubusercontent.com/decantr/dotfiles/refs/heads/master/install.sh" | sh

set -e

# Check for Dotfiles repo
if [ ! -d ~/.local/src/dotfiles ]; then
	echo "!! No dotfiles"
	exit 1
fi

# Install Mise if not available
# @todo

# Remove existing Mise config
if [ -f ~/.config/mise/config.toml ]; then
	echo ":: Backing up existing \`mise.toml\`"

	mv ~/.config/mise/config.toml ~/.config/mise/config.toml."$(date +%Y%m%d-%H%M%S)"
fi

#
echo ":: Applying "

mise dotfiles apply ~/.config/mise/config.toml
