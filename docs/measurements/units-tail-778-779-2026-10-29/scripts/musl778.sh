#!/bin/bash
# #778's musl -c by 8 lanes again, with more runs: #763's head (29770b85) against #778's (3c615fda), 21 runs each in a
# rotating order (time-runs), CPUs 0 to 7, one hold of the host's lock.
set -u
W=$HOME/buster-fast-bench/units-152-claude
E=$W/exp
export TMPDIR=$W/tmp
lock() { EXCLUSIVE_OWNER=claude-152 EXCLUSIVE_TITLE="tackle #776-#779 (units' link tail)" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/778" ~/buster-fast-bench/exclusive.sh "$@"; }
results() { sed -n 's/^\(list [0-9]*\) \[.*\]\(.*\)$/\1\2/p; /^time-runs:/p'; }
A=$E/tree-t763/build/compiler
H=$E/tree-t778/build/compiler
sha256sum $A $H
OUT=$W/musl778
rm -rf $OUT && mkdir -p $OUT && cd $OUT
m=$HOME/buster-fast-bench/refine-claude/inputs/musl
flags="-std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -I$m/arch/x86_64 -I$m/arch/generic -I$m/obj/src/internal -I$m/src/include -I$m/src/internal -I$m/obj/include -I$m/include"
units=$(for f in $W/ev778/musl/probe/*.o; do n=$(basename $f .o); done; true)
# The units ev778.sh's probe found the driver compiles, in its order.
selected=$(cd $m && (comm -23 <(ls src/*/*.c | sort) <(for a in src/*/x86_64/*.[csS]; do d2=$(dirname $(dirname $a)); f=$(basename $a); echo "$d2/${f%.*}.c"; done | sort -u); ls src/*/x86_64/*.c) | sort)
units=$(for s in $selected; do f=$(basename $s .c); [ -f $W/ev778/musl/probe/$f.o ] && echo -n "$m/$s "; done)
echo "== musl's -c by 8 lanes, $(echo $units | wc -w) units: list 1 #763, list 2 #778"
lists=()
for c in $A $H; do lists+=(--list -c "rm -f *.o; taskset -c 0-7 $c --lanes 8 -c $flags $units"); done
lock $H time-runs --executable /bin/sh --runs 21 "${lists[@]}" | results
echo musl778-finished
