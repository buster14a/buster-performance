#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")";d=$PWD
cc=/home/david/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
src=$d/../active-source-name-spans/src
"$cc" -O2 -g0 -std=gnu17 -march=native -fwrapv -funsigned-char -I"$src" -I"$src/buster/compiler" ../local-spelling-study/check.c -o "$d/spans-check"
"$d/spans-check" "$d/../switch-inputs/sqlite/sqlite3.c" "$d/colliding-names.c" "$d"/../local-spelling-study/boundaries/* >"$d/spans-check.log" 2>&1
