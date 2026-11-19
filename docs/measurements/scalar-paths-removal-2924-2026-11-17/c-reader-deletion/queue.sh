#!/bin/bash
# After the rebased batch: the sanitizers on head (vector host), then the open PRs merged onto head, built and tested.
Q=/root/.cache/claude-c7/c12c/queue
mkdir -p $Q; S=$Q/status.txt; : > $S
until grep -qx done /root/.cache/claude-c7/c12c/rebased/status.txt 2>/dev/null; do sleep 20; done
cd /home/user/buster-c12c || exit 1
HEAD_SHA=$(git rev-parse HEAD); echo "head $HEAD_SHA" >> $S
for san in memory address; do
    BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=$san ./build.sh > $Q/$san-build.log 2>&1; r=$?; echo "$san build: $r" >> $S
    [ $r = 0 ] || continue
    E=$Q/$san-compiler; cp build/cmake/vector-$san-O3/Develop/compiler $E 2>/dev/null || cp build/compiler $E
    for k in 1 2 3 4; do $E test-checker --part $k/4 > $Q/$san-checker-$k.log 2>&1 & done
    for j in $(jobs -p); do wait $j; done
    for k in 1 2 3 4; do echo "$san checker $k: $(grep -h ' failures$' $Q/$san-checker-$k.log | tail -1) $(grep -c -E 'ERROR: (Memory|Address|Undefined)|runtime error' $Q/$san-checker-$k.log) reports" >> $S; done
    $E test-checker-driver --executable $E --part 1/4 > $Q/$san-driver-1.log 2>&1; echo "$san driver 1: $? $(grep -c -E 'ERROR: (Memory|Address)|runtime error' $Q/$san-driver-1.log) reports" >> $S
done
./build.sh > $Q/native-rebuild.log 2>&1; echo "native rebuild: $?" >> $S
echo "sanitizers done" >> $S
# The open PRs merged onto head (built in the scratch worktree): the deletion before the unrecorded rule first, on
# main with #3003's fixtures, as the rule's control.
W=/root/.cache/claude-c7/c12c/mergecheck
cd $W || exit 1
run_parts() {
    for k in 1 2 3 4; do ./build/compiler test-checker --part $k/4 > $Q/$1-$k.log 2>&1 & done
    for j in $(jobs -p); do wait $j; done
    echo "$1: $(grep -h 'recorded digests' $Q/$1-*.log | awk '{a+=$6; b+=$11} END {print a " with a line, " b " without"}') $(grep -h ' failures$' $Q/$1-*.log | awk '{f+=$4} END {print f " failures"}')" >> $S
}
git checkout -q --detach $HEAD_SHA && ./build.sh > $Q/merge-build-head.log 2>&1; echo "build head: $?" >> $S
run_parts head
for n in 3010 3008 2896 2916 2920 2923 2993 2998 3002 3004 3005; do
    git checkout -q --detach $HEAD_SHA
    if ! git -c user.name=t -c user.email=t@t merge -q --no-edit --no-ff refs/remotes/pr/$n > /dev/null 2>&1; then git merge --abort; echo "pr $n: conflict" >> $S; continue; fi
    ./build.sh > $Q/merge-build-$n.log 2>&1 || { echo "pr $n: build failed" >> $S; continue; }
    run_parts pr-$n
done
git checkout -q --detach $HEAD_SHA
echo done >> $S
