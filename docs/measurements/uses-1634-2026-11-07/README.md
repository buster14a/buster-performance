# Use-list builder twins (#1634), 2026-11-07

Measurement record for [buster14a/buster#1634](https://github.com/buster14a/buster/issues/1634)
and its changes [#1638](https://github.com/buster14a/buster/pull/1638) and
[#1643](https://github.com/buster14a/buster/pull/1643), both merged.

`ir_uses_validated` used to decode every operand twice through `ir_operand`. Its vector twin
(`ir_uses_batch`) now takes 16 instructions' operand masks from the opcode tables by byte permute
and spreads them with `pdep` into one 48-bit mask in `ir_operand`'s order. The count and fill
loops walk that mask with `tzcnt` and read each operand from its column. The old builder stays as
the exact scalar twin.

## Trees and host

- `main`: buster `687f44c3`, before #1638.
- `cand`: `687f44c3` with `git diff 687f44c3 26600a3d -- src` applied. That is #1638's code with
  #1643's change to the batch loop, the code main has since `b70a2d73`.
- Host: Ryzen 7 9700X (benchpress), Clang 23.1.1, `./build.sh` Release, host `native`,
  `BUSTER_DEBUG_INFO=0` (`build-main.log`, `build-cand.log`).
- Every process took `~/buster-fast-bench/exclusive.sh` for itself, pinned to CPU 2. `ab --lock`
  takes the lock per run.
- Placements: `./build.sh shifts` moves `main_unit_backend.c`'s code 256 and 1024 bytes later
  (`shifts-*.log`).
- Inputs: the frozen corpus `preprocessor-391e729af658`.

## Sizing at main (`scripts/measure.sh`)

`benchmark-ir.log`, ns per instruction:

| Path | 32 instructions | 262,144 instructions |
| --- | ---: | ---: |
| `uses` (`ir_build_uses`: vector verification plus building) | 6.53 | 7.61 |
| `vector` (the whole vector verifier) | 1.78 | 1.26 |
| `cfg` | 1.45 | 1.08 |

Profiles:
- In `-c --tier1 --lanes 1` of `sqlite3.c`, `ir_uses_validated` took 1.17% of the cycles
  (`perf-tier1.report`, `perf-tier1.children`).
- In `benchmark-ir-source --only optimize`, see `perf-optimize.report`.

## The first version, dropped

#1638's first head (`39992214`) interleaved the columns with permutes, compressed the operands
into a stack buffer and walked that. Round 1 of `ab` at three placements (`ir-compress.log`,
before that run was stopped) put its `uses` path, against main's 6.62–6.91 and 7.70–7.73 ns:
- at 32 instructions: 7.81–7.88 ns per instruction, 14% to 19% slower;
- at 262,144 instructions: 5.92–6.08 ns, 21% to 23% faster.

Each batch's overlapping 64-byte stores, read back four bytes at a time, cost more than a small
function saves. #1638 merged at that head; #1643 replaced it with the mask walk measured below.

## A/B (`scripts/uses-ab.sh`, `scripts/uses-chain2.sh`)

`benchmark-ir`: `ab --rounds 3 --cpu 2` over both trees at three placements (`ir.log`). Each cell
is the median of three rounds, main → cand, in ns per instruction:

| Size | Path | Placement 0 | Placement 256 | Placement 1024 |
| --- | --- | ---: | ---: | ---: |
| 32 | `uses` | 6.710 → 5.530 (−17.6%) | 6.564 → 5.585 (−14.9%) | 6.569 → 5.577 (−15.1%) |
| 32 | `vector` (control) | 1.864 → 1.782 (−4.4%) | 1.773 → 1.818 (+2.5%) | 1.777 → 1.824 (+2.6%) |
| 32 | `cfg` (control) | 1.485 → 1.469 (−1.1%) | 1.452 → 1.499 (+3.2%) | 1.450 → 1.469 (+1.3%) |
| 32 | `scalar` (control) | 9.136 → 9.273 (+1.5%) | 9.152 → 9.160 (+0.1%) | 9.081 → 9.472 (+4.3%) |
| 262,144 | `uses` | 7.603 → 7.186 (−5.5%) | 7.713 → 7.100 (−7.9%) | 7.723 → 7.094 (−8.1%) |
| 262,144 | `vector` (control) | 1.270 → 1.261 (−0.7%) | 1.262 → 1.280 (+1.4%) | 1.266 → 1.266 (+0.0%) |
| 262,144 | `cfg` (control) | 1.075 → 1.063 (−1.1%) | 1.078 → 1.086 (+0.7%) | 1.078 → 1.067 (−1.0%) |
| 262,144 | `scalar` (control) | 8.141 → 8.156 (+0.2%) | 8.150 → 8.181 (+0.4%) | 8.270 → 8.207 (−0.8%) |

The 262,144-instruction function gains less than the small one. That function uses value 0 as
the second operand of three quarters of its instructions, so incrementing that value's count and
cursor is one serial chain in both twins. The first version's 5.92–6.08 ns there came from the
same staging that cost small functions 14% to 19%.

`benchmark-ir-source` on the frozen `sqlite3.c`, with every variant per process: `ab --rounds 3`
over both trees (`source.log`). Medians of the three rounds, in ns per typed entry:

| Variant | main | cand | Change |
| --- | ---: | ---: | ---: |
| `gvn` | 129.99 | 118.87 | −8.6% |
| `optimize` | 123.31 | 114.67 | −7.0% |
| `optimize-vector` | 133.68 | 125.06 | −6.4% |
| `gvn-scalar` (scalar twin) | 137.44 | 136.80 | −0.5% |
| `optimize-scalar` (scalar twin) | 140.02 | 140.05 | +0.0% |
| `lower`, `promote`, `verify` and their twins (controls) | | | −0.3% to +0.5% |

Each tree's three rounds agree within 0.5%. The optimizer's scalar paths build use lists with the
scalar twin, which is unchanged.

`-c --tier1` of the frozen `sqlite3.c`: `ab --rounds 3` of `time-runs --runs 5`, then one compile
per tree for the object comparison (`tier1.log`). Medians of the rounds' medians:

| | main | cand | Change |
| --- | ---: | ---: | ---: |
| Wall time | 388.40 ms | 386.40 ms | −0.51% |
| User cycles | 2,051,291,589 | 2,038,714,822 | −0.61% |
| Instructions | 4,931,469,479 | 4,898,770,846 | −0.66% |

The objects are byte-identical. The compile's saving is about half of the 1.17% that
`ir_uses_validated` took.

## Limitations

- The source and Tier 1 steps ran at the default placement only.
- The profiles are single processes of main.
- No `-c` throughput beyond this one file is claimed.

## Provenance

These are original measurements of original Buster code. The frozen corpus is an external
runtime input; nothing from it is incorporated here besides command lines and counts.
