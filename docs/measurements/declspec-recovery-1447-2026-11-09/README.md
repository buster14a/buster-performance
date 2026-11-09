# Declaration-specifier recovery, error-free units, base vs head on the 9700X (#1447, PR #1820)

Raw evidence for [buster14a/buster#1820](https://github.com/buster14a/buster/pull/1820), "Checker: recover
declaration specifiers that don't combine, as clang's DeclSpec does"
([#1447](https://github.com/buster14a/buster/issues/1447)). Its head changes the loops of two operand readers that
error-free units run: `check_constant_specifiers`, which reads `typeof`'s and `_Atomic`'s type names, and the enum
base reader. This checks that error-free `-fsyntax-only` doesn't pay for that.

## Identity

- **Date:** 2026-11-09, by an agent session (Claude Code), each run under `~/buster-fast-bench/exclusive.sh`.
- **Base:** buster main `cb608c1f616f8fe26234bcaaa869caccc571de63`.
- **Head:** `00ed85d`, branch `recovery/1447-file-scope-errors` (main `cb608c1f` merged in, and the PR's commits).
- **Host:** `benchpress`, AMD Ryzen 7 9700X.
- **Builds:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` in each tree.
- **Inputs:**
  - SQLite's `sqlite3.c`, `~/buster-fast-bench/refine-claude/inputs/sqlite3.c`, with no options;
  - the base tree's `src/buster/compiler/main.c` with `-march=native -Isrc -fwrapv -funsigned-char`.

## Commands

`run.sh` here: `taskset -c 2 perf stat -x, -e instructions:u,cycles:u -r 5`, interleaved base and head.
It was planned for three rounds, but it was stopped after two, together with the third round's first base run.
The coordinating session asked every #1447 session to cut its load on the shared host. The instruction counts are
exact to a few hundred thousand instructions per input from round to round, so two rounds settle the difference.
`perf.txt` holds the raw output, with the lock's waiting lines.

## Results

Means of 5 runs each, instructions:u:

| input | base r1 | base r2 | head r1 | head r2 | change |
|---|---|---|---|---|---|
| `sqlite3.c` | 975,508,580 | 975,508,581 | 975,377,659 | 975,367,549 | −0.014% |
| `main.c` | 26,612,235,801 | 26,612,352,653 | 26,612,387,238 | 26,612,325,648 | +0.0003% |

- `main.c`'s change is within base's own round-to-round spread (117K instructions).
- Cycles:u spread 0.1% to 1.9% from run to run and show no difference either:
  - `sqlite3.c`: 445.8M and 443.8M for base, 452.7M and 445.1M for head;
  - `main.c`: 10.57G and 10.78G for base, 10.49G and 10.38G for head.
