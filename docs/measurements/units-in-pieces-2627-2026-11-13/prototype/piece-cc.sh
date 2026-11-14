#!/bin/bash
# piece-cc.sh PIECE_TREE OUTPUT.bc [EXTRA...]: the checker unit's Develop front end (its flags as the tree's Develop
# build gives them) on one piece's tree, its files mapped back to the source tree's names (__FILE__, line tables).
tree=$1; output=$2; shift 2
root=${ROOT:-/home/user/buster-wt-develop}
clang=${CLANG:-/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang}
exec "$clang" -DCMAKE_INTDIR=\"Develop\" -gdwarf-4 -gline-tables-only ${MARCH:--march=native} -I"$tree" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -Wno-duplicate-decl-specifier -Wno-ignored-attributes -Wno-unused-function -fno-stack-protector \
  -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF -DBUSTER_CLANG_DEFAULT_TARGET=\"x86_64-unknown-linux-gnu\" -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 \
  '-DBUSTER_PIECE_HIDDEN=__attribute__((visibility("hidden")))' -DBUSTER_PIECE_EXTERN=extern \
  -O3 -fmacro-prefix-map="$tree/=src/" -fdebug-prefix-map="$tree/=$root/src/" -Xclang -disable-llvm-passes ${ACTION:--emit-llvm -c} "$@" -o "$output" "$tree/buster/compiler/main_unit_checker.c"
