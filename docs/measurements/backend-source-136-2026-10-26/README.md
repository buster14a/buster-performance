# benchmark-backend-source on sqlite3.c (#136), 2026-10-26

buster14a/buster's branch `claude/136-backend-source-benchmark` at `a69f2577`, with main merged in, against main at
`e04462c1`, on the 9700X (Ryzen 7 9700X, Zen 5). Each run held the shared lock (`~/buster-fast-bench/exclusive.sh`)
alone and was pinned to CPU 2. `be-ab4.sh` synced both trees with `git archive` (build.sh, src, tests: the manifests
list every file) into emptied directories and built each with `BUSTER_DEBUG_INFO=0 ./build.sh` under the lock, and
`be-proc4.sh` ran the measurements. The logs leave out the lock's waiting lines, which name other sessions' private
links.

## What the branch changes on the default path

`check_program_access`, the symbols' access column, moved out of `check_program_emit` unchanged, so that the new
benchmark can give the lowered functions their access again. `functions-diff.txt` lists the functions of one
executable that the other doesn't have at the same size (`comm -3` of `nm -S` over each: main's left, the branch's
indented). Only the checker's unit's copies differ: there `check_program_emit` (47,738 bytes on main, 27,231 on the
branch) no longer inlines `check_program_access`, `tier0_compile`, `tier0_compile_scalar` and `size_branches`, which
the new benchmark calls too, besides the benchmark's and its test's own functions.

## -c of sqlite3.c

`perf stat -r 11 -x, -e instructions:u,cycles:u ./build/compiler -c -I$Q -o ... $Q/sqlite3.c`, with SQLite 3.53.2's
amalgamation from `~/buster-fast-bench/preprocessor-corpora-astra-01a158dd/sqlite` (`$Q`), main's and the branch's in
turn, two rounds (`main/perf-*.log`, `branch/perf-*.log`):

| Run | Instructions | Cycles | ms per run |
| --- | ---: | ---: | ---: |
| main, round 1 | 2,288,013,419 | 890,297,575 | 190.53 |
| branch, round 1 | 2,288,362,023 | 886,289,369 | 189.17 |
| main, round 2 | 2,288,013,415 | 889,554,198 | 190.10 |
| branch, round 2 | 2,288,362,022 | 889,980,909 | 190.42 |

The branch runs 348,604 more user instructions (+0.015%); its cycles are within main's spread. The milliseconds are
perf's enabled time per run.

## benchmark-backend

The generated programs' benchmark, once per tree (`main/backend.log`, `branch/backend.log`): the vector path 79.66
cycles and 169.85 instructions per typed entry on main, 79.59 and 169.85 on the branch; the scalar path 230.32 and
227.33 cycles.

## benchmark-backend-source on the frozen sqlite3.c

The 9700X job's options: `--predefines $corpus/provenance/gnu17-pinned-predefines.txt --no-default-config
--target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc` and the corpus's three `-isystem` directories, on
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c` (SQLite 3.53.2). Without
`--clang-features`: with clang's answers to the feature queries the file takes its `__atomic_*` path, which the
producer doesn't lower yet. The corpus: 2,602 functions, 400,995 typed entries, 366,044 records (0.913 per entry),
1,239,093 bytes of code, 14,008 entries deferred (3.49%).

Medians of 21 passes, the range over three processes (`branch/source-*.log`):

| Variant | ns per entry | Cycles per entry | Instructions per entry | Cycles per record | IPC |
| --- | ---: | ---: | ---: | ---: | ---: |
| Vector path | 11.38–11.67 | 63.08–64.70 | 152.72 | 69.11–70.88 | 2.36–2.42 |
| Scalar path | 30.83–30.90 | 170.90–171.33 | 526.66 | 187.22–187.69 | 3.07–3.08 |
| `size_branches` | 0.94–0.95 | 5.19–5.24 | 11.05 | 5.68–5.74 | 2.11–2.13 |
| `x86_encode` | 0.70–0.72 | 3.89–3.99 | 14.17 | 4.26–4.37 | 3.55–3.64 |

The vector path alone (`--only vector`): 62.58 cycles, 11.29 ns per entry; after 200 ms of the scalar path before each
pass (`--after-scalar 200`): 63.47 cycles, 11.45 ns; the scalar path alone: 170.77 cycles, 30.83 ns.

## Limitations

- One machine, one file of the corpus, three processes of 21 passes each.
- The corpus is the definitions `-c` lowers (the referenced ones), as `check_program_emit` lowers them, with the
  symbols' access it gives them; the functions stay in memory across passes, unlike a compile's single pass.
- The `-c` comparison's input is the astra corpus's copy of SQLite 3.53.2 with the host's headers, the earlier
  records' (`sqlite-136-2026-10-26`, `complex-133-2026-10-26`); the benchmark's is the oracle's frozen copy.
