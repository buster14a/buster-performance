#!/bin/bash
# #1373: sqlite3.c -c by base and head with the 9700X compile_time step's options (the default x86-64 target): 11
# alternating whole processes each with --time-stages, then perf stat -r 11 of each, in one lock hold.
set -u
cd ~/buster-fast-bench/1373-claude
export EXCLUSIVE_OWNER=claude-1373 EXCLUSIVE_TITLE="claude #1373 library calls computed inline A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1373
here=$PWD
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p results out
rm -f out/sqlite-*
base=$(ls -d $here/base-*/build/compiler)
head=$(ls -d $here/head-*/build/compiler)
cat > results/sqlite.sh <<SCRIPT
head -1 /var/lib/buster-9700x/owner >> $here/results/holds.txt
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > $here/results/busy-sqlite.txt
unset CPATH C_INCLUDE_PATH
sha256sum $sqlite/sqlite3.c
for r in \$(seq 1 11); do
  for tree in base head; do
    c=\$([ \$tree = base ] && echo $base || echo $head)
    s=\$(date +%s%N)
    taskset -c 2 \$c --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -o $here/out/sqlite-\$tree.o $sqlite/sqlite3.c 2> $here/out/sqlite-\$tree-\$r.stages
    status=\$?
    e=\$(date +%s%N)
    echo "sqlite \$tree \$r \$(( (e - s) / 1000 )) us status \$status"
  done
done
size $here/out/sqlite-base.o $here/out/sqlite-head.o
for tree in base head; do nm -u $here/out/sqlite-\$tree.o | grep -cw -e memcpy -e memmove -e memset | sed "s/^/\$tree undefined mem* symbols: /"; done
for tree in base head; do
  c=\$([ \$tree = base ] && echo $base || echo $head)
  taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o $here/results/perf-sqlite-\$tree.csv -- \$c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -o $here/out/sqlite-perf.o $sqlite/sqlite3.c
  echo "perf \$tree status \$?"
  taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o $here/results/perf-sqlite-syntax-\$tree.csv -- \$c -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c
  echo "perf syntax \$tree status \$?"
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> $here/results/busy-sqlite.txt
SCRIPT
~/buster-fast-bench/exclusive.sh bash results/sqlite.sh > results/sqlite.txt 2>&1
echo done
