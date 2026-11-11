#!/bin/bash
set -e
D=~/buster-fast-bench/2238-claude
mkdir -p $D && cd $D
for t in base new; do [ -d $t ] || git clone -q https://github.com/buster14a/buster $t; done
(cd base && git fetch -q origin main && git checkout -q 66e05fbf)
(cd new && git fetch -q origin claude/2238-tentative-array && git checkout -q a777aa5d3156515a763e86999d6bff8d72aa827f)
export EXCLUSIVE_OWNER=claude-c5b EXCLUSIVE_TITLE="C5b: tentative arrays (#2238)" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxngSbtNhQrJ351gXFtq
for t in base new; do (cd $t && ~/buster-fast-bench/exclusive.sh ./build.sh > build.log 2>&1; echo $t $?); done
cd new && clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > build/predefines.h
