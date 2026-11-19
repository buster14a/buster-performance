# Tier 1 wide-vector split scratch

Buster issue #3043 covers the compiler's temporary map from source instructions to split values. The base is `6427879e1143026a12fb0388a20bdea1fe4b2bc5` and the candidate is `5b855db18a58979a2401234a68d3816a6fdaf73f`. The candidate stores one 32-bit output ID per source row. Piece zero is that ID. Each subsequent piece advances by one instruction for a constant, undef, copy or phi and by two for a load, which emits an address before each later piece. A store only exposes its first instruction as its own ID. The counting pass fills the map before the writing pass reads operands, including forward phi inputs. There is no auxiliary index. [Compiler issue](https://github.com/buster14a/buster/issues/3043)

## Split allocation

The one-block inputs contain two parameters, one 64-byte load among N scalar copies, a store of the vector, and a scalar return. Each dense control keeps the same source row count and replaces the N+1 middle definitions with alternating 64-byte loads and copies. Every input and output was verified. Each source instruction has a distinct debug origin.

Peak bytes below are measured above the scratch arena's entry mark. The stress harness starts each split in a fresh arena with 13 bytes used. Both maps align to 64, so each measurement includes 51 bytes of padding. The result is the same separately at each emitted width. Repetitions are unnecessary for an exact allocation count.

| N | Source rows | Sparse, 16 B or 32 B target, base → head | Dense, 16 B or 32 B target, base → head | Bytes saved in each case |
|---:|---:|---:|---:|---:|
| 1,024 | 1,029 | 16,515 → 4,167 | 16,515 → 4,167 | 12,348 |
| 16,384 | 16,389 | 262,275 → 65,607 | 262,275 → 65,607 | 196,668 |
| 65,536 | 65,541 | 1,048,707 → 262,215 | 1,048,707 → 262,215 | 786,492 |

For the 64K case, the output and scratch allocations coexist at the end of the split. The table counts all bytes charged to both arenas above their respective entry marks, including debug data and alignment. Process RSS and earlier pipeline stages are outside this measurement.

| Shape | Emitted width | Output rows | Output bytes on each revision | Peak scratch + output, base → head |
|---|---:|---:|---:|---:|
| Sparse | 16 B | 65,553 | 1,311,856 | 2,360,563 → 1,574,071 |
| Sparse | 32 B | 65,545 | 1,311,568 | 2,360,275 → 1,573,783 |
| Dense | 16 B | 360,465 | 8,782,960 | 9,831,667 → 9,045,175 |
| Dense | 32 B | 163,849 | 3,801,936 | 4,850,643 → 4,064,151 |

On every shape and width, a retry with scratch capacity one byte below its observed peak returned `IR_ERROR_MEMORY`. So did a separate retry with the output arena one byte short. Both restored the nonzero arena marks and cleared the split result.

## Normal C compilation

The ordinary `-c --tier1 --tier1-strict --verify --lanes 1` path reached the split after SSA promotion. One input contains Buster's production lexer functions `bit_511` and `bit_0_if`, extracted verbatim with their vector type and macros and called through two external pointer wrappers. The other is the existing seven-function wide-vector C fixture from `c_check_tier1_driver_test.c`. Each was compiled for x86-64, x86-64-v2 and x86-64-v3 with and without `-g`.

| C input | Debug info | Peak split scratch at x86-64 and v2, base → head | Peak split scratch at v3, base → head |
|---|---|---:|---:|
| Lexer bit functions | Off | 2,759 → 719 B | 2,695 → 703 B |
| Lexer bit functions | On | 2,720 → 680 B | 2,656 → 664 B |
| Wide-vector driver fixture | Off | 3,560 → 908 B | 3,560 → 908 B |
| Wide-vector driver fixture | On | 3,536 → 884 B | 3,536 → 884 B |

The Release host compiler used the explicit AVX-512 `vector` target and pinned Clang 23.1.4 on a GitHub-hosted AMD EPYC 9V45. Only the generated target changed. Clean base, instrumented base, instrumented head and clean head each produced the same 12 whole object files. Every generated object linked to a Clang -O2 caller and matched its Clang -O0 oracle over 200 rounds. The 13 base/head captures compared equal with `cmp`. They contain verified printed split IR, instruction columns, original and appended extra slices, vector constants, and the represented debug origins, bindings and regions. The suite capture includes the stress cases and the existing mixed-width and forward-phi fixtures.

The uninstrumented `test-tier1-wide` passed on both revisions with 34,247 checks, zero failures, five wide-vector fixtures at both widths, 160 wide-vector native runs at the 16-byte width, and four wide-vector refusals. An additional unmodified base run established the suite baseline. The measured improvement is compiler scratch. Timing and Zen 5 throughput were outside this experiment. [Comparison job](https://github.com/buster14a/buster-performance/actions/runs/44602704096/job/135838348800) · [Baseline job](https://github.com/buster14a/buster-performance/actions/runs/44601256620/job/135833511642)

## Reproduction

Use a fresh disposable Buster checkout at the base SHA and a Linux x86-64 hosted machine that passes Buster's vector probe. In the commands below, `evidence` names this directory in a separate checkout of buster-performance. The harness swaps the two source files within the disposable checkout and builds both revisions with the same tools and flags.

```sh
evidence=/absolute/path/to/buster-performance/docs/measurements/tier1-vector-split-3043
git clone --no-checkout https://github.com/buster14a/buster.git buster-3043
cd buster-3043
git checkout --detach 6427879e1143026a12fb0388a20bdea1fe4b2bc5
bash "$evidence/run.sh" "$evidence"
```

`capture.inc` observes each successful split before it restores its scratch mark. There is one scratch allocation in each implementation, so the reading includes the entire split scratch allocation. The IR printer uses a separate observer arena. `stress.inc` also reads the fresh arena's recorded high-water mark. Both inserts are temporary. The clean builds run the unmodified suite, and only the measurement builds run the extra cases. `hosted.txt` preserves the per-call counts and the object and IR SHA-256 digests from the comparison job.
