#!/usr/bin/env bash
# usage: build9700.sh TREE NAME   builds TREE Release under the lock and copies the compiler to bin/NAME
set -u
D=$HOME/buster-fast-bench/3070-claude-euler
T=$1; N=$2
cd $D/$T
export EXCLUSIVE_OWNER=claude-3070-euler EXCLUSIVE_TITLE="#3070 step 1: the root image" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/3070
timeout 2400 ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > $D/build-$N.log 2>&1
s=$?
echo "build exit $s" >> $D/build-$N.log
if [ $s = 0 ]; then cp build/compiler $D/bin/$N; fi
