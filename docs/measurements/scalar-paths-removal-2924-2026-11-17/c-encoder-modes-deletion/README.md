# C10b and C10c: the encoder's tail by masked loads, and the other entry points' twins deleted (#2924)

These follow C10 ([`../c-encoder-deletion/`](../c-encoder-deletion/), #3015), which deleted the 64-bit twins. The gates
are in [`../c-encoder-gate/`](../c-encoder-gate/): "The encoder's last partial group by masked loads" for 32-bit and
16-bit modes, and "APX's registers and 32-bit addresses" for the other two entry points.

Commits:
- **C10b `b78c563dd`:** the encoder loads a last partial group by masked loads, with its forms from the loaded records.
  It took a zeroed copy before.
- **C10b `50fe4dc83`:** `x86_encode_scalar_32` and `x86_encode_scalar_16` deleted.
- **C10c `b753df27d`:** `benchmark-x86-encoder`'s `--apx` and `--address32` streams.
- **C10c `c98e08a5a`:** `x86_encode_scalar_apx`, `x86_encode_scalar_address32` and `encode_scalar` deleted.

## C10b on the 9700X

[`run.sh`](run.sh) ran base `48e3ad96a` (C10's head) against head `50fe4dc83`: Release, every run under the lock, timings
on CPU 2 ([`logs.tar.gz`](logs.tar.gz)).

**Objects:** `-c` (Tier 0) and `-c --tier1` of sqlite3.c, Lua 5.4.8, musl's units and buster's `main.c`. 1,372 of
1,372 objects are byte-identical in each mode.

**Whole compiles:** `ab`, three rounds, around `time-runs` of base, head and base again; `--lanes 1`. User cycles against
base:

| Compile | Head | Base again | Instructions, head against base |
| --- | --- | --- | --- |
| sqlite3.c, `-c` | −0.37%, +0.12%, −0.02% | −0.24%, +0.15%, +0.13% | 0.065 M fewer |
| Lua's units, `-c` | −0.12%, −0.37%, +0.18% | −0.21%, −0.27%, −0.02% | 0.025 M fewer |
| sqlite3.c, `-c --tier1` | −0.15%, −0.18%, −0.24% | +0.02%, −0.02%, −0.01% | 0.034 M fewer |
| Lua's units, `-c --tier1` | −0.20%, −0.02%, −0.35% | +0.04%, +0.17%, −0.02% | 0.014 M fewer |

Head retires fewer instructions in every list. By `--tier1` it reads 0.02 to 0.35 points fewer cycles in every round,
where base again stays within 0.17.

**`benchmark-x86-encoder`**, each mode's production loop alone, base and head in turn, three rounds. Cycles per
instruction:

| Stream | Calls of | Base | Head |
| --- | ---: | --- | --- |
| 64-bit mix | 1 | 77.92, 77.91, 77.93 | 36.60, 35.30, 35.79 |
| 64-bit mix | 2 | 38.96, 38.98, 39.00 | 18.02, 17.78, 18.05 |
| 64-bit mix | 4 | 10.18, 10.28, 10.16 | 8.41, 8.41, 8.43 |
| 64-bit mix | all | 3.11, 3.09, 3.08 | 3.11, 3.07, 2.99 |
| Vector mix | 1 | 77.99, 77.99, 77.99 | 35.48, 36.83, 35.38 |
| Vector mix | 2 | 39.04, 39.07, 39.03 | 18.20, 18.05, 18.72 |
| Vector mix | 4 | 10.17, 10.20, 10.20 | 8.36, 8.48, 8.35 |
| Vector mix | all | 2.96, 3.15, 3.09 | 3.06, 3.09, 3.07 |
| 32-bit mode | 1 | 103.51, 103.32, 104.22 | 69.81, 69.61, 69.78 |
| 32-bit mode | 2 | 51.77, 51.93, 52.43 | 35.17, 34.80, 34.69 |
| 32-bit mode | 4 | 17.52, 17.28, 17.31 | 17.30, 17.06, 17.49 |
| 32-bit mode | all | 3.76, 3.73, 3.72 | 3.71, 3.70, 3.84 |
| 16-bit mode | 1 | 102.88, 103.39, 104.20 | 69.73, 70.14, 74.21 |
| 16-bit mode | 2 | 51.84, 51.84, 51.68 | 34.85, 34.95, 35.00 |
| 16-bit mode | 4 | 17.39, 17.27, 17.53 | 17.22, 17.23, 17.29 |
| 16-bit mode | all | 3.80, 3.78, 3.77 | 3.74, 3.71, 3.68 |

**Tests:** on head, the encoder's and its callers' tests, the complete driver's checks of `main.c`, the call graph's
checks and the ownership check all pass ([`logs.tar.gz`](logs.tar.gz), `status.txt`).

**MSan and ASan** on head ([`sanitizers.sh`](sanitizers.sh), [`sanitizers.log`](sanitizers.log)), all clean:
- `test-x86-encoder` in every mode, and `--mode32` and `--mode16` alone;
- the tests of the encoder's callers;
- `-c` and `-c --tier1` of c-testsuite's first 30 programs.

## C10c

C10c leaves the compile's code as C10b's: it changes the benchmark and the encoder's test, and deletes code nothing but
the test ran. The gate, the encoder test's digests (the recorded values, in every mode), the ownership check and the
benchmark's own check of every implementation against the scalar loop, in every mode, ran on its head.

## Mutants

[`mutation/`](mutation/) holds the mutants and their results. Each is a build of `test-x86-encoder` alone
([`enc_main.c`](mutation/enc_main.c), at -O1), which must fail. All 12 are killed:
- **The masked-load tail** ([`c10b.results`](mutation/c10b.results)): the last record, a quad's mask, a partial quad
  loaded whole, the forms read from the records past the last (64-bit's tail and the others'), and the count passed.
- **32-bit and 16-bit modes** ([`c10b-legacy.results`](mutation/c10b-legacy.results)): 16-bit mode's presence bits, and
  a 16-bit address's displacement size.
- **APX and 32-bit addresses** ([`c10c.results`](mutation/c10c.results)): a 32-bit address's 67 and its length, and
  REX2's presence bits and its length.
