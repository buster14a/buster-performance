#!/usr/bin/env bash
# #1217's compile-time comparison on the 9700X, after run1217.sh: the frozen sqlite3.c and Lua's 33 sources by main's
# (base) and the head's --tier1, ROUNDS rounds with the builds' order alternating, one warm-up of each first, each run
# one hold of the lock, pinned to CPU 2, with perf stat's task-clock, user cycles and user instructions. The objects
# are checked against the first run's, so that each run compiles the same code.
set -u
W=$HOME/buster-fast-bench/1217-claude
export EXCLUSIVE_OWNER=claude-1217 EXCLUSIVE_TITLE='Issue 1217: Tier 1 address arithmetic' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndCyWpFg1feNbcGfjY
L=$HOME/buster-fast-bench/exclusive.sh
ROUNDS=${ROUNDS:-11}
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
LUA=$W/inputs/lua-5.4.8/src
FILES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
log() { echo "$(date -u +%FT%TZ) $*" >> $W/compile.log; }
cd $W || exit 1
echo $$ > compile.pid
while [ -e run.pid ] && kill -0 $(cat run.pid) 2> /dev/null; do sleep 20; done
grep -q " done$" run.log || { log "run1217.sh didn't finish"; exit 1; }
E=task-clock,cycles:u,instructions:u
mkdir -p $W/compiled
LUA_SOURCES=$(for f in $FILES; do printf '%s ' $LUA/$f.c; done)
one() {
    local phase=$1 round=$2 t=$3 what=$4
    local C=$W/$t/build/compiler
    if [ $what = sqlite ]; then
        $L bash -c "unset CPATH C_INCLUDE_PATH; cd $W/compiled && taskset -c 2 perf stat -x, -e $E -o $W/one-compile.txt $C --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -c -o sqlite3-$t.o $SQ/sqlite3.c > /dev/null 2>&1"
    else
        $L bash -c "unset CPATH C_INCLUDE_PATH; cd $W/compiled && taskset -c 2 perf stat -x, -e $E -o $W/one-compile.txt $C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$t $LUA_SOURCES -lm -ldl > /dev/null 2>&1"
    fi
    awk -F, -v p=$phase -v r=$round -v t=$t -v w=$what 'BEGIN{ORS=""; print p, r, t, w} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $W/one-compile.txt >> $W/compile-runs.txt
}
: > $W/compile-runs.txt
for what in sqlite lua; do
    for t in base head; do one warmup 0 $t $what; done
    sha256sum $W/compiled/sqlite3-*.o $W/compiled/lua-* 2> /dev/null > $W/compiled-first.sha256
    for round in $(seq 1 $ROUNDS); do
        first=base; second=head
        [ $((round % 2)) = 1 ] && first=head && second=base
        for t in $first $second; do one run $round $t $what; done
    done
    sha256sum $W/compiled/sqlite3-*.o $W/compiled/lua-* 2> /dev/null | cmp -s - $W/compiled-first.sha256 && log "$what outputs stable" || log "$what outputs CHANGED"
    log "$what done"
done
log done
