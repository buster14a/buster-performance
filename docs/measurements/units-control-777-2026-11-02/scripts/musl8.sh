#!/bin/bash
# musl's -c by 8 lanes, by each tree given, interleaved, 11 runs, with peaks.
set -u
W=$HOME/buster-fast-bench/777-claude
NAME=${1:?name}
shift
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-777 EXCLUSIVE_TITLE="solve 777" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/777" ~/buster-fast-bench/exclusive.sh "$@"; }
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
statuses() { echo "runs with status 0: $(grep -c 'status 0$' $1); other: $(grep -E '^(run|warm-up).*status' $1 | grep -v -c 'status 0$')"; grep -E 'FAILED' $1 | head -3; }
for TREE in "$@"; do echo "tree $TREE commit $(cat $W/$TREE/COMMIT)"; sha256sum $W/$TREE/build/compiler; done
OUT=$W/musl8-$NAME
rm -rf $OUT && mkdir -p $OUT && cd $OUT
m=$HOME/buster-fast-bench/refine-claude/inputs/musl
flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
base=$(cd $m && ls src/*/*.c | sort)
replaced=$(cd $m && for a in src/*/x86_64/*.[csS]; do d2=$(dirname $(dirname $a)); f=$(basename $a); echo "$d2/${f%.*}.c"; done | sort -u)
units=$( (comm -23 <(echo "$base") <(echo "$replaced"); cd $m && ls src/*/x86_64/*.c) | sort | sed "s|^|$m/|" | tr '\n' ' ')
echo "== musl's -c, $(echo $units | wc -w) units by 8 lanes: one list per tree, in the order given"
lists=()
for TREE in "$@"; do lists+=(--list -c "rm -f *.o; taskset -c 0-7 $W/$TREE/build/compiler --lanes 8 -c $flags $units"); done
lock $W/$1/build/compiler time-runs --executable /bin/sh --runs 11 "${lists[@]}" > musl.log 2>&1
statuses musl.log; results < musl.log
echo musl8-finished
