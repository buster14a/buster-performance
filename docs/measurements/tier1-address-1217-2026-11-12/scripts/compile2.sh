#!/usr/bin/env bash
# #1217's compile time on the 9700X, again: main (bin/compiler-base), the first head c5e6920b (bin/compiler-head) and the
# head with the cheaper entry rule and marks (HEAD2, built here into bin/compiler-head2, its tree then removed: /home is
# nearly full). The frozen sqlite3.c by --tier1 -c and Lua's 33 sources by --tier1 into an executable, ROUNDS rounds after
# one warm-up of each, the builds' order rotating by round, each run one hold of the lock, pinned to CPU 2, with perf
# stat's task-clock, user cycles and user instructions. Every output and perf's report go to /tmp (tmpfs): compile1217.sh
# lost some of its runs' writes on the full /home. The outputs are checked against the warm-up's.
set -u
W=$HOME/buster-fast-bench/1217-claude
export EXCLUSIVE_OWNER=claude-1217 EXCLUSIVE_TITLE='Issue 1217: Tier 1 address arithmetic' EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndCyWpFg1feNbcGfjY
L=$HOME/buster-fast-bench/exclusive.sh
HEAD2=${HEAD2:?the second head commit}
ROUNDS=${ROUNDS:-11}
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
LUA=$W/inputs/lua-5.4.8/src
FILES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
T=/tmp/claude-1217-compile
log() { echo "$(date -u +%FT%TZ) $*" >> $W/compile2.log; }
cd $W || exit 1
echo $$ > compile2.pid
if [ ! -x $W/bin/compiler-head2 ]; then
    rm -rf $W/head2 && git init -q $W/head2 && git -C $W/head2 fetch -q --depth 1 https://github.com/buster14a/buster $HEAD2 && git -C $W/head2 checkout -q FETCH_HEAD || { log "head2 fetch failed"; exit 1; }
    $L bash -c "cd $W/head2 && BUSTER_DEBUG_INFO=0 ./build.sh > $T-build.log 2>&1"; rc=$?
    log "head2 $(git -C $W/head2 rev-parse HEAD) build exit $rc"
    [ $rc = 0 ] && cp $W/head2/build/compiler $W/bin/compiler-head2
    rm -rf $W/head2
fi
sha256sum $W/bin/* > $W/compilers2.sha256
E=task-clock,cycles:u,instructions:u
LUA_SOURCES=$(for f in $FILES; do printf '%s ' $LUA/$f.c; done)
mkdir -p $T
one() {
    local phase=$1 round=$2 t=$3 what=$4
    local C=$W/bin/compiler-$t
    if [ $what = sqlite ]; then
        $L bash -c "unset CPATH C_INCLUDE_PATH; cd $T && taskset -c 2 perf stat -x, -e $E -o $T/perf.txt $C --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -c -o sqlite3-$t.o $SQ/sqlite3.c > /dev/null 2>&1"
    else
        $L bash -c "unset CPATH C_INCLUDE_PATH; cd $T && taskset -c 2 perf stat -x, -e $E -o $T/perf.txt $C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$t $LUA_SOURCES -lm -ldl > /dev/null 2>&1"
    fi
    awk -F, -v p=$phase -v r=$round -v t=$t -v w=$what 'BEGIN{ORS=""; print p, r, t, w} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $T/perf.txt >> $T/runs.txt
}
: > $T/runs.txt
BUILDS="base head head2"
for what in sqlite lua; do
    for t in $BUILDS; do one warmup 0 $t $what; done
    sha256sum $T/sqlite3-*.o $T/lua-* 2> /dev/null | sort > $T/first.sha256
    for round in $(seq 1 $ROUNDS); do
        rot=$(echo $BUILDS | awk -v r=$round '{ for (i = 0; i < NF; i++) printf "%s ", $(((i + r) % NF) + 1) }')
        for t in $rot; do one run $round $t $what; done
    done
    sha256sum $T/sqlite3-*.o $T/lua-* 2> /dev/null | sort | cmp -s - $T/first.sha256 && log "$what outputs stable" || log "$what outputs CHANGED"
    cp $T/first.sha256 $W/compile2-$what.sha256
    log "$what done"
done
cp $T/runs.txt $W/compile2-runs.txt
log "runs $(wc -l < $W/compile2-runs.txt), with counters $(grep -c task-clock $W/compile2-runs.txt)"
rm -rf $T
log done
