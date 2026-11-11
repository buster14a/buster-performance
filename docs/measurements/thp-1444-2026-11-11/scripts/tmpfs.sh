#!/bin/sh
# #1444 item 3: the executable's text in huge pages where a collapse can make them: two copies of build NAME's
# placement 0 (2 MB segment alignment) in tmpfs, the second's text collapsed (collapse, shmem huge folios); perf stat
# of both, alternating, 4 rounds, pinned to CPU 2, one hold of the 9700X's lock.
#   tmpfs.sh NAME
set -e
d=~/buster-fast-bench/1444-claude-thp
. $d/env.sh
out=$d/results/tmpfs-$1
mkdir -p $out
t=$(mktemp -d /tmp/thp1444.XXXXXX)
cp $d/shifts-$1/compiler-0 $t/plain
cp $d/shifts-$1/compiler-0 $t/huge
cd $d/inputs
~/buster-fast-bench/exclusive.sh sh -c "
    $d/collapse $t/huge > $out/collapse.txt 2>&1 || true
    for r in 1 2 3 4; do
        for c in plain huge; do
            taskset -c 2 perf stat -r 200 -e task-clock,page-faults,iTLB-load-misses,cycles:u,cycles:k -o $out/\$c-syntax-\$r.txt $t/\$c -fsyntax-only empty.c > /dev/null 2>&1
            taskset -c 2 perf stat -r 100 -e task-clock,page-faults,iTLB-load-misses,cycles:u,cycles:k -o $out/\$c-hello-\$r.txt $t/\$c -c hello.c -o /dev/null > /dev/null 2>&1
        done
    done"
rm -rf $t
echo done > $out/done
