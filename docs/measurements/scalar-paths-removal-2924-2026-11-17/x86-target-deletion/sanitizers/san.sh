#!/bin/sh
# sanitizer builds of the combo tree, and the two pieces' tests
cd /home/user/buster-combo
for s in address undefined memory; do
  BUSTER_SANITIZER=$s ./build.sh --config Release > /tmp/claude-0/-home-user-buster/091235aa-913c-5912-a1a0-e94a0a45a741/scratchpad/san-$s-build.log 2>&1 || { echo "$s build failed"; continue; }
  exe=$(sed -n 's/.*published as \(.*\)$/\1/p' /tmp/claude-0/-home-user-buster/091235aa-913c-5912-a1a0-e94a0a45a741/scratchpad/san-$s-build.log | tail -1)
  bin=$(ls -d build/cmake/*$s*/Release/compiler 2>/dev/null | head -1)
  echo "$s: exe=$exe bin=$bin"
  for t in test-x86-zen5 test-x86-target test-builtin-terminal-helpers test-tier1-select; do
    $bin $t > /tmp/claude-0/-home-user-buster/091235aa-913c-5912-a1a0-e94a0a45a741/scratchpad/san-$s-$t.log 2>&1; echo "$s $t rc=$?"
  done
done
