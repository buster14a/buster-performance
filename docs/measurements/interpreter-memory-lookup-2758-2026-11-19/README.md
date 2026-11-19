# Interpreter memory lookup on c-testsuite’s eight queens

The all-memory child of `00040.c` took 2.36% less elapsed time under MSan and 1.36% less under ASan after retaining a second region hint. The median duration of the 220-program CI command fell by 1.61 s and 0.20 s, respectively. The standalone run of all four forms was flat under MSan. These are four-CPU GitHub-hosted sanitizer measurements. [Issue and handoff](https://github.com/buster14a/buster/issues/2758#issuecomment-7016179018) · [Base 6427879e](https://github.com/buster14a/buster/commit/6427879e1143026a12fb0388a20bdea1fe4b2bc5) · [Head a167aba6](https://github.com/buster14a/buster/commit/a167aba689450ba4b67c8f6ea5baebfa0fbfc438)

## What the misses cost

All three screening runs on base gave the same MSan distribution. Out of 371,541,609 memory lookups, 362,445,633 hit the primary hint. Of the 9,095,976 misses, 4,117,553 scanned two regions and 3,893,538 scanned 58. The 58-region walks accounted for 93.93% of all fallback region checks. For 9,095,908 misses, the previous successful lookup at that slot used a different eight-byte address granule. All requested ranges ultimately matched a registration in the disjoint prefix. [Screening histograms](screening) · [Hosted run](https://github.com/buster14a/buster/actions/runs/44598499957)

The change keeps the displaced 32-bit region index for each of the 256 primary slots, adding 1,024 bytes to an interpreter runtime. A primary miss tries the displaced index before scanning. A hit in either slot leaves both indices in place. A fallback scan that finds a different index replaces the pair.

| Build | Recent hits | Full cache misses | Regions examined by fallback scans | Regions per full miss | Median / p95 / maximum scan |
|---|---:|---:|---:|---:|---:|
| MSan base | 362,445,633 | 9,095,976 | 240,410,411 | 26.43 | 3 / 58 / 69 |
| MSan head | 371,210,531 | 331,078 | 2,948,005 | 8.90 | 4 / 58 / 58 |
| ASan base | 355,569,736 | 15,971,873 | 423,125,819 | 26.49 | 26 / 58 / 69 |
| ASan head | 369,706,604 | 1,835,005 | 39,042,931 | 21.28 | 5 / 58 / 69 |

A hit means a cache entry actually passed the live-prefix and range checks. A fallback inspection is one call to the region containment predicate in either scan loop, including revisits. Counting the rejected hints on full misses as well gives **27.37 → 10.16** inspected regions per miss on MSan and **27.45 → 22.95** on ASan. Across all lookups, including hits, the totals were **611,384,448 → 501,430,885** and **794,049,511 → 566,214,487**. The displaced hint supplied 132,159,119 MSan hits and 155,566,713 ASan hits. The table hashes virtual addresses, so each sanitizer has its own measurements. [MSan counters](msan/head-probes.tsv) · [ASan counters](asan/head-probes.tsv) · [Base/head probe run](https://github.com/buster14a/buster/actions/runs/44600509203)

## Timings

Each entry gives the median in seconds. Each base/head pair ran serially on the same VM, with a four-CPU affinity and Clang 23.1.4. Both builds used `./build.sh --config Release` with `BUSTER_HOST_ARCH=vector` and either `BUSTER_SANITIZER=memory` or `BUSTER_SANITIZER=address`. MSan tracked origins at level 2. The address row enabled address, undefined and bounds instrumentation. The timed compilers contained the production change and its fixtures. The counter patches were applied only to the probe binaries. [MSan setup](msan/setup.log) · [ASan setup](asan/setup.log)

| Workload and metric | MSan base | MSan head | ASan base | ASan head |
|---|---:|---:|---:|---:|
| All-memory child CPU, six pairs | 61.180 | 60.094 | 68.094 | 67.316 |
| All-memory child elapsed, six pairs | 62.137 | 60.671 | 68.726 | 67.791 |
| `00040.c`, all four forms, command elapsed, three pairs | 140.07 | 140.19 | 55.68 | 55.36 |
| 220-program CI command elapsed, three pairs | 180.22 | 178.61 | 73.42 | 73.22 |

The all-memory child finished sooner in five of six pairs under each sanitizer. Its CPU time fell in four MSan pairs and five ASan pairs. The full CI command finished sooner in all three pairs under each sanitizer. The standalone four-form command finished sooner in one MSan pair and all three ASan pairs. The two CI-duration workers were AMD EPYC 9V74s. The independent child-clock workers were an AMD EPYC 9V45 for MSan and an Intel Xeon Platinum 8573C for ASan. [Command timings](https://github.com/buster14a/buster/actions/runs/44602011151) · [Independent child timing](https://github.com/buster14a/buster/actions/runs/44605097021)

GNU time measured the commands in base/head, head/base, base/head order. The standalone run retained its files with `--keep`. The timed 220-program run used the exact inventory command below, with c-testsuite at `5c7275656d751de0e68b2d340a95b5681858ed07`. The independent observer alternated order across six pairs, identified the existing child by its `run-0-memory` working directory, and recorded its Linux task clock and process lifetime. All twelve samples per sanitizer obtained a task clock. The largest attachment bracket was 11 ms. The all-memory figures above use the kernel measurements because result-file creation timestamps on these workers could differ at subsecond precision. [MSan samples](msan/child-clocks.tsv) · [ASan samples](asan/child-clocks.tsv)

```sh
"$BUSTER_COMPILER" test-ssa-source --typed --tier1 $(sed -n 's|^\([0-9][0-9]*\)$|build/c-testsuite/tests/single-exec/\1.c|p' tests/c-testsuite/subset.txt)
```

## Correctness

Both hints must name a registration below the current disjoint-prefix count and contain the entire range. Such a registration is the first possible match. Compaction or index reuse still requires a fresh check against the live region. The existing access code then reads that region’s permissions and defined-byte map. The new fixtures exercise a displaced hint for a later overlapping writable registration, a read-only write, an undefined read and a reused address. The existing bounds and frame-removal fixtures also passed. [Production patch](scripts/candidate.patch) · [MSan interpreter checks](msan/interpreter-tests.txt) · [ASan interpreter checks](asan/interpreter-tests.txt)

All 220 programs and both strict Tier 1 executions per program passed on base and head under both sanitizers. For `00040.c`, the all-memory, vector SSA, scalar SSA and typed step counts were **1,350,907,667 / 1,086,721,021 / 1,086,721,021 / 1,044,385,698**. Its expected output was empty and its exit status was zero. The full corpus had identical per-program steps, with totals **1,358,276,578 / 1,093,063,173 / 1,093,063,173 / 1,050,172,945**. An extra retained full run of each binary produced matching SHA-256 hashes for all 1,320 output files. Both sanitizers produced the same manifest. [Per-program records](validation/per-program.txt) · [Output hashes](validation/output.sha256)

The initial probe jobs recorded both sides and completed their first timing pair, then flagged the randomly named working directories printed in native status messages. The timing job stripped that final directory field and compared the remaining status, coverage and exact step fields on every run. The independent output-hash comparison consumed the captured program files directly.

## Reproduction

Use a fresh disposable checkout of the base commit for each script, with CI’s pinned toolchain on `PATH` and four available AVX-512 CPUs. Set `RUNNER_TEMP` to a private temporary directory and `BUSTER_SAMPLE_SANITIZER` to `memory` or `address`. From the checkout root, invoke the script by its path in this record. Each script applies the measured patch to that checkout. [Collect lookup counters](scripts/count.sh) · [Time and validate the full command](scripts/time-ci.sh) · [Measure the all-memory child](scripts/time-memory-child.sh)
