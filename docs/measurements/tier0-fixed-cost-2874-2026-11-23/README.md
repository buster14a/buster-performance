# Tier 0: a function's fixed cost, and the loads that wait on stores (buster#2874's pieces C and D), 2026-11-23

[buster#2874](https://github.com/buster14a/buster/issues/2874), after
[the passes over a window's bodies](../tier0-batches-2874-2026-11-23/README.md). There, all of `sqlite3.c`'s bodies
read 45.8 cycles an entry and those of 512 entries or more 35.8: a body costs about 1,400 cycles beside its entries'
work. This record says where those are, and has the two pieces that followed.

Everything is on the 9700X, CPU 2, under the lock, Release, `BUSTER_HOST_ARCH=znver5`, `sqlite3.c` (2,602 functions,
371,237 typed entries).

## The passes by a function's size (`results/bins1`, `scripts/bins.sh`)

`benchmark-backend-source --only vector` in batches of 32 on the tuning executable (`tune4`, every knob off: main
`b7d0b5ed` with the batches), the functions in nine bins of their entry counts (`BUSTER_TIER0_MIN`, `_MAX`), a run a
bin, a stop (the pass the batch stops after) and an event pair. Cycles a function:

| entries | functions | the front and selection | homes, frame | measuring | emission | the forms and the rest | a function | an entry |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| under 8 | 214 | 635 | 210 | 191 | 180 | 99 | 1,315 | 266 |
| 8 to 15 | 272 | 707 | 242 | 277 | 242 | 143 | 1,611 | 143 |
| 16 to 31 | 396 | 822 | 248 | 308 | 375 | 226 | 1,979 | 86 |
| 32 to 63 | 555 | 1,039 | 316 | 433 | 608 | 316 | 2,711 | 59 |
| 64 to 127 | 508 | 1,725 | 388 | 727 | 1,171 | 472 | 4,484 | 49 |
| 128 to 255 | 360 | 2,846 | 526 | 1,216 | 1,896 | 674 | 7,158 | 40 |
| 256 to 511 | 182 | 4,937 | 862 | 2,290 | 3,526 | 1,053 | 12,668 | 35 |
| 512 to 1,023 | 75 | 9,131 | 1,473 | 4,386 | 7,240 | 1,990 | 24,220 | 35 |
| 1,024 or more | 40 | 33,531 | 4,381 | 17,994 | 29,260 | 7,343 | 92,509 | 36 |

- A least-squares line through the bins, weighted by their functions: **1,043 cycles a function and 34.9 an entry**
  (the front and selection 514 and 12.7, the homes 233 and 1.6, measuring 91 and 6.8, emission 43 and 11.1, the rest
  162 and 2.8). The functions' fixed work is 2.7 M of the 17.0 M cycles.
- A function of five entries runs 5,119 instructions: 2,244 in the front and selection, 922 in the homes, 714 in
  measuring, 833 in emission, 406 after.
- **The front's 64-entry blocks are not the fixed cost.** Fitted with each bin's count of 64-entry blocks and of
  8-entry blocks, the front and selection are 367 cycles a function, 226 a block of 64 and 73 a block of 8 (964, 1,008
  and 260 instructions). `sqlite3.c`'s functions have 7,256 blocks of 64 where their entries fill 5,801: sharing blocks
  across a batch's functions, with eight entries between two functions, would save 0.25 M of the front's 6.1 M cycles.

## Where a small function's cycles are (`results/small1`, `scripts/perf-small.sh`)

`perf record` (user mode, one event a run, periods in `events.txt`) of the same benchmark over the 486 functions under
16 entries (4,117 entries), 20,001 loops. The benchmark reads 181.6 cycles an entry there, 1,538 a function; the
samples in Tier 0's functions make 1,641 a function. By instruction (`scripts/perf_hot.py`; a sample is at the
instruction after the one that waited):

| cycles a function | the load | what it waits on |
| ---: | --- | --- |
| 95 | `incl (references, local, 4)`: `references[local] += 1` in `tier0_count_references_vector` | the `memset` of the counts before it: under 64 bytes, glibc's is one masked store |
| 85 | `vmovdqu8 (absorbed), %zmm{k}{z}`: P3b's first load in `tier0_vector_depths` | P3a's masked store of the same block |
| 82 | `vmovdqu64 0x40(%rsp), %zmm`: the free registers' list in `tier0_assign_registers_vector` | the loops that stored the list a register at a time |
| 72 | `vmovq 0xac(%rsp), %xmm`: two of measuring's counts as one vector (the compiler's) in `tier0_measure_vector_entries` | `tier0_measure_listed`'s two stores of them |
| 58 | the second copy of a job's code in `tier0_compile_batch` (`tier0_job_code`) | the first copy's stores, laid out otherwise |

**392 of the 1,641 cycles are at those five instructions.** Each is a load right after stores it cannot be forwarded
from: a masked store, or several narrower stores under one wider load. Smaller ones of the same kind: P1's loads of
the predicates' words after P0's eight stores of a byte each (18), the homes loaded eight at a time after the
parameters' byte stores (13), the branches' targets loaded sixteen at a time after their compressed stores of eight
(13), selection's loads of the depths after P4's masked stores (12), measuring's counts again at its return (12).

By function, cycles a function compiled (`scripts/perf_table.py`): the front's passes 578, emission 164, measuring 147,
the references' counts 133, the homes 103, the calls' memo's lookup 77, the forms 74, the batch's driver 71, the
calls' raw effects 49, the prologue 39.

In a compile (the batch build's profile of `-c sqlite3.c`, `../tier0-batches-2874-2026-11-23`), the C driver copies
each body's code three more times: `check_program_emit_code_half` has 111 cycles a body at those three lines and 20
store-to-load conflicts a body. The whole compile has 3.85 M such conflicts (the PMU's count, raw event `224`), most of
them in the checker's passes (`check_input_expressions_coded_range` 563 K, `check_graph_run` 389 K,
`parse_tree_columns` 242 K), which this record doesn't look into.

## Each of those loads without its wait, a knob each: the samples overstated them (`results/stalls1`)

[Piece D's specification](https://github.com/buster14a/buster/issues/2874#issuecomment-7116827073) took the
samples above as costs. Before the piece's own A/B, each fix went behind a bit of `BUSTER_TIER0_CHAIN` in one tuning
executable (`tune5`: `scripts/tune5.patch` on main `b7d0b5ed`), each exact: every value of the knob gives main's
object for `sqlite3.c`, and with all on, 2,951 compiles and 4,492 at the AVX targets are the same as main's.

`-c sqlite3.c`, medians of 9 in turn (`table.txt`); and the benchmark in batches of 32 (`benchmark.txt`), over every
function and over the 1,437 functions under 64 entries (27.0 entries each), with the store-to-load conflicts (raw
event `224`):

| the bit | what | `tier0`, ms | cycles an entry | under 64 entries: cycles a function | instructions a function | conflicts a function |
| ---: | --- | ---: | ---: | ---: | ---: | ---: |
| 0 | none | 3.711 | 46.42 | 2,401 | 8,208 | 44.0 |
| 32 | the front's sub-passes each over the batch | 3.803 | 47.70 | 2,462 | 8,333 | 37.7 |
| 64 | P3a's distances carried in a register | 3.729 | 46.37 | 2,373 | 8,179 | 43.2 |
| 128 | the references' counts zeroed by whole vectors | 3.727 | 46.49 | 2,392 | 8,192 | 45.0 |
| 256 | P0's predicates' words stored whole | 3.802 | 47.32 | 2,429 | 8,324 | 45.2 |
| 512 | the front's whole-block stores unmasked | 3.704 | 47.05 | 2,397 | 8,208 | 42.3 |
| 1024 | the homes' register bits as a mask | 3.719 | 46.45 | 2,384 | 8,200 | 43.1 |
| 2048 | a job's code copied once | 3.736 | 46.47 | 2,385 | 8,180 | 44.4 |
| 4096 | the driver reads a batch's code in place | 3.736 | 46.83 | 2,394 | 8,208 | 44.7 |
| 8192 | the free registers' lists compressed in registers | 3.735 | 46.46 | 2,382 | 8,105 | 44.5 |
| 16384 | measuring's counts in registers | 3.719 | 46.53 | 2,413 | 8,212 | 46.2 |
| 32736 | all of them | 3.818 | 48.31 | 2,475 | 8,270 | 34.2 |
| 32740 | all, and selection's gather ahead | 3.779 | 47.55 | 2,457 | 8,351 | 32.3 |

- **No fix moves `tier0` in a compile:** every single bit reads within 0.03 ms of none, on either side.
- **In the benchmark a fix gains 9 to 28 cycles a small function** where its load was sampled at 58 to 95: the
  processor keeps working past a load that waits, retirement stops at it, and the samples pile up there. A function
  under 64 entries has 44 such conflicts; removing one is worth what little of its wait nothing else overlapped.
- **Two are slower by 0.09 ms:** the front's sub-passes each over the batch (six conflicts fewer a function, and the
  columns touched again from further away), and P0's words put together in registers (an inner loop of shifts
  where eight byte stores were cheaper). They make "all of them" slower.
- So a function's fixed cost is its instructions (5,119 for a function of five entries, at 3.9 a cycle), not a few
  waits.

## Piece C: selection's words gathered a block ahead (`results/ab-ahead`)

[Specified here](https://github.com/buster14a/buster/issues/2874#issuecomment-7116319725), after a knob of the tuning
executable read `tier0` 3.717 to 3.673 ms. `scripts/piece-c.patch` on main `d4a6eb540`, against that main, both built
from one tree; `-c sqlite3.c`, medians of 21 in turn (`table.txt`), ms:

| stage | main | the piece | change |
| --- | ---: | ---: | ---: |
| `tier0` | 3.663 | 3.644 | -0.019 |
| the row, `tier0` to `object-write` | 6.394 | 6.374 | -0.020 |

And `benchmark-backend-source`'s vector row, a function at a time, three runs each in turn (`benchmark.txt`), cycles
an entry: main 50.93, 51.31, 51.00; the piece 50.76, 50.88, 50.70.

- Both objects are the same. Exact: 2,951 compiles of the corpora (1,938 built) and 4,492 at the AVX targets (2,478
  built) the same as main's; `test-tier0 --cross-check` 21,796,335 checks, 0 failed.
- **Against the gate** (`tier0` 0.03 ms lower or more, refuted under 0.015; the benchmark 0.4 cycles an entry lower):
  **missed, not refuted**: 0.019 ms and 0.3 cycles an entry, every run of the benchmark below every run of main's.

## Piece D: the five loads without their stores (`results/ab-d`, `ab-cd`, `ab3-cd`)

`scripts/piece-d.patch` on piece C (buster#3486's second commit): the references' counts zeroed by whole vectors,
P3a's distances carried in a register, the free registers' lists compressed in registers, measuring's counts in
registers of their own, and a job's code copied once with the C driver reading a batch's code in place. Exact: 2,951
compiles of the corpora and 4,492 at the AVX targets the same as main `d4a6eb540`'s, `test-tier0 --cross-check`
21,796,335 checks, 0 failed.

Two A/Bs in one hold, medians of 21 in turn (`ab.sh`: the first executable, then the second, every round), ms:

| | the first | the second | change |
| --- | ---: | ---: | ---: |
| piece C, then C and D (`ab-d`): `tier0` | 3.604 | 3.588 | -0.016 |
| main, then C and D (`ab-cd`): `tier0` | 3.665 | 3.591 | -0.074 |
| main, then C and D: the row | 6.382 | 6.301 | -0.081 |

`benchmark-backend-source`'s vector row, a function at a time, three runs each in turn, cycles an entry: piece C
50.83, 50.78, 50.84; C and D 50.23, 50.16, 50.05.

**The two A/Bs disagree about piece C's executable**: it read 3.644 as the second of its pair an hour before
(`ab-ahead`) and 3.604 as the first here. So the three executables in one hold, 30 rounds, the order rotated a place
every round (`scripts/ab3.sh`, `results/ab3-cd`), medians, ms:

| stage | main `d4a6eb540` | piece C | C and D |
| --- | ---: | ---: | ---: |
| `tier0` | 3.660 | 3.616 | 3.582 |
| `branch-sizing` | 0.393 | 0.392 | 0.380 |
| the row, `tier0` to `object-write` | 6.327 | 6.268 | 6.234 |

- Every object is the same (`objects.txt`).
- **An A/B in a fixed order reads its second executable 0.01 to 0.03 ms high on `tier0`**: piece C read 0.028 above
  its rotated reading as a second, 0.012 below it as a first; C and D 0.009 above as a second. The A/Bs of this
  issue's earlier pieces all had the piece second.
- **Piece C: `tier0` 0.044 ms lower** rotated (0.019 as the second of a pair): its gate was 0.03.
- **Piece D: `tier0` 0.034 ms lower** rotated (0.016 as the second of a pair), and branch sizing 0.012 lower in all
  three runs, behind the driver's copies. **Against its gate** (0.10 ms, refuted under 0.04; the small functions 250
  cycles each faster): missed, at the refutation line, and its premise refuted by the knobs above. What its fixes
  are worth is this 0.03 ms.

## Files

- `scripts/bins.sh`, `run-bins.sh`: the passes by size; `scripts/perf-small.sh`, `run-small.sh`: the small functions'
  profile; `perf_table.py` (by function), `perf_src.py` (by line), `perf_hot.py` (by instruction, with the
  instructions before it), `perf_lines.py`.
- `scripts/piece-c.patch`, `ab.sh`, `abtable.sh`, `run-ahead.sh`: piece C and its A/B; `exact.sh`, `exact-avx.sh`: the
  objects' comparison.
- `results/bins1/bins.txt`: a line a run; `results/small1`: `events.txt`, the benchmark's line, `ips.tar.zst` (each
  event's sampled addresses and counts, for the tuning executable `tune4` of the batches' record).
- `scripts/tune5.patch`, `knobs2.sh`, `run-stalls.sh`: the stalls' knobs (the whole tuning tree against main
  `b7d0b5ed`) and their scan. Not for main.
- `scripts/piece-d.patch`, `run-d.sh`: piece D and its two A/Bs; `scripts/ab3.sh`, `run-ab3.sh`: the three
  executables with the order rotated.
- `results/ab-ahead`, `ab-d`, `ab-cd`, `ab3-cd`: the tables, the objects' hashes, `stages.tar.zst` (and `order.txt`,
  each round's order); `results/stalls1`: the scan's tables and `stages.tar.zst`.
