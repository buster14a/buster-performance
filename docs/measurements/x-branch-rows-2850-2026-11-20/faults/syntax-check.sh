#!/bin/bash
# syntax-check.sh TREE LIST INDEX...: each fault INDEX of LIST (faults-branch.py) applied alone to a scratch copy of
# TREE's src, and the checker's unit compiled with -fsyntax-only and the unit's flags: a fault that removes a
# variable's only use does not build under -Werror, and costs a campaign a slot. A line a fault: ok or FAILS.
tree=$1; list=$2; shift 2
scratch=/tmp/claude-0/-home-user/750b08ae-4cd9-565b-b66d-6cb5ef06cd50/scratchpad/syntax-$$
rm -rf "$scratch" && mkdir -p "$scratch" && cp -r "$tree/src" "$scratch/src" || exit 1
clang=/root/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
rows=src/buster/compiler/c_check_node_machine_rows.c
facts=src/buster/compiler/c_check_node_machine_facts.c
reader=src/buster/compiler/c_check_node_machine_reader.c
window=src/buster/compiler/c_check_node_machine_window.c
for n in "$@"; do
    cp "$tree/$rows" "$scratch/$rows"; cp "$tree/$facts" "$scratch/$facts"; cp "$tree/$reader" "$scratch/$reader"; cp "$tree/$window" "$scratch/$window"
    name=$(python3 "$list" "$scratch" "$n") || { echo "not-applied $n"; continue; }
    if $clang -fsyntax-only -march=native -I"$scratch/src" -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror -fno-stack-protector -DBUSTER_HOST_SSP_DEFAULT=BUSTER_PREDEFINES_SSP_OFF '-DBUSTER_CLANG_DEFAULT_TARGET="x86_64-unknown-linux-gnu"' -DBUSTER_EXECUTABLE_UNIT -DBUSTER_HOST_STATIC=1 "$scratch/src/buster/compiler/main_unit_checker.c" > "$scratch/err.txt" 2>&1; then echo "ok $n $name"; else echo "FAILS $n $name: $(grep -m1 error "$scratch/err.txt" | cut -c1-200)"; fi
done
