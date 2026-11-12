#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# linkbench.sh: the repository's own benchmark of the direct path's link at the measured revision, for the warm figures
# beside this record's whole processes: benchmark-link --only direct, dynamic and static, its lane on CPU 2, twice,
# inside one hold of the lock (lock.sh ./linkbench.sh).
set -u
cd "$(dirname "$0")"
. ./common.sh
out=$here/results/linkbench
mkdir -p "$out" $t/bl $t/cache-bench
head -1 /var/lib/buster-9700x/owner > "$out/holder.txt"
status=0
for r in 1 2; do
    "$c" benchmark-link --only direct --kinds dynamic,static --cpus 2 --directory $t/bl --cache $t/cache-bench > "$out/direct-$r.txt" 2>&1 || status=1
done
if ((status == 0)); then date -u +%FT%TZ > "$out/.done"; fi
exit $status
