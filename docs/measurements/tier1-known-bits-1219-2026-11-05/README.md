# Tier 1 known upper bits, #1219 (2026-11-05)

This record qualifies [buster#1419](https://github.com/buster14a/buster/pull/1419),
the known-bits selection work for [buster#1219](https://github.com/buster14a/buster/issues/1219).
It measures register extensions and self-moves with #1189's existing classifier,
and generated-program runtime and compiler cost on the locked Ryzen 7 9700X.
The issue's full extension-count acceptance remains open; the self-move limit
passes. See the exact counts below.

## Sources and host

| Role | Exact source |
| --- | --- |
| Baseline | Buster `d6cc7ed2634e0bad8993b435745ca8ebe722ebc4` |
| Candidate | Buster `08545d5c765912a08967dd66e19298c28f1eedb8` |
| Existing corpus harness, gap classifier and Lua scripts | buster-performance `b749a517de5bd31b2c85c4035ff838157f4244cc` |

All compiler builds, native tests, instruction counting and timing ran on
`benchpress`, a Ryzen 7 9700X, through `~/buster-fast-bench/exclusive.sh` with
owner `codex-1219` and this issue/PR's link. Timing and count runs use CPU 2.
Builds use Clang 23.1.1, `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0`, eight build
jobs. `identity/` records tool, source, input and binary hashes; the source trees
were immutable archives of the listed commits, without Git metadata.

The candidate propagates bounded unsigned and signed ranges separately from
physical zero-upper-bit certificates. It removes proven redundant widening and
truncation, folds ordinary exact-width signed loads, collapses successive sign
extensions, reads original values at exact-width stores, and computes bounded
nonoverflowing signed constant offsets directly at 64 bits. Unknown ABI upper
halves, possible wrapping arithmetic, cyclic facts and volatile/atomic access
ordering remain conservative.

## Workloads and checks

- The frozen `sqlite3.c`: SHA-256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`, from
  `ci-corpora-preprocessor-391e729af658`.
- SQLite `test/speedtest1.c` at `ccc132c5be20ab5c755c97a08d06b1b592fef330`:
  `b5eaf4bbcbb320fd8eb3f3e6c4cd5f51a64dd0cd70efe969634d1785e3419675`.
- Lua 5.4.8 release archive:
  `4f18ddae154e793e46eeab727c59ef1c0c0c2b744e7b94219710d76f530629ae`.
  Scripts are `calls`, `tables`, `strings`, `arithmetic`, `closures` from
  `docs/measurements/tier1-reciprocal-141-2026-11-01/9700x/lua/` at the performance
  commit above. Lua and speedtest sources and the scripts are hashed in
  `identity/inputs.sha256`; the frozen SQLite and release-archive pins are above.

SQLite flags: `-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`. Buster builds its unity input with
`--tier1 -fno-asynchronous-unwind-tables`; Clang -O2 builds separate SQLite and
speedtest objects, as the original harness does. Lua uses `-std=gnu99
-DLUA_COMPAT_5_3 -DLUA_USE_LINUX`, the same 33 translation units, `-lm -ldl`.

The speedtest arguments are `--shrink-memory --reprepare --stats --journal wal
--size 5 --heap 40000000 64 --testset mix1`, each run in a fresh directory under
`/dev/shm`. Every build passes `--verify`, producing
`1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`. All five Lua outputs
match the baseline for the counted runs and the independent Clang -O0 output
for the runtime runs.

## Dynamic counts

| Program-code count | Baseline | Candidate | Clang -O2 | Candidate / Clang |
| --- | ---: | ---: | ---: | ---: |
| SQLite extensions | 197,897,800 | 111,371,374 | 33,084,180 | 3.366 |
| Lua five scripts, extensions | 470,424,767 | 199,094,174 | 37,907,635 | 5.252 |
| SQLite all self-moves | 29,201,811 | 345,916 | 962,217 | 0.359 |
| Lua five scripts, all self-moves | 69,102,695 | 610,084 | 2,379,571 | 0.256 |
| SQLite program instructions | 3,563,156,990 | 3,452,761,706 | 1,918,440,918 | 1.800 |
| Lua five scripts, program instructions | 7,035,076,470 | 6,697,966,156 | 3,796,966,679 | 1.764 |

Extensions decrease 43.72% on SQLite and 57.68% on Lua, but still exceed the
limits of 66,168,360 and 75,815,270. Neither extension gate passes.
`counts/summary.tsv` retains each script's exact counts. The SQLite candidate
still executes 25,029,375 extensions immediately following `setcc`; that count
alone does not establish that every such value has only a branch consumer.

Counts are program code only. Callgrind 3.25.1 supplies instruction-address
counts; the unchanged `tier1-gap-1189-2026-11-03/tools/gap.c` at the performance
commit above joins GNU objdump disassembly and classifies them. Extending memory
loads are loads in this classifier; register extensions are `extend`.

Buster's Callgrind object is `???` at bias `0x4000000` on this installation;
Clang's object is its exact program path at bias zero. The TSVs retain `#total`
and `#check unmatched`. Buster's unmatched counts are 1,986 for SQLite and
800,334 across Lua, unchanged from the baseline; Clang has none. These are not
attributed to any instruction class. The program-instruction column follows
`gap`'s `#total`, including those unmatched counts; the extension/self-move
columns contain matched instructions only. Raw Callgrind captures are in the
compressed archive; TSVs and program hashes are retained without third-party
executables.

No record-origin instrumentation was needed for the self-move gate. The table
counts **all candidate self-moves**, including calls and widths other than 32,
which upper-bounds the requested outside-call 32-bit count. For the Clang side,
two leaf functions give a sufficient **lower** bound on outside-call 32-bit
self-moves: `memsys5Free` contributes 188,673 in SQLite, and `luaO_ceillog2`
contributes 400,344 across Lua's five scripts. Their complete disassemblies have
no calls, system calls or branches outside the function. Their counted self-moves
are `mov %ecx,%ecx` at `0x1040ca` and `mov %eax,%eax` at `0x16d74` respectively.
Thus 345,916 < 2 × 188,673 and 610,084 < 2 × 400,344: both requested self-move
gates pass even with these conservative bounds. The all-self-move Clang column
is not used as a lower bound for the gate.

`counts/clang-self-move-lower-bound.tsv` retains the six address/count rows.
Reproduce them with `GAP_INSTRUCTIONS=1 gap count ...`, selecting those symbols
and self-move addresses; use `objdump -d --disassemble=memsys5Free` and
`--disassemble=luaO_ceillog2` to verify that neither function contains a call or
an external branch. The other Clang self-moves need not be classified to prove
these bounds.

## Locked runtime and compiler cost

| Generated program, median | Baseline Tier 1 | Candidate Tier 1 | Clang -O2, candidate campaign |
| --- | ---: | ---: | ---: |
| SQLite, ms | 200.836 | 198.857 | 130.775 |
| SQLite, user cycles M | 1,016.017 | 1,006.993 | 633.747 |
| SQLite, whole-process instructions M | 3,685.442 | 3,575.047 | 2,009.898 |
| Lua five scripts, ms | 259.655 | 248.560 | 164.947 |
| Lua five scripts, user cycles M | 1,415.859 | 1,355.902 | 896.732 |
| Lua five scripts, whole-process instructions M | 7,566.140 | 7,227.427 | 4,283.321 |

| Compiler measurement | Baseline | Candidate | Change |
| --- | ---: | ---: | ---: |
| SQLite `--tier1 -c`, median wall ms | 515.088 | 539.415 | +4.72% |
| SQLite `--tier1 -c`, median user cycles M | 2,745.443 | 2,774.358 | +1.05% |
| SQLite `--tier1 -c`, median instructions M | 6,774.145 | 6,830.511 | +0.83% |
| Source selection, cycles/IR instruction | 228.57 | 292.04 | +27.77% |
| Source selection, instructions/IR instruction | 530.05 | 683.46 | +28.94% |

The range analysis has a measurable compile cost. Candidate compile wall times
range from 520.085 to 547.719 ms, against 514.211 to 519.032 ms for baseline.

Runtime uses the built-in `measure-tier1-programs`, one warm-up and eleven
rotating rounds of Tier 0, Tier 1, Clang -O0 and -O2, with per-process user-cycle
and instruction counters. The baseline and candidate are separate locked
campaigns, each with its Clang controls. Lua totals are sums of five per-script
medians. These are observed values for these executable placements, not a
placement-independent speedup claim. Disk-backed exploratory SQLite timing was
discarded; all runtime results reported here use `/dev/shm`.

Compile cost uses `time-runs`: eleven alternating baseline/candidate rounds,
one warm-up, frozen SQLite `--tier1 -c` and the same flags. Source-selection
cost uses one `benchmark-tier1-select-source --only select` process per build on
the same frozen SQLite input. That command checks both selection paths on its
2,666 selected functions / 472,996 IR instructions; the two refusals predate this
change. A single source-selection process is descriptive, not a statistical
performance qualification across code layouts.

`native/known-bits.s` is the optimized helper's assembly. The independent seed
loop handles 32 nodes with masked `vmovdqu8`/`vmovdqu16`; the dependent fact
sweeps are scalar bounded walks. Stable IR column pointers are cached across
fact stores. Native protected-page tests cover both paths and every tail size
from zero through 65 nodes.

## Correctness and limits

At the exact candidate source:

- `test-tier1-select`: 600,841 checks, zero failures.
- `test-tier1-emit`: 237,406 checks, zero failures.
- `test-tier1-pipeline --cross-check`: 9,231 checks, zero failures; 2,176 native
  results and 1,088 Clang results, with no selection-twin mismatches.
- Bounded differential campaign: eight generated programs, all pass at both
  Buster tiers and both Clang optimization levels.
- All eight Ubuntu 26.04 / Clang 23 hosted correctness shards, DCO audit and
  guide/storage policies pass. The [run](https://github.com/buster14a/buster/actions/runs/42032998957)
  records native/x86-64 host builds. Its hardware qualification aggregate fails
  because the PR is draft, not because a native test failed; its native hardware
  job and libFuzzer job were skipped. Manual native results above are separate
  from that workflow's qualification status.

The first emission/pipeline dispatcher was accidentally duplicated; both runs
passed. The retained pipeline receipt is a clean single rerun, not the earlier
interleaved output. The final runtime log has exactly 288 unique run tuples:
24 warm-ups and 264 measurements, all successful and counted. The baseline has
the same complete run set. An additional runtime replay at the same source is
not pooled into these medians. Binary hashes were checked again after the
duplicate corpus builder finished and all matched the original receipts.

The native selector regressions cover boundary and randomized values, poisoned
ABI upper halves with coalesced registers, wrapping arithmetic that must retain
extensions, exact-width and volatile loads, exact-width stores at protected page
boundaries, signed-offset chains and conservative cyclic phis. Both selection
paths execute the generated code against independent formulas.

The final bounded differential campaign has two seeds per generator in each of
two chunks (seeds 1219–1222), eight generated programs total. Each passes
Clang -O0/-O2 and both Buster tiers. Csmith is pinned to
`0cdc710315cfee9035e22ef4363ca479270d1934`, with `--max-funcs 4
--max-block-depth 3 --max-expr-complexity 5`; YARPGen is version 2.0 build
`1adb290`, binary SHA-256
`6111ca4061547957b6ebd7df1f713a04f843dae20022b79d0798e9fb77a8092d`, with
`--max-array-dims=2`. The receipts retain commands, source hashes and results.

Earlier unbounded generator exploration at an intermediate implementation had
one Clang reference timeout and one reference link failure beyond the small
code model. They are not counted as passes or Buster failures. Eight bounded
programs are a small regression check, not broad fuzz or sanitizer acceptance.

The remaining extension count includes truth-value materialization, ABI narrow
argument/result normalization and signed indices without a proven range. Branch
truth elimination is separately owned by #1218 / PR #1301; no unmerged result
from that work is included or assumed here. The 2× extension target is not met,
and this evidence does not close #1219.

## Reproduction and provenance

`scripts/` contains the as-run coordinators. They assume the task directory
`~/buster-fast-bench/1219-codex`, immutable `base/` and `affine/` source trees,
the prepared inputs, and #1189's `scripts/progs.sh` and `scripts/run.sh` at the
pinned performance commit. Each substantive invocation obtains the host lock;
the lock is not held across the coordinator's whole series. `affine` is the
final candidate's historical directory name, not an additional compiler mode.
The initial build/count coordinators also mention an exploratory `head/`
directory. None of its results supplies the candidate columns: those come only
from the final `affine/` source and `results/affine/` captures.

Build an immutable archive of each compiler commit with `./build.sh --jobs 8`
and the settings above under the lock. `prepare-inputs.sh` downloads the official
inputs; copy the pinned five scripts and original corpus harness into its
expected directories. `count-affine.sh` makes the final candidate programs,
checks outputs and records six Callgrind runs; repeat that procedure for the
baseline and Clang -O2 builds. For each program:

```sh
objdump -d --no-show-raw-insn PROGRAM > PROGRAM.dis
gap count PROGRAM.dis PROGRAM.out.cg '???' 0x4000000 > PROGRAM.tsv
# For Clang use its exact Callgrind object path and bias 0.
```

`qualify-affine.sh` records emission, pipeline, runtime, compile and source-select
checks; `record-pipeline.sh` makes the clean pipeline receipt, and
`differential-affine.sh` records the bounded differential campaign.
`identity/` pins the binaries actually run. The user-prefix Valgrind installation
was copied from the session's installed 3.25.1 solely to instrument the host; no
host-wide package or setting was changed and no Valgrind binary is included.

Original compiler changes and measurement orchestration use
Apache-2.0 WITH LLVM-exception. Existing harness code is referenced by its exact
source, without relicensing it. SQLite, Lua, Csmith and YARPGen are external
runtime/generator inputs; their code and compiled corpus executables are not
incorporated in this evidence record. Generated differential receipts identify
their inputs without shipping executables. No imported implementation code was
used for the selector changes.

## Follow-up review coverage

Commit `0216fe051a1105caeec60a387324765ff6c44416` changes only the selector tests
after the measured `08545d5c` implementation. It adds direct rule and native
value regressions for NEG, UDIV and UREM: masked negation through truncation and
signed widening, bounded unsigned division by four, and arbitrary unsigned
remainder by eight. Both selection paths run boundary/random values with
poisoned ABI upper halves and coalesced registers. The native selector passes
601,336 checks with zero failures at this commit (`native/review-select.log`).

The new compiler rebuilds **both** corpus executables byte-for-byte identically
to the measured candidate. `identity/review-programs-identical.txt` and
`identity/review-binaries.sha256` retain that proof; the production selector
source hash is unchanged. The compiler-cost measurements remain pinned to the
original `08545d5c` compiler executable, since a test-only commit can still change
the host executable's layout. `scripts/validate-review-tests.sh` records the
locked build, native test and corpus identity checks.

Agent session: `01a1ab58-d20a-7f91-b522-34a0c70fa8f5` (no private share URL is
exposed). Model: OpenAI / GPT-6.
