#!/bin/bash
# Runs the native suites one after another from the repository root; each one's log in $S/native-NAME.log and its
# status and time in $S/logs/native-summary.txt.
S=/root/.cache/claude-2891
cd /home/user/buster
export BUSTER_CORPUS=/home/user/buster/build/corpus BUSTER_COMPILER=/home/user/buster/build/compiler
run() { local name=$1; shift; local start=$(date +%s); "$@" > "$S/logs/native-$name.log" 2>&1; local status=$?; echo "$name status $status $(( $(date +%s) - start )) s" >> "$S/logs/native-summary.txt"; }
: > "$S/logs/native-summary.txt"
run cts nice -n 5 ./build/compiler test-c-testsuite --cross-check --clang clang --jobs 2 --subset tests/c-testsuite/subset.txt build/c-testsuite
run checker nice -n 5 ./build/compiler test-checker --seed 133
run cts-tier1 nice -n 5 ./build/compiler test-c-testsuite --tier1 --code-size --clang clang --jobs 2 --subset tests/c-testsuite/subset.txt build/c-testsuite
run templates-sqlite nice -n 5 ./build/compiler test-lowering-templates -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I build/corpus/sqlite build/corpus/sqlite/sqlite3.c
run templates-lua nice -n 5 bash -c './build/compiler test-lowering-templates '"$S"'/inputs/lua-5.4.8/src/*.c'
run templates-cts nice -n 5 bash -c './build/compiler test-lowering-templates $(sed -n "s|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p" tests/c-testsuite/subset.txt)'
echo done >> "$S/logs/native-summary.txt"
