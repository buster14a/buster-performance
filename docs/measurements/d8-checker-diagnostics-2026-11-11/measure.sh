#!/bin/bash
# usage: measure.sh OUT NAME... (trees under d8-claude)
D=~/buster-fast-bench/d8-claude; out=$1; shift
C=/var/lib/buster-9700x/corpora/preprocessor-391e729af658
SQ="--predefines $C/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc -isystem $C/headers/usr/lib/clang/23/include -isystem $C/headers/usr/local/include -isystem $C/headers/usr/include $C/sqlite/sqlite3.c"
MA="-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing --predefines $D/predefines.h src/buster/compiler/main.c"
builds=(); for n in "$@"; do builds+=(--build $n $D/$n/build/compiler); done
cd $D/$1
export EXCLUSIVE_OWNER=claude-d8 EXCLUSIVE_TITLE="D8: checker diagnostics PRs, base vs heads" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndzEpWbBb3xjo3m4ge
~/buster-fast-bench/exclusive.sh taskset -c 2 $D/$1/build/compiler time-runs --runs ${RUNS:-11} "${builds[@]}" --list -fsyntax-only $SQ --list -c -o $D/sqlite.o $SQ --list -fsyntax-only $MA --list -c -o $D/main.o $MA > $D/$out 2>&1
echo MEASURE-DONE >> $D/$out
