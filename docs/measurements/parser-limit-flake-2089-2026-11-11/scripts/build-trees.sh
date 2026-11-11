#!/bin/bash
# Builds each named tree under the 9700X lock, one hold per build.
B=$HOME/buster-fast-bench/2089-claude
export EXCLUSIVE_OWNER=claude-2089 EXCLUSIVE_TITLE="test-parser limit flake (#2089)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2089
for name in "$@"; do
  cd $B/trees/$name || exit 1
  ~/buster-fast-bench/exclusive.sh ./build.sh > $B/logs/build-$name.log 2>&1
  echo "$name build exit $?" >> $B/logs/builds.txt
done
