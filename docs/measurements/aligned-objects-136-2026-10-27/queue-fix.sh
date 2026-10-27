#!/usr/bin/env bash
# The fix's A/B: builds the fix tree under the lock, checks it (test-tier0, test-unwind), compares its functions with
# main's, takes counters of both (perf stat, in one hold), then 8 rounds of round.sh against main, each under one hold
# of the lock, the trees' order alternating, and compares their sqlite3.c objects. Run detached (setsid -f).
set -u
cd "$(dirname "$0")"
export EXCLUSIVE_OWNER=claude-aligned-136 EXCLUSIVE_TITLE="Objects aligned past 16 (#136): main vs fix" EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/136"
lock=~/buster-fast-bench/exclusive.sh
(cd fix && "$lock" env BUSTER_DEBUG_INFO=0 ./build.sh > build.log 2>&1) || { echo "build fix failed" >> queue-fix.log; exit 1; }
echo "built fix $(date -Is)" >> queue-fix.log
"$lock" bash -c "cd fix && ./build/compiler test-tier0 > ../fix-tier0.log 2>&1; echo \"test-tier0 \$? \$(tail -1 ../fix-tier0.log)\" >> ../queue-fix.log; ./build/compiler test-unwind > ../fix-unwind.log 2>&1; echo \"test-unwind \$?\" >> ../queue-fix.log"
nm -S --defined-only fix/build/compiler | awk '{print $4, $2}' | sort > functions-fix.txt
comm -3 functions-main.txt functions-fix.txt > functions-diff-fix.txt
mkdir -p counters-fix
"$lock" bash -c 'for t in main fix main fix; do taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u,L1-icache-load-misses:u,ic_tag_hit_miss.instruction_cache_miss:u ./$t/build/compiler benchmark-backend --only vector > counters-fix/$t.out 2>> counters-fix/$t.perf; done'
echo "counters $(date -Is)" >> queue-fix.log
for round in 1 2 3 4 5 6 7 8; do
    if [ $((round % 2)) -eq 1 ]; then order="main fix"; else order="fix main"; fi
    "$lock" ./round-fix.sh "$round" $order
    echo "round $round ($order) $(date -Is)" >> queue-fix.log
done
cmp "objects-fix/sqlite3-main.o" "objects-fix/sqlite3-fix.o" >> queue-fix.log 2>&1 && echo "sqlite3.o identical" >> queue-fix.log
echo "done $(date -Is)" >> queue-fix.log
