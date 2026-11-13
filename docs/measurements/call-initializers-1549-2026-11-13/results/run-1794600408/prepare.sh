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
