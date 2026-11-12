#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# retime.sh: the one-worker timeline again, inside one hold of the lock. The queue's first one (14:56 UTC) counted
# 1,542 MB of DRAM traffic a compile where the baseline's controllers count about 1,380 for the same compile: the
# controllers count the whole host, and its intervals between runs and its first 100 ms carried traffic of no run's.
# Its files are kept in results/timeline/first-w1/; timeline.sh then writes the label's files again.
set -u
cd "$(dirname "$0")"
mkdir -p results/timeline/first-w1
mv results/timeline/sq-timeline.w1.* results/timeline/first-w1/
mkdir -p results/timeline/first-w1/stages
mv results/timeline/stages/sq-timeline.w1.* results/timeline/first-w1/stages/
exec ./timeline.sh sq /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c w1
