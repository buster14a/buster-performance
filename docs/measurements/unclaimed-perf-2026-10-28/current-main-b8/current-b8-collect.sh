#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
set -euo pipefail
cd "$HOME/buster-fast-bench/unclaimed-perf-20261028"
mkdir -p results/current-b8-meta
sha256sum base-4165454e/build/compiler combined-416-b8cd163c/build/compiler > results/current-b8-meta/binaries.sha256
find results/current-b8-j1 results/current-b8-j8 results/current-b8-aa-j1 results/current-b8-aa-j8 -type f -name '*.o' -print0 | sort -z | xargs -0 sha256sum > results/current-b8-meta/objects.sha256
awk '{print $1}' results/current-b8-meta/objects.sha256 | sort | uniq -c > results/current-b8-meta/object-summary.txt
find results/current-b8-j1 results/current-b8-j8 results/current-b8-aa-j1 results/current-b8-aa-j8 results/current-b8-meta -type f ! -name '*.o' -print0 > current-b8-metadata.list0
tar --null -czf current-b8-metadata.tar.gz -T current-b8-metadata.list0
sha256sum current-b8-metadata.tar.gz
cat results/current-b8-meta/object-summary.txt
