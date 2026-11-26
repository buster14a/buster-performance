# Call-dominated parameter spill regions — 2026-11-26

This checkpoint for [buster#2610](https://github.com/buster14a/buster/issues/2610)
reaches the `yy_reduce` call-preservation target: **576,735 C/R instructions**,
below 660,000. The combination of ordinary spill regions, call windows and
parameter-row reuse reduces tagged allocation memory and total allocation
transport in the complete SQLite/five-Lua-workload campaign. No executed
function has a positive difference in either combined category against the
original main control.

**This is not full issue acceptance.** The issue also says tagged spills,
saves and edge traffic must not rise elsewhere. Individual spill and edge
categories do rise outside `yy_reduce`, as reported below. The experiment
does not satisfy a literal requirement that each such category never rise.
It also uses a raised structural-work limit; the later production extraction
needs its own measurements. No Benchpress/9700X execution was requested or
performed. The measured C/R target, combined-traffic results and outstanding
acceptance limits are separate conclusions.

## Measured results

All figures count instructions inside the generated executable object, not
wall-clock time or compiler throughput. The two new candidates use the same
frozen v1 compiler and inputs. Pure spill regions were measured for SQLite
and Lua arithmetic. Spill regions + windows + rows were measured for SQLite
and all five Lua scripts. Differences use the original `current-0` control.

| Configuration | SQLite total | Total difference | Allocation memory | Transport | `yy_reduce` C/R |
| --- | ---: | ---: | ---: | ---: | ---: |
| Original main control | 2,238,433,975 | 0 | 217,413,112 | 253,798,812 | 3,923,938 |
| Spill regions | 2,235,438,830 | −2,995,145 | 214,478,967 | 250,864,652 | 911,774 |
| Spill regions + windows + rows | 2,226,827,955 | −11,606,020 | 198,611,141 | 242,253,792 | **576,735** |

Pure spill regions improve the target substantially but still miss 660,000.
The successful combination has `yy_reduce` C = 227,325 and R = 349,410.

| Combined workload | Main instructions | Candidate instructions | Total difference | Memory difference | Transport difference |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite speedtest1 | 2,238,433,975 | 2,226,827,955 | −11,606,020 | −18,801,971 | −11,545,020 |
| Lua arithmetic | 954,459,083 | 954,455,779 | −3,304 | −5,552 | −3,304 |
| Lua calls | 514,194,341 | 514,192,004 | −2,337 | −4,387 | −2,337 |
| Lua closures | 1,057,541,169 | 1,054,604,201 | −2,936,968 | −6,772,750 | −2,936,968 |
| Lua strings | 720,674,383 | 714,914,127 | −5,760,256 | −19,799,042 | −5,760,256 |
| Lua tables | 879,188,189 | 876,280,367 | −2,907,822 | −3,960,124 | −2,907,822 |

Pure spill regions change arithmetic by −168 instructions, −168 allocation
memory instructions and −168 transport instructions. No other Lua script
was dynamically captured for that isolated mode.

[summary.tsv](summary.tsv) preserves every origin column and accounting
status. [comparison.tsv](comparison.tsv) gives all category differences.
[function-category-summary.tsv](function-category-summary.tsv) also counts
positive and negative function differences, including those outside
`yy_reduce`. Full per-function differences and complete instruction joins
are inside the archive.

## Category accounting and the strict gate

The definitions retain the preceding #2553/#2610 records:

| Category | Origin union | Meaning |
| --- | --- | --- |
| Call preservation | `CR` | Private call-row stores and reloads |
| Interior ordinary spills | `SL` | Actual allocation spill stores and reloads inside blocks |
| Edge memory | `TUtu` | Actual edge/split spill stores and reloads |
| Edge register copies | `ehx` | Register traffic on edges and splits |
| Interior register copies | `m` | Actual call-window register-to-register instructions |
| Allocation memory | `SLCRTUtu` | All tagged allocation memory operations, counted once |
| Allocation transport | `SLCTURehxtum` | All tagged allocation memory and register transport, counted once |
| Historical `spills_all` | `SLTUtu` | Interior and edge ordinary spill memory |
| Historical `edges_all` | `ehxTtUu` | Edge register and memory traffic |

`spills_all` and `edges_all` overlap in edge memory. Their totals must not be
added together. The separate memory and transport unions avoid that overlap.

The combined candidate has the following individual-category increases:

- SQLite `spills_all` increases by **3,104,460**. It rises in 42 functions,
  **41 outside `yy_reduce`**.
- SQLite `edges_all` increases by **1,188,185**. It rises in 34 functions,
  **33 outside `yy_reduce`**. The edge-memory component increases by
  1,188,200; edge copies decrease by 15.
- In Lua, `body` has `spills_all` increases of **2** in calls, **12** in
  closures and **2** in tables. Those workloads' aggregate spill totals
  still decrease, and every function's combined memory and transport stay
  nonincreasing.
- No function has increased C/R, combined allocation memory or combined
  allocation transport in any of the six combined workload comparisons.

The SQLite raw spill/edge differences are the same in the pure-spill and
combined modes. They arise in the ordinary spill allocation proposal.
[positive-function-category-deltas.tsv](positive-function-category-deltas.tsv)
contains every positive category difference.
[positive-categories-outside-yy.tsv](positive-categories-outside-yy.tsv)
makes the issue's “elsewhere” qualification directly inspectable.

For `yy_reduce`, the mutually exclusive transport components show that this
is more than a change of origin labels:

| Component | Main | Combined | Difference |
| --- | ---: | ---: | ---: |
| C/R memory | 3,923,938 | 576,735 | −3,347,203 |
| Interior S/L memory | 711,659 | 1,814,478 | +1,102,819 |
| Edge memory | 684,029 | 1,794,739 | +1,110,710 |
| Edge register copies | 49,063 | 49,063 | 0 |
| Interior register copies `m` | 0 | 293,694 | +293,694 |
| Combined allocation memory | 5,319,626 | 4,185,952 | **−1,133,674** |
| Combined allocation transport | 5,368,689 | 4,528,709 | **−839,980** |

The complete `yy_reduce` instruction total falls by 840,266. In addition
to the transport saving, argument-copy records fall by 15 and branch
records by 271. Every replacement memory operation and register copy
remains counted under its actual emitter origin.

Both candidates have one positive per-function *total instruction*
difference: `sqlite3GetToken` is +28, with unchanged allocation transport.
This is the same size of tokenizer observation seen in the preceding
window checkpoint. This packet preserves the observed difference and does
not establish its cause or remove it from any total. All five Lua workload
comparisons have no positive per-function total instruction difference.

## Allocation proposal and proof scope

The spill policy considers immutable incoming GPR parameters that already
have paid ordinary spill slots. It chooses no-read blocks and establishes
a real ordinary spill home at a call boundary on a path that executes the
call. A no-call block can
carry that location only when every predecessor proves it. Mixed entries
retain the register convention. A critical outgoing edge can force an
in-block reload; real uses and region exits receive the required reloads.
This changes allocation fragments and their emitted S/L/edge operations.

Each proposal rebuilds the allocation's current-slot facts and edge
programs. It preserves slot identities, interval hulls, callee registers,
temporary-slot count and original private call-row layout. Unrelated slot
facts, unread-entry facts, split programs and rematerializations must agree.
The candidate is scored with exact full call-preservation replay, an exact
ordinary S/L replay and resolved edge/branch costs.

Three independent path checks require nonincrease of allocation memory,
allocation transport and total instructions on every admitted CFG path.
A separate finite entry-to-terminal walk must have a strict real-memory
saving. A wholly neutral S/L-for-C/R replacement cannot qualify solely
because heuristic block weights are inconsistent. The witness and path
checks include loops, joins, bypasses and arithmetic overflow refusal.
The row pass subsequently deletes only redundant stores with independently
proved private-row ownership. Call windows use genuine paid-callee
register moves, with both moves included in transport.

The measured configuration sets `BUSTER_TIER1_EXPERIMENT=0`, enables spill
regions, and uses `BUSTER_TIER1_REGION_WORK=8589934592`. The combined mode
also enables call windows and parameter rows. Batch exchange, branch-cost
experiment activation and the separate parameter-partition experiment are
not enabled. The spill proposal performs its own required normalization.

The `yy_reduce` trace selects two parameter proposals, with 241 and 251
call roots and 1,302/1,360 affected blocks. The complete spill search is
bounded and charges **3,994,419,863 structural work units**. The window
stage selects 91 of 218 candidates and charges 32,634,039; the row proof
charges 1,292,149. These are conservative algorithmic accounting units,
not elapsed time, instructions or cycles. The raised limit is material:
this record does not establish the result under the earlier 128-Mi-unit
default or the cost of the production extraction.

## Frozen source and latest-main qualification

The actual dynamic captures use v1:

- Source: `39fc19ac969e5ba06809453d473e0d7aa8b09d45`.
- Tree: `6ff5642f9a52b51b32a22730713a8e7e2259ed2c`.
- Compiler SHA256:
  `9b687fc273b8a9c69ab0dee27d890c3035a0151f839991613e6cd7d14b53f68f`.

An earlier local name, `1968d3845`, has the identical complete source tree.
The subsequent correction changed the commit message/sign-off record, not
the compiled source. The packet retains both tree identities and the
corrected commit record.

V2 adds the conservative inline-assembly refusal for standalone parameter
row analysis, an actual odd-phase block-first seed fixture, and the
latest-main integration through `44cf35e195eb73e7306f13882ef15b2d9b301c4d`:

- Local source: `b8633fa0abb63a3b08e11746226ed39740af45ec`.
- Published draft #3639 source:
  [`704c32b94d88ffa50960e1d807fb678ec2131f17`](https://github.com/buster14a/buster/commit/704c32b94d88ffa50960e1d807fb678ec2131f17).
- Both use tree `024052df8ddc3cd42ab7fd6a5c92c39a43b762b1`.
- Compiler SHA256:
  `394f30a1985b2ea39cc752c0244566a8636d0f987c91fa242e69c5085ee8e7a9`.

For each candidate, V2 reproduces the complete SQLite ELF, Lua ELF and both
origin sidecars **byte for byte**: eight independent full-file comparisons
pass. The spill policy module itself is unchanged between V1 and V2.
The original dynamic counts therefore apply to these identical V2 outputs.
There was **no new V2 dynamic capture**. The exact compile/comparison
receipt and complete compilation reports are retained.

The independently built uninstrumented main at `44cf35e1` also reproduces
both complete original-control ELFs exactly. The SQLite hash is
`dba5e7c4382df7f8cea6d72e9aed6619535ea2af193d99695117127de3b5f7f3`;
Lua is `610c60a34458d25ec177d097b7603d83d95d699fb18a7527e2bc6155e2096765`.
This supports reuse of the older control captures without asserting a new
main dynamic run.

A further uninstrumented main refresh at
`4cac2430b304510610388ee3f1e33b0c6a8a3dab` (tree
`dbdf719e191eea41402b0a1d41ae25ac8cd34fdf`) also reproduces both full
control ELFs exactly. Its compiler SHA256 is
`55164cac092ff027b0a4dba9aaf463c628a218639db023d6f27fb007a85f1562`.
The packet retains its build log, exact workload commands, compilation
reports and independently repeated comparisons. Standalone V2 remains
the 44cf-based source identified above.

## Tests, certificates and hosted boundaries

| Source | Default emitter | Spill enabled | Spill + windows + rows |
| --- | ---: | ---: | ---: |
| V1 | 259,337 / 0 failures | 259,337 / 0 | 259,341 / 0 |
| V2 | 261,009 / 0 failures | 261,009 / 0 | 261,013 / 0 |

The focused spill fixtures cover genuine ordinary-slot allocation,
current-slot facts and a rejected false-home mutation, actual S/L/edge
emission across hostile native calls, mixed joins and unseeded loops.
Proof fixtures independently reject losses in each metric and reject
neutral weighted rewrites, unreachable gains and gains with no terminal
continuation. They exercise finite profitable walks, backedges, overflow
and bounded refusal. V2 adds actual materialization/certification/native
execution of the block-first odd-phase seed.

All eight newly measured workload runs pass native oracle comparisons
and have empty native stderr. The SQLite verification hash is unchanged;
the Lua stdout files equal the frozen Clang-oracle outputs. Both candidate
SQLite builds compile all 2,709 functions through Tier 1. Lua compiles
1,086 of 1,087, retaining the pre-existing `luaD_rawrunprotected` fallback.
All four candidate compilations report zero internal and resource failures.

The actual `yy_reduce` allocation certificate passes. Its emitted-code
certificate remains unsupported: `code_reason=5`, `code_reason_name=indirect`.
The passing focused certificates and native tests are not a complete
emitted-code certificate for that actual function.

The earlier integration source `e1077b9b30c94dabe2426848dad3a18479a2bc61`
(tree `7fafc9a1db3e9bdbf9bdfae35fb5ee2f16a12bbb`) passed hosted correctness
run 45886418191 and machine-problem interchange run 45886418073. The
archived correctness jobs report 22 successes and 17 skips, including the
hardware job. That integration predates the new spill policy. Its hosted
success is not asserted for V1, V2 or the later production extraction.

A subsequent completed hosted record, retrieved at 20:37:45 UTC, covers published
V2 head `704c32b9` at the actual PR merge
`c073a956e2a59199e679616291929399a4bb640d` into main `4cac2430`.
Machine-problem interchange run 45891074759 completed successfully:
42,840 checks pass normally and under ASan/UBSan, and the seeded 100,000-run
fuzz campaign completes. Correctness run 45891074877 also completed
successfully, with 22 successful jobs and 17 skips. Its four main shards
report 166 passing commands, no failures and one duplicate unity-ownership
skip. Retained Tier 1 excerpts include emitter 261,009, CFG 107,509,
allocation 92,098, pipeline 6,172, certificate 2,147 and interval certificate
17 checks, all with zero failures. Machine-problem jobs report five
successes and six skips. Hardware job 140157486687 is explicitly skipped
with null runner name and ID, consistent with `hardware=skip (pull-request)`.
These completed receipts qualify that exact hosted PR merge, separately
from both earlier integration and standalone measured source identities.

The v1 build used the existing Release build tree through a direct CMake
build command; v2 used `build.sh --config Release --jobs 2`. Actual commands
and successful completion receipts are recorded. Full build stdout survived
only in tool output, so this packet does not invent retained build logs.
The six emitter test logs and the frozen binary identities do survive.

## Reproduction, independent audit and retained data

[spill-regions-evidence.tar.gz](spill-regions-evidence.tar.gz) contains all
eight new compressed raw captures, their stdout/stderr, full instruction
joins, origin sidecars, allocation dumps, build reports, test logs, source
patches and exact commands. It also contains all six control joins,
sidecars and summaries, input digests, native oracles, C helpers and notices.
Compiler/workload executables, huge disassemblies and full workload source
trees are represented by identities and digests rather than redistributed.

The six original-control raw captures remain in the immutable
[rows/partition packet at 59c3f7d5](https://github.com/buster14a/buster-performance/tree/59c3f7d5c24986905c33a19f15e9595f30a88f10/docs/measurements/tier1-call-preservation-2610-2026-11-26/rows-partition-20261126).
The preceding [call-window packet](../call-windows-20261126/README.md)
records the earlier missed target and its unchanged capture tooling.

Independent packet checks regenerated all fourteen complete instruction
joins and obtained byte-identical files. All forty new compressed raw files
passed gzip validation and matched their uncompressed originals. An
independent C accounting reader balances every joined instruction against
the reported object total and enumerates all category/function differences.
All joins have zero unmatched instructions. Untagged startup/PLT/fallback
instructions and outside-object exclusions remain visible; those exclusions
are 15 for SQLite and 25 for each Lua workload.

The input inventories were rechecked: 71 workload files and 327 LLVM
resource headers match their frozen digests. `packet/SHA256SUMS` covers
every archived file. [archive-verification.txt](archive-verification.txt)
records a fresh extraction, checksum check and compressed-file check.

Prepared in session `6b086a82-e9b8-83eb-aad4-587684d3a052`, OpenAI / GPT-6
Astra Pro. The local host was AMD EPYC 9V74, with Clang 23.1.4 and Valgrind
3.24.0-3. Source production, workload capture and independent packet audits
are distinguished in the archived provenance. No hardware-performance or
literal individual-category acceptance is claimed.
