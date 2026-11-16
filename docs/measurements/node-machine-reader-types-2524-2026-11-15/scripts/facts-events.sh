#!/bin/bash
# facts-events.sh LABEL TAG ROUND PASSES [shadow options]: one round of measure-node-machine --shadow --facts [options]
# --passes PASSES on sqlite3.c by results/LABEL/compiler on CPU 2, in one hold of the lock: three perf stat processes
# (five events each: the retired work and store forwarding, the data side's fills and misses, the front end's) and one
# perf record of cycles by symbol (its period two apart a round, so that samples do not land on the same instructions).
# Files results/LABEL/fe-TAG-{stat-a,stat-b,stat-c,run,symbols}-ROUND.txt.
set -u
cd "$(dirname "$0")"
label=$1; tag=$2; round=$3; passes=$4
shift 4
options="$*"
out=$PWD/results/$label
corpus=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
sqlite=$corpus/sqlite
export LC_ALL=C
run="taskset -c 2 $out/compiler measure-node-machine --shadow --facts $options --passes $passes -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
a="cycles:u,instructions:u,ex_ret_brn_misp:u,ls_bad_status2.stli_other:u,ls_stlf:u"
b="cycles:u,ls_dmnd_fills_from_sys.all:u,ls_hw_pf_dc_fills.all:u,ls_l1_d_tlb_miss.all:u,ls_misal_loads.ma64:u"
c="cycles:u,ic_tag_hit_miss.instruction_cache_miss:u,op_cache_hit_miss.op_cache_miss:u,de_src_op_disp.x:u,bp_l1_tlb_miss_l2_tlb_hit:u"
period=$((200003 + 2 * round))
commands="head -1 /var/lib/buster-9700x/owner | cut -c1-200 >> $PWD/results/holds-facts-events-$tag.txt"
commands="$commands; perf stat -x, -o $out/fe-$tag-stat-a-$round.txt -e $a -- $run > $out/fe-$tag-run-$round.txt 2>&1"
commands="$commands; perf stat -x, -o $out/fe-$tag-stat-b-$round.txt -e $b -- $run > /dev/null 2>&1"
commands="$commands; perf stat -x, -o $out/fe-$tag-stat-c-$round.txt -e $c -- $run > /dev/null 2>&1"
commands="$commands; perf record -q -o $out/fe-$tag-$round.data -e cycles:u -c $period -- $run > /dev/null 2>&1"
./lock.sh bash -c "$commands"
nice -n 19 perf report -i $out/fe-$tag-$round.data --stdio --sort symbol -n 2>/dev/null | awk -v period=$period '/^ +[0-9.]+%/ { printf "%.6f %s\n", $2 * period / 1e6, $4 }' > $out/fe-$tag-symbols-$round.txt
rm -f $out/fe-$tag-$round.data
