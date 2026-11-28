#!/bin/bash
# The generator's profile by function on the 9700X, each run under the lock by itself: today's direct path, and the
# build that makes no code for a body's expressions. Cycles and mispredicted branches, user mode, 41 compiles a run.
cd /tmp/2850-fermat
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
S=$C/sqlite/sqlite3.c
H=(--predefines $C/provenance/gnu17-pinned-predefines.txt -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $S)
export FEATURES=/tmp/2850-fermat/features.txt
for build in main nocode; do
  ./bp-run.sh "today's direct path, profile ($build)" perf record -q -e cycles:u -c 20011 -o gen-$build.perf ./direct-$build "${H[@]}" --repeat 41 -o /dev/shm/2850-fermat-p.o > /dev/null 2>&1
  perf report -i gen-$build.perf --stdio --no-children --sort symbol --percent-limit 0.4 2>/dev/null | grep -v "^#" | sed '/^$/d' > gen-$build-symbols.txt
  ./bp-run.sh "today's direct path, mispredictions ($build)" perf record -q -e branch-misses:u -c 2003 -o gen-$build-bm.perf ./direct-$build "${H[@]}" --repeat 41 -o /dev/shm/2850-fermat-p.o > /dev/null 2>&1
  perf report -i gen-$build-bm.perf --stdio --no-children --sort symbol --percent-limit 0.6 2>/dev/null | grep -v "^#" | sed '/^$/d' > gen-$build-bm-symbols.txt
done
rm -f /dev/shm/2850-fermat-p.o gen-*.perf
touch genprof.done
