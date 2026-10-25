#!/usr/bin/env bash
FIFO="${XDG_RUNTIME_DIR:-/tmp}/shift-spam.fifo"
if [ ! -p "$FIFO" ]; then
	notify-send -a "shift-toggle" -u critical "Shift spam" "shift-spam.sh is not running" 2>/dev/null
	exit 1
fi
printf 'toggle\n' >"$FIFO"
