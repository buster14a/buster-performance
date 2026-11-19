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
EOF
./build/compiler test-ir-source --print test_deal_memory_fits -std=c17 -ffreestanding -nostdinc -isystem "$(clang -print-resource-dir)/include" -Isrc "$out/fit.c" > "$out/emitted.txt"
awk '/^ir-source: test_deal_memory_fits as promoted:/{keep=1; next} keep && /^function /{body=1} body{print} body && /^}/{exit}' "$out/emitted.txt" > "$out/real.ir"
grep -q '^function ' "$out/real.ir"
grep -q ' = phi\.' "$out/real.ir"
wc -cl "$out"/{real,stress}.ir
sha256sum "$out"/{real,stress}.ir
