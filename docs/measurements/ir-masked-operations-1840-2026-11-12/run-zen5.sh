#!/bin/sh
set -e
cd ~/buster-fast-bench/1840-claude-e1
export EXCLUSIVE_OWNER=claude-e1 EXCLUSIVE_TITLE="E1: #1840 masked operations' Zen 5 rows" EXCLUSIVE_LINK=https://claude.ai/code/session_01EgbxndWCrfZ3qeELU4Hd1U
if [ ! -d buster ]; then git clone -q https://github.com/buster14a/buster buster; fi
cd buster && git fetch -q origin e1/1840-masked-op && git checkout -q a48af16e732ed2e77673451eddb6cacebe3e9427
echo "build start $(date -Is)"
BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ~/buster-fast-bench/exclusive.sh ./build.sh > ../build.log 2>&1
echo "build done $(date -Is)"
~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler measure-x86-zen5 --missing --table > ../table.txt 2> ../measure.err
echo "measure done $(date -Is)"
