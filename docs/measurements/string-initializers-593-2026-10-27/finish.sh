#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
if ! grep -qx 'comparisons status=0' comparisons-progress.log; then
    grep -qx 'comparisons status=0' comparisons-complete
fi
grep -qx 'string_counters byte_identical=1 status=0' control-progress.log
samples=$(grep -h '^sample,' logs/comparison-*.csv | wc -l)
objects=$(grep -h '^objects,' logs/comparison-*.csv | wc -l)
verified=$(grep -h '^verify,' logs/comparison-*.csv | wc -l)
summaries=$(grep -h '^summary,' logs/comparison-*.csv | wc -l)
completed=$(grep -h '^comparison,.*status=0$' logs/comparison-*.csv | wc -l)
test "$samples" -eq 560
test "$objects" -eq 112
test "$verified" -eq 84
test "$summaries" -eq 28
test "$completed" -ge 11
test "$completed" -le 14
if grep -h -E 'byte_identical=0|status=[1-9]' logs/comparison-*.csv; then exit 1; fi
if grep -E '<not (counted|supported)>' logs/*-perf.csv; then exit 1; fi
clang -std=c17 -O2 -Wall -Wextra -Werror summarize_pairs.c -o summarize_pairs
./summarize_pairs . > tables.md
sha256sum objects/paired-*.o > objects.sha256
sha256sum ../base/build/compiler ../head/build/compiler generate compare > binaries.sha256
if test -f compare-controls; then sha256sum compare-controls >> binaries.sha256; fi
sha256sum objects/sqlite-*.o objects/strings-160000-*.o > control-objects.sha256
sha256sum generate.c verify.c compare.c compare-v1.c summarize_pairs.c setup.sh comparisons.sh comparisons-v1.sh control.sh finish.sh > harness.sha256
printf 'primary: %s compiler processes; %s identical-object rounds; %s runtime checks; %s summaries; %s completed cohorts\n' \
    "$samples" "$objects" "$verified" "$summaries" "$completed"
echo 'record validation status=0'
