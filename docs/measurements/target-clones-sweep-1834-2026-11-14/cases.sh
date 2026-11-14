#!/bin/sh
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Writes one target_clones case per function-like macro intrinsic of intrin.txt (genintrin.py's output, from
# ../vector-baseline-sweep-1834-2026-11-11): the macro's call in a target_clones("arch=znver5","default") body, its
# value stored through a pointer, so that the default copy holds the macro's builtin.
# Usage: cases.sh intrin.txt DIRECTORY
mkdir -p "$2"
grep '^M_' "$1" | while IFS="$(printf '\t')" read -r n code; do
  body=$(printf '%s' "$code" | sed -E 's/^__typeof__\((.*)\) g\((.*)\)\{return (.*);\}$/void g(void* out_,\2){__auto_type r_=\3;__builtin_memcpy(out_,\&r_,sizeof r_);}/; s/void\* out_,void\)/void* out_)/')
  printf '#include <immintrin.h>\n#include <x86intrin.h>\n__attribute__((target_clones("arch=znver5","default"))) %s\n' "$body" > "$2/$n.c"
done
