#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/450
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
lock=/home/david/buster-fast-bench/exclusive.sh
mkdir -p logs/450-check logs/450-check-acceptance
test ! -e logs/450-check/campaign-started
date -Is > logs/450-check/campaign-started
export EXCLUSIVE_TITLE='Affinity #450 phase: exact 63844208 correctness and identity'
"$lock" bash held.sh bash provenance450-check.sh > logs/450-check-acceptance/provenance-before.log 2>&1
"$lock" bash held.sh taskset -c 0-7 head450-check/build/compiler test-lanes > logs/450-check-acceptance/lanes.log 2>&1
"$lock" bash held.sh taskset -c 0-7 head450-check/build/compiler test-checker-deferred > logs/450-check-acceptance/fixtures.log 2>&1
"$lock" bash held.sh taskset -c 0-7 head450-check/build/compiler test-checker-corpus --deferred 8 /home/david/buster-fast-bench/deferred-lanes-claude/c-testsuite/tests/single-exec > logs/450-check-acceptance/c-testsuite.log 2>&1
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
"$lock" bash held.sh taskset -c 0-7 head450-check/build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc \
    -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" \
    -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > logs/450-check-acceptance/sqlite.log 2>&1
for batch in paired-1-3 paired-4-5 sweep-0 sweep-1 sweep-2; do
    export EXCLUSIVE_TITLE="Affinity #450 $batch: approved 60-second cap"
    "$lock" bash held.sh timeout --signal=TERM --kill-after=1s 55s bash batch450-check.sh "$batch" > "logs/450-check/group-$batch.log" 2>&1
    printf '%s passed\n' "$batch"
done
for round in 1 2 3; do
    export EXCLUSIVE_TITLE="Affinity #450 general lanes pair $round: approved 60-second cap"
    "$lock" bash held.sh timeout --signal=TERM --kill-after=1s 55s bash lanes450-check.sh "$round" > "logs/450-check/group-lanes-$round.log" 2>&1
    printf 'lanes %s passed\n' "$round"
done
export EXCLUSIVE_TITLE='Affinity #450 post-measurement source identity'
"$lock" bash held.sh bash provenance450-check.sh > logs/450-check-acceptance/provenance-after.log 2>&1
printf 'excluded 00078.c: pre-existing source-order fallback; included in correctness acceptance\n' > logs/450-check/excluded.txt
