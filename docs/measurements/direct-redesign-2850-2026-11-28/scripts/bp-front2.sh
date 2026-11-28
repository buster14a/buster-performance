#!/bin/bash
# The front prototype alone: counters over 51 rounds, then cycle and misprediction profiles by function.
cd /tmp/2850-fermat
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
./bp-run.sh "front prototype" ./front dump $S 51 > front.out 2>&1
./bp-run.sh "front prototype profile" perf record -q -e cycles:u -c 20011 -o front.perf ./front dump $S 201 > /dev/null 2>&1
perf report -i front.perf --stdio --no-children --sort symbol --percent-limit 0.7 2>/dev/null | grep -v "^#" | sed '/^$/d' > front-symbols.txt
./bp-run.sh "front prototype mispredictions" perf record -q -e branch-misses:u -c 2003 -o front-bm.perf ./front dump $S 201 > /dev/null 2>&1
perf report -i front-bm.perf --stdio --no-children --sort symbol --percent-limit 0.7 2>/dev/null | grep -v "^#" | sed '/^$/d' > front-bm-symbols.txt
touch front2.done
