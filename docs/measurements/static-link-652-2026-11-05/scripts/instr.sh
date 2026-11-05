#!/bin/sh
# Where the static head's extra user instructions come from: the same two executables timed with 2 builds, then with
# the A/B's 12 executables and 2 copies; and perf stat's count of each.
cd ~/buster-fast-bench/652-claude-5
export EXCLUSIVE_OWNER=claude-652 EXCLUSIVE_TITLE="652 remaining work" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1431
H=shifts-main/compiler-0
{
echo "== two builds"
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 3 --warmups 1 --build main shifts-main/compiler-0 --build head shifts-s2/compiler-0 --list -fsyntax-only empty.c 2>&1 | grep "^run [23] "
echo "== two builds, 2 copies"
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 3 --warmups 1 --copies 2 --build main shifts-main/compiler-0 --build head shifts-s2/compiler-0 --list -fsyntax-only empty.c 2>&1 | grep "^run [23] "
echo "== three lists"
~/buster-fast-bench/exclusive.sh taskset -c 2 $H time-runs --runs 3 --warmups 1 --build main shifts-main/compiler-0 --build head shifts-s2/compiler-0 --list -fsyntax-only empty.c --list -E -P empty.c -o /dev/null --list -c tiny.c -o /dev/null 2>&1 | grep "^run [23] "
echo "== perf stat"
~/buster-fast-bench/exclusive.sh sh -c 'for b in shifts-main/compiler-0 shifts-s2/compiler-0; do taskset -c 2 perf stat -r 50 -e instructions:u,cycles:u,instructions:k $b -fsyntax-only empty.c 2>&1 | grep -E "instructions|cycles"; done'
} > instr.txt 2>&1
echo done >> instr.txt
