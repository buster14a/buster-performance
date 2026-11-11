#!/bin/sh
# #1444 item 3: perf stat (task clock, faults, user and kernel cycles) of base, bss2 and base again (the floor),
# placement 0 of each, 4 rounds in a rotating order, warm (perf stat -r: each process right after the last of the same
# build), pinned to CPU 2; each round one hold of the 9700X's lock. Then the host's description.
set -e
d=~/buster-fast-bench/1444-claude-thp
. $d/env.sh
out=$d/results/kstat-bss2
mkdir -p $out
cd $d/inputs
for round in 1 2 3 4; do
    case $round in
        1) order="base bss2 base-again";;
        2) order="bss2 base-again base";;
        3) order="base-again base bss2";;
        4) order="base bss2 base-again";;
    esac
    ~/buster-fast-bench/exclusive.sh sh -c "
        for b in $order; do
            n=\$b; [ \$b = base-again ] && n=base
            C=$d/shifts-\$n/compiler-0
            taskset -c 2 perf stat -r 300 -x, -e task-clock,page-faults,cycles:u,cycles:k -o $out/\$b-syntax-$round.csv \$C -fsyntax-only empty.c > /dev/null 2>&1
            taskset -c 2 perf stat -r 300 -x, -e task-clock,page-faults,cycles:u,cycles:k -o $out/\$b-preprocess-$round.csv \$C -E -P empty.c -o /dev/null > /dev/null 2>&1
            taskset -c 2 perf stat -r 300 -x, -e task-clock,page-faults,cycles:u,cycles:k -o $out/\$b-tiny-$round.csv \$C -c tiny.c -o /dev/null > /dev/null 2>&1
            taskset -c 2 perf stat -r 150 -x, -e task-clock,page-faults,cycles:u,cycles:k -o $out/\$b-hello-$round.csv \$C -c hello.c -o /dev/null > /dev/null 2>&1
        done"
done
{ lscpu | grep -E "Model name|^CPU\(s\)|On-line"; uname -r; cat /sys/kernel/mm/transparent_hugepage/enabled /sys/kernel/mm/transparent_hugepage/defrag; cat /proc/sys/vm/overcommit_memory; for c in 2 3; do cat /sys/devices/system/cpu/cpu$c/cpufreq/scaling_governor; done; clang --version | head -1; perf --version; strace -V | head -1; ldd --version | head -1; df -T $d | tail -1; sha256sum $d/shifts-*/compiler-* $d/*.patch $d/inputs/*.c; } > $d/results/hostinfo.txt 2>&1
echo done > $out/done
