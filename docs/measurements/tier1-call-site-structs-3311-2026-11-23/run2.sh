#!/bin/bash
# Builds base (main) and fix Release, builds the kernels, times them: each step under the lock as a run of its own.
set -uo pipefail
D=/tmp/3311-claude; cd $D
export EXCLUSIVE_OWNER=claude-3311 EXCLUSIVE_TITLE="buster #3311: Tier 1 call-site structs" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3311
for t in base fix; do
  (cd $D/$t && ~/buster-fast-bench/exclusive.sh timeout -k 5 1800 ./build.sh --config Release > $D/build-$t.log 2>&1); echo "$t exit $?" >> $D/status
done
~/buster-fast-bench/exclusive.sh timeout -k 5 300 ./build-kernels.sh $D/base/build/compiler $D/fix/build/compiler > kernels-build.log 2>&1; echo "kernels exit $?" >> status
for k in i4 i2 l2; do
  ~/buster-fast-bench/exclusive.sh timeout -k 5 300 bash -c "cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; ./time.sh 11 bin/$k.clang-O0 bin/$k.clang-O2 bin/$k.base-tier0 bin/$k.base-tier1 bin/$k.fix-tier0 bin/$k.fix-tier1; cat /proc/loadavg" > times-$k.tsv 2> times-$k.err
  echo "$k exit $?" >> status
done
echo done >> status
