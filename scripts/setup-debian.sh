#!/bin/sh

# Install Proxy
if [ ! -f /etc/apt/apt.conf.d/20-localproxy ]; then
	printf 'Acquire::http::Proxy "http://10.0.0.112:3142";
Acquire::https::Proxy "DIRECT";' |
		sudo tee /etc/apt/apt.conf.d/20-localproxy
fi

# Install Apps
sudo apt update

sudo apt install -y extrepo

sudo extrepo enable mise

sudo apt update

sudo apt install -y \
	openssh-server \
	curl \
	\
	mise \
	tmux \
	vim \
	fastfetch \
	btop \
	nnn \
	\
	sway \
	swayidle \
	swaylock \
	brightnessctl \
	foot \
	grim \
	slurp \
	wireplumber \
	xdg-desktop-portal-wlr \
	xwayland
