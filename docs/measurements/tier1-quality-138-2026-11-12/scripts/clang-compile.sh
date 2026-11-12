#!/bin/bash
# clang-compile.sh: what clang takes for the unit the compile-time figures use: -c of the frozen sqlite3.c with the
# 9700X job's options at -O2, -O1 and -O0, pinned to CPU 2, three runs each after one warm-up (runrss: wall, user and
# system seconds, peak RSS). Run inside one hold of the lock. results/inventory/clang-compile-runs.tsv.
set -u
cd "$(dirname "$0")"
root=$PWD
out=$root/results/inventory
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner > "$out/clang-compile.holder.txt"
test -x "$root/runrss" || cc -O2 -o "$root/runrss" "$root/tools/runrss.c"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(-c -w -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
tmp=$(mktemp -d /tmp/claude-tier1-quality-clangc.XXXXXX)
clang --version | head -1 > "$out/clang-compile-version.txt"
taskset -c 2 clang -O0 "${options[@]}" -o "$tmp/x.o" > /dev/null 2>&1
for run in 1 2 3; do
    for level in O2 O1 O0; do
        "$root/runrss" "$out/clang-compile-runs.tsv" "clang -$level" taskset -c 2 clang "-$level" "${options[@]}" -o "$tmp/x.o" > /dev/null 2>&1
    done
done
rm -rf "$tmp"
date -u +%FT%TZ > "$out/clang-compile.done"
