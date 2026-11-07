#!/bin/bash
# #868's driver: each step takes the 9700X's lock on its own (exclusive.sh), never around the series.
set -uo pipefail
D=$HOME/buster-fast-bench/868-claude
export EXCLUSIVE_OWNER=claude-868 EXCLUSIVE_TITLE="Solve 868" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/868
lock=$HOME/buster-fast-bench/exclusive.sh
for off in 0 2048; do
    "$lock" "$D/scripts/build-variant.sh" "$off" > "$D/logs/build-$off.log" 2>&1 || { echo "build $off failed"; exit 1; }
done
"$lock" "$D/scripts/objects.sh" > "$D/logs/objects.log" 2>&1 || { echo "objects failed"; exit 1; }
for round in $(seq 1 10); do
    "$lock" "$D/scripts/measure-round.sh" "$round" > "$D/logs/round-$round.log" 2>&1 || { echo "round $round failed"; exit 1; }
done
echo done
