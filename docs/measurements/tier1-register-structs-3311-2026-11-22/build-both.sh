#!/bin/bash
# Builds base and fix Release, each under the lock as a run of its own.
set -uo pipefail
D=~/buster-fast-bench/3311-claude
export EXCLUSIVE_OWNER=claude-3311 EXCLUSIVE_TITLE="buster #3311: Tier 1 register-passed structs" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3311
for t in base fix; do
  cd $D/$t && ~/buster-fast-bench/exclusive.sh timeout -k 5 1800 ./build.sh --config Release > $D/build-$t.log 2>&1; echo "$t exit $?" >> $D/build.status
done
echo done >> $D/build.status
