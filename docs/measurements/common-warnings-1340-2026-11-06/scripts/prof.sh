#!/usr/bin/env bash
# #1340: cycles:u profiles of sq-c, 8 compiles per build, CPU 2, under the lock.
set -u
cd ~/buster-fast-bench/1340-droid/root || exit 2
SCRATCH=scratch/zen5-9700x
source ../repo/tools/microarch/workloads.sh
mkdir -p ../prof
for v in main-znver5 znver5; do
    workload "$v" sq-c
    printf '%q ' "${WL[@]}" > "../prof/$v.cmd"
done
EXCLUSIVE_OWNER=droid-1340 EXCLUSIVE_TITLE="droid #1340 common warnings cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340 \
    ~/buster-fast-bench/exclusive.sh bash -c '
        head -1 /var/lib/buster-9700x/owner >> ../prof/holds.txt
        for v in main-znver5 znver5; do
            LC_ALL=C taskset -c 2 perf record -q -e cycles:u -c 50021 -o ../prof/$v.data -- bash -c "for i in 1 2 3 4 5 6 7 8; do $(cat ../prof/$v.cmd) || exit 1; done" || exit 1
        done'
status=$?
for v in main-znver5 znver5; do
    LC_ALL=C perf report -i ../prof/$v.data --no-children --sort sym --stdio --percent-limit 0.25 2>/dev/null | grep -v '^#' | grep -v '^$' > ../prof/$v.syms.txt
done
echo "status=$status" > ../prof/done
