#!/bin/bash
# Attribution of benchmark-lowering-source's difference between #137's trees: each tree's user instructions, cycles
# and branch misses over the whole benchmark process (its 21 timed passes are most of it), 3 runs each, each under the
# lock alone, on CPU 2, with the benchmark's own referenced_ns. Usage: lowstat.sh NAME TREE...
set -e
name=$1; shift
cd ~/buster-fast-bench/cc137-claude
export EXCLUSIVE_OWNER=claude-137 EXCLUSIVE_TITLE="solve #137's remaining work (lowering attribution: $name)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/137
S=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
O=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$S" "$S/sqlite3.c")
for r in 1 2 3; do
    for t in "$@"; do
        ~/buster-fast-bench/exclusive.sh taskset -c 2 perf stat -x, -e instructions:u,cycles:u,branch-misses:u -o $name-$t-$r.csv ./$t/build/compiler benchmark-lowering-source "${O[@]}" > $name-$t-$r.txt 2>&1
        echo "$t $r: $(grep -o 'referenced_ns=[0-9]*' $name-$t-$r.txt | tail -1) $(grep -E 'instructions|cycles|branch-misses' $name-$t-$r.csv | cut -d, -f1,3 | tr '\n' ' ')"
    done
done
echo done
