#!/bin/bash
# compile.sh TREE...: what each TREE's --tier1 costs a compile of the frozen sqlite3.c (the 9700X job's options), one
# lane, pinned to CPU 2, seven runs each in rotation after a warm-up: each run's wall, user and system seconds and peak
# RSS (runrss), and its user cycles and instructions (perf stat); each tree's object's .text and --tier1-report. The
# design record's proto-compile.sh, by tree. Run inside one hold of the lock. results/compile/{runs.tsv,perf.tsv,
# report-TREE.txt,sizes.txt}.
set -u
cd "$(dirname "$0")"
root=$PWD
out=$root/results/compile
mkdir -p "$out"
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
head -1 /var/lib/buster-9700x/owner >> "$out/holders.txt"
runrss=$HOME/buster-fast-bench/138-tier1-quality-claude/runrss
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options=(--lanes 1 --tier1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
tmp=$(mktemp -d /tmp/claude-2541-step1-compile.XXXXXX)
for round in 0 1 2 3 4 5 6 7; do
    for tree in "$@"; do
        file=$out/runs.tsv; [ $round = 0 ] && file=$tmp/warmup.tsv
        "$runrss" "$file" "$tree" taskset -c 2 "$root/$tree/build/compiler" "${options[@]}" -o "$tmp/$tree.o" > /dev/null 2>&1
        taskset -c 2 perf stat -x, -o "$tmp/stat.csv" -e task-clock,cycles:u,instructions:u -- "$root/$tree/build/compiler" "${options[@]}" -o "$tmp/$tree.o" > /dev/null 2>&1
        awk -F, -v r="$round" -v t="$tree" '$3 ~ /task-clock/ { clock = $1 } $3 ~ /cycles/ { cycles = $1 } $3 ~ /instructions/ { instructions = $1 }
            END { printf "%s\t%s\t%s\t%s\t%s\n", r, t, clock, cycles, instructions }' "$tmp/stat.csv" >> "$out/perf.tsv"
    done
done
for tree in "$@"; do
    "$root/$tree/build/compiler" --tier1-report "${options[@]}" -o "$tmp/$tree.o" > "$out/report-$tree.txt" 2>&1
    size -A "$tmp/$tree.o" | awk -v n="$tree" '$1 == ".text" { print n " .text " $2 }' >> "$out/sizes.txt"
done
rm -rf "$tmp"
date -u +%FT%TZ > "$out/done"
