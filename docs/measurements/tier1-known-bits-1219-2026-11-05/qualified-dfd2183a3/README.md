# Known upper bits: #1219 acceptance at dfd2183a3

All four manual instruction-count gates pass for
[buster#1419](https://github.com/buster14a/buster/pull/1419), source
`dfd2183a3bbe96f8a99d39b1c36036aeb500ac08`. Locked 9700X runtime and compiler
cost measurements are complete. **Hosted checks and ordinary native workflow
qualification are still pending; this record does not assert integration.**

The [initial record](../README.md) and [b8 milestone](../progress-b8d721e26/README.md)
retain their original sources and raw evidence. Their failed extension gates
are historical results, not results for this head.

## Sources, inputs and method

| Role | Exact source |
| --- | --- |
| Candidate | buster `dfd2183a3bbe96f8a99d39b1c36036aeb500ac08` |
| Main control, included by candidate | buster `1bfc57eedf9c2fc3deb5a71a22b7c2a4f01ee29f` |
| Existing corpus harness, classifier and five Lua scripts | buster-performance `b749a517de5bd31b2c85c4035ff838157f4244cc` |

The control includes the independently merged #1218 / #1301 branch-truth work.
Inputs, flags, compiler tools and commands are the frozen ones in the parent
record and `scripts/`. SQLite amalgamation SHA-256 is
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`;
speedtest source is pinned at `ccc132c5be20ab5c755c97a08d06b1b592fef330`;
Lua is 5.4.8. No classifier was changed.

Every build, native test, corpus execution and timing used `benchpress`, the
real Ryzen 7 9700X, under `exclusive.sh`, owner `codex-1219`, per run.
Builds use `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`, eight jobs; counts and
timings use CPU 2. SQLite runs in a fresh `/dev/shm` directory with
`--shrink-memory --reprepare --stats --journal wal --size 5 --heap 40000000 64
--testset mix1`. Its verification hash matches the control:
`1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`.
Counted Lua outputs match the frozen control, and runtime outputs match Clang.

`identity/` records source-archive, fourteen changed-source-member, compiler and
program hashes. The archive's Git pax comment and all fourteen members match
the candidate Git objects. Local analysis verified all three executable hashes
against the remote receipts. No executable is distributed here.

## Exact program-code counts

| Dynamic count | Main control | Candidate | Clang -O2 |
| --- | ---: | ---: | ---: |
| SQLite extensions | 197,716,127 | **64,832,259** | 33,084,180 |
| Lua five scripts, extensions | 281,768,905 | **45,534,436** | 37,907,635 |
| SQLite all self-moves | 29,201,811 | 345,916 | 962,217 |
| Lua five scripts, all self-moves | 69,102,719 | 610,084 | 2,379,571 |
| SQLite program instructions | 3,561,958,660 | 3,447,029,961 | 1,918,440,918 |
| Lua program instructions | 6,656,422,352 | 6,431,789,029 | 3,796,966,679 |

SQLite extensions are **1.960x** Clang and below 66,168,360 by **1,336,101**.
Lua extensions are **1.201x** Clang and below 75,815,270. Both pass.

For outside-call 32-bit self-moves, all candidate self-moves are an upper bound.
The frozen Clang leaf-function lower bounds remain 188,673 for SQLite
`memsys5Free` and 400,344 for Lua `luaO_ceillog2` across the five scripts.
Their complete functions contain no calls or external branches. Thus
**345,916 < 2 x 188,673** and **610,084 < 2 x 400,344** prove both requested
self-move gates. The table's all-self-move Clang counts are not used as lower
bounds. Addresses, exact rows, proof and reproduction commands remain in the
[parent record](../README.md#dynamic-counts).

`counts/summary.json` retains exact per-script totals. `callgrind.tar.gz`
contains six new original captures, stdout and stderr. Each archived capture
regenerates its published `counts/candidate/*.tsv` byte-for-byte, using the
unchanged tool, matching hashed program disassembly, object `???` and bias
`0x4000000`:

```sh
gap count PROGRAM.dis candidate/PROGRAM.out.cg '???' 0x4000000
```

Current-main raw captures, tables and runtime remain in
`../progress-b8d721e26/`; frozen Clang captures remain in `../callgrind.tar.gz`
and `../counts/`. Unmatched counts remain 1,986 SQLite / 800,334 Lua: they
contribute to `#total`, not to any class. Extending memory loads are classified
as loads. Lua interpreter activity can vary slightly across captures.

## Locked runtime and compiler cost

| Median | Main Tier 1 | Candidate Tier 1 | Clang -O2, candidate campaign |
| --- | ---: | ---: | ---: |
| SQLite wall, ms | 200.496 | 197.539 | 130.340 |
| SQLite user cycles, M | 1,015.624 | 999.607 | 631.488 |
| SQLite whole-process instructions, M | 3,684.245 | 3,569.315 | 2,009.898 |
| Lua sum of five wall medians, ms | 247.601 | 243.075 | 165.405 |
| Lua user cycles, M | 1,350.502 | 1,325.524 | 899.177 |
| Lua whole-process instructions, M | 7,187.241 | 6,960.338 | 4,283.509 |

Each campaign has 288 unique rows: 24 warm-ups and 264 measured runs, eleven
measured rounds of six programs and four rotating builds. All status values
are zero and all runs counted. Baseline-campaign Clang controls are 130.927 ms
SQLite / 165.472 ms Lua. These observations describe the measured placements;
no layout-independent speedup is asserted. Runtime counters include the whole
process; classifier counts cover program code only.

| Compiler measurement | Main control | Candidate | Change |
| --- | ---: | ---: | ---: |
| SQLite Tier 1 compile wall median, ms | 511.910 | 533.104 | **+4.14%** |
| SQLite compile user cycles median, M | 2,727.898 | 2,799.552 | **+2.63%** |
| Source selection cycles / IR instruction | 226.33 | 351.73 | **+55.41%** |
| Source selection ns / IR instruction | 40.83 | 63.46 | +55.42% |
| Source selection instructions / IR instruction | 528.41 | 920.73 | +74.25% |

Compilation uses eleven alternating A/B rounds plus warm-ups, zero failed
processes. The source-selection commands each select 2,666 functions / 472,996
IR instructions, two refused functions, zero bottom-up twin mismatches and
zero uncovered nodes. Source selection is one benchmark invocation per
compiler placement, not an eleven-round A/B experiment. These costs are the
measured tradeoff of the added proofs and storage planning; the issue has no
separate compile-cost threshold. The parent's old throughput measurements are
not transferred to this source. Raw cost and runtime logs are in `timing/`.

## Correctness, storage and SIMD

Native candidate checks, all zero failures:

- Selector: **623,061** checks.
- Emission: **277,629** checks; scalar/vector selection, constrained/full
  allocation, spills, signed/unsigned uses, wrapping controls, guarded and
  unsafe loop states, signed midpoint bounds and poisoned ABI upper halves.
- Pipeline: **9,311** checks, 2,176 native results / 1,088 Clang results.
- Selected-use liveness: **20,433** checks; masks: **146,160** checks and 2,304
  native runs against the interpreter.
- Both the main-control and candidate compilers pass `-fsyntax-only` on the
  same candidate `main.c`, with the repository's own-source flags and `-Werror`.
- Eight bounded Csmith/YARPGen programs pass both Buster tiers and Clang
  -O0/-O2. Two programs per generator at each seed 1219 / 1221; request,
  provenance, command/status and output receipts are archived. Generator
  limits and exact revisions are retained in the script and receipts.

The final follow-up preserves wrapping loop definitions before establishing
signed storage, proves power-of-two product bounds including negative
endpoints, and explicitly converts an I32 argument once at entry when two
signed widening roots request it. It assumes no ABI upper-bit promise. A stack
argument's conversion still reads exactly four bytes; unsigned widening still
clears the upper half. The emitted-code checker decodes the exact entry form,
source and result widths. Native mutants that omit the conversion or read the
caller's unspecified upper bytes are refused.

`native/*ranges.dis`, `storage-components.dis` and `signed-requests.dis` are
actual final-compiler assembly: masked 32-node opcode/type loads, masked
16-node parent/storage initialization, and masked 32-node phi/request scans.
Dependent proof/edge walks are bounded scalar operations with scalar twins;
protected logical tails remain covered. No emulated vector qualification was
used. Executables used only for disassembly and hash analysis are not shipped.

The current-head official DCO audit in
[run 42109303955](https://github.com/buster14a/buster/actions/runs/42109303955)
reports **33 signed commits, zero missing and zero trailer findings**.
`native/dco-audit.txt` retains that exact-head tool report. Hosted and native
workflow checks are still pending at publication; manual acceptance evidence
is not a substitute for those integration gates. The issue remains open until
integration, and no merge is claimed.
