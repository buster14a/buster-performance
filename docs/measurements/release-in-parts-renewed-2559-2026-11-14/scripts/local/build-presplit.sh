#!/bin/bash
# build-presplit.sh SRC_TREE OUT: presplit from SRC_TREE's tools/codegen, against CI's LLVM 23.1.4
set -e
T=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4
src=$1; out=$2
$T/bin/clang++ -O2 -Wall -Werror -I$T/include -std=c++17 -D_GNU_SOURCE -D_GLIBCXX_USE_CXX11_ABI=1 -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -fno-exceptions -fno-rtti -c $src/tools/codegen/split_bitcode.cpp -o $out.split_bitcode.o
$T/bin/clang -O2 -Wall -Wextra -Werror -I$T/include -D_GNU_SOURCE -D__STDC_CONSTANT_MACROS -D__STDC_FORMAT_MACROS -D__STDC_LIMIT_MACROS -c $src/tools/codegen/presplit.c -o $out.o
$T/bin/clang++ -o $out $out.o $out.split_bitcode.o $($T/bin/llvm-config --ldflags --libs --system-libs 2>/dev/null | tr '\n' ' ' | sed "s#/usr/lib/x86_64-linux-gnu/libzstd.a#/usr/lib/x86_64-linux-gnu/libzstd.so.1#; s#-lzstd#/usr/lib/x86_64-linux-gnu/libzstd.so.1#")
