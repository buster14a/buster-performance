# Inline assembly lowering (#147, PR #535), 2026-10-27

buster14a/buster's branch `claude/inline-asm-lowering-126-9c1d15` against main at its merge-base, on the 9700X
(Ryzen 7 9700X, Zen 5). The branch lowers GNU C's `asm` statements as per-unit helpers.

## Sources and binaries

- **Base:** main at `e04462c12f1ce25c70e41e8aa4acf48f4d7c4004`, the branch's merge-base.
- **Head:** `b33e8da487dcf507492fe2ec37a9bea9cccb0fbb`, the branch's lowering commit before its last amend, which was
  never pushed. The PR's `99462a644068de97898c8176342a812588c7ebbf` differs from it in one test's return expression,
  `b33e8da4-to-99462a64.diff`, which no measured path runs. The commits after it (`825e8c94` CI's musl minimum,
  `220b9e8e` main merged in, `0d92eeac` the guide's numbers) change no measured path either.
- Each tree was sent with `git archive` into an empty directory. `manifest-e04462c1.sha256` and
  `manifest-b33e8da4.sha256` list every file, and the trees on the host matched them file for file (leaving out
  `build/` and `build.log`).
- Each was built with `LC_NUMERIC=C BUSTER_DEBUG_INFO=0 ./build.sh` under the lock. The executables' hashes, the
  toolchain (clang 23.1.1, perf 7.2.9, gdb 18.1, kernel 6.18.50-2-lts, transparent huge pages `always`) and the
  inputs' hashes are in `identities.txt`.

Every measurement held the shared lock (`~/buster-fast-bench/exclusive.sh`) for itself, pinned to CPU 2 unless said
otherwise, base and head in alternating order. The logs leave out the lock's waiting lines, which name other
sessions' private links.

## The default path: `-c` of sqlite3.c

The frozen corpus's `sqlite3.c` (SQLite 3.53.2, `/var/lib/buster-9700x/corpora/preprocessor-391e729af658`) with
`--predefines $corpus/provenance/gnu17-pinned-predefines.txt --target=x86_64-linux-gnu -march=znver5 -std=gnu17
-nostdinc` and the corpus's three `-isystem` directories, `-o /dev/null`. It has no asm statement. Without
`--clang-features`: with clang's answers to the feature queries the file takes its `__atomic_*` path, which main
doesn't lower; `queue.sh`'s first attempt used them, and both trees refused the file (`queue.log`).

Both trees write the same object (`b4cc5868df7fafacd95cc01cef01066a`, `queue3.log`).

| | main | head | |
|---|---:|---:|---:|
| Wall (`ab`, 5 rounds of 11 runs: the rounds' medians' median and range, `ab-sqlite.log`) | 190.03 ms (189.81–190.08) | 189.71 ms (189.53–190.33) | −0.2% |
| User instructions (`perf stat -r 11`, twice each, `step-perf.log`) | 2,287,953,020 | 2,287,446,729 | −0.02% |
| User cycles | 890.4 M, 889.5 M | 888.4 M, 887.0 M | −0.3% |
| Peak RSS (`ab-sqlite.log`) | 710,248 KB | 713,364 KB | +0.44% |

`step-smaps.log` has each tree's mappings at the first `munmap` of more than 64 MB, with every arena still mapped
(`smaps.py` reads `/proc/PID/status` and `/proc/PID/smaps` in gdb). Head's `.bss` has one more 2 MB transparent huge
page resident (8,192 → 10,240 KB of its 236 MB), its read-only segment 1,024 KB more (2,368 → 3,392 KB), its text
56 KB and its data 8 KB more. No other mapping differs. The head executable's text is 199 KB larger, which moves the
segments against the 2 MB pages; nothing allocates more.

## The modules' benchmarks

| | main | head | |
|---|---:|---:|---:|
| `benchmark-lowering-source`, c-testsuite `5c72756`'s 220 programs (CI's step), twice each (`step-lowering.log`) | 1.999, 2.007 ms | 1.965, 1.965 ms | −1.8% |
| `benchmark-lowering-source`, `sqlite3.c`: 6 processes each, ABBA (`step-lowering-sqlite2.log`), median (range) | 37.51 ms (37.05–37.73) | 37.45 ms (37.35–37.54) | −0.2% |
| that process's user instructions | 26.554 G | 26.529 G | −0.09% |
| `benchmark-assembler`, vector path, twice each (`step-assembler.log`) | 1.460, 1.470 ms | 1.454, 1.470 ms | |
| its scalar path | 3.667, 3.860 ms | 3.682, 4.069 ms | one pass's parse was slow |
| its match index | 419,496 bytes | 419,496 bytes | |

`step-lowering-sqlite.log` has an earlier pair of processes per tree (base 37.18 and 37.01 ms, head 37.38 and
37.91 ms), whose spread `step-lowering-sqlite2.log`'s six processes each settle.

## Tests

- `test-assembler --cross-check` (`step-tests.log`): medians of 3 runs, twice each, 406.3 and 405.3 ms on main
  against 405.7 and 405.5 ms on head, which runs the branch's checks too.
- `test-checker --seed 133` as the 9700X job's test step runs it: the parallel runner with one command, on CPUs 0
  to 7 (`queue7.sh`). Both pass: 11.0 and 11.0 s on main, 11.4 and 11.5 s on head (`queue7.log`; `checker-*.log` keep
  each tree's last run).
- musl's symbol comparison, CI's command on the frozen copy of its eight directories (`queue2.sh`,
  `musl-*.log`): main compares 351 files' objects with clang -O0's, head 354, 0 different, 0 failures on both.

## What an asm statement costs

Head alone, since main refuses them. `gen.sh 1000` writes `asm.c`, 1,000 functions of four statements each
(registers with a modifier, a barrier, cpuid's fixed registers and a memory output: 3,000 helpers), and `plain.c`,
the same functions with C in the statements' place; their hashes are in `identities.txt`.

- `time-runs --runs 21 --warmups 3`, both in turn (`step-perf.log`): 29.04 ms against 18.22 ms.
- `perf stat -r 11`, twice each: 435,240,730 against 246,845,877 user instructions.
- That is 2.7 µs and 47,000 instructions a statement.
- `perf record -e cycles:u -c 200003` over 30 compiles of each (`step-profile.sh`, `profile-asm.txt`,
  `profile-plain.txt`): the statements' own functions take 7.6% of `asm.c`'s user cycles, about 0.55 µs a statement:
  `check_program_asm_plan_one` 3.92%, `asm_section_index` 2.68%, `asm_parse` 0.55%, `check_program_asm_plan` 0.31%
  and `x86_match_bucket` 0.13%. The checker's `check_asm_operand` (0.51%) runs on main too. The rest is what
  3,000 more functions cost the backend: `validate_instructions`, for one, is 3.33% of `asm.c`'s cycles and 1.58% of
  `plain.c`'s.

## How the runs were made

`queue.sh` built both trees, then failed its drive check (the `--clang-features` above). `queue3.sh` repeated the
measurements without building again. `queue4.sh` stopped it after its `ab` (the run it had started was cut short
and isn't used) and ran the rest in a few holds of the lock, each under a minute or two: `step-perf.sh`,
`step-assembler.sh`, `step-lowering.sh`, `step-lowering-sqlite.sh` and `step-tests.sh`. Each hold's own time is the
`timed:` line `timed.sh` appends. Then `step-smaps.sh`, `queue5.sh` (`step-lowering-sqlite2.sh`), `queue6.sh`
(`step-profile.sh`) and `queue7.sh` ran in turn, each waiting for the one before.

## Limitations

- The head measured is `b33e8da4`, not a pushed commit; the diff above is its whole difference from the PR's
  `99462a64`.
- A pair of processes per tree, or two rounds, decides each comparison; their spread is in the tables. Code placement
  alone moves this executable by about 1% between builds, which covers every difference here.
- Laptop and CI results the PR quotes (the fixture tests, the mutation check, the `main.c` survey) aren't measurements
  and aren't recorded here.
