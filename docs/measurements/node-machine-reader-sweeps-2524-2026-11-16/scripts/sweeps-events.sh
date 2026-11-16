#!/bin/bash
# sweeps-events.sh LABEL TAG ROUND PASSES [shadow options]: measure-node-machine --shadow [options] --passes PASSES on
# sqlite3.c by results/LABEL/compiler on CPU 2, in one hold of the lock: one perf record process an event (cycles,
# mispredicted branches, instruction cache misses, op cache misses, store-to-load interference), each by symbol; the
# cycles' period two apart a round. Files results/LABEL/se-TAG-EVENT-symbols-ROUND.txt and se-TAG-run-ROUND.txt.
set -u
cd "$(dirname "$0")"
label=$1; tag=$2; round=$3; passes=$4
shift 4
options="$*"
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
run="taskset -c 2 $out/compiler measure-node-machine --shadow $options --passes $passes -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
events="cycles:u:$((200003 + 2 * round)) ex_ret_brn_misp:u:1009 ic_tag_hit_miss.instruction_cache_miss:u:1009 op_cache_hit_miss.op_cache_miss:u:1009 ls_bad_status2.stli_other:u:1009"
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-sweeps-events-$tag.txt; $run > $out/se-$tag-run-$round.txt 2>&1"
for spec in $events; do
    event=${spec%:*}; name=${event%%:*}; period=${spec##*:}
    commands="$commands; perf record -q -o $out/se-$tag-$name-$round.data -e $event -c $period -- $run > /dev/null 2>&1"
done
./lock.sh bash -c "$commands"
for spec in $events; do
    event=${spec%:*}; name=${event%%:*}; period=${spec##*:}
    nice -n 19 perf report -i $out/se-$tag-$name-$round.data --stdio --sort symbol -n 2>/dev/null | awk -v period=$period '/^ +[0-9.]+%/ { printf "%.6f %s\n", $2 * period / 1e6, $4 }' > $out/se-$tag-$name-symbols-$round.txt
    rm -f $out/se-$tag-$name-$round.data
done
