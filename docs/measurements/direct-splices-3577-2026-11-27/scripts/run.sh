#!/bin/bash
# usage: run.sh COMPILER files...  — compares -c against --no-direct -c (stderr, status) and says whether the direct path compiled
C=$1; shift
d=$(mktemp -d)
for f in "$@"; do
  BUSTER_TEST_DIRECT_BAILS=$d/bails $C -c "$f" -o $d/a.o > $d/a.out 2>&1; ea=$?
  $C --no-direct -c "$f" -o $d/b.o > $d/b.out 2>&1; eb=$?
  if [ $ea = $eb ] && cmp -s $d/a.out $d/b.out; then r=same; else r=DIFF; fi
  why=$(cut -f1 $d/bails 2>/dev/null | head -1); rm -f $d/bails
  printf "%s %s direct=%d full=%d %s\n" "$r" "$(basename $f)" $ea $eb "${why:+[left: $why]}"
  if [ $r = DIFF ]; then sed 's/^/   D: /' $d/a.out | head -3; sed 's/^/   F: /' $d/b.out | head -3; fi
done
rm -rf $d
