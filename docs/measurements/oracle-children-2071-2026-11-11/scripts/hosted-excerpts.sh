#!/bin/bash
# Copied from ../../served-oracles-remaining-2071-2026-11-11/scripts/hosted-excerpts.sh (buster-performance#386); only this line is new.
# Writes, for each hosted test shard's log in a run's log archive (its directory, unzipped), the raw lines behind
# hosted-times.sh's: the runner's CPU model, the build step's clang server line, and for test-preprocessor's commands
# (the cases' four parts and the repository's units) and test-parser's snippets, the parallel runner's report and the
# command's oracle cache and clang server lines. One file per shard in OUTPUT_DIRECTORY.
# Usage: hosted-excerpts.sh DIRECTORY OUTPUT_DIRECTORY
set -euo pipefail
directory=$1
output=$2
mkdir -p "$output"
for log in "$directory"/[0-9]*_Tests*"shard "[1-4]" of 4"*.txt; do
    name=$(basename "$log" | sed -E 's/.*Clang 23, ([^,]*), .*shard ([0-9]) of 4.*/\1-shard\2/')
    {
        grep -m1 -P 'Z model name\t' "$log" || true
        grep -m1 'clang-server: .*smoke request' "$log" || true
        sed -e 's/\r$//' "$log" | awk '
            / ##\[group\]Test the (preprocessor.s cases against clang|preprocessor on the repository.s translation units|parser.s snippets against clang)/ { keep = 1; print; next }
            / ##\[group\]/ { keep = 0 }
            keep && / test-(preprocessor|parser): (clang server|oracle cache) \(/ { print }
        '
    } > "$output/$name.txt"
done
