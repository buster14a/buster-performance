#!/bin/bash
# stages.sh TREE TAG RUNS: SQLite's shell to an executable, with and without -g, one lane (CPU 2) and 7 lanes, --time-stages.
tree=$1; tag=$2; runs=${3:-7}
c=$tree/build/compiler
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
sh="-DSQLITE_DQS=0 -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_EXPLAIN_COMMENTS -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION -DSQLITE_ENABLE_STMTVTAB -DSQLITE_ENABLE_DBPAGE_VTAB -DSQLITE_ENABLE_DBSTAT_VTAB -DSQLITE_ENABLE_BYTECODE_VTAB -DSQLITE_ENABLE_OFFSET_SQL_FUNC -DSQLITE_ENABLE_PERCENTILE -DSQLITE_STRICT_SUBTYPE=1 -DSQLITE_ENABLE_MATH_FUNCTIONS -I$sqlite"
out=/tmp/2540-claude/$tag; mkdir -p $out
export XDG_CACHE_HOME=/tmp/2540-claude/cache LC_ALL=C
cat /proc/loadavg > $out/load-before.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head > $out/ps-before.txt
for i in $(seq 1 $runs); do
  for g in plain g; do
    gf=; [ $g = g ] && gf=-g
    taskset -c 2 $c $sh $gf --lanes 1 --time-stages $sqlite/shell.c $sqlite/sqlite3.c -lm -o $out/sqlite3-1-$g 2> $out/l1-$g-$i.err
    taskset -c 1-7 $c $sh $gf --lanes 7 --time-stages $sqlite/shell.c $sqlite/sqlite3.c -lm -o $out/sqlite3-7-$g 2> $out/l7-$g-$i.err
  done
done
cat /proc/loadavg > $out/load-after.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head > $out/ps-after.txt
echo 'select 6*7, sqlite_version(), sqrt(2.0);' | $out/sqlite3-1-g > $out/run.txt
