#!/bin/bash
# owners.sh NM OUT PIECES: OUT/ownedK.txt, the named local variables piece K defines first (llvm-nm's d, b or r),
# each file rewritten only when it changes.
nm=$1; out=$2; pieces=$3
for k in $(seq 0 $((pieces - 1))); do
    "$nm" --defined-only "$out/p$k.bc" | awk -v k="$k" '$2 ~ /^[dbr]$/ {print k, $3}'
done | awk -v out="$out" '!($2 in owner) {owner[$2] = $1; print $2 > (out "/owned" $1 ".next")}'
for k in $(seq 0 $((pieces - 1))); do
    touch "$out/owned$k.next"
    if cmp -s "$out/owned$k.next" "$out/owned$k.txt"; then rm "$out/owned$k.next"; else mv "$out/owned$k.next" "$out/owned$k.txt"; fi
done
