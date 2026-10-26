#!/bin/bash
set -euo pipefail
cd /home/david/buster-fast-bench/codex-449-450-451-20261026
export EXCLUSIVE_OWNER=codex-449-450-451
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/450
export EXCLUSIVE_TITLE='Cold utility #450: exact candidate correctness and identity'
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
lock=/home/david/buster-fast-bench/exclusive.sh
mkdir -p logs/450-cold-acceptance
"$lock" bash held.sh bash provenance450-cold.sh > logs/450-cold-acceptance/provenance-before.log 2>&1
"$lock" bash held.sh taskset -c 0-7 head450-cold/build/compiler test-lanes > logs/450-cold-acceptance/lanes.log 2>&1
"$lock" bash held.sh taskset -c 0-7 head450-cold/build/compiler test-checker-deferred > logs/450-cold-acceptance/fixtures.log 2>&1
"$lock" bash held.sh taskset -c 0-7 head450-cold/build/compiler test-checker-corpus --deferred 8 /home/david/buster-fast-bench/deferred-lanes-claude/c-testsuite/tests/single-exec > logs/450-cold-acceptance/c-testsuite.log 2>&1
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
"$lock" bash held.sh taskset -c 0-7 head450-cold/build/compiler test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc \
    -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" \
    -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" > logs/450-cold-acceptance/sqlite.log 2>&1
printf 'All native cold utility acceptance commands passed.\n'
