#!/usr/bin/env bash
# #2602 run-time comparison (#2600's record's run2600.sh, its paths and lock identity changed) on the 9700X: main (BASE) against the pull request's head (HEAD), each compiler built in
# a tree of its own at its commit. Lua 5.4.8's 33 objects by each compiler's --tier1, linked by cc in ORDERS recorded
# orders (order 0 the usual one; every order the same for both builds), and speedtest1 as measure-tier1-programs builds
# it (one unity translation unit, so one layout). Every executable's output is checked first: speedtest1's verification
# hash, and each script's output against clang -O0's. Then ROUNDS rounds: in each, every order's two Lua builds run all
# five scripts and speedtest1's two builds run once, the builds' order rotating by round and order, each run one hold of
# the lock, pinned to CPU 2, with perf stat's task-clock, user cycles and user instructions. Each step logs to run.log.
set -u
W=$HOME/buster-fast-bench/2602-claude
export EXCLUSIVE_OWNER=claude-2602 EXCLUSIVE_TITLE='Solve 2602: an addition of a load from memory' EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxndcswcy5h6cwFvZ4QF
L=$HOME/buster-fast-bench/exclusive.sh
BASE=${BASE:?the base commit}
HEAD=${HEAD:?the head commit}
ORDERS=${ORDERS:-6}
ROUNDS=${ROUNDS:-11}
SQ=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
IN=$W/inputs
LUA=$IN/lua-5.4.8/src
SCRIPTS="calls tables strings arithmetic closures"
FILES="lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua"
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
log() { echo "$(date -u +%FT%TZ) $*" >> $W/run.log; }
cd $W || exit 1
echo $$ > run.pid
printf '%s  %s\n' 0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d $SQ/sqlite3.c | sha256sum --check --quiet || { log "sqlite3.c differs"; exit 1; }
(cd $IN && sha256sum --check --quiet inputs.sha256) || { log "inputs differ"; exit 1; }
for t in base head; do
    c=$BASE; [ $t = head ] && c=$HEAD
    if [ ! -x $W/$t/build/compiler ]; then
        rm -rf $W/$t && git init -q $W/$t && git -C $W/$t fetch -q --depth 1 https://github.com/buster14a/buster $c && git -C $W/$t checkout -q FETCH_HEAD || { log "$t fetch failed"; exit 1; }
        $L bash -c "cd $W/$t && BUSTER_DEBUG_INFO=0 ./build.sh > $W/build-$t.log 2>&1"; log "$t $(git -C $W/$t rev-parse HEAD) build exit $?"
    fi
    sha256sum $W/$t/build/compiler >> $W/compilers.sha256
done
printf '#include "sqlite3.c"\n#define randomFunc speedtest1_randomFunc\n#include "speedtest1.c"\n' > $IN/speedtest1-unity.c
for t in base head; do
    C=$W/$t/build/compiler
    mkdir -p $W/obj-$t
    $L bash -c "cd $W/obj-$t && for f in $FILES; do $C --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o \$f.o $LUA/\$f.c || exit 1; done"; log "lua objects $t exit $?"
    $L bash -c "unset CPATH C_INCLUDE_PATH; $C --tier1 -fno-asynchronous-unwind-tables $FLAGS -I$SQ -I$IN -o $W/st-$t $IN/speedtest1-unity.c -lm"; log "speedtest1 $t exit $?"
done
if [ ! -x $W/lua-clang0 ]; then
    $L bash -c "cd $W && clang -O0 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-clang0 $(for f in $FILES; do printf '%s ' $LUA/$f.c; done) -lm -ldl"; log "clang -O0 lua exit $?"
fi
: > $W/orders.txt
for o in $(seq 0 $((ORDERS - 1))); do
    if [ $o = 0 ]; then perm="$FILES"; else perm=$(echo $FILES | tr ' ' '\n' | shuf --random-source=<(yes $o) | tr '\n' ' '); fi
    echo "$o $perm" >> $W/orders.txt
    for t in base head; do
        objs=""; for f in $perm; do objs="$objs $W/obj-$t/$f.o"; done
        $L bash -c "cd $W && cc -o lua-$t-o$o $objs -lm -ldl"; log "link $t o$o exit $?"
    done
done
sha256sum $W/obj-*/*.o $W/lua-* $W/st-* > $W/executables.sha256
# The checks: each script's output by clang -O0 and by every Lua executable, and speedtest1's hash by both.
status=0
for s in $SCRIPTS; do
    $L bash -c "cd $IN && $W/lua-clang0 $s.lua > $W/ref-$s.out 2>&1"
    for o in $(seq 0 $((ORDERS - 1))); do
        for t in base head; do
            $L bash -c "cd $IN && $W/lua-$t-o$o $s.lua > $W/check.out 2>&1"; rc=$?
            cmp -s $W/check.out $W/ref-$s.out && [ $rc = 0 ] || { log "check $s $t o$o FAILED"; status=1; }
        done
    done
done
for t in base head; do
    $L bash -c "rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp; cd $W/db && SQLITE_TMPDIR=$W/tmp $W/st-$t $OPTS --verify speedtest1.db > $W/verify-$t.txt 2>&1"
    grep -qx 'Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739' $W/verify-$t.txt || { log "verify $t FAILED"; status=1; }
done
log "checks status $status"
[ $status = 0 ] || exit 1
E=task-clock,cycles:u,instructions:u
: > $W/runs.txt
for round in $(seq 1 $ROUNDS); do
    for o in $(seq 0 $((ORDERS - 1))); do
        first=base; second=head
        [ $(( (round + o) % 2 )) = 1 ] && first=head && second=base
        for t in $first $second; do
            for s in $SCRIPTS; do
                $L bash -c "cd $IN && taskset -c 2 perf stat -x, -e $E -o $W/one.txt $W/lua-$t-o$o $s.lua > /dev/null 2>&1"
                awk -F, -v r=$round -v o=$o -v t=$t -v s=$s 'BEGIN{ORS=""; print "lua", r, o, t, s} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $W/one.txt >> $W/runs.txt
            done
        done
    done
    first=base; second=head
    [ $((round % 2)) = 1 ] && first=head && second=base
    for t in $first $second; do
        $L bash -c "rm -rf $W/db $W/tmp; mkdir -p $W/db $W/tmp; cd $W/db && SQLITE_TMPDIR=$W/tmp taskset -c 2 perf stat -x, -e $E -o $W/one.txt $W/st-$t $OPTS speedtest1.db > /dev/null 2>&1"
        awk -F, -v r=$round -v t=$t 'BEGIN{ORS=""; print "st", r, 0, t, "speedtest1"} /^[0-9]/{n=$3; sub(/:u$/,"",n); print " " n "=" $1} END{print "\n"}' $W/one.txt >> $W/runs.txt
    done
    log "round $round"
done
log done
