#!/bin/bash
# The record's four kernels (store-motion-3309-2026-11-22/scripts/kernels) in one hold of the lock: each compiled by
# --tier1 without the pass (t1), by #3328's head with it (keep: the stores stay), by this branch (sink: the write-back
# reads the key at the exit) and by its first commit (held: the write-back compares the preheader's value, held in a
# register across the loop), each linked after 0, 16, 32 and 48 bytes of padding; clang -O2 and clang -O2 without
# unrolling or vectors beside them. ROUNDS rounds of every binary pinned to CPU 2, the order rotating by round; perf stat's user task clock, cycles
# and instructions.
W=/tmp/3346-claude
export EXCLUSIVE_OWNER=claude-3346 EXCLUSIVE_TITLE='buster #3346: loop store motion sinks stores (kernels)' EXCLUSIVE_LINK=https://claude.ai/code/session_01Egbxnh2KB6UMiNcgm6mK5q
L=$HOME/buster-fast-bench/exclusive.sh
ROUNDS=${ROUNDS:-5}
cd $W/kernels || exit 1
cat > run-all.sh <<'INNER'
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
INNER
chmod +x run-all.sh
$L ./run-all.sh $W/tree/build/compiler $W/base/build/compiler $W/keep/build/compiler $ROUNDS > results.txt 2> lock.txt
