# Tier 0's back half on bytes, in the shadow: the one-core path's step 4, piece 1 (buster#2874), 2026-11-21

[buster#2874](https://github.com/buster14a/buster/issues/2874)'s design
([7060520410](https://github.com/buster14a/buster/issues/2874#issuecomment-7060520410)) made its first piece "byte
templates": an entry's machine code from a template's bytes, its positions a prefix sum of bytes, branch sizing on
the branches alone, with no records, no immediates' forms pass, no `x86_measure` and no encoder for the entries a
template takes. This record is that piece in the shadow, against its gate. **It is exact, and its cost refutes it.**
The design's measurements are [tier0-row-2874-2026-11-21](../tier0-row-2874-2026-11-21/).

## What was built

`measure-tier0-bytes` (`scripts/tier0_bytes_measure.c`, wired in by `scripts/main.c.patch`, on buster main
`e77b3eba4752`). It is a measurement command; nothing of a compile changes.

- **The functions** are the ones `-c` lowers, read as `measure-tier0-entries` reads them. Each is compiled by Tier 0's
  front (labels, values, fusion, depths, selection, homes, frame) twice, untimed, and then by two back halves, each
  timed in TSC ticks: today's (measuring, the output's room, emission, the forms, branch sizing and the encoder, as
  `tier0_generate` and the emission run them: the reference) and the shadow's.
- **The shadow's back half.** An entry's bytes come from its *shape*: its template, the hole block's bytes its records'
  registers, modes and forms read, its constant's value classes (`x86_choice_classes`, for a dynamic choice) and the
  sizes of the displacements its hole block gives. A shape's bytes are the encoder's, made at its first use from that
  entry's own records (expanded, their form chosen, encoded), with the bytes that come from the hole block found by
  encoding again with two sets of marked values; every later entry of the shape copies 32 bytes and takes its own
  values' bytes with one masked `vpermb` of its hole block. Pass A computes the hole blocks and the keys 8 entries at a
  time (the hashes in vectors, the slots by gathers, a miss a lane at a time) and each entry's length; the positions
  are their prefix sum; pass B expands the shapes and compresses the branches; branch sizing runs `size_branches`' own
  rounds on the branches' byte positions. Deferred entries, the prologue and the epilogue are records, encoded at
  their places.
- **Exactness:** each taken function's bytes and fixups (end, kind, field, target) must be the reference's; the
  command fails otherwise. A function the piece doesn't take is listed by why: the memory classes (long double, 128-bit
  integers), vectors and masks, segment overrides, deep values, asm bodies, tail calls, eh_return, setjmp's snapshots,
  probes, interrupt and preserving frames, deferred entries with branches.
- **Diagnostics in the command:** per-phase laps of the shadow, and `BUSTER_TIER0_BYTES_FAKE`, which replaces the
  shapes' lookups by a direct index (the bytes are then wrong, and the timing is the rest's floor).

## How it was measured

- The 9700X, CPU 2, under the lock, a hold a run (`scripts/bytes.sh`, `scripts/bytesfake.sh`, `scripts/bytesperf.sh`);
  Release `znver5` builds made in a cloud container with CI's staged toolchain (LLVM 23.1.4) and copied over
  (`binaries.sha256`). Five passes over the functions; the figures are the medians of the four after the first, which
  makes the shapes. `results/*/busy.txt` has the busiest processes around each hold.
- `sqlite3.c` with the frozen corpus's options (`--predefines provenance/gnu17-pinned-predefines.txt -march=znver5
  -std=gnu17 -nostdinc` and its three `-isystem` directories). musl's 1,336 units (its build's options) were run in the
  cloud container for exactness alone.
- Cycles are TSC ticks times 5.45 / 3.7928.

## Results

**Exact.** Every taken function's bytes and fixups are the reference's:

| | functions taken | entries taken | bytes | mismatches | shapes |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` (9700X) | 2,591 of 2,602 | 368,117 of 371,246 (99.16%) | 1,027,006 | 0 | 4,937 |
| musl (cloud, one process) | 2,018 of 2,756 | 142,032 of 192,404 (73.82%) | 429,995 | 0 | 4,067 |

musl's refusals: the memory classes 13.24% of its entries, vectors and masks 10.10%, asm bodies 2.68%, deep values
0.12%, snapshots 0.05%. `sqlite3.c`'s: vectors and masks 0.83%, the memory classes 0.02%.

**Cost,** `sqlite3.c`'s taken entries, TSC ticks an entry (cycles in brackets), `results/bytesfake3`:

| | ticks | cycles |
| --- | ---: | ---: |
| the reference: measuring, emission, the forms, sizing, the encoder | 30.41 | 43.7 |
| the shadow's back half | 43.73 | 62.8 |
| … its deferred entries (today's emitters, encoded aside) | 6.25 | 9.0 |
| … the rest | 37.48 | 53.9 |
| the shadow with its lookups replaced by a direct index (`fake.txt`; its reference 30.46) | 30.01 | 43.1 |
| … its rest | 24.13 | 34.7 |

The shadow's laps (all five passes, the first with its shapes' first uses), ticks an entry: the prologue 1.34, pass A
29.82, the prefix sum 0.51, pass B 8.35, the epilogue 1.00, sizing 5.66, the final copy 0.21. A shape's first use took
579.5 ticks (833 cycles): 4,937 of them, 11.2 cycles a taken entry in the pass that makes them (`results/bytes2`).

The first 9700X run (`results/bytes1`, the shadow before its lookups were vectors and its sizing was lean) read the
shadow at 61.61 ticks an entry against the reference's 30.37; `results/bytesperf2` has a `perf record` of the second
version, whose hottest instructions are spread over the slots' gathers, the hash's multiplies and the lines' loads.

## Against the gate

| the gate's line | asked | read | verdict |
| --- | --- | --- | --- |
| exact | every taken function's bytes, relocations and branch sizes | 0 mismatches on `sqlite3.c` and musl | **met** on the two corpora run |
| taken | 95% of each corpus's entries or more | 99.16% and 73.82% | **met** on `sqlite3.c`, **missed** on musl |
| the back half | 20 cycles an entry or less with today's deferred emitters inside (refuted above 30) | 62.8 | **refuted** |
| the template entries' part | 8 or less (refuted above 12) | 53.9 | **refuted** |

Lua, the compiler's own `main.c` and c-testsuite were not run.

## What it means

- **Bytes from shapes are exact,** and few: 4,937 shapes for `sqlite3.c`'s 368,117 taken entries (exact registers,
  forms and sizes), each the encoder's own bytes. The format works.
- **The format is not where the back half's time is.** With the lookups free, the shadow's back half costs what
  today's does (43.1 cycles an entry against 43.8). What both pay is the per-entry bookkeeping before any byte: the
  homes' cases, the hole blocks (the constant, the homes, the depths' registers), the keys or the expansion, the
  positions, and the deferred entries (9 cycles an entry). Records and the vector encoder (3.32 cycles a record at its
  own benchmark's rate, by the census) were never the cost.
- **The shapes' lookups cost more than they save:** 19.2 cycles an entry (the rest with them, 53.9, less the rest
  without, 34.7) for a hash, two gathers into a 512 KB table and a 32-byte line, where today's template line is one
  load from a 142 KB table by the template's index.
- **For step 4,** the row's cost is the number of passes and what each pays an entry and a body (the design's item 1:
  80% of Tier 0's cycles are an entry's, 26 cycles an entry are bodies' fixed costs), not the records. The next
  pieces are the bodies' fixed costs (the unwind rows from the frame: 1,419 cycles a body) and Tier 0's passes fused
  into one loop a block, with records and the encoder as they are.

## Files

- `scripts/tier0_bytes_measure.c`, `scripts/main.c.patch`: the command, on main `e77b3eba4752` (in the checker's unit,
  after `tier0_entries_measure.c`).
- `scripts/bytes.sh`, `scripts/bytesfake.sh`, `scripts/bytesperf.sh`: the 9700X runs.
- `results/bytes1/`, `results/bytes2/`: the first two versions' runs; `results/bytesfake3/real.txt`, `fake.txt`: the
  last version, with its lookups and without; `results/bytesperf2/`: a `perf` profile and `perf stat` of the second;
  `results/cloud/musl.txt`: musl's exactness run.
