#!/bin/bash
# after.sh UNIT QUEUE: waits for the systemd user unit UNIT to end, then runs queue.sh QUEUE (STOP removed first).
cd "$(dirname "$0")"
while systemctl --user is-active --quiet "$1"; do sleep 20; done
rm -f STOP
exec ./queue.sh "$2"
