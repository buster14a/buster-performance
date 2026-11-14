#!/usr/bin/env bash
# vector-copies-ab.sh: src/sse_probe.c and src/avx_probe.c by the base and the patched compiler's Tier 1 and Tier 0, and
# by clang, at each target; each timed by src/sse_bench.c (clang -O2) pinned to CPU 2, with perf stat's user cycles,
# instructions and store-to-load conflicts. Run under the lock as one hold. Environment: BASE, FIX, CLANG.
set -u
cd "$(dirname "$0")"
O=out/ab
mkdir -p $O
head -1 /var/lib/buster-9700x/owner >> holds.txt
$CLANG -O2 -c src/sse_bench.c -o $O/bench.o || exit 1
run()
{
    name=$1
    source=$2
    shift 2
    if "$@" -c $source -o $O/$name.o 2> $O/$name.log && $CLANG $O/bench.o $O/$name.o -o $O/$name; then
        line=$(taskset -c 2 $O/$name)
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u,ls_bad_status2.stli_other:u -o $O/$name.perf -- $O/$name > /dev/null 2>&1
        echo "$name: $line | cycles $(grep cycles $O/$name.perf | cut -d, -f1) instructions $(grep instructions $O/$name.perf | cut -d, -f1) conflicts $(grep stli $O/$name.perf | cut -d, -f1)"
    else
        echo "$name: FAILED $(head -2 $O/$name.log)"
    fi
}
for pair in sse:x86-64 sse:x86-64-v2 sse:x86-64-v3 avx:x86-64-v3 sse:x86-64-v4 avx:x86-64-v4; do
    p=${pair%%:*}
    m=${pair##*:}
    run base-tier1-$p-$m src/${p}_probe.c $BASE --tier1 -O2 -march=$m
    run fix-tier1-$p-$m src/${p}_probe.c $FIX --tier1 -O2 -march=$m
    run base-tier0-$p-$m src/${p}_probe.c $BASE -O2 -march=$m
    run fix-tier0-$p-$m src/${p}_probe.c $FIX -O2 -march=$m
    run clang-O0-$p-$m src/${p}_probe.c $CLANG -O0 -march=$m
    run clang-O2-novec-nounroll-$p-$m src/${p}_probe.c $CLANG -O2 -march=$m -fno-vectorize -fno-slp-vectorize -fno-unroll-loops
done
for m in x86-64 x86-64-v3; do
    echo "report base $m: $($BASE --tier1 --tier1-report -O2 -march=$m -c src/sse_probe.c -o /dev/null 2>&1 | cut -f2-3,17-19,24,28-32)"
    echo "report fix $m: $($FIX --tier1 --tier1-report -O2 -march=$m -c src/sse_probe.c -o /dev/null 2>&1 | cut -f2-3,17-19,24,28-32)"
done
cmp $O/base-tier0-sse-x86-64.o $O/fix-tier0-sse-x86-64.o && echo "tier0 objects identical (sse, x86-64)"
cmp $O/base-tier1-sse-x86-64-v4.o $O/fix-tier1-sse-x86-64-v4.o && echo "tier1 objects identical (sse, x86-64-v4)"
cmp $O/base-tier1-avx-x86-64-v4.o $O/fix-tier1-avx-x86-64-v4.o && echo "tier1 objects identical (avx, x86-64-v4)"
sha256sum $BASE $FIX
