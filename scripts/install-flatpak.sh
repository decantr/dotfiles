#!/bin/sh
#
# install-flatpak.sh - install flatpak and add flathub remote

echo "install flatpak? "
read -r "Continue? (y/N): " confirm

if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
	echo "Aborted."
	exit 0
fi

if [ ! -f /etc/os-release ]; then
	echo "cant find /etc/os-release"
	exit 1
fi

. /etc/os-release

case "$ID" in
debian | ubuntu | linuxmint | pop)
	sudo apt update && sudo apt install -y flatpak
	;;
arch | manjaro | endeavouros)
	sudo pacman -Sy --noconfirm flatpak
	;;
*)
	echo "unsupported distro: $ID"
	exit 1
	;;
esac

# add flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

echo "done"
