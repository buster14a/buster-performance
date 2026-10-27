#!/usr/bin/env bash
# The final's A/B: builds the final tree under the lock, checks it (test-tier0, test-unwind), compares its functions with
# main's, takes counters of both (perf stat, in one hold), then 8 rounds of round.sh against main, each under one hold
# of the lock, the trees' order alternating, and compares their sqlite3.c objects. Run detached (setsid -f).
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-aligned-136 EXCLUSIVE_TITLE="Objects aligned past 16 (#136): main vs final" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
lock=~/buster-fast-bench/exclusive.sh
(cd final && "$lock" env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1) || { echo "build final failed" >> queue-final.log; exit 1; }
echo "built final $(date -Is)" >> queue-final.log
"$lock" bash -c "cd final && ./build/compiler test-tier0 > ../final-tier0.log 2>&1; echo \"test-tier0 \$? \$(tail -1 ../final-tier0.log)\" >> ../queue-final.log; ./build/compiler test-unwind > ../final-unwind.log 2>&1; echo \"test-unwind \$?\" >> ../queue-final.log"
nm -S --defined-only final/build/compiler | awk '{print $4, $2}' | sort > functions-final.txt
comm -3 functions-main.txt functions-final.txt > functions-diff-final.txt
mkdir -p counters-final
"$lock" bash -c 'for t in main final main final; do taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u,L1-icache-load-misses:u,ic_tag_hit_miss.instruction_cache_miss:u ./$t/build/compiler benchmark-backend --only vector > counters-final/$t.out 2>> counters-final/$t.perf; done'
"$lock" bash -c 'for t in main final main final; do taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u,L1-icache-load-misses:u,ic_tag_hit_miss.instruction_cache_miss:u ./$t/build/compiler benchmark-backend --only scalar > counters-final/$t-scalar.out 2>> counters-final/$t-scalar.perf; done'
echo "counters $(date -Is)" >> queue-final.log
for round in 1 2 3 4 5 6; do
    if [ $((round % 2)) -eq 1 ]; then order="main final"; else order="final main"; fi
    "$lock" ./round-final.sh "$round" $order
    echo "round $round ($order) $(date -Is)" >> queue-final.log
done
cmp "objects-final/sqlite3-main.o" "objects-final/sqlite3-final.o" >> queue-final.log 2>&1 && echo "sqlite3.o identical" >> queue-final.log
echo "done $(date -Is)" >> queue-final.log
