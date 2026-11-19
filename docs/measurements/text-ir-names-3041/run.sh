#!/usr/bin/env bash
# Run from a disposable clone of buster on a hosted AVX-512 Linux VM.
set -euo pipefail
driver=$(cd -- "$(dirname -- "$0")" && pwd)
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=7dafd2f7d2e9fc35b9194e2b7c3e81f261ed399e
test -z "$(git status --porcelain --untracked-files=no)"
test "$(git rev-parse HEAD)" = "$base"
git fetch --depth=1 origin "$head"
out=$(mktemp -d)
export BUSTER_HOST_ARCH=vector BUSTER_DEBUG_INFO=0 BUSTER_SANITIZER=none BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_LINKER=auto
tool_path=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$tool_path:$PATH"
clang --version
cmake --version | head -n1
ninja --version
cat > "$out/deal.c" <<'C'
#include "buster/compiler/test_deal.h"
uint64_t schedule_time(const uint64_t *w, const uint64_t *h, const uint64_t *p, uint64_t n, const uint64_t *a, uint64_t bin, uint64_t cpus, uint64_t budget, uint64_t *ends, uint64_t *holds, uint64_t *memories)
{
    return test_deal_makespan(w, h, p, n, a, bin, cpus, budget, ends, holds, memories);
}
C
emit()
{
    ./build/compiler test-ir-source --print test_deal_makespan -std=c17 -ffreestanding -nostdinc -isystem "$(clang -print-resource-dir)/include" -Isrc "$out/deal.c" > "$out/emitter.log" || { cat "$out/emitter.log"; return 1; }
    awk '/^ir-source: test_deal_makespan as lowered:/{section=1; next} /^ir-source:/{section=0} section' "$out/emitter.log" > "$1"
    grep -q '^function ' "$1"
}
sed -n '/static const char\* const fixtures\[\]/,/};/s/.*"\(tests\/ir\/[^"]*\.ir\)".*/\1/p' src/buster/compiler/ir_parse_test.c > "$out/fixtures.list"
while read -r fixture; do cat "$fixture"; done < "$out/fixtures.list" > "$out/canonical.ir"
test "$(wc -l < "$out/fixtures.list")" = 36
mkdir "$out/errors" "$out/base" "$out/head"
bad()
{
    printf '%b' "$2" > "$out/errors/$1.ir"
}
bad empty-type 'function () ->   {\n'
bad type-prefix 'function (i12) -> void {\n'
bad type-suffix 'function () -> i128extra {\n'
bad empty-op 'function () -> void {\nb0:\n  %0 = .i32\n'
bad prefix 'function () -> void {\nb0:\n  %0 = call_indirec.void\n'
bad suffix 'function () -> void {\nb0:\n  %0 = call_indirectx.void\n'
bad last-op 'function () -> void {\nb0:\n  %0 = scattxr.void\n'
bad empty-at-eof 'function () -> void {\nb0:\n  %0 = '
bad predicate 'function () -> void {\nb0:\n  %0 = undef.i64\n  %1 = icmp.i1 %0, %0 ulte\n'
bad order 'function () -> void {\nb0:\n  %0 = fence.void acq_relaxed\n'
bad intrinsic 'function () -> void {\nb0:\n  %0 = undef.i64\n  %1 = intrinsic.i64 %0, %0 lane_unaryx\n'
bad invalid-op 'function () -> void {\nb0:\n  %0 = invalid.void\n}\n'
bad verifier 'function () -> void {\nb0:\n  %0 = copy.i64 %0\n  %1 = ret.void\n}\n'
{ printf 'function () -> '; printf 'i%0258d' 0; printf ' {\n'; } > "$out/errors/long.ir"
for role in base head; do
    if [ "$role" = head ]; then git switch --detach "$head"; fi
    printf '\n%s ' "$role"
    git rev-parse HEAD
    ./build.sh print-compile-flags --config Release > "$out/$role.flags"
    sha256sum "$out/$role.flags"
    git apply "$driver/instrument-$role.patch"
    ./build.sh --config Release
    ./build/compiler test-ir-parse
    if [ "$role" = base ]; then
        emit "$out/emitted.ir"
        wc -c "$out/canonical.ir" "$out/emitted.ir"
        sha256sum "$out/canonical.ir" "$out/emitted.ir"
    else
        emit "$out/head-emitted.ir"
        cmp "$out/emitted.ir" "$out/head-emitted.ir"
    fi
    for name in canonical emitted; do
        printf '%s %s ' "$role" "$name"
        BUSTER_COUNT_IR_NAMES=1 ./build/compiler interpret-ir --print "$out/$name.ir" > "$out/$role/$name.out"
        cmp "$out/$name.ir" "$out/$role/$name.out"
        ./build/compiler interpret-ir --print "$out/$role/$name.out" > "$out/reprint.ir"
        cmp "$out/$role/$name.out" "$out/reprint.ir"
    done
    for path in "$out"/errors/*.ir; do
        name=$(basename "$path" .ir)
        status=0
        ./build/compiler interpret-ir --print "$path" > "$out/$role/$name.stdout" 2> "$out/$role/$name.stderr" || status=$?
        test "$status" -ne 0
        test ! -s "$out/$role/$name.stdout"
        grep -q 'IR parse error' "$out/$role/$name.stderr"
        printf '%s\n' "$status" > "$out/$role/$name.status"
        if [ "$role" = head ]; then
            for field in status stdout stderr; do cmp "$out/base/$name.$field" "$out/head/$name.$field"; done
            cat "$out/head/$name.stderr"
        fi
    done
    git restore src/buster/compiler/ir_parse.c
done
cmp "$out/base.flags" "$out/head.flags"
./build.sh --config Release
./build/compiler test-ir-parse
nm -S --size-sort build/compiler | awk '$NF ~ /ir_(type|op|intrinsic)_name_lengths/ { print }' | tee "$out/length-symbols"
test -s "$out/length-symbols"
for name in canonical emitted; do
    ./build/compiler interpret-ir --print "$out/$name.ir" > "$out/clean.ir"
    cmp "$out/$name.ir" "$out/clean.ir"
done
git diff --exit-code
echo "PASS: two identical canonical prints per role and input, matching emitted IR, all 14 diagnostics and identical compile flags."
