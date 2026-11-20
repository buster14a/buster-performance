#!/bin/bash
# syntax-check.sh TREE LIST OUT INDEX...: each fault INDEX of LIST (faults-values-roundN.py) applied alone to a scratch
# copy of TREE's src, and the checker's unit compiled with -fsyntax-only and the unit's flags: a fault that removes a
# variable's only use does not build under -Werror, and costs a campaign a slot. A line a fault in OUT: ok or FAILS.
tree=$1; list=$2; out=$3; shift 3
scratch=/tmp/claude-0/-home-user/dee3f18a-a5e4-510a-ab70-2139693431f3/scratchpad/syntax-$$
rm -rf "$scratch" && mkdir -p "$scratch" && cp -r "$tree/src" "$scratch/src" || exit 1
clang=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
files="src/buster/compiler/c_check_node_machine_rows.c src/buster/compiler/c_check_node_machine_facts.c src/buster/compiler/c_check_node_machine_window.c src/buster/compiler/c_check_node_census.c"
for n in "$@"; do
    for f in $files; do cp "$tree/$f" "$scratch/$f"; done
    name=$(python3 "$list" "$scratch" "$n") || { echo "not-applied $n" >> "$out"; continue; }
    if $clang -fsyntax-only -march=native -I"$scratch/src" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF '-DBUSTER_CLANG_DEFAULT_TARGET="x86_64-unknown-linux-gnu"' -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 "$scratch/src/buster/compiler/main_unit_checker.c" > "$scratch/err.txt" 2>&1; then echo "ok $n $name" >> "$out"; else echo "FAILS $n $name: $(grep -m1 error "$scratch/err.txt" | cut -c1-200)" >> "$out"; fi
done
rm -rf "$scratch"
echo "done" >> "$out"
