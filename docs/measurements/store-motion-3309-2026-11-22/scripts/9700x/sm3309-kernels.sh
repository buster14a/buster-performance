#!/bin/bash
# The kernels on the 9700X, in one hold of the lock (about a minute). Each kernel is compiled to an object by Tier 0
# (t0), --tier1 without the pass (t1), --tier1 as it is by default, the pass on (sm), and --tier1 +all (all). Each
# object is linked by clang after 0, 16, 32 and 48 bytes of padding, so that a build's loop is timed at the four places
# a 16-aligned function can take in a 64-byte line: the same loop read 272M and 400M cycles at two of them, which is
# more than the pass's own difference. t1 and sm are also linked by the compiler itself (bl). clang's -O0, -O2 and -O2
# without unrolling or vectors stand beside them. ROUNDS rounds of every binary, pinned to CPU 2, the order rotating by
# round; perf stat's user task clock, cycles and instructions of each run, and each binary's addresses.
W=${W:-/dev/shm/3309-fable}
C=${C:-$W/tree/build/compiler}
export EXCLUSIVE_OWNER=claude-3309-fable EXCLUSIVE_TITLE='buster #3309: loop store motion (kernels)' EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/3328
L=$HOME/buster-fast-bench/exclusive.sh
ROUNDS=${ROUNDS:-5}
cd $W/kernels || exit 1
cat > run-all.sh <<'INNER'
#!/bin/bash
C=$1; ROUNDS=$2
echo "receipt: $(head -1 /var/lib/buster-9700x/owner) at $(date -u +%FT%TZ)"
sha256sum $C
clang --version | head -1
for n in 0 16 32 48; do printf '.text\n.skip %d, 0xcc\n.section .note.GNU-stack,"",@progbits\n' $n > pad$n.s; clang -c pad$n.s -o pad$n.o || exit 1; done
for k in k1 k2 k3 k4; do
    $C -c -o $k-t0.o $k.c && $C --tier1 --tier1-passes=-storemotion -c -o $k-t1.o $k.c && $C --tier1 --tier1-report -c -o $k-sm.o $k.c 2> $k-sm.report && $C --tier1 --tier1-passes=+all -c -o $k-all.o $k.c || { echo "$k build failed"; continue; }
    grep -h store-motion $k-sm.report | sed "s/^/report $k /"
    builds=""
    for b in t0 t1 sm all; do
        for n in 0 16 32 48; do clang -o $k-$b-p$n pad$n.o $k-$b.o || echo "$k $b p$n link failed"; builds="$builds $b-p$n"; done
    done
    $C --tier1 --tier1-passes=-storemotion -o $k-t1-bl $k.c && $C --tier1 -o $k-sm-bl $k.c || echo "$k bl build failed"
    clang -O0 -o $k-c0 $k.c && clang -O2 -o $k-c2 $k.c && clang -O2 -fno-unroll-loops -fno-vectorize -fno-slp-vectorize -o $k-c2n $k.c || echo "$k clang build failed"
    builds="$builds t1-bl sm-bl c0 c2 c2n"
    ./$k-c0 > out-$k-c0.txt
    for b in $builds; do
        ./$k-$b > out-$k-$b.txt; cmp -s out-$k-c0.txt out-$k-$b.txt || echo "$k $b OUTPUT DIFFERS"
        echo "layout $k $b $(nm $k-$b | awk '$3 == "f" || $3 ~ /^g_/ || $3 == "s_n" { printf "%s=%s ", $3, $1 }')"
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
$L ./run-all.sh $C $ROUNDS > results.txt 2> lock.txt
