#!/bin/bash
# #405's second re-review fix (4113e380) on the 9700X, on tree394rr: each step its own lock acquisition.
base=~/buster-fast-bench/claude-linker-80
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/405
L=~/buster-fast-bench/exclusive.sh
log=$base/logs394rr; mkdir -p $log
echo "start $(date -Is)" > $log/status
cd $base/tree394rr || exit 1
EXCLUSIVE_TITLE="PR 405 re-review: build" $L ./build.sh > $log/build.log 2>&1; echo "build=$? $(date -Is)" >> $log/status
sha256sum build/compiler > $log/compiler.sha256
EXCLUSIVE_TITLE="PR 405 re-review: test-foreign --cross-check" $L ./build/compiler test-foreign --cross-check > $log/test-foreign.log 2>&1; echo "test-foreign=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="PR 405 re-review: foreign corpus, every kind, against lld and mold" $L ./build/compiler test-foreign-corpus --sqlite ../inputs/sqlite-amalgamation-3530400 --lua ../inputs/lua-5.4.8/src --self . > $log/corpus.log 2>&1; echo "corpus=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="PR 405 re-review: the startup check's cost, CPU 2" $L taskset -c 2 $base/measure9700x.sh $base/tree394rr/build/compiler 41 $base/startup-cost > $log/startup-cost.log 2>&1; echo "startup-cost=$? $(date -Is)" >> $log/status
echo "done $(date -Is)" >> $log/status
