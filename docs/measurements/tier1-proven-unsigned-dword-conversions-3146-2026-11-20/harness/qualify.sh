#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/unsigned32-evidence";export CORES_LINK=https://github.com/buster14a/buster/issues/2829
while [[ ! -f "$p/head-built" || ! -f "$p/parent-built" ]];do sleep 5;done
for t in test-tier1-emit test-tier1-pipeline test-tier1-select test-tier1-schedule;do
 (cd "$w/unsigned32" && CORES_TITLE='Check selection, allocation and conversion records with the new storage proof' cores -n1 -- ./build/compiler "$t") >"$p/$t.log" 2>&1
done
CORES_TITLE='Check unsigned dword conversions with dirty registers, guarded memory, rounding and real spills' cores -n1 -- bash -ec 'python unsigned32-evidence/verify.py && python unsigned32-evidence/pressure.py' >"$p/oracles.log" 2>&1
touch "$p/oracles-passed"
CORES_TITLE='Compare scalar unsigned conversion loops across four executable placements' cores -n1 -- bash -ec 'python unsigned32-evidence/loops/run.py build && python unsigned32-evidence/loops/run.py time' >"$p/loop.log" 2>&1
touch "$p/loop-passed"
CORES_TITLE='Inspect all 1,336 musl objects for actual unsigned dword conversions' cores -n1 -- python compare-musl.py late-control/build/compiler unsigned32/build/compiler "$p/musl" >"$p/musl.log" 2>&1
touch "$p/qualified"
