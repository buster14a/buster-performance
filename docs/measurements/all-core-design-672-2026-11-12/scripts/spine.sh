#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# spine.sh ROUND: the function bodies' share at 1 worker and at 8, inside one hold of the lock. units.sh's preprocessed
# sqlite3.c is compiled whole and without its bodies (-c --lanes 1), 6 compiles a worker, at 1 worker (CPU 2) and at 8
# (CPUs 0 to 7), once for each of the counter sets basic, lat and mem: the difference between the two units is the
# bodies', stage by stage. The page policy is main's.
set -u
cd "$(dirname "$0")"
. ./common.sh
round=${1:?a round}
out=results/spine/r$round
mkdir -p "$out"
status=0
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
sets=(basic lat mem)
for ((s = 0; s < 3; s += 1)); do
    set=${sets[(s + round) % 3]}
    for workers in w1 w8; do
        sqlite_cohort "$out" "whole-$set.$workers" 6 scratch/sqlite3.i "$set" || { status=1; echo "whole-$set.$workers failed" >&2; }
        sqlite_cohort "$out" "spine-$set.$workers" 6 scratch/sqlite3-spine.i "$set" || { status=1; echo "spine-$set.$workers failed" >&2; }
    done
done
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
