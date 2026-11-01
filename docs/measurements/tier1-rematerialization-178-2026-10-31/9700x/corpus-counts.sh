#!/usr/bin/env bash
# corpus-counts.sh COMPILER CORPORA CTS SUBSET [PATH-OPTION]: --tier1 -c's report on c-testsuite's subset, the frozen
# sqlite3.c and musl's units, with and without rematerialization (#178), each corpus one command whose units' reports the
# driver sums (musl's a directory at a time: two directories may have units of one name, whose objects -c can't both
# write), pinned to CPU 2.
set -u
compiler=$1
corpus=$2
cts=$3
subset=$4
path=${5:-}
musl="$corpus/libc/musl"
work=$(mktemp -d)
fields='^(functions|tier1|records|spill_stores|spill_loads|call_stores|call_loads|rematerializations|dropped_definitions|edge_moves|spill_slots|frame_bytes)='
report() { # name mode command...
    local name=$1 mode=$2
    shift 2
    rm -rf "$work"/* && cd "$work" || exit 1
    local line
    line=$(taskset -c 2 "$@" 2>&1 | grep '^tier1	functions=')
    echo "$name $mode $(echo "$line" | tr '\t' '\n' | grep -E "$fields" | tr '\n' ' ')"
}
for mode in remat noremat; do
    extra=(--tier1 --tier1-report -fno-asynchronous-unwind-tables -c $path)
    [ $mode = noremat ] && extra+=(--tier1-no-rematerialize)
    report c-testsuite $mode "$compiler" "${extra[@]}" $(sed -n "s|^\([0-9][0-9]*\)$|$cts/tests/single-exec/\1.c|p" "$subset")
    report sqlite3 $mode "$compiler" "${extra[@]}" --predefines "$corpus/provenance/gnu17-pinned-predefines.txt" --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc \
        -isystem "$corpus/headers/usr/lib/clang/23/include" -isystem "$corpus/headers/usr/local/include" -isystem "$corpus/headers/usr/include" "$corpus/sqlite/sqlite3.c"
    for directory in "$musl"/src/*/ "$musl"/src/*/x86_64/; do
        units=("$directory"*.c)
        [ -e "${units[0]}" ] || continue
        report musl-part $mode "$compiler" "${extra[@]}" --target=x86_64-linux-gnu -march=znver5 -std=c99 -ffreestanding -nostdinc -D_XOPEN_SOURCE=700 -Os \
            -I "$musl/arch/x86_64" -I "$musl/arch/generic" -I "$corpus/musl-generated/obj/src/internal" -I "$musl/src/include" -I "$musl/src/internal" -I "$corpus/musl-generated/obj/include" -I "$musl/include" \
            "${units[@]}"
    done | awk -v mode=$mode '{ for (i = 3; i <= NF; i += 1) { split($i, kv, "="); sum[kv[1]] += kv[2]; if (!(kv[1] in seen)) { seen[kv[1]] = 1; order[++n] = kv[1] } } }
        END { printf "musl %s ", mode; for (i = 1; i <= n; i += 1) printf "%s=%d ", order[i], sum[order[i]]; printf "\n" }'
done
rm -rf "$work"
