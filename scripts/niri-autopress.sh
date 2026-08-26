#!/usr/bin/env bash
KEY=42 # KEY_LEFTSHIFT (54 = right shift)
INTERVAL=0.25
STATE=/tmp/niri-autopress.pid

notify() { notify-send -u low -h string:x-dunst-stack-tag:autopress "Auto-Press Shift" "$1"; }

if [[ -f "$STATE" ]] && kill -0 "$(cat "$STATE")" 2>/dev/null; then
  kill "$(cat "$STATE")" 2>/dev/null
  rm -f "$STATE"
  notify "Stopped"
  exit 0
fi

rm -f "$STATE"
(
  while true; do
    ydotool key $KEY:1 $KEY:0
    sleep $INTERVAL
  done
) &
echo $! >"$STATE"
notify "Started (shift every 250ms)"
