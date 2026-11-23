#!/usr/bin/env bash
# build-base.sh TREE: a Release build of TREE under the 9700X lock (one hold).
set -u
R=~/buster-fast-bench/2743-claude-default
cd $R || exit 1
export EXCLUSIVE_OWNER=claude-2743-default
export EXCLUSIVE_TITLE="buster #2743: Tier 1 loop vectorizer by default"
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2743
T=$1
~/buster-fast-bench/exclusive.sh bash -c "head -1 /var/lib/buster-9700x/owner >> $R/holds.txt; cd $R/$T && timeout -k 5 1800 ./build.sh --config Release" > $R/build-$T.log 2>&1
echo "exit $?" >> $R/build-$T.log
