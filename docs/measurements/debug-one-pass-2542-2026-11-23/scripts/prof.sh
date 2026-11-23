#!/bin/bash
tree=$1; tag=$2
c=$tree/build/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sh="-DSQLITE_DQS=0 -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_RTREE -DSQLITE_ENABLE_EXPLAIN_COMMENTS -DSQLITE_ENABLE_UNKNOWN_SQL_FUNCTION -DSQLITE_ENABLE_STMTVTAB -DSQLITE_ENABLE_DBPAGE_VTAB -DSQLITE_ENABLE_DBSTAT_VTAB -DSQLITE_ENABLE_BYTECODE_VTAB -DSQLITE_ENABLE_OFFSET_SQL_FUNC -DSQLITE_ENABLE_PERCENTILE -DSQLITE_STRICT_SUBTYPE=1 -DSQLITE_ENABLE_MATH_FUNCTIONS -I$sqlite"
out=/tmp/2542-claude/$tag; mkdir -p $out
export XDG_CACHE_HOME=/tmp/2542-claude/cache LC_ALL=C
for g in plain g; do
  gf=; [ $g = g ] && gf=-g
  taskset -c 2 perf record -q -F 20000 -o $out/perf-$g.data -- sh -c "for i in 1 2 3 4 5; do $c $sh $gf --lanes 1 -c $sqlite/sqlite3.c -o $out/x-$g.o; done" 2>/dev/null
  perf report -i $out/perf-$g.data --no-children --sort sym --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -70 > $out/report-$g.txt
done
