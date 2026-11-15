#!/bin/bash
# #2677's 9700X measurements: after the head's build, the kernels (11 rounds) and sqlite3.c's --tier1 -c (11 runs),
# each run under the lock on its own.
cd ~/buster-fast-bench/2677-claude || exit 1
while systemctl --user is-active -q claude-2677-build-head; do sleep 10; done
grep -q "build exit 0" head/build.log || { echo "head build failed"; exit 1; }
kernels/measure.sh "$PWD/main" "$PWD/head" 11 > kernels/measure.log 2>&1
compile/compile.sh 11 "main=$PWD/main" "head=$PWD/head" > compile/compile.log 2>&1
echo all done
