#!/usr/bin/env bash
# luacount.sh DIR: DIR/lua-t1's five scripts checked against clang -O0's outputs (S/ref), then each under callgrind;
# DIR/instructions.txt has each script's whole-process count.
set -u
S=$HOME/.cache/claude-2843/S
d=$(readlink -f $1); mkdir -p $d/cg
: > $d/check.txt
for s in calls tables strings arithmetic closures; do
    (cd $S/inputs && $d/lua-t1 $s.lua > $d/$s.out 2>&1); rc=$?
    if [ -f $S/ref/$s.out ] && cmp -s $d/$s.out $S/ref/$s.out; then same=same; else same=DIFF; fi
    echo "$s $rc $same" >> $d/check.txt
done
for s in calls tables strings arithmetic closures; do
    (cd $S/inputs && valgrind --tool=callgrind --callgrind-out-file=$d/cg/$s.cg $d/lua-t1 $s.lua > $d/cg/$s.out 2> $d/cg/$s.err) &
done
wait
for s in calls tables strings arithmetic closures; do echo "$s $(grep -m1 '^summary' $d/cg/$s.cg | cut -d' ' -f2)"; done > $d/instructions.txt
cat $d/check.txt
awk '{s+=$2} END {printf "total %.2f M\n", s/1e6}' $d/instructions.txt
