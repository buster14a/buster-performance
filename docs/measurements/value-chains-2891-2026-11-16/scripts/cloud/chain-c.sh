#!/bin/bash
# Chain C, after main 7910ff7b (#2892) merged into the branch: the head's build, test-checker whole, the shadow's twelve
# modes on the four inputs; main's build at 7910ff7b and its plain and own-tests modes, for the counts before.
S=/root/.cache/claude-2891
cd /home/user/buster
nice -n 5 ./build.sh --config Release > $S/logs/build-merged.log 2>&1; echo "exit $?" >> $S/logs/build-merged.log
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
export BUSTER_CORPUS=/home/user/buster/build/corpus
nice -n 5 ./build/compiler test-checker --seed 133 > $S/logs/merged-checker.log 2>&1; echo "status $?" >> $S/logs/merged-checker.log
bash $S/scripts/shadow-modes2.sh /home/user/buster/build/compiler /home/user/buster $S/shadow-merged
git -C /home/user/buster-main checkout -q --detach 7910ff7bc
(cd /home/user/buster-main && BUSTER_DEBUG_INFO=0 nice -n 5 ./build.sh --config Release > $S/logs/build-main2.log 2>&1; echo "exit $?" >> $S/logs/build-main2.log)
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > /home/user/buster-main/build/predefines.h
MODES="plain front-own-tests front-own-tests-wall" bash $S/scripts/shadow-modes2.sh /home/user/buster-main/build/compiler /home/user/buster-main $S/shadow-main2
echo chain-c done > $S/logs/chain-c.done
