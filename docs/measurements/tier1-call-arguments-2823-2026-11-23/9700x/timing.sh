#!/bin/bash
# timing.sh NAME: the timings of measure.sh, over the builds it made and checked in /tmp/claude-2823-NAME: each Lua script
# by base's and head's executables in three link orders, speedtest1, then each compiler's compile of speedtest1's unity
# and of lvm.c, each program in its own hold of the 9700X's lock, pinned to CPU 2. Results in results/NAME.
set -u
root=~/buster-fast-bench/2823-claude
cd "$root"
name=${1:?a name}
out=$root/results/$name
work=/tmp/claude-2823-$name
export LC_ALL=C
unset CPATH C_INCLUDE_PATH
export EXCLUSIVE_OWNER=claude-2823 EXCLUSIVE_TITLE="buster #2823: Tier 1 call arguments, timings" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3330
lock=~/buster-fast-bench/exclusive.sh
inputs=~/buster-fast-bench/138-tier1-quality-claude/inputs
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
sqlite_flags="-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I$sqlite -I$inputs"
st="--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1"
tool=$root/head/build/compiler
busy="cat /proc/loadavg >> $out/busy.txt; ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | head >> $out/busy.txt"
for script in arithmetic calls closures strings tables; do
    (cd "$inputs/scripts" && $lock bash -c "$busy; taskset -c 2 $tool time-runs --runs 11 --warmups 1 --build base $work/base/lua0 --build head $work/head/lua0 --build base $work/base/lua1 --build head $work/head/lua1 --build base $work/base/lua2 --build head $work/head/lua2 --list $script.lua; $busy") > "$out/time-$script.txt" 2>&1
done
(cd "$work" && $lock bash -c "$busy; taskset -c 2 $tool time-runs --runs 11 --warmups 1 --build base $work/base/speedtest1 --build head $work/head/speedtest1 --list $st $work/time.db; $busy") > "$out/time-speedtest1.txt" 2>&1
(cd "$work" && $lock bash -c "$busy; taskset -c 2 $tool time-runs --runs 11 --warmups 1 --build base $root/base/build/compiler --build head $root/head/build/compiler --list --tier1 -fno-asynchronous-unwind-tables $sqlite_flags -c $work/speedtest1-unity.c -o $work/compile.o; $busy") > "$out/compile-speedtest1.txt" 2>&1
(cd "$work" && $lock bash -c "$busy; taskset -c 2 $tool time-runs --runs 21 --warmups 1 --build base $root/base/build/compiler --build head $root/head/build/compiler --list --tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c $inputs/lua-5.4.8/src/lvm.c -o $work/compile-lvm.o; $busy") > "$out/compile-lvm.txt" 2>&1
echo done >> "$out/status.txt"
