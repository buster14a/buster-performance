# #2716: a target_clones copy's AVX-512 macros and AVX2 gathers, lane by lane (2026-11-14)

This record backs [buster14a/buster#2716](https://github.com/buster14a/buster/issues/2716) and its PR, buster14a/buster#2776: `check_lower_x86_lanes`, which computes those builtins element by element where a copy lacks AVX-512F and AVX-512VL.

## Contents

- **`sweep/`**: the cases that [`target-clones-sweep-1834-2026-11-14`](../target-clones-sweep-1834-2026-11-14) refused, re-run with its `run1.sh` (clang 23 -O0, then Buster's `-c`):
  - `refused-*.txt`: the names refused at each level.
  - `now-*.txt`: main `2909b2c`, before this change.
  - `after-*.txt`: this change, a Develop build in a cloud container (Intel Xeon with AVX-512, without AVX10.2).
- **`probes/`**: the native probes, each a `target_clones("avx10.2", "default")` body built by clang -O0 and by Buster at x86-64, -v2 and -v3. The host lacks AVX10.2, so both run the default copy, and both hashes must agree:
  - `compares.c`: every compare into a mask, of every element type, width and predicate, plain and masked.
  - `lanes.c`: the rotates, funnel shifts, alignr, ternary logic, moves, inserts and extracts. The 32-byte ternary logic is in it under `-DV3`.
  - `gathers-rounds.c`: the gathers at x86-64 and -v2, with masked-off indices past every mapping; the round-scales under `-DROUND` (-v2 and -v3), the 32-byte one under `-DV3`.
- **`2716-lanes/`, `2716-lanes2/`**: the 9700X timings. Each has its script, its progress file and `ab --rounds 3` of `time-runs --runs 3 --copies 3`, for `-c main.c` at `-march=native` and `-march=x86-64`:
  - `2716-lanes/`: main `56b5864` against the first head (`d21fbec`).
  - `2716-lanes2/`: against the final head (`93e7348`), which reuses the routing's baseline row.

  Release builds without `-g`; each run held the 9700X's lock on CPU 2.

## Results

### The sweep's refused cases

| Level | Refused on main | Compiling with this change | Of those compiling before, still compiling |
| --- | ---: | ---: | ---: |
| x86-64 | 150 | 150 | 79 of 79 |
| -v2 | 152 | 152 | 100 of 100 |
| -v3 | 149 (`_mm_cvtss_sh` compiled already) | 150 | 124 of 124 |

The probes give clang's hashes at every level, through Tier 0 and through Tier 1. Swapping one predicate (NLT computed as LE) changes the compare probe's hash.

### Clang's backend failures, which stay refused by name

| Builtin | Where clang fails | Clang's error |
| --- | --- | --- |
| `pternlog{d,q}256` | x86-64 and -v2 (AVX is enough) | "Do not know how to split the result of this operator" |
| `pternlog{d,q}512` | every level | "Do not know how to split the result of this operator" |
| `rndscaleps_256_mask` | below AVX | "Do not know how to split the result of this operator" |
| `rndscaleps_256_mask`, `rndscaless`/`rndscalesd_round_mask` with a mask that isn't a constant | every level | "Cannot select" a `vselect`, or a `v1i1` load |
| `rndscaless`/`rndscalesd_round_mask` | x86-64 | "Cannot select" `X86ISD::VRNDSCALES` |
| `gather{d,q}_*256` | below AVX2 | "Do not know how to split the result of this operator" |

Two of clang's own results are worth knowing:

- Its legalized `rndscalesd` at -v2 is `roundsd $imm`, with the whole immediate, so the scale bits are ignored.
- Its default copy at x86-64 emits AVX2's `vpgatherdq` for a gather.

### Compile time (`-c main.c`, final head)

| Target | Instructions, main → head (mean of 9) | User cycles against main | Main against itself |
| --- | --- | --- | --- |
| `-march=native` | 10,701,242,417 → 10,701,242,909 | −0.28%, −0.39%, −0.11% | −0.21%, −0.16%, −0.16% |
| `-march=x86-64` | 11,048,116,452 → 11,051,098,457 (+0.027%) | +0.14%, −0.46%, −0.05% | +0.13%, −0.31%, +0.01% |

The first head cost +7.5 M instructions at x86-64, because the routing computed `check_vector_baseline_row` and then `check_lower_operation_index` computed it again; the final head reuses the routing's row. The remaining +3.0 M is the entry room's name filter over each x86 builtin call (`check_x86_lanes_room`), which runs only at a target without AVX-512F/VL.
