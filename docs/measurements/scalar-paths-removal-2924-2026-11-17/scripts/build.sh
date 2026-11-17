#!/bin/bash
# #2924 phase B2's gate, step 1: main's native and x86-64 (baseline) Release builds, each under the lock.
set -euo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: B2 gate (native vs x86-64 Release)" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p compilers logs
if [ ! -d src ]; then git clone -q https://github.com/buster14a/buster src; fi
git -C src fetch -q origin main
git -C src checkout -q --detach d1cf1fe
git -C src rev-parse HEAD > logs/commit.txt
cd src
$L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-native.log" 2>&1
cp build/compiler "$D/compilers/native"
BUSTER_HOST_ARCH=x86-64 $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build-x86-64.log" 2>&1
cp build/compiler "$D/compilers/x86-64"
cd "$D"
sha256sum compilers/* > logs/compilers.sha256
date -u +%FT%TZ > logs/.built
