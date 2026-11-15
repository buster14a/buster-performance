#!/bin/bash
# Builds one tree's Release compiler under the 9700X's lock: build-tree.sh DIR
cd "$1" || exit 1
git log --format='%H %T' -1 > COMMIT
EXCLUSIVE_OWNER=claude-2677 EXCLUSIVE_TITLE="#2677 Tier 1 i1/i8/i16 and/or/xor" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2677 \
    ~/buster-fast-bench/exclusive.sh timeout -k 5 900 ./build.sh --config Release > build.log 2>&1
echo "build exit $?" >> build.log
