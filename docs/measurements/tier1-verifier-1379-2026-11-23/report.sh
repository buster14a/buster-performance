#!/bin/sh
D=/tmp/c1341/w; S=$D/s1379; cd $S
for w in sq lua; do for b in b2665 m2665 main; do
  perf report -i raw/$w-$b.data --no-children --sort sym --stdio -q 2>/dev/null | head -400 > raw/$w-$b.report
done; done
