#!/usr/bin/env bash
# sse-probe.sh: src/sse_probe.c (two SSE2 intrinsic loops) by Tier 1, Tier 0 and clang at three targets, each timed
# by src/sse_bench.c (clang -O2), pinned to CPU 2. Run under the lock as one hold. Environment: BUSTER, CLANG.
set -u
cd "$(dirname "$0")"
O=out/sse
mkdir -p $O
head -1 /var/lib/buster-9700x/owner >> holds.txt
$CLANG -O2 -c src/sse_bench.c -o $O/bench.o || exit 1
run()
{
    name=$1
    shift
    if "$@" -c src/sse_probe.c -o $O/$name.o 2> $O/$name.log && $CLANG $O/bench.o $O/$name.o -o $O/$name; then
        echo "$name: $(taskset -c 2 $O/$name)"
        taskset -c 2 perf stat -x, -e cycles:u,instructions:u,ls_bad_status2.stli_other:u -o $O/$name.perf -- $O/$name > /dev/null 2>&1
        echo "$name perf: $(tr '\n' ' ' < $O/$name.perf | sed 's/#[^,]*//g')"
    else
        echo "$name: FAILED $(head -2 $O/$name.log)"
    fi
}
for m in x86-64 x86-64-v3 x86-64-v4; do
    run tier1-$m $BUSTER --tier1 -O2 -march=$m
    run tier0-$m $BUSTER -O2 -march=$m
    run clang-O0-$m $CLANG -O0 -march=$m
    run clang-O2-novec-nounroll-$m $CLANG -O2 -march=$m -fno-vectorize -fno-slp-vectorize -fno-unroll-loops
done
$BUSTER --tier1 --tier1-report --tier1-refusals -O2 -march=x86-64 -c src/sse_probe.c -o /dev/null 2>&1 | cut -f1-12
sha256sum $O/*.o | head -20
