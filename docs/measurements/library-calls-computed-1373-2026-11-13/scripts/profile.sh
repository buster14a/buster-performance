#!/bin/bash
# #1373: user instructions by symbol of sqlite3.c -c by base and fix (perf record -e instructions:u, CPU 2), one hold.
set -u
cd ~/buster-fast-bench/1373-claude
export EXCLUSIVE_OWNER=claude-1373 EXCLUSIVE_TITLE="claude #1373 compile-time fix profile" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2671
here=$PWD
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
base=$(ls -d $here/base-*/build/compiler)
fix=$here/fix-1228e539/build/compiler
mkdir -p results/profile
cat > results/profile/run.sh <<SCRIPT
head -1 /var/lib/buster-9700x/owner >> $here/results/holds.txt
unset CPATH C_INCLUDE_PATH
for tree in base fix; do
  c=\$([ \$tree = base ] && echo $base || echo $fix)
  taskset -c 2 perf record -q -e instructions:u -c 200003 -o $here/results/profile/\$tree.data -- \$c -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -o $here/out/sqlite-prof.o $sqlite/sqlite3.c
  echo "record \$tree status \$?"
done
SCRIPT
~/buster-fast-bench/exclusive.sh bash results/profile/run.sh > results/profile/run.txt 2>&1
for tree in base fix; do perf report -q -i results/profile/$tree.data --sort symbol --stdio 2>/dev/null | head -60 > results/profile/$tree.txt; done
echo profile done
