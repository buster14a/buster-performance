# #1834's intrinsic sweep as target_clones bodies (2026-11-14)

This records the check behind buster14a/buster#2707 (#1834): which x86 builtins a `target_clones` body's `default` copy
still refuses where clang -O0 compiles them. Clang checks a `target_clones` body against its first version's features,
then LLVM legalizes the `default` copy's builtins with the copy's own instructions, so such a copy reaches builtins
that clang refuses in any other function at the same `-march`.

## Harness

- The cases are `genintrin.py`'s function-like macro intrinsics (2,142 of them) from
  [vector-baseline-sweep-1834-2026-11-11](../vector-baseline-sweep-1834-2026-11-11), whose README says how to make
  `hdr.i`, `macros.txt` and `intrin.txt` (clang 23.1.6). A macro intrinsic is a builtin's call in the body itself, where
  a function intrinsic would be an out-of-line call in the `default` copy (an `always_inline` callee its features lack).
- `cases.sh intrin.txt tcases` writes each into a `target_clones("arch=znver5","default")` body that stores its value
  through a pointer (`__auto_type`, so a vector's type needs no spelling and no vector crosses the ABI).
- That record's `run1.sh COMPILER MARCH CASE.c` compiles each: `ok`, `fail <Buster's first error>`, or `clangfail`
  where clang -O0 -c refuses it too.

```sh
./cases.sh intrin.txt tcases
for m in x86-64 x86-64-v2 x86-64-v3; do ls tcases/*.c | xargs -P4 -n1 ./run1.sh build/compiler $m | sort > target-clones-$m.txt; done
```

## Build

buster14a/buster#2707's head `e3605fe` (main `8023523` plus the SSE2 sequences), a Develop build in a cloud
container (Intel Xeon @ 2.10 GHz with AVX-512). Compile-only results, not timings.

## Results

| level | ok | Buster refuses | clang refuses (or its backend fails) |
| --- | ---: | ---: | ---: |
| x86-64 | 79 | 150 | 1913 |
| x86-64-v2 | 100 | 152 | 1890 |
| x86-64-v3 | 124 | 150 | 1868 |

- **#1834's list compiles at every level:** `_mm_alignr_epi8`, `_mm_blend_epi16`, `_mm_blend_ps`, `_mm_blend_pd`,
  `_mm_blend_epi32`, `_mm_extract_epi8`, `_mm_insert_epi8`/`32`/`64`, `_mm_permute_pd`, `_mm_cmp_ps`, `_mm_cmp_pd`,
  and their 256-bit forms on halves.
- **Clang's backend fails** on `_mm_round_ps`/`_pd`, `_mm_floor_ps`, `_mm_ceil_pd`, `_mm_dp_ps` and `_mm_mpsadbw_epu8`
  in such a copy ("Cannot select"), so they are `clangfail`; Buster refuses them by name.
- **What Buster still refuses** (`results/`, case by case) is outside #1834's list:
  - the AVX-512 macros: `_mm*_cmp_*_mask` and their masked forms, `_mm*_alignr_epi32`/`64`, `_mm*_ternarylogic_*`,
    `_mm*_rol`/`ror`, `_mm*_shldi`/`shrdi`, `_mm*_shuffle_[if]32x4`/`64x2`, the `insert`/`extract` of 128- and
    256-bit lanes, `_mm512_permutex*`, `_mm512_shuffle*`, `_mm512_bslli`/`bsrli`, `_mm*_roundscale_*`;
  - AVX2's gathers by a vector mask (`_mm_mask_i32gather_epi32` and the others) at x86-64 and -v2;
  - at -v3 one more, `_cvtss_sh`: "invalid or unsupported declaration", an x86 builtin's call in a statement
    expression that initializes an `__auto_type` declaration, a checker bug of its own and no lowering's.
