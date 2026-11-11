#!/bin/sh
set -e
D=~/buster-fast-bench/2301-claude-d6
mkdir -p $D && cd $D
export EXCLUSIVE_OWNER=claude-2301-d6 EXCLUSIVE_TITLE="#2301 D6: GNU cast to a union, base vs head" EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxngcbuk3PNgFUn7C7Ze
for t in base head; do
  [ -d $t ] || git clone -q --reference ~/buster-fast-bench/2216-claude-d2/base https://github.com/buster14a/buster $t
done
git -C base fetch -q origin main && git -C base checkout -q e43dfc102
git -C head fetch -q origin d6/2301-union-cast && git -C head checkout -q FETCH_HEAD
for t in base head; do (cd $t && ~/buster-fast-bench/exclusive.sh ./build.sh > ../build-$t.log 2>&1); done
cd base && clang -dM -E -march=native -fwrapv -funsigned-char -x c /dev/null > ../predefines.h
echo setup-done
