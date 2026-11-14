#!/bin/bash
# #1373: the compile-time fix's tree (9e873bf6, `git archive` of the local commit, copied here), built znver5 without
# debug info in one hold; its kernel objects compared with head's; then sqlite3.c -c by base and fix as compile.sh
# measures it (11 alternating processes with --time-stages, then perf stat -r 11 of -c and -fsyntax-only), one hold.
set -u
cd ~/buster-fast-bench/1373-claude
export EXCLUSIVE_OWNER=claude-1373 EXCLUSIVE_TITLE="claude #1373 library calls computed inline A/B (compile-time fix 2)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2671
here=$PWD
if [[ ! -x fix2-9e873bf6/build/compiler ]]; then
    (cd fix2-9e873bf6 && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh) > fix2-9e873bf6.build.log 2>&1 || { echo "build failed"; exit 1; }
fi
echo "built $(tail -2 fix2-9e873bf6.build.log | head -1)"
fix=$here/fix2-9e873bf6/build/compiler
base=$(ls -d $here/base-*/build/compiler)
mkdir -p bin-fix2
"$fix" -c scripts/kern.c -o bin-fix2/k-fix-t0.o && "$fix" --tier1 -c scripts/kern.c -o bin-fix2/k-fix-t1.o
for t in t0 t1; do cmp bin/k-head-$t.o bin-fix2/k-fix-$t.o && echo "kernels $t: fix's object is head's" || echo "kernels $t: objects differ"; done
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
cat > results/sqlite-fix2.sh <<SCRIPT
head -1 /var/lib/buster-9700x/owner >> $here/results/holds.txt
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } > $here/results/busy-sqlite-fix2.txt
unset CPATH C_INCLUDE_PATH
for r in \$(seq 1 11); do
  for tree in base fix2; do
    c=\$([ \$tree = base ] && echo $base || echo $fix)
    s=\$(date +%s%N)
    taskset -c 2 \$c --time-stages -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -o $here/out/f2-sqlite-\$tree.o $sqlite/sqlite3.c 2> $here/out/f2-sqlite-\$tree-\$r.stages
    status=\$?
    e=\$(date +%s%N)
    echo "sqlite \$tree \$r \$(( (e - s) / 1000 )) us status \$status"
  done
done
size $here/out/f2-sqlite-base.o $here/out/f2-sqlite-fix2.o
cmp $here/out/sqlite-head.o $here/out/f2-sqlite-fix2.o && echo "fix's sqlite object is head's" || echo "fix's sqlite object differs from head's"
for tree in base fix2; do
  c=\$([ \$tree = base ] && echo $base || echo $fix)
  taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o $here/results/perf-sqlite-\$tree-3.csv -- \$c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -o $here/out/sqlite-perf.o $sqlite/sqlite3.c
  echo "perf \$tree status \$?"
  taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o $here/results/perf-sqlite-syntax-\$tree-3.csv -- \$c -fsyntax-only -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c
  echo "perf syntax \$tree status \$?"
done
{ cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8; } >> $here/results/busy-sqlite-fix2.txt
SCRIPT
~/buster-fast-bench/exclusive.sh bash results/sqlite-fix2.sh > results/sqlite-fix2.txt 2>&1
echo fix2 done
