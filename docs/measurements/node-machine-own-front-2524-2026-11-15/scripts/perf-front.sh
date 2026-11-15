#!/bin/bash
# perf-front.sh LABEL RUNS TAG [shadow options]: perf record (user cycles, a period that differs by the run, CPU 2) of
# measure-node-machine --shadow --passes 0 with the options on sqlite3.c, RUNS processes in one hold; then, outside the
# lock, the samples by symbol and the front's and the walk's functions annotated. Files results/LABEL/perf-TAG-*.
set -u
cd "$(dirname "$0")"
label=$1; runs=$2; tag=$3
shift 3
options="$*"
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-perf-$tag.txt"
for n in $(seq 1 $runs); do
    commands="$commands; perf record -q -o $out/perf-$tag-$n.data -e cycles:u -c $((40003 + 2 * n)) -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $out/perf-$tag-$n.out 2>&1"
done
./lock.sh bash -c "$commands"
for n in $(seq 1 $runs); do
    nice -n 19 perf report -i $out/perf-$tag-$n.data --stdio --sort symbol 2>/dev/null | grep -v '^$' | head -70 > $out/perf-$tag-$n-symbols.txt
done
nice -n 19 perf annotate -i $out/perf-$tag-1.data --stdio -l node_front_chunk 2>/dev/null > $out/perf-$tag-1-annotate-front.txt
