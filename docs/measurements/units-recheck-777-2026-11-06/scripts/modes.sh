#!/bin/bash
# Which of the scratch's pages a units lane should give back, on the 9700X (transparent huge pages `always`): an
# experiment's build of main whose EXP_DISCARD_MODE picks check_program's discard: 0 main's (arena_discard: from the
# first huge page boundary past the length to the peak, in pages), 1 none, 2 whole huge pages only (the peak rounded
# down to a huge page boundary). Lua's and synth's links and musl's 1,006 units with -c, by 8 lanes and by one, each
# corpus one time-runs on CPUs 0 to 7.
# Usage: modes.sh TREE [lua|synth|musl]...
. $(dirname $0)/common.sh
TREE=${1:?tree}
shift
build $TREE
E=$W/$TREE/build/compiler
OUT=$W/modes-$TREE
mkdir -p $OUT
P="taskset -c 0-7"
run() {
    # $1 name, $2 command after the compiler (with LANES), $3 runs, $4 output test
    local name=$1 args=$2 runs=$3 check=$4 d=$OUT/$1
    rm -rf $d && mkdir -p $d && cd $d
    echo "== $name: lists 1-3 --lanes 8 by modes 0, 1, 2; 4-6 --lanes 1 by modes 0, 1, 2"
    local lists=() n=0
    for lanes in 8 1; do for m in 0 1 2; do n=$((n + 1)); mkdir -p l$n; lists+=(--list -c "cd $d/l$n && rm -f *.o && EXP_DISCARD_MODE=$m $P $E --lanes $lanes $args && $check"); done; done
    lock $E time-runs --executable /bin/sh --runs $runs "${lists[@]}" > runs.log 2>&1
    statuses runs.log; results < runs.log
}
lua() {
    local src=$HOME/buster-fast-bench/units-152-claude/inputs/lua-5.4.8/src
    run lua "-std=gnu99 -U__ELF__ -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -o lua $(cd $src && ls *.c | grep -v '^luac.c$' | sed "s|^|$src/|" | tr '\n' ' ') -lm -ldl" ${RUNS_LUA:-21} "test -x lua"
    for n in 1 2 3 4 5 6; do cmp -s l1/lua l$n/lua || echo "l$n/lua DIFFERS"; done
}
synth() {
    run synth "-o synth $(ls $HOME/buster-fast-bench/units-152-claude/explore/synth/unit_*.c | tr '\n' ' ')" ${RUNS_SYNTH:-7} "test -x synth"
    for n in 1 2 3 4 5 6; do cmp -s l1/synth l$n/synth || echo "l$n/synth DIFFERS"; done
}
musl() {
    local m=$HOME/buster-fast-bench/refine-claude/inputs/musl
    run musl "-c -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include $(tr '\n' ' ' < $W/scripts/musl-units-763.txt)" ${RUNS_MUSL:-7} "true"
    local differ=0; for o in l1/*.o; do for n in 2 3 4 5 6; do cmp -s $o l$n/$(basename $o) || differ=$((differ + 1)); done; done; echo "objects: $(ls l1/*.o | wc -l); differing between modes and lanes: $differ"
}
for corpus in "$@"; do $corpus; done
echo modes-finished
