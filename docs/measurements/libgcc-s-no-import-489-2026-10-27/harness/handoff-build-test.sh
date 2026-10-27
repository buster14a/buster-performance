#!/bin/bash
set -eu
export EXCLUSIVE_OWNER=codex-489 EXCLUSIVE_TITLE='Buster #489 validation' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/489
D=$HOME/buster-fast-bench/codex-489-handoff
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D"
mkdir -p final-logs tmp
export TMPDIR=$D/tmp
BUSTER_DEBUG_INFO=0 "$X" ./build.sh > final-logs/build.log 2>final-logs/build.stderr
"$X" taskset -c 0-7 ./build/compiler parallel --jobs 8 --timeout 180 handoff-tests.list > final-logs/tests.log 2>final-logs/tests.stderr
echo 'final validation done'
