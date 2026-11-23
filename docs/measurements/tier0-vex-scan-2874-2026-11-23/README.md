# Tier 0's row on the calls memo's branch, and the VEX scan without gathers (buster#2874), 2026-11-23

[buster#2874](https://github.com/buster14a/buster/issues/2874), on the branch of
[buster#3403](https://github.com/buster14a/buster/pull/3403) (the calls' memo, piece 3), which is main `e5c975f1` with
the memo. Two things here:

1. **The row log of that branch**, by Tier 0's passes, cold and warm, and a profile of it by pass with libc's samples
   charged to their callers.
2. **Piece 3b: the VEX rewrite's scan without gathers.** #3388 (#3335) added `tier0_vex`, which rewrites a function's
   legacy SSE records as their VEX twins at a target with AVX. It found them with `x86_vex_lookup`: a gather of 16
   records' forms (16 bytes apart), then a gather of their entries from the 8,359-entry table, two gathers every 16
   records, for every record of every function. `x86_vex_find` reads 32 records' forms four records a load, puts them
   together with `vpermt2w`, and takes their entries from the table's 192 rows from `movss`'s (rows 1,069 to 1,260,
   which hold every legacy form with a twin) in six registers, with `vpermt2w` again.

## Setup

- **Revisions:** `bin/branch` is buster#3403's head `9a6de893`; `bin/rowlogmemo` is it with the row log
  (`scripts/rowlog.patch`, the experiment patch of [the row's record](../tier0-row-main-2874-2026-11-23/));
  `bin/vex` is it with the scan's first form and `bin/vex2` with its final form (`scripts/vex-scan.patch`, the pull
  request's commit `c4cec46e`).
- **Builds:** Release, `BUSTER_HOST_ARCH=znver5`, in a cloud container with CI's staged toolchain (LLVM 23.1.4), copied
  to the 9700X stripped (`binaries.sha256`).
- **Runs:** the 9700X, CPU 2, under the lock, one hold a set: `-c sqlite3.c` with the row's record's flags and corpus.

## 1. The row log of the memo's branch (`results/tables-memo.txt`)

Five runs (`results/rowlog-memo`), and five with each body compiled once first (`results/rowlog-memo-warm`), medians a
body; cycles = TSC ticks x 5.45 / 3.7928; each part fitted as a + b x entries over the 2,602 bodies.

| Tier 0's pass | cycles an entry, cold | warm | a: a body | b: an entry | the row's record (`9d927943`) |
| --- | ---: | ---: | ---: | ---: | ---: |
| room | 2.92 | 1.39 | 251 | 1.02 | 2.79 |
| labels | 1.48 | 0.97 | 66 | 1.02 | 1.48 |
| values (P0) | 2.01 | 1.91 | 25 | 1.83 | 2.05 |
| fusion (P1 to P3) | 6.88 | 5.16 | 301 | 4.76 | 6.89 |
| depths (P4) | 1.48 | 1.29 | 91 | 0.84 | 1.49 |
| selection | 10.40 | 6.77 | -109 | 11.14 | 10.50 |
| homes and frame | 6.56 | 4.14 | 616 | 2.21 | 6.52 |
| measuring and the output's room | 12.98 | 8.94 | -143 | 13.96 | 12.36 |
| emission | 17.41 | 12.62 | -372 | 19.99 | 21.14 |
| forms | 3.33 | 2.94 | 159 | 2.20 | 3.33 |
| the rest of `tier0_generate`, labels, tails | 0.71 | 0.71 | | | 0.73 |
| after the passes: `tier0_vex`, `emitted_from_tier0` | 3.80 | 3.36 | 199 | 2.40 | 0.70 |
| **Tier 0** | **71.41** | **51.65** | 1,370 | 61.47 | **71.44** |

- **The memo moved emission's 3.7 cycles an entry**, the calls' emitter (21.14 to 17.41), and measuring took 0.6 more:
  the table's lookup where `tier0_count_call` was.
- **The lap after the passes took 3.1 more** (0.70 to 3.80), most of it #3388's `tier0_vex`, which main `9d927943`
  didn't have. So Tier 0 on the branch is where `9d927943`'s was, 71.4 cycles an entry. Part 2's A/B puts the scan's
  gathers at about two thirds of the 3.1 (0.15 ms, 2.1 cycles an entry); the rest of the lap's rise is not placed here.

The profile (`results/profb-branch/passes.txt`; 16 runs, `cycles:u` every 100,003, branch stacks, libc's samples charged
to their callers by `tools/brips` of [the calls memo's record](../tier0-calls-memo-2874-2026-11-23/)) has Tier 0's
samples by pass. Of its 3,244 samples outside validation: emission 830 (its vector loop 620, the memo's writes 76),
the front 671 (fusion 296, values 106, the calls' raw effects 104, depths 98, labels 67), measuring 513 (its loop 304,
the memo's lookups 149), selection 385, the homes and the frame 342, the setup 210, the forms 167, `tier0_vex` 82.

## 2. The VEX scan without gathers

### The A/B (`results/ab-vex2`, medians of 11 in turn, ms)

| stage | the memo's branch (`bin/branch`) | the scan (`bin/vex2`) | change |
| --- | ---: | ---: | ---: |
| `tier0` | 4.779 | 4.633 | -0.146 |
| `emit-setup` | 1.044 | 1.043 | -0.001 |
| `branch-sizing` | 0.413 | 0.419 | +0.006 |
| `encode` | 0.338 | 0.336 | -0.002 |
| `unwind` | 0.216 | 0.217 | +0.001 |
| `code-atoms` | 0.311 | 0.311 | 0.000 |
| `publish-data` | 0.503 | 0.498 | -0.005 |
| `object-build` | 0.402 | 0.401 | -0.001 |
| `object-write` | 0.153 | 0.151 | -0.002 |
| the compile | 115.357 | 115.368 | +0.011 |

The scan's `tier0`, round by round: 4.803 4.633 4.615 4.788 4.610 4.661 4.632 4.662 4.609 4.651 4.630; the branch's
4.744 to 4.810. Both objects hash `f4149786…3f3e` (`results/ab-vex2/objects.sha256`). The compile's total moves with the
front's stages, which the change doesn't touch.

### The first form (`results/ab-vex`, medians of 9, ms)

The same scan with two more mask operations, an SS override's compare and the live records' mask, both found redundant
by the fault round below: `tier0` 4.761 to 4.659 (-0.102), every other stage within 0.02, both objects hashing
`f4149786…3f3e`. Its first two rounds (4.914, 4.874) ran with the new executable's pages cold.

### Profile of the first form (`results/profb-vex/passes.txt`)

`tier0_vex` 21 samples where it took 82 (`x86_vex_find` 14 of them), about 0.13 M cycles left.

### What the scan converts

On `sqlite3.c`, the object has 1,028 VEX forms of the legacy ones (372 `vmovups`, 260 `vmovsd`, 80 `vxorps`, 78
`vmovq`, ...) among its 319,277 lines of disassembly: the scan reads every record to find about one in 290.

### Exactness and tests

- **Objects** (`scripts/exact.sh`, `scripts/exact-avx.sh`; `results/exact-totals.txt`), the pull request's head
  against the scan, both built `native` in the cloud container: 2,928 compiles the same (1,925 built) of `sqlite3.c`
  with and without `-g`, Lua 5.4.8, musl's 1,337 units, `main.c` and `tests/**/*.c`; and 4,446 the same (2,452 built)
  of musl's units at `-march=x86-64-v3` and `tests/**/*.c` at `x86-64-v3` and `znver5`, the targets with AVX, where
  the scan runs.
- **`test-tier0 --cross-check`:** 21,675,530 checks, 0 failed. Its "VEX window" check compares `x86_vex_find` with both
  forward tables for every value of a record's form (each row, with each segment override, with the fixup flag or
  not), at every count to 32, and with the block at the end of a page before a `PROT_NONE` one.
- **`test-tier1-emit`:** 487,451 checks, 0 failures (`tier1_emit_vex` takes the scan too).
- **The fault round** (`scripts/vex-mutants.py`, `scripts/vex-harness.c`, `results/vex-mutants.txt`): 14 mutants of
  the final form; 12 fail the check or fault on the guard page, `none` passes, and `rows 191` is equivalent (the
  window's last rows hold no entry). On the first form, two survivors showed its SS compare and its live mask
  redundant (they are gone), and two more needed the guard page, which the check now has.

## Files

- `scripts/`: `rowlog.patch`, `rowlog.sh`, `rowtables.py` (the row log); `profile-b.sh`, `profile-b-post.sh`,
  `passes.py` (the profiles by pass); `ab.sh`, `abtable.sh` (the A/B); `exact.sh`, `exact-avx.sh` (the objects
  compared); `vex-scan.patch`; `vex-mutants.py` and `vex-harness.c` (the fault round).
- `results/`: the row logs and their tables; the profiles' samples charged to their callers (`samples.ips.zst`, one
  address a line) and their tables by pass (`passes.txt`); the A/Bs' stage clocks; the objects' comparisons; the
  fault round.
