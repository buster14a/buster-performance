#!/bin/bash
cd ~/buster-fast-bench/1555-claude/main
export EXCLUSIVE_OWNER=claude-1555 EXCLUSIVE_TITLE="#1555 line-crossing loads (build main)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/1555
time ~/buster-fast-bench/exclusive.sh env BUSTER_HOST_ARCH=znver5 ./build.sh
echo "exit=$?"
