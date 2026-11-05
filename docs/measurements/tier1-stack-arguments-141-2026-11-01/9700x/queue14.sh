#!/usr/bin/env bash
# queue14.sh: after queue 13's campaign, #141's next pull request, the stack arguments 3146ff1, against #1086's head
# 9b9e43a (claude-141-rebased10.bundle): both builds, the stack arguments' suites (tests6.sh), the programs and #142's
# campaign at seeds 5100 to 5139. Then the stack's top 8ef99de (floating values, by-value aggregates, unsigned 64-bit
# conversions and the dynamic stack on 3146ff1): its build and the union of the suites (tests7.sh), to find its
# problems before its pull requests open. Queue 13's own last step (d61905f, the stack's older top) is superseded.
cd ~/buster-fast-bench/claude-141-remaining || exit 1
while pgrep -f "campaign.sh head-d5156c7" > /dev/null; do sleep 30; done
./tally.sh diff-head-d5156c7
for r in pr-1086:base-9b9e43a stack-1086~4:head-3146ff1 stack-1086:head-8ef99de; do
    ref=${r%%:*}
    tree=${r##*:}
    rm -rf $tree && mkdir -p $tree && git -C repo archive refs/remotes/rebased10/$ref | tar -x -C $tree || exit 1
done
./build.sh base-9b9e43a head-3146ff1 && ./tests6.sh head-3146ff1 && ./programs.sh base-9b9e43a head-3146ff1 && ./campaign.sh head-3146ff1 3146ff1 5100 5139
./build.sh head-8ef99de && ./tests7.sh head-8ef99de
echo queue-finished
