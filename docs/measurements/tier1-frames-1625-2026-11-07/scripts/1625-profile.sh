#!/bin/bash
# #1625 on the 9700X: main's (cf38957a) builds of speedtest1 and Lua by measure-tier1-programs (one run, kept), then
# an IBS op profile (user mode, every 20,011th op) of the Tier 1 and clang -O2 executables, pinned to CPU 2: speedtest1
# with #136's options and each of the five Lua scripts. Every build, run and profile is one hold of the lock.
set -u
cd ~/buster-fast-bench/1623-claude
export EXCLUSIVE_OWNER=claude-1625 EXCLUSIVE_TITLE='Measure shrink-wrapping and shared call-save rows (#1625)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1625
unset CPATH C_INCLUDE_PATH
X=~/buster-fast-bench/exclusive.sh
sqlite=/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite
mkdir -p inputs programs profiles
cp ~/buster-fast-bench/speedtest1-136-claude/src/speedtest1.c inputs/
[ -d inputs/lua-5.4.8 ] || tar -xzf ~/buster-fast-bench/868-claude/inputs/lua-5.4.8.tar.gz -C inputs
if [ ! -d perf-repo ]; then
    git clone -q --depth 1 --filter=blob:none --sparse https://github.com/buster14a/buster-performance perf-repo
    git -C perf-repo sparse-checkout set docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua
fi
scripts=$PWD/perf-repo/docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua
sha256sum inputs/speedtest1.c $sqlite/sqlite3.c $scripts/*.lua > inputs.txt
git -C perf-repo log --oneline -1 >> inputs.txt
ls -d programs/measure-tier1-programs-* > /dev/null 2>&1 || $X taskset -c 2 base/build/compiler measure-tier1-programs --runs 1 --clang clang --sqlite $sqlite --speedtest inputs --lua inputs/lua-5.4.8/src --scripts $scripts --directory $PWD/programs --keep > programs.log 2>&1
echo "programs exit $?" >> programs.log
P=$(ls -d programs/measure-tier1-programs-* | head -1)
ls -la $P > programs-files.txt
for build in tier1 clang2; do
    st=$P/speedtest1-$build
    lua=$P/lua-$build
    echo "$build: $st $lua" >> profiles/executables.txt
    [ -x "$st" ] || continue
    rm -rf $P/db-$build; mkdir -p $P/db-$build
    $X sh -c "cd $P/db-$build && SQLITE_TMPDIR=\$PWD taskset -c 2 perf record -q -e ibs_op/swfilt=1/ -c 20011 -o ~/buster-fast-bench/1623-claude/profiles/speedtest1-$build.data -- ~/buster-fast-bench/1623-claude/$st --shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64 --testset mix1 db > /dev/null" 2>> profiles/errors.txt
    for s in calls tables strings arithmetic closures; do
        $X taskset -c 2 perf record -q -e ibs_op/swfilt=1/ -c 20011 -o profiles/lua-$s-$build.data -- $lua $scripts/$s.lua > /dev/null 2>> profiles/errors.txt
    done
done
ls -la profiles > profiles/files.txt
touch profile.done
