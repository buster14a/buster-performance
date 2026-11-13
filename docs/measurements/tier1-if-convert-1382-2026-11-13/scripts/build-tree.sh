#!/bin/bash
# Builds one tree's Release compiler under the 9700X's lock: build-tree.sh DIR
cd "$1" || exit 1
EXCLUSIVE_OWNER=claude-1382 EXCLUSIVE_TITLE="#1382 Tier 1 if-conversion of nested, truth and reload regions" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1382 \
    ~/buster-fast-bench/exclusive.sh timeout -k 5 900 ./build.sh > build.log 2>&1
echo "build exit $?" >> build.log
