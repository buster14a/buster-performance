#!/bin/bash
# The compiler's own main.c at base compiled -c by base and head, one hold each, as code shapes: .text bytes and calls.
set -euo pipefail
cd ~/buster-fast-bench/1549-claude
out=results/self-$(date +%s)
mkdir -p "$out"
unset CPATH C_INCLUDE_PATH
for t in base head; do
    ./lock.sh "$out/self-$t" bash -c "cd base && ../$t/build/compiler -w -c -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing src/buster/compiler/main.c -o ../$out/self-$t.o" > "$out/self-$t-receipt.txt"
    echo "$t text=$(size -A "$out"/self-$t.o | awk '/^\.text /{print $2}') memmove=$(objdump -dr "$out"/self-$t.o | grep -c 'R_X86_64_PLT32	memmove') memcpy=$(objdump -dr "$out"/self-$t.o | grep -c 'R_X86_64_PLT32	memcpy')"
done | tee "$out/shape.txt"
sha256sum "$out"/*.o | tee "$out/sha256.txt"
