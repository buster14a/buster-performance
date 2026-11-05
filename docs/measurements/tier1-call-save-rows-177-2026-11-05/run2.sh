#!/usr/bin/env bash
# callsave run 2: head2 (the save positions' pass made sparse) against main and the first head, on the 9700X. Every
# step one hold of the shared lock, every timed run its own hold, pinned to CPU 2.
#  1. head2 built (znver5); its --tier1 objects of sqlite3.c and its Lua executable the first head's, byte for byte.
#  2. Compile time of -c sqlite3.c --tier1, main and head2 alternating, 11 rounds.
#  3. Lua's closures script, main's and head's Tier 1 builds alternating, 11 rounds at each of four environment sizes
#     (which move the initial stack), with branch misses and L1 data misses beside the cycles.
set -u
HEAD2=${1:?head2 commit}
W=$HOME/buster-fast-bench/177-callsave-claude
export EXCLUSIVE_OWNER=claude-177-callsave EXCLUSIVE_TITLE='Problems 141, 177, 789' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1433
L="$HOME/buster-fast-bench/exclusive.sh"
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
cd $W || exit 1
mkdir -p $W/out2
log() { echo "$(date -u +%FT%TZ) $*" >> $W/out2/steps.log; }
log "start head2=$HEAD2"
if [ ! -d head2 ]; then git clone -q https://github.com/buster14a/buster head2; fi
(cd head2 && git fetch -q origin claude/tier1-call-save-rows && git checkout -q $HEAD2 && git log -1 --format=%H > ../out2/head2.commit)
$L bash -c "cd $W/head2 && BUSTER_HOST_ARCH=znver5 ./build.sh > $W/out2/build-head2.log 2>&1"; log "build head2 exit $?"
B=$W/head/build/compiler
B2=$W/head2/build/compiler
M=$W/main/build/compiler
lua_files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    lua_files="$lua_files $LUA/$f.c"
done
# 1. Identity with the first head.
$L bash -c "cd $W/out2 && $B2 --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o sqlite3-t1head2.o $Q/sqlite3.c && (cmp -s sqlite3-t1head2.o $W/out/frames/sqlite3-t1head.o && echo sqlite3-same || echo sqlite3-differs) && $B2 --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-t1head2 $lua_files -lm -ldl && (cmp -s lua-t1head2 $W/out/lua/lua-t1head && echo lua-same || echo lua-differs)" > $W/out2/identity.txt 2>&1
log "identity $(grep -E 'same|differs' $W/out2/identity.txt | tr '\n' ' ')"
# 2. Compile time.
: > $W/out2/compile.txt
for round in $(seq 1 11); do
    order="main head2"; [ $((round % 2)) = 0 ] && order="head2 main"
    for c in $order; do
        exe=$([ $c = main ] && echo $M || echo $B2)
        $L taskset -c 2 perf stat -x, -e task-clock,instructions:u,cycles:u -o $W/out2/compile-one.txt $exe --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o /dev/null $Q/sqlite3.c > /dev/null 2>&1
        awk -F, -v c=$c -v r=$round '/task-clock/{t=$1} /instructions/{i=$1} /cycles/{y=$1} END{print r, c, t, i, y}' $W/out2/compile-one.txt >> $W/out2/compile.txt
    done
done
log "compile done"
# 3. closures.lua at four environment sizes.
: > $W/out2/closures.txt
for pad in 0 700 1900 3333; do
    padding=$(head -c $pad /dev/zero | tr '\0' x)
    for round in $(seq 1 11); do
        order="t1main t1head"; [ $((round % 2)) = 0 ] && order="t1head t1main"
        for c in $order; do
            $L bash -c "cd $W/out/lua && env PADDING=$padding taskset -c 2 perf stat -x, -e task-clock,instructions:u,cycles:u,branch-misses:u,L1-dcache-load-misses:u -o $W/out2/closures-one.txt ./lua-$c closures.lua > /dev/null 2>&1"
            awk -F, -v c=$c -v r=$round -v p=$pad '/task-clock/{t=$1} /instructions/{i=$1} /cycles/{y=$1} /branch-misses/{b=$1} /L1-dcache-load-misses/{d=$1} END{print p, r, c, t, i, y, b, d}' $W/out2/closures-one.txt >> $W/out2/closures.txt
        done
    done
    log "closures pad $pad done"
done
log "done"
