#!/bin/bash
# After setup.sh: make.sh, three rounds and the two compile-time runs, each its own hold of the lock.
set -euo pipefail
cd ~/buster-fast-bench/1372-3343-claude
until grep -qx built setup.log; do sleep 20; done
export EXCLUSIVE_OWNER=claude-3343 EXCLUSIVE_TITLE="buster #3343: bit-field units leftovers (#1372)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3343
lock=~/buster-fast-bench/exclusive.sh
$lock timeout 300 ./make.sh
for round in 1 2 3; do
    $lock timeout 540 ./round.sh "$round"
done
corpus=~/buster-fast-bench/2543-claude/corpus
$lock timeout 540 ./compile.sh "$corpus" tier0
$lock timeout 540 ./compile.sh "$corpus" tier1
echo done
