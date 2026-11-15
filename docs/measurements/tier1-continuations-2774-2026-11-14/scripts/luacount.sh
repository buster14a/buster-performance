#!/usr/bin/env bash
# luacount.sh DIR: DIR/lua-t1's five scripts checked against clang -O0's outputs (ref/) and run under callgrind, joined
# by gap.c into DIR/*.tsv; prints whole-process counts. #2592's luacount.sh with this session's paths.
set -u
C=$HOME/.cache/claude-2774
G=$C/gap
d=$(readlink -f $1)
mkdir -p $d/cg
: > $d/check.txt
for s in calls tables strings arithmetic closures; do
  (cd $C/inputs && $d/lua-t1 $s.lua > $d/$s.out 2>&1); rc=$?
  if cmp -s $d/$s.out $C/ref/$s.out; then same=same; else same=DIFF; fi
  echo "$s $rc $same" >> $d/check.txt
done
for s in calls tables strings arithmetic closures; do
  (cd $C/inputs && valgrind --tool=callgrind --dump-instr=yes --callgrind-out-file=$d/cg/$s.cg $d/lua-t1 $s.lua > $d/cg/$s.out 2> $d/cg/$s.err) &
done
wait
for f in calls tables strings arithmetic closures; do echo "$f $(grep -m1 '^summary' $d/cg/$f.cg | cut -d' ' -f2)"; done > $d/instructions.txt
objdump -d --no-show-raw-insn $d/lua-t1 > $d/lua.dis
for f in calls tables strings arithmetic closures; do GAP_INSTRUCTIONS=1 $G count $d/lua.dis $d/cg/$f.cg '???' 0x108000 > $d/$f.tsv; done
cat $d/check.txt
awk '{s+=$2} END {printf "total %.1f M\n", s/1e6}' $d/instructions.txt
