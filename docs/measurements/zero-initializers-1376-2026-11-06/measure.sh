#!/bin/bash
# The kernels and the threshold sweep, every executable in each round in a rotated order, pinned to CPU 2. Run under the lock.
set -euo pipefail
cd ~/buster-fast-bench/1376-opencode
out=results/run-$(date +%s)
mkdir -p "$out/bin"
k=k
clang --version | head -1 > "$out/clang.txt"
clang -O2 -c $k/driver.c -o "$out/bin/driver.o"
clang -O2 -c $k/szdrv.c -o "$out/bin/szdrv.o"
for tree in base head fill8; do
    for tier in t0 t1; do
        flag=""; [ $tier = t1 ] && flag=--tier1
        $tree/build/compiler -c $flag $k/kernel.c -o "$out/bin/kernel-$tree-$tier.o"
        $tree/build/compiler -c $flag $k/sz.c -o "$out/bin/sz-$tree-$tier.o"
    done
done
clang -O0 -c $k/kernel.c -o "$out/bin/kernel-clang-o0.o"; clang -O0 -c $k/sz.c -o "$out/bin/sz-clang-o0.o"
clang -O2 -fno-vectorize -c $k/kernel.c -o "$out/bin/kernel-clang-o2.o"
kernels="base-t0 head-t0 base-t1 head-t1 clang-o0 clang-o2"
sizes="base-t0 head-t0 fill8-t0 base-t1 head-t1 fill8-t1 clang-o0"
for c in $kernels; do clang "$out/bin/driver.o" "$out/bin/kernel-$c.o" -o "$out/bin/kernel-$c"; done
for c in $sizes; do clang "$out/bin/szdrv.o" "$out/bin/sz-$c.o" -o "$out/bin/sz-$c"; done
sha256sum "$out"/bin/* > "$out/sha256.txt"
set -- $kernels; nk=$#
for round in 1 2 3 4 5; do
    set -- $kernels
    for ((r = 0; r < (round - 1) % nk; r++)); do set -- "$@" "$1"; shift; done
    for c in "$@"; do taskset -c 2 "$out/bin/kernel-$c" | sed "s/^/$round $c /" >> "$out/kernels.txt"; done
    set -- $sizes
    for ((r = 0; r < (round - 1) % 7; r++)); do set -- "$@" "$1"; shift; done
    for c in "$@"; do taskset -c 2 "$out/bin/sz-$c" | sed "s/^/$round $c /" >> "$out/sizes.txt"; done
done
echo "$out"
