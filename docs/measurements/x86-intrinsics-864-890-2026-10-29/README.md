# #864's and #890's x86 builtins: what code without them pays, 2026-10-29

Two branches stacked on #862's (buster14a/buster#862, half-precision values) give the lowering rows for more of the
headers' x86 builtins:

- `claude/loving-carson-j9sz52-intrinsics9` (buster14a/buster#864): XOP's compares, AVX512-FP16's reductions and
  bf16's scalar masked loads and stores, with XOP an extension of `X86Target`'s;
- `claude/loving-carson-j9sz52-intrinsics9b` (buster14a/buster#890), on #864's: XOP's own instructions, the effects of
  their forms and of 39 others in `x86_semantics.c` (102 forms in all), and `test-x86-intrinsics`, a test command.

This record measures what the two heads cost `-fsyntax-only` and `-c` of code that calls no x86 builtin, and
`-fsyntax-only` of `main.c`, whose headers define the intrinsics, against #862's head.

Every measurement ran on the 9700X, pinned to CPU 2, each run under the 9700X's lock on its own. The inputs:

- **`sqlite3.c`**: the frozen one of corpus `preprocessor-391e729af658`, by `-fsyntax-only --clang-features`
  (`drive`) and by `-c` without that option (`lower`), whose objects every tree made the same, byte for byte
  (`abX/abX.log` and `abX/inputs.sha256`);
- **`main.c`**: #890's head's own, the same file for every tree, checked with `build.sh`'s flags
  (`print-compile-flags`, #890's) and one lane (`main`).

Each tree built with `BUSTER_DEBUG_INFO=0` under its own hold of the lock, and its sources hash to the commit's
`git archive` (`sources.sha256`). An A/A control (`aa`) is a copy of the base's executable, the same bytes, run as a
tree of its own.

## abX: #864's and #890's heads against #862's

Base: #862's head `80e2666be6b8ad86156a2e5d0d542d746234c705`. `h864`: #864's head
`411eab5d23abb63e0768c5ca499604c822c157a0`, its batch's commit and its merge of the base. `h890`: #890's head
`be6b7cd4c8e8a6ef3b56a1ca2004bae53b2939d9`, its batch's commit and its merges of #864's heads, the last of them
`h864`.

abX.sh built the three trees, ran each tree's `-c` of `sqlite3.c` and `main.c`, then three rounds of
`perf stat -r 11` (`-r 5` for `main.c`) of user instructions, cycles and task-clock, whose order rotates; the medians
of the rounds (`abX/perf.log`):

| Measure | base | A/A copy | h864 | h890 |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c -fsyntax-only`, instructions | 1,027,131,751 | 1,027,131,749 | 1,027,138,725 | 1,027,128,677 |
| against base | | -2 | +6,974 (+0.0007%) | -3,074 (-0.0003%) |
| `sqlite3.c -fsyntax-only`, cycles | 467.322 M | 465.579 M | 468.101 M | 468.111 M |
| `sqlite3.c -c`, instructions | 1,302,610,155 | 1,302,610,155 | 1,302,617,297 | 1,302,624,702 |
| against base | | 0 | +7,142 (+0.0005%) | +14,547 (+0.0011%) |
| `sqlite3.c -c`, cycles | 592.085 M | 591.273 M | 592.699 M | 593.556 M |
| `main.c -fsyntax-only`, instructions | 19,497,139,912 | 19,497,138,421 | 19,497,416,343 | 19,497,117,611 |
| against base | | -1,491 | +276,431 (+0.0014%) | -22,301 (-0.0001%) |
| `main.c -fsyntax-only`, cycles | 7,374.990 M | 7,370.066 M | 7,395.010 M | 7,399.390 M |

- **Instructions:** one tree's three rounds span at most 50 instructions in `sqlite3.c`'s runs and 19,188 in
  `main.c`'s (the A/A copy's), and the A/A copy is within 2 and 1,491 of its base. Against base, `h864` runs 6,974,
  7,142 and 276,431 more; `h890` 3,074 fewer, 14,547 more and 22,301 fewer, which against `h864` is 10,048 fewer,
  7,405 more and 298,732 fewer. Each is at most 0.0016% of its command. The lowering reads the rows only for an x86
  builtin's call, which `sqlite3.c` doesn't have, and `-fsyntax-only` lowers none of `main.c`'s. `-c`'s emission
  initializes `x86_semantics.c`'s effects table (`c_check_program_emit.c`), to which `h890` adds the rows of 102
  forms, and `-fsyntax-only` emits nothing. This record attributes none of these differences further.
- **Cycles:** every tree's median is within 0.34% of base's (`h890`'s of `main.c`, 0.33% more), inside the spread of
  the A/A copy against its base (up to 0.37%, `drive`'s, fewer) and of one tree's own three rounds (up to 0.57%,
  `h864`'s of `lower` and the A/A copy's of `main`, `abX/perf.log`); this record claims no speed difference.
- **Not measured:** the branches' later heads, which merge later commits of main and #862's branch, and #890's
  `46cad79f997fa92954bc2c478b7276e9df93a675`, which changes only `x86_intrinsics_test.c`, the test command's source.

## Files

| File | What it is |
| --- | --- |
| `abX/abX.sh`, `abX/abX.log`, `abX/perf.log`, `abX/inputs.sha256` | abX's script and log, `perf stat`'s output, and the executables', objects' and inputs' hashes. |
| `abX/build_*.log`, `abX/lower_*.log`, `abX/main_*.log` | Its builds' reports, and each tree's `-c` and `main.c` runs' output (the lock's waits). |
| `sources.sha256` | Each tree's sources' list hashed, and the commit it matches. |
