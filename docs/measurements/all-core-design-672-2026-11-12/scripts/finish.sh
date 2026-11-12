#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# finish.sh: the reductions, after the last run, inside one hold of the lock: every sampled cohort's buckets again from
# its samples (rebucket.sh), every table (tables.sh), the tables as Markdown (report.sh), and the stage reports of each
# cohort directory packed into one archive beside it (they are thousands of small files).
set -u
cd "$(dirname "$0")"
head -1 /var/lib/buster-9700x/owner > results/finish.holder.txt
./rebucket.sh
./tables.sh
./report.sh
for stages in results/*/r*/stages results/sampled/stages results/timeline/stages results/latency/r*/stages; do
    [[ -d $stages ]] || continue
    tar -C "$(dirname "$stages")" -czf "$(dirname "$stages")/stages.tar.gz" stages
done
date -u +%FT%TZ > results/finish.done
