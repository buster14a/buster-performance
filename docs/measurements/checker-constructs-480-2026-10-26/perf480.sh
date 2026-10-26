#!/bin/bash
# #480: user instructions and cycles of the whole -fsyntax-only on the frozen sqlite3.c, base and head in turn, three
# rounds, each run under its own hold of the shared lock, pinned to CPU 2.
set -u
cd ~/buster-fast-bench/solve-126-claude/ab480
export EXCLUSIVE_OWNER=claude-126 EXCLUSIVE_TITLE="solve #126: #480 A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/480
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
driver=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c")
for round in 1 2 3; do
    for tree in base head; do
        echo "== round $round tree $tree"
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -fsyntax-only "${driver[@]}" 2>&1 >/dev/null | grep -v "^exclusive.sh:\|^  title:\|^  link:\|^  pull request:"
    done
done
echo done
