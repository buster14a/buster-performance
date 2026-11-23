#!/bin/bash
# Round 2 of PR #3332 on the 9700X: main 1b9821a (base) vs the lazy backward order (lazy, 9a63d70), Release, each
# relinked at four placements of main.c's code (./build.sh shifts), time-runs over the placements. One hold per run.
D=~/buster-fast-bench/3332-claude
cd $D
export EXCLUSIVE_OWNER=claude-3332 EXCLUSIVE_TITLE="PR 3332 merge-ready (liveness loop nests, #2995)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3332
X=~/buster-fast-bench/exclusive.sh
R=results2
mkdir -p $R
SHIFTS="0 1024 2048 3072"
if [ ! -d lazy ]; then git clone -q https://github.com/buster14a/buster lazy; fi
git -C lazy fetch -q origin claude/2995-liveness-loop-nest && git -C lazy checkout -q FETCH_HEAD
git -C lazy log --oneline -1 > $R/lazy-commit.txt
git -C base log --oneline -1 > $R/base-commit.txt
for t in base lazy; do
  (cd $D/$t && $X bash -c "cat /proc/loadavg; BUSTER_DEBUG_INFO=0 ./build.sh shifts --config Release $D/shifts-$t main.c $SHIFTS") > $R/shifts-$t.log 2>&1
  echo "$t shifts rc=$?" >> $R/status.txt
done
ARGS=""
for s in $SHIFTS; do ARGS="$ARGS --build base $D/shifts-base/compiler-$s --build lazy $D/shifts-lazy/compiler-$s"; done
LUA=$(ls $D/inputs/lua-5.4.8/src/*.c | tr '\n' ' ')
$X bash -c "cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; mkdir -p /dev/shm/claude-3332-lua && cd /dev/shm/claude-3332-lua && taskset -c 2 $D/shifts-lazy/compiler-0 time-runs --runs 7 --warmups 1 $ARGS --list -w --tier1 -c $D/inputs/sqlite/sqlite3.c -o /dev/shm/claude-3332-sqlite3.o --list -w --tier1 -c $LUA; cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6" > $R/time-runs.txt 2>&1
for f in loop-1000 loop-4000 loop-8000 ptr-4000 brk-4000; do
  $X bash -c "cat /proc/loadavg; for i in 1 2 3; do TIMEFORMAT=%R; { time taskset -c 2 timeout -k 5 150 $D/shifts-lazy/compiler-0 -w --tier1 -c nests/$f.c -o /dev/shm/claude-3332-n.o > /dev/null 2>&1; echo rc=\$?; } 2>&1 | tr '\n' ' '; echo; done; cat /proc/loadavg" > $R/nest-lazy-$f.txt 2>&1
done
for i in 1 2 3; do for t in base lazy; do
  $X bash -c "cat /proc/loadavg; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head -6; taskset -c 2 $D/shifts-$t/compiler-0 benchmark-dataflow; echo rc=\$?; cat /proc/loadavg" > $R/benchmark-dataflow-$t-$i.txt 2>&1
done; done
rm -rf /dev/shm/claude-3332-*
echo done > $R/DONE
