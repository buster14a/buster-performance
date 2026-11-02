#!/bin/bash
# musl's -c by main and the head, 8 lanes and one, 11 runs, with peaks (the units that the head's probe compiles).
set -u
W=$HOME/buster-fast-bench/777-claude
MAIN=${1:?main tree}
HEAD=${2:?head tree}
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
statuses() { echo "runs with status 0: $(grep -c 'status 0$' $1); other: $(grep -E '^(run|warm-up).*status' $1 | grep -v -c 'status 0$')"; grep -E 'FAILED' $1 | head -3; }
M=$W/$MAIN/build/compiler
H=$W/$HEAD/build/compiler
for TREE in $MAIN $HEAD; do echo "tree $TREE commit $(cat $W/$TREE/COMMIT)"; sha256sum $W/$TREE/build/compiler; done
OUT=$W/musl-$HEAD
rm -rf $OUT && mkdir -p $OUT/probe && cd $OUT
m=$HOME/buster-fast-bench/refine-claude/inputs/musl
flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
base=$(cd $m && ls src/*/*.c | sort)
replaced=$(cd $m && for a in src/*/x86_64/*.[csS]; do d2=$(dirname $(dirname $a)); f=$(basename $a); echo "$d2/${f%.*}.c"; done | sort -u)
selected=$( (comm -23 <(echo "$base") <(echo "$replaced"); cd $m && ls src/*/x86_64/*.c) | sort)
(cd probe && lock taskset -c 0-7 $H --lanes 8 -c $flags $(for s in $selected; do echo -n "$m/$s "; done) 2> ../probe_errors.txt; echo "probe status $?")
units=$(for s in $selected; do f=$(basename $s .c); [ -f probe/$f.o ] && echo -n "$m/$s "; done)
echo "== musl's -c, $(echo $units | wc -w) units of $(echo $selected | wc -w): lists 1-2 --lanes 8 by main, head; 3-4 --lanes 1"
lists=()
for lanes in 8 1; do for C in $M $H; do lists+=(--list -c "rm -f *.o; taskset -c 0-7 $C --lanes $lanes -c $flags $units"); done; done
lock $H time-runs --executable /bin/sh --runs 11 "${lists[@]}" > musl.log 2>&1
statuses musl.log; results < musl.log
echo musl-finished
