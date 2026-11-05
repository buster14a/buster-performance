#!/usr/bin/env bash
# callsave: #177's call-save rows (claude/tier1-call-save-rows) against main on the 9700X. Every step one hold of the
# shared lock, every timed run its own hold, pinned to CPU 2.
#  1. main (MAIN) and head (HEAD) built (znver5). Tier 0's objects of sqlite3.c must be the same (the change is Tier 1's).
#  2. speedtest1 and Lua 5.4.8 built by --tier1 of each; speedtest1's --verify hash and each Lua script's output must
#     agree with clang -O0's (Lua) and across builds (speedtest1).
#  3. Run time: 11 rounds, main and head alternating (the order flipping by round), each run one hold: speedtest1 from a
#     fresh database and Lua's five scripts; perf stat's task-clock, cycles and instructions.
#  4. Compile time of -c sqlite3.c --tier1: 11 rounds alternating, perf stat instructions and cycles.
#  5. Frames: measure-frames (head's) of sqlite3.c's objects and Lua's executables, by Tier 1 of each and Tier 0, against
#     clang -O2's.
set -u
MAIN=${1:?main commit}
HEAD=${2:?head commit}
W=$HOME/buster-fast-bench/177-callsave-claude
export EXCLUSIVE_OWNER=claude-177-callsave EXCLUSIVE_TITLE='Problems 141, 177, 789' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/177
L="$HOME/buster-fast-bench/exclusive.sh"
Q=$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite
ST=$HOME/buster-fast-bench/speedtest1-136-claude/src
LUA=$HOME/buster-fast-bench/claude-141-reciprocal/inputs/lua-5.4.8/src
SCRIPTS=$HOME/buster-fast-bench/claude-141-reciprocal/lua
FLAGS="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE"
OPTS="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
mkdir -p $W/out && cd $W || exit 1
log() { echo "$(date -u +%FT%TZ) $*" >> $W/out/steps.log; }
log "start main=$MAIN head=$HEAD"
for t in main head; do
    commit=$([ $t = main ] && echo $MAIN || echo $HEAD)
    if [ ! -d $t ]; then git clone -q https://github.com/buster14a/buster $t; fi
    (cd $t && git fetch -q origin main claude/tier1-call-save-rows && git checkout -q $commit && git log -1 --format=%H > ../out/$t.commit)
    $L bash -c "cd $W/$t && BUSTER_HOST_ARCH=znver5 ./build.sh > $W/out/build-$t.log 2>&1"; log "build $t exit $?"
done
B=$W/head/build/compiler
M=$W/main/build/compiler
sha256sum $Q/sqlite3.c $ST/speedtest1.c > $W/out/inputs.txt
# 1. Tier 0's objects, the same.
mkdir -p $W/out/identity
$L bash -c "cd $W/out/identity && $M -c $FLAGS -I$Q -o t0-main.o $Q/sqlite3.c && $B -c $FLAGS -I$Q -o t0-head.o $Q/sqlite3.c && (cmp -s t0-main.o t0-head.o && echo t0-same || echo t0-differs)" > $W/out/identity.txt 2>&1
log "identity $(tr '\n' ' ' < $W/out/identity.txt)"
# 2. The programs' builds.
cc_of() {
    case $1 in
        t1main) echo "$M --tier1 -fno-asynchronous-unwind-tables" ;;
        t1head) echo "$B --tier1 -fno-asynchronous-unwind-tables" ;;
        t0) echo "$B" ;;
        clang2) echo "clang -O2" ;;
        clang0) echo "clang -O0" ;;
    esac
}
mkdir -p $W/out/st $W/out/lua $W/out/frames
cp $SCRIPTS/*.lua $W/out/lua/
lua_files=""
for f in lapi lcode lctype ldebug ldo ldump lfunc lgc llex lmem lobject lopcodes lparser lstate lstring ltable ltm lundump lvm lzio lauxlib lbaselib lcorolib ldblib liolib lmathlib loadlib loslib lstrlib ltablib lutf8lib linit lua; do
    lua_files="$lua_files $LUA/$f.c"
done
for c in t1main t1head; do
    $L bash -c "cd $W/out/st && $(cc_of $c) $FLAGS -I$Q -I$ST -o speedtest1-$c $ST/speedtest1-unity.c -lm > build-$c.txt 2>&1"; log "speedtest1 $c exit $?"
    printf '#!/bin/bash\nrm -rf "$1" "$1"-wal "$1"-shm "$1"-journal /tmp/177-callsave-tmp; mkdir -p /tmp/177-callsave-tmp\nSQLITE_TMPDIR=/tmp/177-callsave-tmp exec %s/out/st/speedtest1-%s %s "$1"\n' "$W" "$c" "$OPTS" > $W/out/st/run-$c.sh
    chmod +x $W/out/st/run-$c.sh
done
for c in t1main t1head t0 clang2 clang0; do
    $L bash -c "cd $W/out/lua && $(cc_of $c) -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua-$c $lua_files -lm -ldl > build-$c.txt 2>&1"; log "lua $c exit $?"
done
$L bash -c "cd $W/out/st && for c in t1main t1head; do rm -rf /tmp/177-callsave-db*; ./speedtest1-\$c $OPTS --verify /tmp/177-callsave-db 2>&1 | grep 'Verification Hash' | sed \"s/^/\$c /\"; done" > $W/out/st/verify.txt 2>&1
log "verify hashes $(awk '{print $NF}' $W/out/st/verify.txt | sort -u | wc -l) distinct of $(wc -l < $W/out/st/verify.txt)"
$L bash -c "cd $W/out/lua && for s in calls tables strings arithmetic closures; do ./lua-clang0 \$s.lua > \$s-clang0.out 2>&1; for c in t1main t1head t0; do ./lua-\$c \$s.lua > \$s-\$c.out 2>&1; cmp -s \$s-clang0.out \$s-\$c.out && echo \"\$s \$c same\" || echo \"\$s \$c differs\"; done; done" > $W/out/lua/compare.txt 2>&1
log "lua compare $(grep -c same $W/out/lua/compare.txt) same, $(grep -c differs $W/out/lua/compare.txt) differ"
# 5. Frames (before the timing, which takes longest).
$L bash -c "cd $W/out/frames && $B -c $FLAGS -I$Q -o sqlite3-t0.o $Q/sqlite3.c && $M --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o sqlite3-t1main.o $Q/sqlite3.c && $B --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o sqlite3-t1head.o $Q/sqlite3.c && clang -O2 -c $FLAGS -I$Q -o sqlite3-clang2.o $Q/sqlite3.c"; log "frames objects exit $?"
$L bash -c "cd $W/out/frames && $B measure-frames --functions clang2=sqlite3-clang2.o t1head=sqlite3-t1head.o t1main=sqlite3-t1main.o t0=sqlite3-t0.o > sqlite3-frames.tsv && $B measure-frames --functions clang2=$W/out/lua/lua-clang2 t1head=$W/out/lua/lua-t1head t1main=$W/out/lua/lua-t1main t0=$W/out/lua/lua-t0 > lua-frames.tsv"; log "frames exit $?"
grep -h '^frames' $W/out/frames/*.tsv >> $W/out/steps.log
# 3. Run time, each run one hold.
: > $W/out/st/runs.txt
: > $W/out/lua/runs.txt
: > $W/out/compile.txt
for round in $(seq 1 11); do
    order="t1main t1head"; [ $((round % 2)) = 0 ] && order="t1head t1main"
    for c in $order; do
        $L taskset -c 2 perf stat -x, -e task-clock,instructions:u,cycles:u -o $W/out/st/one.txt $W/out/st/run-$c.sh /tmp/177-callsave-db > /dev/null 2>&1
        awk -F, -v c=$c -v r=$round '/task-clock/{t=$1} /instructions/{i=$1} /cycles/{y=$1} END{print r, c, t, i, y}' $W/out/st/one.txt >> $W/out/st/runs.txt
        for s in calls tables strings arithmetic closures; do
            $L bash -c "cd $W/out/lua && taskset -c 2 perf stat -x, -e task-clock,instructions:u,cycles:u -o $W/out/lua/one.txt ./lua-$c $s.lua > /dev/null 2>&1"
            awk -F, -v c=$c -v r=$round -v s=$s '/task-clock/{t=$1} /instructions/{i=$1} /cycles/{y=$1} END{print r, c, s, t, i, y}' $W/out/lua/one.txt >> $W/out/lua/runs.txt
        done
        # 4. Compile time.
        exe=$([ $c = t1main ] && echo $M || echo $B)
        $L taskset -c 2 perf stat -x, -e task-clock,instructions:u,cycles:u -o $W/out/compile-one.txt $exe --tier1 -fno-asynchronous-unwind-tables -c $FLAGS -I$Q -o /dev/null $Q/sqlite3.c > /dev/null 2>&1
        awk -F, -v c=$c -v r=$round '/task-clock/{t=$1} /instructions/{i=$1} /cycles/{y=$1} END{print r, c, t, i, y}' $W/out/compile-one.txt >> $W/out/compile.txt
    done
    log "round $round"
done
# The tests that touch the change, on the 9700X (correctness only).
: > $W/out/tests.txt
for test in test-tier1-emit test-tier1-pipeline test-tier1-masks test-tier1-cfg test-tier1-frame-execution; do $L $B $test > $W/out/test-$test.log 2>&1; echo "$test exit=$?" >> $W/out/tests.txt; done
log "done"
