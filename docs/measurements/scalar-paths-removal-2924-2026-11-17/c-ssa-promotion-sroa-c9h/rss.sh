#!/bin/bash
# rss.sh: #1353's case (one function of N for-loops, each with its own i) under --tier1 -c --time-stages, CPU 2, by
# compiler-base (main) and compiler-head (#2924 C9h): total time and peak RSS from the time-process line.
D=~/buster-fast-bench/2924-c9h
W=$D/rss; mkdir -p $W; cd $W
for N in 1000 2000 4000 8000; do
  { echo 'int g(int a) { int s = 0;'; i=0; while [ $i -lt $N ]; do echo "for (int i = 0; i < a; i++) s += i * $i;"; i=$((i+1)); done; echo 'return s; }'; } > loops-$N.c
done
export EXCLUSIVE_OWNER=claude-2924-c9h EXCLUSIVE_TITLE="buster #2924: IR promotion and SROA twins (C9h)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
~/buster-fast-bench/exclusive.sh timeout -k 5 600 bash -c '
for N in 1000 2000 4000 8000; do for exe in base head; do
  out=$(taskset -c 2 '$D'/compiler-$exe -c --tier1 --time-stages loops-$N.c -o loops-$N-$exe.o 2>&1 | grep -E "time-process" | tr "\n" " ")
  echo "N=$N $exe status=$? $out"
done; done' > $W/rss.txt 2>&1
echo done >> $W/rss.txt
