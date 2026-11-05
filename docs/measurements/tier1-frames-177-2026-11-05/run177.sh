#!/usr/bin/env bash
# run177.sh: #177's 9700X measurements, every step one hold of the shared lock, every timed run pinned to CPU 2.
#  1. main (483e5f70) and head (HEAD below) built (znver5); head's default objects of sqlite3.c by Tier 0 and --tier1
#     must be main's byte for byte (the options change nothing without -fno-omit-frame-pointer).
#  2. speedtest1 (sqlite3.c and speedtest1.c as one unit, #136's flags) and Lua 5.4.8 built by head as
#     t0 (Tier 0), t0fp (Tier 0 -fno-omit-frame-pointer), t1 (--tier1), t1fp (--tier1 -fno-omit-frame-pointer),
#     t1nl (--tier1 --tier1-no-lifetimes), and clang -O2 with and without -fno-omit-frame-pointer, clang -O0 (Lua's
#     outputs' reference); speedtest1's --verify hash and each script's output must agree across builds.
#  3. time-runs: 11 rounds after a warm-up, the builds rotating, speedtest1 from a fresh database (a wrapper per build),
#     Lua's five scripts.
#  4. measure-frames: sqlite3.c's objects and Lua's executables by each build, against clang -O2's.
set -u
HEAD=${1:?commit}
W=$HOME/buster-fast-bench/177-claude
L="env EXCLUSIVE_OWNER=claude-177 EXCLUSIVE_TITLE=Problems_141_177_789 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/177 $HOME/buster-fast-bench/exclusive.sh"
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
ST=$HOME/buster-fast-bench/speedtest1-136-claude/src
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
SCRIPTS=$HOME/buster-fast-bench/claude-141-reciprocal/lua
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
mkdir -p $W/out && cd $W || exit 1
log() { echo "$(date -u +%FT%TZ) $*" >> $W/out/steps.log; }
log "start head=$HEAD"
for t in main head; do
    commit=$([ $t = main ] && echo 483e5f70 || echo $HEAD)
    if [ ! -d $t ]; then git clone -q https://github.com/buster14a/buster $t; fi
    (cd $t && git fetch -q origin claude/practical-ramanujan-s8ccq2 main && git checkout -q $commit && git log -1 --format=%H > ../out/$t.commit)
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh > $W/out/build-$t.log 2>&1"; log "build $t exit $?"
done
B=$W/head/build/compiler
M=$W/main/build/compiler
# 1. Identity of the default objects.
mkdir -p $W/out/identity
$L bash -c "cd $W/out/identity && for t in main head; do c=\$([ \$t = main ] && echo $M || echo $B); \$c -c $FLAGS -I$Q -o t0-\$t.o $Q/sqlite3.c; \$c --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o t1-\$t.o $Q/sqlite3.c; done; cmp t0-main.o t0-head.o && echo t0-same || echo t0-differs; cmp t1-main.o t1-head.o && echo t1-same || echo t1-differs" > $W/out/identity.txt 2>&1
log "identity $(tr '\n' ' ' < $W/out/identity.txt)"
# 2. The programs' builds.
cc_of() {
    case $1 in
        t0) echo "$B" ;;
        t0fp) echo "$B -fno-omit-frame-pointer" ;;
        t1) echo "$B --tier1 -fno-asynchronous-unwind-tables" ;;
        t1fp) echo "$B --tier1 -fno-asynchronous-unwind-tables -fno-omit-frame-pointer" ;;
        t1nl) echo "$B --tier1 -fno-asynchronous-unwind-tables --tier1-no-lifetimes" ;;
        clang2) echo "clang -O2" ;;
        clang2fp) echo "clang -O2 -fno-omit-frame-pointer" ;;
        clang0) echo "clang -O0" ;;
    esac
}
BUILDS="t0 t0fp t1 t1fp t1nl clang2 clang2fp"
mkdir -p $W/out/st $W/out/lua $W/out/frames
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
        # The run's wrapper: a fresh database on tmpfs, outside nothing (time-runs times the whole process).
        printf '#!/bin/bash\nrm -rf "$1" "$1"-wal "$1"-shm "$1"-journal /tmp/177-claude-tmp; mkdir -p /tmp/177-claude-tmp\nSQLITE_TMPDIR=/tmp/177-claude-tmp exec %s/out/st/speedtest1-%s %s "$1"\n' "$W" "$c" "$OPTS" > $W/out/st/run-$c.sh
        chmod +x $W/out/st/run-$c.sh
    fi
    $L bash -c "cd $W/out/lua && $(cc_of $c) -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$c $lua_files -lm -ldl > build-$c.txt 2>&1"; log "lua $c exit $?"
done
# The checks: speedtest1's --verify hash, and each script's output against clang -O0's.
$L bash -c "cd $W/out/st && for c in $BUILDS; do rm -rf /tmp/177-claude-db*; ./speedtest1-\$c $OPTS --verify /tmp/177-claude-db 2>&1 | grep 'Verification Hash' | sed \"s/^/\$c /\"; done" > $W/out/st/verify.txt 2>&1
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
$L bash -c "cd $W/out/st && taskset -c 2 $B time-runs --runs 11 --warmups 1 $st_builds --list /tmp/177-claude-db" > $W/out/st/time-runs.txt 2>&1; log "time-runs speedtest1 exit $?"
$L bash -c "cd $W/out/lua && taskset -c 2 $B time-runs --runs 11 --warmups 1 --copies 3 --directory /tmp $lua_builds --list calls.lua --list tables.lua --list strings.lua --list arithmetic.lua --list closures.lua" > $W/out/lua/time-runs.txt 2>&1; log "time-runs lua exit $?"
# 4. Frames.
$L bash -c "cd $W/out/frames && $B -c $FLAGS -I$Q -o sqlite3-t0.o $Q/sqlite3.c && $B --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o sqlite3-t1.o $Q/sqlite3.c && $B --tier1 -fno-asynchronous-unwind-tables --tier1-no-lifetimes -c $FLAGS -I$Q -o sqlite3-t1nl.o $Q/sqlite3.c && clang -O2 -c $FLAGS -I$Q -o sqlite3-clang2.o $Q/sqlite3.c && clang -O0 -c $FLAGS -I$Q -o sqlite3-clang0.o $Q/sqlite3.c"; log "frames objects exit $?"
$L bash -c "cd $W/out/frames && $B measure-frames --functions clang2=sqlite3-clang2.o t1=sqlite3-t1.o t1nl=sqlite3-t1nl.o t0=sqlite3-t0.o clang0=sqlite3-clang0.o > sqlite3-frames.tsv && $B measure-frames --functions clang2=$W/out/lua/lua-clang2 t1=$W/out/lua/lua-t1 t1nl=$W/out/lua/lua-t1nl t0=$W/out/lua/lua-t0 clang0=$W/out/lua/lua-clang0 > lua-frames.tsv"; log "frames exit $?"
grep '^frames' $W/out/frames/*.tsv >> $W/out/steps.log
log "done"
