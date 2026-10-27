#!/usr/bin/env bash
# The A/B after merging main again: builds main3 (main at 51bf882b) and merged3 (the branch with it, 3932bcf8), each build under
# a hold of the lock, checks the merge (test-tier0, test-unwind), compares the trees' functions, takes counters of both
# (perf stat, a hold per path, each tree twice in alternating order), then 6 rounds of round-merged3.sh, each under one
# hold of the lock, the trees' order alternating, and compares their sqlite3.c objects. Run detached (setsid -f).
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-aligned-136 EXCLUSIVE_TITLE="Objects aligned past 16 (#136): main vs merged head, again" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
lock=~/buster-fast-bench/exclusive.sh
for tree in main3 merged3; do
    (cd "$tree" && "$lock" env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1) || { echo "build $tree failed" >> queue-merged3.log; exit 1; }
    echo "built $tree $(date -Is)" >> queue-merged3.log
done
"$lock" bash -c "cd merged3 && ./build/compiler test-tier0 > ../merged3-tier0.log 2>&1; echo \"test-tier0 \$? \$(tail -1 ../merged3-tier0.log)\" >> ../queue-merged3.log; ./build/compiler test-unwind > ../merged3-unwind.log 2>&1; echo \"test-unwind \$?\" >> ../queue-merged3.log"
for tree in main3 merged3; do
    nm -S --defined-only "$tree/build/compiler" | awk '{print $4, $2}' | sort > "functions-$tree.txt"
done
comm -3 functions-main3.txt functions-merged3.txt > functions-diff-merged3.txt
mkdir -p counters-merged3
events=cycles:u,instructions:u,branch-misses:u,L1-icache-load-misses:u,ic_tag_hit_miss.instruction_cache_miss:u
for path in vector scalar; do
    "$lock" bash -c "for run in 1:main3 1:merged3 2:merged3 2:main3; do t=\${run#*:}; i=\${run%%:*}; taskset -c 2 perf stat -x, -e $events ./\$t/build/compiler benchmark-backend --only $path > counters-merged3/\$t-$path-\$i.out 2> counters-merged3/\$t-$path-\$i.perf; done"
    echo "counters $path $(date -Is)" >> queue-merged3.log
done
for round in 1 2 3 4 5 6; do
    if [ $((round % 2)) -eq 1 ]; then order="main3 merged3"; else order="merged3 main3"; fi
    "$lock" ./round-merged3.sh "$round" $order
    echo "round $round ($order) $(date -Is)" >> queue-merged3.log
done
cmp "objects-merged3/sqlite3-main3.o" "objects-merged3/sqlite3-merged3.o" >> queue-merged3.log 2>&1 && echo "sqlite3.o identical" >> queue-merged3.log
echo "done $(date -Is)" >> queue-merged3.log
