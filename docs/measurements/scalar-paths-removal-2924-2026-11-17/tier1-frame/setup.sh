#!/bin/bash
# setup.sh REV: tree exp = REV + experiment.diff (experiment only, never merged), Release, as compiler-exp.
set -uo pipefail
cd "$(dirname "$0")"; D=$PWD
export EXCLUSIVE_OWNER=claude-2924-frame EXCLUSIVE_TITLE="buster #2924/#2699: Tier 1 frame colorer twin" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2699
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
if [ ! -d exp ]; then git clone -q --shared ~/buster-fast-bench/2924-c-df-claude/c7gate/src exp || exit 1; fi
git -C exp fetch -q https://github.com/buster14a/buster main && git -C exp checkout -q --detach "$1" && git -C exp reset -q --hard && git -C exp apply "$D/experiment.diff" || { echo "patch failed"; exit 1; }
(cd exp && $L timeout -k 5 1500 env BUSTER_DEBUG_INFO=0 ./build.sh --config Release > "$D/logs/build-exp.log" 2>&1) || { echo "build failed"; exit 1; }
cp exp/build/compiler compiler-exp && sha256sum compiler-exp > logs/compiler-exp.sha256
echo setup-done
