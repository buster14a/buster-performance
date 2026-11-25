# Direct-to-ELF compiler measurements on benchpress

On the Ryzen 7 9700X, six musl iconv tables compiled 2.06× faster, a generated 4,000-function inline chain compiled 5.44× faster, and a generated file with 50,000 locals compiled 11.00× faster. SQLite took 0.7–1.0% less time on one core and 1.5–2.0% less time with four simultaneous compiles across two sessions.

The baseline was `56490ed95ac23b1634b0252d8ee1405e54947418`. Both builds used the same source directory, the host’s pinned Clang 23.1.4, `-march=native` and `./build.sh --config Release --jobs 6`. The candidate incorporated the four compiler source edits in `candidate.patch`, SHA-256 `9d686048ce5adee06064d21087a7bd1a1f83930e499b16da0436566f8d1f05f2`. The executable hashes and compiler path are in [the host record](raw/host.txt).

## End-to-end compile time

Each median is based on 100 paired baseline/candidate runs. The order alternated after four warm-up pairs. Each invocation acquired benchpress’s shared exclusive lock independently. The monotonic timer started after the lock was acquired, immediately before forking, and stopped when the process exited. It includes process startup, compilation and writing a fresh object in tmpfs. The frozen source and headers were warm in the page cache. Speedups use the ratio of the two medians.

Single compiles ran on CPU 2, with its SMT sibling offline, the performance governor selected and boost enabled. Each four-worker run started four independent compiler processes on CPUs 0, 1, 2 and 3, from a shell on CPU 4, and timed their joint completion. The driver used `--lanes 1` for each compiler process.

| Input | Workers | Baseline (ms) | Candidate (ms) | Speedup | Candidate wins out of 100 |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite amalgamation | 1 | 17.949 | 17.775 | 1.010× | 93 |
| musl `wcwidth.c` | 1 | 1.159 | 1.100 | 1.054× | 92 |
| musl `__rem_pio2_large.c` | 1 | 1.272 | 1.265 | 1.005× | 51 |
| Six musl iconv tables in one translation unit | 1 | 2.466 | 1.198 | 2.059× | 100 |
| Generated chain of 4,000 static inline functions | 1 | 9.048 | 1.662 | 5.444× | 100 |
| Generated 1,000 functions with 25 locals each | 1 | 2.932 | 2.837 | 1.033× | 90 |
| Generated 2,000 functions with 25 locals each | 1 | 52.496 | 4.773 | 10.998× | 100 |
| SQLite amalgamation | 4 | 20.659 | 20.349 | 1.015× | 95 |
| Six musl iconv tables in one translation unit | 4 | 3.851 | 2.559 | 1.505× | 100 |
| Generated chain of 4,000 static inline functions | 4 | 10.631 | 3.210 | 3.312× | 100 |

The six inputs accepted by both direct compilers produced byte-identical objects. The baseline switched to the full compiler for the 50,000-local file. The candidate reused local symbol slots and stayed on the direct path. Both resulting objects linked, and a native driver called all 2,000 functions and checked that each returned 300. Every four-worker object matched its single-worker counterpart. The native direct self-test passed 10/10 baseline cases and 11/11 candidate cases. [Object hashes and direct/fallback decisions](raw/objects.tsv)

## Repeat runs and identical-baseline controls

A second 100-pair session tested the smaller effects. Each round interleaved a baseline/candidate pair with two invocations of the identical baseline executable, using equal-length names. The order within and between the pairs was balanced. The control column measures how far timings moved for the same binary. Positive reductions mean less wall time.

| Input | Workers | Baseline (ms) | Candidate (ms) | Time reduction | Identical-baseline reduction |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite amalgamation | 1 | 17.871 | 17.746 | +0.70% | +0.07% |
| SQLite amalgamation | 4 | 20.726 | 20.314 | +1.99% | +0.02% |
| musl `__rem_pio2_large.c` | 1 | 1.243 | 1.281 | -3.04% | +0.10% |
| Generated 1,000 functions with 25 locals each | 1 | 2.892 | 2.843 | +1.69% | +0.22% |

SQLite improved in both sessions. The musl math file moved from 0.49% faster in the first session to 3.04% slower in the second. To check whether a small gain was reproducible, four more sessions used fresh, byte-verified compiler files on tmpfs. Each used 52 measured pairs per comparison and an independent copy of the baseline for its control. These placements vary the executable file and its cached pages while preserving its linked code layout.

| File placement | Baseline (ms) | Candidate (ms) | Time reduction | Independent baseline copies |
| --- | ---: | ---: | ---: | ---: |
| 1 | 1.265 | 1.265 | -0.01% | -0.12% |
| 2 | 1.261 | 1.268 | -0.48% | -1.17% |
| 3 | 1.256 | 1.258 | -0.12% | -2.49% |
| 4 | 1.258 | 1.251 | +0.61% | -0.77% |

The four placement comparisons ranged from 0.48% slower to 0.61% faster for the math file. These measurements leave its wall-time effect unresolved. [All placement timings](raw/math-placements.tsv)

## Hardware counters

Separate single-core runs collected eight alternating pairs per input with `perf stat`. The medians below count user-space instructions and cycles, in millions, over the compiler invocation. All four hardware events reported 100% running time. The raw file includes branches and branch misses as well.

| Input | Baseline instructions (M) | Candidate instructions (M) | Fewer instructions | Baseline cycles (M) | Candidate cycles (M) |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite amalgamation | 229.542 | 225.362 | 1.82% | 86.505 | 85.730 |
| musl `wcwidth.c` | 3.636 | 1.676 | 53.89% | 1.597 | 1.233 |
| musl `__rem_pio2_large.c` | 4.131 | 3.879 | 6.10% | 2.067 | 2.083 |
| Six musl iconv tables in one translation unit | 44.806 | 5.505 | 87.71% | 8.946 | 1.869 |
| Generated chain of 4,000 static inline functions | 219.813 | 20.013 | 90.90% | 45.363 | 4.347 |
| Generated 1,000 functions with 25 locals each | 58.049 | 57.865 | 0.32% | 10.844 | 10.442 |
| Generated 2,000 functions with 25 locals each | 970.561 | 114.936 | 88.16% | 243.750 | 19.894 |

SQLite retired 1.82% fewer instructions. The iconv tables retired 87.71% fewer, and the inline chain retired 90.90% fewer. [Raw hardware-counter observations](raw/pmu.tsv)

## Evidence and reproduction

The raw timing files include warm-up rounds numbered −4 to −1. Median calculations use rounds zero and higher. The timing columns also record child user/system CPU time, peak resident set and page faults. Compressed scheduling logs retain load averages, process snapshots taken before and after each trial, and shared-lock output. The lock reported no competing busy-process warnings during these campaigns. [Primary timings](raw/times.tsv) · [Repeat and control timings](raw/control-and-repeat.tsv)

To reproduce, put a copy of this record on benchpress. Set `RECORD` to its absolute path and `SESSION_LINK` to the session URL. Run the following from a separate, fresh task directory under `~/buster-fast-bench/`. The scripts acquire the shared lock for each build, test and timed trial.

```bash
cp "$RECORD"/scripts/* "$RECORD/candidate.patch" .
printf 'export EXCLUSIVE_OWNER=%q EXCLUSIVE_TITLE=%q EXCLUSIVE_LINK=%q\n' \
    "$USER-direct" 'Direct compiler baseline and candidate' "$SESSION_LINK" > owner.sh
printf 'export CORES_TITLE="$EXCLUSIVE_TITLE" CORES_LINK="$EXCLUSIVE_LINK"\n' >> owner.sh
bash build-both.sh
bash src/tools/ci/fetch-corpus.sh "$PWD/corpus"
bash generate-inputs.sh "$PWD/input"
sha256sum -c "$RECORD/raw/inputs.sha256"
bash campaign.sh
bash confirm.sh
bash math-placements.sh
```

The captured run transferred the previously checksum-verified frozen corpus over Tailscale. Re-fetching it with the pinned script above supplies the same inputs. [Input checksums](raw/inputs.sha256) · [Candidate source checksums](raw/candidate-sources.sha256)
