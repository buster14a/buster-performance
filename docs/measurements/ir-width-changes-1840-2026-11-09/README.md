# buster#1840's 9700X records: Zen 5 rows and Tier 1's vector code

The 9700X's measurement of the six register forms that buster#1840's width changes add to Tier 1:
- `vextracti32x4` of a ymm and of a zmm register, and `vextracti64x4`;
- `vinserti32x4` into a ymm and into a zmm register, and `vinserti64x4`.

Tier 1 selects them for the IR's `extract` and `insert` intrinsics.

- **Host:** benchpress (AMD Ryzen 7 9700X, clang 23.1.1).
  - The build and the measurement each took one hold of `~/buster-fast-bench/exclusive.sh`.
  - The measurement was pinned to CPU 2.
- **Working directory there:** `~/buster-fast-bench/1840-claude`.
- **Build:** buster main `cb608c1` with `familyb.patch` applied: the family's working tree when measured, whose Zen 5 rows were `U`.
  - Built `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`.
- **Script:** `zen5.sh`.
- **Command:** `measure-x86-zen5 --missing --table`. It measured the six rows without values and printed the whole rows file.

## Files

- `zen5-table.txt`: that process's standard output. It holds every fixture's per-iteration counts for the six cases, then the rows file, with the six rows filled.
- `zen5-errors.txt`: its standard error, the lock's wait message.

The six rows, as committed:

| Form | Latency (1/256 cycle) | Throughput (1/256 cycle) | Macro-ops (1/256) | Pipes |
| --- | ---: | ---: | ---: | --- |
| `VEXTRACTI32X4_XM128_Y_IMM8` | 512 | 64 | 256 | 128 |
| `VEXTRACTI32X4_XM128_Z_IMM8` | 512 | 64 | 256 | 128 |
| `VEXTRACTI64X4_YM256_Z_IMM8` | 512 | 64 | 256 | 128 |
| `VINSERTI32X4_Y_Y_XM128_IMM8` | 512 | 128 | 256 | 256 |
| `VINSERTI32X4_Z_Z_XM128_IMM8` | 512 | 128 | 256 | 256 |
| `VINSERTI64X4_Z_Z_YM256_IMM8` | 512 | 128 | 256 | 256 |

So each takes 2 cycles of latency and one macro-op. The extracts run 4 per cycle and the inserts 2.

## The permutes' rows (buster#1840, family C)

A second process measured 19 more register forms with the same method:
- **Script:** `zen5c.sh`.
- **Build:** buster main `cb608c1` with `familyc.patch`: families B and C, the permutes' rows `U`.
- **Output:** `zen5c-table.txt` (standard output) and `zen5c-errors.txt` (standard error).

The forms are those Tier 1 selects for the IR's `permute`, `shuffle`, `align` and `shuffle_lanes`:
- `vpermb` of xmm and ymm registers;
- `vpermw` of all three widths;
- `vpermd` of ymm and zmm registers;
- `vpermq` of zmm registers;
- `vpshufb` (EVEX) of all three widths;
- `valignd` and `valignq` of all three widths;
- `vshufi64x2` of ymm and zmm registers.

`vpermb`'s zmm row was already in the table.

| Form | Latency | Throughput | Macro-ops | Pipes |
| --- | ---: | ---: | ---: | --- |
| `VPERMB_X_X_XM128` | 512 | 128 | 256 | 256 |
| `VPERMB_Y_Y_YM256` | 1024 | 128 | 256 | 256 |
| `VPERMW_X_X_XM128` | 512 | 128 | 256 | 256 |
| `VPERMW_Y_Y_YM256` | 1024 | 128 | 256 | 256 |
| `VPERMW_Z_Z_ZM512` | 1280 | 128 | 256 | 256 |
| `VPERMD_Y_Y_YM256_EVEX` | 1024 | 128 | 256 | 256 |
| `VPERMD_Z_Z_ZM512` | 1280 | 128 | 256 | 256 |
| `VPERMQ_Z_Z_ZM512` | 1280 | 128 | 256 | 256 |
| `VPSHUFB_X_X_XM128_EVEX` | 512 | 128 | 256 | 256 |
| `VPSHUFB_Y_Y_YM256_EVEX` | 512 | 128 | 256 | 256 |
| `VPSHUFB_Z_Z_ZM512` | 512 | 128 | 256 | 256 |
| `VALIGND_X_X_XM128_IMM8` | 512 | 128 | 256 | 256 |
| `VALIGND_Y_Y_YM256_IMM8` | 1024 | 128 | 256 | 256 |
| `VALIGND_Z_Z_ZM512_IMM8` | 1280 | 128 | 256 | 256 |
| `VALIGNQ_X_X_XM128_IMM8` | 512 | 128 | 256 | 256 |
| `VALIGNQ_Y_Y_YM256_IMM8` | 768 | 128 | 256 | 256 |
| `VALIGNQ_Z_Z_ZM512_IMM8` | 1280 | 128 | 256 | 256 |
| `VSHUFI64X2_Y_Y_YM256_IMM8` | 768 | 128 | 256 | 256 |
| `VSHUFI64X2_Z_Z_ZM512_IMM8` | 1280 | 128 | 256 | 256 |

Latency and throughput are in 1/256 cycle, so each permute runs 2 per cycle. A 16-byte permute's latency is 2 cycles, a 32-byte one's 3 to 4, and a 64-byte one's 5, except `vpshufb`, which is 2 cycles at every width.

## The conversions' rows (buster#1840, family D)

A third process measured 88 more register forms with the same method:
- **Script:** `zen5d.sh`. It cleans the worktree before applying its patch.
- **Build:** buster main `cb608c1` with `familyd.patch`: families B, C and D, the conversions' rows `U`.
- **Output:** `zen5d-table.txt` and `zen5d-errors.txt`.

The forms are those Tier 1 selects for the IR's `extend` and `truncate`:
- `vpmovzx` and `vpmovsx` of every pair of lanes at every result width (36);
- `vpmov`, `vpmovs` and `vpmovus` of every pair at every source width (54, less `vpmovzxbw`'s and `vpmovsxbw`'s two already in the table).

The rows, as committed (latency and throughput in 1/256 cycle):

| Form | Latency | Throughput |
| --- | ---: | ---: |
| `VPMOVZXBW_X_XM64_EVEX` | 512 | 128 |
| `VPMOVZXBW_Y_XM128_EVEX` | 512 | 128 |
| `VPMOVZXBW_Z_YM256` | 1024 | 128 |
| `VPMOVZXBD_X_XM32_EVEX` | 512 | 128 |
| `VPMOVZXBD_Y_XM64_EVEX` | 512 | 128 |
| `VPMOVZXBD_Z_XM128` | 1024 | 128 |
| `VPMOVZXBQ_X_XM16_EVEX` | 512 | 128 |
| `VPMOVZXBQ_Y_XM32_EVEX` | 512 | 128 |
| `VPMOVZXBQ_Z_XM64` | 1024 | 128 |
| `VPMOVZXWD_X_XM64_EVEX` | 512 | 128 |
| `VPMOVZXWD_Y_XM128_EVEX` | 512 | 128 |
| `VPMOVZXWD_Z_YM256` | 1024 | 128 |
| `VPMOVZXWQ_X_XM32_EVEX` | 512 | 128 |
| `VPMOVZXWQ_Y_XM64_EVEX` | 512 | 128 |
| `VPMOVZXWQ_Z_XM128` | 1024 | 128 |
| `VPMOVZXDQ_X_XM64_EVEX` | 512 | 128 |
| `VPMOVZXDQ_Y_XM128_EVEX` | 512 | 128 |
| `VPMOVZXDQ_Z_YM256` | 1024 | 128 |
| `VPMOVSXBW_X_XM64_EVEX` | 512 | 128 |
| `VPMOVSXBW_Y_XM128_EVEX` | 512 | 128 |
| `VPMOVSXBW_Z_YM256` | 1024 | 128 |
| `VPMOVSXBD_X_XM32_EVEX` | 512 | 128 |
| `VPMOVSXBD_Y_XM64_EVEX` | 512 | 128 |
| `VPMOVSXBD_Z_XM128` | 1024 | 128 |
| `VPMOVSXBQ_X_XM16_EVEX` | 512 | 128 |
| `VPMOVSXBQ_Y_XM32_EVEX` | 512 | 128 |
| `VPMOVSXBQ_Z_XM64` | 1024 | 128 |
| `VPMOVSXWD_X_XM64_EVEX` | 512 | 128 |
| `VPMOVSXWD_Y_XM128_EVEX` | 512 | 128 |
| `VPMOVSXWD_Z_YM256` | 1024 | 128 |
| `VPMOVSXWQ_X_XM32_EVEX` | 512 | 128 |
| `VPMOVSXWQ_Y_XM64_EVEX` | 512 | 128 |
| `VPMOVSXWQ_Z_XM128` | 1024 | 128 |
| `VPMOVSXDQ_X_XM64_EVEX` | 512 | 128 |
| `VPMOVSXDQ_Y_XM128_EVEX` | 512 | 128 |
| `VPMOVSXDQ_Z_YM256` | 1024 | 128 |
| `VPMOVWB_XM64_X` | 512 | 128 |
| `VPMOVWB_XM128_Y` | 1024 | 128 |
| `VPMOVWB_YM256_Z` | 1024 | 128 |
| `VPMOVDB_XM32_X` | 512 | 128 |
| `VPMOVDB_XM64_Y` | 1024 | 128 |
| `VPMOVDB_XM128_Z` | 1280 | 128 |
| `VPMOVDW_XM64_X` | 512 | 128 |
| `VPMOVDW_XM128_Y` | 1024 | 128 |
| `VPMOVDW_YM256_Z` | 1024 | 128 |
| `VPMOVQB_XM16_X` | 512 | 128 |
| `VPMOVQB_XM32_Y` | 1024 | 128 |
| `VPMOVQB_XM64_Z` | 1280 | 128 |
| `VPMOVQW_XM32_X` | 512 | 128 |
| `VPMOVQW_XM64_Y` | 1024 | 128 |
| `VPMOVQW_XM128_Z` | 1280 | 128 |
| `VPMOVQD_XM64_X` | 512 | 128 |
| `VPMOVQD_XM128_Y` | 1024 | 128 |
| `VPMOVQD_YM256_Z` | 1024 | 128 |
| `VPMOVSWB_XM64_X` | 512 | 128 |
| `VPMOVSWB_XM128_Y` | 1024 | 128 |
| `VPMOVSWB_YM256_Z` | 1024 | 128 |
| `VPMOVSDB_XM32_X` | 512 | 128 |
| `VPMOVSDB_XM64_Y` | 1024 | 128 |
| `VPMOVSDB_XM128_Z` | 1280 | 128 |
| `VPMOVSDW_XM64_X` | 512 | 128 |
| `VPMOVSDW_XM128_Y` | 1024 | 128 |
| `VPMOVSDW_YM256_Z` | 1024 | 128 |
| `VPMOVSQB_XM16_X` | 512 | 128 |
| `VPMOVSQB_XM32_Y` | 1024 | 128 |
| `VPMOVSQB_XM64_Z` | 1280 | 128 |
| `VPMOVSQW_XM32_X` | 512 | 128 |
| `VPMOVSQW_XM64_Y` | 1024 | 128 |
| `VPMOVSQW_XM128_Z` | 1280 | 128 |
| `VPMOVSQD_XM64_X` | 512 | 128 |
| `VPMOVSQD_XM128_Y` | 1024 | 128 |
| `VPMOVSQD_YM256_Z` | 1024 | 128 |
| `VPMOVUSWB_XM64_X` | 512 | 128 |
| `VPMOVUSWB_XM128_Y` | 1024 | 128 |
| `VPMOVUSWB_YM256_Z` | 1024 | 128 |
| `VPMOVUSDB_XM32_X` | 512 | 128 |
| `VPMOVUSDB_XM64_Y` | 1024 | 128 |
| `VPMOVUSDB_XM128_Z` | 1280 | 128 |
| `VPMOVUSDW_XM64_X` | 512 | 128 |
| `VPMOVUSDW_XM128_Y` | 1024 | 128 |
| `VPMOVUSDW_YM256_Z` | 1024 | 128 |
| `VPMOVUSQB_XM16_X` | 512 | 128 |
| `VPMOVUSQB_XM32_Y` | 1024 | 128 |
| `VPMOVUSQB_XM64_Z` | 1280 | 128 |
| `VPMOVUSQW_XM32_X` | 512 | 128 |
| `VPMOVUSQW_XM64_Y` | 1024 | 128 |
| `VPMOVUSQW_XM128_Z` | 1280 | 128 |
| `VPMOVUSQD_XM64_X` | 512 | 128 |
| `VPMOVUSQD_XM128_Y` | 1024 | 128 |
| `VPMOVUSQD_YM256_Z` | 1024 | 128 |

## Tier 1's vector code by each family (`measure-tier1-rows`)

Families A (buster#1878, selects), B (buster#1924, width changes) and C (buster#1950, permutes, stacked on B), each against main.

- **Commits:** main `cb608c1f616f8fe26234bcaaa869caccc571de63` against each head; `inputs.txt` has the heads, the lexer's inputs' SHA-256 and the toolchain.
  - A: `ef33ec8f2e576427d2c664d50990604065c961be`
  - B: `aae6f8508ebd46208f4d0633216c5fbf54fc61b3`
  - C: `11dd0086b8152821b5745e755bbf0e5aae6eaa1b`
- **Builds:** each built `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`, one hold each (`run-b.sh`).
- **Command:** `measure-tier1-rows --march znver5 --base main` by each head's compiler, one hold per head, pinned to CPU 2 (`run-c.sh`). Its `--lexer` inputs are five of main's own sources: `c_checker.c`, `c_preprocessor.c`, `tier1_select.c`, `ir.c` and `c_parser.c`.
  - `run-b.sh`'s first attempt at this step failed, its `--directory` missing. `run-c.sh` made the directories and ran it again.
- **Output:** `rows-a.txt`, `rows-b.txt` and `rows-c.txt`. Every program's output agreed by every build; each file has every run.

Medians of 11 runs, `--tier1` of the head against `--tier1` of main:

| Program | A (selects) | B (width changes) | C (B and the permutes) |
| --- | ---: | ---: | ---: |
| machine rows' unit, user cycles | 1.000 | 0.998 | 0.998 |
| lexer's byte-class scan, user cycles | 1.001 | 1.001 | 1.000 |
| the compiler's lexer, user cycles | **1.005** | **0.984** | **0.986** |
| the compiler's lexer, instructions | 0.999 | 0.999 | 0.999 |
| `c_tokenize`, cycles per byte | 28.196 → 28.497 | 28.011 → 27.855 | 27.881 → 27.723 |

Main's own runs differ between the three processes by up to 0.6%. The comparison is within each process, where main and the head alternate.

The lexer's machine rows fall from 254 to:
- A: 223;
- B: 240;
- C: 229.

## The benchmark programs

`run-b.sh` also compiled `measure-tier1-programs`' inputs by main's `--tier1` and each head's: sqlite3.c, with speedtest1's flags, and Lua 5.4.8's 33 sources. `log-b.txt` records that every object is byte-identical with main's for every head: those programs have no x86 builtins. So the families change none of their code, and `measure-tier1-programs` was not timed for them.

## Family A's lexer, again (`run-d.sh`)

The first process put A's lexer 0.5% slower. Yet A's Tier 1 code of it differs from main's only at the selects: each was three records, `vmovdqu64`, a merge-masked `vmovdqu8` and `vmovdqa64`, and is now one `vpblendmb`. That is fewer instructions with the same 2-cycle dependency (below).

`run-d.sh` measured A twice more and B once, each one hold, as `run-c.sh` did. Output is in `rows-a2.txt`, `rows-b2.txt` and `rows-a3.txt`.

| Process | lexer user cycles, head / main | `c_tokenize` cycles/B, main → head |
| --- | ---: | --- |
| A, first (`rows-a.txt`) | 1.005 | 28.196 → 28.497 |
| A, second (`rows-a2.txt`) | 1.002 | 28.329 → 28.466 |
| A, third (`rows-a3.txt`) | 0.987 | 28.883 → 28.007 |
| B, first (`rows-b.txt`) | 0.984 | 28.011 → 27.855 |
| B, second (`rows-b2.txt`) | 0.984 | 27.727 → 27.539 |

Main's own `c_tokenize` varies from 27.7 to 28.9 cycles/B between these processes, so A's lexer is within that noise. B's 1.6% reproduces.

## Masked register moves (`zen5a.sh`)

A merge-masked `vmovdqu8`/`16`/`32`/`64` between registers might be a faster select than `vpblendm`. To test that, `zen5a.sh` measured the masked register moves on main `cb608c1` with `familya-moves.patch`. That patch is family A with the twelve rows added as `U`; the rows are not committed.

The result is in `zen5a-table.txt`. Every masked register move has `vpblendm`'s figures: latency 512, throughput 64 (1/256 cycle), one macro-op. So a masked move gives a select nothing over `vpblendm`.
