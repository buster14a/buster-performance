#!/usr/bin/env bash
set -euo pipefail
d=$(cd "$(dirname "$0")" && pwd);w=$(cd "$d/../.." && pwd);v=$1;root="$d/$v-mt"
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
c=reference
case $v in control) c="$w/nov20-main-control/build/compiler";; candidate) c="$w/twelve-candidate/build/compiler";; esac
export SOURCE_DATE_EPOCH=1792454400 LC_ALL=C
cmake -G Ninja -S "$w/independent-corpus/zstd/build/cmake" -B "$root" -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER="$cc" -DCMAKE_ASM_COMPILER="$cc" -DCMAKE_CXX_COMPILER="${cc}++" -DCMAKE_C_FLAGS_RELEASE='-O2 -march=znver5 -DNDEBUG' -DCMAKE_EXE_LINKER_FLAGS=-no-pie "-DCMAKE_C_COMPILER_LAUNCHER=python;$d/launcher.py;$c" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DZSTD_BUILD_STATIC=ON -DZSTD_BUILD_SHARED=OFF -DZSTD_PROGRAMS_LINK_SHARED=OFF -DZSTD_BUILD_TESTS=ON -DZSTD_BUILD_PROGRAMS=ON -DZSTD_MULTITHREAD_SUPPORT=ON -DZSTD_BUILD_CONTRIB=OFF
ninja -C "$root" -j1 -k0 libzstd_static zstd zstreamtest fuzzer
