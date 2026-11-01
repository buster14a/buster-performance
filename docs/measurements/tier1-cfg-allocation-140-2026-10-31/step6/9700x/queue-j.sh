#!/usr/bin/env bash
# queue-j.sh HEAD REVISION: once queue-h.sh's campaign is done, queue-ds.sh's scalar campaign.
cd ~/buster-fast-bench/claude-140-cfg || exit 1
until [ -f diff-$1/done ]; do sleep 30; done
./queue-ds.sh "$1" "$2"
