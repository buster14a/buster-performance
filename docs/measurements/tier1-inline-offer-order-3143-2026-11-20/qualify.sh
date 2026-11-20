#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/offer-evidence";export CORES_LINK=https://github.com/buster14a/buster/issues/2541
while [[ ! -f $p/inline-offers-built ]];do sleep 4;done
CORES_TITLE='Check whole-unit inlining and its independent native executions' cores -n 1 -- bash -ec 'cd inline-offers; ./build/compiler test-ir-inline; ./build/compiler test-tier1-pipeline; ./build/compiler test-check-debug --cross-check' >"$p/suites.log" 2>&1
for mode in normal debug; do
 CORES_TITLE="Measure direct-call offer scanning during $mode compilation of SQLite and Lua" cores -n 1 -- python local-compiler-pair.py "$mode" inline-shape-cache/build/compiler inline-offers/build/compiler "$p/$mode" "$mode" >"$p/$mode-run.log" 2>&1
 python summarize-compile.py "$p/$mode" "$mode" "$p/$mode-process.tsv" >"$p/$mode-summary.txt"
done
CORES_TITLE='Compile 1,336 frozen musl objects and compare their complete bytes' cores -n 1 -- python compare-musl.py inline-shape-cache/build/compiler inline-offers/build/compiler "$p/musl" >"$p/musl.log" 2>&1
CORES_TITLE='Compare Lua and SQLite at both debug levels with the callee-offer filter' cores -n 1 -- bash "$p/apps.sh" >"$p/apps.log" 2>&1
touch "$p/qualified"
