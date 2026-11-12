#!/bin/bash
# exp-compile.sh: what the experiment's way of inlining costs a compile: --tier1 -c of the frozen sqlite3.c by
# src-exp's compiler without the switch and with BUSTER_EXP_INLINE_STATIC=32 and 64, pinned to CPU 2, seven runs each in
# rotation after a warm-up, each run's wall, user and system seconds and peak RSS (runrss), and each variant's
# --tier1-report. Run inside one hold of the lock. results/exp/compile-runs.tsv, compile-report-*.txt.
set -u
cd "$(dirname "$0")"
root=$PWD
out=$root/results/exp
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
test -x "$root/runrss" || cc -O2 -o "$root/runrss" "$root/tools/runrss.c"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(--tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
tmp=$(mktemp -d /tmp/claude-tier1-quality-expc.XXXXXX)
compiler=$root/src-exp/build/compiler
for round in 0 1 2 3 4 5 6 7; do
    for v in 0 32 64; do
        file=$out/compile-runs.tsv; [ $round = 0 ] && file=$tmp/warmup.tsv
        if [ $v = 0 ]; then
            "$root/runrss" "$file" "base" taskset -c 2 "$compiler" "${options[@]}" -o "$tmp/x.o" > /dev/null 2>&1
        else
            BUSTER_EXP_INLINE_STATIC=$v "$root/runrss" "$file" "s$v" taskset -c 2 "$compiler" "${options[@]}" -o "$tmp/x.o" > /dev/null 2>&1
        fi
    done
done
"$compiler" --tier1-report "${options[@]}" -o "$tmp/x.o" > "$out/compile-report-base.txt" 2>&1
BUSTER_EXP_INLINE_STATIC=32 "$compiler" --tier1-report "${options[@]}" -o "$tmp/x.o" > "$out/compile-report-s32.txt" 2>&1
BUSTER_EXP_INLINE_STATIC=64 "$compiler" --tier1-report "${options[@]}" -o "$tmp/x.o" > "$out/compile-report-s64.txt" 2>&1
rm -rf "$tmp"
date -u +%FT%TZ > "$out/compile.done"
