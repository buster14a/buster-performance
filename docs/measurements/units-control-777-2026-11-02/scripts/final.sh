#!/bin/bash
# #777's evidence on the 9700X: the head (lanes free their memory once they take no units, the last one at exit)
# against main: its tests; a few large units (SQLite 3.53.4's sqlite3.c and shell.c) as one command against their two
# processes at once, each child's status checked and every output removed before each run and required after it, with
# -c and linked (cc's link, and cc's with mold); --time-stages of the one command; Lua's, synth's and musl's commands
# by 8 lanes and by one, with their peaks; and a command of one file by perf stat on CPU 2. Every build, test and
# measurement holds the host's lock for itself.
set -u
W=$HOME/buster-fast-bench/777-claude
MAIN=${1:?main tree}
HEAD=${2:?head tree}
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
statuses() { echo "runs with status 0: $(grep -c 'status 0$' $1); other: $(grep -E '^(run|warm-up).*status' $1 | grep -v -c 'status 0$')"; grep -E 'FAILED' $1 | head -3; }
echo "== receipts"
uname -a; clang --version | head -1; perf --version; cc --version | head -1; mold --version
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
OUT=$W/final-$HEAD
rm -rf $OUT && mkdir -p $OUT

echo "== tests at the head"
cd $W/$HEAD
ln -sfn $HOME/buster-fast-bench/units-152-claude/inputs/c-testsuite build/c-testsuite
n=0
for t in "test-check-units" "test-check-units --corpus build/c-testsuite/tests/single-exec" "test-check-lanes" "test-checker-driver --executable ./build/compiler" "test-check-debug --cross-check"; do
    n=$((n + 1))
    lock bash -c "taskset -c 0-7 ./build/compiler $t > $OUT/test-$n.log 2>&1; echo \"$t: status \$?\""
    grep -m5 -i "fail" $OUT/test-$n.log
    grep "shared parts" $OUT/test-$n.log
    tail -1 $OUT/test-$n.log
done
lock bash -c "./build/compiler test-lanes > $OUT/test-lanes.log 2>&1; echo \"test-lanes: status \$?\"; tail -1 $OUT/test-lanes.log"
lock bash -c "clang -std=c17 -O2 -march=native -Wall -Wextra -Werror -fno-strict-aliasing tests/driver/multicore.c -o build/test-driver-multicore && taskset -c 0-7 ./build/test-driver-multicore ./build/compiler > $OUT/test-multicore.log 2>&1; echo \"test-driver-multicore: status \$?\"; tail -1 $OUT/test-multicore.log"
lock bash -c "./build/compiler test-call-graph 2>&1 | tail -1; ./build.sh check-call-graph 2>&1 | tail -2"

S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400
sha256sum $S/sqlite3.c $S/shell.c
cd $OUT
mkdir -p ref
lock bash -c "cd ref && taskset -c 0-7 $M -c $S/sqlite3.c; echo main sqlite3 status \$?; taskset -c 0-7 $M -c $S/shell.c; echo main shell status \$?; mkdir -p h && cd h && taskset -c 0-7 $H -c --shared-parts $S/sqlite3.c $S/shell.c; echo head one-command status \$?"
cmp ref/sqlite3.o ref/h/sqlite3.o && cmp ref/shell.o ref/h/shell.o && echo "head's one command: main's objects alone"
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
    for d in r$round/l*; do for o in sqlite3.o shell.o; do [ -f $d/$o ] && { cmp -s $d/$o ref/$o && echo "$d/$o: main's alone" || echo "$d/$o: DIFFERS"; }; done; [ -x $d/sq ] && echo "$d/sq: $(echo 'select 6 * 7;' | ./$d/sq)"; done
done
cmp r1/l4/sq r1/l5/sq && echo "linked by main and by the head: the same bytes"
echo "== --time-stages of the one command by the head, five runs"
mkdir -p stages
lock bash -c "cd stages && for i in 1 2 3 4 5; do rm -f *.o; taskset -c 0-7 $H --time-stages -c $S/sqlite3.c $S/shell.c 2> one-\$i.txt; echo status \$?; done"
for i in 1 2 3 4 5; do tr '\t' ' ' < stages/one-$i.txt | grep -E '^time-(stage (setup|lanes-start|lanes|release|total)|process (user-ms|system-ms|peak-rss-kb)) ' | tr '\n' ' '; echo; done

cd $OUT && mkdir -p runs
cd runs
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
cd $OUT && mkdir -p musl/probe && cd musl
m=$HOME/buster-fast-bench/refine-claude/inputs/musl
flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
base=$(cd $m && ls src/*/*.c | sort)
replaced=$(cd $m && for a in src/*/x86_64/*.[csS]; do d2=$(dirname $(dirname $a)); f=$(basename $a); echo "$d2/${f%.*}.c"; done | sort -u)
selected=$( (comm -23 <(echo "$base") <(echo "$replaced"); cd $m && ls src/*/x86_64/*.c) | sort)
(cd probe && lock taskset -c 0-7 $H --lanes 8 -c $flags $(for s in $selected; do echo -n "$m/$s "; done) 2> ../probe_errors.txt)
units=$(for s in $selected; do f=$(basename $s .c); [ -f probe/$f.o ] && echo -n "$m/$s "; done)
echo "== musl's -c, $(echo $units | wc -w) units: lists 1-2 --lanes 8 by main, head; 3-4 --lanes 1"
lists=()
for lanes in 8 1; do for C in $M $H; do lists+=(--list -c "rm -f *.o; taskset -c 0-7 $C --lanes $lanes -c $flags $units"); done; done
lock $H time-runs --executable /bin/sh --runs 7 "${lists[@]}" > musl.log 2>&1
statuses musl.log; results < musl.log

echo "== one file, -c sqlite3.c, perf stat -r 11 on CPU 2, main and head in turn"
cd $OUT && mkdir -p onefile && cd onefile
for round in 1 2 3; do for C in $M $H; do
    lock bash -c "perf stat -x, -e task-clock,cycles:u,instructions:u -r 11 taskset -c 2 $C -c $S/sqlite3.c 2> perf.txt; echo \"$C round $round status \$?\"; cat perf.txt"
done; done
cmp sqlite3.o $OUT/ref/sqlite3.o && echo "one file: main's object"
echo final-finished
