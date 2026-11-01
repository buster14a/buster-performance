#!/bin/bash
set -u
export LC_ALL=C
tree=$HOME/.cache/solve982-gentle/head
out=$HOME/.cache/solve982-gentle/measure
cd "$tree" || exit 1
./build/compiler test-tier1-select > "$out/test-tier1-select.log" 2>&1; echo "select exit $?" >> "$out/test-tier1-select.log"
./build/compiler test-tier1-emit > "$out/test-tier1-emit.log" 2>&1; echo "emit exit $?" >> "$out/test-tier1-emit.log"
./build/compiler test-tier1-pipeline --cross-check > "$out/test-tier1-pipeline.log" 2>&1; echo "pipeline exit $?" >> "$out/test-tier1-pipeline.log"
./build/compiler test-c-testsuite --tier1 --jobs 8 --subset tests/c-testsuite/subset.txt "$HOME/buster-fast-bench/claude-435/c-testsuite" > "$out/test-c-testsuite.log" 2>&1; echo "c-testsuite exit $?" >> "$out/test-c-testsuite.log"
for f in test-tier1-select.log test-tier1-emit.log test-tier1-pipeline.log test-c-testsuite.log; do tail -n 2 "$out/$f"; done
