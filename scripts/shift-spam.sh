#!/usr/bin/env bash
set -euo pipefail

FIFO="${XDG_RUNTIME_DIR:-/tmp}/shift-spam.fifo"
[ -p "$FIFO" ] || mkfifo "$FIFO"
exec 3<>"$FIFO" # open RDWR so we never block on open/EOF

state=0 # 0 = idle, 1 = spamming

trap 'exec 3>&-; rm -f "$FIFO"' EXIT INT TERM

while :; do
  if read -r -t 0.25 -u 3 line; then # waits up to 250ms for a toggle
    if [ "$line" = toggle ]; then
      state=$((1 - state))
      [ "$state" = 1 ] && echo "Shift spam ON" || echo "Shift spam OFF"
    fi
  fi
  [ "$state" = 1 ] && ydotool key 42:1 42:0 # Left Shift tap (evdev keycode 42)
done
