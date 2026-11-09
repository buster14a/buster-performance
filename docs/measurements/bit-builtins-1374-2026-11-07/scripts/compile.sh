#!/bin/bash
# #1374: sqlite3.c -c by base and head with the 9700X compile_time step's options (the default x86-64 target) and with
# -march=znver5: 11 alternating whole processes each with --time-stages, then perf stat -r 11 of each, in one hold;
# then the compiler's own main.c -c at its znver5 build flags, 3 alternating processes each, in another hold.
set -u
cd ~/buster-fast-bench/1374-opencode
export EXCLUSIVE_OWNER=opencode-1374 EXCLUSIVE_TITLE="opencode #1374 bit builtins A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1374
here=$PWD
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p results out
rm -f out/sqlite-* out/main-*
base=$here/base-c3fcc7e2/build/compiler
head=$here/head-8570c6bb/build/compiler
cat > results/sqlite.sh <<SCRIPT
head -1 /var/lib/buster-9700x/owner >> $here/results/holds.txt
unset CPATH C_INCLUDE_PATH
sha256sum $sqlite/sqlite3.c
for target in default znver5; do
  march=\$([ \$target = znver5 ] && echo -march=znver5)
  for r in \$(seq 1 11); do
    for tree in base head; do
      c=\$([ \$tree = base ] && echo $base || echo $head)
      s=\$(date +%s%N)
      taskset -c 2 \$c --time-stages -c \$march -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -o $here/out/sqlite-\$target-\$tree.o $sqlite/sqlite3.c 2> $here/out/sqlite-\$target-\$tree-\$r.stages
      status=\$?
      e=\$(date +%s%N)
      echo "sqlite \$target \$tree \$r \$(( (e - s) / 1000 )) us status \$status"
    done
  done
  cmp $here/out/sqlite-\$target-base.o $here/out/sqlite-\$target-head.o && echo "sqlite \$target objects identical" || echo "sqlite \$target objects differ"
  size $here/out/sqlite-\$target-base.o $here/out/sqlite-\$target-head.o
  for tree in base head; do
    c=\$([ \$tree = base ] && echo $base || echo $head)
    taskset -c 2 perf stat -x, -r 11 -e instructions:u,cycles:u,task-clock -o $here/results/perf-sqlite-\$target-\$tree.csv -- \$c -c \$march -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -o $here/out/sqlite-perf.o $sqlite/sqlite3.c
    echo "perf \$target \$tree status \$?"
  done
done
SCRIPT
~/buster-fast-bench/exclusive.sh bash results/sqlite.sh > results/sqlite.txt 2>&1
mapfile -d '' -t flags < <(cd head-8570c6bb && BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh print-compile-flags)
printf '%s\n' "${flags[@]}" > results/main-flags.txt
cat > results/main.sh <<SCRIPT
head -1 /var/lib/buster-9700x/owner >> $here/results/holds.txt
unset CPATH C_INCLUDE_PATH
cd $here/head-8570c6bb
for r in 1 2 3; do
  for tree in base head; do
    c=\$([ \$tree = base ] && echo $base || echo $head)
    s=\$(date +%s%N)
    taskset -c 2 \$c --lanes 1 -c $(printf '%q ' "${flags[@]}") -o $here/out/main-\$tree.o src/buster/compiler/main.c
    status=\$?
    e=\$(date +%s%N)
    echo "main \$tree \$r \$(( (e - s) / 1000 )) us status \$status"
  done
done
size $here/out/main-base.o $here/out/main-head.o
SCRIPT
~/buster-fast-bench/exclusive.sh bash results/main.sh > results/main.txt 2>&1
echo done
