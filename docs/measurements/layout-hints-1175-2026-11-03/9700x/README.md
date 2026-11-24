# Checker layout on the Ryzen 7 9700X, November 5, 2026

SQLite syntax checking took **13.28 million fewer taken branches** and **6.82 million fewer user cycles** after
the checker layout change. At all four candidate placements, taken branches and cycles were below even the best
reference placement on all three workloads. This meets the placement criterion for the integrated change.
[Issue #1175](https://github.com/buster14a/buster/issues/1175) · [Per-site measurements](../README.md#results)

| Frozen workload | Taken branches, reference → candidate | Change | User cycles, reference → candidate | Change (range over placements) |
| --- | ---: | ---: | ---: | ---: |
| SQLite `-fsyntax-only` | 138.94 M → 125.66 M | −9.56% | 672.94 M → 666.12 M | −1.01% (−2.14% to −0.40%) |
| SQLite `-c` | 157.57 M → 143.73 M | −8.78% | 778.04 M → 771.84 M | −0.80% (−1.31% to −0.41%) |
| 139 musl units, one `-c` invocation | 263.55 M → 246.64 M | −6.42% | 936.19 M → 931.61 M | −0.49% (−0.91% to −0.21%) |

For each placement the reader takes the least of three user-mode counts, then averages those four minima.
The range compares each candidate minimum with every reference minimum. All 72 raw perf captures report
100% counter runtime. Instructions fell 0.49%, 0.44% and 0.07%, respectively. [Counter output](counters-summary.txt)

| Workload | Median wall time, reference → candidate | Change | All placement pairs | All placement and copy pairs |
| --- | ---: | ---: | ---: | ---: |
| SQLite syntax | 138.101 → 137.156 ms | −0.68% | −1.15% to −0.16% | −1.21% to +0.04% |
| SQLite object | 158.389 → 157.641 ms | −0.47% | −1.03% to −0.13% | −1.24% to +0.05% |
| musl objects | 203.055 → 202.350 ms | −0.35% | −0.85% to −0.11% | −0.94% to −0.02% |

`time-runs --runs 11 --warmups 1 --copies 2` recorded 88 timed processes per build and workload. All 528
succeeded. Wall-time and user-cycle medians fell across all placement pairs. Comparing the two copies at each
placement separately gives overlapping wall times for SQLite and overlapping user cycles for all three workloads.
[Timing output](timing-summary.txt)

## Inputs and verification

The reference was `e36740b8f70cf5755cabff9b2a9a998b173c2878`, the first parent of merge
`c79fd0076fc8ee3ba0a43d02f94dca417a7557ea`. The campaign ran on benchpress under its shared lock, pinned to CPU 2
with the performance governor. Both builds used Clang 23.1.4, `znver5`, debug info off and the default lane count.
The frozen corpus manifest starts with `391e729af658`. The archive contains its full manifest hash list, the
NUL-delimited compiler arguments, and the compile and verification commands.
[Pinned campaign and counter reader](https://github.com/buster14a/buster-performance/tree/961e2893fe13ac4c30547ff86f1e2e279e09b06b/docs/measurements/layout-hints-1175-2026-11-03/scripts)

- The eight symbol tables confirm checker displacements of 0, 688, 1,376 and 2,064 bytes within a page in both
  trees, and `main` displacements of 0, 256, 512 and 768 bytes.
- Each executable produced the same 140 objects byte for byte. At publication the eight retained executables and
  all 1,120 retained object files on benchpress still matched the original SHA-256 manifests.
- Each raw perf event matched its declared build, placement, workload and repetition. Replaying the pinned strict
  reader on all 216 observations reproduced the archived summary byte for byte.
- The saved GitHub job receipts pass the qualification predicate for both source revisions, including the 48 hosted
  shards, all three fuzz jobs, and the native correctness step. [Reference CI](https://github.com/buster14a/buster/actions/runs/41839388530) · [Candidate CI](https://github.com/buster14a/buster/actions/runs/41841112215)

## Relation to the profile

On the older #880 baseline, the source changes and BOLT counts gave an estimated reduction of about 32% from
77.4 M taken branches. Layout-only PGO saved about 33%. The full profile reached 43.7 M, about 8.6 M below the
historical source estimate. The November 5 hardware comparison measures two unprofiled revisions, with 138.94 M
baseline branches. A direct gap to PGO on those revisions would require a matched profiled build.
[Profile experiment](../../pgo-port-880-2026-11-02/README.md)

## Replaying the counts

From this directory, extract the archive into an empty directory and pass the declared grid and observations
to the reader. The archive contains the original perf output, all timing rows and process statuses, symbol
tables, binary and object hashes, qualification receipts, and the host scripts and logs. [Raw evidence](raw.tar.gz)

```sh
d=$(mktemp -d)
tar -xzf raw.tar.gz -C "$d"
cc -std=c17 -O2 -Wall -Wextra -Werror ../scripts/counters.c -o "$d/counters"
"$d/counters" "$d/campaign/logs/counters-expected.txt" < "$d/campaign/logs/counters.txt" > "$d/replay.txt"
cmp counters-summary.txt "$d/replay.txt"
```
