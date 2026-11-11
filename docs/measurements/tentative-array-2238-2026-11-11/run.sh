#!/bin/bash
D=~/buster-fast-bench/2238-claude
cd $D/new
export EXCLUSIVE_OWNER=claude-c5b EXCLUSIVE_TITLE="C5b: tentative arrays (#2238)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/2281
git -C $D/base rev-parse HEAD; git -C $D/new rev-parse HEAD
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler time-runs --runs 15 --warmups 2 --build base $D/base/build/compiler --build new $D/new/build/compiler --list -fsyntax-only -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall src/buster/compiler/main.c
echo "exit $?"
