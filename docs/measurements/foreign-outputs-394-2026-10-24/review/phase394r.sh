#!/bin/bash
# #405's review fixes on the 9700X, on tree394r (the branch merged with main, a077498): each step its own lock
# acquisition.
base=~/buster-fast-bench/claude-linker-80
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/405
L=~/buster-fast-bench/exclusive.sh
log=$base/logs394r; mkdir -p $log
echo "start $(date -Is)" > $log/status
cd $base/tree394r || exit 1
EXCLUSIVE_TITLE="PR 405 review: build" $L ./build.sh > $log/build.log 2>&1; echo "build=$? $(date -Is)" >> $log/status
sha256sum build/compiler > $log/compiler.sha256
EXCLUSIVE_TITLE="PR 405 review: test-foreign --cross-check" $L ./build/compiler test-foreign --cross-check > $log/test-foreign.log 2>&1; echo "test-foreign=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="PR 405 review: foreign corpus, every kind, against lld and mold" $L ./build/compiler test-foreign-corpus --sqlite ../inputs/sqlite-amalgamation-3530400 --lua ../inputs/lua-5.4.8/src --self . > $log/corpus.log 2>&1; echo "corpus=$? $(date -Is)" >> $log/status
echo "done $(date -Is)" >> $log/status
