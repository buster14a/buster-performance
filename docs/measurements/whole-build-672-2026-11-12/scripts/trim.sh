#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md of buster14a/buster.
#
# trim.sh RAW: what the record doesn't keep of the host's results, cut in place; no measurement, so it runs anywhere.
#   dwarfcensus/*.verify.txt   llvm-dwarfdump --verify's output (a message with its DIE for every finding, megabytes)
#                              to its first 6 lines, its messages' counts by kind, and its last 6 lines
#   prepare/build.log          without the lines the lock printed while it waited for another holder (they name
#                              that holder's command, not this record's)
#   */ROUND-LABEL-RUN.STEP.out, .err   a captured output that is empty (most commands print nothing) is not kept
set -u
raw=${1:?the raw results}
for verify in "$raw"/dwarfcensus/*.verify.txt; do
    if ! grep -q '^## messages by kind' "$verify"; then
        {
            head -6 "$verify"
            echo "## messages by kind (numbers as N), of $(grep -c '' "$verify") lines"
            grep -E '^(error|warning):' "$verify" | sed -E 's/0x[0-9a-f]+/0xN/g; s/[0-9]+/N/g' | sort | uniq -c | sort -rn
            echo "## the last lines"
            tail -6 "$verify"
        } > "$verify.cut"
        mv "$verify.cut" "$verify"
    fi
done
if [[ -f $raw/prepare/build.log ]]; then
    awk '/^exclusive\.sh: waiting/ { skip = 1; next } skip && /^  (title|link):/ { next } { skip = 0; print }' "$raw/prepare/build.log" > "$raw/prepare/build.log.cut"
    mv "$raw/prepare/build.log.cut" "$raw/prepare/build.log"
fi
find "$raw" -type f -empty -regex '.*/[0-9]+-[^/]*-[0-9]+\.[0-9]+\.\(out\|err\)' -delete
