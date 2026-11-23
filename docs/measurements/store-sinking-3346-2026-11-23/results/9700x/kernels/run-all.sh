#!/bin/bash
C=$1; B=$2; H=$3; ROUNDS=$4
echo "receipt: $(head -1 /var/lib/buster-9700x/owner) at $(date -u +%FT%TZ)"
sha256sum $C $B $H
clang --version | head -1
for n in 0 16 32 48; do printf '.text\n.skip %d, 0xcc\n.section .note.GNU-stack,"",@progbits\n' $n > pad$n.s; clang -c pad$n.s -o pad$n.o || exit 1; done
for k in k1 k2 k3 k4; do
    $C --tier1 -c -o $k-t1.o $k.c && $B --tier1 --tier1-passes=+storemotion -c -o $k-keep.o $k.c && $C --tier1 --tier1-passes=+storemotion --tier1-report -c -o $k-sink.o $k.c 2> $k-sink.report && $H --tier1 --tier1-passes=+storemotion -c -o $k-held.o $k.c || { echo "$k build failed"; continue; }
    grep -h store-motion $k-sink.report | sed "s/^/report $k /"
    objdump -d --no-show-raw-insn $k-sink.o | sed -n '/<f>:/,/^$/p' | sed "s/^/asm $k sink /"
    builds=""
    for b in t1 keep sink held; do
        for n in 0 16 32 48; do clang -o $k-$b-p$n pad$n.o $k-$b.o || echo "$k $b p$n link failed"; builds="$builds $b-p$n"; done
    done
    clang -O0 -o $k-c0 $k.c && clang -O2 -o $k-c2 $k.c && clang -O2 -fno-unroll-loops -fno-vectorize -fno-slp-vectorize -o $k-c2n $k.c || echo "$k clang build failed"
    builds="$builds c2 c2n"
    ./$k-c0 > out-$k-c0.txt
    for b in $builds; do
        ./$k-$b > out-$k-$b.txt; cmp -s out-$k-c0.txt out-$k-$b.txt || echo "$k $b OUTPUT DIFFERS"
    done
    echo "output $k $(cat out-$k-c0.txt)"
    for r in $(seq $ROUNDS); do
        for b in $builds; do
            taskset -c 2 perf stat -x, -e task-clock:u,cycles:u,instructions:u -o stat.txt ./$k-$b > /dev/null
            echo "run $k $b $r $(cut -d, -f1 stat.txt | grep -E "^[0-9]" | tr "\n" " ")"
        done
        builds="${builds#* } ${builds%% *}"; builds="${builds# }"
    done
done
echo done
