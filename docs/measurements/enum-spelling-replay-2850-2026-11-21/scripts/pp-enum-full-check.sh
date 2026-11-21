#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
root=$PWD
cd pp-enum-queue-qual
test "$(git write-tree)" = dead56c03d526cb0e25b4fffda3f11175fec6f93
out="$root/enum-queue-shards"; mkdir -p "$out"
export PATH="$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin:$PATH" BUSTER_CLANG_RESOURCE_DIR="$HOME/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/lib/clang/23"
./build.sh --config Develop > "$out/build.log" 2>&1
cc=$PWD/build/compiler; export cc out
for kind in checker driver;do
 export kind
 seq 1 8 | xargs -P 2 -IXX bash -c 'set -eu; if [[ $kind == checker ]];then args=(test-checker --seed 133);else args=(test-checker-driver --executable "$cc" --in-process);fi; rc=0; "$cc" "${args[@]}" --part "$1/8" > "$out/$kind-$1.log" 2>&1 || rc=$?; echo "$rc" > "$out/$kind-$1.status"; exit "$rc"' _ XX
done
date -u +%FT%TZ > "$out/done"
