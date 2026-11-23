#!/bin/bash
# build.sh TREE: Release build of TREE under the lock
. ~/buster-fast-bench/2972-claude/env.sh
cd ~/buster-fast-bench/2972-claude/$1 && $X timeout -k 5 1800 ./build.sh --config Release
echo "exit $?"
