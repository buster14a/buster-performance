#!/bin/sh
# sanitizer builds of piece (c)'s head and the area's tests
B=/tmp/claude-0/-home-user-buster/091235aa-913c-5912-a1a0-e94a0a45a741/scratchpad
cd /home/user/buster-sem
for s in address undefined memory; do
  BUSTER_SANITIZER=$s ./build.sh --config Release > $B/sansem-$s-build.log 2>&1 || { echo "$s build failed"; continue; }
  bin=$(ls -d build/cmake/*$s*/Release/compiler | head -1)
  for t in test-x86-semantics test-tier1-schedule test-tier1-emit test-tier1-pipeline test-emitted-code test-check-debug test-tier0 test-unwind; do
    $bin $t > $B/sansem-$s-$t.log 2>&1; echo "$s $t rc=$?"
  done
done
