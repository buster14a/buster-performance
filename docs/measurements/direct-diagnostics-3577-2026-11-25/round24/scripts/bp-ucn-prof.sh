#!/bin/bash
# bp-ucn-prof.sh: where the merge's, the head's and the gated variant's cycles land: cycles:u every 100,000 (below the
# 9700X's 63,300/s sampling limit at this rate) over 100 compiles of sqlite3.c each, in one hold; per-symbol totals.
D=$HOME/buster-fast-bench/3577-claude
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
export EXCLUSIVE_OWNER=claude-3577 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3597
EXCLUSIVE_TITLE="#3577 direct path: profile the UCN variants" ~/buster-fast-bench/exclusive.sh timeout -k 5 590 bash -c '
  sqlite=$1; D=$2
  for t in merge head g; do
    taskset -c 2 perf record -q -e cycles:u -c 100000 -o /tmp/3577-claude-prof-$t.data -- bash -c "for i in \$(seq 100); do $D/bins/compiler-u-$t -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c -o /tmp/3577-claude-prof.o; done" 2>&1 | tail -2
  done
' x "$sqlite" "$D"
for t in merge head g; do
  perf report -q -i /tmp/3577-claude-prof-$t.data --stdio --sort sym 2>/dev/null | awk -v T=$t 'NF >= 3 {gsub("%","",$1); print T"\t"$1"\t"$NF}' > $D/prof-u-$t.tsv
  echo "$t: $(perf report -q -i /tmp/3577-claude-prof-$t.data --stdio --sort comm 2>/dev/null | head -3 | tr -s ' ' | tr '\n' ' ')"
  perf report -i /tmp/3577-claude-prof-$t.data --stdio --sort comm 2>/dev/null | grep -m2 "Samples\|Event count"
done
rm -f /tmp/3577-claude-prof-*.data
echo DONE
