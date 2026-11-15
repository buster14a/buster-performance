#!/bin/bash
# After both builds: the kernels' A/B (11 rounds, a hold each), then the compile A/B (objects, then 3 rounds of perf stat
# and benchmark-lowering-source, a hold each), then host facts in a hold. Each script takes the lock per run itself.
B=~/buster-fast-bench/2678-claude
until grep -q '^done' $B/bench/builds.log 2>/dev/null; do sleep 10; done
main=$B/main-2ebfe68a/build/compiler
head=$B/head-e79a6338/build/compiler
cd $B/bench
./ab.sh $main $head 11 > ab.txt 2>&1
echo "ab exit $?" >> ab.txt
./compile-ab.sh $main $head ~/buster-fast-bench/corpus-391e729af658 3 > compile.txt 2>&1
echo "compile exit $?" >> compile.txt
./lock.sh host bash -c 'uname -r; cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference /sys/kernel/mm/transparent_hugepage/enabled; clang --version | head -1; perf --version' > host.txt 2>&1
echo finished >> host.txt
