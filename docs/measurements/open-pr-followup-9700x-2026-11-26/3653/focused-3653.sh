set -euo pipefail
out="$PWD/followup-9700x/3653"
for tier in tier0 tier1; do
    flags=()
    if [[ "$tier" == tier1 ]]; then flags=(--tier1 --tier1-report); fi
    for side in base3652 pr3653; do
        "$side/build/compiler" "${flags[@]}" -march=znver5 remaining-asm.c -o "$out/$side-$tier.bin" > "$out/$side-$tier.report" 2>&1
    done
    for kernel in mul flags shift cpuid; do
        iterations=20000000
        if [[ "$kernel" == cpuid ]]; then iterations=1000000; fi
        for round in 0 1 2 3 4; do
            sides=(base3652 pr3653)
            if ((round % 2)); then sides=(pr3653 base3652); fi
            for side in "${sides[@]}"; do
                label="$out/$tier-$kernel-$round-$side"
                taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,task-clock -o "$label.csv" -- "$out/$side-$tier.bin" "$kernel" "$iterations" > "$label.out"
            done
            cmp "$out/$tier-$kernel-$round-base3652.out" "$out/$tier-$kernel-$round-pr3653.out"
        done
    done
done
