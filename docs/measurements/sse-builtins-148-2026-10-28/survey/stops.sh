#!/usr/bin/env bash
# Each SSE unit by the given compiler's -c, at the default target and at -march=native: its first error.
set -uo pipefail
compiler="$1"; out="$2"; mkdir -p "$out"
C=/home/david/.cache/claude-148-corpora; U=/home/david/.cache/claude-148-units
for t in default native; do
    flags=(); [ "$t" = native ] && flags=(-march=native)
    for f in stb_image:$C/stb dr_flac:$C/dr_libs dr_mp3:$C/dr_libs minimp3:$C/minimp3 minimp3_ex:$C/minimp3 xxhash:$C/xxhash; do
        n=${f%%:*}; inc=${f#*:}
        timeout 120 "$compiler" -c "${flags[@]}" -I"$inc" -o "$out/$n.$t.o" "$U/$n.c" > "$out/$n.$t.txt" 2>&1; s=$?
        printf '%-11s %-8s %3d  %s\n' "$n" "$t" "$s" "$(grep -m1 -E 'error|fatal' "$out/$n.$t.txt" | sed 's|/home/david/.cache/claude-148-corpora/||' | cut -c 1-200)"
    done
done
