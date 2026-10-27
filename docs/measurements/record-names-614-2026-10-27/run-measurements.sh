#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Original invocation glue for Buster's retained C time-runs harness.
set -euo pipefail
cd "$(dirname "$0")"
root=$(pwd)
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
export EXCLUSIVE_OWNER=codex-614
export EXCLUSIVE_TITLE='Solve 614: record namespace syntax-only comparison'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/614
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
while [ ! -x "$root/../head/build/compiler" ]; do sleep 5; done
# With no argument, reproduce qualification and both comparisons. The conditioned comparison can also queue
# independently after the same binary has passed the complete checker suite.
rounds=(1 4)
if [ "${1-}" = conditioned ]; then
    grep -Eq '^test-checker: [1-9][0-9]* checks, 0 failures$' "$root/checker-9700x.log"
    rounds=(4)
else
    test "$#" = 0
    ~/buster-fast-bench/exclusive.sh bash -c 'exec "$1" test-checker > "$2" 2>&1' checker \
        "$root/../head/build/compiler" "$root/checker-9700x.log"
fi
builds=(--build base "$root/../base/build/compiler" --build head "$root/../head/build/compiler" --build base-again "$root/../base/build/compiler")
lists=()
for n in 2000 4000 8000; do
    lists+=(--list --lanes 1 -fsyntax-only "$root/nested-$n.c")
done
lists+=(--list --lanes 1 -fsyntax-only -std=gnu17 --target=x86_64-linux-gnu -march=znver5
    -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE
    -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include"
    "-I$corpus/sqlite" "$corpus/sqlite/sqlite3.c")
for round in "${rounds[@]}"; do
    conditioning=0
    runs=7
    if [ "$round" = 4 ]; then conditioning=200; runs=3; fi
    # stdout belongs to time-runs alone. Lock-wait diagnostics stay outside the retained measurement log.
    ~/buster-fast-bench/exclusive.sh taskset -c 2 "$root/../head/build/compiler" time-runs --runs "$runs" --copies 2 --after-scalar "$conditioning" \
        "${builds[@]}" "${lists[@]}" > "$root/round-$round.log"
    grep -q '^time-runs: done, 0 failed processes' "$root/round-$round.log"
    if grep -Eq 'status (-1|[1-9])|FAILED' "$root/round-$round.log"; then exit 1; fi
done
