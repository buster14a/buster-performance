#!/bin/bash
# Chain A: the native suites, the shadow's modes by the head, then main's build and its shadow counts.
S=/root/.cache/claude-2891
bash $S/scripts/run-native.sh
bash $S/scripts/shadow-modes2.sh /home/user/buster/build/compiler /home/user/buster $S/shadow-head
(cd /home/user/buster-main && BUSTER_DEBUG_INFO=0 nice -n 5 ./build.sh --config Release > $S/logs/build-main.log 2>&1; echo "exit $?" >> $S/logs/build-main.log)
clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > /home/user/buster-main/build/predefines.h
cp /home/user/buster-main/build/compiler $S/compiler-main
bash $S/scripts/shadow-modes2.sh $S/compiler-main /home/user/buster-main $S/shadow-main
echo chain-a done > $S/logs/chain-a.done
