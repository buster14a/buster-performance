#!/bin/bash
# #88's validation and measurements on the 9700X, on tree88 (the DWARF in units as it compiles): each step its own lock acquisition.
base=~/buster-fast-bench/claude-linker-80
log=$base/logs88c; mkdir -p $log
# (after phase87, whose runs it interleaves with)
cd $base/tree88 || exit 1
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/88
L=~/buster-fast-bench/exclusive.sh
echo "build start $(date -Is)" > $log/status
EXCLUSIVE_TITLE="Issue 88: streaming build" $L ./build.sh > $log/build.log 2>&1; echo "build=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="Issue 88: test-debug with gdb and perf" $L ./build/compiler test-debug --cross-check > $log/test-debug.log 2>&1; echo "test-debug=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="Issue 88: test-streaming with llvm-dwarfdump, gdb and perf" $L ./build/compiler test-streaming --cross-check > $log/test.log 2>&1; echo "test=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="Issue 88: streaming benchmark, one lane, callees first" $L taskset -c 2 ./build/compiler benchmark-streaming --units 3200 --runs 11 --lanes 8 > $log/bench-1-callees.log 2>&1; echo "bench1=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="Issue 88: streaming benchmark, writer lane" $L taskset -c 2,3 ./build/compiler benchmark-streaming --units 3200 --runs 11 --lanes 8 --cpus 2,3 > $log/bench-2-callees.log 2>&1; echo "bench2=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="Issue 88: streaming benchmark, callers first" $L taskset -c 2 ./build/compiler benchmark-streaming --units 3200 --runs 11 --lanes 8 --order callers > $log/bench-1-callers.log 2>&1; echo "bench3=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="Issue 88: streaming benchmark, all CPUs" $L taskset -c 0-7 ./build/compiler benchmark-streaming --units 3200 --runs 11 --lanes 8 --cpus 2,3 > $log/bench-8.log 2>&1; echo "bench4=$? $(date -Is)" >> $log/status
echo "done $(date -Is)" >> $log/status
