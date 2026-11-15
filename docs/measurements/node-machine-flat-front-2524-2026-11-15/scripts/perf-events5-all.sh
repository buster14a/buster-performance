#!/bin/bash
# perf-events5.sh LABEL TAG [shadow options]: as perf-events.sh, five processes an event with periods two apart, so that
# a function's count is over five times the samples. Files results/LABEL/events5-TAG-EVENT-N.{data,out} and
# events5-TAG-EVENT.txt (the five runs' mean by symbol, millions).
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
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-events5-$tag.txt"
for spec in $events; do
    event=${spec%:*}; period=${spec##*:}; name=${event%%:*}
    for n in 1 2 3 4 5; do
        commands="$commands; perf record -q -o $out/events5-$tag-$name-$n.data -e $event -c $((period + 2 * n)) -- taskset -c 2 $out/compiler measure-node-machine --shadow --passes 0 $options -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c > $out/events5-$tag-$name-$n.out 2>&1"
    done
done
./lock.sh bash -c "$commands"
for spec in $events; do
    event=${spec%:*}; period=${spec##*:}; name=${event%%:*}
    for n in 1 2 3 4 5; do
        nice -n 19 perf report -i $out/events5-$tag-$name-$n.data --stdio --sort symbol -n 2>/dev/null | awk -v period=$((period + 2 * n)) '/^ +[0-9.]+%/ { printf "%.6f %s\n", $2 * period / 1e6, $4 }'
    done | awk '{ sum[$2] += $1 } END { for (s in sum) printf "%12.3f M  %s\n", sum[s] / 5, s }' | sort -rn | head -400 > $out/events5-$tag-$name.txt
    rm -f $out/events5-$tag-$name-*.data
done
