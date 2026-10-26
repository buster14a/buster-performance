#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/450
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
lock=/home/david/buster-fast-bench/exclusive.sh
# Preserve successful completed work; the first SQLite attempt rejected --predefines before processing a file.
for log in provenance-before fixtures c-testsuite; do
    grep -q '^exit=0 end:' "logs/450-final-acceptance/$log.log"
done
if compgen -G 'logs/450-final/paired-*.log' > /dev/null; then exit 2; fi
export EXCLUSIVE_TITLE='Final #450 SQLite acceptance: documented corpus options'
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
"$lock" bash held.sh taskset -c 0-7 head450-final/build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc \
    -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" \
    -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > logs/450-final-acceptance/sqlite-retry.log 2>&1
for batch in paired-1-3 paired-4-5 sweep-0 sweep-1 sweep-2; do
    export EXCLUSIVE_TITLE="Final #450 $batch: approved 60-second cap"
    "$lock" bash held.sh timeout --signal=TERM --kill-after=1s 55s bash batch450-final.sh "$batch" > "logs/450-final/group-$batch.log" 2>&1
    printf '%s passed\n' "$batch"
done
export EXCLUSIVE_TITLE='Final #450 post-measurement source identity'
"$lock" bash held.sh bash provenance450-final.sh > logs/450-final-acceptance/provenance-after.log 2>&1
printf 'excluded 00078.c: pre-existing source-order fallback; included in correctness acceptance\n' > logs/450-final/excluded.txt
