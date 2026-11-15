#!/bin/bash
# perf-events.sh LABEL TAG [shadow options]: perf record of measure-node-machine --shadow --passes 0 with the options on
# sqlite3.c (CPU 2), one process an event (user cycles, instructions, mispredicted branches, each at a fixed period under
# the kernel's sampling limit), in one hold; then each event's count by symbol (samples times period), outside the lock.
# Files results/LABEL/events-TAG-EVENT.{data,out,txt}.
set -u
cd "$(dirname "$0")"
label=$1; tag=$2
shift 2
options="$*"
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
events="cycles:u:200003 instructions:u:400009 ex_ret_brn_misp:u:1009"
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-events-$tag.txt"
for spec in $events; do
    event=${spec%:*}; period=${spec##*:}; name=${event%%:*}
    commands="$commands; perf record -q -o $out/events-$tag-$name.data -e $event -c $period -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $out/events-$tag-$name.out 2>&1"
done
./lock.sh bash -c "$commands"
for spec in $events; do
    event=${spec%:*}; period=${spec##*:}; name=${event%%:*}
    nice -n 19 perf report -i $out/events-$tag-$name.data --stdio --sort symbol -n 2>/dev/null | awk -v period=$period '/^ +[0-9.]+%/ { printf "%12.3f M  %s\n", $2 * period / 1e6, $4 }' | head -40 > $out/events-$tag-$name.txt
done
