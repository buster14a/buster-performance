#!/usr/bin/env bash
# luacount.sh DIR: DIR/lua-t1's five scripts checked against clang -O0's outputs ($S/ref) and run under callgrind,
# then joined by gap.c (GAP_INSTRUCTIONS=1) into DIR/*.tsv; prints whole-process counts and disptab-site leas.
set -u
S=${S:-$HOME/.cache/claude-2593/S}
d=$(readlink -f $1); kind=${2:-t1}
mkdir -p $d/cg
: > $d/check.txt
for s in calls tables strings arithmetic closures; do
  (cd $S/inputs && $d/lua-$kind $s.lua > $d/$s.out 2>&1); rc=$?
  if [ -f $S/ref/$s.out ] && cmp -s $d/$s.out $S/ref/$s.out; then same=same; else same=DIFF; fi
  echo "$s $rc $same" >> $d/check.txt
done
for s in calls tables strings arithmetic closures; do
  (cd $S/inputs && valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$d/cg/$s.cg $d/lua-$kind $s.lua > $d/cg/$s.out 2> $d/cg/$s.err) &
  [ $s = tables ] && wait
done
wait
for f in calls tables strings arithmetic closures; do echo "$f $(grep -m1 '^summary' $d/cg/$f.cg | cut -d' ' -f2)"; done > $d/instructions.txt
objdump -d --no-show-raw-insn $d/lua-$kind > $d/lua.dis
if [ $kind = t1 ]; then o='???'; base=0x108000; else o=$(sed -n 's/^cmd: *\([^ ]*\).*/\1/p' $d/cg/calls.cg); base=0; fi
for f in calls tables strings arithmetic closures; do GAP_INSTRUCTIONS=1 $S/gap count $d/lua.dis $d/cg/$f.cg "$o" $base > $d/$f.tsv; done
cat $d/check.txt
awk '{s+=$2} END {printf "total %.1f M\n", s/1e6}' $d/instructions.txt
