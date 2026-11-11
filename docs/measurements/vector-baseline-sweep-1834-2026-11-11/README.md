# #1834 vector sweep below AVX-512 (2026-11-11)

This directory records the sweep for buster14a/buster#1834 (part A, package B1). It measures which vector operations Buster refuses by name, at `-march=x86-64`, `x86-64-v2` and `x86-64-v3`, where clang 23 -O0 compiles the same source. The harness and the results are both here. The harness moved here from the WIP branch `claude/1447-vector-baseline` @`7ceb8ca9`, which is not for merging.

The sweep only compiles each case. Run-time agreement with clang is checked in Buster itself, by `test-checker --program-vectors`'s `baseline-*` programs.

## Harness

- `gen.py` writes the **generic** cases: 3,389 C files, one case each. They cover:
  - C's vector operators;
  - the elementwise, reduction, shuffle, conversion, nontemporal and masked builtins;
  - the scalar elementwise builtins.
- `genintrin.py` writes the **intrinsic wrappers**: 6,944 of them, one per function and function-like macro of clang's `immintrin.h` and `x86intrin.h`. Its header gives the `hdr.i` and `macros.txt` inputs it needs.
- `run1.sh COMPILER MARCH CASE.c` compiles one case with `clang -O0 -c` and, where clang accepts it, with Buster's `-c`. It prints `ok`, `fail <Buster's first error>` or `clangfail`.

To reproduce, from a Buster checkout:

```sh
python3 -I gen.py cases
for m in x86-64 x86-64-v2 x86-64-v3; do ls cases/*.c | xargs -P4 -n1 ./run1.sh build/compiler $m | sort > generic-$m.txt; done
# intrinsics: write hdr.i and macros.txt as genintrin.py's header says, then
python3 -I genintrin.py intrin.txt
mkdir icases && while IFS="$(printf '\t')" read -r n code; do printf '#include <immintrin.h>\n#include <x86intrin.h>\n%s\n' "$code" > "icases/$n.c"; done < intrin.txt
for m in x86-64 x86-64-v2 x86-64-v3 native; do ls icases/*.c | xargs -P4 -n1 ./run1.sh build/compiler $m | sort > intrinsics-$m.txt; done
```

## Builds

- **base**: main `457c5893bf`, the package's inventory revision.
- **head**: `d5f6f5174a`, branch `vector/1834-bit-builtins`. It is main plus B1's four PRs:
  - buster14a/buster#2122 (floating elementwise builtins), now merged;
  - #2151 (reductions), now merged;
  - #2173 (masked memory);
  - #2191 (bit builtins).
- Both are Release builds (`./build.sh`) with clang 23.1.6, run in a cloud container (Intel Xeon @ 2.10 GHz with AVX-512, so `native` is an AVX-512 target). These are compile-only results, not timings, so they don't need the 9700X.

## Results

**Generic cases.** Clang accepts 3,198 of the 3,389 at each level. `results/generic-{base,head}-*.txt` have them case by case.

| level | base: ok / refused | head: ok / refused |
| --- | --- | --- |
| x86-64 | 1873 / 1325 | 2672 / 526 |
| x86-64-v2 | 2057 / 1141 | 2848 / 350 |
| x86-64-v3 | 2065 / 1133 | 2841 / 357 |

Every case in B1's families compiles at head at each level: the floating elementwise builtins, the reductions, the masked memory builtins and the bit builtins. Head still refuses:

- **#1834 part B (package B2):**
  - byte and word shuffles without SSSE3, and 32-byte ones at -v3;
  - qword compares, `?:`, `!` and `&&` at x86-64;
  - 64-bit multiplies;
  - conversions;
  - nontemporal loads and stores;
  - qword min/max on SSE2;
  - the scalar IEEE maximum/minimum without AVX.
- **Shifts by a vector of counts** (`a << (b & 31)`): every element size at x86-64 and -v2; bytes, words and qword arithmetic right shifts at -v3. No package holds these; they are filed as their own issue.
- **Refused at native too, so outside #1834:**
  - integer vector division and remainder;
  - dword and qword saturating arithmetic;
  - the scalar integer elementwise builtins;
  - floats' `__builtin_elementwise_abs`, `max` and `min`.

**Intrinsic wrappers, at head.** `results/intrinsics-head-*.txt` list them wrapper by wrapper.

| level | clang accepts | Buster refuses |
| --- | --- | --- |
| x86-64 | 422 | 4: `_mm_maskmove_si64` and `_mm_maskmoveu_si128` ("x86 builtins whose instructions the target hasn't": MASKMOVQ and MASKMOVDQU write through rdi, an implicit register that Tier 0's rows refuse), and `_mm_unpackhi_pi8` and `_mm_unpackhi_pi16` (MMX unpacks, as byte and word shuffles without SSSE3; B2's) |
| x86-64-v2 | 503 | 2: the two `maskmove` wrappers |
| x86-64-v3 | 697 | 2: the two `maskmove` wrappers |
| native | 4049 | 0 |

Clang refuses the rest at each level: they are intrinsics of features the `-march` lacks.
