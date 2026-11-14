#!/bin/bash
# The kernels: one hold compiles and links them; then every executable runs in its own hold, once per round, five
# rounds in an order that rotates by round, pinned to CPU 2.
set -euo pipefail
cd ~/buster-fast-bench/1549-claude
out=results/run-$(date +%s)
mkdir -p "$out/bin"
cat > "$out/prepare.sh" <<'PREP'
set -euo pipefail
out=$1
clang --version | head -1 > "$out/clang.txt"
clang -O2 -c k/driver.c -o "$out/bin/driver.o"
for tree in base head; do
    for tier in t0 t1; do
        flag=""; [ $tier = t1 ] && flag=--tier1
        $tree/build/compiler -c $flag k/kernel.c -o "$out/bin/kernel-$tree-$tier.o"
    done
done
clang -O0 -c k/kernel.c -o "$out/bin/kernel-clang-o0.o"
clang -O2 -fno-vectorize -c k/kernel.c -o "$out/bin/kernel-clang-o2.o"
for c in base-t0 head-t0 base-t1 head-t1 clang-o0 clang-o2; do clang "$out/bin/driver.o" "$out/bin/kernel-$c.o" -o "$out/bin/kernel-$c"; done
sha256sum "$out"/bin/* > "$out/sha256.txt"
PREP
./lock.sh "$out/prepare" bash "$out/prepare.sh" "$out" > "$out/prepare.log"
kernels="base-t0 head-t0 base-t1 head-t1 clang-o0 clang-o2"
set -- $kernels; nk=$#
for round in 1 2 3 4 5; do
    set -- $kernels
    for ((r = 0; r < (round - 1) % nk; r++)); do set -- "$@" "$1"; shift; done
    for c in "$@"; do
        ./lock.sh "$out/runs" taskset -c 2 "$out/bin/kernel-$c" > "$out/one.txt"
        grep '^receipt ' "$out/one.txt" | sed "s/^/$round $c /" >> "$out/receipts.txt"
        grep -v '^receipt ' "$out/one.txt" | sed "s/^/$round $c /" >> "$out/kernels.txt"
    done
done
rm -f "$out/one.txt"
echo "$out"
