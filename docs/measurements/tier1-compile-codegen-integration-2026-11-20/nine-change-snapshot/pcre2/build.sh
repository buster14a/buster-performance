#!/usr/bin/env bash
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd);w=$(cd "$d/../.." && pwd)
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
v=$1;dest="$d/$v-static";more=("-DCMAKE_C_COMPILER_LAUNCHER=python;$d/launcher.py;reference")
if [[ $v != clang ]]; then more=("-DCMAKE_C_COMPILER_LAUNCHER=python;$d/launcher.py;$w/all-pr-$v/build/compiler"); fi
export SOURCE_DATE_EPOCH=1792454400 LC_ALL=C
cmake -G Ninja -S "$w/independent-corpus/pcre2" -B "$dest" -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$cc" -DCMAKE_C_FLAGS_RELEASE="-O2 -DNDEBUG" -DCMAKE_EXE_LINKER_FLAGS=-no-pie -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DPCRE2_SUPPORT_JIT=OFF -DPCRE2_BUILD_PCRE2_8=ON -DPCRE2_BUILD_PCRE2_16=ON -DPCRE2_BUILD_PCRE2_32=ON -DPCRE2_BUILD_TESTS=ON -DPCRE2_SUPPORT_LIBREADLINE=OFF "${more[@]}"
ninja -C "$dest" -j1 -k0
ctest --test-dir "$dest" --output-on-failure --timeout 500 -j1
