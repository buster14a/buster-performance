#!/bin/bash
set -eu
export EXCLUSIVE_OWNER=codex-489 EXCLUSIVE_TITLE='Buster #489 controlled runtime comparison' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/489
D=$HOME/buster-fast-bench/codex-489-control
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D"
mkdir -p controlled/tmp controlled/base-cache controlled/candidate-cache controlled/logs
export TMPDIR=$D/controlled/tmp
for mode in base candidate; do
    if [ "$mode" = base ]; then qualifier=(env BUSTER_GCC_S_489_CONTROL=1); else qualifier=(env -u BUSTER_GCC_S_489_CONTROL); fi
    "$X" taskset -c 2 "${qualifier[@]}" ./build/compiler benchmark-snapshot --only dynamic --directory "$D/controlled/tmp" > "controlled/logs/snapshot-$mode.log" 2>"controlled/logs/snapshot-$mode.stderr"
    echo "$mode snapshot PASS"
done
grep -q 'The dynamic runtime: 20 probes, 3387 global names' controlled/logs/snapshot-base.log
grep -q 'The dynamic runtime: 23 probes, 3432 global names' controlled/logs/snapshot-candidate.log
last_round=${BUSTER_GCC_S_489_ROUNDS:-1}
for ((round = 1; round <= last_round; round += 1)); do
    order='base candidate'
    [ "$round" != 2 ] || order='candidate base'
    for mode in $order; do
        if [ "$mode" = base ]; then qualifier=(env BUSTER_GCC_S_489_CONTROL=1); else qualifier=(env -u BUSTER_GCC_S_489_CONTROL); fi
        "$X" "${qualifier[@]}" ./build/compiler benchmark-link --only direct --kinds dynamic,shared --directory "$D/controlled/tmp" --cache "$D/controlled/$mode-cache" > "controlled/logs/link-$mode-$round.log" 2>"controlled/logs/link-$mode-$round.stderr"
        echo "$mode link $round PASS"
    done
done
echo 'controlled comparison done'
