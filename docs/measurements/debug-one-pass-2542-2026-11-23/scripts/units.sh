#!/bin/bash
# units.sh TREE TAG RUNS: -c of sqlite3.c and shell.c with/without -g, one lane on CPU 2, --time-stages.
tree=$1; tag=$2; runs=${3:-5}
c=$tree/build/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sh="-DSQLITE_DQS=0 -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_EXPLAIN_COMMENTS -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION -DSQLITE_ENABLE_STMTVTAB -DSQLITE_ENABLE_DBPAGE_VTAB -DSQLITE_ENABLE_DBSTAT_VTAB -DSQLITE_ENABLE_BYTECODE_VTAB -DSQLITE_ENABLE_OFFSET_SQL_FUNC -DSQLITE_ENABLE_PERCENTILE -DSQLITE_STRICT_SUBTYPE=1 -DSQLITE_ENABLE_MATH_FUNCTIONS -I$sqlite"
out=/tmp/2542-claude/$tag; mkdir -p $out
export XDG_CACHE_HOME=/tmp/2542-claude/cache LC_ALL=C
cat /proc/loadavg > $out/load-before.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head > $out/ps-before.txt
for i in $(seq 1 $runs); do
  for u in sqlite3 shell; do
    for g in plain g; do
      gf=; [ $g = g ] && gf=-g
      taskset -c 2 $c $sh $gf --lanes 1 --time-stages -c $sqlite/$u.c -o $out/$u-$g.o 2> $out/c-$u-$g-$i.err
    done
  done
done
cat /proc/loadavg > $out/load-after.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head > $out/ps-after.txt
