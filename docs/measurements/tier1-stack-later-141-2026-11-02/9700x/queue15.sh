#!/usr/bin/env bash
# queue15.sh: after queue 14, #141's later pull requests, each commit of claude-141-rebased10.bundle's stack-1086
# against the commit before it: floating values 14801fa on the stack arguments 3146ff1, by-value aggregates' ABI
# records 6d1f101 on 14801fa, unsigned 64-bit conversions 4143ea7 on 6d1f101, and the dynamic stack 8ef99de on 4143ea7.
# Each pair: the head's build (the base is built already), the union of the suites (tests7.sh), the programs and #142's
# campaign at seeds of its own.
cd ~/buster-fast-bench/claude-141-remaining || exit 1
until grep -q queue-finished queue-14.log; do sleep 60; done
for r in stack-1086~3:head-14801fa stack-1086~2:head-6d1f101 stack-1086~1:head-4143ea7; do
    ref=${r%%:*}
    tree=${r##*:}
    rm -rf $tree && mkdir -p $tree && git -C repo archive refs/remotes/rebased10/$ref | tar -x -C $tree || exit 1
done
for p in 3146ff1:14801fa:5200 14801fa:6d1f101:5300 6d1f101:4143ea7:5400 4143ea7:8ef99de:5500; do
    base=head-${p%%:*}
    rest=${p#*:}
    head=head-${rest%%:*}
    first=${rest#*:}
    if [ ! -x $head/build/compiler ]; then ./build.sh $head || continue; fi
    ./tests7.sh $head && ./programs.sh $base $head && ./campaign.sh $head ${head#head-} $first $((first + 39)) && ./tally.sh diff-$head > diff-$head/campaign.tsv
done
echo queue-finished
