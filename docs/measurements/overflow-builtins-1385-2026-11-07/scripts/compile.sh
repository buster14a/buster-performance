#!/bin/bash
# #1385: sqlite3.c -c by base and head with the 9700X compile_time step's options (the default x86-64 target): 11
# alternating whole processes each, then perf stat -r 11 of each, in one hold. sqlite3.c has no overflow builtin; this
# checks that the lowering's new branch costs nothing.
set -u
cd ~/buster-fast-bench/1385-opencode
export EXCLUSIVE_OWNER=opencode-1385 EXCLUSIVE_TITLE="opencode #1385 overflow builtins A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1385
here=$PWD
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p results out
base=$(ls -d $here/base-*/build/compiler)
head=$(ls -d $here/head-*/build/compiler)
cat > results/sqlite.sh <<SCRIPT
head -1 /var/lib/buster-9700x/owner >> $here/results/holds.txt
unset CPATH C_INCLUDE_PATH
sha256sum $sqlite/sqlite3.c
for r in \$(seq 1 11); do
  for tree in base head; do
    c=\$([ \$tree = base ] && echo $base || echo $head)
    s=\$(date +%s%N)
    taskset -c 2 \$c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -o $here/out/sqlite-\$tree.o $sqlite/sqlite3.c
    status=\$?
    e=\$(date +%s%N)
    echo "sqlite \$tree \$r \$(( (e - s) / 1000 )) us status \$status"
  done
done
cmp $here/out/sqlite-base.o $here/out/sqlite-head.o && echo "sqlite objects identical" || echo "sqlite objects differ"
size $here/out/sqlite-base.o $here/out/sqlite-head.o
for tree in base head; do
  c=\$([ \$tree = base ] && echo $base || echo $head)
  taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o $here/results/perf-sqlite-\$tree.csv -- \$c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -o $here/out/sqlite-perf.o $sqlite/sqlite3.c
  echo "perf \$tree status \$?"
done
SCRIPT
~/buster-fast-bench/exclusive.sh bash results/sqlite.sh > results/sqlite.txt 2>&1
echo done
