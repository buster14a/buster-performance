#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# sets.sh ROUND: the frozen sqlite3.c's -c at 1 worker (CPU 2) and at 8 (CPUs 0 to 7), 6 compiles a worker, once for
# each of common.sh's other counter sets (td, lat, mem), inside one hold of the lock: what the pipeline's slots, its
# loads and the caches' fills cost a compile alone and beside seven others. The compiles are as baseline.sh's, with
# main's page policy (huge pages alone, base pages where the host is busy).
set -u
cd "$(dirname "$0")"
. ./common.sh
round=${1:?a round}
out=results/sets/r$round
mkdir -p "$out"
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sets=(td lat mem)
for ((s = 0; s < 3; s += 1)); do
    set=${sets[(s + round) % 3]}
    for workers in w1 w8; do
        sqlite_cohort "$out" "sq-$set.$workers" 6 "$sqlite/sqlite3.c" "$set" || { status=1; echo "sq-$set.$workers failed" >&2; }
    done
done
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
