#!/usr/bin/env bash
set -euo pipefail
here=$(cd -- "$(dirname -- "$0")" && pwd)
dir=src/buster/compiler
pool=$dir/foreign_strings.c
adapter=$dir/foreign_strings_link.c
sed -i 's/BUSTER_ARENA_PUSH_ARRAY(/STRINGS_TRACE_ARRAY(/g; s/\bmemset(/strings_trace_clear(/g' "$pool" "$adapter"
sed -i '/^    strings->size = error ==/a\    strings_trace.pool_size = strings->size;' "$pool"
sed -i '/memcpy(strings.bytes +/i\                strings_trace.copied += strings.lengths[entry];' "$pool"
sed -i '/const SymbolId symbol = imported->symbols\[index\];/i\            strings_trace.original += 1;' "$adapter"
sed -i '/const Elf64_Sym value = import_symbol(.*original->symbols, index);/i\                strings_trace.reads += 1;' "$adapter"
sed -i '/for (SymbolId symbol = 0; .*link->symbols.count; symbol += 1)/{n; a\        strings_trace.translated += 1;
}' "$adapter"
sed -i '/for (SymbolId symbol = 1; symbol < link->symbols.count; symbol += 1)/{n; a\            strings_trace.published += 1;
}' "$adapter"
sed -i '/^static ForeignStringsError foreign_strings_merge(.*output)$/,/^}/ {
    /^    const uint64_t saved = arena->length;/a\    strings_trace_begin(arena);
    /^    return error;/i\    strings_trace_report((unsigned)error, merged.input_bytes, merged.applied);
}' "$adapter"
# Limit the instrumentation to these two adjacent includes in the foreign driver's unity unit.
cp "$here/trace.h" "$dir/foreign_strings_3042_trace.h"
sed -i '/#include "buster\/compiler\/foreign_strings.c"/i\#include "buster/compiler/foreign_strings_3042_trace.h"' "$dir/main.c"
for marker in strings_trace_begin strings_trace_report strings_trace.original strings_trace.reads strings_trace.translated strings_trace.published; do
    test "$(grep -Fc "$marker" "$adapter")" = 1
done
