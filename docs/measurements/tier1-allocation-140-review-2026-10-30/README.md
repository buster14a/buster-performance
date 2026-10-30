# Tier 1 allocation costs and a data-parallel prototype, buster #140's review

Evidence for [the review of buster #140](https://github.com/buster14a/buster/issues/140) (linear-scan register
allocation on SSA) posted on 2026-10-30 at David's request, by a Claude Code session. It is a review: no claim on the
issue, and no buster change. Everything was measured on the shared Ryzen 7 9700X in three holds of the host's lock
(the builds, the timed runs and LLVM's compiles: `logs/9700x/hold-*.log`), timed runs pinned to CPU 2.

It answers four questions:

1. What does the current `tier1_allocate` cost per interval, by path, and what do two minimal fixes change?
2. Where does the time go?
3. What do similar lifetimes cost when an allocator takes them as the instruction stream the selector already has,
   scalar and with an in-register AVX-512 kernel? (Similar, not identical: see "How the stream inputs differ".)
4. For scale, what does LLVM's register allocation cost on `sqlite3.c` on the same machine?

## Sources and host

- **buster:** [`7f8577861b5836b62689aa61b28155815ca5ecb3`](https://github.com/buster14a/buster/tree/7f8577861b5836b62689aa61b28155815ca5ecb3)
  (main after #925), as `git archive` extracted on the host with a `COMMIT` file; `logs/9700x/tree.sha256` lists every
  file's SHA-256 there. `tier1_allocate.c` is unchanged since `caef4ea2`, the four-part review's snapshot.
- **Record files:** `logs/9700x/record-files.sha256`, including the generated `proto_impl.c`.
- **Host** (`logs/9700x/host.txt`): AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9, CPU 2's governor and energy preference `performance`.
- **Executables:** `logs/9700x/executables.sha256`. Flags: `-O3 -march=native -fwrapv -funsigned-char
  -fno-strict-aliasing` (buster's), `-g` added for the profiled build.
- **Input for LLVM:** the host's baseline copy of `sqlite3.c`, SHA-256 `b1dd5d74ec7f29055a6684fa06fb3c2f6821c87dd38f9a458dfd2e8a1db28189` (`logs/9700x/inputs.sha256`).

The published hash lists give paths relative to the run's work directory and the input's file name; the host's own paths
are left out.

`scripts/record.sh BUSTER_TREE SQLITE3_C WORK OUT` ran everything. Each step's log (`logs/9700x/*.log`) starts and ends
with the step's times and gives its exit status (every step exited 0); `hold-*.log` give when each hold began and
ended. The lock's own messages went to a separate directory that is not published.

## The files

- `scripts/harness.c`: whole `tier1_allocate` calls on ten synthetic workloads (the four of
  `benchmark-tier1-allocation`, mostly-short temporaries with 5% and 15% long values, and one reuse chain), five
  configurations each. Every timed configuration, the current algorithm's included, runs `proto_allocate_impl`, the
  generated copy of `tier1_allocate_impl` (variant 0 is the current algorithm). The production entry points
  `tier1_allocate` and `tier1_allocate_scalar` run only before timing, as the oracles each configuration's output is
  compared with by `same_output`: the fragment count, offsets, starts, ends, kinds and registers, and the spill and
  interval counts. The other public fields (`value_registers`, `spill_ids`, `spill_values` and the statistics) were not
  compared in this record. The references are also checked with `tier1_allocation_verify` up to 4,096 intervals.
  Medians of 11 samples, configurations rotating within each sample. The repetition count is calibrated once on
  `vector-current` against a 2 ms threshold, then reused for every configuration. Faster configurations can have
  shorter batches. About 0.7 ms is only an illustrative estimate from that threshold (temps-pressure's both-fixes,
  0.37 of the baseline cost), not a retained observed batch minimum. The selected repetition count, calibration
  elapsed time and individual batch durations were not retained.
- `scripts/make_proto.sh`: makes `proto_impl.c` from the measured `tier1_allocate.c` by `sed`: `tier1_allocate_impl`
  with a variant parameter. Bit 0 replaces the prefix sum and pointer-jumping coloring with `proto_color`, which
  resolves each start's register in the same LIFO matching loop. Bit 1 replaces `tier1_allocate_scan` with
  `proto_scan`, which frees a register at its interval's end event instead of checking 32 slots at every start.
- `scripts/stream.c`: temps-fit-like and one-chain lifetimes as an instruction stream (two fixed use slots per
  instruction, instruction i defines value i), two classes of 16 registers. Last-use bits by a backward scan and by a
  "last reader" pass; assignment with one 64-bit free mask in a register, with and without forwarding the last two
  definitions' registers. An independent simulation checks every use.
- `scripts/levels.c` (with `levels_head.c` and `levels_gen.c`): one class of 32 registers. The LIFO "level" rule of
  `tier1_allocation_color` as a scalar twin, and as an AVX-512 kernel: 21 instructions (63 events) per 64-byte chunk,
  heights by a byte prefix sum, each definition's partner (the last kill at its level) by a 6-step descent over window
  maxima, registers by six rounds of `vpermb` pointer jumping, and a 32-level register state carried between chunks.
  `v2` uses a two-table permute in the descent and takes values defined in the previous chunk from its registers.
  Both kernels must reproduce the twin byte for byte; the lowest-free rule is the scalar baseline.
- `scripts/phases.awk`: sums the profile's source-line shares by allocator phase.

## Results

### 1. `tier1_allocate`, whole calls

Cycles per interval, medians of 11 (`logs/9700x/intervals-1.log`; `intervals-2.log`, the second round, is within
4.2% of it everywhere). All five columns are `proto_allocate_impl`: "vector now" and "scalar now" are variant 0 (the
current algorithm) on each path, "resolved" is variant 1, "end events" variant 2 and "both fixes" variant 3. Each
configuration's output was compared by `same_output` (the fields listed above) with its path's `tier1_allocate` or
`tier1_allocate_scalar`; the harness exits 1 on a difference, and both rounds exit 0.

| Workload | Intervals | Peak (GPR/vector) | On the vector path | Vector now | Vector, resolved | Both fixes | Scalar now | Scalar, end events |
| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| tiny-fit | 16 | 3/4 | 16 | 94 | 65 | 65 | 170 | 71 |
| small-fit | 128 | 3/4 | 128 | 100 | 59 | 59 | 167 | 66 |
| large-fit | 2,048 | 3/4 | 2,048 | 125 | 58 | 58 | 166 | 64 |
| large-pressure | 16,384 | 29/30 | 0 | 224 | 224 | 126 | 221 | 124 |
| temps-fit | 4,096 | 13/5 | 4,096 | 132 | 61 | 61 | 172 | 73 |
| temps-fit | 65,536 | 16/8 | 16,384 | 238 | 193 | 137 | 230 | 155 |
| temps-pressure | 4,096 | 22/11 | 1,024 | 186 | 148 | 69 | 186 | 83 |
| temps-pressure | 65,536 | 26/12 | 16,384 | 247 | 205 | 152 | 243 | 170 |
| one-chain | 4,096 | 1/0 | 4,096 | 109 | 73 | 72 | 172 | 67 |
| one-chain | 65,536 | 1/0 | 65,536 | 126 | 74 | 73 | 173 | 67 |

In temps-fit with 65,536 intervals, the GPR class peaks at 16 against 15 registers once (one spill slot), and its
49,152 intervals all take the scalar path.

### 2. Where the time goes

`logs/9700x/profile-phases.txt`: 3 s of perf's user cycles over the resolved vector path on temps-fit, 4,096
intervals, summed by source line into phases (`scripts/phases.awk`).

| Phase | Share |
| --- | ---: |
| Input validation (`tier1_allocation_input_valid`) | 9.9% |
| Memsets, per-interval initialization, bucket counts | 11.2% |
| Bucket prefix sum | 3.8% |
| Event placement | 13.3% |
| Value-overlap validation | 9.1% |
| Per-class count and pressure passes | 20.1% |
| Coloring (`proto_color`) | 10.7% |
| Fragment publication | 18.9% |
| Arena pushes, libc, harness | 2.9% |

`logs/9700x/placement-loop.txt` is the counting sort's placement loop (`proto_impl.c` lines 120-124, the same lines
as `tier1_allocate.c`'s): it reloads `input->ends` (`0x8(%r15)`) twice per element and `input->count` (`0x5c(%r15)`)
once, since under `-fno-strict-aliasing` each store may change the input struct.

### 3. Similar lifetimes as an instruction stream

#### How the stream inputs differ

`stream.c` and `levels_gen.c` draw temps-fit-like lengths with the interval harness's generator, but they are similar
synthetic shapes, not the interval workloads' lifetimes under another representation:

- with two use slots per instruction, a use whose instruction already has two is postponed to the next instruction
  with a free slot, and a use past the stream's end is dropped (its value is never killed);
- the stream generators reset the random state for each workload, while the interval harness continues it from the
  4,096-interval temps-fit workload into the 65,536-interval one.

A data-only reconstruction of both generators finds 206 postponed and 7 dropped uses at 4,096 instructions (every
requested length the same), and 3,067 postponed and 7 dropped uses at 65,536, where 45,659 of the requested lengths
differ. The comparisons inside each prototype (scalar against AVX-512, against twins) use one input and are not
affected; the comparison with the interval workloads is between similar shapes.

#### Results

Two classes of 16 registers, cycles per instruction (`logs/9700x/stream-1.log`; rounds 2 and 3 within about 0.7%):

| Lifetimes | Instructions | Kills, backward scan | Kills, last reader | Assignment, lowest free | Lowest free, forwarding |
| --- | ---: | ---: | ---: | ---: | ---: |
| temps-fit | 4,096 | 3.31 | 3.00 | 8.70 | 8.66 |
| temps-fit | 65,536 | 3.32 | 2.96 | 8.72 | 13.22 |
| one-chain | 4,096 | 3.07 | 3.00 | 13.02 | 7.71 |
| one-chain | 65,536 | 3.08 | 2.96 | 13.02 | 7.68 |

One class of 32 registers, assignment only (`logs/9700x/levels-1.log`; round 2 within about 0.6%):

| Lifetimes | Instructions | Lowest free | Levels, scalar twin | Levels, AVX-512 | Levels, AVX-512 v2 |
| --- | ---: | ---: | ---: | ---: | ---: |
| temps-fit | 4,096 | 7.11 | 7.13 | 8.15 | 7.21 |
| temps-fit | 65,536 | 7.12 | 18.25 | 8.04 | 7.12 |
| one-chain | 4,096 | 12.04 | 14.50 | 7.98 | 7.16 |
| one-chain | 65,536 | 12.04 | 14.43 | 7.93 | 7.15 |

Both kernels reproduced the scalar twin's registers byte for byte, and every assignment passed the simulation.
`perf stat` over 20,000 runs of temps-fit, 4,096 instructions (`logs/9700x/levels-perf-*.log`), per allocated
instruction:

| Variant | Instructions | Cycles | IPC |
| --- | ---: | ---: | ---: |
| Lowest free | 27.53 | 7.11 | 3.87 |
| Levels, scalar twin | 30.96 | 7.15 | 4.33 |
| Levels, AVX-512 | 15.47 | 8.20 | 1.89 |
| Levels, AVX-512 v2 | 15.70 | 7.23 | 2.17 |

v2 runs 330 instructions per 21-instruction chunk.

### 4. LLVM on `sqlite3.c`

One `-ftime-report` run per level (`logs/9700x/llvm-O2.log`, `llvm-O0.log`); instructions counted in the objects'
`objdump -d`, after allocation (at `-O2` its spill code, 5.8% of them, is included in the denominator). The times
are each pass's total CPU time from one run, not matched counter measurements.

| Level | Instructions | Passes | Time | Per instruction |
| --- | ---: | --- | ---: | ---: |
| `-O2` | 248,719 | Greedy Register Allocator (both instances) | 0.428 s | 1.72 µs (about 9,500 cycles at 5.5 GHz) |
| `-O2` | 248,719 | all allocation-related passes* | 0.835 s | 3.36 µs (about 18,500 cycles) |
| `-O0` | 236,385 | Fast Register Allocator | 0.0198 s | 84 ns (about 460 cycles) |
| `-O0` | 236,385 | Fast Register Allocator, Two-Address and PHI elimination | 0.0319 s | 135 ns (about 740 cycles) |

\* Greedy, Register Coalescer, Live Variable Analysis, Live Interval Analysis, Virtual Register Rewriter, PHI
elimination, Two-Address, slot index numbering, Stack Slot Coloring, Live Register Matrix, Spill Code Placement, Live
Stack Slot Analysis, Virtual Register Map, Local Stack Slot Allocation and subregister renaming.

The `-O2` assembly's annotations (`logs/9700x/llvm-O2-asm.log`): 3,640 spills, 9,724 reloads, 1,107 folded reloads.

## Limitations

- Synthetic workloads only. Tier 1 compiles no corpus yet; the interval workloads are `benchmark-tier1-allocation`'s
  shapes and two more, not corpus functions.
- The instruction-stream prototypes cover one straight-line block with no fixed registers and no spilling: pressure
  fits by construction (16 registers per class in `stream.c`, 32 in `levels.c`). They are evidence for the cost of the
  representation and of the kernels, not an allocator.
- Neither power state the repository asks for was isolated: each configuration's batch follows the previous
  configuration's (a few milliseconds of other code), not 100-300 ms of scalar work, and is not run alone. This
  matters most for the AVX-512 kernels.
- Cycles are perf's user cycle counter; nanoseconds come from `CLOCK_MONOTONIC_RAW`. LLVM's times are one
  `-ftime-report` run per optimization level; cycle figures for them assume 5.5 GHz.
- The phase profile is one configuration (`vector-resolved`) on one workload (temps-fit, 4,096 intervals).
- Exploratory runs earlier the same day (hand-copied, not part of this record) gave the same numbers within about 2%.

## Corrections

After [review 5718346232](https://github.com/buster14a/buster-performance/pull/157#pullrequestreview-5718346232), on
2026-10-30, without changing the logs or rerunning anything: the timed configurations are described as
`proto_allocate_impl` throughout (the production entry points are the pre-timing oracles); the calibration is
described as `vector-current`'s, reused for every configuration; `same_output`'s compared fields replace "byte for
byte"; the stream inputs are described as similar shapes, with the reconstruction's counts; the stream rounds' spread
is about 0.7% (0.65%), not within 0.6%; and the LLVM denominator is stated as the objects' instructions after
allocation.
