#!/bin/bash
set -u
export EXCLUSIVE_OWNER=claude-c7 EXCLUSIVE_TITLE="C7: #2228 prefilter base/head builds" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2228
cd ~/buster-fast-bench/1953-c7
for d in base:7be0864f head:204f4e9c; do
  dir=${d%%:*}; rev=${d#*:}
  git -C $dir fetch -q origin main checker/1953-unsequenced-conditional && git -C $dir checkout -q $rev || { echo "checkout $dir failed" >> run2.log; exit 1; }
  (cd $dir && BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh) >> run2.log 2>&1 || { echo "build $dir failed" >> run2.log; exit 1; }
done
mv times.txt times-v2.txt 2>/dev/null
bash time.sh 1953-c7
