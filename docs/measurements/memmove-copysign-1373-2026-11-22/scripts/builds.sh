#!/bin/bash
cd ~/buster-fast-bench/1373-claude-move
export EXCLUSIVE_OWNER=claude-1373-move EXCLUSIVE_TITLE="buster #1373 leftovers: inline memmove 33-128 and __builtin_copysign" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1373
for v in "$@"; do
  (cd $v && ~/buster-fast-bench/exclusive.sh ./build.sh --config Release > ../build-$v.log 2>&1; echo "$v exit $?" >> ../builds.done)
done
