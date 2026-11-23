#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# Static check of a variant: Lua 5.4.8's call-path files compiled at Tier 0 by the experiment compiler (x2841.patch),
# then frame-slot accesses (rsp/rbp memory operands), pushes and instructions of the call path's functions.
# usage: lua-static.sh COMPILER LUA_SRC OUT_DIR X2841_SHIFT X2841_CALLEE
C=$1; L=$2; O=$3; mkdir -p "$O"
for f in ldo lfunc lvm ltable lgc lapi lstring; do
    X2841_SHIFT=$4 X2841_CALLEE=$5 "$C" -march=znver5 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c -o "$O/$f.o" "$L/$f.c" || echo "FAIL $f"
done
for fn in luaD_precall luaD_pretailcall luaF_close luaF_closeupval luaV_execute luaH_getshortstr luaD_poscall; do
    for o in "$O"/*.o; do objdump -d --no-show-raw-insn --disassemble=$fn "$o" 2>/dev/null | sed -n "/<$fn>:/,\$p" > "$O/f.s"; [ -s "$O/f.s" ] && break; done
    printf "%-18s mem %4d push %d insns %d\n" $fn $(grep -c '(%r[bs]p)' "$O/f.s") $(grep -c 'push' "$O/f.s") $(grep -c '^ ' "$O/f.s")
done
echo "total: mem $(for o in "$O"/*.o; do objdump -d --no-show-raw-insn "$o"; done | grep -c '(%r[bs]p)') push $(for o in "$O"/*.o; do objdump -d --no-show-raw-insn "$o"; done | grep -c 'push')"
