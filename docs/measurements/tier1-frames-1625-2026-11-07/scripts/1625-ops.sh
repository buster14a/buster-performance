#!/bin/bash
# #1625: IBS op profiles counting dispatched ops (cnt_ctl=1, every 20,011th op, user mode) of main's Tier 1 and clang
# -O2 builds of speedtest1 and the five Lua scripts, pinned to CPU 2, one hold each: a uniform sample of the executed ops.
set -u
cd ~/buster-fast-bench/1623-claude
export EXCLUSIVE_OWNER=claude-1625 EXCLUSIVE_TITLE='Measure shrink-wrapping and shared call-save rows (#1625)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1625
X=~/buster-fast-bench/exclusive.sh
P=$(readlink -f $(ls -d programs/measure-tier1-programs-* | head -1))
scripts=$PWD/perf-repo/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua
mkdir -p ops
for build in tier1 clang2; do
    rm -rf $P/db-$build; mkdir -p $P/db-$build
    $X sh -c "cd $P/db-$build && SQLITE_TMPDIR=\$PWD taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/ -c 20011 -o ~/buster-fast-bench/1623-claude/ops/speedtest1-$build.data -- $P/speedtest1-$build --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 db > /dev/null" 2>> ops/errors.txt
    for s in calls tables strings arithmetic closures; do
        $X taskset -c 2 perf record -q -e ibs_op/cnt_ctl=1,swfilt=1/ -c 20011 -o ops/lua-$s-$build.data -- $P/lua-$build $scripts/$s.lua > /dev/null 2>> ops/errors.txt
    done
done
for b in tier1 clang2; do python3 analyze_saves.py $P/speedtest1-$b ops/speedtest1-$b.data; python3 analyze_saves.py $P/lua-$b ops/lua-*-$b.data; done > ops/saves.txt 2>&1
touch ops.done
