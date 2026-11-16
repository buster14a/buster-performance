#!/bin/bash
# job37 once job36 has ended.
cd "$(dirname "$0")"
while systemctl --user is-active -q claude-2524-job36; do sleep 20; done
exec ./job37.sh
