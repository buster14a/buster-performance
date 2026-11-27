#!/bin/bash
# bp-san.sh SANITIZER: the san/ tree's sanitizer build (one hold), then test-direct, the probes and the differential (one hold each)
cd ~/buster-fast-bench/3577-claude-splice/san
export EXCLUSIVE_OWNER=claude-session_01TiDLntzjiBRBBPKQphvMQe
export EXCLUSIVE_TITLE="Fix spliced-line conditionals in direct-path skip (#3577 follow-up)"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3577
s=$1
~/buster-fast-bench/exclusive.sh timeout 1500 env BUSTER_SANITIZER=$s BUSTER_HOST_ARCH=znver5 ./build.sh --config Release > ../logs/san-$s-build.log 2>&1
echo "build exit $?"; tail -1 ../logs/san-$s-build.log
exe=$(BUSTER_SANITIZER=$s BUSTER_HOST_ARCH=znver5 ./build.sh print-output --config Release)
~/buster-fast-bench/exclusive.sh timeout 600 $exe test-direct > ../logs/san-$s-test-direct.log 2>&1; echo "test-direct exit $?"; tail -2 ../logs/san-$s-test-direct.log
~/buster-fast-bench/exclusive.sh timeout 900 $exe test-direct --differential --jobs 8 --direct-floor 260 tests > ../logs/san-$s-differential.log 2>&1; echo "differential exit $?"; tail -2 ../logs/san-$s-differential.log
