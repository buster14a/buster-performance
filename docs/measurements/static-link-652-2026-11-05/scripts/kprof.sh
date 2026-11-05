#!/bin/sh
# Where an empty file's -fsyntax-only spends its cycles, user and kernel, by the static head (shifts-s3/compiler-0): 300
# processes, sampled every 20,000 cycles; the shell's own samples are left out by --comm.
cd ~/buster-fast-bench/652-claude-5
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/652
C=$PWD/shifts-s3/compiler-0
~/buster-fast-bench/exclusive.sh sh -c "taskset -c 2 perf record -q -e cycles -c 20000 -o kprof.data -- sh -c 'for i in \$(seq 300); do $C -fsyntax-only empty.c; done' > /dev/null 2>&1"
echo "-- by symbol"
perf report -i kprof.data --stdio --comm compiler-0 --sort sym --percent-limit 0.4 2>/dev/null | grep -v "^#" | grep -v "^$" | head -70
echo "-- by kernel call chain's syscall or fault"
perf report -i kprof.data --stdio --comm compiler-0 --sort dso 2>/dev/null | grep -v "^#" | grep -v "^$" | head
echo done
