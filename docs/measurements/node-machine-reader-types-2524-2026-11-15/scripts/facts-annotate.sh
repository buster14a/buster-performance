#!/bin/bash
# facts-annotate.sh LABEL TAG SYMBOL PASSES [shadow options]: measure-node-machine --shadow --facts [options] --passes
# PASSES on sqlite3.c by results/LABEL/compiler on CPU 2, one hold of the lock, five perf record processes: cycles,
# store-to-load interference, demand fills of the first-level data cache, loads across a line, mispredicted branches.
# Each event's counts by symbol (results/LABEL/fa-TAG-EVENT-symbols.txt) and by SYMBOL's instructions
# (fa-TAG-EVENT-annotate.txt).
set -u
cd "$(dirname "$0")"
label=$1; tag=$2; symbol=$3; passes=$4
shift 4
options="$*"
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
run="taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options --passes $passes -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
events="${EVENTS:-cycles:u:200003 ls_bad_status2.stli_other:u:1009 ls_dmnd_fills_from_sys.all:u:1009 ls_misal_loads.ma64:u:1009 ex_ret_brn_misp:u:1009}"
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-facts-annotate-$tag.txt"
for spec in $events; do
    event=${spec%:*}; period=${spec##*:}; name=${event%%:*}
    commands="$commands; perf record -q -o $out/fa-$tag-$name.data -e $event -c $period -- $run > /dev/null 2>&1"
done
./lock.sh bash -c "$commands"
for spec in $events; do
    event=${spec%:*}; period=${spec##*:}; name=${event%%:*}
    nice -n 19 perf report -i $out/fa-$tag-$name.data --stdio --sort symbol -n 2>/dev/null | awk -v period=$period '/^ +[0-9.]+%/ { printf "%.6f %s\n", $2 * period / 1e6, $4 }' > $out/fa-$tag-$name-symbols.txt
    nice -n 19 perf annotate -i $out/fa-$tag-$name.data --stdio -s $symbol 2>/dev/null > $out/fa-$tag-$name-annotate.txt
    rm -f $out/fa-$tag-$name.data
done
