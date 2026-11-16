#!/bin/bash
# own-instructions.sh LABEL TAG [shadow options]: perf record of retired instructions (user, period 400,009) of
# measure-node-machine --shadow [options] on sqlite3.c by results/LABEL/compiler on CPU 2 under the lock: by symbol
# (results/LABEL/oi-TAG-symbols.txt, M instructions) and, for node_front_acted, by address (oi-TAG-addresses.txt).
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
./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner | cut -c1-200 > /dev/null; perf record -q -o $out/oi-$tag.data -e instructions:u -c 100003 -- $run > /dev/null 2>&1"
nice -n 19 perf report -i $out/oi-$tag.data --stdio --sort symbol -n 2>/dev/null | awk '/^ +[0-9.]+%/ { printf "%.4f %s\n", $2 * 100003 / 1e6, $4 }' > $out/oi-$tag-symbols.txt
nice -n 19 perf script -i $out/oi-$tag.data -F ip,sym 2>/dev/null | awk '$2 ~ /^node_front_acted/ { print $1 }' | sort | uniq -c | awk '{ printf "%s %.4f\n", $2, $1 * 100003 / 1e6 }' > $out/oi-$tag-addresses.txt
rm -f $out/oi-$tag.data
echo "own-instructions $label $tag done $(date -u +%T)" >> results/job47.log
