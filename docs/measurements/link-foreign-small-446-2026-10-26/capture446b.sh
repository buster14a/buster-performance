#!/bin/bash
# capture446b.sh: the 2,000-worker program's objects, which capture446.sh's run wrote over with the 102,400-worker
# program's (both are written to one directory): benchmark-link once more for 2,000 workers alone, kept.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/446
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
mkdir -p "$D/links2000"
cd ~/buster-fast-bench/build-270-claude/ab3/base
~/buster-fast-bench/exclusive.sh ./build/compiler benchmark-link --only linkers --linkers link-foreign --kinds dynamic,static \
    --functions 2000 --runs 1 --directory "$D/links2000" --keep > "$D/links2000/capture.log" 2>&1
echo "status $?" >> "$D/links2000/capture.log"
echo "done $(date -Is)" >> "$D/links2000/capture.log"
