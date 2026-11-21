#!/bin/bash
# Usage: fcmp.sh BASE NEW: frames.c under each option set, by both binaries; DIFF lines name the options that differ.
set -u
BASE=$1; NEW=$2
S=/tmp/claude-0/-home-user/da9b228d-448f-5dff-bcec-738df11c230d/scratchpad
D=$(mktemp -d -p $S/piece2)
cd $D
same=0; diff=0
for o in "" "-fstack-clash-protection" "-g" "--verify" "--verify -fstack-clash-protection" "-fno-omit-frame-pointer" "-fpatchable-function-entry=3,1" "-O2" "-O2 -g" "-fpatchable-function-entry=5 -g"; do
    $BASE -c -march=znver5 $o -o b.o $S/piece2/probe/frames.c 2> b.err; be=$?
    $NEW -c -march=znver5 $o -o n.o $S/piece2/probe/frames.c 2> n.err; ne=$?
    if [ $be = $ne ] && cmp -s b.err n.err && cmp -s b.o n.o; then same=$((same+1)); else diff=$((diff+1)); echo "DIFF [$o] exits $be $ne"; fi
    rm -f b.o n.o
done
echo "frames.c: same $same diff $diff"
cd $S/piece2; rm -rf $D
