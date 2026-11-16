#!/bin/bash
# own-lines.sh LABEL TAG [shadow options]: retired instructions (user) of measure-node-machine --shadow [options] on
# sqlite3.c by results/LABEL/compiler on CPU 2, five processes under one hold of the lock at periods of 400,009 and
# more (a rate the kernel keeps): by symbol (results/LABEL/ol-TAG-symbols.txt) and by source line
# (ol-TAG-lines.txt), in M instructions a process.
set -u
cd "$(dirname "$0")"
label=$1; tag=$2
shift 2
options="$*"
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
run="taskset -c 2 $out/compiler measure-node-machine --shadow $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 > /dev/null"
for round in 1 2 3 4 5; do
    commands="$commands; perf record -q -o $out/ol-$tag-$round.data -e instructions:u -c $((400009 + 2 * round)) -- $run > /dev/null 2>&1"
done
./lock.sh bash -c "$commands"
: > $out/ol-$tag-symbols.txt; : > $out/ol-$tag-lines.txt
for round in 1 2 3 4 5; do
    period=$((400009 + 2 * round))
    nice -n 19 perf report -i $out/ol-$tag-$round.data --stdio --sort symbol -n 2>/dev/null | awk -v period=$period '/^ +[0-9.]+%/ { printf "%.6f %s\n", $2 * period / 5e6, $4 }' >> $out/ol-$tag-symbols.txt
    nice -n 19 perf report -i $out/ol-$tag-$round.data --stdio --sort srcline -n 2>/dev/null | awk -v period=$period '/^ +[0-9.]+%/ { printf "%.6f %s\n", $2 * period / 5e6, $3 }' >> $out/ol-$tag-lines.txt
    rm -f $out/ol-$tag-$round.data
done
echo "own-lines $label $tag done $(date -u +%T)" >> results/job50.log
