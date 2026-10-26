#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/450
lock=/home/david/buster-fast-bench/exclusive.sh
mkdir -p logs/450-final logs/450-final-acceptance
test ! -e logs/450-final/campaign-started
date -Is > logs/450-final/campaign-started
export EXCLUSIVE_TITLE='Final #450 correctness acceptance, exact e2de00e'
"$lock" bash held.sh bash provenance450-final.sh > logs/450-final-acceptance/provenance-before.log 2>&1
"$lock" bash held.sh taskset -c 0-7 head450-final/build/compiler test-checker-deferred > logs/450-final-acceptance/fixtures.log 2>&1
"$lock" bash held.sh taskset -c 0-7 head450-final/build/compiler test-checker-corpus --deferred 8 /home/david/buster-fast-bench/deferred-lanes-claude/c-testsuite/tests/single-exec > logs/450-final-acceptance/c-testsuite.log 2>&1
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
"$lock" bash held.sh taskset -c 0-7 head450-final/build/compiler test-checker-corpus --deferred 8 --symbols \
    --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features -march=znver5 -std=gnu17 -nostdinc \
    -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" \
    -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > logs/450-final-acceptance/sqlite.log 2>&1
group()
{
    local mode=$1 number=$2
    export EXCLUSIVE_TITLE="Final #450 $mode group $number: approved 60-second cap"
    # timeout controls the process group; kills remaining children before the actual shared lock is released.
    "$lock" bash held.sh timeout --signal=TERM --kill-after=1s 55s bash group450-final.sh "$mode" "$number" > "logs/450-final/group-$mode-$number.log" 2>&1
    printf '%s %s passed\n' "$mode" "$number"
}
for round in 1 2 3 4 5; do group paired "$round"; done
for batch in 0 1 2 3 4 5 6; do group sweep "$batch"; done
export EXCLUSIVE_TITLE='Final #450 post-measurement source identity'
"$lock" bash held.sh bash provenance450-final.sh > logs/450-final-acceptance/provenance-after.log 2>&1
printf 'excluded 00078.c: pre-existing source-order fallback; included in correctness acceptance\n' > logs/450-final/excluded.txt
