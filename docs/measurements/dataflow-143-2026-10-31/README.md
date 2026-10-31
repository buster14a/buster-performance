# Phi-aware shared-IR dataflow on the 9700X: solve and prepare-solve (#143)

2026-10-31. This record measures the shared-IR dataflow adapter added for
[buster14a/buster#143](https://github.com/buster14a/buster/issues/143) by
[buster14a/buster#942](https://github.com/buster14a/buster/pull/942), on the
approved Ryzen 7 9700X. It covers `test-ir-source --dataflow-benchmark`: the
adapter's scalar and AVX-512 construction and solve over every accepted function
of the frozen corpora, in lowered, vector-promoted and scalar-promoted form. It
does not measure the selected-use/native-emission work of #354, and it does not
close #143.

## Revision and source identity

Measured code commit: `787d10710bad3c1772a7d47ca3122da149ba2128`
("Gate raw shared-IR dataflow fixtures on --dataflow-self-test"), which merges
main `c1c5ed02` into the PR's earlier head. The tree was extracted with
`git archive 787d1071`; `source-manifest.sha256` lists the SHA-256 of every
tracked file (842 entries; manifest SHA-256
`f85c71cd55ca9b458ff44aedf27ad70b652da937164580d9c06a5dceef06de19`).
The later documentation-only commit that links this record is not part of the
measured code.

The benchmark binary was built on the measurement host from that tree:

| Item | Value |
| --- | --- |
| `build/compiler` SHA-256 | `53880cf5aa3666a4f76efe6f851c12971ba816c1a16d8b4bd500d5312181a373` |
| Build command | `BUSTER_DEBUG_INFO=0 ./build.sh` |
| Build compiler | clang 23.1.1, `-march=native` (znver5) |
| Build result | 41 sources compiled in 36.1 s |

## Host and run control

The runner is `benchpress`, an AMD Ryzen 7 9700X 8-core processor (16 threads,
microcode `0xb404038`), kernel `6.18.50-2-lts`, clang 23.1.1, perf 7.2.9-1.
CPU 2 was used for every timed process:

```text
CPU 2: online, governor performance, EPP performance
thread_siblings_list: 2       (CPU 10 is offline)
on-line CPUs: 0-9,11-15
```

Each command took the shared 9700X lock separately:

```sh
env EXCLUSIVE_OWNER=opencode-942 \
    EXCLUSIVE_TITLE="PR 942 dataflow" \
    EXCLUSIVE_LINK="https://github.com/buster14a/buster/pull/942" \
    ~/buster-fast-bench/exclusive.sh taskset -c 2 ./build/compiler ...
```

The exact corpus scripts are in `scripts/`. Each script redirects the compiler's
stdout and stderr to the logs here and writes its exit status to a `.status`
file. Every status is `exit=0`.

## Inputs

The frozen preprocessing corpus is
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, identified by
`MANIFESTS.sha256` `391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd`.
Its README records SQLite **3.53.2** (`sqlite3.c` SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`) and
Zig 0.14.1-vendored musl 1.2.5 (Zig commit
`d03a147ea0a590ca711b3db07106effc559b0fc6`), with the generated-header overlay
in `musl-generated/`. The pinned GNU17 predefines are
`provenance/gnu17-pinned-predefines.txt` (SHA-256
`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`).

The c-testsuite input is commit
`5c7275656d751de0e68b2d340a95b5681858ed07`; the command passes the 220
programs named by `tests/c-testsuite/subset.txt`, fetched on the host as the
9700X job fetches it.

## Commands

The corpus commands are the same source lists and options as the correctness
manifest's `test-ir-source` invocations, with `--dataflow-benchmark` added. The
scripts are:

```sh
scripts/bench-testsuite.sh
scripts/bench-sqlite.sh
scripts/bench-musl.sh
```

SQLite and musl were each run in two independent processes; c-testsuite ran
once. The second-process scripts are `scripts/bench-sqlite-2.sh` and
`scripts/bench-musl-2.sh`.

## Method

`--dataflow-benchmark` measures every accepted function's three forms:

- `lowered`: the typed stream lowered into the shared IR;
- `promoted-vector`: the vector SSA promotion;
- `promoted-scalar`: the scalar SSA promotion.

For each form it reports four variants: `solve` and `prepare-solve`, each by
the scalar and AVX-512 paths. `solve` times only the fixpoint and the phi
live-out restoration. `prepare-solve` also includes structural verification,
CFG and dense-map construction, allocation and use/def construction. The
frontend, IR lowering, SSA promotion and correctness oracles are outside every
sample.

Each form's warm-up calibrates repetitions toward 250 µs per batch. Twenty-one
passes rotate the four variants' order. The reported figures are medians of the
21 per-pass samples, in hardware CPU cycles (`PERF_COUNT_HW_CPU_CYCLES`) and
instructions; a failed or zero counter endpoint invalidates the sample. Every
run printed `qualified=1`, `left_out=0`, `dataflow_failed=0` and
`vector_host=1`, so the AVX-512 host path was used rather than the scalar
fallback.

The aggregate speedup below is `sum(scalar cycles_per_function) /
sum(vector cycles_per_function)` over the forms of one operation. It is
dominated by the largest functions. The median per-form ratio is the median of
`vector cycles_per_function / scalar cycles_per_function`; a value below 1
means the vector path was faster for the typical form.

## Results

All runs qualified. The corpus counts are the same as the correctness runs on
this binary (without the benchmark flag):

| Corpus | Files | Functions | Forms | Dataflow checks |
| --- | ---: | ---: | ---: | ---: |
| c-testsuite subset | 220 | 430 | 1,290 | 9,030 |
| SQLite 3.53.2 | 1 | 2,602 | 7,806 | 54,642 |
| musl 1.2.5 units | 1,355 | 2,883 | 8,649 | 60,543 |

### First process

| Corpus | Operation | Pairs | Sum vector cycles | Sum scalar cycles | Aggregate speedup | Median ratio | p10 | p90 | Vector faster / slower |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | solve | 7,806 | 4,975,906 | 6,546,983 | **1.316×** | 0.950 | 0.735 | 1.209 | 4,995 / 2,811 |
| SQLite | prepare-solve | 7,806 | 153,219,928 | 127,682,196 | **0.833×** | 1.291 | 1.130 | 1.530 | 53 / 7,753 |
| musl | solve | 8,649 | 2,535,908 | 2,758,504 | **1.088×** | 0.830 | 0.643 | 1.193 | 6,493 / 2,156 |
| musl | prepare-solve | 8,649 | 81,436,900 | 65,715,999 | **0.807×** | 1.333 | 1.079 | 1.729 | 265 / 8,384 |
| c-testsuite | solve | 1,290 | 108,842 | 109,108 | **1.002×** | 1.044 | 0.720 | 1.242 | 636 / 654 |
| c-testsuite | prepare-solve | 1,290 | 5,493,772 | 4,364,837 | **0.795×** | 1.397 | 1.088 | 1.777 | 37 / 1,253 |

### Second process

The second processes confirm the direction of the first. They are separate
`test-ir-source --dataflow-benchmark` invocations, each with its own 21 passes
and calibration.

| Corpus | Operation | Aggregate speedup | Median ratio | p10 | p90 | Vector faster / slower |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | solve | 1.311× | 0.926 | 0.749 | 1.210 | 4,989 / 2,817 |
| SQLite | prepare-solve | 0.828× | 1.298 | 1.138 | 1.532 | 46 / 7,760 |
| musl | solve | 1.088× | 0.766 | 0.708 | 1.193 | 6,589 / 2,060 |
| musl | prepare-solve | 0.792× | 1.344 | 1.105 | 1.726 | 163 / 8,486 |

### By form

First process only. `agg` is the aggregate speedup; `med` is the median
per-form ratio (below 1 favors the vector path).

| Corpus | Form | solve agg | solve med | prepare agg | prepare med |
| --- | --- | ---: | ---: | ---: | ---: |
| SQLite | lowered | 1.200× | 0.924 | 0.873× | 1.215 |
| SQLite | promoted-vector | 1.362× | 0.975 | 0.814× | 1.322 |
| SQLite | promoted-scalar | 1.365× | 0.975 | 0.812× | 1.323 |
| musl | lowered | 1.025× | 0.828 | 0.850× | 1.270 |
| musl | promoted-vector | 1.117× | 0.834 | 0.785× | 1.365 |
| musl | promoted-scalar | 1.116× | 0.848 | 0.783× | 1.360 |
| c-testsuite | lowered | 1.096× | 0.870 | 0.789× | 1.423 |
| c-testsuite | promoted-vector | 0.949× | 1.135 | 0.798× | 1.378 |
| c-testsuite | promoted-scalar | 0.954× | 1.140 | 0.798× | 1.377 |

## What the numbers say

- **Solve.** The AVX-512 fixpoint is faster in aggregate on SQLite (1.32×) and
  musl (1.09×), and at parity on the c-testsuite subset (1.002×). The median
  per-form ratio is mixed: musl's typical form is faster (0.83), while SQLite's
  and c-testsuite's typical form is slightly slower (0.95 and 1.04), with large
  functions accounting for the aggregate gain. A uniform per-function speedup
  is not claimed.
- **Prepare-solve.** The AVX-512 construction is slower than its scalar twin on
  every corpus: 0.83× SQLite, 0.81× musl and 0.79× c-testsuite in aggregate,
  with median per-form ratios of 1.29, 1.33 and 1.40 (vector over scalar).
  The masked gathers, verification, allocation and dense-map construction do
  not pay for themselves at these function sizes. The adapter therefore
  provides the vector path and its scalar twin for correctness and future
  consumers, but this record does not support selecting it for construction.
  Existing measured solver dispatch is unchanged.

The second process moves the median ratios by up to about 0.06 but not the
direction or the aggregate conclusion. The prepare-solve result is not a
noise-level difference.

## Limits

- The aggregate is the sum of per-form medians, not a whole-compiler runtime.
  Frontend, lowering, promotion and output are excluded. The figures answer
  what the adapter's two operations cost, not what `-c` costs.
- `prepare-solve` includes preparation, so its block/sweep-normalized figures
  are not pure solver costs.
- The record covers one host, one CPU (CPU 2), one kernel/toolchain/microcode
  and one build. SQLite and musl have two independent processes; c-testsuite
  has one. No cross-host or SMT-sibling comparison is made.
- The c-testsuite input is the declared 220-program subset, not all of
  c-testsuite.
- `vector_host=1` records that the AVX-512 host path ran; it is not a claim
  that every function's vector form was faster.
- This is not #143's final whole-pipeline acceptance and does not qualify the
  selected-use/native-emission work of #354.

## Files

| Path | Contents |
| --- | --- |
| `logs/bench-*.out.xz` | complete stdout of every benchmark process (all 21-pass samples and summaries), xz-compressed |
| `logs/bench-*.status` | exit status of each process |
| `logs/bench-*.err` | stderr of each process (empty) |
| `logs/bench-sha256.txt` | SHA-256 of every log, status, error file and `build/compiler` |
| `scripts/bench-*.sh` | exact corpus commands run under the lock |
| `summaries/bench-summary.tsv` | per-corpus, per-process, per-form aggregates |
| `summaries/bench-summary.json` | the same with raw sums and quantiles |
| `summaries/summarize.py` | parser that derives the summaries from the logs |
| `source-manifest.sha256` | every tracked file of the measured tree |

The raw logs are compressed with `xz -1`; decompress with `xz -dc`. The
summaries are derived only from the summary lines in those logs. To reproduce,
extract `source-manifest.sha256`'s tree at `787d1071`, build with
`BUSTER_DEBUG_INFO=0 ./build.sh`, fetch the c-testsuite commit and run the
scripts under the shared lock on the same corpus.
