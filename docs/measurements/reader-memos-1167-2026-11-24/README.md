# Reader memo storage and peak RSS on the 9700X

The frozen SQLite compile on buster main `7515714d0` exercises the source-order reader. The first version moved five token-indexed columns to sparse storage. The final layout uses three directories, pairing tag types with tag ends and declaration bases with specifiers. Each memo remains a single pointer in a deferred reader. The driver also retains whole scratch pages within its existing source-order reuse allowance. [Issue and acceptance criteria](https://github.com/buster14a/buster/issues/1167#issuecomment-6917438068)

Against the same-revision control before both changes, the reader arena took **1,942 fewer faults**. Median within-pair differences were **5.10 million fewer kernel cycles, 5.00 million fewer total cycles and 1,960 KiB lower peak RSS**. All twelve pairs had lower kernel cycles, total cycles and peak RSS. The final measured compiler commit is [buster `4248b555b`](https://github.com/buster14a/buster/commit/4248b555bc299971837685ad929f107f37b4c9b4).

## Reader-arena faults

| Build | Minor faults inside the arena | Distinct 4 KiB pages |
| --- | ---: | ---: |
| Same source snapshot with #2880 reversed | 3,972 | 3,436 |
| Main including #2880 | 2,909 | 2,863 |
| Five independent directories, `693c90ac1` | 2,305 | 2,061 |
| Three eagerly cleared directories, `2b338cdee` | 2,030 | 1,987 |
| Three directories and whole-page scratch reuse, `4248b555b` | 2,030 | 1,987 |

The original census attributed 2,840 faults to the nonbinding part of the reader arena. The target was a reduction of at least 1,420 faults and 3.35 million kernel cycles. The same-revision control measures both steps together. The earlier census and step-one results were taken on older compiler revisions. [Earlier record](../sparse-columns-1167-2026-11-16)

## Whole-compile counters and peak memory

The columns show the median for each executable and the median of twelve within-pair differences. The paired interquartile range uses linear interpolation. Each executable ran first six times. Negative differences are reductions.
### After #2880 against the final build

| Metric | Baseline | Final | Paired difference | Paired IQR | Pairs lower |
| --- | ---: | ---: | ---: | ---: | ---: |
| Whole-process page faults | 5,761 | 4,882 | -878.5 | -879 to -878 | 12/12 |
| Kernel cycles | 81,473,185 | 79,366,565.5 | -2,171,027 | -3,100,970 to -1,731,150 | 12/12 |
| User cycles | 547,395,507.5 | 548,899,508 | 1,022,897 | -590,908 to 3,075,912 | 5/12 |
| Total cycles | 628,576,406 | 627,992,773.5 | -1,263,282 | -3,146,279 to 1,207,700 | 8/12 |
| Peak RSS (KiB) | 243,804 | 241,848 | -1,956 | -1,960 to -1,955 | 12/12 |

### Before both steps against the final build

| Metric | Baseline | Final | Paired difference | Paired IQR | Pairs lower |
| --- | ---: | ---: | ---: | ---: | ---: |
| Whole-process page faults | 6,822.5 | 4,882 | -1,940.5 | -1,941 to -1,938 | 12/12 |
| Kernel cycles | 84,388,671 | 79,562,579.5 | -5,102,462.5 | -5,352,577 to -3,871,389 | 12/12 |
| User cycles | 548,683,006.5 | 548,317,027.5 | -417,652.5 | -1,571,390 to 638,849 | 7/12 |
| Total cycles | 632,461,216.5 | 627,671,379.5 | -5,004,692.5 | -6,372,568 to -4,042,608 | 12/12 |
| Peak RSS (KiB) | 243,808 | 241,848 | -1,960 | -1,964 to -1,956 | 12/12 |

## Why the driver change accompanies the reader change

The three-directory reader alone reduced arena faults by 879 compared with main. Its twelve paired compiles saved 3.32 million kernel cycles and 2.36 million total cycles. Peak RSS rose by 24 KiB. Relative to the baseline before both steps, the increases in RSS had a median of 12 KiB. The stage readings put the reader's high-water increment 3,476 KiB lower, and put the final peak in declaration checking. [Reader-only pairs](raw/compact.tsv) · [Both steps before the driver change](raw/cumulative.tsv)

The driver keeps 96 bytes per token of scratch beyond its live data for subsequent checking stages. Its discard rounds up to a 2 MiB boundary. On a source-order compile with at least one huge page of reuse allowance, the final change first rounds the end of the allowance down. The existing discard still protects every live byte. The three-pair pilot preceded the two separate twelve-pair confirmation series.

The controlled paired-directory prototype used a wider memo descriptor in each deferred lane. It saved 875 whole-process page faults and 2.34 million kernel cycles compared with main and added 24 KiB of peak RSS. Moving the reader's marks out of scratch and sharing one out-of-line memo getter were tested separately. Both probes increased peak RSS relative to main. The two probe patches apply to `2b338cdee`, and the paired prototype patch applies to `693c90ac1`. [Prototype samples](raw/controlled.tsv) · [Three-pair probes](raw/probes.tsv)

## Output and checker validation

The native Release builds on the cloud worker used Clang 23.1.4. The baseline and final builds produced byte-identical SQLite objects and outputs on all 1,336 musl units. All musl units were also compiled individually with `--deferred-bodies --lanes 3`. All 202 driver fixtures matched exit status, stdout and stderr at one and three requested lanes, both with and without explicit deferred bodies. Of those fixtures, 104 were accepted and 98 were rejected. The eight-lane SQLite and 613-file musl Clang checks passed. [Source-order output digest](raw/source-order-output.txt) · [Deferred musl output digest](raw/deferred-musl.txt) · [Diagnostics](raw/driver-diagnostics.txt) · [Clang comparisons](raw/clang-corpora.txt)

The checker passed 833,442 checks, the partitioned driver passed 243,238 checks, the deferred checker passed 2,767 checks, the unit tests passed 2,382 checks and c-testsuite passed 220 of 220 cases. [Test summary](raw/reuse-tests.txt)

## Inputs and controls

All performance samples used CPU 2 on the shared AMD Ryzen 7 9700X, Linux 6.18.50-2-lts. Its sibling CPU 10 was offline. The builds used the repository Release configuration with `BUSTER_HOST_ARCH=znver5`. Each build, compiler invocation, GDB trace and perf decode took its own benchpress lock. The frozen `sqlite3.c` had SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. The compile used `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c"`.

The `base` build is buster `7515714d05caa655e8c2e1e2776e07aa9b8058df`, including step one. The `without` build reverses the performance changes in #2880 on that same snapshot. The reversal retains the subsequently extracted parameter helper and the C23 constant-initializer check. The exact measurement-only patch is in `scripts/without-step-one.patch.gz`. The 9700X emitted the same SQLite object across the builds, SHA-256 `190cf4c109792239cc1dfac8e2e2fb2fd1e11f5df9117e7766d9193f1b1b78eb`. [Step-one PR](https://github.com/buster14a/buster/pull/2880)

Each counter series used twelve pairs, alternating which executable ran first. The harness copied both executables before the series and kept those copies for every round. `perf stat -C 2` measured kernel and user cycles on the pinned CPU through process teardown. `wait4` recorded the compiler's peak RSS. The harness compared object bytes after each pair. Every sample used `BUSTER_HUGE_PAGES=1`, which selects the same page policy across builds. An exploratory series using the automatic policy produced roughly 5,700 faults in one traced process and 55,000 in another. The reader arena itself used 4 KiB pages in both.

For the arena census, GDB recorded the inferior PID and monotonic time at allocation, then the time, base address and used length before release. `perf record -k mono -d -e minor-faults -c 1` sampled every minor fault, and `perf script --ns -F pid,time,addr` decoded them. Each compressed trace contains every decoded fault for the compiler PID, including those outside this arena. The range, time and PID filters are reproducible from the archived data. The final compiler source digests from the host matched the ones from commit `4248b555b`. Kernel cycles in the tables are CPU-wide. The address census counts faults directly.

## Reproduction

Build each checkout with `./build.sh --config Release` under the benchpress lock and `BUSTER_HOST_ARCH=znver5`. For the baseline without step one, apply `gzip -dc scripts/without-step-one.patch.gz | git apply -` to a checkout of `7515714d0`. Compile the prior record's `waitall.c` and `peakrss.c` with `cc -O2` under the same lock. Run `scripts/compare.sh BASE HEAD WAITALL PEAKRSS SQLITE_DIR NEW_OUTPUT_DIR`. Its arguments are paths to the compiler builds, helper executables, frozen corpus and a fresh output directory. [Counter helper sources](../sparse-columns-1167-2026-11-16/scripts/tools)

To repeat a trace under the same lock, run `scripts/trace.sh BUILD_TREE SQLITE_DIR NEW_OUTPUT_DIR` with line information available in the build.

To recount a trace on any host, run the following from this record's directory.

```sh
cc -std=c17 -O2 scripts/count-arena.c -o /tmp/count-arena
for trace in raw/*-faults.txt.gz; do
    echo "$trace"
    gzip -dc "$trace" | /tmp/count-arena "${trace%-faults.txt.gz}-range.txt"
done
```

The TSV files preserve run order, individual counters, peak RSS and object hashes. The compressed hold logs contain process and load snapshots. The GDB command files identify the exact breakpoint lines used for each build.
