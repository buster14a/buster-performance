#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# baseline.sh ROUND: one round of the frozen sqlite3.c's -c as independent processes, inside one hold of the lock:
# 1 worker on CPU 2, 1 on CPU 5 (a powersave core, for what the governors change), then 2, 4, 8 (one a physical core)
# and 15 (every online CPU), in an order rotated by ROUND. Each cohort is 6 compiles a worker one after another (4 on
# 15), each run counted (user and kernel cycles and instructions, L2 fills from DRAM, APERF and MPERF: common.sh's
# BASIC) and the cohort by the memory controllers and the package's energy on every CPU, with each run's own
# --time-stages report and resource use; and a 2 s idle control of the controllers' counters first.
set -u
cd "$(dirname "$0")"
. ./common.sh
round=${1:?a round}
out=results/baseline/r$round
mkdir -p "$out"
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
idle "$out" idle 2 || status=1
labels=(sq.w1 sq.w1b sq.w2 sq.w4 sq.w8 sq.w15)
n=${#labels[@]}
for ((s = 0; s < n; s += 1)); do
    label=${labels[(s + round) % n]}
    loops=6
    [[ $label == sq.w15 ]] && loops=4
    sqlite_cohort "$out" "$label" "$loops" "$sqlite/sqlite3.c" || { status=1; echo "$label failed" >&2; }
done
sha256sum scratch/sq.w1.w0.o scratch/sq.w8.w7.o > "$out/objects.txt"
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
