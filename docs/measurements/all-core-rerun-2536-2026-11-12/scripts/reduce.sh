#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# reduce.sh: finish.sh without its rebucket.sh step (every sampled cohort's buckets were just made by sampled.sh and
# muslsample.sh with the same reducer), inside one hold of the lock: every table (tables.sh), the tables as Markdown
# (report.sh), and each cohort directory's stage reports packed into one archive beside it.
set -u
cd "$(dirname "$0")"
head -1 /var/lib/buster-9700x/owner > results/finish.holder.txt
./tables.sh
./report.sh
for stages in results/*/r*/stages results/sampled/stages results/timeline/stages results/latency/r*/stages; do
    [[ -d $stages ]] || continue
    tar -C "$(dirname "$stages")" -czf "$(dirname "$stages")/stages.tar.gz" stages
done
date -u +%FT%TZ > results/finish.done
