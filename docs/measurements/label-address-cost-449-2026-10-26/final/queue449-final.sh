#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/449
lock=/home/david/buster-fast-bench/exclusive.sh
mkdir -p logs/449-final
test ! -e logs/449-final/campaign-started
date -Is > logs/449-final/campaign-started
export EXCLUSIVE_TITLE='Final #449 source identity and label-dispatch acceptance'
"$lock" bash held.sh bash provenance449-final.sh > logs/449-final/provenance-before.log 2>&1
"$lock" bash held.sh taskset -c 2 bash acceptance449-final.sh > logs/449-final/label-dispatch-acceptance.log 2>&1
export EXCLUSIVE_TITLE='Final #449 driver preflight'
"$lock" bash held.sh timeout --signal=TERM --kill-after=1s 55s bash group449-final.sh preflight > logs/449-final/group-preflight.log 2>&1
for round in 1 2 3 4 5; do
    export EXCLUSIVE_TITLE="Final #449 paired group $round: approved 60-second cap"
    "$lock" bash held.sh timeout --signal=TERM --kill-after=1s 55s bash group449-final.sh "$round" > "logs/449-final/group-$round.log" 2>&1
    printf '%s passed\n' "$round"
done
export EXCLUSIVE_TITLE='Final #449 post-measurement source identity'
"$lock" bash held.sh bash provenance449-final.sh > logs/449-final/provenance-after.log 2>&1
