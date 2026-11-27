#!/bin/bash
# usage: skipasm.sh OUT.s  -- compiles src/buster/compiler/c_direct.c for znver5 and extracts fast_pp_skip_inactive
set -e
cd /home/user/buster
CC=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
mapfile -d '' FLAGS < <(BUSTER_HOST_ARCH=znver5 ./build.sh print-compile-flags --config Release)
FL=()
for f in "${FLAGS[@]}"; do [ "$f" = "-g" ] && continue; [ "$f" = "-march=native" ] && f=-march=znver5; FL+=("$f"); done
$CC "${FL[@]}" -S -o /tmp/claude-0/asm/full.s src/buster/compiler/c_direct.c
awk '/^fast_pp_skip_inactive:/,/^\.Lfunc_end/' /tmp/claude-0/asm/full.s > "/tmp/claude-0/asm/$1"
grep -c "^\s\+[a-z]" "/tmp/claude-0/asm/$1"
