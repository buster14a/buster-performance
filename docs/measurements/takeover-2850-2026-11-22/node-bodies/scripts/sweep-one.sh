#!/bin/bash
# sweep-one.sh COMPILER OUT INDEX OPTIONS...: every source of OUT/sources.txt compiled with OPTIONS, without and with
# --node-bodies: a line with the units both compiles accept, those the same (status, diagnostics, object) and those that
# differ, which are listed in OUT/INDEX.differences.
cc=$1; out=$2; index=$3; shift 3
work=$out/work-$index; mkdir -p "$work"
accepted=0; rejected=0; same=0; differ=0
: > "$out/$index.differences"
while IFS= read -r f; do
    "$cc" --lanes 1 -std=gnu17 "$@" -c -nostdinc "$f" -o "$work/off.o" > "$work/off.err" 2>&1; s0=$?
    "$cc" --lanes 1 --node-bodies -std=gnu17 "$@" -c -nostdinc "$f" -o "$work/on.o" > "$work/on.err" 2>&1; s1=$?
    if [[ $s0 -ne 0 && $s1 -ne 0 ]] && cmp -s "$work/off.err" "$work/on.err"; then rejected=$((rejected + 1)); continue; fi
    accepted=$((accepted + 1))
    if [[ $s0 -eq $s1 ]] && cmp -s "$work/off.err" "$work/on.err" && { [[ $s0 -ne 0 ]] || cmp -s "$work/off.o" "$work/on.o"; }; then same=$((same + 1)); else differ=$((differ + 1)); echo "$f status $s0 $s1" >> "$out/$index.differences"; fi
done < "$out/sources.txt"
echo "[$*] accepted=$accepted rejected-the-same-way=$rejected same=$same DIFFER=$differ"
