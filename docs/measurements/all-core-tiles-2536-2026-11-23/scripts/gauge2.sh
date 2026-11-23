#!/bin/bash
# Step 0's gauge on a tree, with the host's 64 KB page switch and the compiler's page setting as asked.
# gauge2.sh TREE OUT SWITCH PAGES [extra compiler options...]   PAGES: default, or a BUSTER_HUGE_PAGES value
set -euo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
name=${1:?tree name}
out=${2:?out name}
switch=${3:?never or madvise}
pages=${4:?default or a BUSTER_HUGE_PAGES value}
shift 4
cd "$dir/$name"
export EXCLUSIVE_OWNER=claude-2536-kcl1ed
export EXCLUSIVE_TITLE="#2536: the all-core path, the gauge with 64 KB pages"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
if [ "$pages" != default ]; then export BUSTER_HUGE_PAGES="$pages"; fi
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
gauge="$dir/results/$out"
mkdir -p "$gauge"
command=(./build/compiler --time-stages --lanes 1 -c "$@" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$gauge/%l.w%w.o")
~/buster-fast-bench/exclusive.sh "$dir/hold2.sh" "$switch" counted "$gauge" -- "${command[@]}" 2> "$gauge/counted.err"
~/buster-fast-bench/exclusive.sh "$dir/hold2.sh" "$switch" sampled "$gauge" -- "${command[@]}" 2> "$gauge/sampled.err"
build/allcore table --out "$gauge" --bytes 9507037 > "$gauge/table.out" 2>&1
sha256sum "$gauge"/*.o | awk '{print $1}' | sort | uniq -c > "$gauge/objects.txt"
echo "GAUGE-DONE $out"
