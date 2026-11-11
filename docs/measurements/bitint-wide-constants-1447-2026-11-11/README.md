# `_BitInt` constants past 128 bits, Buster #1447 (PRs #2161, #2193, #2227)

Package C1 of #1447 made the checker fold `_BitInt(N)` constants for N > 128 (#2161), warn of their value-changing
conversions (#2193), and fold the bit and alignment builtins of them (#2227). The paths that take wide constants are
cold branches beside `check_action_integer_type`, which still refuses those widths; no corpus unit has a wide
constant. This record checks what the narrow code pays, base against head, on the 9700X.

## Sources and host

- **base:** `d43c37e5192d7e5d62df822aa2ce5c1f3facb5ca`, main before #2161.
- **head, run 1 (`logs/pr2161/`):** `571deed0d479a172b1b91f75d6a5784c294069e1`, #2161 as merged.
- **head, run 2 (`logs/c05367b/`):** `c05367b4ed73c81c6f52da4e0b6fa17f0d42630f`, #2161 with #2193 merged in and a
  guard that asks `check_action_convert_plain`'s wide branch only for a constant. #2227 carried both to main.

Each tree was a fresh clone at its commit, built by `BUSTER_DEBUG_INFO=0 ./build.sh` (Release, native) under the
host's lock (`build-*.log`). Executables' and objects' SHA-256, the kernel and clang are in each `receipt.txt`: AMD
Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1.

Inputs:
- the 9700X job's frozen `sqlite3.c` (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`,
  with the job's `-D` options);
- the head tree's `src/buster/compiler/main.c` (`-march=native -Isrc -fwrapv -funsigned-char`), the same source for
  both compilers.

## Method

`scripts/run.sh` (`BASE`, `HEAD_REF`):
1. builds both trees;
2. compiles each input with `-c`, pinned to CPU 2, and compares the objects;
3. runs `ab --rounds 7 --cpu 2 --lock exclusive.sh` of `time-runs --runs 5`, base and head, `-fsyntax-only` of each
   input.

`ab` takes the lock per run and orders the trees by its Williams design. Each round reports each build's median of 5
runs: wall time, user cycles and user instructions (`ab-*.log`).

## Results

The table gives the means of the 7 rounds' medians. Each column group is wall ms / user cycles / user instructions,
then head against base.

| Run | Input | Base | Head | Head against base |
|---|---|---|---|---|
| 1 (#2161) | sqlite3.c | 96.869 / 455.41M / 991.604M | 97.080 / 456.15M / 993.688M | +0.22% / +0.16% / +0.21% (+2.08M) |
| 1 (#2161) | main.c | 582.746 / 2914.37M / 8770.65M | 581.878 / 2908.23M / 8791.26M | −0.15% / −0.21% / +0.23% (+20.6M) |
| 2 (c05367b) | sqlite3.c | 96.660 / 453.97M / 991.605M | 96.668 / 454.40M / 993.874M | +0.01% / +0.10% / +0.23% (+2.27M) |
| 2 (c05367b) | main.c | 583.191 / 2914.10M / 8770.70M | 584.606 / 2920.82M / 8799.48M | +0.24% / +0.23% / +0.33% (+28.8M) |

**Objects.** The `-c` objects are byte-identical, base and head, for both inputs in both runs (`receipt.txt`).

**Wall time and cycles.** Both stay inside their rounds' spread. The rounds' sqlite3.c wall medians range 96.3 to
97.6 ms on both sides, and head beats base in some rounds and loses in others.

**Instructions.** They rise consistently in every round: about 0.2% from #2161, and a further 0.02% (sqlite3.c) and
0.1% (main.c) with #2193's conversion-warning candidates. The guard (asking about a wide conversion only for a
constant) did not remove the 0.2%.

**Where the instructions go.** This is not located. A callgrind profile in a cloud container stopped at the parser,
whose arena reservation valgrind's address space refused. That run covered preprocessing only, which agreed within
0.003%.

## Limitations

- One machine and one toolchain. 7 rounds of 5 processes per input, with no relative-layout variation.
- The instruction increase is measured, not attributed.
