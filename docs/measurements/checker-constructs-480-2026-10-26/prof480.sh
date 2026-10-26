#!/bin/bash
# #480: where the whole -fsyntax-only's cycles go on the frozen sqlite3.c, base and head, ten processes per profile,
# each profile under its own hold of the shared lock, pinned to CPU 2.
set -u
cd ~/buster-fast-bench/solve-126-claude/ab480
export EXCLUSIVE_OWNER=claude-126 EXCLUSIVE_TITLE="solve #126: #480 A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/480
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
args="--predefines $corpus/provenance/gnu17-pinned-predefines.txt --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $corpus/headers/usr/lib/clang/23/include -isystem $corpus/headers/usr/local/include -isystem $corpus/headers/usr/include $corpus/sqlite/sqlite3.c"
for tree in base head; do
    $lock perf record -q -e cycles:u -c 200003 -o $tree.perf.data -- bash -c "for i in 1 2 3 4 5 6 7 8 9 10; do taskset -c 2 $tree/build/compiler -fsyntax-only $args > /dev/null; done" > /dev/null 2>&1
    perf report -q --stdio --sort symbol -i $tree.perf.data 2>/dev/null | head -45 > $tree.perf.txt
    echo "profiled $tree"
done
echo done
