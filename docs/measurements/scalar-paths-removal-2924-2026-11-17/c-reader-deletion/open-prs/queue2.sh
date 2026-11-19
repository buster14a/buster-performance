#!/bin/bash
# The open PRs the first queue didn't reach, merged onto #3047's head 47cbcd24a in the scratch worktree, built and run
# through test-checker's four parts.
Q=/root/.cache/claude-c7/c12c/queue; S=$Q/status2.txt; : > $S
H=47cbcd24aeed2a7de675efd4311bf086fd4a4d1a
cd /root/.cache/claude-c7/c12c/mergecheck || exit 1
git merge --abort 2>/dev/null
for n in 2920 2923 2993 2998 3002 3004 3005; do
    git checkout -q -f --detach $H
    if ! git -c user.name=t -c user.email=t@t merge -q --no-edit --no-ff refs/remotes/pr/$n > /dev/null 2>&1; then git merge --abort; echo "pr $n: conflict" >> $S; continue; fi
    ./build.sh > $Q/merge2-build-$n.log 2>&1 || { echo "pr $n: build failed" >> $S; continue; }
    for k in 1 2 3 4; do timeout -k 5 1500 ./build/compiler test-checker --part $k/4 > $Q/pr2-$n-$k.log 2>&1 & done
    for j in $(jobs -p); do wait $j; done
    echo "pr $n: $(grep -h 'recorded digests' $Q/pr2-$n-*.log | awk '{a+=$6; b+=$11} END {print a " with a line, " b " without"}'), $(grep -h ' failures$' $Q/pr2-$n-*.log | awk '{f+=$4} END {print f " failures"}')" >> $S
done
git checkout -q -f --detach $H
echo done >> $S
