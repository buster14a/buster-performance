#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Copyright (c) 2026 David Gonzalez Martin.
set -euo pipefail
if (( $# != 2 )); then echo 'usage: compare.sh BASE_COMPILER HEAD_COMPILER' >&2; exit 2; fi
compilers=("$(realpath "$1")" "$(realpath "$2")")
cd "$(dirname "$0")"
export LC_ALL=C

# Decode only the bytes in the ELF symbol. Alignment padding belongs to neither leaf.
shape() {
    local out=$1 side=$2 tier=$3 name=$4 sym=$5 bytes begin first last code fde
    read -r begin bytes < <(awk -v s="$sym" '$4 == "FUNC" && $8 == s {print $2, $3}' "$out/symbols.txt")
    first=$((16#$begin))
    last=$((first + bytes))
    code="$out/$name.asm"
    fde="$out/$name.fde"
    llvm-objdump -d --no-show-raw-insn --x86-asm-syntax=intel --start-address="$first" --stop-address="$last" "$out/roots.o" > "$code"
    awk -v pc="$(printf 'pc=%016x..%016x' "$first" "$last")" '/ FDE / { found = index($0, pc) != 0 } found' "$out/frames.txt" > "$fde"
    grep -q ' FDE ' "$fde"
    grep -q 'DW_CFA_def_cfa: r7 (rsp) ofs 8' "$out/frames.txt"
    gawk -v name="$name" -v side="$side" -v tier="$tier" -v bytes="$bytes" '
        /^[[:space:]]*[[:xdigit:]]+:/ {
            ++inst
            if (/\[rsp\]/) ++stack
            if ($2 == "sub" && $3 == "rsp,") frame = strtonum($4)
            if ($2 == "jp") jp = strtonum($3)
            if ($2 == "jae") jae = strtonum($3)
            if ($2 == "mov" && /dword ptr \[rsi\], 0x21/) store = inst
            if ($2 == (name == "sqrt" ? "sqrtsd" : "sqrtss")) {
                sq = strtonum("0x" substr($1, 1, length($1)-1))
                sqinst = inst
            }
        }
        END {
            printf "%s\t%s\t%s\t%d\t%d\t%d\t%d\n", side, tier, name, bytes, inst, stack, frame
            if (store == 0 || sqinst != store+1 || jp != sq || jae != sq) exit 1
            if (side == "base") exit !(inst == 13 && stack == 4 && frame == 16 && bytes == (name == "sqrt" ? 49 : 47))
            exit !(inst == 9 && stack == 0 && frame == 0 && bytes <= (name == "sqrt" ? 33 : 30))
        }
    ' "$code" >> counts.tsv
    if [[ $side == base ]]; then
        [[ $(awk '/DW_CFA_def_cfa_offset:/ { print $NF }' "$fde" | paste -sd, -) == 24,8 ]]
    else
        ! grep 'DW_CFA_' "$fde" | grep -v 'DW_CFA_nop' > /dev/null || return 1
    fi
}

printf 'build\ttier\tleaf\tbytes\tinstructions\tstack_transports\tframe_bytes\n' > counts.tsv
for i in 0 1; do
    side=base
    if (( i == 1 )); then side=head; fi
    cc=${compilers[i]}
    mkdir -p "$side"
    "$cc" test-builtin-math-helpers > "$side/math-tests.txt"
    "$cc" test-unwind > "$side/unwind-core.txt"
    cat "$side/math-tests.txt"
    for tier in tier0 tier1; do
        args=(-march=x86-64 -fasynchronous-unwind-tables --helper-report)
        if [[ $tier == tier1 ]]; then args+=(--tier1); fi
        out="$side/$tier"
        mkdir -p "$out"
        "$cc" "${args[@]}" -c roots.c -o "$out/roots.o" > "$out/helper-report.txt" 2>&1
        "$cc" "${args[@]}" -c controls.c -o "$out/controls.o" > "$out/control-report.txt" 2>&1
        grep -Fxq $'helpers.math\tdirect=0\thelper=2\tplanned=2' "$out/helper-report.txt"
        grep -Fxq $'helpers.math\tdirect=0\thelper=12\tplanned=12' "$out/control-report.txt"
        llvm-objdump -dr --x86-asm-syntax=intel "$out/roots.o" > "$out/disassembly.txt"
        readelf -sW "$out/roots.o" > "$out/symbols.txt"
        readelf -Wr "$out/roots.o" > "$out/relocations.txt"
        readelf --debug-dump=frames "$out/roots.o" > "$out/frames.txt"
        readelf --debug-dump=frames-interp "$out/roots.o" > "$out/frames-interp.txt"
        shape "$out" "$side" "$tier" sqrt .Lbuster_builtin_512_0
        shape "$out" "$side" "$tier" sqrtf .Lbuster_builtin_513_0
        objcopy --redefine-sym .Lbuster_builtin_512_0=raw64 --redefine-sym .Lbuster_builtin_513_0=raw32 --globalize-symbol=raw64 --globalize-symbol=raw32 "$out/roots.o" "$out/test-symbols.o"
        clang -std=gnu17 -O0 -Wall -Wextra -Werror -fno-builtin -frounding-math matrix.c "$out/test-symbols.o" -lm -o "$out/matrix"
        "$out/matrix" > "$out/matrix.tsv" 2> "$out/matrix-summary.txt"
        cat "$out/matrix-summary.txt"
    done
done
for tier in tier0 tier1; do
    cmp "base/$tier/helper-report.txt" "head/$tier/helper-report.txt"
    cmp "base/$tier/controls.o" "head/$tier/controls.o"
    cmp "base/$tier/matrix.tsv" "head/$tier/matrix.tsv"
    sha256sum {base,head}/"$tier"/{controls.o,matrix.tsv}
done
cmp base/tier0/matrix.tsv base/tier1/matrix.tsv
cat counts.tsv
