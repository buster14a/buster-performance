# Module homes and one compile per core (#270), 2026-10-25

The 9700X's measurements behind Buster's [PR #424](https://github.com/buster14a/buster/pull/424) for
[#270](https://github.com/buster14a/buster/issues/270). The PR compiles the modules that several of `main.c`'s
translation units run (the lexer, the preprocessor, the parser and the linker's modules) in one unit each, their
home, which the other units call; and `build.sh` runs at most one compile per core, the longest first.

Two studies, each of exact commits:

- **`current/`**, the acceptance: main `51ab0b63` against the PR's head `6847c1db` (its first commits merged with
  that main): the builds, the generated code, the benchmarks whose code the homes move and the whole drivers that run
  the homed entry points.
- **`first/`**, history: main `5863eeda` against `9b391d4b`, the PR before its merge of main. Main's changes in
  between (#415 rewrote `c_lexer.c`'s vector code for MSVC, #416 the assembler, `object_writer.c` changed) moved code
  the homes touch, so the reviews asked for the current pair; this study was stopped in its fourth round.

`exploratory/` has the earlier measurements of working trees that chose the design (below). `parse.py DIRECTORY`
makes every table here from a study's logs.

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 | `build/compiler` SHA-256 (`BUSTER_DEBUG_INFO=0`) |
| --- | --- | ---: | --- | --- |
| current base | `51ab0b63d344d890de1d8a09a29a121174a512a4` (main) | 587 | `118639df5ad029a04a6b6acda4e44249ce7cf54c8ff9402e0cc642d51dbb5f31` | `3d15d48fc37df41975cd51c08382f42d09ac1ae93f051b04c7a2767d0a39830a` |
| current head | `6847c1dbb22b8396b9f4daa4ebb6b2c247e44720` (the PR) | 587 | `63a501a3df58bcd484204351f179b429022a6712cad5d868b3a8c797f1f150a3` | `93ecb1e647389e7f0be91e709b1f1d7c6aa5f42032143477197c740b8b82d8ef` |
| first base | `5863eeda331dacaa1371e1fe9ca1456e9d0039ca` (main) | 564 | `12f63a3ec7b50c346e9ad915f8d123f79c1eb7f43423f0ee140bec1074d1edad` | `9e74bdb733704bdd6298659fe739ecd819182c8728e429ca187af0e55c6a621e` |
| first head | `9b391d4b5befae8ea7bc135e6635632ca87038fc` (the PR) | 564 | `45974e3e561530a8d3365f009ea6197076fe3934b80d88eb12e4d5c2baefaa24` | `04f3dbfb0cb3258407bf9507c12bd70ac16c0765a21d63a8fd9067f1ea55a5a0` |

Each `source-*.sha256` lists the SHA-256 of every file of `git archive` of the commit, sorted by path
(`LC_ALL=C`). Every tree was sent to the host by `git archive`; the host's files but `build/` match the manifests.
The executables are each study's last builds (`BUSTER_DEBUG_INFO=0`), which every later run of the study used.

Inputs:

- `sqlite3.c` of the frozen preprocessor corpora (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, the
  bundle of #117's 2026-10-23 acceptance; `sqlite3.c`:
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`), with its pinned predefines
  (`provenance/gnu17-pinned-predefines.txt`: `a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`) and
  headers: `--predefines ... --clang-features --target=x86_64-linux-gnu -march=znver5 -std=gnu17 -nostdinc` and its
  three `-isystem` directories (the benchmarks also take `--no-default-config`, a clang option the driver doesn't).
- `main.c` and `src` of the base tree, with `-march=native -Isrc -fwrapv -funsigned-char` and clang's predefines for
  those options (`build/predefines.h`: `40c31757e3ffd1ce3f95f79ee9ba347ba97ba893aa66f6e69df4cc9e3b344c58`).
- c-testsuite at `5c7275656d751de0e68b2d340a95b5681858ed07`, the 219 programs of the base tree's
  `tests/c-testsuite/subset.txt`; the whole drivers' program is `tests/single-exec/00216.c`, the largest
  (`023f99bc5046f940b3cb9d6f3070c3a9d7c1dfe295cdd74d3b155ed774df28c0`).
- `SOURCE_DATE_EPOCH=1792454400`; `CPATH` and `C_INCLUDE_PATH` unset.

Host: AMD Ryzen 7 9700X (CPUs 0-9 and 11-15 online), Linux 6.18.50-2-lts, clang 23.1.1, wild 0.10.0 (the linker
`build.sh` picks there), the `performance` governor and energy preference, transparent huge pages `always`, address
space randomization on (`randomize_va_space` 2). Every build and every run took the shared lock on its own, through
`~/buster-fast-bench/exclusive.sh` with `EXCLUSIVE_OWNER=claude-270`; the benchmarks ran pinned to CPU 2 (`ab --cpu
2`) but `benchmark-link`, which pins its one-thread runs itself. `ab` runs every argument list on every tree each
round, the trees in an order that rotates by round. The lock's waiting messages, which name other sessions' runs, are
removed from the logs; nothing else in them is changed.

## The current pair: main `51ab0b63` against `6847c1db`

`current/scripts`: `run.sh` (the builds, the generated code, then `ab --rounds 5` of the lexer's, the assembler's
and the encoder's benchmarks and one `time-runs` of the whole drivers), `run2.sh` (`link-foreign` through
`benchmark-link`, `ab --rounds 3`, unpinned), `run3.sh` (the first study's other benchmarks, `ab --rounds 3`),
`run4.sh` (where the checker's peak resident set differs, below) and `run5.sh` (`benchmark-checker-source` over six
more rounds). `run3.sh` ran beside `run.sh`'s last round and `run2.sh`, each run still locked alone. Every `ab` run
succeeded, and every whole-driver process exited with status 0 (525 per tree).

#### Builds

| Configuration | Tree | `build.sh` wall, each round | Median | CPU (median) | Longest compiles (median) |
| --- | --- | --- | ---: | ---: | --- |
| debug information | base | 50.73 s | 50.73 s | 417 s | checker 50.6 s, backend 39.4 s, frontend 35.3 s |
| debug information | head | 32.12 s | 32.12 s | 255 s | checker 27.5 s, backend 25.3 s, frontend 21.5 s |
| debug information | change | | -36.7% | -39.0% | |
| `BUSTER_DEBUG_INFO=0` | base | 40.30, 40.56, 40.20 s | 40.30 s | 333 s | checker 40.2 s, backend 31.2 s, frontend 28.2 s |
| `BUSTER_DEBUG_INFO=0` | head | 25.59, 25.48, 25.57 s | 25.57 s | 202 s | checker 21.4 s, backend 20.1 s, frontend 17.2 s |
| `BUSTER_DEBUG_INFO=0` | change | | -36.6% | -39.3% | |

`.text`, `BUSTER_DEBUG_INFO=0`: 24,194,781 bytes on main, 20,795,507 with the homes (−14.0%); the files 35,477,836 and
31,917,130 bytes (−10.0%), and with debug information 91,881,996 and 80,790,538 (−12.1%).

#### Generated code

- identity: 657 files the same, 0 different, 0 not written
- base outputs: 219 executables, 219 objects, 438 zero statuses
- head outputs: 219 executables, 219 objects, 438 zero statuses
- base -E sqlite3.c: status 0
- base parse -fsyntax-only sqlite3.c: status 0
- base -fsyntax-only sqlite3.c: status 0
- base compile and link 00216.c: status 0, the program: 0
- base -c 00216.c: status 0
- head -E sqlite3.c: status 0
- head parse -fsyntax-only sqlite3.c: status 0
- head -fsyntax-only sqlite3.c: status 0
- head compile and link 00216.c: status 0, the program: 0
- head -c 00216.c: status 0

The whole drivers' command lines, run once by each executable before the A/B, all exit with status 0 (the program
the compile and link writes runs with status 0 too).

#### Whole drivers (`time-runs`, each round the median of its processes)

| Workload | Metric | main, each round | head, each round | main median | head median | Change | Per-round changes |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |
| `-E` sqlite3.c | minor faults | 778.00, 778.00, 778.00, 778.00, 778.00 | 776.00, 776.00, 776.00, 777.00, 776.00 | 778.00 | 776.00 | -0.3% | -0.3% to -0.1% |
| `-E` sqlite3.c | peak resident, KB | 59,152, 59,160, 59,156, 59,164, 59,164 | 59,056, 59,060, 59,052, 59,048, 59,060 | 59,160 | 59,056 | -0.2% | -0.2% to -0.2% |
| `-E` sqlite3.c | user + system, ms | 19.38, 19.28, 19.28, 19.60, 19.28 | 19.35, 19.25, 19.92, 19.28, 19.41 | 19.28 | 19.35 | +0.3% | -1.6% to +3.3% |
| `-E` sqlite3.c | wall, ms | 19.51, 19.42, 19.44, 19.54, 19.40 | 19.38, 19.39, 19.43, 19.44, 19.41 | 19.44 | 19.41 | -0.1% | -0.7% to +0.1% |
| `-c` 00216.c | minor faults | 566.00, 566.00, 566.00, 566.00, 566.00 | 570.00, 570.00, 570.00, 571.00, 570.00 | 566.00 | 570.00 | +0.7% | +0.7% to +0.9% |
| `-c` 00216.c | peak resident, KB | 39,492, 39,500, 39,496, 39,492, 39,496 | 39,380, 39,380, 39,376, 39,388, 39,388 | 39,496 | 39,380 | -0.3% | -0.3% to -0.3% |
| `-c` 00216.c | user + system, ms | 3.550, 3.545, 3.523, 3.509, 3.660 | 3.520, 3.620, 4.128, 3.605, 3.521 | 3.545 | 3.605 | +1.7% | -3.8% to +17.2% |
| `-c` 00216.c | wall, ms | 3.695, 3.718, 3.705, 3.723, 3.712 | 3.740, 3.755, 3.725, 3.741, 3.755 | 3.712 | 3.741 | +0.8% | +0.5% to +1.2% |
| `-fsyntax-only` sqlite3.c | minor faults | 1,760, 1,760, 1,760, 1,760, 1,760 | 1,767, 1,767, 1,767, 1,767, 1,766 | 1,760 | 1,767 | +0.4% | +0.3% to +0.4% |
| `-fsyntax-only` sqlite3.c | peak resident, KB | 590,000, 590,000, 590,000, 590,012, 590,000 | 592,080, 592,080, 592,084, 592,084, 592,080 | 590,000 | 592,080 | +0.4% | +0.4% to +0.4% |
| `-fsyntax-only` sqlite3.c | user + system, ms | 149.51, 149.43, 149.63, 150.58, 149.79 | 149.44, 149.22, 149.62, 149.85, 149.41 | 149.63 | 149.44 | -0.1% | -0.5% to -0.0% |
| `-fsyntax-only` sqlite3.c | wall, ms | 150.15, 149.90, 149.95, 150.38, 150.13 | 149.90, 149.96, 150.16, 150.16, 150.45 | 150.13 | 150.16 | +0.0% | -0.2% to +0.2% |
| `parse -fsyntax-only` sqlite3.c | minor faults | 906.00, 906.00, 906.00, 906.00, 906.00 | 899.00, 899.00, 899.00, 899.00, 899.00 | 906.00 | 899.00 | -0.8% | -0.8% to -0.8% |
| `parse -fsyntax-only` sqlite3.c | peak resident, KB | 143,856, 143,864, 143,864, 143,856, 143,856 | 143,408, 143,480, 143,484, 143,480, 143,484 | 143,856 | 143,480 | -0.3% | -0.3% to -0.3% |
| `parse -fsyntax-only` sqlite3.c | user + system, ms | 18.68, 18.65, 18.57, 18.67, 18.47 | 18.37, 18.68, 18.55, 18.49, 18.73 | 18.65 | 18.55 | -0.5% | -1.6% to +1.4% |
| `parse -fsyntax-only` sqlite3.c | wall, ms | 18.82, 18.77, 18.76, 18.82, 18.82 | 18.80, 18.76, 18.77, 18.78, 18.87 | 18.82 | 18.78 | -0.2% | -0.2% to +0.3% |
| compile and link 00216.c | minor faults | 603.00, 603.00, 603.00, 603.00, 603.00 | 607.00, 607.00, 607.00, 607.00, 608.00 | 603.00 | 607.00 | +0.7% | +0.7% to +0.8% |
| compile and link 00216.c | peak resident, KB | 43,992, 43,992, 43,972, 43,992, 43,980 | 44,128, 44,128, 44,120, 44,136, 44,120 | 43,992 | 44,128 | +0.3% | +0.3% to +0.3% |
| compile and link 00216.c | user + system, ms | 4.546, 4.596, 4.588, 4.488, 4.480 | 4.411, 4.483, 4.511, 4.528, 4.479 | 4.546 | 4.483 | -1.4% | -3.0% to +0.9% |
| compile and link 00216.c | wall, ms | 4.629, 4.601, 4.609, 4.625, 4.628 | 4.588, 4.658, 4.612, 4.637, 4.657 | 4.625 | 4.637 | +0.3% | -0.9% to +1.2% |

time-runs processes by status: base status 0: 525, head status 0: 525 (the refused `-funsigned-char` list of `main.c` left out of the table)

#### link-foreign (`benchmark-link --only linkers`)

| Workload | Metric | main, each round | head, each round | main median | head median | Change | Per-round changes |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |
| link-foreign 102,400 workers, a dynamic PIE | 1 thread, peak MB | 217.96, 217.96, 218.00 | 217.82, 217.81, 217.76 | 217.96 | 217.81 | -0.1% | -0.1% to -0.1% |
| link-foreign 102,400 workers, a dynamic PIE | 1 thread, µs | 52,341, 52,430, 51,510 | 51,326, 51,110, 50,706 | 52,341 | 51,110 | -2.4% | -2.5% to -1.6% |
| link-foreign 102,400 workers, a dynamic PIE | its threads, peak MB | 239.87, 240.04, 240.10 | 239.46, 239.28, 239.25 | 240.04 | 239.28 | -0.3% | -0.4% to -0.2% |
| link-foreign 102,400 workers, a dynamic PIE | its threads, µs | 28,835, 28,914, 28,950 | 29,168, 29,074, 28,480 | 28,914 | 29,074 | +0.6% | -1.6% to +1.2% |
| link-foreign 102,400 workers, a static executable | 1 thread, peak MB | 222.95, 222.78, 222.76 | 222.63, 222.67, 222.74 | 222.78 | 222.67 | -0.0% | -0.1% to -0.0% |
| link-foreign 102,400 workers, a static executable | 1 thread, µs | 54,143, 54,500, 54,393 | 54,309, 54,152, 54,938 | 54,393 | 54,309 | -0.2% | -0.6% to +1.0% |
| link-foreign 102,400 workers, a static executable | its threads, peak MB | 244.35, 244.56, 244.42 | 244.40, 244.22, 244.24 | 244.42 | 244.24 | -0.1% | -0.1% to +0.0% |
| link-foreign 102,400 workers, a static executable | its threads, µs | 29,153, 29,562, 29,909 | 30,112, 29,720, 29,774 | 29,562 | 29,774 | +0.7% | -0.5% to +3.3% |
| link-foreign 2,000 workers, a dynamic PIE | 1 thread, peak MB | 19.59, 19.54, 19.55 | 19.51, 19.36, 19.30 | 19.55 | 19.36 | -1.0% | -1.3% to -0.4% |
| link-foreign 2,000 workers, a dynamic PIE | 1 thread, µs | 1,237, 1,180, 1,171 | 1,157, 1,194, 1,250 | 1,180 | 1,194 | +1.3% | -6.5% to +6.8% |
| link-foreign 2,000 workers, a dynamic PIE | its threads, peak MB | 38.83, 39.26, 39.03 | 36.65, 38.99, 38.72 | 39.03 | 38.72 | -0.8% | -5.6% to -0.7% |
| link-foreign 2,000 workers, a dynamic PIE | its threads, µs | 2,365, 2,437, 2,466 | 2,426, 2,669, 2,543 | 2,437 | 2,543 | +4.4% | +2.6% to +9.5% |
| link-foreign 2,000 workers, a static executable | 1 thread, peak MB | 22.40, 22.40, 22.36 | 22.25, 22.30, 22.21 | 22.40 | 22.25 | -0.7% | -0.7% to -0.4% |
| link-foreign 2,000 workers, a static executable | 1 thread, µs | 1,870, 2,055, 2,096 | 2,040, 2,027, 2,045 | 2,055 | 2,040 | -0.7% | -2.5% to +9.1% |
| link-foreign 2,000 workers, a static executable | its threads, peak MB | 48.33, 48.15, 46.23 | 45.83, 47.89, 47.82 | 48.15 | 47.82 | -0.7% | -5.2% to +3.4% |
| link-foreign 2,000 workers, a static executable | its threads, µs | 3,668, 3,724, 3,610 | 3,644, 3,653, 3,611 | 3,668 | 3,644 | -0.7% | -1.9% to +0.0% |

#### Benchmarks

| Workload | Metric | main, each round | head, each round | main median | head median | Change | Per-round changes |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |
| assembler | scalar total, ms | 3.696, 3.697, 3.712, 3.685, 3.667 | 3.636, 3.637, 3.618, 3.614, 3.601 | 3.696 | 3.618 | -2.1% | -2.5% to -1.6% |
| assembler | vector total, ms | 1.484, 1.516, 1.448, 1.451, 1.458 | 1.470, 1.454, 1.472, 1.446, 1.452 | 1.458 | 1.454 | -0.3% | -4.1% to +1.7% |
| checker-bindings | batch, ns/token | 106.14, 106.58, 105.87 | 106.86, 106.89, 106.78 | 106.14 | 106.86 | +0.7% | +0.3% to +0.9% |
| checker-bindings | direct, ns/token | 104.53, 104.17, 104.02 | 104.74, 104.87, 104.83 | 104.17 | 104.83 | +0.6% | +0.2% to +0.8% |
| checker-bindings | parser-batch, ns/token | 131.17, 131.38, 130.55 | 130.63, 131.14, 131.26 | 131.17 | 131.14 | -0.0% | -0.4% to +0.5% |
| checker-bindings | parser-stacks, ns/token | 128.34, 129.34, 128.42 | 128.71, 129.28, 129.07 | 128.42 | 129.07 | +0.5% | -0.0% to +0.5% |
| checker-bindings | stacks, ns/token | 104.36, 104.32, 104.29 | 104.95, 104.87, 105.07 | 104.32 | 104.95 | +0.6% | +0.5% to +0.8% |
| checker-source | scalar, cycles/node | 272.96, 274.32, 274.47 | 316.28, 301.42, 286.93 | 274.32 | 301.42 | +9.9% | +4.5% to +15.9% |
| checker-source | scalar, ns/node | 49.44, 49.62, 49.74 | 57.22, 54.45, 51.96 | 49.62 | 54.45 | +9.7% | +4.5% to +15.7% |
| checker-source | vector, cycles/node | 297.98, 298.69, 297.70 | 328.35, 317.29, 307.57 | 297.98 | 317.29 | +6.5% | +3.3% to +10.2% |
| checker-source | vector, ns/node | 53.88, 53.96, 53.89 | 59.36, 57.27, 55.66 | 53.89 | 57.27 | +6.3% | +3.3% to +10.2% |
| debug | scalar, ns/row | 4.096, 4.085, 4.068 | 3.466, 3.477, 3.472 | 4.085 | 3.472 | -15.0% | -15.4% to -14.7% |
| debug | vector, ns/row | 2.148, 2.145, 2.143 | 2.148, 2.144, 2.144 | 2.145 | 2.144 | -0.0% | -0.0% to +0.0% |
| foreign-strings | duplicate 4096 merge-exact, µs | 1,570, 1,560, 1,576 | 1,573, 1,570, 1,582 | 1,570 | 1,573 | +0.1% | +0.1% to +0.7% |
| foreign-strings | duplicate 4096 merge-vector, µs | 522.70, 525.60, 514.90 | 525.80, 528.10, 522.60 | 522.70 | 525.80 | +0.6% | +0.5% to +1.5% |
| foreign-strings | duplicate 4096 nomerge-exact, µs | 616.50, 601.30, 583.10 | 630.80, 567.60, 579.00 | 601.30 | 579.00 | -3.7% | -5.6% to +2.3% |
| foreign-strings | duplicate 4096 nomerge-vector, µs | 402.20, 397.70, 411.60 | 398.70, 404.00, 406.10 | 402.20 | 404.00 | +0.4% | -1.3% to +1.6% |
| foreign-strings | duplicate 64 merge-exact, µs | 55.40, 52.80, 55.60 | 52.60, 55.30, 52.10 | 55.40 | 52.60 | -5.1% | -6.3% to +4.7% |
| foreign-strings | duplicate 64 merge-vector, µs | 36.00, 36.00, 36.40 | 35.20, 36.10, 34.90 | 36.00 | 35.20 | -2.2% | -4.1% to +0.3% |
| foreign-strings | duplicate 64 nomerge-exact, µs | 47.40, 43.40, 43.20 | 43.60, 42.30, 42.50 | 43.40 | 42.50 | -2.1% | -8.0% to -1.6% |
| foreign-strings | duplicate 64 nomerge-vector, µs | 39.30, 36.30, 35.20 | 33.20, 35.90, 33.80 | 36.30 | 33.80 | -6.9% | -15.5% to -1.1% |
| foreign-strings | unique 4096 merge-exact, µs | 1,482, 1,476, 1,480 | 1,484, 1,476, 1,501 | 1,480 | 1,484 | +0.2% | -0.0% to +1.4% |
| foreign-strings | unique 4096 merge-vector, µs | 449.50, 450.50, 450.50 | 439.70, 439.70, 449.30 | 450.50 | 439.70 | -2.4% | -2.4% to -0.3% |
| foreign-strings | unique 4096 nomerge-exact, µs | 564.00, 563.00, 562.10 | 558.70, 564.30, 556.50 | 563.00 | 558.70 | -0.8% | -1.0% to +0.2% |
| foreign-strings | unique 4096 nomerge-vector, µs | 393.70, 398.60, 387.10 | 396.70, 395.30, 394.60 | 393.70 | 395.30 | +0.4% | -0.8% to +1.9% |
| foreign-strings | unique 64 merge-exact, µs | 50.50, 52.00, 51.20 | 52.10, 51.10, 51.40 | 51.20 | 51.40 | +0.4% | -1.7% to +3.2% |
| foreign-strings | unique 64 merge-vector, µs | 35.00, 34.80, 33.90 | 34.70, 34.50, 34.30 | 34.80 | 34.50 | -0.9% | -0.9% to +1.2% |
| foreign-strings | unique 64 nomerge-exact, µs | 35.90, 38.90, 36.40 | 35.40, 34.90, 36.00 | 36.40 | 35.40 | -2.7% | -10.3% to -1.1% |
| foreign-strings | unique 64 nomerge-vector, µs | 34.00, 34.10, 33.60 | 34.00, 33.70, 33.30 | 34.00 | 33.70 | -0.9% | -1.2% to +0.0% |
| gnu | build-scalar, ns/token | 0.540, 0.540, 0.539 | 0.558, 0.540, 0.540 | 0.540 | 0.540 | +0.0% | +0.0% to +3.3% |
| gnu | build-vector, ns/token | 0.060, 0.060, 0.060 | 0.069, 0.063, 0.062 | 0.060 | 0.063 | +5.0% | +3.3% to +15.0% |
| gnu | collect-scalar, ns/token | 0.298, 0.298, 0.298 | 0.307, 0.299, 0.298 | 0.298 | 0.299 | +0.3% | +0.0% to +3.0% |
| gnu | collect-vector, ns/token | 0.033, 0.033, 0.033 | 0.037, 0.035, 0.034 | 0.033 | 0.035 | +6.1% | +3.0% to +12.1% |
| gnu | parser-only, ns/token | 12.14, 12.08, 12.07 | 12.21, 12.12, 12.21 | 12.08 | 12.21 | +1.1% | +0.3% to +1.1% |
| gnu | parser-with-gnu, ns/token | 12.28, 12.22, 12.24 | 12.26, 12.29, 12.33 | 12.24 | 12.29 | +0.4% | -0.2% to +0.7% |
| lexer | c_tokenize, instructions/B | 2.994, 2.994, 2.994, 2.994, 2.994 | 2.994, 2.994, 2.994, 2.994, 2.994 | 2.994 | 2.994 | +0.0% | +0.0% to +0.0% |
| lexer | c_tokenize, ms | 3.234, 3.228, 3.284, 3.251, 3.260 | 3.275, 3.249, 3.259, 3.243, 3.248 | 3.251 | 3.249 | -0.1% | -0.8% to +1.3% |
| lexer | c_tokenize_scalar, instructions/B | 24.38, 24.38, 24.38, 24.38, 24.38 | 24.38, 24.38, 24.38, 24.38, 24.38 | 24.38 | 24.38 | +0.0% | +0.0% to +0.0% |
| lexer | c_tokenize_scalar, ms | 34.67, 34.77, 34.72, 34.70, 34.82 | 35.41, 35.52, 35.40, 36.17, 35.53 | 34.72 | 35.52 | +2.3% | +2.0% to +4.2% |
| parser-bindings | batch, ms | 18.79, 17.11, 16.71 | 18.60, 16.49, 16.84 | 17.11 | 16.84 | -1.6% | -3.6% to +0.8% |
| parser-bindings | prepare, ms | 76.93, 76.81, 76.79 | 78.18, 78.80, 77.52 | 76.81 | 78.18 | +1.8% | +1.0% to +2.6% |
| parser-bindings | scalar, ms | 6.964, 6.984, 6.950 | 6.645, 6.639, 6.613 | 6.964 | 6.639 | -4.7% | -4.9% to -4.6% |
| parser-bindings | sort, ms | 4.716, 5.260, 5.430 | 5.016, 8.615, 5.600 | 5.260 | 5.600 | +6.5% | +3.1% to +63.8% |
| parser-bindings | source-batch, ms | 147.50, 145.56, 144.81 | 147.76, 147.05, 146.31 | 145.56 | 147.05 | +1.0% | +0.2% to +1.0% |
| parser-bindings | source-scalar, ms | 135.52, 134.71, 134.73 | 136.02, 136.58, 135.57 | 134.73 | 136.02 | +1.0% | +0.4% to +1.4% |
| x86-encoder | x86_encode_64, ns | 0.544, 0.555, 0.551, 0.554, 0.545 | 0.559, 0.556, 0.530, 0.544, 0.560 | 0.551 | 0.556 | +0.9% | -3.8% to +2.8% |

#### `benchmark-checker-source` again, six more rounds (run5.sh)

| Workload | Metric | main, each round | head, each round | main median | head median | Change | Per-round changes |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |
| more rounds: checker-source | scalar, cycles/node | 274.94, 274.02, 272.92, 273.17, 272.89, 272.96 | 286.94, 274.32, 273.01, 272.10, 283.04, 285.06 | 273.06 | 278.68 | +2.1% | -0.4% to +4.4% |
| more rounds: checker-source | scalar, ns/node | 49.71, 49.63, 49.43, 49.50, 49.45, 49.43 | 51.87, 49.69, 49.41, 49.30, 51.24, 51.59 | 49.47 | 50.47 | +2.0% | -0.4% to +4.4% |
| more rounds: checker-source | vector, cycles/node | 299.71, 298.23, 302.31, 299.25, 298.85, 299.14 | 307.94, 297.77, 297.45, 296.19, 304.43, 304.50 | 299.20 | 301.10 | +0.6% | -1.6% to +2.7% |
| more rounds: checker-source | vector, ns/node | 54.09, 53.92, 54.61, 54.09, 54.03, 54.07 | 55.63, 53.86, 53.77, 53.59, 55.05, 55.09 | 54.08 | 54.46 | +0.7% | -1.5% to +2.8% |

#### The checker's peak resident set

`-fsyntax-only` of `sqlite3.c` peaks 2,080 KB higher with the homes (+0.4%), in every process of both studies (2,064
KB in the first), where `-E`, `parse`, `-c` and the compile and link peak 0.2% to 0.3% lower or 0.3% higher.
`run4.sh` stopped each executable's run by gdb at its first `munmap` of more than 64 MB, when its arenas start to be
released and all are still mapped (at its exit only 16 MB are resident), twice each: VmHWM 590,128 KB on main and
592,132 KB with the homes, both times. Its mappings' resident bytes differ in one place that matters: the anonymous
mapping of about 232 MB that holds the executable's `.bss` (238.1 MB of static arrays), 2,048 KB resident on main and
4,096 KB with the homes, both transparent huge pages. With the homes the command touches static variables in three
units' `.bss` (the checker's, the front end's and the driver's) rather than one, which reaches a second 2 MB huge page
of the segment: kilobytes more touched, a huge page more resident. The executable's file pages differ by 12 KB.

## Assessment

Buster sets no numeric performance limit: the 9700X job's benchmarks are informational, compared with no baseline
(its `AGENTS.md`). Its `docs/profiling.md` measures the noise to judge against: builds of the same code in separate
processes differ by about 2%, where a variant's code lands moves it by up to about 1.5%, and a single round can be 5%
to 10% off. Against that, on the current pair:

- **Builds**: `build.sh` 36.6% faster without debug information (40.30 to 25.57 s) and 36.7% with it (50.73 to 32.12
  s), 39% less CPU, 14.0% less `.text`.
- **Generated code**: unchanged, byte for byte, over 657 outputs; the programs run as before by construction.
- **Whole drivers**: every median wall time within −0.2% to +0.8% (`-c`'s +0.8% is 29 µs of 3.7 ms), every peak
  resident set within −0.3% to +0.4% (the checker's 2 MB, above).
- **link-foreign**: within −2.4% to +1.3% but for the 2,000 workers' dynamic PIE on its threads, +4.4% on the medians
  of runs whose minimums are the same (2.19 to 2.34 ms on main, 2.24 to 2.44 ms with the homes) and whose maximums are
  outliers of the homes' (5.8 and 7.1 ms): scheduling in a link of 2.4 ms on eight threads. The same program's static
  executable is −0.7%, and the large program's links are within −2.4% and +0.7%.
- **Benchmarks** (each benchmark unit of its own keeps `static` copies of the homed modules, so their changes are
  their code's placement, as `docs/profiling.md` describes): within about ±2% but for, slower and faster:
  - the lexer's scalar twin, +2.3% with the same instructions per byte (+5.0% in the first study), where the lexer
    itself, `c_tokenize`, is −0.1%;
  - `benchmark-debug`'s scalar path, −15.0% (+2.5% in the first study), the vector path ±0.0%;
  - the parser bindings' scalar replay, −4.7% (−6.6% in the first study), and their source production
    (`prepare`), +1.8%;
  - the assembler's scalar path, −2.1%;
  - `benchmark-checker-source`, +9.7% scalar and +6.3% vector over `run3.sh`'s three rounds, falling from round to
    round; over `run5.sh`'s six more, +2.0% and +0.7%. Over the nine, main's processes take 49.4 to 49.7 ns/node and
    the head's either the same (49.3 to 49.7, three of the nine) or 3.6% to 15.7% more than their rounds' main (six): a slow state of a
    process, the same work in more cycles, that the first study saw once in main's four rounds and never in the
    head's. The checker's whole driver, which runs the same body checking on the same file, is +0.0%;
  - `benchmark-gnu`'s vector rows, +5.0% and +6.1% of 0.060 and 0.033 ns/token: 0.003 and 0.002 ns, under 0.02 cycles, per token;
  - the parser bindings' sort phase, whose rounds range over 4.7 to 8.6 ms in both trees of both studies, and
    `benchmark-foreign-strings`' cases of 64 strings, of 33 to 55 µs, which spread as much from round to round; its
    cases of 4,096 strings are within −3.7% and +0.6%.

No change of a whole driver passes the measured noise; the rows past it are placements of benchmark units' own copies
or states of single processes, which change sign between the two studies, and the slowest of them doesn't reach the
command it models.

## The first study (history): main `5863eeda` against `9b391d4b`

`first/scripts/run.sh` (the builds, the generated code, `ab --rounds 5` of ten benchmarks and of `time-runs` of
`-fsyntax-only` on `sqlite3.c` and on `main.c`) and `run2.sh` (`time-runs` of `-E`, `parse`, the compile and link and
`-c`, `ab --rounds 5`; then `link-foreign`). It was stopped when the reviews asked for the current pair: in `run.sh`'s
fourth round (the tables use the rounds both trees ran), and in `run2.sh`'s first round of `link-foreign`, which only
main ran (left out). Its `main.c` list passed `-funsigned-char`, which the checker refuses at once (status 1 in 1 ms),
so it timed a refusal and is left out of the tables.

#### Builds

| Configuration | Tree | `build.sh` wall, each round | Median | CPU (median) | Longest compiles (median) |
| --- | --- | --- | ---: | ---: | --- |
| debug information | base | 50.31, 51.82, 50.74 s | 50.74 s | 415 s | checker 50.7 s, backend 39.4 s, frontend 35.1 s |
| debug information | head | 31.91, 31.97, 31.94 s | 31.94 s | 254 s | checker 27.4 s, backend 25.3 s, frontend 21.5 s |
| debug information | change | | -37.1% | -38.8% | |
| `BUSTER_DEBUG_INFO=0` | base | 40.26, 40.67, 41.11 s | 40.67 s | 335 s | checker 40.6 s, backend 31.9 s, frontend 28.1 s |
| `BUSTER_DEBUG_INFO=0` | head | 25.52, 25.52, 25.48 s | 25.52 s | 202 s | checker 21.4 s, backend 20.2 s, frontend 17.1 s |
| `BUSTER_DEBUG_INFO=0` | change | | -37.3% | -39.8% | |

#### Generated code

- identity: 657 files the same, 0 different, 0 not written
- base outputs: 219 executables, 219 objects
- head outputs: 219 executables, 219 objects
- base -fsyntax-only sqlite3.c: status 0
- base -fsyntax-only main.c: status 1
- head -fsyntax-only sqlite3.c: status 0
- head -fsyntax-only main.c: status 1

#### Benchmarks

| Workload | Metric | main, each round | head, each round | main median | head median | Change | Per-round changes |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |
| assembler | scalar total, ms | 3.583, 3.634, 3.638, 3.584 | 3.547, 3.578, 3.596, 3.579 | 3.609 | 3.579 | -0.8% | -1.5% to -0.1% |
| assembler | vector total, ms | 1.391, 1.395, 1.428, 1.386 | 1.388, 1.385, 1.389, 1.410 | 1.393 | 1.389 | -0.3% | -2.7% to +1.7% |
| checker-bindings | batch, ns/token | 106.26, 105.90, 106.67, 106.86 | 106.14, 105.83, 105.84, 105.56 | 106.47 | 105.83 | -0.6% | -1.2% to -0.1% |
| checker-bindings | direct, ns/token | 104.15, 104.03, 104.73, 105.23 | 104.37, 103.94, 104.19, 103.87 | 104.44 | 104.06 | -0.4% | -1.3% to +0.2% |
| checker-bindings | parser-batch, ns/token | 130.72, 130.14, 130.98, 130.10 | 130.56, 130.23, 129.83, 130.26 | 130.43 | 130.25 | -0.1% | -0.9% to +0.1% |
| checker-bindings | parser-stacks, ns/token | 128.44, 128.05, 129.37, 127.75 | 128.62, 128.14, 128.12, 128.02 | 128.24 | 128.13 | -0.1% | -1.0% to +0.2% |
| checker-bindings | stacks, ns/token | 104.48, 104.50, 105.40, 104.40 | 104.72, 103.90, 104.16, 104.08 | 104.49 | 104.12 | -0.3% | -1.2% to +0.2% |
| checker-source | scalar, cycles/node | 274.57, 278.37, 313.61, 275.70 | 274.85, 274.08, 272.99, 274.88 | 277.04 | 274.47 | -0.9% | -13.0% to +0.1% |
| checker-source | scalar, ns/node | 49.74, 50.36, 56.93, 49.99 | 49.84, 49.67, 49.59, 49.80 | 50.17 | 49.74 | -0.9% | -12.9% to +0.2% |
| checker-source | vector, cycles/node | 298.00, 301.19, 325.78, 302.29 | 298.08, 298.02, 296.36, 297.89 | 301.74 | 297.96 | -1.3% | -9.0% to +0.0% |
| checker-source | vector, ns/node | 53.91, 54.45, 59.06, 54.68 | 53.96, 53.94, 53.93, 53.89 | 54.57 | 53.94 | -1.2% | -8.7% to +0.1% |
| debug | scalar, ns/row | 3.444, 3.457, 3.457 | 3.475, 3.547, 3.544 | 3.457 | 3.544 | +2.5% | +0.9% to +2.6% |
| debug | vector, ns/row | 2.146, 2.149, 2.148 | 2.147, 2.150, 2.164 | 2.148 | 2.150 | +0.1% | +0.0% to +0.7% |
| foreign-strings | duplicate 4096 merge-exact, µs | 1,573, 1,575, 1,580, 1,585 | 1,584, 1,591, 1,584, 1,583 | 1,577 | 1,584 | +0.4% | -0.1% to +1.0% |
| foreign-strings | duplicate 4096 merge-vector, µs | 528.50, 531.70, 530.80, 539.00 | 539.40, 543.20, 541.70, 549.30 | 531.25 | 542.45 | +2.1% | +1.9% to +2.2% |
| foreign-strings | duplicate 4096 nomerge-exact, µs | 577.60, 581.50, 582.60, 576.80 | 578.70, 593.20, 580.90, 578.80 | 579.55 | 579.85 | +0.1% | -0.3% to +2.0% |
| foreign-strings | duplicate 4096 nomerge-vector, µs | 403.80, 409.80, 404.20, 410.00 | 424.50, 410.30, 415.60, 412.70 | 407.00 | 414.15 | +1.8% | +0.1% to +5.1% |
| foreign-strings | duplicate 64 merge-exact, µs | 52.40, 53.00, 53.60, 54.70 | 51.90, 53.00, 52.20, 51.50 | 53.30 | 52.05 | -2.3% | -5.9% to +0.0% |
| foreign-strings | duplicate 64 merge-vector, µs | 35.00, 35.00, 35.50, 35.20 | 36.50, 35.90, 34.50, 36.40 | 35.10 | 36.15 | +3.0% | -2.8% to +4.3% |
| foreign-strings | duplicate 64 nomerge-exact, µs | 42.30, 41.00, 52.70, 43.10 | 44.20, 42.00, 48.10, 39.20 | 42.70 | 43.10 | +0.9% | -9.0% to +4.5% |
| foreign-strings | duplicate 64 nomerge-vector, µs | 33.70, 33.90, 34.60, 37.30 | 33.70, 34.70, 33.70, 50.80 | 34.25 | 34.20 | -0.1% | -2.6% to +36.2% |
| foreign-strings | unique 4096 merge-exact, µs | 1,501, 1,502, 1,501, 1,496 | 1,507, 1,504, 1,505, 1,506 | 1,501 | 1,506 | +0.3% | +0.2% to +0.6% |
| foreign-strings | unique 4096 merge-vector, µs | 459.90, 461.40, 454.20, 455.90 | 465.70, 462.00, 457.70, 462.40 | 457.90 | 462.20 | +0.9% | +0.1% to +1.4% |
| foreign-strings | unique 4096 nomerge-exact, µs | 569.10, 565.30, 567.80, 571.20 | 573.50, 575.10, 573.80, 580.20 | 568.45 | 574.45 | +1.1% | +0.8% to +1.7% |
| foreign-strings | unique 4096 nomerge-vector, µs | 403.60, 403.80, 400.20, 405.60 | 411.30, 408.40, 411.00, 415.60 | 403.70 | 411.15 | +1.8% | +1.1% to +2.7% |
| foreign-strings | unique 64 merge-exact, µs | 50.50, 50.60, 51.40, 54.50 | 52.50, 51.10, 50.50, 58.90 | 51.00 | 51.80 | +1.6% | -1.8% to +8.1% |
| foreign-strings | unique 64 merge-vector, µs | 34.20, 33.80, 36.50, 34.80 | 33.70, 35.30, 33.80, 34.70 | 34.50 | 34.25 | -0.7% | -7.4% to +4.4% |
| foreign-strings | unique 64 nomerge-exact, µs | 35.20, 36.20, 35.90, 43.60 | 36.00, 37.20, 36.70, 45.70 | 36.05 | 36.95 | +2.5% | +2.2% to +4.8% |
| foreign-strings | unique 64 nomerge-vector, µs | 33.20, 32.90, 36.80, 34.90 | 33.40, 34.30, 33.40, 34.00 | 34.05 | 33.70 | -1.0% | -9.2% to +4.3% |
| gnu | build-scalar, ns/token | 0.540, 0.542, 0.541, 0.540 | 0.540, 0.541, 0.540, 0.540 | 0.540 | 0.540 | -0.1% | -0.2% to +0.0% |
| gnu | build-vector, ns/token | 0.060, 0.061, 0.062, 0.061 | 0.063, 0.065, 0.062, 0.062 | 0.061 | 0.062 | +2.5% | +0.0% to +6.6% |
| gnu | collect-scalar, ns/token | 0.299, 0.298, 0.300, 0.300 | 0.299, 0.298, 0.298, 0.298 | 0.299 | 0.298 | -0.5% | -0.7% to +0.0% |
| gnu | collect-vector, ns/token | 0.035, 0.034, 0.034, 0.034 | 0.036, 0.035, 0.034, 0.034 | 0.034 | 0.035 | +1.5% | +0.0% to +2.9% |
| gnu | parser-only, ns/token | 12.11, 12.11, 12.13, 12.13 | 12.18, 12.13, 12.26, 12.22 | 12.12 | 12.20 | +0.7% | +0.2% to +1.1% |
| gnu | parser-with-gnu, ns/token | 12.30, 12.30, 12.29, 12.30 | 12.30, 12.31, 12.40, 12.41 | 12.30 | 12.35 | +0.4% | +0.0% to +0.9% |
| lexer | c_tokenize, instructions/B | 2.994, 2.994, 2.994 | 2.994, 2.994, 2.994 | 2.994 | 2.994 | +0.0% | +0.0% to +0.0% |
| lexer | c_tokenize, ms | 3.233, 3.237, 3.238 | 3.226, 3.239, 3.234 | 3.237 | 3.234 | -0.1% | -0.2% to +0.1% |
| lexer | c_tokenize_scalar, instructions/B | 24.38, 24.38, 24.38 | 24.38, 24.38, 24.38 | 24.38 | 24.38 | +0.0% | +0.0% to +0.0% |
| lexer | c_tokenize_scalar, ms | 34.44, 34.44, 34.59 | 35.87, 36.14, 36.19 | 34.44 | 36.14 | +5.0% | +4.2% to +5.0% |
| parser-bindings | batch, ms | 18.91, 16.94, 16.67, 16.72 | 16.35, 16.28, 18.36, 16.68 | 16.83 | 16.52 | -1.9% | -13.6% to +10.1% |
| parser-bindings | prepare, ms | 76.92, 77.12, 77.06, 76.90 | 77.13, 77.28, 77.13, 78.94 | 76.99 | 77.21 | +0.3% | +0.1% to +2.6% |
| parser-bindings | scalar, ms | 7.140, 7.110, 7.089, 7.089 | 6.614, 6.642, 6.573, 6.675 | 7.100 | 6.628 | -6.6% | -7.4% to -5.8% |
| parser-bindings | sort, ms | 4.688, 5.642, 6.627, 8.501 | 6.960, 6.952, 5.015, 5.656 | 6.135 | 6.304 | +2.8% | -33.5% to +48.5% |
| parser-bindings | source-batch, ms | 146.31, 145.57, 144.44, 145.05 | 144.95, 144.81, 146.50, 147.19 | 145.31 | 145.73 | +0.3% | -0.9% to +1.5% |
| parser-bindings | source-scalar, ms | 134.68, 134.94, 134.80, 135.06 | 135.00, 134.77, 134.59, 136.55 | 134.87 | 134.89 | +0.0% | -0.2% to +1.1% |
| x86-encoder | x86_encode_64, ns | 0.547, 0.552, 0.539 | 0.540, 0.551, 0.550 | 0.547 | 0.550 | +0.5% | -1.3% to +2.0% |

#### Whole drivers (`time-runs`, each round the median of its processes)

| Workload | Metric | main, each round | head, each round | main median | head median | Change | Per-round changes |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |
| `-E` sqlite3.c | minor faults | 777.00, 778.00, 777.00, 777.00, 777.00 | 774.00, 774.00, 774.00, 774.00, 774.00 | 777.00 | 774.00 | -0.4% | -0.5% to -0.4% |
| `-E` sqlite3.c | peak resident, KB | 59,152, 59,156, 59,140, 59,144, 59,148 | 59,004, 58,996, 58,992, 58,996, 58,996 | 59,148 | 58,996 | -0.3% | -0.3% to -0.3% |
| `-E` sqlite3.c | user + system, ms | 19.44, 19.25, 19.32, 19.36, 19.09 | 19.23, 19.33, 19.27, 19.02, 19.32 | 19.32 | 19.27 | -0.2% | -1.8% to +1.2% |
| `-E` sqlite3.c | wall, ms | 19.45, 19.43, 19.48, 19.43, 19.46 | 19.31, 19.39, 19.41, 19.39, 19.35 | 19.45 | 19.39 | -0.3% | -0.7% to -0.2% |
| `-c` 00216.c | minor faults | 567.00, 567.00, 567.00, 567.00, 567.00 | 570.00, 570.00, 570.00, 570.00, 570.00 | 567.00 | 570.00 | +0.5% | +0.5% to +0.5% |
| `-c` 00216.c | peak resident, KB | 39,572, 39,584, 39,576, 39,572, 39,584 | 39,456, 39,460, 39,452, 39,460, 39,464 | 39,576 | 39,460 | -0.3% | -0.3% to -0.3% |
| `-c` 00216.c | user + system, ms | 3.936, 3.514, 3.455, 3.520, 3.509 | 4.203, 3.510, 3.513, 3.539, 3.561 | 3.514 | 3.539 | +0.7% | -0.1% to +6.8% |
| `-c` 00216.c | wall, ms | 3.709, 3.729, 3.743, 3.656, 3.636 | 3.751, 3.790, 3.750, 3.773, 3.800 | 3.709 | 3.773 | +1.7% | +0.2% to +4.5% |
| `-fsyntax-only` sqlite3.c | minor faults | 1,759, 1,759, 1,761 | 1,765, 1,764, 1,766 | 1,759 | 1,765 | +0.3% | +0.3% to +0.3% |
| `-fsyntax-only` sqlite3.c | peak resident, KB | 589,956, 589,952, 589,976 | 592,012, 592,024, 592,020 | 589,956 | 592,020 | +0.3% | +0.3% to +0.4% |
| `-fsyntax-only` sqlite3.c | user + system, ms | 149.83, 149.35, 149.39 | 148.86, 149.22, 148.41 | 149.39 | 148.86 | -0.4% | -0.7% to -0.1% |
| `-fsyntax-only` sqlite3.c | wall, ms | 150.15, 149.94, 148.98 | 149.47, 149.77, 149.89 | 149.94 | 149.77 | -0.1% | -0.5% to +0.6% |
| `parse -fsyntax-only` sqlite3.c | minor faults | 904.00, 903.00, 903.00, 903.00, 903.00 | 897.00, 897.00, 897.00, 897.00, 898.00 | 903.00 | 897.00 | -0.7% | -0.8% to -0.6% |
| `parse -fsyntax-only` sqlite3.c | peak resident, KB | 143,708, 143,692, 143,696, 143,700, 143,696 | 143,312, 143,296, 143,312, 143,304, 143,300 | 143,696 | 143,304 | -0.3% | -0.3% to -0.3% |
| `parse -fsyntax-only` sqlite3.c | user + system, ms | 18.70, 18.58, 18.64, 18.77, 18.52 | 18.72, 18.65, 18.43, 18.69, 18.70 | 18.64 | 18.69 | +0.2% | -1.2% to +1.0% |
| `parse -fsyntax-only` sqlite3.c | wall, ms | 18.83, 18.80, 18.78, 18.78, 18.71 | 18.84, 18.84, 18.83, 18.90, 18.86 | 18.78 | 18.84 | +0.3% | +0.1% to +0.8% |
| compile and link 00216.c | minor faults | 604.00, 604.00, 604.00, 604.00, 604.00 | 607.00, 606.00, 606.00, 606.00, 606.00 | 604.00 | 606.00 | +0.3% | +0.3% to +0.5% |
| compile and link 00216.c | peak resident, KB | 44,064, 44,072, 44,060, 44,064, 44,068 | 44,212, 44,200, 44,204, 44,216, 44,212 | 44,064 | 44,212 | +0.3% | +0.3% to +0.3% |
| compile and link 00216.c | user + system, ms | 4.538, 4.698, 4.700, 4.339, 4.359 | 4.659, 4.355, 4.336, 4.689, 4.310 | 4.538 | 4.355 | -4.0% | -7.7% to +8.1% |
| compile and link 00216.c | wall, ms | 4.779, 4.783, 4.800, 4.783, 4.745 | 4.793, 4.796, 4.762, 4.813, 4.781 | 4.783 | 4.793 | +0.2% | -0.8% to +0.8% |

time-runs processes by status: base status 0: 453, base status 1: 33, head status 0: 453, head status 1: 33 (the refused `-funsigned-char` list of `main.c` left out of the table)

#### link-foreign (`benchmark-link --only linkers`)

| Workload | Metric | main, each round | head, each round | main median | head median | Change | Per-round changes |
| --- | --- | --- | --- | ---: | ---: | ---: | --- |


## Exploratory measurements (working trees, before the commits)

`exploratory/` has the measurements that chose the design, of three trees on the host as `tree-*.sha256` list them:
`base` (main `cefcb28d` but for `build.sh`'s report of every compile's time, not the three longest), and `proto` and
`final`, uncommitted states of the change on it. `scripts/sched.sh` compiled a tree's sources with `build.sh`'s flags
(without `-g`) scheduled several ways and timed each compile (`logs/sched.txt`, `logs/width.txt`): all at once (as
main's `build.sh`), at most 15 or 8 at once the longest first, the checker's unit pinned to CPU 2, `nice` for the
benchmarks, and each large unit alone. `logs/base.txt`, `proto.txt` and `final.txt` are the trees' builds, and
`logs/ab.txt` the first A/B, of `final` against `base` (`scripts/ab.sh`), replaced by the studies above: it held
the lock for a whole round, and its `-fsyntax-only sqlite3.c` timed a refusal (`--no-default-config`). The PR cites
from them: all at once 40.8 s on main and 29.8 s with the homes, one per core 32.3 s and 25.3 s, the checker's unit
alone 27.0 s and 17.7 s.
