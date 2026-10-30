#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
source "$(dirname "$0")/environment.sh"
builds=()
for placement in 0 64 512; do
    for variant in base candidate; do
        builds+=(--build "$variant" "$Q/hot-$variant-$placement/build/compiler")
    done
done
taskset -c 2 "$Q/candidate/build/compiler" time-runs --runs 11 --warmups 2 --copies 2 \
  "${builds[@]}" --list -c "${sqlite[@]}" -o /dev/null \
  --list -fsyntax-only "${sqlite[@]}"
