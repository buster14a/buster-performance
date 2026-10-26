#!/bin/bash
# The initializers' A/B (abc4): perf stat of benchmark-checker-source itself, a run per lock hold, three per tree in
# turn, to tell the body graph's work from where its code lands.
set -u
export EXCLUSIVE_OWNER=claude-126 EXCLUSIVE_TITLE="solve #126: initializers A/B (body graph counters)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/126
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
source=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --clang-features --no-default-config --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
cd ~/buster-fast-bench/solve-126-claude/abc4
for round in 1 2 3; do
    for tree in base head; do
        echo "== round $round tree $tree"
        $lock perf stat -x, -e instructions:u,cycles:u taskset -c 2 $tree/build/compiler benchmark-checker-source "${source[@]}" 2>&1 >/dev/null | grep -v "^exclusive.sh:\|^  title:\|^  link:\|^  pull request:"
    done
done
echo done
