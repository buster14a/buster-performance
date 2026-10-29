#!/bin/bash
# #786's fix on the 9700X: the verifier's, the CFG builder's and the optimizer's benchmarks of old 9bb5060e (#774's
# base), the branch's base (main) and its head, each linked six times with the backend's unit shifted by 0 to 3,456
# bytes (./build.sh shifts; old's links are q786a.sh's), each link running benchmark-ir and benchmark-ir-optimize once
# pinned to CPU 2, the trees alternating and the order turning by round, two rounds; each build and run its own hold of
# the shared lock. Waits for q786b.sh's counters.
set -u
echo $$ > ~/buster-fast-bench/claude-786/queue-c.pid
until grep -q '^done' ~/buster-fast-bench/claude-786/out-b/progress 2>/dev/null; do sleep 10; done
cd ~/buster-fast-bench/claude-786
out=~/buster-fast-bench/claude-786/out-c
mkdir -p "$out"
lock()
{
    EXCLUSIVE_OWNER=claude-786 EXCLUSIVE_TITLE="IR passes over placements (#786)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/786 ~/buster-fast-bench/exclusive.sh "$@"
}
shifts="0 640 1344 2048 2752 3456"
for tree in base head; do
    lock bash -c "cd $tree && BUSTER_DEBUG_INFO=0 ./build.sh shifts ../shifts/$tree main_unit_backend.c $shifts" > "$out/shifts-$tree.log" 2>&1
    echo "shifts $tree: $?" >> "$out/progress"
done
order()
{
    case $(( ($1 + $2) % 3 )) in
        0) echo old base head ;;
        1) echo base head old ;;
        *) echo head old base ;;
    esac
}
for pass in 1 2; do
    index=0
    for shift in $shifts; do
        for tree in $(order $pass $index); do
            for benchmark in benchmark-ir benchmark-ir-optimize; do
                lock bash -c "taskset -c 2 ./shifts/$tree/compiler-$shift $benchmark > $out/$benchmark-$tree-$shift-$pass.log 2>&1"
                echo "$benchmark $tree $shift $pass: $?" >> "$out/progress"
            done
        done
        index=$((index + 1))
    done
done
echo done >> "$out/progress"
