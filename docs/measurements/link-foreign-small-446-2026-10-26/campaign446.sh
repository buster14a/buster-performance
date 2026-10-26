#!/bin/bash
# campaign446.sh FIRST LAST: rounds FIRST to LAST of links446.list, each round under its own hold of the shared lock
# (about 35 s: 17 commands, 41 or 11 links each), 20 s apart, appended to results446.tsv; outputs in out446/.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/446
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
mkdir -p out446
[ -s results446.tsv ] || ./procbench --rounds 0 links446.list > results446.tsv
for round in $(seq "$1" "$2"); do
    ~/buster-fast-bench/exclusive.sh ./procbench --first "$round" --rounds 1 --no-header --out out446 links446.list >> results446.tsv 2>> campaign446.err
    echo "round $round status $? $(date -Is)" >> campaign446.log
    sleep 20
done
echo "done $(date -Is)" >> campaign446.log
