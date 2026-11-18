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
