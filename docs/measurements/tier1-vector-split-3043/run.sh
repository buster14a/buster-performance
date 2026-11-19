#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
# Run from a clean checkout of buster at BASE, on a host passing tools/ci/vector-probe.c.
set -euo pipefail
harness=$(realpath "$1")
base=6427879e1143026a12fb0388a20bdea1fe4b2bc5
head=5b855db18a58979a2401234a68d3816a6fdaf73f
test "$(git rev-parse HEAD)" = "$base"
git fetch -q --depth 1 origin "$head"
root=$PWD
src=src/buster/compiler
work=$(mktemp -d)
export BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=none BUSTER_DEBUG_INFO=0
stage=$(bash tools/ci/session-toolchain.sh stage)
export PATH="$stage:$PATH"
clang --version | head -1
bash ./build.sh print-host-flags | tr '\0' ' '
echo
mkdir -p "$work/inputs" "$work/oracle"

# Decode the existing C fixture using the host C compiler. Both source units and all 200 rounds are unchanged.
{
    echo '#include <stdio.h>'
    sed -n '/^static const char check_test_tier1_wide_vectors_header\[/,/^\/\/ Its builds by/{/^\/\/ Its builds by/!p;}' "$src/c_check_tier1_driver_test.c"
    cat <<'C'
int main(void)
{
    const char* names[] = { "tier1-wide-vectors.h", "tier1-wide-vectors.c", "wide-other.c" };
    const char* texts[] = { check_test_tier1_wide_vectors_header, check_test_tier1_wide_vectors_source, check_test_tier1_wide_vectors_other_source };
    for (int i = 0; i < 3; i++)
    {
        FILE* f = fopen(names[i], "w");
        if (f == NULL || fputs(texts[i], f) < 0 || fclose(f) != 0) return 1;
    }
    return 0;
}
C
} > "$work/extract.c"
cc "$work/extract.c" -o "$work/extract"
(cd "$work/inputs" && "$work/extract")

# The production lexer's top-bit reader and low-bit constructor, extracted verbatim including their GNU-vector definitions.
# Two external pointer entry points make the always-inline functions observable in a separate object.
lexer=$src/c_lexer.c
{
    echo '#include <stdint.h>'
    sed -n '/^#define BUSTER_INLINE static inline __attribute__((always_inline))$/p; /^#define BUSTER_LEX_VECTOR_COUNT /p; /^typedef uint64_t U64x8 /p' "$lexer"
    sed -n '/^#else$/,/^#endif$/ { /^#define BUSTER_LEX_LANE(value, index) ((value)\[index\])$/p; /^#define BUSTER_LEX_LANES(...) ((U64x8){ __VA_ARGS__ })$/p; }' "$lexer"
    sed -n '/^BUSTER_INLINE uint64_t bit_511(/,/^}/p; /^BUSTER_INLINE U64x8 bit_0_if(/,/^}/p' "$lexer"
    echo 'uint64_t lex_top(const U64x8* x) { return bit_511(*x); }'
    echo 'void lex_low(U64x8* x, uint64_t condition) { *x = bit_0_if(condition); }'
} > "$work/inputs/lexer.c"
cat > "$work/inputs/lexer-other.c" <<'C'
#include <stdint.h>
#include <stdio.h>
typedef uint64_t V __attribute__((vector_size(64)));
uint64_t lex_top(const V*);
void lex_low(V*, uint64_t);
int main(void)
{
    uint64_t hash = 0;
    for (unsigned k = 0; k < 200; k++)
    {
        V v = { k, 0, 0, 0, 0, 5, 23, (uint64_t)k << 63 };
        hash = hash * 31 + lex_top(&v);
        lex_low(&v, k & 1);
        for (unsigned j = 0; j < 8; j++) hash = hash * 31 + v[j];
    }
    printf("%016llx\n", (unsigned long long)hash);
    return 0;
}
C
for arch in x86-64 x86-64-v2 x86-64-v3; do
    for unit in tier1-wide-vectors lexer; do
        other=wide-other
        if [[ "$unit" = lexer ]]; then other=lexer-other; fi
        clang -w -march="$arch" -O2 -c "$work/inputs/$other.c" -o "$work/oracle/$unit-$arch.o"
        clang -w -march="$arch" -O0 "$work/inputs/$unit.c" "$work/inputs/$other.c" -o "$work/oracle/oracle"
        "$work/oracle/oracle" > "$work/oracle/$unit-$arch.txt"
    done
done
prepare()
{
    local revision=$1 mode=$2 f
    git restore --source="$revision" -- "$src/ir_vector_split.c" "$src/tier1_wide_vectors_test.c"
    if [[ "$mode" = trace ]]; then
        cp "$harness/capture.inc" "$harness/stress.inc" "$src/"
        f=$src/ir_vector_split.c
        sed -i '/^    arena_pop_to(scratch, scratch_mark);$/i#include "capture.inc"' "$f"
        f=$src/tier1_wide_vectors_test.c
        awk '/^static void tier1_wide_vectors\(Tier1WideTest\* test\)$/ {print "#include \"stress.inc\""; print; getline; print; print "    if (getenv(\"BUSTER_SPLIT_STRESS\") != NULL) split_measure_stress(test);"; next} {print}' "$f" > "$work/injected.c"
        cp "$work/injected.c" "$f"
    fi
    ./build.sh --config Release > "$work/build.log" 2>&1 || { tail -80 "$work/build.log"; return 1; }
}
collect()
{
    local side=$1 mode=$2 out="$work/$1-$2" compiler="$root/build/compiler"
    local unit arch debug tag
    mkdir -p "$out"
    if [[ "$mode" = trace ]]; then
        BUSTER_SPLIT_CAPTURE="$out/suite.ir" BUSTER_SPLIT_STRESS=1 "$compiler" test-tier1-wide > "$out/suite.log" 2>&1 || { tail -80 "$out/suite.log"; return 1; }
    else
        "$compiler" test-tier1-wide > "$out/suite.log" 2>&1 || { tail -80 "$out/suite.log"; return 1; }
    fi
    grep -E 'STRESS|wide vectors: [0-9]+ fixtures|checks, [0-9]+ failures' "$out/suite.log"
    for arch in x86-64 x86-64-v2 x86-64-v3; do
        for unit in tier1-wide-vectors lexer; do
            for debug in plain debug; do
                tag=$unit-$arch-$debug
                flags=(--tier1 --tier1-strict --verify --lanes 1 -march="$arch")
                if [[ "$debug" = debug ]]; then flags+=(-g); fi
                env_args=()
                if [[ "$mode" = trace ]]; then env_args+=("BUSTER_SPLIT_CAPTURE=$out/$tag.ir"); fi
                env "${env_args[@]}" "$compiler" "${flags[@]}" -c "$work/inputs/$unit.c" -o "$out/$tag.o" > "$out/$tag.log" 2>&1 || { cat "$out/$tag.log"; return 1; }
                if [[ "$mode" = trace ]]; then
                    test -s "$out/$tag.ir" || { echo "No split for $tag"; cat "$out/$tag.log"; return 1; }
                    sed -n "s/^SPLIT /REAL $side $tag /p" "$out/$tag.log"
                fi
                clang -no-pie "$out/$tag.o" "$work/oracle/$unit-$arch.o" -o "$out/native"
                "$out/native" > "$out/$tag.txt"
                cmp "$out/$tag.txt" "$work/oracle/$unit-$arch.txt"
            done
        done
    done
}
for phase in base-clean base-trace head-trace head-clean; do
    side=${phase%-*}
    mode=${phase#*-}
    rev=$base
    if [[ "$side" = head ]]; then rev=$head; fi
    echo "PHASE $phase $rev"
    prepare "$rev" "$mode"
    collect "$side" "$mode"
done
for artifact in "$work/base-clean"/*.o; do
    name=${artifact##*/}
    for other in base-trace head-trace head-clean; do cmp "$artifact" "$work/$other/$name"; done
    (cd "$work/base-clean" && sha256sum "$name")
done
for artifact in "$work/base-trace"/*.ir; do
    name=${artifact##*/}
    cmp "$artifact" "$work/head-trace/$name"
    (cd "$work/base-trace" && sha256sum "$name")
done
echo 'PASS: all clean and traced objects are byte-identical, all split IR captures are byte-identical, all native outputs agree with Clang.'
