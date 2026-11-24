#!/bin/bash
# The head tree with a patch, built with debug info (a profile's build, not a timed one), and its cycles by source
# line in the reach scan's files. Run under the lock. Arguments: the patch file, a label.
set -u
cd ~/buster-fast-bench/1340-reach/buster-head
git checkout -q -- . && git apply ../$1 || exit 1
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=1 ./build.sh --config Release > ../build-lines.log 2>&1
out=$(BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=1 ./build.sh print-output --config Release 2>/dev/null)
cp "$out" ../bin/compiler-lines-$2
git checkout -q -- .
cd .. && mkdir -p results/lines-$2 && cd results/lines-$2
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
for round in 1 2 3 4 5 6 7 8; do
    taskset -c 2 perf record -q -e cycles:u -c 20011 -o perf-$round.data -- ../../bin/compiler-lines-$2 "${O[@]}" -o x.o > /dev/null 2>> err.txt
done
for round in 1 2 3 4 5 6 7 8; do perf report -q -i perf-$round.data --sort srcline --stdio 2>/dev/null | awk 'NF >= 2 { print $1, $2 }'; done |
    awk '{ gsub("%", "", $1); sum[$2] += $1 } END { for (s in sum) printf "%8.4f %s\n", sum[s] / 8, s }' | sort -rn > by-line.txt
rm -f x.o
echo done > complete
