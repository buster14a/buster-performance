#!/bin/bash
# #2531 step 4 at s4c (the one-file memo's diagnostics fix and index table): build, warm, compare, 5 rounds.
cd ~/buster-fast-bench/2531-step3c-claude
x()
{
    EXCLUSIVE_OWNER=claude-2531-step3c EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 "$@"
    echo "status $? $*"
}
x ./build.sh s4c
x ./run4.sh warm s4c
x ./run4.sh ppucompare s4c
for r in 1 2 3 4 5; do
    x ./run4.sh ppu $r s4c none memo
    x ./run4.sh sqlite $r s4c none memo
done
x ./run7.sh faultprof s4c none memo
echo "queue11 done"
