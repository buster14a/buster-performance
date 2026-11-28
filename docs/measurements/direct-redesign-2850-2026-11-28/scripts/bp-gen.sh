#!/bin/bash
# The generator's split on the 9700X, each command under the lock by itself, two turns: today's direct path by the
# harness with a stage's hardware counters; its timer build with a line a body; and the timer build that makes no code
# for a body's expressions (every body compiled as a dead branch is: read, typed, no code).
cd /tmp/2850-fermat
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
S=$C/sqlite/sqlite3.c
H=(--predefines $C/provenance/gnu17-pinned-predefines.txt -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$C/sqlite $S)
export FEATURES=/tmp/2850-fermat/features.txt
for turn in 1 2; do
  ./bp-run.sh "today's direct path, counters a stage" ./direct-main "${H[@]}" --repeat 31 --summary --counters -o /dev/shm/2850-fermat-g.o 2>&1 | grep -a -E "^median|^status|^bail" > gen-main-$turn.out
  BUSTER_DIRECT_TIMERS_PRINT=1 BUSTER_DIRECT_BODIES=/tmp/2850-fermat/bodies-timers-$turn.txt ./bp-run.sh "today's direct path, timers" ./direct-timers "${H[@]}" --repeat 15 --summary --counters -o /dev/shm/2850-fermat-g.o 2>&1 | grep -a -E "^median|^status|^timers|^bail" > gen-timers-$turn.out
  BUSTER_DIRECT_TIMERS_PRINT=1 BUSTER_DIRECT_BODIES=/tmp/2850-fermat/bodies-nocode-$turn.txt ./bp-run.sh "today's direct path, no code for expressions" ./direct-nocode "${H[@]}" --repeat 15 --summary --counters -o /dev/shm/2850-fermat-g.o 2>&1 | grep -a -E "^median|^status|^timers|^bail" > gen-nocode-$turn.out
done
rm -f /dev/shm/2850-fermat-g.o
touch gen.done
