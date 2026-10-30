# Tier 1 allocation stopgap, main against head (buster #140)

Evidence for buster #140's stopgap ([claim](https://github.com/buster14a/buster/issues/140#issuecomment-6534489099)), which
[the #140 review](https://github.com/buster14a/buster/issues/140#issuecomment-6532841722) proposed and
[the design discussion](https://github.com/buster14a/buster/issues/140#issuecomment-6534430572) endorsed. In buster's
commits [`a306b31e`](https://github.com/buster14a/buster/commit/a306b31eb95f2fcb55e2cf0faa4feb9917a5362c) and
[`83251e23`](https://github.com/buster14a/buster/commit/83251e23a61335fdc4c7d100b40a95969af04cfb):

- `tier1_allocation_color` resolves each register in its LIFO matching loop, without the AVX-512 prefix sum and the
  pointer jumping;
- `tier1_allocate_scan` and `tier1_allocate_scan_uses` free a register at its interval's end event, guarded by
  `active[r] == interval`, instead of checking all 32 slots at every start;
- the hot functions copy the input columns into a local struct.

Outputs are meant to be unchanged on both paths, and only the scratch arena should shrink.

## Sources and host

- **main:** [`257892fbaf369f99d93914c328824c6a315e019e`](https://github.com/buster14a/buster/tree/257892fbaf369f99d93914c328824c6a315e019e);
  **head:** [`83251e23a61335fdc4c7d100b40a95969af04cfb`](https://github.com/buster14a/buster/tree/83251e23a61335fdc4c7d100b40a95969af04cfb),
  the two commits on that main. Each tree is a `git archive` of its commit, extracted on the host with a `COMMIT` file;
  `logs/9700x/tree-*.sha256` list every file's SHA-256 there (but `build/`); both match `git archive` of their
  commits file for file, but `COMMIT`.
- **Host** (`logs/9700x/host.txt`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2's governor and energy preference `performance`.
- **Builds:** `BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh` for each tree (`logs/9700x/build-*.log`);
  `logs/9700x/executables.sha256` gives the executables' SHA-256.

`scripts/stopgap.sh MAIN_TREE HEAD_TREE WORK OUT` ran everything in four holds of the host's lock
(`logs/9700x/hold-*.log`): the builds, the tests, the benchmark's plain and isolated runs, and its runs after scalar
work. Each step's log starts and ends with its times and gives its exit status. The lock's own messages went to a
separate directory that is not published.

## Results

### Correctness

| Run (`logs/9700x/`) | Result |
| --- | --- |
| `test-main-tier1-allocation` | 16,867 checks, 0 failures |
| `test-head-tier1-allocation` | 18,990 checks, 0 failures: the 2,123 more are the new comparison with an independent implementation of the LIFO level rule |
| `test-head-tier1-allocation-seed7`, `-seed99` (4,000 cases each) | 31,546 and 31,549 checks, 0 failures |
| `test-head-tier1-liveness`, `-emit`, `-frame` | 20,433, 179,845 and 2,273,931 checks, 0 failures |
| `test-head-tier1-pipeline` (`--cross-check`) | 3,554 checks, 0 failures; 1,024 native and 512 Clang results |
| `differential-main`, `differential-head` | 3,210 cases on both entry points, 6,420 main/head pairs: 6,204 successful results agree in the logical-field hash and retained bytes; 216 constraint refusals agree in status and restore the arena |

`scripts/differential.c` hashes the logical fields of each successful `Tier1Allocation`: fragment count and columns, value registers,
spill ids and values, the interval counts, splits and peak pressures. It also prints the status, the retained bytes
and the arena's growth. For constraint refusals, the hash, retained and scratch values are zero placeholders; the
result fields are not inspected. Its cases are:
- `benchmark-tier1-allocation`'s four workloads, and the review record's six;
- 3,000 of `tier1_allocate_test.c`'s generated shapes: fixed ranges, narrowed masks, hints, rematerialization, and
  required uses on every fifth;
- 200 random inputs of up to 16,384 intervals, with several uses each (a third of them required), holes as
  intervals of one value, and random fixed ranges.

Scratch bytes shrink in the 3,061 vector-path runs that allocate (43,436,760 bytes in all) and never grow.

Two more checks ran in the author's local build (Zen 4 laptop, outside this record):
- **A mutant** that takes fresh registers from the top of the mask keeps every allocation valid, yet fails 2,066 of the
  new rule comparisons.
- **The placement loop's code.** The counting sort's placement loop, at the first commit, still reloaded the `ends`
  column pointer from the stack twice per element, because `tier1_allocate_impl` passed its local copy to helpers it
  doesn't inline. The second commit passes `input` to them instead, and the loop keeps the pointer in a register.

### Time

`benchmark-tier1-allocation`, cycles per interval: medians over processes of each process's median of 11 samples
(`logs/9700x/bench-*.log`). Five processes per tree and mode for the plain, vector-only and scalar-only runs, three
for the vector path after 100 ms of scalar work before each sample. Ranges are over processes.

| Workload | Intervals | Vector path, main | head | Scalar path, main | head |
| --- | ---: | ---: | ---: | ---: | ---: |
| tiny-fit | 16 | 103.2 [102.3-105.8] | 65.4 [64.2-66.8] | 186.7 [185.5-188.7] | 74.6 [72.9-75.1] |
| small-fit | 128 | 95.5 [94.6-96.3] | 53.6 [53.0-57.0] | 174.4 [173.6-176.2] | 62.6 [61.8-65.3] |
| large-fit | 2,048 | 114.2 [114.2-116.7] | 52.9 [52.4-53.7] | 172.3 [171.4-174.1] | 61.2 [60.0-61.6] |
| large-pressure | 16,384 | 232.0 [231.2-234.4] | 118.0 [117.4-118.4] | 231.4 [230.2-233.7] | 117.9 [117.7-118.1] |

The vector path is 1.58x, 1.78x, 2.16x and 1.97x faster, and the scalar path 2.50x, 2.78x, 2.81x and 1.96x.
large-pressure is overfull, so both paths take the scan there. The isolated runs agree with the plain ones:
- vector-only: 1.54x, 1.79x, 2.15x and 1.96x;
- scalar-only: 2.50x, 2.79x, 2.78x and 1.96x;
- the vector path after scalar work: 1.54x, 1.80x, 2.14x and 1.98x.

The ranges of main and head never overlap.

## Limitations

- `benchmark-tier1-allocation`'s four synthetic workloads only: Tier 1 compiles no corpus yet.
- Five processes per tree and mode for the plain and isolated runs, three for the runs after scalar work; each
  benchmark process reports medians of 11 samples, calibrated on the vector path.
- The differential compares 64-bit FNV-1a hashes of successful results' logical fields, not the fields' bytes side
  by side; a hash collision would hide a difference. Constraint refusals compare status and arena restoration only.
- The local mutant and code checks have no receipts in this record.
