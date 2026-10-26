#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/450
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
lock=/home/david/buster-fast-bench/exclusive.sh
mkdir -p logs/450-cold
test ! -e logs/450-cold/campaign-started
date -Is > logs/450-cold/campaign-started
for batch in paired-1-3 paired-4-5 sweep-0 sweep-1 sweep-2; do
    export EXCLUSIVE_TITLE="Cold utility #450 $batch: approved 60-second cap"
    "$lock" bash held.sh timeout --signal=TERM --kill-after=1s 55s bash batch450-cold.sh "$batch" > "logs/450-cold/group-$batch.log" 2>&1
    printf '%s passed\n' "$batch" >&2
done
printf 'excluded 00078.c: pre-existing source-order fallback; included in correctness acceptance\n' > logs/450-cold/excluded.txt
export EXCLUSIVE_TITLE='Collect #450 cold utility evidence and post-measurement identity'
"$lock" bash collect450-cold.sh
