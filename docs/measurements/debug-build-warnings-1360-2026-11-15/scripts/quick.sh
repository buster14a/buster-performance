#!/bin/bash
# quick.sh COMPILER LABEL REPS: sqlite3.c variants and Lua, CPU 2, inside one hold; prints label workload rep total check-program instructions cycles.
set -u
X=$1; L=$2; R=${3:-5}
cd ~/buster-fast-bench/1360-claude
mkdir -p out
SQ=inputs/sqlite3.c
SQOPTS="-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
w=( "sq-ci|$SQOPTS $SQ" "sq-ci-w|$SQOPTS -w $SQ" "sq-debug|$SQOPTS -DSQLITE_DEBUG $SQ" "sq-debug-w|$SQOPTS -DSQLITE_DEBUG -w $SQ" )
for ((r = 1; r <= R; r++)); do
  for e in "${w[@]}"; do
    n=${e%%|*}; a=${e#*|}
    perf stat -x, -e instructions:u,cycles:u -o out/$n-$L.perf taskset -c 2 $X $a -o out/$n-$L.o --time-stages > out/$n-$L.stdout 2> out/$n-$L.stderr
    s=$?
    c=$(awk -F, '$3=="instructions:u"{i=$1} $3=="cycles:u"{c=$1} END{printf "%s\t%s", i, c}' out/$n-$L.perf)
    t=$(awk '$1=="time-stage"&&$2=="total"{t=$3} $1=="time-stage"&&$2=="check-program"{c=$3} END{printf "%s\t%s", t, c}' out/$n-$L.stderr)
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$L" "$n" "$r" "$s" "$t" "$c"
  done
done
