#!/bin/bash
# campaign.sh FIRST LAST: the fault campaign of the tests' own form after the sorting, on the build with every fault
# behind BUSTER_NODE_TESTS_FAULT (knobs2.py): for each fault N, the census's part of test-checker (the seven fixtures in
# both forms, the own form beside the census's code). A line a fault in out-FIRST.txt: the tests' failures and the
# fixtures that failed.
set -u
sort=/tmp/claude-0/-home-user/743aa3e7-1556-5d1b-ba6c-46b8ead1bd58/scratchpad/own/sort
dir=$sort/campaign
cd /home/user/buster-0003
names=$(python3 -I $sort/knobs2.py . list)
for n in $(seq $1 $2); do
    name=$(echo "$names" | sed -n "${n}p" | cut -f2)
    case "$name" in
        "(taken out"*) echo "fault $n $name" >> $dir/out-$1.txt; continue ;;
    esac
    BUSTER_NODE_TESTS_FAULT=$n ./build/compiler test-checker --seed 133 --part 5/8 > $dir/tests-$n.log 2> $dir/tests-$n.err
    failures=$(sed -n 's/^test-checker: [0-9]* checks, \([0-9]*\) failures/\1/p' $dir/tests-$n.log)
    which=$(grep -o "node-tests [a-z]*\.c" $dir/tests-$n.err | sort -u | sed 's/node-tests //' | tr '\n' ' ')
    echo "fault $n ($name): tests ${failures:-?} failures; ${which}" >> $dir/out-$1.txt
    rm -f $dir/tests-$n.log
done
echo "done $1 $2" >> $dir/out-$1.txt
