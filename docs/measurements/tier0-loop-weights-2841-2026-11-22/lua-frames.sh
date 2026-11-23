#!/bin/bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
# Static comparison of the record's Tier 0 Lua binaries (programs/lua-base, programs/lua-head on the 9700X): per
# function, instructions, accesses through rsp/rbp (frame slots) and pushes. No timing; run outside the lock.
cd "${1:-$HOME/buster-fast-bench/2841-claude/programs}" || exit 1
for f in luaV_execute luaD_precall luaD_poscall luaF_close luaF_closeupval luaF_findupval luaD_pretailcall luaH_getshortstr; do
    for v in base head; do
        objdump -d --no-show-raw-insn --disassemble=$f lua-$v | sed -n "/<$f>:/,\$p" | sed 's/^ *[0-9a-f]*:\s*//; s/ *[0-9a-f]* <[^>]*>//; s/#.*//' > /tmp/lua-frames-$v.s
    done
    echo "$f: insns $(wc -l < /tmp/lua-frames-base.s)->$(wc -l < /tmp/lua-frames-head.s), rbp/rsp mem $(grep -c '(%r[bs]p)' /tmp/lua-frames-base.s)->$(grep -c '(%r[bs]p)' /tmp/lua-frames-head.s), push $(grep -c '^push' /tmp/lua-frames-base.s)->$(grep -c '^push' /tmp/lua-frames-head.s)"
done
rm -f /tmp/lua-frames-*.s
