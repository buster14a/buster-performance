# Release's tests unoptimized, and the Tier 1 self-built compiler (2026-11-13)

Two campaigns on the 9700X (`benchpress`), each step its own hold of the lock (`scripts/lock.sh`), with CI's staged
Clang 23.1.4 (`scripts/env.sh`), from buster at `a11e44ac` (buster#2633's head), the base:

1. [buster#2626](https://github.com/buster14a/buster/issues/2626): the tests' own functions unoptimized in Release's
   other units, as #681 did for the checker's (the stage 1 design's lever 2). **Refused by its rule: a benchmark moves
   outside its floor.**
2. [buster#2630](https://github.com/buster14a/buster/issues/2630)'s step 1: a compiler wholly self-built at Tier 1.
   **`test-tier0` passes**, where the stage 1 design's record (`c5f0efb2`) had 1,824 failures.

## 1. Release's tests unoptimized (#2626)

**The head** (`head.patch`): every `*_test.c` and `*_tests.c` that `main.c` includes outside #681's regions (121 of
them, in 91 regions) between `#pragma clang optimize off` and `on`, but `foreign_test.c`, which includes
`foreign_strings_benchmark.c`.

**The units' compiles.** On the 4-CPU cloud container (Release flags, `-g`, one at a time): the front end's unit 56.5 s
to 34.5 s, the backend's 169.3 s to 89.8 s (not the 9700X's times).

**The build on the 9700X** (`results/buildtimes.tsv`, `scripts/buildtimes.sh`; eight jobs, `-g`, two rounds):

| Case | base | head |
| --- | ---: | ---: |
| clean Release build | 72.0, 71.7 s | 67.6, 68.5 s |
| the backend's unit's time alone | 31.8, 32.0 s | 19.1, 19.0 s |
| the front end's unit's time alone | 21.0, 20.8 s | 13.3, 13.3 s |

The 9700X job's own build (`results/builds.txt`, znver5, no debug information, with its four placements): 55.2 s and
296 s of CPU against 53.0 s and 247 s.

**The tests' run time** (`results/tests/`, `scripts/tests.sh`: the stage 1 design's 21 commands): 34.1 and 34.2 s
against 38.1 and 38.1 s, **+11.5%**.

**The benchmarks.** `results/triage-head.txt` (`scripts/triage.sh`): each of the 9700X job's 69 benchmarks once by the
base's and the head's executables (placement 0), user instructions and cycles. 45 run the same instructions; **24 run
other code**:

| Benchmark | Instructions | Cycles (one run) |
| --- | ---: | ---: |
| `benchmark-ir` | +10.52% | +6.78% |
| `benchmark-assembler` | +7.45% | +3.87% |
| `benchmark-ir-lowering` | +3.75% | -0.11% |
| `benchmark-x86-zen5` | +3.17% | +19.62% |
| `benchmark-dominators --cfg` | +1.80% | +0.78% |
| `benchmark-calling-convention` | +1.08% | +0.85% |
| `benchmark-lanes` | +0.88% | +6.21% |
| `benchmark-checker-bindings` (headers) | +0.87% | +0.22% |
| `benchmark-lowering` | +0.49% | +1.84% |
| `benchmark-ir-optimize-passes` | -3.54% | -3.33% |
| 14 more, of the front end, the checker and Tier 1 | -1.00% to +0.29% | |

`benchmark-x86-zen5` and `benchmark-ir` size their own work, so their counts don't compare; time-runs over the four
placements (`results/bench/`, `scripts/bench.sh`, 7 runs, the base again as the floor) decide:

| Benchmark | head against base, user cycles | base again |
| --- | ---: | ---: |
| `benchmark-assembler` | **+3.66%** (+3.09% to +4.53%) | -0.05% (-0.69% to +0.73%) |
| `benchmark-ir` | -0.01% (-0.36% to +0.41%) | +0.15% (-0.49% to +0.73%) |
| `benchmark-ir-optimize-passes` | -2.32% (-4.28% to +3.30%) | -0.11% (-3.61% to +4.07%) |

`benchmark-assembler` is outside its floor, so by the issue's rule Release keeps optimizing its tests. The cause is
#2624's finding 2: a test function calls product helpers, and an `optnone` caller keeps a static helper's out-of-line
copy, so the product's own call to it loses LLVM's last-call-to-static bonus and isn't inlined. `assembler_test.c` is
in the assembler's unit, with `benchmark-assembler`.

## 2. The Tier 1 self-built compiler (#2630, step 1)

`scripts/selfbuild.sh`: the base's own Release executable (`placements/base/compiler-0`) compiles each of the 43
units of `./build.sh print-sources` at `--tier1`, with the build's flags without debug information less `-O3`,
`-Wall` and `-Werror` (`self/options.txt`); the base tree's own Release link joins them (`self/link.txt`).

- **`test-tier0` passes**: 14,561,628 checks, 0 failed (`self/test-tier0.log`), the unsigned floating groups among
  them (1,430 and 4,374 checks). The stage 1 design's record had 1,824 failures in those two groups at `c5f0efb2`;
  something among the 309 commits since fixed them. The cloud container's self-build of the same kind (`local/`,
  `-march=native` on an AVX-512 Xeon) passes too.
- **The correctness inventory** (`scripts/inventory2630.sh`, 12 shards, the self-built executable as the runner, so
  every command's `BUSTER_COMPILER`): 141 commands, **137 passed**, 4 failed (`results/inventory2630/summary.txt`), each
  for what the self-built executable is rather than what it computes:
  - `build-regression --ownership-only` needs an executable inside a build tree ("a detached compiler copy");
  - `test-preprocessor` looks for `src/buster/include` beside the executable's build directory;
  - two parts of the integer builtins' Clang comparison require the oracle to be the Clang that built the executable:
    the test compares the `__clang_*` macros it was compiled with, and buster's own predefines say 23.1.3 where the
    release is 23.1.4. A self-build given the release's predefines (`--predefines`) would pass that gate.

**In a build tree, with the release's predefines** (`scripts/selftree.sh`, `selfp/`, `results/inventory2630p/`): step 1
done.

- **The build.** The same self-build, given `--predefines selfp/predefines.h`, which is `clang -dM -E` with the units'
  flags by CI's Clang 23.1.4 (`selfp/clang.txt`). Buster's own predefines differ from clang's only in the patch
  release's version macros and `__BUSTER__`, which no product code tests. 43 units compiled, 0 failed. The executable
  was copied over the `ci2630` tree's Release executable, the original kept beside it (`selfp/placed.txt`).
- **The 4 commands that failed** pass (`results/inventory2630p/failed.log`).
- **The whole inventory**, 12 shards, each its own hold: 141 commands, 138 passed. The 3 that failed open their
  `--report` files under `build/` for exclusive creation. They are the frozen SQLite source against Clang, the
  frozen corpus subset, and the oracle's accounting. The first inventory in the same tree had left
  `build/oracle-{sqlite,libc,musl}.tsv` there (13:31). With those moved aside, the 3 pass
  (`results/inventory2630p/stale.log`). So **141 of 141** pass.
