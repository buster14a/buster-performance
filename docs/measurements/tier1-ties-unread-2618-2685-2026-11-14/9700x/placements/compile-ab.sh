#!/usr/bin/env bash
# compile-ab.sh: sqlite3.c's and Lua's --tier1 compiles by main (BASE, the run's base tree), #2714's head (282d1157, the
# run's head tree) and the follow-up (FINAL: the head with patches/*.patch applied), each built at six placements of the
# backend unit (./build.sh shifts), timed by time-runs under ab with fresh copies, main a second time as the floor.
set -u
W=$HOME/buster-fast-bench/2618d-claude
L=$HOME/buster-fast-bench/exclusive.sh
export EXCLUSIVE_OWNER=claude-2618 EXCLUSIVE_TITLE='GitHub issue #2618 (rest) and #2685: compile time over placements' EXCLUSIVE_LINK=https://claude.ai/code/session_01NNmNQsNkec1N4WJ65hh6VB
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
SHIFTS="0 688 1376 2064 2752 3440"
log() { echo "$(date -u +%FT%TZ) $*" >> $W/ab.log; }
cd $W || exit 1
if [ ! -d final ]; then
    git clone -q head final && (cd final && git -c user.name=build -c user.email=build@localhost am -q $W/patches/*.patch) || { log "final tree failed"; exit 1; }
fi
log "final $(git -C final rev-parse HEAD) on $(git -C final rev-parse HEAD~3)"
for t in base head final; do
    if [ ! -x $W/shifts/$t/compiler-3440 ]; then
        $L bash -c "head -1 /var/lib/buster-9700x/owner >> $W/holds.txt; cd $W/$t && BUSTER_DEBUG_INFO=0 ./build.sh shifts --config Release $W/shifts/$t main_unit_backend.c $SHIFTS > $W/shifts-$t.log 2>&1"
        log "$t shifts exit $?"
    fi
done
for t in base head final; do for s in $SHIFTS; do [ -x $W/shifts/$t/compiler-$s ] || { log "missing $t $s"; exit 1; }; done; done
sha256sum $W/shifts/*/compiler-* > $W/shifts/compilers.sha256
builds=()
for b in main:base head:head final:final main-again:base; do
    for s in $SHIFTS; do builds+=(--build "${b%%:*}" "$W/shifts/${b#*:}/compiler-$s"); done
done
mkdir -p /tmp/claude-2618d-ab
cd /tmp/claude-2618d-ab
unset CPATH C_INCLUDE_PATH
LUA=$W/inputs/lua-5.4.8/src
LUA_SOURCES=""; for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do LUA_SOURCES="$LUA_SOURCES $LUA/$f.c"; done
$W/base/build/compiler ab --rounds 3 --cpu 2 --lock $L $W/base/build/compiler \
    -- time-runs --runs 3 --copies 2 --directory /tmp/claude-2618d-ab "${builds[@]}" \
       --list --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -c -o /tmp/claude-2618d-ab/sqlite3.o $SQ/sqlite3.c \
       --list --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o /tmp/claude-2618d-ab/lvm.o $LUA/lvm.c \
    > $W/ab.txt 2>&1
log "ab exit $?"
rm -rf /tmp/claude-2618d-ab
log done
