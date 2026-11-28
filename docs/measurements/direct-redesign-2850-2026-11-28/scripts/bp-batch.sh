#!/bin/bash
# One batch on the 9700X, each command under the lock by itself: the front prototype (counters, profiles), today's
# direct path by the harness (stages, counters) and its timer build (the front's and the generator's split).
cd /tmp/2850-fermat
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
S=$C/sqlite/sqlite3.c
H=(--predefines $C/provenance/gnu17-pinned-predefines.txt -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $S)
export FEATURES=/tmp/2850-fermat/features.txt
./bp-run.sh "front prototype" ./front dump $S 51 > front.out 2>&1
./bp-run.sh "front prototype profile" perf record -q -e cycles:u -c 20011 -o front.perf ./front dump $S 201 > /dev/null 2>&1
perf report -i front.perf --stdio --no-children --sort symbol --percent-limit 0.7 2>/dev/null | grep -v "^#" | sed '/^$/d' > front-symbols.txt
./bp-run.sh "front prototype mispredictions" perf record -q -e branch-misses:u -c 2003 -o front-bm.perf ./front dump $S 201 > /dev/null 2>&1
perf report -i front-bm.perf --stdio --no-children --sort symbol --percent-limit 0.7 2>/dev/null | grep -v "^#" | sed '/^$/d' > front-bm-symbols.txt
if [ -x ./direct-main ]; then
  ./bp-run.sh "today's direct path, harness" ./direct-main "${H[@]}" --repeat 31 --summary -o /dev/shm/2850-fermat-main.o > main.out 2>&1
  ./bp-run.sh "today's direct path, counters" perf stat -x, -e cycles:u,instructions:u,branch-misses:u,cycles:k -o main-1.csv ./direct-main "${H[@]}" --repeat 1 -o /dev/shm/2850-fermat-main.o > /dev/null 2>&1
  ./bp-run.sh "today's direct path, counters" perf stat -x, -e cycles:u,instructions:u,branch-misses:u,cycles:k -o main-41.csv ./direct-main "${H[@]}" --repeat 41 -o /dev/shm/2850-fermat-main.o > /dev/null 2>&1
fi
if [ -x ./direct-timers ]; then
  BUSTER_DIRECT_TIMERS_PRINT=1 ./bp-run.sh "today's direct path, timers" ./direct-timers "${H[@]}" --repeat 9 --stages -o /dev/shm/2850-fermat-timers.o > timers.out 2>&1
fi
rm -f /dev/shm/2850-fermat-main.o /dev/shm/2850-fermat-timers.o
touch batch.done
