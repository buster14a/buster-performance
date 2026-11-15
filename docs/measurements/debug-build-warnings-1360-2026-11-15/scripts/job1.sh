#!/bin/bash
# job1.sh: head1 tree (main + fix1.patch) built Release with debug info, then 8 perf records of sqlite3.c -DSQLITE_DEBUG.
set -u
cd ~/buster-fast-bench/1360-claude || exit 2
export EXCLUSIVE_OWNER=claude-1360 EXCLUSIVE_TITLE="claude #1360 debug-build warnings" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1360
if [[ ! -x head1/build/compiler ]]; then
  rm -rf head1 && mkdir head1 && git -C repo archive 2ebfe68a856613e300231520af5e7ec5627708b6 | tar -x -C head1 && (cd head1 && patch -p1 -s < ../fix1.patch) || exit 2
  (cd head1 && BUSTER_HOST_ARCH=znver5 timeout 3000 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release) > head1.build.log 2>&1 || { echo build failed; exit 1; }
fi
timeout 3000 ~/buster-fast-bench/exclusive.sh ./prof.sh $PWD/head1/build/compiler h1dbg 8 -DSQLITE_DEBUG
echo done > job1.done
