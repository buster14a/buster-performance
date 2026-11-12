#!/usr/bin/env bash
# nodom.sh: an experiment, not the PR's code: h7 with nodom.patch (anchors without the dominator analysis: no anchors,
# the nearest earlier predecessor), built in one hold of the lock, then --tier1 -c sqlite3.c by its measure-compile with
# base and h7 as references, pinned to CPU 2, in another: what the analysis costs of h7's compile time.
set -u
W=$HOME/buster-fast-bench/2553-claude
export EXCLUSIVE_OWNER=claude-2553 EXCLUSIVE_TITLE="Tier 1: values keep their registers along dominators (#2553)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2553
L=$HOME/buster-fast-bench/exclusive.sh
I=$W/inputs
cd $W || exit 1
test -e nodom || { ./clone.sh 09c205599b4282f3651ce2aaaa5a5c873bed6fd0 nodom && git -C nodom apply ../nodom.patch; }
$L bash -c "cd $W/nodom && BUSTER_HOST_ARCH=znver5 ./build.sh > $W/build-nodom-compiler.log 2>&1"
echo "nodom build exit $?" >> compile/log.txt
unset CPATH C_INCLUDE_PATH
$L bash -c "head -1 /var/lib/buster-9700x/owner; taskset -c 2 $W/nodom/build/compiler measure-compile --runs 21 --reference $W/base/build/compiler --reference $W/h7/build/compiler -- --tier1 --lanes 1 -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -c $I/sqlite/sqlite3.c" > compile/sqlite3-nodom.txt 2>&1
echo "nodom sqlite3 exit $?" >> compile/log.txt
