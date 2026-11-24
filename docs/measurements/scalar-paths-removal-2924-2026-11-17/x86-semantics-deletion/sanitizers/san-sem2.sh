#!/bin/sh
B=/tmp/claude-0/-home-user-buster/091235aa-913c-5912-a1a0-e94a0a45a741/scratchpad
cd /home/user/buster-sem
BUSTER_SANITIZER=memory ./build.sh --config Release > $B/sansem2-build.log 2>&1 || { echo "build failed"; exit 1; }
bin=$(ls -d build/cmake/*memory*/Release/compiler | head -1)
for t in test-x86-semantics test-tier1-schedule test-tier1-emit test-tier1-pipeline test-emitted-code test-check-debug test-tier0 test-unwind test-tier1-cfg; do
  $bin $t > $B/sansem2-$t.log 2>&1; echo "memory $t rc=$?"
done
