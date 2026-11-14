#!/bin/bash
# The rest of queue7 (step 4's s4b rounds 3-5) and queue8 (main 74d23965d against #2726's head), each line a hold of the lock.
cd ~/buster-fast-bench/2531-step3c-claude
x()
{
    EXCLUSIVE_OWNER=claude-2531-step3c EXCLUSIVE_TITLE='Problem 2531' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2531 ~/buster-fast-bench/exclusive.sh timeout 900 "$@"
    echo "status $? $*"
}
x ./run4.sh sqlite 3 s4b none memo
for r in 4 5; do x ./run4.sh ppu $r s4b none memo; x ./run4.sh sqlite $r s4b none memo; done
x ./build.sh main2
x ./build.sh f
x ./run6.sh batch "compare musl 1 on" "compare glibc 1 on" "compare musl 8 on"
for r in 11 12 13 14 15; do x ./run.sh batch "time musl 1 $r main2:off main2 f" "time glibc 1 $r main2:off main2 f"; done
for r in 11 12 13; do x ./run.sh batch "time musl 8 $r main2 f" "time glibc 8 $r main2 f"; done
echo "queue9 done"
