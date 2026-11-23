#!/bin/bash
# Step 0's gauge on a tree: counted and sampled, one hold of the lock each.
set -euo pipefail
dir=~/buster-fast-bench/2536-claude-kcl1ed
name=${1:?tree name}
out=${2:?out name}
shift 2
cd "$dir/$name"
export EXCLUSIVE_OWNER=claude-2536-kcl1ed
export EXCLUSIVE_TITLE="#2536: the all-core path, the gauge"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2536
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
gauge="$dir/results/$out"
mkdir -p "$gauge"
command=(./build/compiler --time-stages --lanes 1 -c "$@" -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c" -o "$gauge/%l.w%w.o")
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; cat /proc/loadavg; } > "$gauge/before.txt"
~/buster-fast-bench/exclusive.sh build/allcore counted --out "$gauge" -- "${command[@]}" 2> "$gauge/counted.err"
~/buster-fast-bench/exclusive.sh build/allcore sampled --out "$gauge" -- "${command[@]}" 2> "$gauge/sampled.err"
{ ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; cat /proc/loadavg; } > "$gauge/after.txt"
build/allcore table --out "$gauge" --bytes 9507037 > "$gauge/table.out" 2>&1
sha256sum "$gauge"/*.o | awk '{print $1}' | sort | uniq -c > "$gauge/objects.txt"
echo GAUGE-DONE
