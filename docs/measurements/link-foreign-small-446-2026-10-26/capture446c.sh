#!/bin/bash
# capture446c.sh: the objects of programs of 500 to 32,000 workers, for #446's sizes between 2,000 and 102,400:
# benchmark-link once per size by main's archived executable, its objects kept in links-N.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/446
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd ~/buster-fast-bench/build-270-claude/ab3/base
for n in 500 1000 4000 8000 16000 32000; do
    mkdir -p "$D/links-$n"
    ~/buster-fast-bench/exclusive.sh ./build/compiler benchmark-link --only linkers --linkers link-foreign --kinds dynamic \
        --functions "$n" --runs 1 --directory "$D/links-$n" --keep > "$D/links-$n/capture.log" 2>&1
    echo "$n status $? $(date -Is)" >> "$D/capture446c.log"
    sleep 10
done
echo "done $(date -Is)" >> "$D/capture446c.log"
