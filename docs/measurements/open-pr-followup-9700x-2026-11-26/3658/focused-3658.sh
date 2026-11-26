set -euo pipefail
out="$PWD/followup-9700x/3658"
for side in base3597 pr3658; do
    "$side/build/compiler" --tier1 --tier1-strict --verify --tier1-report -O2 -march=znver5 -c remaining-vector-kernels.c -o "$out/$side-kernel.o" > "$out/$side-kernel.report" 2>&1
    clang -O2 -march=znver5 -no-pie remaining-vector-driver.c "$out/$side-kernel.o" -o "$out/$side-kernel.bin"
    objdump -dr "$out/$side-kernel.o" > "$out/$side-kernel.asm"
done
clang -O2 -march=znver5 -no-pie remaining-vector-driver.c remaining-vector-kernels.c -o "$out/clang-kernel.bin"
for n in 4 8 16; do
    taskset -c 2 "$out/clang-kernel.bin" "$n" > "$out/kernel-$n-oracle.out"
    for round in 0 1 2 3 4; do
        sides=(base3597 pr3658)
        if ((round % 2)); then sides=(pr3658 base3597); fi
        for side in "${sides[@]}"; do
            label="$out/kernel-$n-$round-$side"
            taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$label.csv" -- "$out/$side-kernel.bin" "$n" > "$label.out"
            cmp "$label.out" "$out/kernel-$n-oracle.out"
        done
    done
done
