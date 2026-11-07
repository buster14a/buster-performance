#!/bin/bash
# #1629, run off-host (the Xeon VM): objects.sh COMPILER OUTDIR writes the c-testsuite programs' and the synthetic units' objects by
# -c, -c -g, -c --scalar and -c -funsigned-char, which diff -r compares between the branch and main.
bin=$1; out=$2; rm -rf $out; mkdir -p $out
for f in /home/user/buster/build/c-testsuite/tests/single-exec/*.c /home/user/trees/syn/*.c; do
  n=$(basename $f .c)
  $bin -c $f -o $out/$n.o 2>/dev/null
  $bin -c -g $f -o $out/$n.g.o 2>/dev/null
  $bin -c --scalar $f -o $out/$n.s.o 2>/dev/null
  $bin -c -funsigned-char $f -o $out/$n.u.o 2>/dev/null
done
ls $out | wc -l
