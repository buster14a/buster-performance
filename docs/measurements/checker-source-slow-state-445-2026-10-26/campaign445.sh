#!/bin/bash
# campaign445.sh FIRST LAST: rounds FIRST to LAST of checker445.list, each round under its own hold of the shared lock
# (about 15 s: four processes of about 3.5 s), 20 s apart, appended to results445.tsv; outputs in out445/.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/445
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
mkdir -p out445
[ -s results445.tsv ] || ./procbench --rounds 0 checker445.list > results445.tsv
for round in $(seq "$1" "$2"); do
    ~/buster-fast-bench/exclusive.sh ./procbench --first "$round" --rounds 1 --no-header --out out445 checker445.list >> results445.tsv 2>> campaign445.err
    echo "round $round status $? $(date -Is)" >> campaign445.log
    sleep 20
done
echo "done $(date -Is)" >> campaign445.log
