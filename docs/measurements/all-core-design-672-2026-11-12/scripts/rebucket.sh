#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
#
# rebucket.sh: every sampled cohort's reduction again from its samples in scratch/ (after a change to the reducer),
# inside a hold of the lock: sampled.sh's and muslsample.sh's `allcore buckets` lines, with their arguments.
set -u
cd "$(dirname "$0")"
. ./common.sh
for rows in results/sampled/*.rows.tsv; do
    label=$(basename "$rows" .rows.tsv)
    [[ -f scratch/$label.samples.gz ]] || continue
    workers=${label##*.}
    without=$(awk '{ c = $3; if (c >= 8) c -= 8; print c }' "results/sampled/$label.strays.txt" | sort -un | paste -sd, -)
    [[ $workers == w1 ]] && without=
    pids=$(awk '{ print $7 }' "results/sampled/$label.strays.txt" | sort -un | paste -sd, -)
    ./allcore buckets --rows "$rows" --stages "results/sampled/stages/$label.w%w.r%i.txt" --samples "scratch/$label.samples.gz" --interior --without "${without:--}" --without-pid "${pids:--}" --functions 30 \
        --families families.tsv > "results/sampled/$label.buckets.tsv" || echo "$label failed" >&2
done
for rows in results/muslsampled/*.rows.tsv; do
    [[ -f $rows ]] || continue
    name=$(basename "$rows" .rows.tsv)
    [[ -f scratch/$name.samples.gz ]] || continue
    all=
    [[ $name == m.l8-* ]] && all=--all-cpus
    pids=$(awk '{ print $7 }' "results/muslsampled/$name.strays.txt" | sort -un | paste -sd, -)
    ./allcore buckets --rows "$rows" --samples "scratch/$name.samples.gz" $all --without-pid "${pids:--}" --functions 60 --families families.tsv > "results/muslsampled/$name.buckets.tsv" || echo "$name failed" >&2
done
