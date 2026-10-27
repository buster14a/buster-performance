# VLA declaration record spans, Buster #611

The reader previously visited every retained VLA record for each variably modified declaration and each definition's parameter activation. The implementation retains the append range introduced by a declaration's specifiers/declarator, and retains each definition header's range in its deferred-body cut. Typedef reuse introduces no record; the original source-token and declaration/body filters still apply within each range. A suspended `typeof` job saves the declaration's append mark.

For the one-bound typedef input, the declaration association visits N records in total, replacing N(N+1)/2 visits. It preserves the existing scalar record updates; there is no new dense table, allocation or SIMD kernel. The useful unit here is one new bound per declaration, with ordered ownership and lifetime publication.

## Identities and reproduction

- Frozen main: `92c025e71856d13eb34247477c5294d2cead139e`.
- Implementation: `ee3da53d58bc0b963563bae067261f31987d90fb`.
- Both are Buster source trees. Full tracked-file SHA-256 manifests are retained and checked against the remote trees before running.
- Hardware: AMD Ryzen 7 9700X; native Clang release builds, `BUSTER_DEBUG_INFO=0 ./build.sh`, with the normal build flags recorded in each source's `build.sh` and `compile_commands.json`.
- Every build, test and measurement on that machine uses its shared exclusive lock. Timed processes use CPU 2 and `--lanes 1`. No machine settings are changed.
- `generate.c` is retained unchanged from [the discovery generator](https://github.com/buster14a/buster-performance/blob/7d25666880d5bbdce838bab7e0f79a31d70d4c78/docs/measurements/performance-audit-2026-10-27/generate.c), Git blob `25513713be2c167c157581438072beadb0a8b267`. It is original project material under its retained Apache-2.0 WITH LLVM-exception notice. Input N is 2,000, 4,000, 8,000, 16,000 and 32,000.
- Run `bash run.sh ROOT`, where `ROOT/base` and `ROOT/head` are the built source trees and `ROOT/evidence/generate.c` is this generator. The script retains exact command arguments in the `time-runs` output. The measurement harness is Buster's existing `profile.c` at the implementation revision.
- Scaling uses one warmup and 11 fresh-process samples per executable/input, in rotating order. SQLite uses one placement and three fresh inode copies each of base, head and base-again, with the same warmup and 11 samples per copy. This is an instruction/scaling experiment, not a multi-placement qualification of small timing deltas.

## Results

All 110 timed scaling processes exited 0. User counters were available for every process. Medians and wall ranges from `scaling.txt`:

| N | Base wall ms (range) | Head wall ms (range) | Base instructions | Head instructions | Base / head peak KiB |
|---:|---:|---:|---:|---:|---:|
| 2,000 | 16.798 (13.349–24.906) | 4.064 (4.004–23.248) | 70,455,117 | 46,492,243 | 41,560 / 41,532 |
| 4,000 | 9.828 (9.393–11.070) | 6.498 (6.290–6.597) | 173,115,041 | 77,190,182 | 62,716 / 62,616 |
| 8,000 | 28.212 (22.399–28.487) | 10.670 (10.384–10.767) | 522,515,055 | 138,666,187 | 84,596 / 84,584 |
| 16,000 | 89.334 (70.297–90.181) | 19.306 (19.057–19.672) | 1,797,293,900 | 261,597,005 | 135,748 / 135,672 |
| 32,000 | 249.305 (232.084–319.189) | 34.744 (34.571–35.301) | 6,650,980,156 | 507,587,203 | 205,892 / 204,048 |

At 32k this is 92.368% fewer instructions and 86.064% less median wall time (7.175× faster). From 16k to 32k, the head's instructions grow 1.940×, versus the base's 3.701×. The code change removes the quadratic record-association term; the measured complete compilation becomes approximately linear over these shapes. These timings exercise declaration association; parameter activation has correctness coverage, without a separate large-header timing claim. Small-input wall time is noisy and nonmonotone, so the stable instruction counts establish scaling more strongly than those time ratios. All samples have zero major faults. The table does not establish a memory reduction.

The SQLite control (`sqlite.txt`) has 99 timed status-zero processes: 33 samples each of base, head and base-again over three inode copies. Its source hash is `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

| Build | Median wall ms | Median user cycles, millions | Median instructions |
|---|---:|---:|---:|
| Base | 144.184 | 679.082 | 1,529,804,093 |
| Head | 143.963 | 677.443 | 1,529,975,178 |
| Base-again | 144.021 | 678.536 | 1,529,804,096 |

Head's wall delta is −0.15%, with per-copy comparisons from −0.47% to +0.33%; base-again is −0.11%, from −0.68% to +0.43%. Cycles are −0.24% for head and −0.08% for base-again, with mixed per-copy signs. These small timing differences overlap process/copy variability and do not establish a SQLite speedup or precise neutrality. Head incurs about 0.0112% more instructions. Per-copy median peak RSS stays around 506,000 KiB for all three builds; every sample has zero major faults. Only one placement is measured.

## Correctness and limits

The local Ryzen 9 7940HS / Clang 23.1.4 build succeeded. A standalone O0 ASan/UBSan invocation of the committed VLA metadata/scaling tests (`focus.sh`) passed 69 checks, including both reader paths at every size. This diagnostic makes the compiler's module homes static in a temporary copy of `main.c`; it does not change production sources or establish whole-compiler sanitizer acceptance.

The production local compiler's `test-checker-corpus --clang /usr/bin/clang --deferred 1 runtime.c vla-2000.c vla-4000.c vla-8000.c vla-16000.c vla-32000.c` passed all six files (434,255 tokens), with no acceptance, diagnostic, scalar/vector or deferred differences. `runtime.c` also compiled and ran against Clang O0 on eight inputs, with identical results for nested typedef/typeof/comma-declarator captures and a side-effectful parameter bound. Its outputs are retained.

The full local `test-checker --seed 133` completed 265,577 checks with four failures, all in the existing `fpclassify-conditional-selector-effects` / `fpclassify-known-category-effects` oracle fixtures (two paths each). Their exact local outputs match the documented Clang 23.1.4 selector-effect ordering difference: `512434` vs `512344`, and `1512430` vs `1512340`. This is recorded as a failing local suite, not a pass.

On the approved 9700X, the same release implementation passes the complete `test-checker --seed 133`: 265,577 checks, zero failures. `test-checker-deferred` passes 70 fixtures / 1,113 checks, with 684 merged results and 6,492 bodies read apart, zero failures. Its existing schedules cover 1, 2, 3 and 8 lanes; the new header-span fixture includes unrelated prototypes, nested callback bounds and several definitions. Each test command holds the shared host lock independently. These are manual target runs, distinct from pull-request CI.

Original regressions cover scalar/vector reader metadata at every input size, unique bound captures, exact declaration owners and scope starts, side-effectful bounds, typedef reuse, nested blocks, comma declarators, nested parameter prototypes and deferred-body schedules. Clang runs externally as an oracle; no compiler implementation or external corpus code is incorporated.

`run.sh` also compares the baseline and implementation objects byte for byte at all five VLA sizes. This separate object/stage verification command is queued at this checkpoint; no object-equality result is claimed yet. One diagnostic `--time-stages` compile per source/input locates the removed work but does not establish a stage-time distribution. Frozen SQLite is an external control input, identified by hash; its source and system headers are not incorporated here.

Lock wait messages are excluded because they can identify unrelated private sessions. Build logs retain only this build's `build.sh:` lines; the object-test harness directs compiler stage output to separate files, away from the lock's stderr. The local checker excerpt retains the failing values, fixture names and final tally. Fresh-process measurement rows and summaries are unchanged. The record makes no corpus-wide VLA frequency or generated-program speedup claim.
