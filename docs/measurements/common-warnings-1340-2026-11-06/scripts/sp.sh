#!/usr/bin/env bash
# #1340: a cycles:u profile of head's self-syn (one compile, CPU 2), then its per-symbol samples and
# check_driver_common_warnings' source lines, all in one hold.
set -u
cd ~/buster-fast-bench/1340-droid/root || exit 2
SCRATCH=scratch/zen5-9700x
source ../repo/tools/microarch/workloads.sh
mkdir -p ../sp
workload znver5 self-syn
printf '%q ' "${WL[@]}" > ../sp/znver5-self.cmd
EXCLUSIVE_OWNER=droid-1340 EXCLUSIVE_TITLE="droid #1340 common warnings cost" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1340 \
    ~/buster-fast-bench/exclusive.sh bash -c '
        head -1 /var/lib/buster-9700x/owner >> ../sp/holds.txt
        LC_ALL=C taskset -c 2 perf record -q -e cycles:u -c 50021 -o ../sp/znver5-self.data -- bash -c "$(cat ../sp/znver5-self.cmd)" > ../sp/znver5-self.log 2>&1 || exit 1
        LC_ALL=C perf report -i ../sp/znver5-self.data --no-children --sort sym --stdio -F sample,sym 2>/dev/null | grep -v "^#" | grep -v "^$" > ../sp/znver5-self.samples.txt || exit 1
        LC_ALL=C perf report -i ../sp/znver5-self.data --no-children --symbols check_driver_common_warnings --sort srcline --stdio -F sample,srcline 2>/dev/null | grep -v "^#" | grep -v "^$" > ../sp/znver5-self.common-srcline.txt'
echo "done status=$?" >> ../sp.done
