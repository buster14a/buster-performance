#!/bin/bash
# placements.sh LABEL...: where each build's executable has the front's functions, T, and the function with the
# window's passes inlined: the address, its offset in its 64-byte line and its 4 KB page, and the size.
cd "$(dirname "$0")"
for l in "$@"; do
    for f in node_front_chunk_window node_front_chunk_lean node_front_keep node_machine_type node_facts_reader_flush node_census_reader_expression; do
        nm -S results/$l/compiler | grep -w "$f" | head -1 | awk -v l=$l -v f=$f '{ a = strtonum("0x" $1); printf "%s %s: at %s (line offset %d, page offset %d) size %d\n", l, f, $1, a % 64, a % 4096, strtonum("0x" $2) }'
    done
done
