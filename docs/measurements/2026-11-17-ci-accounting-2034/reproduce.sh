#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# Offline replay. Pass a checkout containing the #2034 implementation.
set -euo pipefail
checkout=${1:?usage: reproduce.sh BUSTER_CHECKOUT}
checkout=$(cd "$checkout" && pwd)
root=$(cd "$(dirname "$0")" && pwd)
[[ -f "$root/replay/collection.json" ]] || { echo 'Extract capture.tar.gz here before replaying.' >&2; exit 1; }
(cd "$root" && sha256sum -c raw-SHA256SUMS > raw-checksums-verified.txt)
cd "$checkout"
GITHUB_REPOSITORY=buster14a/buster CI_TIMINGS_REPLAY="$root/replay" \
    bash tools/ci/timings.sh "$root/output" > "$root/collector-stdout.md"
# Keep the collector output unchanged. Add the sample-design note to the
# separately published facts and regenerate the report with the same engine.
cp "$root/output/facts.tsv" "$root/facts.tsv"
printf 'note\tsample-design\tThis is a purposive 12-run illustrative replay. Run-list files are derived projections of retained actual metadata, not original workflow-list responses. Empty projections do not mean no actual runs. Raw responses and projection provenance are retained. Latest/count phrases in collector notes describe replay inputs only; no population, arrival-rate, or causal before/after claim is made.\n' >> "$root/facts.tsv"
temporary=$(mktemp -d)
trap 'rm -rf "$temporary"' EXIT
cc -std=c17 -O2 -Wall -Wextra -Werror -fno-strict-aliasing tools/ci/timings.c -o "$temporary/timings"
"$temporary/timings" --accounting < "$root/facts.tsv" > "$root/summary.md"
git rev-parse HEAD > "$root/implementation-base.txt"
sha256sum tools/ci/timings.c tools/ci/timings_accounting.c tools/ci/timings-facts.jq tools/ci/timings.sh > "$root/implementation-SHA256SUMS"
printf 'Replayed retained facts with the C engine. Independent raw interval results are retained in verification.md and independent-checks.json.\n'
