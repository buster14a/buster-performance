#!/usr/bin/env bash
# Called from a compiler checkout with a clean vector Release build.
set -euo pipefail
record=$(cd -- "$(dirname -- "$0")" && pwd)
out=$1
mkdir -p "$out"
clang -std=c17 -O2 -Wall -Wextra -Werror "$record/stress.c" -o "$out/generate"
"$out/generate" > "$out/stress.ir"
cat > "$out/fit.c" <<'EOF'
#include "buster/compiler/test_deal.h"
bool fit(uint64_t peak, uint64_t used, uint64_t running, uint64_t budget)
{
    return test_deal_memory_fits(peak, used, running, budget);
}
uint64_t schedule(const uint64_t *weights, const uint64_t *held, const uint64_t *peaks, uint64_t count, const uint64_t *assigned, uint64_t bin, uint64_t cpus, uint64_t budget, uint64_t *ends, uint64_t *holds, uint64_t *memories)
{
    return test_deal_makespan(weights, held, peaks, count, assigned, bin, cpus, budget, ends, holds, memories);
}
EOF
emit()
{
    local name=$1 file=$2
    ./build/compiler test-ir-source --print "$name" -std=c17 -ffreestanding -nostdinc -isystem "$(clang -print-resource-dir)/include" -Isrc "$out/fit.c" > "$out/$name.txt"
    awk -v title="ir-source: $name as promoted:" '$0==title{keep=1; next} keep && /^function /{body=1} body{print} body && /^}/{exit}' "$out/$name.txt" > "$out/$file.ir"
    grep -q '^function ' "$out/$file.ir"
    grep -q ' = phi\.' "$out/$file.ir"
}
emit test_deal_memory_fits real
emit test_deal_makespan schedule
wc -cl "$out"/{real,schedule,stress}.ir
sha256sum "$out"/{real,schedule,stress}.ir
