#!/bin/bash
# #817's -c instruction cost, -c alone: main 5655370 (base), its A/A copy (aa), #817's head ff2b8e0 (head2), and two
# variants of it (v1: the bit-cast test behind an inline class test; v2: the bit-cast test removed), abH's builds. perf
# stat's user instructions and cycles of -c of the frozen sqlite3.c, 11 runs, in three rounds whose order rotates. Every
# run takes the 9700X's lock on its own and runs pinned to CPU 2.
set -u
export EXCLUSIVE_OWNER=claude-126-cloud EXCLUSIVE_TITLE="solve #126 (cloud session): #817's -c instruction cost, variants" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/817
lock=~/buster-fast-bench/exclusive.sh
unset CPATH C_INCLUDE_PATH BUSTER_ORACLE_CACHE
here=~/buster-fast-bench/claude-126-cloud/abH
export TMPDIR=$here/tmp
export SOURCE_DATE_EPOCH=1792454400
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
system=(-nostdinc -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include")
lower=(--predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 "${system[@]}" "$corpus/sqlite/sqlite3.c")
cd "$here"
order=(base aa head2 v1 v2)
for round in 1 2 3; do
    for i in "${!order[@]}"; do
        tree=${order[$(( (i + round - 1) % ${#order[@]} ))]}
        echo "== round $round tree $tree lower" >> perf2.log
        $lock perf stat -x, -e instructions:u,cycles:u,task-clock -r 11 taskset -c 2 $tree/build/compiler -c -o /dev/null "${lower[@]}" 2>> perf2.log >/dev/null
    done
done
echo "perf done"
sha256sum base/build/compiler aa/build/compiler head2/build/compiler v1/build/compiler v2/build/compiler lower_*.o > inputs2.sha256
echo done
