#!/bin/bash
# After chain.sh: piece (a)'s deletion run (its first launch died with its ssh session).
B=~/buster-fast-bench/2924-program
while pgrep -f "2924-program/chain.sh|chain.sh$" > /dev/null; do sleep 30; done
(cd $B/a && ./run.sh 0fd0634cb 74924852e all > run.out 2>&1)
