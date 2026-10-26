#!/bin/bash
# phases446.sh: two rounds of phases446.list (main, main again and the head, 41 links each with --time after a warm-up),
# each under its own hold of the shared lock, appended to results446p.tsv; reports in out446p/.
set -u
D=~/buster-fast-bench/perf-445-446-claude
export EXCLUSIVE_OWNER=claude-445-446
export EXCLUSIVE_TITLE="Performance issues #490 #446 #445"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/446
export SOURCE_DATE_EPOCH=1792454400
unset CPATH C_INCLUDE_PATH
cd "$D"
mkdir -p out446p
[ -s results446p.tsv ] || ./procbench --rounds 0 phases446.list > results446p.tsv
for round in 1 2; do
    ~/buster-fast-bench/exclusive.sh ./procbench --first "$round" --rounds 1 --no-header --out out446p phases446.list >> results446p.tsv 2>> phases446.err
    echo "round $round status $? $(date -Is)" >> phases446.log
    sleep 20
done
echo "done $(date -Is)" >> phases446.log
