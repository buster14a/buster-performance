#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
export EXCLUSIVE_OWNER=codex-596
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/627
root=$PWD
lock="$HOME/buster-fast-bench/exclusive.sh"
cd head
EXCLUSIVE_TITLE='Buster #596 head build' "$lock" env BUSTER_DEBUG_INFO=0 ./build.sh > "$root/record/build-head.txt" 2>&1
cd "$root/record"
while [[ ! -x ../base/build/compiler ]]; do sleep 2; done
EXCLUSIVE_TITLE='Buster #596 measurement tools and scratch audit' "$lock" bash build-tools.sh > build-tools.txt 2>&1
for round in 0 1 2; do
    EXCLUSIVE_TITLE="Buster #596 matched comparison round $round" "$lock" taskset -c 2 ./compare \
        "$root/base/build/compiler" "$root/head/build/compiler" "$root/record/inputs" "$root/record/objects" "$round" \
        "$HOME/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite/sqlite3.c" > "round-$round.tsv" 2> "round-$round.err"
done
EXCLUSIVE_TITLE='Buster #596 ELF and runtime correctness' "$lock" bash verify.sh > verify.txt 2>&1
cd "$root/head"
printf '%s\n' 'test-checker --seed 133' 'test-checker --seed 1' 'test-checker-driver --executable ./build/compiler' \
    'test-object-writer --cross-check' 'test-tier0' > "$root/record/tests.list"
EXCLUSIVE_TITLE='Buster #596 integration tests' "$lock" ./build/compiler parallel --jobs 4 --timeout 180 "$root/record/tests.list" > "$root/record/tests.txt" 2>&1
EXCLUSIVE_TITLE='Buster #596 call graph check' "$lock" ./build.sh check-call-graph > "$root/record/call-graph.txt" 2>&1
echo complete > "$root/record/complete"
