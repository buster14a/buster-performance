#!/bin/bash
D=~/buster-fast-bench/d8-claude; out=$1; shift
cd $D/base
export EXCLUSIVE_OWNER=claude-d8 EXCLUSIVE_TITLE="D8: #2365 stage times, base vs head" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2365
~/buster-fast-bench/exclusive.sh bash -c '
for r in 1 2 3 4 5 6 7 8 9; do for n in "$@"; do echo "== $n run $r"; taskset -c 2 '$D'/$n/build/compiler -fsyntax-only --time-stages -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing --predefines '$D'/predefines.h src/buster/compiler/main.c 2>&1 | grep -v "^$"; done; done' _ "$@" > $D/$out 2>&1
echo STAGES-DONE >> $D/$out
