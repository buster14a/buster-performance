#!/usr/bin/env bash
# queue13.sh: after queue 11, #141's stack rebased onto main 13b7d81 (claude-141-rebased4.bundle). First its next pull
# request, the narrow arguments b068dcc with the selection guide's line d5156c7, against main 13b7d81: both builds, the
# narrow arguments' suites (tests5.sh), the programs and #142's campaign at seeds 5000 to 5039. Then the stack's top
# d61905f (stack arguments, floating values, by-value aggregates and unsigned 64-bit conversions on d5156c7): its build
# and the union of the suites (tests7.sh), to find its problems before its pull requests open.
cd ~/buster-fast-bench/claude-141-remaining || exit 1
until grep -q queue-finished queue-11.log; do sleep 60; done
for r in main-13b7d81:base-13b7d81 claude/exciting-pascal-9qb5m7:head-d5156c7 stack-main:head-d61905f; do
    ref=${r%%:*}
    tree=${r##*:}
    rm -rf $tree && mkdir -p $tree && git -C repo archive refs/remotes/rebased4/$ref | tar -x -C $tree || exit 1
done
./build.sh base-13b7d81 head-d5156c7 && ./tests5.sh head-d5156c7 && ./programs.sh base-13b7d81 head-d5156c7 && ./campaign.sh head-d5156c7 d5156c7 5000 5039
./build.sh head-d61905f && ./tests7.sh head-d61905f
echo queue-finished
