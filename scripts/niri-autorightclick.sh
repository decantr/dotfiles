#!/usr/bin/env bash
INTERVAL=0.05
STATE=/tmp/niri-autopress.pid

notify() { notify-send -u low -h string:x-dunst-stack-tag:autopress "Auto-Press RMB" "$1"; }

if [[ -f "$STATE" ]] && kill -0 "$(cat "$STATE")" 2>/dev/null; then
  kill "$(cat "$STATE")" 2>/dev/null
  rm -f "$STATE"
  notify "Stopped"
  exit 0
fi

rm -f "$STATE"
(
  while true; do
    ydotool click 0xC1
    sleep $INTERVAL
  done
) &
echo $! >"$STATE"
notify "Started (RMB every 5ms)"
