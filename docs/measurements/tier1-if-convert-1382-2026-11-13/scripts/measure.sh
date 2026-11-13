#!/bin/bash
# #1382's kernels on the 9700X: measure.sh MAIN_TREE HEAD_TREE ROUNDS. Builds the objects in the first hold, then
# runs each round's 8 kernels x 4 builds in one hold of the 9700X's lock (a few seconds), pinned to CPU 2, under
# perf stat (cycles:u, instructions:u, branch-misses:u); the builds' order rotates by round. Results: results.tsv.
set -u
cd "$(dirname "$0")"
main=$1
head=$2
rounds=$3
export EXCLUSIVE_OWNER=claude-1382 EXCLUSIVE_TITLE="#1382 Tier 1 if-conversion of nested, truth and reload regions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1382
kernels="null max clamp and andor condsum abssum runmax"
builds="main head o2 o0"
cat > build.sh <<BUILD
set -e
head -1 /var/lib/buster-9700x/owner >> holds.txt
{ uname -a; clang --version | head -1; perf --version; echo "cpu2 governor \$(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp \$(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"; cat $main/COMMIT $head/COMMIT; } > identities.txt
$main/build/compiler --tier1 --tier1-strict -c -o k_main.o kernels.c
$head/build/compiler --tier1 --tier1-strict -c -o k_head.o kernels.c
clang -O2 -fno-vectorize -c -o k_o2.o kernels.c
clang -O0 -c -o k_o0.o kernels.c
clang -O2 -c -o bench.o bench.c
for b in $builds; do clang -o bench_\$b bench.o k_\$b.o; done
for b in $builds; do objdump -d --no-show-raw-insn k_\$b.o > k_\$b.s; done
sha256sum $main/build/compiler $head/build/compiler kernels.c bench.c k_*.o bench_* >> identities.txt
for k in $kernels; do for b in $builds; do taskset -c 2 ./bench_\$b \$k; done | sort -u | awk -v k=\$k 'END { if (NR != 1) { print "outputs differ for " k; exit 1 } }'; done
echo built and checked
BUILD
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash build.sh > build.log 2>&1 || { echo "build failed"; cat build.log; exit 1; }
printf 'round\tkernel\tbuild\tcycles\tinstructions\tbranch_misses\twall_ns\tstatus\n' > results.tsv
for round in $(seq 1 "$rounds"); do
    all=($builds)
    r=$(( (round - 1) % 4 ))
    order="${all[*]:r} ${all[*]:0:r}"
    cat > round.sh <<ROUND
head -1 /var/lib/buster-9700x/owner >> holds.txt
echo "== round $round: \$(cat /proc/loadavg)" >> busy.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -8 >> busy.txt
for k in $kernels; do
    for b in $order; do
        taskset -c 2 ./bench_\$b \$k > /dev/null
        start=\$(date +%s%N)
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u,branch-misses:u -o stat.csv ./bench_\$b \$k > /dev/null
        status=\$?
        end=\$(date +%s%N)
        c=\$(awk -F, '\$3 ~ /^cycles/ { print \$1 }' stat.csv)
        i=\$(awk -F, '\$3 ~ /^instructions/ { print \$1 }' stat.csv)
        m=\$(awk -F, '\$3 ~ /^branch-misses/ { print \$1 }' stat.csv)
        printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' $round \$k \$b \$c \$i \$m \$(( end - start )) \$status >> results.tsv
    done
done
echo "== after round $round: \$(cat /proc/loadavg)" >> busy.txt
ROUND
    ~/buster-fast-bench/exclusive.sh timeout -k 5 120 bash round.sh 2>> lock.log
done
echo done
