#!/bin/bash
# objects.sh BASE HEAD OUT: -c of sqlite3.c by both trees, default, --scalar and --lanes 8, then -g; one hold.
set -u
cd ~/buster-fast-bench/claude-628 || exit 1
base=$1 head=$2 out=$3
mkdir -p "$out"
export EXCLUSIVE_OWNER=claude-628 EXCLUSIVE_TITLE="Problem 628 529" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
~/buster-fast-bench/exclusive.sh bash -c '
  base=$1 head=$2 out=$3 sqlite=$4
  options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for tree in "$base" "$head"; do
    name=$(basename "$tree")
    taskset -c 2 "$tree/build/compiler" "${options[@]}" -o "$out/$name.o" --time-stages 2> "$out/$name.stages"; echo "$name default $?"
    taskset -c 2 "$tree/build/compiler" "${options[@]}" -o "$out/$name-scalar.o" --scalar; echo "$name scalar $?"
    "$tree/build/compiler" "${options[@]}" -o "$out/$name-lanes.o" --lanes 8; echo "$name lanes $?"
    taskset -c 2 "$tree/build/compiler" "${options[@]}" -g -o "$out/$name-g.o"; echo "$name g $?"
  done
' objects "$base" "$head" "$out" "$sqlite"
for v in "" -scalar -lanes -g; do
  cmp "$out/$(basename $base)$v.o" "$out/$(basename $head)$v.o" && echo "same$v"
done
grep "peak-rss-kb\|time-stage	check-input\|time-stage	total\|system-ms" "$out"/*.stages
echo done
