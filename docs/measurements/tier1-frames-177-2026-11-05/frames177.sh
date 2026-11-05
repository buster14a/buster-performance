#!/usr/bin/env bash
# frames177.sh COMMIT: #1415's review's measure-frames (the depth along the control flow) built at COMMIT in head2/, under
# the shared lock, reading run177.sh's objects of sqlite3.c and Lua's executables again (COMMIT changes the reader, not
# the code they hold), into out/frames2/.
set -u
COMMIT=${1:?commit}
W=$HOME/buster-fast-bench/177-claude
L="env EXCLUSIVE_OWNER=claude-177 EXCLUSIVE_TITLE=Problems_141_177_789 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/1415 $HOME/buster-fast-bench/exclusive.sh"
cd $W || exit 1
mkdir -p out/frames2
if [ ! -d head2 ]; then git clone -q https://github.com/buster14a/buster head2; fi
(cd head2 && git fetch -q origin claude/practical-ramanujan-s8ccq2 && git checkout -q $COMMIT && git log -1 --format=%H > ../out/frames2/head2.commit)
$L bash -c "cd $W/head2 && BUSTER_HOST_ARCH=znver5 ./build.sh > $W/out/frames2/build.log 2>&1"; echo "build exit $?" > $W/out/frames2/steps.log
B=$W/head2/build/compiler
$L bash -c "cd $W/out/frames && $B measure-frames --functions clang2=sqlite3-clang2.o t1=sqlite3-t1.o t1nl=sqlite3-t1nl.o t0=sqlite3-t0.o clang0=sqlite3-clang0.o > $W/out/frames2/sqlite3-frames.tsv && $B measure-frames --functions clang2=$W/out/lua/lua-clang2 t1=$W/out/lua/lua-t1 t1nl=$W/out/lua/lua-t1nl t0=$W/out/lua/lua-t0 clang0=$W/out/lua/lua-clang0 > $W/out/frames2/lua-frames.tsv"; echo "frames exit $?" >> $W/out/frames2/steps.log
grep -h '^frames' $W/out/frames2/sqlite3-frames.tsv $W/out/frames2/lua-frames.tsv >> $W/out/frames2/steps.log
echo done >> $W/out/frames2/steps.log
