#!/usr/bin/env bash
set -euo pipefail
work=$1
rev=$2
tools=$(cd "$(dirname "$0")" && pwd)
src=src/buster/compiler/inflate.c
flags=(-std=gnu17 -O3 -fwrapv -funsigned-char -fno-strict-aliasing -fno-stack-protector
       -march=x86-64-v4 -maes -mgfni -mvaes -mavx512vbmi -mavx512vbmi2 -mavx512vpopcntdq -mavx512bitalg -mavx512vnni)
awk '
    /code->alphabet = alphabet;/ { print "    counts.builds++;" }
    /memset\(code->counts,/ { print "    counts.count_clear += sizeof(code->counts);" }
    /memset\(code->table,/ { print "    counts.table_clear += sizeof(code->table);" }
    /code->table\[fill\] = entry;/ { print "                counts.table_fill += sizeof(code->table[fill]);" }
    /^    memset\(lengths( \+ [0-9]+)?, [0-9]+, [0-9]+\);$/ {
        n = $NF; sub(/\);$/, "", n); print "    counts.length_init += " n ";"
    }
    { print }
    /const uint32_t type = header >> 1;/ {
        print "        if (error == INFLATE_ERROR_NONE && type < 3) counts.blocks[type]++;"
    }
' "$src" > "$work/inflate-counted.c"
clang "${flags[@]}" -I "$work" "$tools/probe.c" -lz -o "$work/probe"
"$work/probe" "$work/adler.o" "$work/adler.raw.o" "$work/$rev.classes" | tee "$work/$rev.counts"
awk -v rev="$rev" '
    BEGIN {
        expected["fixed-1"]=2; expected["fixed-16"]=rev=="base"?32:2; expected["fixed-256"]=rev=="base"?512:2
        expected["fixed-stored"]=rev=="base"?4:2; expected["mixed"]=rev=="base"?13:7
        expected["dynamic-first"]=10; expected["stored-only"]=0
    }
    $1 in expected { if ($5 != "builds=" expected[$1]) exit 1; matched++ }
    END { if (matched != 7) exit 1 }
' "$work/$rev.counts"
sha256sum "$work/$rev.classes"
cat > "$work/frame.c" <<'SRC'
#include <stdbool.h>
#include <stdint.h>
#include <string.h>
#include <immintrin.h>
#include "inflate.c"
int normal_entry(const uint8_t *data, uint64_t length, uint8_t *out, uint64_t size)
{
    return inflate_zlib(data, length, out, size);
}
SRC
clang "${flags[@]}" -I "$(dirname "$src")" -fstack-usage -c "$work/frame.c" -o "$work/$rev-frame.o"
awk '{print "stack_usage " $0}' "$work/$rev-frame.su"
