#!/bin/bash
set -eu
export EXCLUSIVE_OWNER=codex-489 EXCLUSIVE_TITLE='Buster #489 review regression coverage' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/625
D=$HOME/buster-fast-bench/codex-489-review
X=$HOME/buster-fast-bench/exclusive.sh
cd "$D"
mkdir -p review-logs tmp
export TMPDIR=$D/tmp
BUSTER_DEBUG_INFO=0 "$X" ./build.sh > review-logs/build.log 2>review-logs/build.stderr
"$X" taskset -c 0-7 ./build/compiler parallel --jobs 8 --timeout 180 review-tests.list > review-logs/tests.log 2>review-logs/tests.stderr
echo 'review validation done'
