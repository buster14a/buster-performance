#!/bin/bash
# #777's "Done when" on the 9700X at a tree, against #763's merge built and run beside it, every process on CPUs 0 to 7:
# - a few large units: SQLite 3.53.4's sqlite3.c and shell.c as one command against its units' two processes at once,
#   with -c and linked (mold's and cc's link of the processes' objects), each child's status checked and every output
#   removed before each run and required after it;
# - #763's record's commands (Lua 5.4.8's interpreter linked, synth's 512 units linked, musl 1.2.5's 1,006 units of
#   #763's record with -c) by 8 lanes and by one, by the tree and by #763, with their peaks.
# Each time-runs is one hold of the lock; every build and test holds it for itself.
# Usage: measure.sh TREE BASE [sqlite|lua|synth|musl]...
. $(dirname $0)/common.sh
TREE=${1:?tree}
BASE=${2:?base tree}
shift 2
echo "== receipts"
receipts
build $TREE
build $BASE
H=$W/$TREE/build/compiler
B=$W/$BASE/build/compiler
OUT=$W/measure-$TREE
mkdir -p $OUT
P="taskset -c 0-7"
both="test \$sa = 0 && test \$sb = 0"

sqlite() {
    local S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400 d=$OUT/sqlite
    rm -rf $d && mkdir -p $d/ref/one $d/ref/two && cd $d
    sha256sum $S/sqlite3.c $S/shell.c
    lock bash -c "cd ref/one && $P $H -c --shared-parts $S/sqlite3.c $S/shell.c 2>&1 | tail -3; echo one-c status \$?; cd ../two && $P $H -c $S/sqlite3.c; echo sqlite3 status \$?; $P $H -c $S/shell.c; echo shell status \$?"
    cmp ref/one/sqlite3.o ref/two/sqlite3.o && cmp ref/one/shell.o ref/two/shell.o && echo "one command's objects: each its unit's alone"
    two() { echo "rm -f sqlite3.o shell.o && { $P $1 -c $S/sqlite3.c & a=\$!; $P $1 -c $S/shell.c & b=\$!; wait \$a; sa=\$?; wait \$b; sb=\$?; $both; } && test -s sqlite3.o && test -s shell.o"; }
    echo "lists: 1 -c one command by $TREE; 2 -c two processes by $TREE; 3 linked one command by $TREE;"
    echo "       4 two processes by $TREE then mold's link; 5 the same with cc's link; 6 -c one command by $BASE; 7 linked one command by $BASE"
    for round in 1 2; do
        local lists=() n=0
        n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && rm -f sqlite3.o shell.o && $P $H -c $S/sqlite3.c $S/shell.c && test -s sqlite3.o && test -s shell.o")
        n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && $(two $H)")
        n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && rm -f sq && $P $H -o sq $S/sqlite3.c $S/shell.c -lm && test -x sq")
        n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && rm -f sq && $(two $H) && $P cc -fuse-ld=mold -o sq sqlite3.o shell.o -lm && test -x sq")
        n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && rm -f sq && $(two $H) && $P cc -o sq sqlite3.o shell.o -lm && test -x sq")
        n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && rm -f sqlite3.o shell.o && $P $B -c $S/sqlite3.c $S/shell.c && test -s sqlite3.o && test -s shell.o")
        n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && rm -f sq && $P $B -o sq $S/sqlite3.c $S/shell.c -lm && test -x sq")
        echo "-- round $round, ${RUNS_SQLITE:-31} runs"
        lock $H time-runs --executable /bin/sh --runs ${RUNS_SQLITE:-31} "${lists[@]}" > runs-$round.log 2>&1
        echo "time-runs status $?"
        statuses runs-$round.log
        results < runs-$round.log
        for l in 1 2 4 5; do for o in sqlite3.o shell.o; do cmp -s r$round/l$l/$o ref/two/$o || echo "r$round/l$l/$o: DIFFERS"; done; done
        for l in 3 4 5 7; do echo "r$round/l$l/sq: $(echo 'select 6 * 7;' | ./r$round/l$l/sq)"; done
    done
}

lua() {
    local src=$HOME/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src d=$OUT/lua
    rm -rf $d && mkdir -p $d/h $d/b && cd $d
    local files=$(cd $src && ls *.c | grep -v '^luac.c$' | sed "s|^|$src/|" | tr '\n' ' ')
    local flags="-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
    echo "== lua: $(echo $files | wc -w) units; lists 1-2 --lanes 8 by $TREE, $BASE; 3-4 --lanes 1 by $TREE, $BASE"
    local lists=()
    for lanes in 8 1; do lists+=(--list -c "cd $d/h && $P $H --lanes $lanes $flags -o lua $files -lm -ldl"); lists+=(--list -c "cd $d/b && $P $B --lanes $lanes $flags -o lua $files -lm -ldl"); done
    lock $H time-runs --executable /bin/sh --runs ${RUNS_LUA:-21} "${lists[@]}" > runs.log 2>&1
    statuses runs.log; results < runs.log
    echo 'print(6 * 7)' | ./h/lua -; echo 'print(6 * 7)' | ./b/lua -
}

synth() {
    local src=$HOME/buster-fast-bench/units-152-claude/explore/synth d=$OUT/synth
    rm -rf $d && mkdir -p $d/h $d/b && cd $d
    local files=$(ls $src/unit_*.c | tr '\n' ' ')
    echo "== synth: $(echo $files | wc -w) units; lists 1-2 --lanes 8 by $TREE, $BASE; 3-4 --lanes 1 by $TREE, $BASE"
    local lists=()
    for lanes in 8 1; do lists+=(--list -c "cd $d/h && $P $H --lanes $lanes -o synth $files"); lists+=(--list -c "cd $d/b && $P $B --lanes $lanes -o synth $files"); done
    lock $H time-runs --executable /bin/sh --runs ${RUNS_SYNTH:-7} "${lists[@]}" > runs.log 2>&1
    statuses runs.log; results < runs.log
    ./h/synth | tail -1; ./b/synth | tail -1
}

musl() {
    local m=$HOME/buster-fast-bench/refine-claude/inputs/musl d=$OUT/musl
    rm -rf $d && mkdir -p $d/h $d/b && cd $d
    local flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
    local units=$(tr '\n' ' ' < $W/scripts/musl-units-763.txt)
    echo "== musl: $(echo $units | wc -w) units (#763's record's); lists 1-2 --lanes 8 by $TREE, $BASE; 3-4 --lanes 1 by $TREE, $BASE"
    local lists=()
    for lanes in 8 1; do lists+=(--list -c "cd $d/h && rm -f *.o && $P $H --lanes $lanes -c $flags $units"); lists+=(--list -c "cd $d/b && rm -f *.o && $P $B --lanes $lanes -c $flags $units"); done
    lock $H time-runs --executable /bin/sh --runs ${RUNS_MUSL:-7} "${lists[@]}" > runs.log 2>&1
    statuses runs.log; results < runs.log
    echo "objects: $(ls h/*.o | wc -l) by $TREE, $(ls b/*.o | wc -l) by $BASE"
}

for corpus in "$@"; do $corpus; done
echo measure-finished
