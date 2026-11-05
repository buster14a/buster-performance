#!/usr/bin/env bash
# probes177.sh: -fstack-clash-protection's 9700X measurements (#177), every step one hold of the shared lock, every
# timed run pinned to CPU 2.
#  1. base (main, the merge's first parent) and head (HEAD below) built (znver5); head's default objects of
#     sqlite3.c by Tier 0 and --tier1 must be the base's byte for byte (the option changes nothing unless given), and
#     main's are compared too.
#  2. speedtest1 (sqlite3.c and speedtest1.c as one unit, #136's flags) and Lua 5.4.8 built by head as
#     t0 (Tier 0), t0p (Tier 0 -fstack-clash-protection), t1 (--tier1), t1p (--tier1 -fstack-clash-protection), and
#     clang -O2 with and without -fstack-clash-protection, clang -O0 (Lua's outputs' reference); speedtest1's --verify
#     hash and each script's output must agree across builds.
#  3. time-runs: 11 rounds after a warm-up, the builds rotating, speedtest1 from a fresh database (a wrapper per build),
#     Lua's five scripts.
set -u
HEAD=${1:?commit}
BASE=${2:?base commit}
MAIN=${3:?main commit}
W=$HOME/buster-fast-bench/177-probes-claude
L="env EXCLUSIVE_OWNER=claude-177-probes EXCLUSIVE_TITLE=Problems_141_177_789 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/177 $HOME/buster-fast-bench/exclusive.sh"
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
ST=$HOME/buster-fast-bench/speedtest1-136-claude/src
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
SCRIPTS=$HOME/buster-fast-bench/claude-141-reciprocal/lua
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
mkdir -p $W/out && cd $W || exit 1
log() { echo "$(date -u +%FT%TZ) $*" >> $W/out/steps.log; }
log "start head=$HEAD base=$BASE main=$MAIN"
sha256sum $Q/sqlite3.c $ST/speedtest1-unity.c $ST/speedtest1.c > $W/out/inputs.txt
for t in base head; do
    commit=$([ $t = base ] && echo $BASE || ([ $t = main ] && echo $MAIN || echo $HEAD))
    if [ ! -d $t ]; then git clone -q https://github.com/buster14a/buster $t; fi
    (cd $t && git fetch -q origin claude/stack-clash-probes main; git checkout -q $commit && git log -1 --format=%H > ../out/$t.commit)
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh > $W/out/build-$t.log 2>&1"; log "build $t exit $?"
done
B=$W/head/build/compiler
# 1. Identity of the default objects.
mkdir -p $W/out/identity
$L bash -c "cd $W/out/identity && for t in base head; do c=$W/\$t/build/compiler; \$c -c $FLAGS -I$Q -o t0-\$t.o $Q/sqlite3.c; \$c --tier1 -c $FLAGS -I$Q -o t1-\$t.o $Q/sqlite3.c; done; for o in base; do cmp -s t0-\$o.o t0-head.o && echo t0-\$o-same || echo t0-\$o-differs; cmp -s t1-\$o.o t1-head.o && echo t1-\$o-same || echo t1-\$o-differs; done" > $W/out/identity.txt 2>&1
log "identity $(tr '\n' ' ' < $W/out/identity.txt)"
# 2. The programs' builds.
cc_of() {
    case $1 in
        t0) echo "$B" ;;
        t0p) echo "$B -fstack-clash-protection" ;;
        t1) echo "$B --tier1 -fno-asynchronous-unwind-tables" ;;
        t1p) echo "$B --tier1 -fno-asynchronous-unwind-tables -fstack-clash-protection" ;;
        clang2) echo "clang -O2" ;;
        clang2p) echo "clang -O2 -fstack-clash-protection" ;;
        clang0) echo "clang -O0" ;;
    esac
}
BUILDS="t0 t0p t1 t1p clang2 clang2p"
mkdir -p $W/out/st $W/out/lua
cp $SCRIPTS/*.lua $W/out/lua/
lua_files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    lua_files="$lua_files $LUA/$f.c"
done
for c in $BUILDS clang0; do
    if [ $c != clang0 ]; then
        if [ ${c#clang} = $c ]; then
            $L bash -c "cd $W/out/st && $(cc_of $c) $FLAGS -I$Q -I$ST -o speedtest1-$c $ST/speedtest1-unity.c -lm > build-$c.txt 2>&1"; log "speedtest1 $c exit $?"
        else
            $L bash -c "cd $W/out/st && $(cc_of $c) -c $FLAGS -I$Q -o sqlite3-$c.o $Q/sqlite3.c && $(cc_of $c) -c $FLAGS -I$Q -o speedtest1-$c.o $ST/speedtest1.c && $(cc_of $c) -o speedtest1-$c speedtest1-$c.o sqlite3-$c.o -lm > build-$c.txt 2>&1"; log "speedtest1 $c exit $?"
        fi
        printf '#!/bin/bash\nrm -rf "$1" "$1"-wal "$1"-shm "$1"-journal /tmp/177-probes-tmp; mkdir -p /tmp/177-probes-tmp\nSQLITE_TMPDIR=/tmp/177-probes-tmp exec %s/out/st/speedtest1-%s %s "$1"\n' "$W" "$c" "$OPTS" > $W/out/st/run-$c.sh
        chmod +x $W/out/st/run-$c.sh
    fi
    $L bash -c "cd $W/out/lua && $(cc_of $c) -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$c $lua_files -lm -ldl > build-$c.txt 2>&1"; log "lua $c exit $?"
done
$L bash -c "cd $W/out/st && for c in $BUILDS; do rm -rf /tmp/177-probes-db*; ./speedtest1-\$c $OPTS --verify /tmp/177-probes-db 2>&1 | grep 'Verification Hash' | sed \"s/^/\$c /\"; done" > $W/out/st/verify.txt 2>&1
log "verify hashes $(awk '{print $NF}' $W/out/st/verify.txt | sort -u | wc -l) distinct of $(wc -l < $W/out/st/verify.txt)"
$L bash -c "cd $W/out/lua && for s in calls tables strings arithmetic closures; do ./lua-clang0 \$s.lua > \$s-clang0.out 2>&1; for c in $BUILDS; do ./lua-\$c \$s.lua > \$s-\$c.out 2>&1; cmp -s \$s-clang0.out \$s-\$c.out && echo \"\$s \$c same\" || echo \"\$s \$c differs\"; done; done" > $W/out/lua/compare.txt 2>&1
log "lua compare $(grep -c same $W/out/lua/compare.txt) same, $(grep -c differs $W/out/lua/compare.txt) differ"
# 3. Timing.
st_builds=""
lua_builds=""
for c in $BUILDS; do
    st_builds="$st_builds --build $c $W/out/st/run-$c.sh"
    lua_builds="$lua_builds --build $c $W/out/lua/lua-$c"
done
$L bash -c "cd $W/out/st && taskset -c 2 $B time-runs --runs 11 --warmups 1 $st_builds --list /tmp/177-probes-db" > $W/out/st/time-runs.txt 2>&1; log "time-runs speedtest1 exit $?"
$L bash -c "cd $W/out/lua && taskset -c 2 $B time-runs --runs 11 --warmups 1 --copies 3 --directory /tmp $lua_builds --list calls.lua --list tables.lua --list strings.lua --list arithmetic.lua --list closures.lua" > $W/out/lua/time-runs.txt 2>&1; log "time-runs lua exit $?"
log "done"
echo done > $W/out/done
