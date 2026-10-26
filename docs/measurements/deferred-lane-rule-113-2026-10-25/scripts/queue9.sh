#!/bin/bash
# #448's review: what a lane costs again, with the wake-up timed alone and lane_run's dispatch apart (timed: b412aa53),
# beside balanced's figure (8c538df3: the first lane's time in lane_parts_by_cost). The build and the deferred reader's
# tests, then three rounds of six units on 2 and 8 lanes, every lane the bodies can take, each unit and run in a
# process of its own (runs.sh); a lock hold covers one step or one round (about 40 s).
D=~/buster-fast-bench/deferred-lanes-claude
cd "$D" || exit 1
export EXCLUSIVE_OWNER=claude-deferred-lanes
export EXCLUSIVE_TITLE="#113 deferred lanes: #448's review, the wake-up timed alone"
export EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/448"
L="$D/log9.txt"
: > "$L"
unset CPATH C_INCLUDE_PATH
export SOURCE_DATE_EPOCH=1792454400
~/buster-fast-bench/exclusive.sh "$D/step9.sh" "$L" build > /dev/null 2>> "$D/queue9.lock.txt"
~/buster-fast-bench/exclusive.sh "$D/step9.sh" "$L" test > /dev/null 2>> "$D/queue9.lock.txt"
for round in 1 2 3; do
    ~/buster-fast-bench/exclusive.sh "$D/round9.sh" "$L" "$round" > /dev/null 2>> "$D/queue9.lock.txt"
    sleep 30
done
echo done >> "$L"
