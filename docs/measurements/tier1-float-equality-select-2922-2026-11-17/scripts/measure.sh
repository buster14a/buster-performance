#!/bin/bash
# #2922's kernels (kernels.c, bench.c): measure.sh DIR ROUNDS TREE..., in ~/buster-fast-bench/2922-claude/DIR. Builds the
# objects by each tree's --tier1 --tier1-strict -c and clang -O2 -fno-vectorize in the first hold and checks every
# build's output alike, then runs each round's 7 kernels x 4 builds in one hold of the 9700X's lock,
# pinned to CPU 2, each run after an untimed one, under perf stat (cycles:u, instructions:u, branch-misses:u); the
# builds' order rotates by round. #2791's measure.sh with these trees. Results: results.tsv.
set -u
t=~/buster-fast-bench/2922-claude
mkdir -p $t/$1
cd $t/$1
rounds=$2
shift 2
trees="$*"
cp $t/scripts/kernels.c $t/scripts/bench.c .
export EXCLUSIVE_OWNER=claude-2922 EXCLUSIVE_TITLE="#2922 Tier 1: a select of a floating == or != by two cmovs where its values don't recur" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2922
kernels="null best equal sum lt eq ne"
builds="$trees o2"
for b in $trees; do test -x $t/$b/build/compiler || { echo "missing $b"; exit 1; }; done
cat > build.sh <<BUILD
set -e
head -1 /var/lib/buster-9700x/owner >> holds.txt
{ uname -a; clang --version | head -1; perf --version; echo "cpu2 governor \$(cat /sys/devices/system/cpu/cpu2/cpufreq/scaling_governor) epp \$(cat /sys/devices/system/cpu/cpu2/cpufreq/energy_performance_preference)"; for b in $trees; do echo "\$b \$(cat $t/\$b/COMMIT)"; done; } > identities.txt
for b in $trees; do $t/\$b/build/compiler --tier1 --tier1-strict -c -o k_\$b.o kernels.c; done
clang -O2 -fno-vectorize -c -o k_o2.o kernels.c
clang -O2 -c -o bench.o bench.c
for b in $builds; do clang -o bench_\$b bench.o k_\$b.o; done
for b in $builds; do objdump -d --no-show-raw-insn k_\$b.o > k_\$b.s; done
nm -n $(for b in $trees; do printf "k_%s.o " $b; done) > symbols.txt
sha256sum $(for b in $trees; do printf "$t/%s/build/compiler " $b; done) kernels.c bench.c k_*.o bench_* >> identities.txt
for k in $kernels; do for b in $builds; do taskset -c 2 ./bench_\$b \$k; done | sort -u | awk -v k=\$k 'END { if (NR != 1) { print "outputs differ for " k; exit 1 } }'; done
echo built and checked
BUILD
~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash build.sh > build.log 2>&1 || { echo "build failed"; cat build.log; exit 1; }
grep -q "built and checked" build.log || { echo "build not checked"; exit 1; }
printf 'round\tkernel\tbuild\tcycles\tinstructions\tbranch_misses\twall_ns\tstatus\n' > results.tsv
for round in $(seq 1 "$rounds"); do
    all=($builds)
    r=$(( (round - 1) % ${#all[@]} ))
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
    ~/buster-fast-bench/exclusive.sh timeout -k 5 180 bash round.sh 2>> lock.log
done
echo done > measure.done
