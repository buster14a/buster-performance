# Tier 1 parallel moves, issue #608

This campaign measures the complete resolver call, including validation,
allocation, indexing/sorting, dependency construction, move emission and arena
reset. Input generation and semantic verification are outside timing. These are
synthetic resolver measurements, separate from default Tier 0 compilation and
from whole-program compiler performance.

Source: Buster `e2dcb4b63c2611946be26a424a4618f6b584cfb8`, based on
`92c025e71856d13eb34247477c5294d2cead139e`. The original scan is retained as
`tier1_resolve_moves_scalar`; its body is unchanged from the base apart from its
name. The indexed scalar and vector variants differ only in initialization;
dispatch selects the original scan through eight moves and indexed vector above
that boundary. The harness verifies exact output agreement with the original
scan and executes the result against simultaneous snapshot assignments before
timing each case.

The five general shapes are N-move chains (`i -> i+1`), reversed input order of
that same chain, independent moves (`N+i -> i`), one long cycle (`(i+1)%N -> i`),
and fan-out (`0 -> i+1`), at N = 32, 64, 128, 256, 512 and 1024. Separate
one-through-six-move chains cover the current production caller's nonempty size range.
The API's opaque location domain and maximum count are correctness-tested in
the compiler suite, outside this timing matrix.

`moves_benchmark.c`, `moves_check.c` and the compiler's new fixtures are original
project work under Apache-2.0 WITH LLVM-exception. No external implementation,
fixture corpus or generated dataset is incorporated. Linux perf counter ids,
instruction semantics and C language rules are interface/specification facts.

## Method and reproduction

Use the approved Ryzen 7 9700X under its shared `exclusive.sh` lock for every
build, test and measurement. Pin benchmark processes to CPU 2. Build the harness
against the pinned source:

```sh
clang -O3 -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing \
  -Wall -Wextra -Werror /path/to/moves_benchmark.c -pthread -o moves-benchmark
taskset -c 2 ./moves-benchmark
```

Each variant calibrates to at least 2 ms, then reports the median of eleven
samples. The four variants rotate order between samples. Instructions and core
cycles come from user-only Linux hardware counters, opened per process; missing
counters fail the campaign. Three independent processes release the lock between
them. Arena creation and first-touch effects are warmed by verification and
calibration; the reported per-call cost includes arena reset but excludes arena
reservation/release. Peak and retained byte columns are exact arena-size formulas
for the aligned, initially empty arena, rather than process RSS measurements.

`qualify608.sh` records the actual remote commands and per-run lock boundaries.
Its absolute working locations are campaign-specific. It also runs the
allocation, emission, liveness, selection and native pipeline suites, the
compiler call-graph check, and an ASan/UBSan build of `moves_check.c` with 20,000
shuffled random comparisons against the original scan, in addition to the
compiler's maximum-count, guarded-tail, snapshot and rollback fixtures.

## Current caller relevance

At the pinned source, `tier1_emit_call` is the only production caller. The
`tier1_select_call_supported` preparation guard accepts at most six arguments,
using the six integer argument registers. The production dispatch therefore
keeps that caller on the original small scan. General CFG/phi-edge emission
remains a separate integration requirement. This campaign establishes resolver
scalability; it makes no whole-corpus compile-time improvement claim.

## Validation

The approved locked 9700X built the full compiler and both harnesses successfully.
The compiler's 41 translation units compiled in 31.9 s, with debug information
disabled as in CI. The standard parallel runner then passed all seven commands
in 8.0 s under one lock, with an eight-core budget:

- `test-tier1-allocation --seed 608 --count 4000`: 21,832 checks, zero failures.
- `test-tier1-emit`: 179,701 checks, zero failures, including 23,208 spill stores
  and reloads and 3,316 rematerializations.
- `test-tier1-pipeline --cross-check`: 3,514 checks, zero failures; 1,024 native
  executions and 512 Clang comparisons, with eight expected unsupported cases.
- `test-tier1-liveness`: 20,433 checks, zero failures, on generated IR.
- `test-tier1-select`: 179,458 checks, zero failures. Its existing output still
  reports incomplete Zen 5 model IDs; this campaign does not qualify that model.
- `./build.sh check-call-graph`: 41 translation units, 23,974 functions,
  143,480 calls, zero unapproved cycles, and three existing allowed fuzzer cycles.
- The resolver-only ASan/UBSan harness: 20,122 checks, zero failures and no
  diagnostics, with leak detection and UBSan halt-on-error enabled.

These generated-IR/native checks do not establish full Tier 1 C-source corpus
acceptance. The local Ryzen 9 7940HS also passed the 20,122 focused checks;
that run is correctness evidence only and supplies no timing claim here.

`logs/validation.log` records the successful run. `logs/status.log` also preserves an
initial command-list formatting rejection, before any test executed; the list
was corrected to use the runner's required `==` headings, and qualification
resumed from the successful build using `qualify608.sh --resume`.

## Measured scaling

All three processes completed with `valid=1`, with 144 measured rows each.
Ranges below are the minimum and maximum of the three process medians;
instruction columns are the median of those three per-call readings, rounded
to whole instructions. Times include the complete resolver and arena reset.

For the adversarial 1024-move chain, the original scan took
**116.487–117.449 ms**, and production dispatch took
**13.309–13.314 microseconds**: about **8,800 times faster in this resolver
microbenchmark**. Retired instructions fell from 3,842,936,080 to 420,805.
The original source's 537,395,200 inner-loop iterations are logical iterations,
separate from these measured retired-instruction counts.

| Chain moves | Original scan, microseconds/call | Dispatch, microseconds/call | Original instructions/call | Dispatch instructions/call |
| ---: | ---: | ---: | ---: | ---: |
| 32 | 3.799–3.841 | 0.250–0.253 | 136,291 | 9,293 |
| 64 | 27.847–28.376 | 0.557–0.558 | 1,007,325 | 19,928 |
| 128 | 217.920–219.882 | 1.216–1.221 | 7,755,805 | 42,859 |
| 256 | 1802.321–1808.632 | 2.652–2.656 | 60,890,108 | 92,062 |
| 512 | 14642.586–15124.821 | 5.711–5.747 | 482,600,788 | 197,170 |
| 1024 | 116487.272–117448.937 | 13.309–13.314 | 3,842,936,080 | 420,805 |

Doubling N increases the original chain's instruction work by 7.39–7.96 times
and dispatch's by 2.13–2.15 times. The source algorithm supplies the O(N log N)
bound: streaming merge passes, one binary lookup per source, at most one heap
insertion/removal per move, and a cursor that advances at most N times.
There is no all-pairs destination validation or repeated pending-source scan
on the general path.

All five shapes at N = 1024:

| Shape | Original scan, microseconds/call | Dispatch, microseconds/call | Original instructions/call | Dispatch instructions/call |
| --- | ---: | ---: | ---: | ---: |
| chain | 116487.272–117448.937 | 13.309–13.314 | 3,842,936,080 | 420,805 |
| reversed-chain | 469.027–540.982 | 11.807–12.161 | 14,035,535 | 410,565 |
| independent | 477.175–541.300 | 20.885–21.116 | 14,035,535 | 549,521 |
| cycle | 717.218–784.659 | 12.931–13.184 | 23,238,296 | 420,798 |
| fan-out | 467.791–540.980 | 21.093–21.178 | 14,035,535 | 594,577 |

The selected long-cycle orientation, reversed chain, independent moves and
fan-out have quadratic work in the original scan; the forward chain is its
cubic worst case. The input orientations are defined above and in the harness.

Dispatch's measured work across every requested shape and size:

| Shape / instructions per call | 32 | 64 | 128 | 256 | 512 | 1024 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| chain | 9,293 | 19,928 | 42,859 | 92,062 | 197,170 | 420,805 |
| reversed-chain | 9,133 | 19,544 | 41,963 | 90,014 | 192,562 | 410,565 |
| independent | 10,187 | 22,971 | 51,437 | 114,304 | 251,530 | 549,521 |
| cycle | 9,296 | 19,929 | 42,858 | 92,059 | 197,165 | 420,798 |
| fan-out | 11,275 | 25,275 | 56,301 | 124,544 | 273,034 | 594,577 |

At N = 1024 the new call uses 44 KiB of arena space at its peak, versus 21 KiB
for the original scan; each retains 16 KiB of output columns. At the full
2^20-move API limit the corresponding general-path bound is 44 MiB, plus
alignment, with 16 MiB retained. The maximum-count chain passed correctness
checks; it is outside the timed matrix.

### SIMD preparation and the small path

The indexed vector initializer is 2.9–5.3% faster than the indexed scalar
initializer in the median-of-process-medians comparison at N = 1024 across the
five shapes. Sorting, ownership lookup and minimum-ready scheduling are shared
scalar operations; these results measure their complete preparation/consumer
path, rather than initialization alone. The captured assembly includes masked
`vmovdqu32` input loads/stores, `vpmovzxdq`, and masked `vmovdqu64` key
stores. The cycle/heap scheduling preserves the original ordered policy;
the implementation does not claim a fully vectorized move resolver.

These are warmed, interleaved measurements. Isolated and explicitly
scalar-conditioned power states were not measured separately in this campaign.
The data establish the algorithmic scaling and this recorded execution state.

The production cutoff keeps the original scan through eight moves, preserving
its smaller arena requirement for the current caller. The tiny-chain data also
expose a future tuning opportunity: forced indexing wins at four through six
moves, while the original scan wins at one and two, and three varies across
processes. The actual caller's identity/cycle/chain distribution has not been
profiled. The cutoff preserves the existing small-case algorithm and memory
budget; these chains do not establish an optimal cutoff or corpus speedup.

| Nonempty caller-size chain | Original scan, ns/call | Production dispatch, ns/call | Forced indexed vector, ns/call |
| ---: | ---: | ---: | ---: |
| 1 | 6.875–6.888 | 6.871–6.886 | 9.964–9.987 |
| 2 | 11.276–11.605 | 11.268–11.601 | 15.885–15.937 |
| 3 | 19.584–29.402 | 18.892–31.547 | 22.415–22.761 |
| 4 | 44.651–50.029 | 44.666–50.545 | 26.577–28.054 |
| 5 | 79.340–92.535 | 79.026–93.736 | 36.801–37.307 |
| 6 | 107.476–117.383 | 106.910–117.510 | 43.811–44.878 |

## Recorded host and artifacts

Measurements finished on 2026-10-27 at 21:11:35 UTC on the approved AMD Ryzen 7
9700X, Linux 6.18.50-2-lts, Clang 23.1.1. CPU 2's governor and EPP both reported
`performance`; its SMT sibling, CPU 10, was offline. Every benchmark process
was pinned to CPU 2 and acquired/released the shared lock separately.

- [Raw measurement process 1](logs/benchmark-1.log),
  [process 2](logs/benchmark-2.log), [process 3](logs/benchmark-3.log).
- [Build](logs/build-final.log), [successful validation](logs/validation.log),
  [controller status](logs/status.log), and [exact test list](validation608.list).
- [Host/compiler/binary/source identities](logs/identity.log) and
  [compiled assembly](logs/benchmark-assembly.txt).

The benchmark binary SHA-256 is
`598c543ae8b8525b630c7e97024cfee6769b75af2f120ea58d81fea3f2a35e4c`.
The recorded source and harness hashes match the pinned checkout and archived
C files. The harnesses reuse Buster's existing arena/lane component under its
retained MIT terms; the new harness bodies and report are original project work.
