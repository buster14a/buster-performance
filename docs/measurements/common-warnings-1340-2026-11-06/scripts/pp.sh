#!/usr/bin/env bash
# #1340: cycles:u profiles of head's sq-syn with and without -Wno-empty-body, 8 compiles each on CPU 2, one hold;
# then per-symbol samples of both.
set -u
cd ~/buster-fast-bench/1340-droid/root || exit 2
SCRATCH=scratch/zen5-9700x
source ../repo/tools/microarch/workloads.sh
mkdir -p ../pp
workload znver5 sq-syn
printf '%q ' "${WL[@]}" > ../pp/warning.cmd
printf '%q ' "${WL[@]}" -Wno-empty-body > ../pp/no-empty-body.cmd
EXCLUSIVE_OWNER=droid-1340 EXCLUSIVE_TITLE="droid #1340 common warnings cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340 \
    ~/buster-fast-bench/exclusive.sh bash -c '
        head -1 /var/lib/buster-9700x/owner >> ../pp/holds.txt
        for v in warning no-empty-body; do
            LC_ALL=C taskset -c 2 perf record -q -e cycles:u -c 50021 -o ../pp/$v.data -- bash -c "for i in 1 2 3 4 5 6 7 8; do $(cat ../pp/$v.cmd) || exit 1; done" > ../pp/$v.log 2>&1 || exit 1
        done'
status=$?
for v in warning no-empty-body; do
    LC_ALL=C perf report -i ../pp/$v.data --no-children --sort sym --stdio -F sample,sym 2>/dev/null | grep -v "^#" | grep -v "^$" > ../pp/$v.samples.txt || status=1
done
echo "done status=$status" >> ../pp.done
