#!/bin/bash
# driver445.sh: #445's driver sweep (driver445-0.list and driver445-1.list, 192 processes of about 0.15 s each), each list
# under its own hold of the shared lock, 20 s apart, appended to results445d.tsv.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/445
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
mkdir -p out445d
[ -s results445d.tsv ] || ./procbench --rounds 0 driver445-0.list > results445d.tsv
for part in 0 1; do
    ~/buster-fast-bench/exclusive.sh ./procbench --first 1 --rounds 1 --no-header --out out445d "driver445-$part.list" >> results445d.tsv 2>> driver445.err
    echo "part $part status $? $(date -Is)" >> driver445.log
    sleep 20
done
echo "done $(date -Is)" >> driver445.log
