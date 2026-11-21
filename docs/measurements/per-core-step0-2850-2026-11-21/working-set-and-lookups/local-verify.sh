#!/bin/bash
set -eu
cd "$(dirname "$0")"; d=$PWD; type=$1
c=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
mkdir -p local
for src in musl sqlite3; do
 "$c" -O2 -g -march=native -fsanitize=address,undefined -fno-sanitize-recover=all "-DLANES_BAKED=\"$d/baked-$src.h\"" "tools/$type.c" -o "local/$type-$src" >"local/$type-$src.build" 2>&1
 for win in 64 4096 0; do
  ASAN_OPTIONS=detect_leaks=0 "local/$type-$src" "dumps/$src.dump" --passes 2 --first-passes 2 --window "$win" >"local/$type-$src-$win.txt" 2>&1
 done
done
