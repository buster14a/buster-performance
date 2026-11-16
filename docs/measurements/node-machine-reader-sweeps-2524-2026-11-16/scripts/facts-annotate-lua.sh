#!/bin/bash
# facts-annotate-lua.sh LABEL TAG SYMBOL PASSES [shadow options]: facts-annotate.sh on Lua's sources: one hold of the
# lock, a perf record process an event (cycles, instruction cache misses, op cache misses, mispredicted branches,
# store-to-load interference); each event's counts by symbol (results/LABEL/fl-TAG-EVENT-symbols.txt) and by SYMBOL's
# instructions (fl-TAG-EVENT-annotate.txt).
set -u
cd "$(dirname "$0")"
label=$1; tag=$2; symbol=$3; passes=$4
shift 4
options="$*"
out=$PWD/results/$label
lua=$PWD/inputs/lua-5.4.8/src
export LC_ALL=C
run="taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options --passes $passes $lua/*.c"
events="cycles:u:200003 ic_tag_hit_miss.instruction_cache_miss:u:1009 op_cache_hit_miss.op_cache_miss:u:1009 ex_ret_brn_misp:u:1009 ls_bad_status2.stli_other:u:1009"
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-facts-annotate-lua-$tag.txt"
for spec in $events; do
    event=${spec%:*}; period=${spec##*:}; name=${event%%:*}
    commands="$commands; perf record -q -o $out/fl-$tag-$name.data -e $event -c $period -- $run > /dev/null 2>&1"
done
./lock.sh bash -c "$commands"
for spec in $events; do
    event=${spec%:*}; period=${spec##*:}; name=${event%%:*}
    nice -n 19 perf report -i $out/fl-$tag-$name.data --stdio --sort symbol -n 2>/dev/null | awk -v period=$period '/^ +[0-9.]+%/ { printf "%.6f %s\n", $2 * period / 1e6, $4 }' > $out/fl-$tag-$name-symbols.txt
    nice -n 19 perf annotate -i $out/fl-$tag-$name.data --stdio -s $symbol 2>/dev/null > $out/fl-$tag-$name-annotate.txt
    rm -f $out/fl-$tag-$name.data
done
