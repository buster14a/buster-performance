#!/bin/bash
# #2531 step 4 at s4d (the one-file view threshold): build, warm, compare, 5 rounds; and the main2/f comparison batch again.
cd ~/buster-fast-bench/2531-step3c-claude
x()
{
    EXCLUSIVE_OWNER=claude-2531-step3c EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 "$@"
    echo "status $? $*"
}
x ./run6.sh batch "compare musl 1 on" "compare glibc 1 on" "compare musl 8 on"
x ./build.sh s4d
x ./run4.sh warm s4d
x ./run4.sh ppucompare s4d
for r in 1 2 3 4 5; do
    x ./run4.sh ppu $r s4d none memo
    x ./run4.sh sqlite $r s4d none memo
done
x ./run8.sh sqliteprof s4d none memo
echo "queue13 done"
