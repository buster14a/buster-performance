#!/usr/bin/env bash
# attribute.sh BINARY NAME: from $WORK/runs/NAME/profile.fdata (measure.sh's), the taken edges and the conditional
# branches' fall-throughs (edges.txt, by scripts/taken.c, with its totals in totals.txt), their innermost source lines
# (lines.txt: taken, then fall-throughs) and their compiled functions (functions-taken.txt).
set -euo pipefail
here="$(dirname "$(realpath "$0")")"
B=${LLVM:-/usr/lib/llvm-23/bin}
binary="$(realpath "$1")"
out="$WORK/runs/$2"
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
