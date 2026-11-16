#!/bin/bash
# sweeps-annotate.sh LABEL TAG PASSES SYMBOL...: measure-node-machine --shadow --passes PASSES on sqlite3.c by
# results/LABEL/compiler on CPU 2, one hold of the lock, two perf record processes (store-to-load interference, cycles);
# each event's counts by the instructions of each SYMBOL: results/LABEL/sa-TAG-EVENT-SYMBOL.txt.
set -u
cd "$(dirname "$0")"
label=$1; tag=$2; passes=$3
shift 3
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
run="taskset -c 2 $out/compiler measure-node-machine --shadow --passes $passes -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
events="ls_bad_status2.stli_other:u:1009 cycles:u:200003"
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-sweeps-annotate-$tag.txt"
for spec in $events; do
    event=${spec%:*}; name=${event%%:*}; period=${spec##*:}
    commands="$commands; perf record -q -o $out/sa-$tag-$name.data -e $event -c $period -- $run > /dev/null 2>&1"
done
./lock.sh bash -c "$commands"
for spec in $events; do
    event=${spec%:*}; name=${event%%:*}
    for symbol in "$@"; do
        nice -n 19 perf annotate -i $out/sa-$tag-$name.data --stdio -s $symbol 2>/dev/null > $out/sa-$tag-$name-$symbol.txt
    done
    rm -f $out/sa-$tag-$name.data
done
