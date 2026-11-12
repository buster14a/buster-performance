#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# pages.sh ROUND: the page policy apart from the load, inside one hold of the lock. main gives a compile alone huge
# pages and one that starts on a busy host base pages (#1561), so baseline.sh's 1 worker and 8 workers differ in both.
# This runs the other two corners: 1 worker with base pages (BUSTER_HUGE_PAGES=0) and 8 workers with the system's huge
# pages (BUSTER_HUGE_PAGES=1), 6 compiles a worker, once for each counter set (basic, td, lat, mem).
set -u
cd "$(dirname "$0")"
. ./common.sh
round=${1:?a round}
out=results/pages/r$round
mkdir -p "$out"
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sets=(basic td lat mem)
for ((s = 0; s < 4; s += 1)); do
    set=${sets[(s + round) % 4]}
    BUSTER_HUGE_PAGES=0 sqlite_cohort "$out" "sqbase-$set.w1" 6 "$sqlite/sqlite3.c" "$set" || { status=1; echo "sqbase-$set.w1 failed" >&2; }
    BUSTER_HUGE_PAGES=1 sqlite_cohort "$out" "sqhuge-$set.w8" 6 "$sqlite/sqlite3.c" "$set" || { status=1; echo "sqhuge-$set.w8 failed" >&2; }
done
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
