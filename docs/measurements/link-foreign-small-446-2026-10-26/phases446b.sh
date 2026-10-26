#!/bin/bash
# phases446b.sh FIRST LAST: rounds FIRST to LAST of phases446.list after phases446.sh's two, so that each of main, the
# head and main again runs in each place of the rotated order equally (rounds 1 to 12: four times each), each round
# under its own hold of the shared lock, appended to results446p.tsv; reports in out446p/.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/446
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
while pgrep -f "phases446.sh" > /dev/null; do sleep 10; done
for round in $(seq "$1" "$2"); do
    ~/buster-fast-bench/exclusive.sh ./procbench --first "$round" --rounds 1 --no-header --out out446p phases446.list >> results446p.tsv 2>> phases446.err
    echo "round $round status $? $(date -Is)" >> phases446.log
    sleep 20
done
echo "done $(date -Is)" >> phases446.log
