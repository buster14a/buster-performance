# Tier 1 asm bodies against Tier 1's helpers — #1839, 2026-11-11

For [buster#1839](https://github.com/buster14a/buster/issues/1839), item 11:
[buster#1944](https://github.com/buster14a/buster/pull/1944) placed asm statements
in their callers under `--tier1` (Tier 1 asm bodies, `TIER1_RULE_ASM`), and they
had no measurement on the 9700X yet. This record compares the hot loops of the
same six asm statements as
[asm-bodies-1839-2026-11-09](../asm-bodies-1839-2026-11-09/README.md) across three
builds by one compiler binary:

- `t1`: `--tier1`, the statements Tier 1 asm bodies;
- `t1h`: `--tier1 --helper-forms=asm`, the statements calls of their helpers;
- `t0`: the default Tier 0 compile, the statements Tier 0 asm bodies (for reference).

## Run

- Binary: buster main `457c5893` (`457c589`), built in the session's container by
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh` (Release, Ubuntu clang
  23.1.6); sha256 in `9700x/sha256.txt`
  (`f1f2fa81a37a18d96fe66d217dde4dfde998e36130d0eab2c2ef35ca84b6f5b0`).
- Kernels: `9700x/kernels.c`, byte-identical to the 2026-11-09 record's (sha256
  `043774e1dbc4d5c2438434e370d8b9ae54cb3ab1f0f80131dfd01c089d5deb5c`).
- `benchpress` (Ryzen 7 9700X), 2026-11-11 12:3x UTC, one hold of the shared host
  lock (`~/buster-fast-bench/exclusive.sh ./run.sh`), each process pinned with
  `taskset -c 2`, wall time from `date +%s%N`, 7 rounds, each running the three
  builds of a kernel in turn (`9700x/run.sh`, `9700x/run.log`, `9700x/kernels.tsv`).
- Every build's output matched clang -O0's build before timing. All 8 functions
  were Tier 1's in both `--tier1` builds, with no fallback
  (`9700x/report-t1.txt`, `9700x/report-t1h.txt`).
- `perf stat -e cycles,instructions,ls_bad_status2.stli_other` of the shift, flag
  and mulq kernels by `t1` and `t1h` (in `run.log`).

## Results

Medians in milliseconds (min and max in `kernels.tsv`).

| Kernel | Tier 1 bodies | Tier 1 helpers | Tier 0 bodies |
|---|---:|---:|---:|
| rdtsc | 137.96 | 138.07 | 138.01 |
| cpuid | 51.20 | 51.00 | 51.52 |
| flag output | 73.14 | 73.46 | 62.91 |
| `"c"` shift | **77.56** | 79.58 | 63.99 |
| x87 fsqrt | 293.15 | 293.48 | 293.20 |
| mulq | **91.13** | 88.41 | 77.15 |

| Kernel, 100M iterations | t1 cycles | t1h cycles | t1 instructions | t1h instructions |
|---|---:|---:|---:|---:|
| shift | 425.9M | 434.0M | 2,500.8M | 2,900.8M |
| flag output | 401.2M | 400.8M | 2,000.8M | 2,700.8M |
| mulq | 500.8M | 482.7M | 2,800.8M | 3,000.8M |

- Text: 1,776 bytes and 2 `call`s in the kernels (`t1`), against 1,920 bytes and
  7 calls (`t1h`) and Tier 0's 2,032 bytes and 2 calls (`9700x/sizes.txt`).
- **Tier 1 bodies are level with Tier 1's helpers**: the shift kernel −2.5%, the
  flag kernel −0.4%, mulq +3.1%, the others within noise. They retire 7–26% fewer
  instructions, but the cycles stay where the helpers' are.
- **Both trail Tier 0's bodies** by 14–18% on the shift, flag and mulq kernels.
  The interlock failures (`ls_bad_status2.stli_other`) stay low (1.5–18 thousand
  in 100M iterations), so this isn't #1866's store-to-load failure. It is the
  memory round trips of Tier 1's body call. Tier 1's `k_mul` loop (`--tier1 -c`):
  1. stores both output addresses and both inputs into the operand block, then loads the inputs back;
  2. saves the four values live in registers the body touches (rax, rcx, rdx, rsi) into their call-save rows, and reloads them after;
  3. stores the outputs through their addresses into frame objects, which the loop then loads again.

  Tier 0's bodies take register operands as the call row's arguments, in their
  registers (`CheckProgramAsm.inline_passed`, which a lowering for Tier 1 turns
  off).

## Limitations

- One binary, one host, 7 rounds; medians differ from the 2026-11-09 record's by
  under 1% where the code is the same (Tier 0's rdtsc, cpuid, x87).
- Microkernels of one statement each: they measure the statement's own cost in a
  loop, not a program's.
- The compile-time effect of Tier 1 bodies (`--tier1 -c`) isn't measured here.
