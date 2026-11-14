#!/bin/bash
# explore-bm.sh LABEL: the shadow on sqlite3.c by results/LABEL's compiler, on CPU 2, each run in its own hold of the lock:
# perf stat's PipelineL1 and PipelineL2 metrics with --passes 0 and --passes 40 (their difference is the sweeps'), and a
# profile of retired mispredicted branches (ex_ret_brn_misp:u) by symbol and, for the sweeps' functions, by source line.
set -u
cd "$(dirname "$0")"
out=$PWD/results/$1/bm
mkdir -p "$out"
compiler=$PWD/results/$1/compiler
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
options="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite $sqlite/sqlite3.c"
for p in 0 40; do
    ./lock.sh bash -c "head -1 /var/lib/buster-9700x/owner > $out/holder-stat-p$p.txt; taskset -c 2 perf stat -M PipelineL1,PipelineL2 -o $out/stat-p$p.txt $compiler measure-node-machine --shadow --passes $p $options > $out/shadow-p$p.txt 2>&1"
    ./lock.sh bash -c "taskset -c 2 perf stat -e cycles:u,instructions:u,ex_ret_brn:u,ex_ret_brn_misp:u,ex_ret_brn_tkn:u -o $out/counts-p$p.txt $compiler measure-node-machine --shadow --passes $p $options > /dev/null 2>&1"
done
./lock.sh bash -c "taskset -c 2 perf record -q -c 20011 -e ex_ret_brn_misp:u -o $out/perf-misp.data $compiler measure-node-machine --shadow --passes 40 $options > /dev/null 2>&1"
perf report -i $out/perf-misp.data --stdio --no-children --sort symbol 2>/dev/null | grep -v "^#" | grep -v "^$" | head -40 > $out/misp-symbols.txt
for sym in node_machine_type node_machine_contexts node_machine_expand node_machine_call_rule node_machine_store_rule; do
    perf annotate -i $out/perf-misp.data --stdio --no-source -s $sym 2>/dev/null > $out/ann-$sym.txt
    awk -F: '/^ +[0-9]+\.[0-9]+ +: +[0-9a-f]+:/ { gsub(/ /, "", $1); gsub(/ /, "", $2); print $1, $2 }' $out/ann-$sym.txt > $out/ann-$sym.pairs
    cut -d" " -f2 $out/ann-$sym.pairs | sed "s/^/0x/" | addr2line -e $compiler -a > $out/ann-$sym.lines 2>/dev/null
    paste -d" " $out/ann-$sym.pairs <(grep -v "^0x" $out/ann-$sym.lines | sed "s|.*/||") | sort -k1,1 -g -r | head -25 > $out/misp-lines-$sym.txt
done
rm -f $out/perf-misp.data
