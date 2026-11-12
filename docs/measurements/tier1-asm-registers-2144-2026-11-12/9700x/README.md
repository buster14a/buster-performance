# Tier 1 asm bodies' register operands in registers — #2144, 2026-11-12

For [buster#2144](https://github.com/buster14a/buster/issues/2144), PR
[buster#2470](https://github.com/buster14a/buster/pull/2470): the #1839 record's
six asm kernels ([tier1-asm-bodies-1839-2026-11-11](../tier1-asm-bodies-1839-2026-11-11/README.md),
the same `kernels.c`, sha256 `043774e1…5deb5c`) built by `--tier1` with base and
head, and by head's default Tier 0 for reference.

## Run

- Base: buster main `c1986fd5`; head: `c1b62086` (PR #2470's first commit). Each
  built on `benchpress` by `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`
  (Release), each build under its own hold of the lock (`build2.sh`); sha256 in
  `sha256.txt`.
- One hold of the shared lock for the run (`~/buster-fast-bench/exclusive.sh ./run.sh`),
  each process pinned with `taskset -c 2`, wall time from `date +%s%N`, 7 rounds,
  each running the three builds of a kernel in turn (`run.sh`, `run.log`,
  `kernels.tsv`). Every build's output matched clang -O0's before timing; all 8
  functions were Tier 1's in both `--tier1` builds, with no fallback
  (`report-base.txt`, `report-head.txt`).

## Results

Medians in milliseconds (min and max in `kernels.tsv`).

| Kernel | `--tier1` base | `--tier1` head | change | Tier 0 (head) |
|---|---:|---:|---:|---:|
| rdtsc | 138.17 | 137.99 | −0.1% | 138.00 |
| cpuid | 50.99 | 50.47 | −1.0% | 51.31 |
| flag output | 73.13 | **39.82** | −45.5% | 62.96 |
| `"c"` shift | 77.55 | **73.06** | −5.8% | 64.05 |
| x87 fsqrt | 293.30 | 293.21 | 0.0% | 293.11 |
| mulq | 91.09 | **46.10** | −49.4% | 77.19 |

| 100M iterations | base cycles | head cycles | base instructions | head instructions |
|---|---:|---:|---:|---:|
| flag output | 401.3M | 215.9M | 2,000.9M | 1,400.7M |
| mulq | 500.9M | 250.8M | 2,801.0M | 1,800.8M |

(`perf stat` of the shift kernel is in `run.log`.)

- Text of the kernels: 1,776 bytes base, 1,552 head (Tier 0's 2,032), 2 calls each (`sizes.txt`).
- Tier 1's bodies now beat Tier 0's on the flag and mulq kernels: their inputs
  reach the body in registers rather than through the operand block, and the loop's
  values stay out of the registers the body touches instead of being saved and
  restored around it each iteration. The shift kernel keeps its `+r` output's
  store through its address (#2144's item 2, register outputs as results, is
  left), so it gains less and still trails Tier 0.

## Limitations

- One host, 7 rounds, microkernels of one statement each.
- Default (Tier 0) compiles don't take the changed paths; `-fsyntax-only` and
  `-c` of main.c and sqlite3.c aren't measured here for that reason.
