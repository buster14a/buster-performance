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

## The encoder's last partial group by masked loads

`x86_encode` and the other entry points copied a last partial group into a zeroed array too, so a call of one
instruction waited on the copy's stores as `x86_measure`'s did. That is what made 32-bit and 16-bit modes lose at one
instruction a call (the first table).

[`tail/`](tail/) ran an experiment ([`tailexp.patch`](tail/tailexp.patch)) on main `bc66290c5` against main itself. In
it, `encode_group` loads a partial group's records by masked loads of their dwords and takes their forms from the loaded
records (`X86_GATHER_INSERTS_FORMS_FROM_RECORDS`), with no copy. It passes main's `test-x86-encoder`, page edges and the
twins' comparisons included. The scalar loop and each mode's production loop ran alone (`--only`), by main and by the
experiment in turn, three rounds ([`tail/logs.tar.gz`](tail/logs.tar.gz)). Cycles per instruction, the scalar loop and
the vector loop by main, then by the experiment:

| Stream | Calls of | Scalar, main | Vector, main | Scalar, experiment | Vector, experiment |
| --- | ---: | --- | --- | --- | --- |
| 64-bit mix | 1 | 82.98, 82.88, 82.74 | 77.91, 77.92, 77.89 | 82.71, 82.31, 82.46 | 35.33, 35.62, 35.67 |
| 64-bit mix | 2 | 75.83, 75.83, 75.67 | 39.00, 39.00, 38.98 | 75.75, 75.15, 75.29 | 17.79, 18.03, 17.99 |
| 64-bit mix | 4 | 78.80, 79.18, 78.75 | 10.17, 10.33, 10.17 | 78.30, 78.59, 78.47 | 8.41, 8.47, 8.45 |
| 64-bit mix | 16 | 72.56, 72.20, 72.82 | 3.22, 3.19, 3.19 | 72.28, 72.41, 71.91 | 3.23, 3.25, 3.26 |
| 64-bit mix | all | 69.53, 69.29, 69.75 | 3.03, 3.16, 3.04 | 69.55, 69.32, 69.66 | 3.06, 3.07, 3.07 |
| Vector mix | 1 | 87.85, 87.50, 87.47 | 78.00, 78.03, 78.00 | 87.78, 87.42, 87.46 | 35.42, 35.49, 35.43 |
| Vector mix | 2 | 83.03, 83.17, 83.18 | 39.07, 39.08, 39.09 | 83.85, 83.17, 83.30 | 17.69, 17.86, 17.93 |
| Vector mix | 4 | 88.62, 88.23, 88.44 | 10.14, 10.20, 10.15 | 87.81, 87.94, 88.88 | 8.35, 8.33, 8.37 |
| Vector mix | 16 | 80.42, 80.47, 80.16 | 3.18, 3.16, 3.19 | 80.79, 80.53, 80.59 | 3.18, 3.14, 3.15 |
| Vector mix | all | 77.47, 77.83, 78.16 | 3.17, 3.09, 3.10 | 77.60, 77.21, 77.40 | 3.14, 3.13, 3.04 |
| 32-bit mode | 1 | 91.69, 92.20, 91.52 | 103.29, 103.40, 103.45 | 92.25, 91.49, 91.46 | 69.94, 69.78, 70.01 |
| 32-bit mode | 2 | 84.88, 84.04, 84.04 | 51.98, 52.71, 51.92 | 84.26, 84.33, 84.24 | 34.89, 34.83, 35.04 |
| 32-bit mode | 4 | 85.57, 85.46, 85.44 | 17.21, 17.28, 17.72 | 85.96, 86.31, 86.05 | 17.13, 17.12, 17.27 |
| 32-bit mode | 16 | 80.30, 80.03, 80.15 | 4.01, 3.91, 4.30 | 80.99, 80.78, 81.04 | 3.91, 3.93, 4.03 |
| 32-bit mode | all | 78.93, 78.60, 78.52 | 3.70, 3.77, 3.74 | 79.44, 79.48, 79.69 | 3.74, 3.69, 3.65 |
| 16-bit mode | 1 | 93.73, 93.70, 93.48 | 102.86, 105.60, 103.39 | 91.85, 92.13, 91.81 | 69.49, 69.51, 70.01 |
| 16-bit mode | 2 | 86.91, 86.70, 86.55 | 53.00, 52.12, 52.03 | 85.52, 85.82, 85.92 | 35.03, 34.87, 34.90 |
| 16-bit mode | 4 | 89.72, 89.38, 89.78 | 18.17, 17.28, 17.14 | 88.36, 88.59, 88.51 | 17.21, 17.16, 17.08 |
| 16-bit mode | 16 | 83.13, 83.14, 83.21 | 3.90, 3.92, 4.00 | 82.32, 82.22, 82.32 | 4.02, 4.05, 3.98 |
| 16-bit mode | all | 80.87, 80.71, 80.74 | 3.78, 3.78, 3.71 | 80.17, 79.94, 80.39 | 3.75, 3.77, 3.79 |

With masked loads, the vector encoder wins at every size in every mode measured. At one instruction a call it takes
35.4 cycles in 64-bit mode (from 77.9) and 69.5 to 70.0 in 32-bit and 16-bit modes (from 102.9 to 105.6), where the
scalar loop takes 91.5 to 93.7. From 16 instructions a call the two read the same. APX's and 32-bit addresses' entry
points have no stream in the benchmark, so they still need a gate of their own.

## APX's registers and 32-bit addresses

`benchmark-x86-encoder` had no stream for these two entry points, so the first runs couldn't gate them.
[`apx-address32/`](apx-address32/) ran a build with two streams added (C10c's `--apx` and `--address32`). Both are the
compiler mix: with registers 16 to 31 in the forms that can have them, or with 32-bit addresses. The build also has
C10b's tail by masked loads. Each entry point's scalar loop and its production loop ran alone (`--only`), in turn,
three rounds ([`apx-address32/logs.tar.gz`](apx-address32/logs.tar.gz)). Cycles per instruction:

| Stream | Calls of | Scalar loop | Vector loop |
| --- | ---: | --- | --- |
| APX's registers | 1 | 93.85, 93.60, 93.13 | 71.00, 71.91, 70.95 |
| APX's registers | 2 | 87.00, 87.21, 87.33 | 35.65, 35.73, 36.03 |
| APX's registers | 4 | 90.55, 90.70, 90.68 | 17.57, 17.52, 17.45 |
| APX's registers | 16 | 83.79, 84.35, 84.15 | 3.90, 3.75, 3.77 |
| APX's registers | 256 | 81.77, 81.72, 81.78 | 3.55, 3.46, 3.51 |
| APX's registers | all | 81.39, 81.41, 81.43 | 3.46, 3.46, 3.48 |
| 32-bit addresses | 1 | 84.74, 84.41, 84.52 | 63.43, 63.32, 61.60 |
| 32-bit addresses | 2 | 78.06, 78.07, 78.00 | 31.38, 31.53, 31.84 |
| 32-bit addresses | 4 | 82.16, 81.85, 81.99 | 15.57, 14.96, 15.64 |
| 32-bit addresses | 16 | 75.45, 75.45, 75.19 | 3.20, 3.14, 3.17 |
| 32-bit addresses | 256 | 72.73, 72.84, 72.85 | 2.94, 2.94, 2.91 |
| 32-bit addresses | all | 72.63, 73.04, 72.69 | 2.93, 2.98, 2.91 |

The vector loops win at every size: by 1.32 times at one instruction a call with APX's registers and 1.34 times with
32-bit addresses, and 23 to 25 times on whole streams.
