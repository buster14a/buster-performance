#!/usr/bin/env bash
set -euo pipefail
# This script runs from the compiler root on an AVX-512 hosted VM.
driver=$(cd -- "$(dirname -- "$0")" && pwd)
out=$(mktemp -d)
tool_path=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$tool_path:$PATH"
clang --version
cmake --version | head -n1
ninja --version
git rev-parse HEAD
./build.sh --config Release
./build/compiler test-ir-parse
cat > "$out/deal.c" <<'C'
#include "buster/compiler/test_deal.h"
uint64_t schedule_time(const uint64_t *w, const uint64_t *h, const uint64_t *p, uint64_t n, const uint64_t *a, uint64_t bin, uint64_t cpus, uint64_t budget, uint64_t *ends, uint64_t *holds, uint64_t *memories)
{
    return test_deal_makespan(w, h, p, n, a, bin, cpus, budget, ends, holds, memories);
}
C
./build/compiler test-ir-source --print test_deal_makespan -std=c17 -ffreestanding -nostdinc -isystem "$(clang -print-resource-dir)/include" -Isrc "$out/deal.c" > "$out/emitter.log" || { cat "$out/emitter.log"; exit 1; }
awk '/^ir-source: test_deal_makespan as lowered:/{section=1; next} /^ir-source:/{section=0} section' "$out/emitter.log" > "$out/emitted.ir"
grep -q '^function ' "$out/emitted.ir" || { cat "$out/emitter.log"; exit 1; }
sed -n '/static const char\* const fixtures\[\]/,/};/s/.*"\(tests\/ir\/[^"]*\.ir\)".*/\1/p' src/buster/compiler/ir_parse_test.c > "$out/fixtures.list"
while read -r fixture; do cat "$fixture"; done < "$out/fixtures.list" > "$out/canonical.ir"
wc -l "$out/fixtures.list" "$out/emitted.ir" "$out/canonical.ir"
wc -c "$out/emitted.ir" "$out/canonical.ir"
sha256sum "$out/"*.ir
python3 "$driver/count.py" base
./build.sh --config Release
for name in canonical emitted; do
    ./build/compiler interpret-ir --print "$out/$name.ir" > "$out/$name.out"
    cmp "$out/$name.ir" "$out/$name.out"
done
