#!/bin/bash
# Usage: queue.sh NAME HOLD...: each HOLD (a command line, run by bash) as its own hold of the lock (buster#3394, the fold).
set -u
D=~/buster-fast-bench/3394-claude-fold
NAME=$1; shift
echo $$ > $D/$NAME.pid
for hold in "$@"; do
  EXCLUSIVE_OWNER=claude-3394-fold EXCLUSIVE_TITLE="buster #3394: fold Tier 0's validation" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxndz78sYSvtprpg5qVZ \
    ~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c "$hold"
  echo "hold [$hold] exit $?"
done
echo finished > $D/$NAME.done
