#!/bin/bash
# #777's evidence on the 9700X for the head whose links' last lane releases its memory before the link: its units
# tests; a few large units (SQLite 3.53.4's sqlite3.c and shell.c) as one command against their two processes at once
# (each child's status checked, every output removed before each run and required after it), with -c and linked (cc's
# link, and cc's with mold); Lua's and synth's links by 8 lanes and by one, with their peaks. Every build, test and
# measurement holds the host's lock for itself.
set -u
W=$HOME/buster-fast-bench/777-claude
MAIN=${1:?main tree}
HEAD=${2:?head tree}
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
statuses() { echo "runs with status 0: $(grep -c 'status 0$' $1); other: $(grep -E '^(run|warm-up).*status' $1 | grep -v -c 'status 0$')"; grep -E 'FAILED' $1 | head -3; }
for c in 0 1 2 3 4 5 6 7; do echo "cpu$c $(cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor) $(cat /sys/devices/system/cpu/cpu$c/cpufreq/energy_performance_preference)"; done
for TREE in $MAIN $HEAD; do
    T=$W/$TREE
    if [ ! -x $T/build/compiler ]; then
        (cd $T && BUSTER_DEBUG_INFO=0 lock ./build.sh 2>&1 | tail -2)
    fi
    [ -x $T/build/compiler ] || { echo "the build of $TREE failed"; exit 1; }
    echo "tree $TREE commit $(cat $T/COMMIT)"
    sha256sum $T/build/compiler
done
M=$W/$MAIN/build/compiler
H=$W/$HEAD/build/compiler
OUT=$W/final2-$HEAD
rm -rf $OUT && mkdir -p $OUT
echo "== tests at the head"
cd $W/$HEAD
ln -sfn $HOME/buster-fast-bench/units-152-claude/inputs/c-testsuite build/c-testsuite
n=0
for t in "test-check-units" "test-check-units --corpus build/c-testsuite/tests/single-exec"; do
    n=$((n + 1))
    lock bash -c "taskset -c 0-7 ./build/compiler $t > $OUT/test-$n.log 2>&1; echo \"$t: status \$?\""
    grep "shared parts" $OUT/test-$n.log
    tail -1 $OUT/test-$n.log
done
lock bash -c "clang -std=c17 -O2 -march=native -Wall -Wextra -Werror -fno-strict-aliasing tests/driver/multicore.c -o build/test-driver-multicore && taskset -c 0-7 ./build/test-driver-multicore ./build/compiler > $OUT/test-multicore.log 2>&1; echo \"test-driver-multicore: status \$?\"; tail -1 $OUT/test-multicore.log"
lock bash -c "./build/compiler test-call-graph 2>&1 | tail -1; ./build.sh check-call-graph 2>&1 | tail -2"
S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
cd $OUT
mkdir -p ref
lock bash -c "cd ref && taskset -c 0-7 $M -c $S/sqlite3.c; echo main sqlite3 status \$?; taskset -c 0-7 $M -c $S/shell.c; echo main shell status \$?"
echo "== a few large units: lists 1-2 -c one command by main, head; 3 -c two processes by head;"
echo "   4-5 linked one command by main, head; 6 two processes by head then cc's link; 7 the same with mold"
both="test \$sa = 0 && test \$sb = 0"
two() { echo "rm -f sqlite3.o shell.o && { taskset -c 0-7 $1 -c $S/sqlite3.c & a=\$!; taskset -c 0-7 $1 -c $S/shell.c & b=\$!; wait \$a; sa=\$?; wait \$b; sb=\$?; $both; } && test -s sqlite3.o && test -s shell.o"; }
for round in 1 2; do
    lists=()
    n=0
    for C in $M $H; do n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $OUT/r$round/l$n && rm -f sqlite3.o shell.o && taskset -c 0-7 $C -c $S/sqlite3.c $S/shell.c && test -s sqlite3.o && test -s shell.o"); done
    n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $OUT/r$round/l$n && $(two $H)")
    for C in $M $H; do n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $OUT/r$round/l$n && rm -f sq && taskset -c 0-7 $C -o sq $S/sqlite3.c $S/shell.c -lm && test -x sq"); done
    n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $OUT/r$round/l$n && rm -f sq && $(two $H) && taskset -c 0-7 cc -o sq sqlite3.o shell.o -lm && test -x sq")
    n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $OUT/r$round/l$n && rm -f sq && $(two $H) && taskset -c 0-7 cc -fuse-ld=mold -o sq sqlite3.o shell.o -lm && test -x sq")
    echo "-- round $round, 31 runs"
    lock $H time-runs --executable /bin/sh --runs 31 "${lists[@]}" > runs-$round.log 2>&1
    echo "time-runs status $?"
    statuses runs-$round.log
    results < runs-$round.log
    for d in r$round/l*; do for o in sqlite3.o shell.o; do [ -f $d/$o ] && { cmp -s $d/$o ref/$o || echo "$d/$o: DIFFERS"; }; done; [ -x $d/sq ] && echo "$d/sq: $(echo 'select 6 * 7;' | ./$d/sq)"; done
    echo "objects compared with main's alone"
done
cmp r1/l4/sq r1/l5/sq && echo "linked by main and by the head: the same bytes"
mkdir -p runs && cd runs
SYN=$(ls $HOME/buster-fast-bench/units-152-claude/explore/synth/unit_*.c | tr '\n' ' ')
echo "== synth's link: lists 1-2 --lanes 8 by main, head; 3-4 --lanes 1"
lists=()
for lanes in 8 1; do for C in $M $H; do lists+=(--list -c "taskset -c 0-7 $C --lanes $lanes -o synth_tr $SYN"); done; done
lock $H time-runs --executable /bin/sh --runs 7 "${lists[@]}" > synth.log 2>&1
statuses synth.log; results < synth.log
./synth_tr | tail -1
LUA=$HOME/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
LUAFILES=$(cd $LUA && ls *.c | grep -v '^luac.c$' | sed "s|^|$LUA/|" | tr '\n' ' ')
DEFINES="-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
echo "== Lua's link: lists 1-2 --lanes 8 by main, head; 3-4 --lanes 1"
lists=()
for lanes in 8 1; do for C in $M $H; do lists+=(--list -c "taskset -c 0-7 $C --lanes $lanes $DEFINES -o lua_tr $LUAFILES -lm -ldl"); done; done
lock $H time-runs --executable /bin/sh --runs 15 "${lists[@]}" > lua.log 2>&1
statuses lua.log; results < lua.log
echo 'print(6 * 7)' | ./lua_tr -
echo final2-finished
