#!/bin/bash
# objects-checked.sh BASE HEAD OUT: objects.sh, checked (round 8). OUT must be new; any compile's failure ends the hold
# with its status, which the script returns; a differing object fails it after all four comparisons are printed.
set -euo pipefail
cd ~/buster-fast-bench/claude-628
base=$1 head=$2 out=$3
mkdir "$out"
export EXCLUSIVE_OWNER=claude-628 EXCLUSIVE_TITLE="Problem 628 529" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/628
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
hold=0
~/buster-fast-bench/exclusive.sh bash -c '
  set -euo pipefail
  base=$1 head=$2 out=$3 sqlite=$4
  options=(-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sqlite" "$sqlite/sqlite3.c")
  for tree in "$base" "$head"; do
    name=$(basename "$tree")
    taskset -c 2 "$tree/build/compiler" "${options[@]}" -o "$out/$name.o" --time-stages 2> "$out/$name.stages"; echo "$name default 0"
    taskset -c 2 "$tree/build/compiler" "${options[@]}" -o "$out/$name-scalar.o" --scalar; echo "$name scalar 0"
    "$tree/build/compiler" "${options[@]}" -o "$out/$name-lanes.o" --lanes 8; echo "$name lanes 0"
    taskset -c 2 "$tree/build/compiler" "${options[@]}" -g -o "$out/$name-g.o"; echo "$name g 0"
  done
' objects "$base" "$head" "$out" "$sqlite" 2>&1 | { grep -v '^\(exclusive.sh\|  title:\|  link:\|  pull request:\)' || true; } || hold=$?
echo "hold: status $hold"
[ "$hold" = 0 ] || exit "$hold"
differ=0
for v in "" -scalar -lanes -g; do
  if cmp "$out/$(basename $base)$v.o" "$out/$(basename $head)$v.o"; then echo "same$v"; else echo "differ$v"; differ=1; fi
done
grep "peak-rss-kb\|time-stage	check-input\|time-stage	total\|system-ms" "$out"/*.stages
[ "$differ" = 0 ] || exit 1
echo done
