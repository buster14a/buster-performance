#!/bin/sh
# Run one command under the 9700X lock in the 1352 tree; output goes to the named log.
cd ~/buster-fast-bench/1352-claude || exit 1
log=$1; shift
export EXCLUSIVE_OWNER=claude-1352 EXCLUSIVE_TITLE="SEMI-NCA scalar dominators (#1352)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1352
~/buster-fast-bench/exclusive.sh "$@" > "$log" 2>&1
echo "exit $?" >> "$log"
