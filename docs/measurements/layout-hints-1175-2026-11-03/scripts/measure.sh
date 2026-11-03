#!/usr/bin/env bash
# measure.sh BINARY NAME [MODE]: instruments BINARY (linked with --emit-relocs) with BOLT, compiles the frozen sqlite3.c
# with it (MODE fsyntax, the default, is -fsyntax-only; c is -c --lanes 1, since znver5's mwaitx can't run on an Intel
# host), and writes under $WORK/runs/NAME: profile.fdata (BOLT's edge counts), dyno.txt (BOLT's dyno stats of BINARY's
# own layout), edges.txt (taken edges and the conditional branches' fall-throughs, by scripts/taken.c), lines.txt
# (taken and fall-through counts by innermost source line) and functions-taken.txt (taken by compiled function).
# $WORK holds corpus/ (buster's tools/ci/fetch-corpus.sh output) and runs/; LLVM is LLVM 23's bin directory.
set -euo pipefail
here="$(dirname "$(realpath "$0")")"
B=${LLVM:-/usr/lib/llvm-23/bin}
binary="$(realpath "$1")"
out="$WORK/runs/$2"
mode="${3:-fsyntax}"
mkdir -p "$out"
sq="$WORK/corpus/sqlite"
options=(-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE "-I$sq" "$sq/sqlite3.c")
"$B/llvm-bolt" "$binary" -instrument -strict -instrumentation-file="$out/profile.fdata" -o "$out/instrumented" > "$out/instrument.log" 2>&1
rm -f "$out/profile.fdata"
if [ "$mode" = c ]; then
    "$out/instrumented" -c --lanes 1 "${options[@]}" -o "$out/sqlite3.o"
else
    "$out/instrumented" -fsyntax-only "${options[@]}"
fi
"$B/llvm-bolt" "$binary" -strict -data="$out/profile.fdata" -dyno-stats -o /dev/null > "$out/dyno.log" 2>&1
sed -n '/program-wide dynostats/,/all conditional branches/p' "$out/dyno.log" > "$out/dyno.txt"
nm -p --defined-only -S "$binary" > "$out/nm.txt"
awk '$1 == 1 { print $2 } $4 == 1 { print $5 }' "$out/profile.fdata" | sed 's|/[0-9]*$||' | sort -u | paste -sd, - > "$out/functions.txt"
"$B/llvm-objdump" -d --no-show-raw-insn --disassemble-symbols="$(cat "$out/functions.txt")" "$binary" > "$out/objdump.txt" 2> /dev/null
"$here/taken" "$out/nm.txt" "$out/profile.fdata" "$out/objdump.txt" > "$out/edges.txt" 2> "$out/totals.txt"
cut -d' ' -f1 "$out/edges.txt" | sort -u | sed 's/^/0x/' > "$out/addresses.txt"
"$B/llvm-symbolizer" --obj="$binary" --inlines --relativenames < "$out/addresses.txt" |
    awk 'BEGIN { RS = ""; FS = "\n" } { sub(/:[0-9]+$/, "", $2); print $2 }' > "$out/innermost.txt"
paste -d' ' "$out/addresses.txt" "$out/innermost.txt" | sed 's/^0x//' > "$out/address-lines.txt"
awk 'NR == FNR { line[$1] = $2; next } $3 == "ft" { ft[line[$1]] += $2; next } { taken[line[$1]] += $2 }
     END { for (l in taken) print taken[l], ft[l] + 0, l }' "$out/address-lines.txt" "$out/edges.txt" | sort -rn > "$out/lines.txt"
awk '$3 != "ft" { taken[$4] += $2 } END { for (f in taken) print taken[f], f }' "$out/edges.txt" | sort -rn > "$out/functions-taken.txt"
cat "$out/totals.txt"
grep -E 'taken branches|executed instructions' "$out/dyno.txt" | head -2
