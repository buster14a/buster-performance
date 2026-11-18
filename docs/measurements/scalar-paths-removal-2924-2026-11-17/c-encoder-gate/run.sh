#!/bin/bash
# #2924 C10's gate: the x86 encoder's vector paths against its scalar loop, on main 0c113feb1, Release, every run under
# the lock on CPU 2: benchmark-x86-encoder for the compiler mix (64-bit), the vector mix, 32-bit and 16-bit mode, at 1, 4,
# 16 and 256 instructions a call and the whole stream.
set -uo pipefail
cd "$(dirname "$0")"
D=$PWD
export EXCLUSIVE_OWNER=claude-2924 EXCLUSIVE_TITLE="Scalar paths removed: the x86 encoder's gate" EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/2924
L=~/buster-fast-bench/exclusive.sh
mkdir -p logs
if [ ! -d src ]; then git clone -q --shared $D/../c7gate/src src || exit 1; fi
git -C src fetch -q https://github.com/buster14a/buster main || { echo "fetch failed" >> logs/status.txt; exit 1; }
git -C src checkout -q --detach 0c113feb1 && git -C src reset -q --hard
git -C src rev-parse HEAD > logs/commit.txt
(cd src && $L timeout -k 5 1500 ./build.sh --config Release > "$D/logs/build.log" 2>&1) || { echo "build failed" >> logs/status.txt; exit 1; }
cp src/build/compiler compiler
for mode in "" "--vector" "--mode32" "--mode16"; do
    for section in 1 4 16 256 0; do
        name="encoder${mode:+-${mode#--}}-section$section"
        args=()
        [ -n "$mode" ] && args+=("$mode")
        [ "$section" != 0 ] && args+=(--section "$section")
        $L timeout -k 5 900 taskset -c 2 ./compiler benchmark-x86-encoder "${args[@]}" > "logs/$name.log" 2>&1
        echo "$name: $?" >> logs/status.txt
    done
done
echo done >> logs/status.txt
