# What `-c` of `main.c` lowers with vectors, function by function, 2026-10-27

Branch `claude/producer-vectors-136` (buster14a/buster, #136) lowers GNU C's and Clang's vector types through Tier 0's
VECTOR class. `-c` stops at the first function its lowering refuses, so this survey patches the lowering to go on past
each refusal and write every function's outcome, its first refusal's reason, to standard error. It was made on the
branch's `68d7d3a0`, locally (a Ryzen 9 7940HS: the survey counts outcomes, it times nothing).

Since #543, `main.c` has `#pragma clang section` lines, which the checker refuses, and a file-scope `asm`, which `-c`
refuses ([#619](https://github.com/buster14a/buster/issues/619)). The survey compiles a copy without those eleven lines
(`main_nosection.c`); they place the checker's code and change nothing the lowering sees.

**What `-c` selects** (the functions `main`, `-c`'s roots, reach, `check_program_select`): 8,489 functions, 358 of them
the headers' intrinsics and 8,131 the compiler's own. 7,966 lower and 523 are refused (`tally_select.txt`):

| First refusal | Functions |
| --- | ---: |
| vector, x86 and bit-cast builtins (#148) | 520 |
| inline assembly operands of this type in their constraint's registers (`shift_in_previous`, `encode_group`) | 2 |
| `_BitInt` (`cbuiltin_test_overflow`) | 1 |

Of the 523, 258 are intrinsics and 265 the compiler's own functions.

**Every definition** (`--lower-all`): 13,850, 5,424 of them the headers' and 8,426 the compiler's own. 8,738 lower
(`tally_all.txt`): 592 of the headers' and 8,146 of the compiler's own. The refusals:

| First refusal | Functions |
| --- | ---: |
| vector, x86 and bit-cast builtins | 4,856 |
| vector types of other than 16, 32 or 64 bytes (MMX's 8-byte `__m64`: `_mm_cvtsi32_si64`, `_mm_packs_pi16`, ...) | 174 |
| floating types other than float, double and long double (AVX512-FP16's `_Float16`: `_mm512_cvtsh_h`, `_mm_setzero_ph`, ...) | 44 |
| vector operations on elements of this type (`_mm512_add_ph`, ...) | 24 |
| values of this type (`_mm_add_sh`, `_mm_store_sh`, ...) | 8 |
| complex types other than `_Complex float`, `double` and `long double` (`_mm_set1_pch`, ...) | 3 |
| inline assembly operands of this type in their constraint's registers | 2 |
| `_BitInt` | 1 |

**Found on the way:** the first run of the survey found three of the headers' functions (`_mm_storeu_si64`, `si32` and
`si16`) that the lowering judged invalid, an internal compiler error: an element of a vector that isn't an lvalue
(`((__v2di)__b)[0]`) left the vector on Tier 0's stack. The branch's `60ed0914` fixes it, with a test program against
clang -O0; this survey is of the fixed head.

## Trees and inputs

| Name | Commit | What it is |
| --- | --- | --- |
| `head` | [`68d7d3a0`](https://github.com/buster14a/buster/tree/68d7d3a0) | the producer branch, main `92c025e7` merged |

The tree was `git archive` of its commit with `survey.patch` applied (`c_check_program_lower.c` alone: with
`BUSTER_LOWER_SURVEY` set, `check_lower_survey_print` writes each body's line and a part with a refusal stops before
Tier 0) and `main_nosection.c` made from its `main.c` with
`sed -e '/^#pragma clang section/d' -e '/__asm__(".section .text.buster_checker/d'`. `source.sha256` holds the SHA-256
of each of its files, and `inputs.sha256` the executable's, `main.c`'s, `main_nosection.c`'s and the patched file's, and
the kernel and clang. It was built with `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh`.

## Method

From the tree's root, with `CPATH` and `C_INCLUDE_PATH` unset, `build.sh`'s flags with the 9700X's `-march`, on one
lane so that one part lowers every body in order:

```sh
BUSTER_LOWER_SURVEY=1 ./build/compiler -c --lanes 1 -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -o /dev/null src/buster/compiler/main_nosection.c 2> survey_select.log
BUSTER_LOWER_SURVEY=1 ./build/compiler -c --lanes 1 --lower-all -march=znver5 -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -o /dev/null src/buster/compiler/main_nosection.c 2> survey_all.log
```

Each line is a body: `survey`, the function's name, its status (0 lowered, 2 refused) and its reason, separated by
tabs. Both runs exit with status 1 and end with the driver's `error: unsupported: survey` at the first refused body's
place, which the patch reports for the part. The tallies count the fourth field; a function of the headers is told apart
by its name, `_` first (each of the 358 selected ones is defined in clang 23's `include` directory).

## Limits

A refusal is a function's first: a function refused for a builtin may have more to refuse after it. A function counts
as lowered when its lowering succeeds; Tier 0, branch sizing and encoding didn't run on the survey's functions.
