# Tier 0 validation: campaign and review repairs

Evidence for Buster PR #650 / issue #569. The original campaign completed on
October 27, 2026; review repairs and new qualification are from October 28.
Results distinguish those revisions. Harnesses are original C project work;
they include the named Buster checkout, without copying its modules or an
external fixture corpus into this record.

## Original campaign, recovered without rerunning

The archived source corresponds to main `8ab9a2081de1f67ac6fb79325c8bfd3caf0f46a9`
and code in `97e8693c2d19da07e902eeebe28e0db82de36002` (the last commit adds
documentation). All 488 baseline and 489 head files under `src/` match the
benchpress snapshots by SHA-256: see `*-sources.sha256` and
`*-source-verification.txt`. This verifies source bytes, not new executions.

Ryzen 7 9700X, Clang 23.1.1, Linux/x86-64, `BUSTER_DEBUG_INFO=0 ./build.sh`,
shared host lock, timed commands pinned to CPU 2. `identities.txt` records CPU,
compiler, frozen input and binary hashes; `campaign/common.sh` gives every
option. The external SQLite source hash is
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
It is a runtime input, not an imported source file here.

`qualification.log` removes other sessions' lock-wait owner lines. Its own
results and original scripts are retained. Adjust `campaign/common.sh` to a
new scratch directory when reproducing; its original paths name the old run.

`measure-head.txt` / `measure-main.txt` retain 21 interleaved rounds in each
reference direction. Whole compile medians are about 148.0 ms baseline and
144.3 ms head; `lower` drops from 16.178 to 13.032 ms. Objects from both and
from all three one-binary switch modes have the same SHA-256:
`0c48ff92978c3125b1822a1552eb48d2742ea09d80176488d8dc5320c4afe91f`.

The completed second hold supplies the previously unpublished residual cost.
`stages-*.txt` retains eleven runs per mode on the same switch executable:

| Mode | lower median | span median |
| --- | ---: | ---: |
| Vector | 13.020 ms | 144.261 ms |
| Scalar | 15.662 ms | 146.697 ms |
| Disabled control | 12.146 ms | 142.929 ms |

Vector validation retains about 0.874 ms of lowering cost in this control,
versus 3.516 ms for scalar checking. Disabled validation is measurement-only;
production validates before backend consumers use untrusted indices.

`perf/` preserves eight rotated rounds, each `perf stat -r 3`. Arithmetic
means of their reported process means, rather than medians:

| Mode | user cycles | user instructions | task-clock |
| --- | ---: | ---: | ---: |
| Vector | 677,383,348 | 1,517,492,254 | 143.887 ms |
| Scalar | 692,684,967 | 1,558,319,478 | 146.648 ms |
| Disabled | 673,659,879 | 1,505,602,134 | 143.256 ms |

Vector/disabled user-cycle ranges overlap (674.37–681.08 M / 670.51–676.26 M);
the instruction difference is about 11.89 M. The switch removes executable
layout differences between modes, not all variation. The old controller's
final `test-tier0 times` heading has no corresponding output and establishes
no test result. Fresh results below replace that missing evidence.

Backend-source rows retain 1.96–1.98 ns, 10.86–10.96 cycles and 29.51
instructions per entry for vector validation, versus 8.35 ns, 46.30 cycles and
129.52 instructions for scalar. They cover 2,602 functions / 396,893 entries.

## Review repairs and tests

Code `949a2a7f4f49c831e57225f84655e58f325fcb2d` fixes both P1 findings:

- Basic block validity gates scalar producer and class-dependent checks.
  Underflow followed by a valid-target jump cannot turn byte depth 255 into
  an out-of-range producer index.
- More than 64 total call operands defer to the complete scalar validator.
  A maximum-arity indirect call's 65th operand is no longer omitted.
- Each stream column has its own inaccessible page at its logical end.
  Interacting underflow/invalid-class plus call/arrival cases and
  direct/indirect 63/64-argument cross-block cases are included.

Local optimized `test-tier0 --seed 569 --count 64`: 88,874 checks, zero
failures. The focused production-validator harness `review/validation.c`
passes ASan/UBSan over the 559,200-stream matrix and 3,224 assertions,
including all fourteen new interacting regressions. Local 7940HS results are
correctness evidence only.

Independent mutations detect both defects. Removing block validity gates
triggers ASan stack-buffer-overflow. Removing >64 operand refusal makes the
valid fallback assertion and malformed last-argument assertion fail. Logs
are retained as expected failures. To reproduce, put the modified `tier0.c`
under `M/buster/compiler/`, pass `-IM` before `-Isrc`, and build
`review/regressions.c`.

Example from the named Buster checkout:

```sh
clang -O1 -g -fsanitize=address,undefined -fno-sanitize-recover=all \
  -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing \
  -Wno-unused-function /path/to/record/review/validation.c \
  -o /scratch/validation -lpthread -lm
/scratch/validation
```

Use `cores` for multicore builds and long single-core commands where installed.
Every 9700X build/test/measurement also takes the shared `exclusive.sh` lock,
with `EXCLUSIVE_OWNER`, `EXCLUSIVE_TITLE` and `EXCLUSIVE_LINK` set, per run.

## New target-host qualification

The repaired source builds all 41 optimized units in 31.8 s on the locked
9700X. `test-tier0 --seed 569 --count 128 --cross-check` passes 152,942 checks,
including the unchanged scalar/vector code and native/Clang comparisons.
Additional size controls and the resulting dispatch choice are recorded below
before submission.

`review/buckets.c` times complete production validators on 0,1,2,4,8,16,
24,32,48,64,128,256,1024 entries. Shapes are table-free CONST/DISCARD pairs
(and a terminal RETURN for odd counts) and the same stream with the test
fixture's eight locals, six calls and four argument records. Acceptance is
checked before timings. Each mode calibrates to at least 2 ms, then seven
samples rotate vector/scalar order. Counters measure hardware user cycles
and instructions; clock time uses CLOCK_MONOTONIC_RAW.

Three fresh normal processes and one fresh process with 200 ms of scalar
validation before each sample agree on a crossover between 16 and 24 entries.
Means of all retained samples (ns/call):

| Shape / entries | normal scalar | normal vector | conditioned scalar | conditioned vector |
| --- | ---: | ---: | ---: | ---: |
| Plain / 0 | 14.55 | 11.91 | 14.64 | 11.77 |
| Plain / 1 | 15.79 | 70.63 | 16.04 | 70.53 |
| Plain / 8 | 34.83 | 70.18 | 34.91 | 71.10 |
| Plain / 16 | 60.03 | 70.12 | 60.75 | 70.41 |
| Plain / 24 | 89.77 | 71.02 | 83.49 | 71.37 |
| Metadata / 16 | 100.59 | 116.89 | 104.13 | 117.10 |
| Metadata / 24 | 121.07 | 117.38 | 124.18 | 118.42 |
| Plain / 1024 | 2545.39 | 1041.15 | 2677.10 | 1040.36 |

Commit `006b872a` chooses scalar validation for nonempty streams through 16
entries, provided each local/call/argument table has at most 16 entries too.
Empty streams retain vector setup; large tables retain vector
validation so entry count cannot hide metadata work. The vector acceptor
remains independently tested on tiny streams, and stream fixtures now compare
the selected wrapper's exact error, node and rule with the scalar oracle.
The table limit is a conservative guard, not a measured universal optimum.
These are synthetic size controls, not proof of a whole-corpus speedup.

The historical same-binary disabled control bounds the remaining opportunity
for fusion/reusing Tier 0's analysis at about 0.874 ms on this input. Its
11.89 M user instructions include validation setup, metadata, scratch and
stream processing together. The validator deliberately continues to run before
unchecked backend consumers. Sharing a validated plan would need a new
producer/consumer contract and its own measured comparison; no fused-analysis
speedup or eliminated correctness gate is claimed by this PR. The measured
issue's requested reduction in `lower` is established with identical objects.
