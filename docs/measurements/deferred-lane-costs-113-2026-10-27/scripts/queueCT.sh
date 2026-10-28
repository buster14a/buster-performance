#!/bin/bash
# #113's lane costs, campaign B's c-testsuite sweep: the 220 programs of #145's subset (tests/c-testsuite/subset.txt),
# eight lanes against one by main's rule and by the branch's, each program and run in a process of its own (runs.sh),
# the runs' order alternating by program; a lock hold per 75 programs. Writes logCT.txt.
D=~/buster-fast-bench/deferred-113-lanes-claude
cd "$D" || exit 1
echo $$ > "$D/queueCT.pid"
export EXCLUSIVE_OWNER=claude-113-lanes
export EXCLUSIVE_TITLE="#113 deferred reader lane costs: c-testsuite, main's rule against the branch's"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/issues/113#issuecomment-6448574179"
L="$D/logCT.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
mapfile -t programs < <(grep -v '^#' "$D/final/tests/c-testsuite/subset.txt" | grep -v '^$')
count=${#programs[@]}
for ((i = 0; i < count; i += 75)); do
    ~/buster-fast-bench/exclusive.sh "$D/batchCT.sh" "$L" "$i" "${programs[@]:i:75}" > /dev/null 2>> "$D/queue.lock.txt"
    sleep 30
done
echo done >> "$L"
