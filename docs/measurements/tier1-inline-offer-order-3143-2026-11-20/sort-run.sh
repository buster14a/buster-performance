#!/usr/bin/env bash
set -euo pipefail
p=offer-evidence;w=$(pwd);export CORES_LINK=https://github.com/buster14a/buster/issues/2541
while [[ ! -f $p/qualified ]];do sleep 4;done
python "$p/sort.py"
(cd inline-offers && CORES_TITLE='Build sorted and variable-digit callee offers without changing the shared sorter' cores -n 2 -- env BUSTER_HOST_ARCH=znver5 ./build.sh --config Release) >"$p/sort-build.log" 2>&1
touch "$p/sort-built"
(cd offer-count && CORES_TITLE='Count varying symbol digits and naturally ordered Tier 1 units' cores -n 2 -- env BUSTER_HOST_ARCH=znver5 ./build.sh --config Release) >"$p/sort-census-build.log" 2>&1
bash "$p/census.sh"
for mode in normal debug;do
 CORES_TITLE="Measure ordered callee reuse in $mode SQLite and Lua compiles" cores -n 1 -- python local-compiler-pair.py "$mode" inline-shape-cache/build/compiler inline-offers/build/compiler "$p/sort-$mode" "$mode" >"$p/sort-$mode-run.log" 2>&1
 python summarize-compile.py "$p/sort-$mode" "$mode" "$p/sort-$mode-process.tsv" >"$p/sort-$mode-summary.txt"
done
CORES_TITLE='Verify the gated sort with actual debug and release compiler outputs' cores -n 1 -- bash -ec 'python compare-musl.py inline-shape-cache/build/compiler inline-offers/build/compiler offer-evidence/sort-musl;bash offer-evidence/sort-apps.sh;cd inline-offers;./build/compiler test-ir-inline;./build/compiler test-check-debug --cross-check' >"$p/sort-checks.log" 2>&1
touch "$p/sort-qualified"
