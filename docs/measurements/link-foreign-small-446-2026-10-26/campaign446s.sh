#!/bin/bash
# campaign446s.sh FIRST LAST: rounds FIRST to LAST of sizes446.list, each round under its own hold of the shared lock
# (about 25 s: 12 commands of 21 links), 20 s apart, appended to results446s.tsv; outputs in out446s/.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/446
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
mkdir -p out446s
while pgrep -f "campaign446.sh 1 16" > /dev/null; do sleep 30; done
[ -s results446s.tsv ] || ./procbench --rounds 0 sizes446.list > results446s.tsv
for round in $(seq "$1" "$2"); do
    ~/buster-fast-bench/exclusive.sh ./procbench --first "$round" --rounds 1 --no-header --out out446s sizes446.list >> results446s.tsv 2>> campaign446s.err
    echo "round $round status $? $(date -Is)" >> campaign446s.log
    sleep 20
done
echo "done $(date -Is)" >> campaign446s.log
