#!/bin/bash
# #786's front end: the IR verifier's and the optimizer's benchmarks on main 74af9937 and on 9bb5060e (before #774), each
# tree's unshifted link (shifts/TREE/compiler-0), pinned to CPU 2: perf stat with two groups of Zen 5's front-end events
# (taken branches, mispredictions, empty dispatch slots; the op cache's hits and misses, the decoders' ops, redirects),
# then perf record of each and perf report and annotate of the hottest symbols; each run its own hold of the shared lock.
echo $$ > ~/buster-fast-bench/claude-786/queue-b.pid
until grep -q done ~/buster-fast-bench/claude-786/out/progress 2>/dev/null; do sleep 10; done
cd ~/buster-fast-bench/claude-786
out=~/buster-fast-bench/claude-786/out-b
mkdir -p "$out"
lock()
{
    EXCLUSIVE_OWNER=claude-786 EXCLUSIVE_TITLE="IR passes over placements (#786)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/786 ~/buster-fast-bench/exclusive.sh "$@"
}
groups=("cycles:u,instructions:u,ex_ret_brn_tkn:u,ex_ret_brn_misp:u,de_no_dispatch_per_slot.no_ops_from_frontend:u" "op_cache_hit_miss.op_cache_hit:u,op_cache_hit_miss.op_cache_miss:u,de_src_op_disp.x86_decoder:u,de_src_op_disp.op_cache:u,bp_de_redirect:u")
runs=("benchmark-ir --only scalar --instructions 262144" "benchmark-ir --only vector --instructions 262144" "benchmark-ir --only cfg --instructions 262144" "benchmark-ir-optimize")
for round in 1 2; do
    if [ $round = 1 ]; then trees="old main"; else trees="main old"; fi
    for r in "${runs[@]}"; do
        name=$(echo "$r" | tr ' ' '_')
        for g in 0 1; do
            script=""
            for tree in $trees; do
                script="$script taskset -c 2 perf stat -x, -e ${groups[$g]} -o $out/stat-$name-g$g-$tree-$round.csv ~/buster-fast-bench/claude-786/shifts/$tree/compiler-0 $r > $out/stat-$name-g$g-$tree-$round.log 2>&1; echo $name g$g $tree $round \$?;"
            done
            lock bash -c "$script" >> "$out/stats.log" 2>&1
            echo "stat $name g$g $round: $?" >> "$out/progress"
        done
    done
done
for tree in old main; do
    for r in "benchmark-ir --only scalar --instructions 262144" "benchmark-ir --only vector --instructions 262144"; do
        name=$(echo "$r" | tr ' ' '_')
        lock bash -c "taskset -c 2 perf record -q -e cycles:u -c 200003 -o $out/perf-$name-$tree.data ~/buster-fast-bench/claude-786/shifts/$tree/compiler-0 $r > $out/perf-$name-$tree.log 2>&1 && perf report -i $out/perf-$name-$tree.data --no-children --sort symbol --stdio 2>/dev/null | grep -v '^#' | grep -v '^$' | head -15 > $out/report-$name-$tree.txt && top=\$(head -1 $out/report-$name-$tree.txt | awk '{print \$3}') && perf annotate -i $out/perf-$name-$tree.data --stdio -s \$top 2>/dev/null > $out/annotate-$name-$tree.txt"
        echo "perf $name $tree: $?" >> "$out/progress"
    done
done
echo done >> "$out/progress"
