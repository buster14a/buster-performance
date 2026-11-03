# Tier 1 emitted-code certificates: cost and size — #939, 2026-11-03

Source: [buster#1212](https://github.com/buster14a/buster/pull/1212), for
[buster#939](https://github.com/buster14a/buster/issues/939). #939 asks the
checker to judge the concrete emitted code, not the allocator's account of
it. #1212 adds the bridge that decodes the CFG consumer's emitted records into
a certificate (`tier1_certificate_emitted.c`), and
`benchmark-tier1-code-certificate`, which times it. The allocation
certificates' cost is recorded in
[`tier1-certificate-939-2026-11-02`](../tier1-certificate-939-2026-11-02/README.md)
(buster-performance#217).

The candidate is `6d85124e151245c96e5672f719031576deb565c9` (tree
`5f404f2924cd608ed1d869d8319c0b603fb316aa`), the head of #1212. The job ran
its merge into main `730eea0a7b3f5c6a95be4f13653bd86759b39a2d`, merge commit
`a30ddf00177`. This is one measurement of one revision. It is not an A/B
comparison and makes no claim against another revision.

## Run

- [Workflow run 41636653008](https://github.com/buster14a/buster/actions/runs/41636653008),
  Benchpress job `125923425813` on the approved Ryzen 7 9700X. The job ran
  native correctness first, then the benchmarks its `MEASURE` list selects;
  `tier1-certificate` and `tier1-code-certificate` were among them.
- Host build: `BUSTER_HOST_ARCH=znver5`, the job's standard Benchpress build.
  The job's oracle line reports `clang version 23.1.4 (https://github.com/llvm/llvm-project 7a941dfb2877a0b8cf30323fefa85ad019e0b0f5)`.
- Workload: the frozen `preprocessor-391e729af658/sqlite/sqlite3.c`, with its
  pinned predefines and headers. The exact options are in the step's script in
  `benchmark-6d85124e.txt`.
- Command: `taskset -c "$cpu" ./build/compiler benchmark-tier1-code-certificate ...`,
  pinned to the job's first allowed CPU.

`benchmark-6d85124e.txt` is the step's script, environment and complete
output, with timestamps and colour escapes removed.
`allocation-benchmark-6d85124e.txt` is the same job's
`benchmark-tier1-certificate` step, for comparison. `correctness-6d85124e.txt`
holds the job's checkout line, its oracle line, and the native correctness
lines that report certificates.

## Method

`benchmark-tier1-code-certificate` at `6d85124e`:

- It builds `benchmark-tier1-select-source`'s corpus: every function of the
  file, lowered, promoted and optimized as the C driver's `--tier1` takes it.
- Before the timing, each function is planned by the vector path and emitted
  as `--tier1 --verify` emits it, with its code's certificate checked. A
  function the CFG consumer doesn't take (the straight-line consumer keeps the
  interval certificate) is left out and counted, and so is one whose shape the
  decoding doesn't cover yet, by reason. A refusal would fail the benchmark.
- Four variants then run over every certified function in 21 passes after a
  warm-up, the order rotating by pass:
  - `emit`: `tier1_emit_function` without the certificates, the code being
    certified;
  - `decode`: `tier1_certificate_emitted`, which builds the program from the
    emitted records;
  - `check`: `tier1_certificate_check` alone, on programs decoded before the
    timing;
  - `certify`: both, as `Tier1EmitOptions.certify` runs them.
- Each variant is reported as a median per IR instruction: time, core cycles,
  instructions and IPC. It is also reported in cycles per emitted record, and
  with PMCx1A0 umask 0x08 per IR instruction (the `thr/instr` column, the
  counter buster's Tier 0 benchmarks report since buster#199).

## Results

Of the file's 2,602 functions, 2,600 were selected:

| Functions | Count |
| --- | ---: |
| code certified | 2,103 |
| straight-line (interval certificate, not this bridge) | 429 |
| uncertified: indirect jumps to several labels | 41 |
| uncertified: variadic definitions | 20 |
| uncertified: by-value aggregates | 7 |
| not emitted | 0 |

None was refused. The 2,103 certified functions have 370,795 IR instructions
and 261,385 emitted records.

Medians of 21 passes, over the 2,103 certified functions:

| Variant | ns/instr | cycles/instr | instr/instr | IPC | cycles/record | ms for the corpus | vs `emit` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `emit` | 343.00 | 1,899.71 | 4,385.06 | 2.31 | 2,694.88 | 127.18 | 1.00 |
| `decode` | 95.35 | 528.53 | 1,126.80 | 2.13 | 749.77 | 35.36 | 0.28 |
| `check` | 73.39 | 406.73 | 1,909.39 | 4.69 | 576.98 | 27.21 | 0.21 |
| `certify` | 166.88 | 925.01 | 3,036.72 | 3.28 | 1,312.20 | 61.88 | 0.49 |

Certifying the emitted code costs 0.49 times its emission: 167 ns per IR
instruction, about 57% of it to decode the records and 43% to check the
program. The checker alone runs at 4.69 IPC. The decoding runs at 2.13 IPC;
it regenerates each node's records to compare them byte for byte, so part of
its cost is the emitter's own expansion.

The PMCx1A0 umask 0x08 column reads 48.393 per IR instruction for `emit`,
33.729 for `decode`, 3.155 for `check` and 36.662 for `certify`. This record
doesn't interpret that counter.

For comparison, the same job's `benchmark-tier1-certificate` (the allocation
certificate, over all 2,600 functions' 481,458 IR instructions) reports
`allocate` at 148.88 ns per IR instruction and `certify` at 178.20.
`allocation-benchmark-6d85124e.txt` has its full output. The two benchmarks'
corpora differ, so their per-instruction figures don't add exactly.

### Certificate sizes

Totals over the 2,103 certified functions:

| Quantity | Total | Per IR instruction |
| --- | ---: | ---: |
| emitted records | 261,385 | 0.705 |
| edits (moves, recomputations, frame protocol) | 75,214, plus 30,818 on edges | 0.286 |
| original instructions (nodes, calls, returns) | 110,036 | |
| source records | 171,931 | |
| facts | 499,412 | 1.347 |
| storage | 522,664 locations over 1,149,012 units | |
| program bytes | 69,992,368; the largest function's 1,237,720 | 188.8 |
| checker scratch | the largest 55,273 bytes | |
| checker unit reads and writes | 10,733,183 and 11,352,488 | |

The facts include the frame protocol's: each callee-saved register's value at
entry and the return address, asserted at every block's entry. These are seven
pseudo values per function.

### Correctness in the same job

The job's native correctness, at the same merge:

- `test-tier1-emit`'s code-certificate fixture (its line appears three times
  in the job, identical): 8 compiles certified. Every corruption was refused:
  - stale argument registers, 16 of 16, including 8 of 8 into rsi, the second
    placement of a value passed twice;
  - saves and restores left out, 16 of 16;
  - a store and its load around a call left out, 16 of 16;
  - rows below rsp, 8 of 8;
  - frame pointers set after the allocation, 4 of 4.

  The dynamic frames were 2 of 2 certified, and their frame pointers set after
  the allocation were refused, 2 of 2.
- `test-tier1-pipeline`: 32 of 36 CFG functions' code certified; the other 4
  are its dynamic-stack fixture. Of 890 record mutants, 879 were refused, all
  of the prologue and epilogue mutants among them. The 11 accepted ran natively
  and agreed with the interpreter. The pipeline line has the exact counts.
- `test-tier1-masks`, `test-tier1-certificate`,
  `test-tier1-certificate-interval` and the straight-line allocation
  certificates: 0 failures.

## Second run: #1212's head after review, `7f54d0b5`

The review of #1212 added two checks to the bridge after `6d85124e`:
- a conditional jump reads the condition only while the flags are its
  comparison's (`5ec959e1`);
- a narrow parameter is only its caller's bytes at entry, and its `movzx` is
  the instruction that defines it (`7f54d0b5`).

The frame-pointer, incoming-slot and rows-above-rsp checks (`35b4de33`) were
already in the first run.

The same job measured `7f54d0b50b81c344ad5a12226b8f1ef9a45712a8` (tree
`ca51cb65dd05cfd0a2afa5f79b2ba0e8cd2b9cd0`), merged into main
`a4a2182ad770bd22f25f843b934ba690bac9b1c8` as merge commit `b783c7e6600`. It
ran in [workflow run 41655522070](https://github.com/buster14a/buster/actions/runs/41655522070),
Benchpress job `125989784220`, with the same build, workload and command.
`benchmark-7f54d0b5.txt`, `allocation-benchmark-7f54d0b5.txt` and
`correctness-7f54d0b5.txt` hold its lines, as above.

The functions are the same: 2,103 code-certified, 429 straight-line, 68
uncertified by the same reasons, none refused, 370,795 IR instructions and
261,385 records. Medians of 21 passes:

| Variant | ns/instr | instr/instr | IPC | cycles/record | at `6d85124e` (ns/instr) |
| --- | ---: | ---: | ---: | ---: | ---: |
| `emit` | 345.26 | 4,385.06 | 2.29 | 2,713.13 | 343.00 |
| `decode` | 101.52 | 1,316.26 | 2.34 | 798.40 | 95.35 |
| `check` | 73.78 | 1,909.61 | 4.67 | 580.15 | 73.39 |
| `certify` | 173.71 | 3,226.41 | 3.35 | 1,366.12 | 166.88 |

The instruction counts are the steadier measure here:
- `emit` and `check` are unchanged.
- `decode` executes 189 more instructions per IR instruction (+16.8%), and
  `certify` as many. Between the two revisions the decoding gained the flag
  tracking, which looks up each body and edge record's effects, and the
  narrow parameters' extensions.

The times move within this job's noise. The same job's allocation-certificate
benchmark, whose code didn't change, reads `certify` 189.75 ns against the
first run's 178.20 ns (+6.5%) and `allocate` 148.49 against 148.88. So the
`certify` time's +4.1% here (166.88 to 173.71 ns, now 0.50 times `emit`) is
not separated from that variation. The program bytes grow by 127,944
(70,120,312), the narrow parameters' incoming values and locations.

The job's native correctness, at the same merge, refused every corruption of
the code-certificate fixture. That now includes:
- a conditional jump after an edge's flag-writing move;
- the narrow parameters' extensions corrupted in a register (2 of 2) and from
  a slot (2 of 2).

`test-tier1-pipeline` again certified 32 of 36 CFG functions' code and refused
879 of 890 mutants.

## Limitations

- **One run per revision.** Each revision is one process in one Benchpress
  job: 21 passes, medians only. The benchmark prints no spread, and the clock and thermal state weren't
  recorded.
- **No vector path.** The decoding and the checker are scalar, so no
  after-scalar state applies.
- **Only certified functions.** The timing covers the 2,103 functions whose
  code the bridge certifies. The 68 shapes it leaves uncertified, and the 429
  straight-line functions, are outside it, so `emit` here is not the whole
  file's emission time.
- **The parts don't add up exactly.** `certify` runs `decode` and `check` in
  one pass. The separate medians (95.35 + 73.39 ns) come to slightly more than
  its 166.88 ns; treat the split as approximate.
- **Scope of the evidence.** Generated-code quality and whole-compile time are
  outside this measurement. The raw workflow log is linked above; only the
  lines in the three text files are retained here.
