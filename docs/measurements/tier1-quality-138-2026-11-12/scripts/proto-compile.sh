#!/bin/bash
# proto-compile.sh NAME=ENV[,ENV...]...: what the prototype's way of inlining costs a compile (an upper bound: it
# prepares every callee again for every caller, where the design shares one summary per callee): --tier1 -c of the
# frozen sqlite3.c by src-proto's compiler under each NAME's environment ("base=" is none), one lane, pinned to CPU 2,
# five runs each in rotation after a warm-up; each run's wall, user and system seconds and peak RSS (runrss), each
# variant's object's .text and --tier1-report. Run inside one hold of the lock. results/proto/compile-runs.tsv,
# compile-report-NAME.txt, compile-sizes.txt.
set -u
cd "$(dirname "$0")"
root=$PWD
out=$root/results/proto
mkdir -p "$out"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
test -x "$root/runrss" || cc -O2 -o "$root/runrss" "$root/tools/runrss.c"
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(--lanes 1 --tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
tmp=$(mktemp -d /tmp/claude-tier1-quality-protoc.XXXXXX)
compiler=$root/src-proto/build/compiler
for round in 0 1 2 3 4 5; do
    for pair in "$@"; do
        name=${pair%%=*}; IFS=, read -r -a environment <<< "${pair#*=}"
        file=$out/compile-runs.tsv; [ $round = 0 ] && file=$tmp/warmup.tsv
        env "${environment[@]}" "$root/runrss" "$file" "$name" taskset -c 2 "$compiler" "${options[@]}" -o "$tmp/$name.o" > /dev/null 2>&1
    done
done
for pair in "$@"; do
    name=${pair%%=*}; IFS=, read -r -a environment <<< "${pair#*=}"
    env "${environment[@]}" "$compiler" --tier1-report "${options[@]}" -o "$tmp/$name.o" > "$out/compile-report-$name.txt" 2>&1
    size -A "$tmp/$name.o" | awk -v n="$name" '$1 == ".text" { print n " .text " $2 }' >> "$out/compile-sizes.txt"
done
rm -rf "$tmp"
date -u +%FT%TZ > "$out/compile.done"
