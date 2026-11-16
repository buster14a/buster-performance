#!/bin/bash
# Builds the x86-64 baseline of the branch after the native inventory, then runs its suites.
S=/tmp/claude-0/-home-user-buster/c45a68bf-d025-5d42-ba16-5bb54ca5630c/scratchpad
until grep -q "^exit" $S/inventory-native.log 2>/dev/null; do sleep 30; done
cd /home/user/buster-x86
BUSTER_HOST_ARCH=x86-64 nice -n 5 ./build.sh --config Release > $S/build-x86.log 2>&1; echo "exit $?" >> $S/build-x86.log
export BUSTER_CORPUS=/home/user/buster/build/corpus BUSTER_COMPILER=/home/user/buster-x86/build/compiler
ln -sfn /home/user/buster/build/c-testsuite build/c-testsuite; ln -sfn /home/user/buster/build/sqlite build/sqlite
: > $S/x86-summary.txt
run() { local name=$1; shift; "$@" > "$S/x86-$name.log" 2>&1; echo "$name status $?" >> "$S/x86-summary.txt"; }
run checker nice -n 5 ./build/compiler test-checker --seed 133
run cts nice -n 5 ./build/compiler test-c-testsuite --cross-check --clang clang --jobs 2 --subset tests/c-testsuite/subset.txt build/c-testsuite
run cts-tier1 nice -n 5 ./build/compiler test-c-testsuite --tier1 --clang clang --jobs 2 --subset tests/c-testsuite/subset.txt build/c-testsuite
run tier0 nice -n 5 ./build/compiler test-tier0 --cross-check
echo done >> $S/x86-summary.txt
