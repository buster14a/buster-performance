#!/bin/bash
# bp-ab.sh A B: the front prototype's two builds in turn (A B A B), 51 rounds each, each run under the lock by itself;
# then B's cycle and misprediction profiles by function.
cd /tmp/2850-fermat
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
a=$1; b=$2
: > ab.out
for turn in 1 2; do
  for build in $a $b; do
    ./bp-run.sh "front prototype $build" ./$build dump $S 51 2>/dev/null | grep -aE "^rounds|^pass A alone|SAME|DIFFERS" | sed "s/^/$build: /" >> ab.out
  done
done
./bp-run.sh "front prototype profile" perf record -q -e cycles:u -c 20011 -o front.perf ./$b dump $S 201 > /dev/null 2>&1
perf report -i front.perf --stdio --no-children --sort symbol --percent-limit 0.7 2>/dev/null | grep -v "^#" | sed '/^$/d' > front-symbols.txt
./bp-run.sh "front prototype mispredictions" perf record -q -e branch-misses:u -c 2003 -o front-bm.perf ./$b dump $S 201 > /dev/null 2>&1
perf report -i front-bm.perf --stdio --no-children --sort symbol --percent-limit 0.7 2>/dev/null | grep -v "^#" | sed '/^$/d' > front-bm-symbols.txt
touch ab.done
