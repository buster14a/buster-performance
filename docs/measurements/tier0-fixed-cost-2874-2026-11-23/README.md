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

## Files

- `scripts/bins.sh`, `run-bins.sh`: the passes by size; `scripts/perf-small.sh`, `run-small.sh`: the small functions'
  profile; `perf_table.py` (by function), `perf_src.py` (by line), `perf_hot.py` (by instruction, with the
  instructions before it), `perf_lines.py`.
- `scripts/piece-c.patch`, `ab.sh`, `abtable.sh`, `run-ahead.sh`: piece C and its A/B; `exact.sh`, `exact-avx.sh`: the
  objects' comparison.
- `results/bins1/bins.txt`: a line a run; `results/small1`: `events.txt`, the benchmark's line, `ips.tar.zst` (each
  event's sampled addresses and counts, for the tuning executable `tune4` of the batches' record).
- `results/ab-ahead`: the tables, the objects' hashes, `stages.tar.zst`.
