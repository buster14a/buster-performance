#!/usr/bin/env bash
# The A/B after merging main: builds main2 (main at bbe59b7f) and merged (the branch with it, acb51314), each build under
# a hold of the lock, checks the merge (test-tier0, test-unwind), compares the trees' functions, takes counters of both
# (perf stat, a hold per path, each tree twice in alternating order), then 6 rounds of round-merged.sh, each under one
# hold of the lock, the trees' order alternating, and compares their sqlite3.c objects. Run detached (setsid -f).
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-aligned-136 EXCLUSIVE_TITLE="Objects aligned past 16 (#136): main vs merged head" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
lock=~/buster-fast-bench/exclusive.sh
for tree in main2 merged; do
    (cd "$tree" && "$lock" env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1) || { echo "build $tree failed" >> queue-merged.log; exit 1; }
    echo "built $tree $(date -Is)" >> queue-merged.log
done
"$lock" bash -c "cd merged && ./build/compiler test-tier0 > ../merged-tier0.log 2>&1; echo \"test-tier0 \$? \$(tail -1 ../merged-tier0.log)\" >> ../queue-merged.log; ./build/compiler test-unwind > ../merged-unwind.log 2>&1; echo \"test-unwind \$?\" >> ../queue-merged.log"
for tree in main2 merged; do
    nm -S --defined-only "$tree/build/compiler" | awk '{print $4, $2}' | sort > "functions-$tree.txt"
done
comm -3 functions-main2.txt functions-merged.txt > functions-diff-merged.txt
mkdir -p counters-merged
events=cycles:u,instructions:u,branch-misses:u,L1-icache-load-misses:u,ic_tag_hit_miss.instruction_cache_miss:u
for path in vector scalar; do
    "$lock" bash -c "for run in 1:main2 1:merged 2:merged 2:main2; do t=\${run#*:}; i=\${run%%:*}; taskset -c 2 perf stat -x, -e $events ./\$t/build/compiler benchmark-backend --only $path > counters-merged/\$t-$path-\$i.out 2> counters-merged/\$t-$path-\$i.perf; done"
    echo "counters $path $(date -Is)" >> queue-merged.log
done
for round in 1 2 3 4 5 6; do
    if [ $((round % 2)) -eq 1 ]; then order="main2 merged"; else order="merged main2"; fi
    "$lock" ./round-merged.sh "$round" $order
    echo "round $round ($order) $(date -Is)" >> queue-merged.log
done
cmp "objects-merged/sqlite3-main2.o" "objects-merged/sqlite3-merged.o" >> queue-merged.log 2>&1 && echo "sqlite3.o identical" >> queue-merged.log
echo "done $(date -Is)" >> queue-merged.log
