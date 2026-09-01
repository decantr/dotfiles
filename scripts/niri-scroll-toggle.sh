#!/usr/bin/env bash
CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/niri/dms/scroll.kdl"

notify() { notify-send -u low -h string:x-dunst-stack-tag:scroll-toggle "Scroll Direction" "$1"; }

if [[ ! -f "$CONFIG" ]]; then
	mkdir -p "${CONFIG%/*}"
	cat >"$CONFIG" <<'EOF'
input {
	touchpad {
		tap
		natural-scroll
	}

	mouse {
		accel-speed 0
		accel-profile "flat"
		natural-scroll
	}
}
EOF
	notify "Natural: ON"
	niri msg action load-config-file
	exit 0
fi

if grep -q '^\s*natural-scroll$' "$CONFIG"; then
	sed -i 's|^\s*natural-scroll$|		// natural-scroll|' "$CONFIG"
	notify "Natural: OFF"
else
	sed -i 's|^\s*// natural-scroll$|		natural-scroll|' "$CONFIG"
	notify "Natural: ON"
fi

niri msg action load-config-file