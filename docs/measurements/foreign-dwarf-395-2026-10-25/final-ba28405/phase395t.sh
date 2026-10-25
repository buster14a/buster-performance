#!/bin/bash
# #395 at ba28405 (the decoder, the vector relocation pass on a table of symbols) on the 9700X, on tree395t, against the
# merged tree (tree395, a29db0f): each step its own lock acquisition.
base=~/buster-fast-bench/claude-linker-80
export EXCLUSIVE_OWNER=claude-linker-80 EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/395
L=~/buster-fast-bench/exclusive.sh
log=$base/logs395t; mkdir -p $log
echo "start $(date -Is)" > $log/status
cd $base/tree395t || exit 1
EXCLUSIVE_TITLE="395 DWARF: build" $L ./build.sh > $log/build.log 2>&1; echo "build=$? $(date -Is)" >> $log/status
sha256sum build/compiler $base/tree395/build/compiler > $log/compiler.sha256
EXCLUSIVE_TITLE="395 DWARF: call graph" $L ./build.sh check-call-graph > $log/callgraph.log 2>&1; echo "callgraph=$? $(date -Is)" >> $log/status
for t in test-inflate "test-debug --cross-check" test-executable "test-streaming --cross-check" "test-foreign --cross-check"; do
    name=${t%% *}
    EXCLUSIVE_TITLE="395 DWARF: $t" $L ./build/compiler $t > $log/$name.log 2>&1; echo "$name=$? $(date -Is)" >> $log/status
done
EXCLUSIVE_TITLE="395 DWARF: foreign corpus with SQLite, Lua and this compiler" $L ./build/compiler test-foreign-corpus --sqlite ../inputs/sqlite-amalgamation-3530400 --lua ../inputs/lua-5.4.8/src --self . > $log/corpus.log 2>&1; echo "corpus=$? $(date -Is)" >> $log/status
EXCLUSIVE_TITLE="395 DWARF: links of SQLite -g, CPU 2" $L $base/measure395.sh $base/tree395/build/compiler $base/tree395t/build/compiler $base/dwarf395 > $log/measure.log 2>&1; echo "measure=$? $(date -Is)" >> $log/status
echo "done $(date -Is)" >> $log/status
