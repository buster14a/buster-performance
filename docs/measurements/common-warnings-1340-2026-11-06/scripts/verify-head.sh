#!/bin/bash
# verify-head.sh: build `git archive ac819d97` (native) and compare its code and data sections with bin/compiler-head's.
set -u
D=/home/david/.cache/droid-1340
tree=$D/tree-head
log=$D/verify-head.log
: > "$log"
if [[ ! -f $tree/COMMIT ]]; then
    mkdir -p "$tree"
    (set -o pipefail; git -C "$D/wt" archive ac819d97a2208b98b4703ca7a32c742c2772e5b2 | tar -x -C "$tree") || exit 2
    echo ac819d97a2208b98b4703ca7a32c742c2772e5b2 > "$tree/COMMIT"
fi
(cd "$tree" && ./build.sh) > "$D/build-tree-head.log" 2>&1 || { echo "build failed" >> "$log"; exit 1; }
for b in "$tree/build/compiler" "$D/bin/compiler-head" "$D/wt/build/compiler" "$D/bin/compiler-gate"; do
    for s in .text .rodata .data; do
        objcopy -O binary --only-section=$s "$b" "$D/sec.bin"
        printf '%s %s %s\n' "$(sha256sum < "$D/sec.bin" | cut -d' ' -f1)" "$s" "${b#$D/}" >> "$log"
    done
done
rm -f "$D/sec.bin"
echo all-done >> "$log"
