# #894's x86 builtins: what code without them pays, 2026-10-29

Branch `claude/loving-carson-j9sz52-intrinsics9c` (buster14a/buster#894) gives the lowering rows for AVX-NE-CONVERT's
loads, AVX10.2's dot products of AVX-VNNI-INT8 and AVX-VNNI-INT16, and SHA512's, SM3's and SM4's builtins, with SHA512,
SM3 and SM4 extensions of `X86Target`'s and the effects of 91 forms in `x86_semantics.c`. This record measures what
its head costs `-fsyntax-only` and `-c` of code that calls no x86 builtin, and `-fsyntax-only` of `main.c`, whose
headers define the intrinsics, against main.

Every measurement ran on the 9700X, pinned to CPU 2, each run under the 9700X's lock on its own. The inputs:

- **`sqlite3.c`**: the frozen one of corpus `preprocessor-391e729af658`, by `-fsyntax-only --clang-features`
  (`drive`) and by `-c` without that option (`lower`), whose objects every tree made the same, byte for byte
  (`abY/abY.log` and `abY/inputs.sha256`);
- **`main.c`**: the head's own, the same file for every tree, checked with `build.sh`'s flags
  (`print-compile-flags`, the head's) and one lane (`main`).

Each tree built with `BUSTER_DEBUG_INFO=0` under its own hold of the lock, and its sources hash to the commit's
`git archive` (`sources.sha256`). An A/A control (`aa`) is a copy of the base's executable, the same bytes, run as a
tree of its own.

## abY: the head against main

Base: main `3beda954562cfb15b47a8de75da4705f8c59cdfb`, which has merged the branch's parents (#862, #864 and #890).
`h9c`: the branch's head `d2f495babfe09b60cdac713cda7cfb76aa9f7592`, its batch's commit and its merges of #890's heads
and of that main.

abY.sh built the two trees, ran each tree's `-c` of `sqlite3.c` and `main.c`, then three rounds of `perf stat -r 11`
(`-r 5` for `main.c`) of user instructions, cycles and task-clock, whose order rotates; the medians of the rounds
(`abY/perf.log`):

| Measure | base | A/A copy | h9c |
| --- | ---: | ---: | ---: |
| `sqlite3.c -fsyntax-only`, instructions | 1,025,387,063 | 1,025,387,108 | 1,025,388,535 |
| against base | | +45 | +1,472 (+0.0001%) |
| `sqlite3.c -fsyntax-only`, cycles | 466.168 M | 469.142 M | 469.095 M |
| `sqlite3.c -c`, instructions | 1,302,799,894 | 1,302,799,911 | 1,302,814,481 |
| against base | | +17 | +14,587 (+0.0011%) |
| `sqlite3.c -c`, cycles | 591.686 M | 592.495 M | 594.285 M |
| `main.c -fsyntax-only`, instructions | 19,652,493,312 | 19,652,501,410 | 19,652,233,538 |
| against base | | +8,098 | -259,774 (-0.0013%) |
| `main.c -fsyntax-only`, cycles | 7,453.815 M | 7,499.393 M | 7,480.521 M |

- **Instructions:** one tree's three rounds span at most 5 instructions in `sqlite3.c`'s runs and 7,434 in `main.c`'s
  (the head's), and the A/A copy is within 45, 17 and 8,098 of its base. Against base, the head runs 1,472 and 14,587
  more in `sqlite3.c`'s runs and 259,774 fewer in `main.c`'s, each at most 0.0013% of its command. The lowering reads
  the rows only for an x86 builtin's call, which `sqlite3.c` doesn't have, and `-fsyntax-only` lowers none of
  `main.c`'s. `-c`'s emission initializes `x86_semantics.c`'s effects table (`c_check_program_emit.c`), to which the
  head adds the rows of 91 forms, and `-fsyntax-only` emits nothing. This record attributes none of these differences
  further.
- **Cycles:** every tree's median is within 0.64% of base's (the A/A copy's of `drive`, 0.64% more, and the head's,
  0.63% more), inside the spread of one tree's own three rounds (up to 0.93%, base's of `lower` and the A/A copy's of
  `main`, `abY/perf.log`); this record claims no speed difference.
- **Not measured:** the branch's later heads.

## Files

| File | What it is |
| --- | --- |
| `abY/abY.sh`, `abY/abY.log`, `abY/perf.log`, `abY/inputs.sha256` | abY's script and log, `perf stat`'s output, and the executables', objects' and inputs' hashes. |
| `abY/build_*.log`, `abY/lower_*.log`, `abY/main_*.log` | Its builds' reports, and each tree's `-c` and `main.c` runs' output (the lock's waits). |
| `sources.sha256` | Each tree's sources' list hashed, and the commit it matches. |
