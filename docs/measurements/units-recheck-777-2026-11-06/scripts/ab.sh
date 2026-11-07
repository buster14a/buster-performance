#!/bin/bash
# #777's change on the 9700X: the head (a lane with a unit left keeps its scratch's pages) against main, with #763's merge
# beside them, every process on CPUs 0 to 7, each corpus one time-runs (a warm-up, then runs in an order that rotates):
# Lua's and synth's links and musl's 1,006 units with -c, by 8 lanes and by one; and a few large units (sqlite3.c and
# shell.c) as one command against its two processes at once, with -c and linked, in two rounds. Each run's outputs are
# removed before it and required after it, and the objects and executables compared afterwards.
# Usage: ab.sh HEAD MAIN BASE [lua|synth|musl|sqlite]...
. $(dirname $0)/common.sh
HEAD=${1:?head tree}
MAIN=${2:?main tree}
BASE=${3:?base tree}
shift 3
echo "== receipts"
receipts
build $HEAD
build $MAIN
build $BASE
X=$W/$HEAD/build/compiler
M=$W/$MAIN/build/compiler
B=$W/$BASE/build/compiler
OUT=$W/ab-$HEAD
mkdir -p $OUT
P="taskset -c 0-7"
both="test \$sa = 0 && test \$sb = 0"
three() { echo "lists: 1-3 --lanes 8 by $HEAD, $MAIN, $BASE; 4-6 --lanes 1 by $HEAD, $MAIN, $BASE"; }

lua() {
    local src=$HOME/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src d=$OUT/lua
    rm -rf $d && mkdir -p $d && cd $d
    local files=$(cd $src && ls *.c | grep -v '^luac.c$' | sed "s|^|$src/|" | tr '\n' ' ')
    local flags="-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX"
    echo "== lua's link, 33 units; $(three)"
    local lists=() n=0
    for lanes in 8 1; do for C in $X $M $B; do n=$((n + 1)); mkdir -p l$n; lists+=(--list -c "cd $d/l$n && rm -f lua && $P $C --lanes $lanes $flags -o lua $files -lm -ldl && test -x lua"); done; done
    lock $X time-runs --executable /bin/sh --runs ${RUNS_LUA:-21} "${lists[@]}" > runs.log 2>&1
    statuses runs.log; results < runs.log
    for l in 1 2 4 5; do echo "l$l: $(echo 'print(6 * 7)' | ./l$l/lua -)"; done
    cmp l1/lua l2/lua && cmp l4/lua l5/lua && cmp l1/lua l4/lua && echo "head's and main's executables: the same bytes"
}

synth() {
    local src=$HOME/buster-fast-bench/units-152-claude/explore/synth d=$OUT/synth
    rm -rf $d && mkdir -p $d && cd $d
    local files=$(ls $src/unit_*.c | tr '\n' ' ')
    echo "== synth's link, 512 units; $(three)"
    local lists=() n=0
    for lanes in 8 1; do for C in $X $M $B; do n=$((n + 1)); mkdir -p l$n; lists+=(--list -c "cd $d/l$n && rm -f synth && $P $C --lanes $lanes -o synth $files && test -x synth"); done; done
    lock $X time-runs --executable /bin/sh --runs ${RUNS_SYNTH:-7} "${lists[@]}" > runs.log 2>&1
    statuses runs.log; results < runs.log
    for l in 1 4; do echo "l$l: $(./l$l/synth | tail -1)"; done
    cmp l1/synth l2/synth && cmp l4/synth l5/synth && cmp l1/synth l4/synth && echo "head's and main's executables: the same bytes"
}

musl() {
    local m=$HOME/buster-fast-bench/refine-claude/inputs/musl d=$OUT/musl
    rm -rf $d && mkdir -p $d && cd $d
    local flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
    local units=$(tr '\n' ' ' < $W/scripts/musl-units-763.txt)
    echo "== musl's 1,006 units with -c; $(three)"
    local lists=() n=0
    for lanes in 8 1; do for C in $X $M $B; do n=$((n + 1)); mkdir -p l$n; lists+=(--list -c "cd $d/l$n && rm -f *.o && $P $C --lanes $lanes -c $flags $units"); done; done
    lock $X time-runs --executable /bin/sh --runs ${RUNS_MUSL:-7} "${lists[@]}" > runs.log 2>&1
    statuses runs.log; results < runs.log
    local differ=0
    for o in l1/*.o; do n=$(basename $o); for l in l2 l4 l5; do cmp -s $o $l/$n || differ=$((differ + 1)); done; done
    echo "objects: $(ls l1/*.o | wc -l) by head's 8 lanes; differing from main's 8 and 1 lanes' and head's 1 lane's: $differ"
}

sqlite() {
    local S=$HOME/buster-fast-bench/claude-linker-80/inputs/sqlite-amalgamation-3530400 d=$OUT/sqlite
    rm -rf $d && mkdir -p $d/ref && cd $d
    lock bash -c "cd ref && $P $M -c $S/sqlite3.c; echo main sqlite3 status \$?; $P $M -c $S/shell.c; echo main shell status \$?"
    two() { echo "rm -f sqlite3.o shell.o && { $P $1 -c $S/sqlite3.c & a=\$!; $P $1 -c $S/shell.c & b=\$!; wait \$a; sa=\$?; wait \$b; sb=\$?; $both; } && test -s sqlite3.o && test -s shell.o"; }
    echo "== a few large units; lists 1-2 -c one command by $HEAD, $MAIN; 3 -c two processes by $HEAD;"
    echo "   4-5 linked one command by $HEAD, $MAIN; 6 two processes by $HEAD then mold's link"
    for round in 1 2; do
        local lists=() n=0
        for C in $X $M; do n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && rm -f sqlite3.o shell.o && $P $C -c $S/sqlite3.c $S/shell.c && test -s sqlite3.o && test -s shell.o"); done
        n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && $(two $X)")
        for C in $X $M; do n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && rm -f sq && $P $C -o sq $S/sqlite3.c $S/shell.c -lm && test -x sq"); done
        n=$((n + 1)); mkdir -p r$round/l$n; lists+=(--list -c "cd $d/r$round/l$n && rm -f sq && $(two $X) && $P cc -fuse-ld=mold -o sq sqlite3.o shell.o -lm && test -x sq")
        echo "-- round $round, ${RUNS_SQLITE:-31} runs"
        lock $X time-runs --executable /bin/sh --runs ${RUNS_SQLITE:-31} "${lists[@]}" > runs-$round.log 2>&1
        echo "time-runs status $?"
        statuses runs-$round.log; results < runs-$round.log
        for l in 1 2 3 6; do for o in sqlite3.o shell.o; do cmp -s r$round/l$l/$o ref/$o || echo "r$round/l$l/$o: DIFFERS"; done; done
        echo "objects compared with main's alone"
        for l in 4 5 6; do echo "r$round/l$l/sq: $(echo 'select 6 * 7;' | ./r$round/l$l/sq)"; done
        cmp r$round/l4/sq r$round/l5/sq && echo "linked by the head and by main: the same bytes"
    done
}

for corpus in "$@"; do $corpus; done
echo ab-finished
