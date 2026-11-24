# Designated initializer member lookup on the Ryzen 7 9700X

[Buster issue #1498](https://github.com/buster14a/buster/issues/1498) and [implementation PR #1589](https://github.com/buster14a/buster/pull/1589).

## Whole-process results

Median wall time and retired user instructions per compile across 24 rotated runs on CPU 2, with two warmups. All 240 measured compiler processes exited successfully. [Per-process observations](raw/time-runs.txt)

| Fields × initializers | Wall, base (ms) | Wall, head (ms) | Change | Instructions, base (millions) | Instructions, head (millions) |
| --- | ---: | ---: | ---: | ---: | ---: |
| 16 × 1 | 0.955 | 0.803 | −15.9% | 0.828 | 0.827 |
| 16 × 128 | 1.385 | 1.298 | −6.3% | 12.778 | 12.654 |
| 4,096 × 1 | 6.518 | 3.712 | −43.0% | 134.061 | 41.964 |
| 4,096 × 4 | 20.509 | 8.435 | −58.9% | 481.120 | 112.734 |
| 1,024 promoted names × 4 | 3.584 | 2.935 | −18.1% | 37.710 | 31.456 |

The largest instruction reduction comes from the wide record repeated four times. For the single 16-field control, the instruction medians differ by only 1,051. Process startup and binary placement limit what the small-input timings say about the cost of lookup itself.

## Counter cross-check

Six additional alternating pairs per input, each using `perf stat -r 3`, gave the following median within-pair changes. Task clock measures CPU time during compilation. The 16-field controls straddled zero across pairs.

| Fields × initializers | Task clock, paired change (range) | Retired user instructions, paired change |
| --- | ---: | ---: |
| 16 × 1 | +1.4% (−5.4% to +30.6%) | −0.1% |
| 16 × 128 | +3.1% (−3.8% to +10.8%) | −1.0% |
| 4,096 × 1 | −46.2% (−46.6% to −43.1%) | −68.7% |
| 4,096 × 4 | −60.2% (−60.9% to −58.9%) | −76.6% |
| 1,024 promoted names × 4 | −7.8% (−9.6% to −5.2%) | −16.6% |

Perf reported zero for its additional `duration_time` event on this host. Wall times in this record come from Buster's `time-runs` driver. The task clock and hardware counters were populated in all 60 observations. A second 24-run latency comparison gave 6.553 → 3.732 ms for the wide input and 20.509 → 8.633 ms for its repeated form. All 240 processes in that repeat exited successfully. [Paired summaries](summary.tsv) · [Per-round observations](raw/samples.tsv) · [Raw perf output](raw/perf-stat.txt) · [Load and process snapshots](raw/process-snapshots.txt) · [Lock diagnostics](raw/lock-busy.txt) · [Repeated latency comparison](raw/time-runs-repeat.txt)

## Revisions and workload

| Build | Buster commit | Lookup |
| --- | --- | --- |
| Base | `b1a07174146f2739ab893a1a4807e6ce899adde7` | Walk the direct members, then search anonymous members on a miss |
| Head | `02949d095d223a494b474efc3af859bf9a7e9dbf` | Use the record's bounded scan, hash index or capacity fallback |

Head is the direct child of base. The only production code change between them is in `c_check_initializer.c`. Both were built with Clang 23.1.4, `BUSTER_HOST_ARCH=znver5 ./build.sh --config Release --jobs 8`, with the default debug info and baked executable. The compiler processes used CPU 2. Each warmup and timed command acquired the shared Benchpress lock independently.

Each translation unit defines an array of records. Every field is an `unsigned char` and every row names every field once in reverse declaration order. Values depend on both row and field. The anonymous case promotes the names of 16 anonymous structs with 64 fields each. The two 16-field controls use the bounded scan. Every workload goes through the ordinary `-std=c11 -c` driver, including preprocessing, checking and ELF emission.

## Correctness and assembly

Each dumped ELF `.data` section was compared byte for byte with the expected row-major values for that input. The checks cover both measured binaries and Clang. The independent build of current Buster `7515714d05caa655e8c2e1e2776e07aa9b8058df` passed the same comparisons on the cloud EPYC. With Clang 23.1.4, `test-checker --part 62/64` passed 3,457 checks, including the lookup boundary and exhausted-capacity regressions, and `test-checker --program-initializers` passed 2,642. [Current-main logs](current-main/)

The original loop compares one 32-bit member name and advances its index. In the new binary, the designator calls `check_init_member`. Its indexed vector path loads a bucket's eight names, compares them with `vpcmpeqd`, and selects the matching slot with `tzcnt`. The loop can continue to the next bucket on a collision. [Release disassembly](raw/assembly.txt)

## Reproduction

From the campaign directory with the two Buster trees at `base/` and `head/`, run the following on Benchpress.

```sh
mkdir -p raw
./build-pair.sh
./measure.sh
./time-runs.sh
./repeat-latency.sh
```

The harness generates the original inputs and expected bytes with `fixture.c` and `shapes.txt`. It warms both compilers on each file and checks their bytes. For each workload it measures six pairs, alternating which build goes first. Each observation is one `perf stat -r 3` invocation. The repetitions measure run-to-run variation for one binary layout per revision. The fixtures model the issue's input shape and do not estimate its frequency in other programs.

A separate invocation of Buster’s `time-runs` compares wall time across 24 rotated runs, after two warmups, for the same builds and input files on CPU 2. [Whole-process latency report](raw/time-runs.txt)
