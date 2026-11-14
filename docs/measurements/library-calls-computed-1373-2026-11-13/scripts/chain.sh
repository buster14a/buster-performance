#!/bin/bash
# #1373: builds, kernels, rounds and the compile A/B in turn, each lock hold its own.
cd ~/buster-fast-bench/1373-claude
export EXCLUSIVE_OWNER=claude-1373 EXCLUSIVE_TITLE="claude #1373 library calls computed inline A/B" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1373
BASE=b7a95eedbe16fbd8434654f192f8f7aab76c56e5 HEAD=8fad19cdf5f0232d3a3255f60095184401e968b2 bash scripts/build-trees.sh > build-trees.log 2>&1 || exit 1
~/buster-fast-bench/exclusive.sh bash scripts/prepare.sh > prepare.log 2>&1 || exit 1
bash scripts/measure.sh > measure.log 2>&1
bash scripts/compile.sh > compile.log 2>&1
echo chain done
