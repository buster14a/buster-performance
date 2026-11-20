#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/region-batch-evidence";export CORES_LINK=https://github.com/buster14a/buster/issues/2542
while [[ ! -e $p/whole-built ]];do sleep 5;done
(cd region-batch && CORES_TITLE='Compare debugger-visible ranges after bypassing complete source lifetimes' cores -n1 -- ./build/compiler test-check-debug --cross-check) >"$p/debug.log" 2>&1
CORES_TITLE='Measure debug compilation with whole lifetimes omitted from the location queue' cores -n1 -- python local-compiler-pair.py debug debug-carriers/build/compiler region-batch/build/compiler "$p/paired" whole >"$p/paired.log" 2>&1
python summarize-compile.py "$p/paired" whole "$p/processes.tsv" >"$p/summary.txt"
touch "$p/measured"
CORES_TITLE='Verify all frozen musl, SQLite and Lua debug objects and executable results' cores -n1 -- bash -ec 'python compare-musl.py --debug debug-carriers/build/compiler region-batch/build/compiler region-batch-evidence/musl && bash region-batch-evidence/apps.sh' >"$p/corpus.log" 2>&1
touch "$p/qualified"
