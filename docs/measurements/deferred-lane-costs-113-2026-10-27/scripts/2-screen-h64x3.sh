#!/bin/bash
# The largest-body part fix on h64x3.c, the one input whose part order it changes: merge2 (06bda16, before) against
# merge3 (a36179a, after), by the rule on 8 lanes and on every lane of 2, 3, 4 and 8, each run a process of its own
# (runs.sh), ROUNDS rounds of one lock hold each, the runs' order rotating by round (batch.sh), into logH.txt.
D=~/buster-fast-bench/113-lanes-cloud
rounds="${1:-5}"
export EXCLUSIVE_OWNER=claude-113-cloud
export EXCLUSIVE_TITLE="#113 deferred reader lane costs (cloud session): h64x3 screen of the largest-body part fix"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/683"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
for ((r = 1; r <= rounds; r += 1)); do
    ~/buster-fast-bench/exclusive.sh "$D/batch.sh" "$D/logH.txt" "$r" "$D/jobsH.txt" 0 1 >> "$D/logH.txt" 2>&1
    echo "round $r done $(date -Is)" >> "$D/logH.txt"
done
echo "done $(date -Is)" >> "$D/logH.txt"
