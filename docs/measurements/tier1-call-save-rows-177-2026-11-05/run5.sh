#!/usr/bin/env bash
# callsave run 5: head3 (the search short cut) against main: its --tier1 objects of sqlite3.c the first head's, byte for
# byte, and the compile time of -c sqlite3.c --tier1, main and head3 alternating, 11 rounds, each run one hold, CPU 2.
set -u
HEAD3=${1:?head3 commit}
W=$HOME/buster-fast-bench/177-callsave-claude
export EXCLUSIVE_OWNER=claude-177-callsave EXCLUSIVE_TITLE='Problems 141, 177, 789' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1433
L="$HOME/buster-fast-bench/exclusive.sh"
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
cd $W || exit 1
O=$W/out5
mkdir -p $O
log() { echo "$(date -u +%FT%TZ) $*" >> $O/steps.log; }
log "start head3=$HEAD3"
if [ ! -d head3 ]; then git clone -q https://github.com/buster14a/buster head3; fi
(cd head3 && git fetch -q origin claude/tier1-call-save-rows && git checkout -q $HEAD3 && git log -1 --format=%H > $O/head3.commit)
$L bash -c "cd $W/head3 && BUSTER_HOST_ARCH=znver5 ./build.sh > $O/build-head3.log 2>&1"; log "build head3 exit $?"
M=$W/main/build/compiler
B3=$W/head3/build/compiler
$L bash -c "cd $O && $B3 --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o sqlite3-t1head3.o $Q/sqlite3.c && (cmp -s sqlite3-t1head3.o $W/out/frames/sqlite3-t1head.o && echo sqlite3-same || echo sqlite3-differs)" > $O/identity.txt 2>&1
log "identity $(grep -E 'same|differs' $O/identity.txt | tr '\n' ' ')"
: > $O/compile.txt
for round in $(seq 1 11); do
    order="main head3"; [ $((round % 2)) = 0 ] && order="head3 main"
    for c in $order; do
        exe=$([ $c = main ] && echo $M || echo $B3)
        $L taskset -c 2 perf stat -x, -e task-clock,instructions:u,cycles:u -o $O/one.txt $exe --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o /dev/null $Q/sqlite3.c > /dev/null 2>&1
        awk -F, -v c=$c -v r=$round '/task-clock/{t=$1} /instructions/{i=$1} /cycles/{y=$1} END{print r, c, t, i, y}' $O/one.txt >> $O/compile.txt
    done
done
log done
