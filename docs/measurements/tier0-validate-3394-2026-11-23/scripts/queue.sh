#!/bin/bash
# Usage: queue.sh NAME HOLD...: each HOLD (a command line, run by bash) as its own hold of the lock (buster#3394).
set -u
D=~/buster-fast-bench/3394-claude
NAME=$1; shift
echo $$ > $D/$NAME.pid
for hold in "$@"; do
  EXCLUSIVE_OWNER=claude-3394 EXCLUSIVE_TITLE="buster #3394: lower.validate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3394 \
    ~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c "$hold"
  echo "hold [$hold] exit $?"
done
echo finished > $D/$NAME.done
