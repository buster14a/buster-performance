#!/usr/bin/env bash
set -euo pipefail
w=$(pwd);p="$w/tip-evidence";export CORES_LINK=https://github.com/buster14a/buster/pull/3146
while [[ ! -e "$w/unsigned64-evidence/costs/pushed" ]];do sleep 5;done
python tip-prepare.py >> "$p/merge.log" 2>&1
(cd "$w/tip-candidate" && CORES_TITLE="Build the integrated 27-PR compiler on current main" cores -n2 -- env BUSTER_HOST_ARCH=znver5 ./build.sh --config Release) >"$p/build.log" 2>&1
touch "$p/built"
CORES_TITLE="Measure all 27 PRs together on release and debug SQLite and Lua" cores -n1 -- python local-compiler-pair.py debug tip-control/build/compiler tip-candidate/build/compiler "$p/paired" tip > "$p/pair.log" 2>&1
python summarize-compile.py "$p/paired" tip "$p/processes.tsv" > "$p/summary.txt"
touch "$p/paired-ready"
