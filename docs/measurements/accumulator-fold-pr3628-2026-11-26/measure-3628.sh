set -euo pipefail
mkdir -p evidence-3628
cat /proc/loadavg > evidence-3628/load-before.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> evidence-3628/load-before.txt
clang -O2 -c driver.c -o driver.o
base/build/compiler --tier1 --tier1-strict --tier1-passes=-vectorize -march=znver5 -c kernels.c -o kernel-base.o
pr3628/build/compiler --tier1 --tier1-strict --tier1-passes=-vectorize -march=znver5 -c kernels.c -o kernel-head.o
clang -O2 -fno-vectorize -fno-slp-vectorize -march=znver5 -c kernels.c -o kernel-clang.o
sha256sum kernels.c driver.c kernel-*.o > evidence-3628/hashes.txt
for side in base head clang; do
    objdump -d "kernel-$side.o" > "evidence-3628/$side.asm"
done
printf '%s\n' 'kernel pad round side output user_cycles user_instructions branch_misses' > evidence-3628/results.txt
for pad in 0 16 32 48; do
    printf '.text\n.balign 64\n.space %s, 0x90\n.section .note.GNU-stack,"",@progbits\n' "$pad" | clang -x assembler -c - -o pad.o
    for side in base head clang; do
        clang -no-pie driver.o pad.o "kernel-$side.o" -o "bench-$side"
        nm -n "bench-$side" | awk '$3 == "k_equal" || $3 == "k_best" || $3 == "k_sum"' >> "evidence-3628/placement-$pad-$side.txt"
    done
    for kernel in equal best sum; do
        output=$(taskset -c 2 ./bench-clang "$kernel")
        for round in 0 1 2 3 4; do
            variants=(base head)
            if (( round % 2 )); then variants=(head base); fi
            for side in "${variants[@]}"; do
                stats="evidence-3628/$kernel-$pad-$round-$side.csv"
                actual=$(taskset -c 2 perf stat --no-big-num -x, -e cycles:u,instructions:u,branch-misses:u -o "$stats" -- "./bench-$side" "$kernel")
                [[ "$actual" == "$output" ]]
                counters=$(awk -F, '$3 ~ /^(cycles|instructions|branch-misses):u$/ && $1 ~ /^[0-9]+$/ { values[$3]=$1 }
                    END { if (length(values) != 3) exit 1; print values["cycles:u"], values["instructions:u"], values["branch-misses:u"] }' "$stats")
                printf '%s %s %s %s %s %s\n' "$kernel" "$pad" "$round" "$side" "$actual" "$counters" >> evidence-3628/results.txt
            done
        done
    done
done
cat /proc/loadavg > evidence-3628/load-after.txt
ps -eo psr,pcpu,pid,etimes,user,comm --sort=-pcpu | sed -n '1,10p' >> evidence-3628/load-after.txt
