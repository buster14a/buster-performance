#!/bin/bash
# test-checker-corpus --deferred 8 of a tree (as the 9700X job runs it): c-testsuite's single-exec programs with
# --id-order 153, and the frozen sqlite3.c with --symbols, each a lock hold, into logs/tests-TREE.txt. Arguments: TREE.
. ~/buster-fast-bench/claude-764/scripts/env.sh
tree="$1"
L="$D/logs/tests-$tree.txt"
bin="$D/trees/$tree/build/compiler"
echo "== $(date -Is) test-checker-corpus --deferred 8 c-testsuite $tree" >> "$L"
~/buster-fast-bench/exclusive.sh "$bin" test-checker-corpus --clang /usr/bin/clang --deferred 8 --id-order 153 \
    /home/david/buster-fast-bench/claude-435/c-testsuite/tests/single-exec >> "$L" 2>&1
echo "exit=$? $(date -Is)" >> "$L"
echo "== $(date -Is) test-checker-corpus --deferred 8 sqlite3.c $tree" >> "$L"
~/buster-fast-bench/exclusive.sh "$bin" test-checker-corpus --clang /usr/bin/clang --deferred 8 --symbols --report "$D/logs/checker-sqlite-$tree.tsv" \
    --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" \
    -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c" >> "$L" 2>&1
echo "exit=$? $(date -Is)" >> "$L"
