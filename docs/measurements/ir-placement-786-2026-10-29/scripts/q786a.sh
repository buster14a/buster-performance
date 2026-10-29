#!/bin/bash
# #786's first measurement on the 9700X: the IR's synthetic benchmarks over their code's placements, main 74af9937
# against 9bb5060e (#774's base, before it). Each tree is linked six times with the backend's unit shifted by 0 to 3,456
# bytes over a page (./build.sh shifts), then each link runs benchmark-ir and benchmark-ir-optimize once, pinned to
# CPU 2, the trees alternating and the order turning by round, two rounds; each run its own hold of the shared lock.
echo $$ > ~/buster-fast-bench/claude-786/queue.pid
until grep -q done ~/buster-fast-bench/claude-732/out/progress 2>/dev/null; do sleep 10; done
cd ~/buster-fast-bench/claude-786
out=~/buster-fast-bench/claude-786/out
mkdir -p "$out"
lock()
{
    EXCLUSIVE_OWNER=claude-786 EXCLUSIVE_TITLE="IR passes over placements (#786)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/786 ~/buster-fast-bench/exclusive.sh "$@"
}
shifts="0 640 1344 2048 2752 3456"
for tree in old main; do
    lock bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts/$tree main_unit_backend.c $shifts" > "$out/shifts-$tree.log" 2>&1
    echo "shifts $tree: $?" >> "$out/progress"
done
for round in 1 2; do
    if [ $round = 1 ]; then trees="old main"; else trees="main old"; fi
    for s in $shifts; do
        for tree in $trees; do
            for b in benchmark-ir benchmark-ir-optimize; do
                lock bash -c "cd ~/buster-fast-bench/claude-786/$tree && taskset -c 2 ../shifts/$tree/compiler-$s $b" > "$out/$b-$tree-$s-$round.log" 2>&1
                echo "$b $tree $s $round: $?" >> "$out/progress"
            done
        done
    done
done
echo done >> "$out/progress"
