# #781's AVX512-FP16 builtins: what code without them pays, 2026-10-29

Branch `claude/loving-carson-j9sz52-intrinsics6` (buster14a/buster#781) lowers AVX512-FP16's builtins (145 rules in
`c_check_program_x86.c`) and the arithmetic of `_Float16` vectors, with clang's excess precision where the unit's target
lacks the extension. Its new code runs only in the lowering of vectors and x86 builtins, whose rows now take the target
whole rather than its features, and in `-march=native`'s target, which reads AVX512-FP16 from CPUID (`x86_target.c`).
A compile without vectors runs none of it, but clang compiles the lowering's functions anew.

This record measures, on the 9700X, pinned to CPU 2:

- **base**: the pull request's base, #772's `87924816d38533a044fe6c699c1626d6e22ca69d`;
- **head**: the pull request's head, `0174c87681506d7931686d28fab9b01c6e0c3b5b`;
- **aa**: a copy of base's executable, the same bytes (`inputs.sha256`), run as a third tree.

The inputs:

- **`sqlite3.c`**: the frozen one of corpus `preprocessor-391e729af658`, which has no vectors.
- **`main.c`**: head's own, checked with `build.sh`'s flags (`print-compile-flags`) and one lane. It has the clang
  headers' vector intrinsics, `avx512fp16intrin.h`'s among them.

Each tree's sources hash to the commit's `git archive` (`sources.sha256`). Every run took the 9700X's lock on its own
(`abF.sh`).

## The campaign

There were three rounds, the trees in the same order in each. Each round ran `perf stat -r 11` (`-r 5` for `main.c`) of
user instructions, cycles and task-clock. The medians of the rounds (`perf.log`):

| Measure | base | A/A copy | head | head against the A/A copy |
| --- | --- | --- | --- | --- |
| `sqlite3.c -fsyntax-only`, instructions | 959,263,339 | 959,263,358 | 959,275,368 | +12,010 (+0.0013%) |
| `sqlite3.c -fsyntax-only`, cycles | 448.940 M | 449.534 M | 448.726 M | -0.18% |
| `sqlite3.c -c`, instructions | 1,237,958,930 | 1,237,958,947 | 1,237,959,322 | +375 (+0.00003%) |
| `sqlite3.c -c`, cycles | 572.914 M | 575.340 M | 574.694 M | -0.11% |
| `main.c -fsyntax-only`, instructions | 13,415,782,662 | 13,415,774,775 | 13,415,688,189 | -86,586 (-0.0006%) |
| `main.c -fsyntax-only`, cycles | 5,047.04 M | 5,051.38 M | 5,055.17 M | +0.075% |

The three trees' `sqlite3.c -c` objects are the same, byte for byte (`abF.log`; `inputs.sha256`).

The A/A copy differs from base by up to 0.42% in cycles, though it is the same executable. Head's cycles are within
0.18% of the copy's, inside that spread, so they show no time cost and no time gain. The task-clock medians are 97.9 to
98.0 ms for `sqlite3.c -fsyntax-only`, 121.0 to 121.4 ms for `-c` and 1,017.9 to 1,019.1 ms for `main.c` in every tree.

The instruction counts are deterministic here: the A/A copy differs from base by at most 7,887 instructions. Head's
differences are of that size or smaller: +12,010 for `sqlite3.c -fsyntax-only` (+0.0013%), +375 for `-c` and -86,586
for `main.c` (-0.0006%). This record doesn't attribute them further, and it claims no speed-up or cost.

`-c` of `main.c` isn't measured: at both trees it stops at the first of the bodies the lowering refuses (two inline
assembly templates, which buster14a/buster#773 takes, and a `_BitInt`).

## The builds

Each tree built under its own hold of the lock, with `BUSTER_DEBUG_INFO=0`, once each (`build_base.log`,
`build_head.log`): base in 29.9 s and head in 30.3 s. Host: Linux 6.18.50-2-lts, clang 23.1.1 (`inputs.sha256`).

## Files

| File | What it is |
| --- | --- |
| `abF.sh`, `abF.log`, `perf.log`, `inputs.sha256` | The script, its log, `perf stat`'s output, and the executables', objects' and inputs' hashes. |
| `sources.sha256` | Each tree's sources hashed (`find . -path ./build -prune -o -type f -print`, sorted, `sha256sum`, hashed again), and the commit they match. |
| `build_*.log` | The builds' reports. |
