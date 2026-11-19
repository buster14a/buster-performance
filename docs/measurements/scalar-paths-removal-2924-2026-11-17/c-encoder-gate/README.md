# C10's gate: the x86 encoder's vector paths against its scalar loop (#2924)

[`run.sh`](run.sh) ran on the 9700X on main `0c113feb1` ([`logs/commit.txt`](logs/commit.txt)): Release, every run under
the lock, pinned to CPU 2. `benchmark-x86-encoder` checks every implementation's bytes against the scalar loop, then
reports 21 interleaved passes' medians per encoded instruction. It ran four streams:
- the compiler-like mix of 16,384 legacy instructions (64-bit);
- the mix like vectorized code (`--vector`);
- 32-bit mode's mix (`--mode32`);
- 16-bit mode's (`--mode16`).

Each stream ran in calls of 1, 4, 16 and 256 instructions, and whole (`--section N`).

Cycles per encoded instruction (medians; the entry points use 16 per iteration, `x86_encode` and the modes' `_16`
loops):

| Stream | Calls of | Scalar loop | `x86_encode_16` | `x86_encode_64` | Scalar / vector |
| --- | --- | ---: | ---: | ---: | ---: |
| 64-bit mix | 1 | 83.15 | 77.92 | 77.86 | 1.07 |
| 64-bit mix | 4 | 79.15 | 10.24 | 10.25 | 7.7 |
| 64-bit mix | 16 | 72.86 | 3.38 | 3.24 | 21.6 |
| 64-bit mix | 256 | 70.24 | 3.02 | 3.02 | 23.3 |
| 64-bit mix | all | 69.57 | 3.06 | 2.97 | 22.7 |
| Vector mix | 1 | 87.85 | 77.96 | 77.96 | 1.13 |
| Vector mix | 4 | 88.80 | 10.15 | 10.21 | 8.7 |
| Vector mix | 16 | 81.86 | 3.15 | 3.18 | 26.0 |
| Vector mix | all | 78.48 | 3.09 | 2.99 | 25.4 |
| 32-bit mode | 1 | 100.10 [99.83-100.54] | **102.89** [102.89-102.90] | 103.11 | **0.973** |
| 32-bit mode | 4 | 94.81 | 17.13 | 17.42 | 5.5 |
| 32-bit mode | 16 | 88.74 | 4.32 | 4.08 | 20.5 |
| 32-bit mode | all | 86.90 | 3.76 | 3.84 | 23.1 |
| 16-bit mode | 1 | 103.41 [103.22-103.76] | **103.79** [103.75-103.86] | 104.13 | **0.996** |
| 16-bit mode | 4 | 99.02 | 17.12 | 17.60 | 5.8 |
| 16-bit mode | 16 | 92.40 | 4.28 | 4.02 | 21.6 |
| 16-bit mode | all | 90.26 | 3.79 | 3.94 | 23.8 |

The vector encoder wins at every size in 64-bit mode. In 32-bit mode it loses at one instruction a call, by 2.8% with
the passes' ranges apart; in 16-bit mode by 0.4%, the ranges touching. From four instructions a call it wins in every
mode, by 5.5 to 26 times.

**Who calls which.** Only 64-bit encoding has callers outside the encoder's own tests and benchmark:
- the compiler's emission, the linker's program code and streaming, which encode whole functions;
- inline assembly's records in the C driver (`c_check_program_asm.c`), one at a time, with a `--scalar` arm;
- the assembler, which encodes one record at a time (`x86_encode(record, 1, …)`) and makes a 32-bit address itself, by
  a 67 before a 64-bit encoding (`asm_emit_address32`);
- branch sizing and the assembler, through `x86_measure`.

`x86_encode_mode32`, `x86_encode_mode16`, `x86_encode_apx` and `x86_encode_address32`, and their scalar twins, are
called by `test-x86-encoder` and `benchmark-x86-encoder` alone.

**Not measured here:** APX's and 32-bit addresses' entry points against their own scalar twins (`x86_encode_scalar_apx`,
`x86_encode_scalar_address32`). The benchmark times APX's loops against the 64-bit scalar loop only, and has no 32-bit
address stream.

The scalar single-instruction encoder (`encode_one`) also serves `x86_validate` in 16- and 32-bit modes: an instruction
whose mode adds a 66 or a 67 must stay within 15 bytes, which validation checks by encoding it.

## `x86_measure` against its scalar twin

The runs above time encoding alone. `x86_measure`, which gives the offsets and length without bytes (branch sizing's
and the assembler's), has its own vector loop and scalar twin, so it was measured too, in [`measure/`](measure/), on
main `bc66290c5` with an experiment patch that adds measuring entries to `benchmark-x86-encoder`. Each is checked
against the scalar loop's offsets and length, then timed on the compiler mix and the vector mix. Release, every run
under the lock on CPU 2.

**First run** ([`measure/first/`](measure/first/), [`c10-measure-gate.patch`](measure/first/c10-measure-gate.patch)):
`measure_scalar` (`x86_measure_scalar`) and `measure_vector` (`x86_measure`), at 1, 4, 16 and 256 instructions a call
and whole, each in a run of every implementation and three times alone (`--only`). From four instructions a call the
vector path wins by 7 to 39 times, but at one it loses: 105.6 cycles an instruction against 88.0 (compiler mix) and
91.4 to 92.5 (vector mix), every round.

**Why:** `x86_measure` copied a last partial group into a zeroed array of 16 records and loaded it back as four 64-byte
vectors, which can't take their data from the copy's narrower stores and wait for them. A call of one record is all
tail.

**Second run** ([`measure/masked/`](measure/masked/), [`c10-measure-masked.patch`](measure/masked/c10-measure-masked.patch)):
the same, with a third entry, `measure_masked`, that loads the last partial group by masked loads of its records'
dwords, straight from the records. Each entry alone (`--only`), three rounds in turn. Cycles per instruction:

| Stream | Calls of | `x86_measure_scalar` | `x86_measure` (zeroed copy) | Masked loads |
| --- | ---: | --- | --- | --- |
| Compiler mix | 1 | 88.03, 87.91, 88.03 | 105.56, 105.56, 105.56 | 41.94, 41.82, 41.82 |
| Compiler mix | 2 | 84.71, 84.70, 84.55 | 52.69, 52.74, 52.69 | 21.00, 21.08, 21.01 |
| Compiler mix | 3 | 85.22, 85.19, 85.21 | 35.13, 35.14, 35.13 | 14.15, 14.16, 14.16 |
| Compiler mix | 4 | 86.79, 86.84, 87.06 | 11.97, 11.95, 13.34 | 10.52, 10.52, 10.52 |
| Compiler mix | 8 | 84.09, 83.98, 83.76 | 6.02, 6.01, 6.28 | 5.36, 5.36, 5.45 |
| Compiler mix | 16 | 81.84, 81.80, 81.70 | 2.75, 2.76, 2.76 | 2.61, 2.61, 2.60 |
| Compiler mix | all | 80.31, 80.44, 80.27 | 2.15, 2.15, 2.15 | 2.15, 2.15, 2.15 |
| Vector mix | 1 | 92.47, 91.43, 91.47 | 105.56, 105.33, 105.34 | 41.99, 41.90, 41.90 |
| Vector mix | 2 | 89.71, 90.10, 89.83 | 52.70, 52.69, 52.69 | 21.12, 21.08, 21.08 |
| Vector mix | 3 | 92.94, 92.78, 92.98 | 35.15, 35.15, 35.15 | 14.23, 14.28, 14.33 |
| Vector mix | 4 | 92.98, 93.17, 92.41 | 11.98, 11.90, 11.90 | 10.61, 10.60, 10.60 |
| Vector mix | 8 | 89.10, 89.39, 89.46 | 6.12, 6.06, 6.04 | 5.44, 5.43, 5.44 |
| Vector mix | 16 | 86.01, 85.87, 86.11 | 2.78, 2.77, 2.77 | 2.71, 2.71, 2.71 |
| Vector mix | all | 84.33, 84.05, 83.75 | 2.15, 2.15, 2.15 | 2.15, 2.15, 2.15 |

With masked loads the vector path wins at every size, by 2.1 times at one instruction a call, and is never slower than
the zeroed copy. C10 makes it `x86_measure`'s tail, then deletes the twin.

The encoder's own tail (`encode_tail64`, and the other entry points' last partial groups) copies into a zeroed array
the same way, and loses or nearly loses at one instruction a call in 32-bit and 16-bit modes (above). That is the next
thing to try for those modes.
