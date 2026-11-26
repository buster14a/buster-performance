# Parameter-row and partition probes for #2610

**The parameter-row prototype improves all six captured workload totals, but
the primary [buster#2610](https://github.com/buster14a/buster/issues/2610)
target remains unmet.** Row propagation alone leaves `yy_reduce` at
**3,436,798 C/R instructions**. The combined branch-cost, partition and row
probe reaches **2,251,611**, still above the required 660,000.

This record preserves the immutable measured source and its original tests.
The default emitter suite passes 259,263 checks; the initial fully enabled
suite reports **four failures** in the existing lazy-call-row fixture.
A later fixture correction is outside this source and is not used to relabel
the original run as a pass. No production policy is accepted here.

## Source and variants

All new programs in this packet use local commit
`ad9047dd851f25c323f715ca8b43b1d8ef3b2264`, complete tree
`d4362a0f9c4db31c297f6d69ee004e3030142011`. The compiler is frozen as
`campaign/compiler-branch-partition-rows`, SHA256
`93a9d47c5b27821264c4bed3e1aeea63698f1a78fd3c0e954a603290c3d530a7`.
The archive contains its source-tree inventory and exact patch from the
preceding batch-v2 tree. Later uncommitted source changes are excluded.

| Variant | Enabled settings | Evidence |
| --- | --- | --- |
| `partition-control` | Mask 0; parameter partitioning | SQLite/Lua compilation with `--verify`; complete ELF parity |
| `current-rows` | Mask 0; parameter rows | SQLite/arithmetic pair |
| `current-rows-all` | Exact programs and sidecars from `current-rows` | New all-six capture |
| `current-branch-partition-rows` | Mask 2048; branch pricing, parameter partitioning, parameter rows; work allowance 8,589,934,592 | SQLite/arithmetic pair |

All three new compilations use `--verify`. Exact environment variable names,
arguments and commands are retained in `packet/metadata/*commands.txt`.
The full-suite row run reuses the pair's programs and sidecars by hard link;
their complete ELF hashes and byte comparisons agree.

The six `current-0` control captures are reused unchanged from the
[current-main packet](../current-main-20261126/README.md), published at
[buster-performance commit 24e35c4a](https://github.com/buster14a/buster-performance/commit/24e35c4a126dbe220b65984964ed00758ad1384e).
That control is tied by complete ELF parity to uninstrumented main
[`8cfefb2dccc92c754092cd3ce9a0eafa62c6bdca`](https://github.com/buster14a/buster/commit/8cfefb2dccc92c754092cd3ce9a0eafa62c6bdca).
No new dynamic partition-control run is claimed.

## Partition-only control

Parameter partitioning increases the target's interval count from 7,637 to
10,924. With experimental mask 0 and row propagation disabled, the resulting
complete SQLite and Lua executables remain byte-identical to `current-0`:

| Program | Shared SHA256 |
| --- | --- |
| SQLite speedtest1 | `dba5e7c4382df7f8cea6d72e9aed6619535ea2af193d99695117127de3b5f7f3` |
| Lua | `610c60a34458d25ec177d097b7603d83d95d699fb18a7527e2bc6155e2096765` |

The compiler reports and `--verify` invocation are retained. This establishes
physical output parity for the two programs and settings checked, not for
every possible input.

## Row propagation: all six workloads

The row-only captures remove repeated parameter call-save stores. Restores,
edge traffic, spill/reload traffic, argument copies and control-origin counts
remain unchanged. In these captures, all transport savings are C-origin
call-save savings.

| Workload | Current-main control | Row-only full-suite capture | Total difference | Transport difference |
| --- | ---: | ---: | ---: | ---: |
| SQLite size-5 mix1 | 2,238,433,975 | 2,226,549,329 | -11,884,646 | -11,884,660 |
| Lua arithmetic | 954,459,083 | 954,455,624 | -3,459 | -3,459 |
| Lua calls | 514,194,341 | 514,191,875 | -2,466 | -2,466 |
| Lua closures | 1,057,541,169 | 1,054,587,347 | -2,953,822 | -2,953,822 |
| Lua strings | 720,674,383 | 714,904,009 | -5,770,374 | -5,770,374 |
| Lua tables | 879,188,189 | 876,221,340 | -2,966,849 | -2,966,849 |

There are **zero positive per-function transport deltas in all six row-only
workloads**. The numbers of improved functions are 257 for SQLite and
44, 45, 56, 59 and 53 for arithmetic, calls, closures, strings and tables.
All changed Lua function totals improve.

SQLite has one positive function total: `sqlite3GetToken` increases by 14
instructions in the full-suite run. Its earlier pair run increases by 28.
The pair and full-suite generated programs are identical; their SQLite
transport categories are identical, and their total counts differ by 14
ordinary-node instructions only.

The tokenizer's code matches the control after address/RIP-displacement
normalization. Relative to control, its full-suite load, compare and ALU
counts each rise by 7, while memory compares fall by 7. The pair has twice
those differences. The specific cause of this path-count variation is not
established. Both positive deltas and both captures are retained, without
subtracting them or treating them as optimizer changes.

The earlier SQLite pair total is 2,226,549,343, a difference of -11,884,632
from control; arithmetic is identical between the pair and all-six runs.
[summary.tsv](summary.tsv) labels every capture by variant, and
[comparison.tsv](comparison.tsv) includes their separate differences.

For `yy_reduce`, row propagation reduces C from 1,851,473 to 1,364,333 while
R stays at 2,072,465. The combined C/R total is 3,436,798. The row trace reports
3,375 known entries and 1,283,352 charged work units for this target.

## Combined probe

The combined candidate uses the new per-edge conditional branch pricing,
parameter partitioning, parameter-row propagation and bit-2048 batch search.
Its target traversal completes within the diagnostic allowance:
`branch_cost=1 supported=1 bounded=1 selected=650 published=1`,
8,796 trials and 3,042,330,711 charged work units. The parameter-row trace
reports 3,083 known entries and 1,292,509 work units.

| Metric | Current-main control | Combined candidate | Difference |
| --- | ---: | ---: | ---: |
| SQLite target instructions | 2,238,433,975 | 2,228,455,367 | -9,978,608 |
| SQLite call saves/restores | 92,488,848 | 73,101,548 | -19,387,300 |
| SQLite edge traffic | 120,718,813 | 129,928,526 | +9,209,713 |
| SQLite argument copies | 95,034,050 | 95,086,050 | +52,000 |
| SQLite control-origin instructions | 349,954,287 | 350,101,266 | +146,979 |
| SQLite transport union | 253,798,812 | 243,621,225 | -10,177,587 |
| `yy_reduce` target instructions | 97,144,176 | 96,612,214 | -531,962 |
| `yy_reduce` C/R | 3,923,938 | 2,251,611 | -1,672,327 |
| Lua arithmetic target instructions | 954,459,083 | 954,455,386 | -3,697 |
| Lua arithmetic transport union | 80,792,166 | 80,787,903 | -4,263 |

Against `current-0`, all 257 changed SQLite function totals and all 47 changed
arithmetic function totals improve. There are no positive function transport
deltas in either combined capture. Spills/reloads remain unchanged.

Positive component costs remain explicit: edge traffic increases in 218
SQLite functions and 31 arithmetic functions; argument copies increase in
seven and eight functions; control-origin counts increase in six and four
functions respectively. Other component decreases make the overall function
totals nonpositive. The transport union deduplicates overlapping spill and
edge categories; argument and control-origin counts are separate.

### Combined versus row-only

The combined candidate improves the target C/R count further, but its overall
SQLite total is **1,906,038 instructions higher** than the row-only full-suite
capture, with transport **1,707,073 higher**. There are 131 positive SQLite
function totals and transport deltas in this comparison. Arithmetic improves
by 238 instructions overall, while 15 individual function totals rise.

These are comparisons with a different baseline. They do not contradict the
nonpositive function results against `current-0`, and they prevent the
combined policy from being described as uniformly better than row-only.
[combined-versus-rows-summary.tsv](combined-versus-rows-summary.tsv) and the
archive retain the complete changes. The specific contribution of each
interaction is not isolated by this combined experiment.

## Correctness, accounting and the original test failures

All **16 included dynamic captures** pass the independently regenerated
origin/tag-fit audits with zero unmatched executable instructions. Six are
reused controls; ten are new captures: two row pair, six row full-suite and
two combined pair. Outside-object counts remain 15 for SQLite and 25 for Lua.
Every raw gzip capture was compared against its uncompressed original.

All four native SQLite runs reproduce the frozen verification hash:

```text
Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739
```

Every included Lua native output matches its frozen Clang oracle, with empty
stderr. This includes all five Lua workloads for row-only and control,
and arithmetic for the two pair captures. The combined candidate has no
calls/closures/strings/tables capture or native correctness claim here.

Compilation coverage is unchanged across partition control, row-only and
combined: SQLite compiles 2,709 of 2,709 functions; Lua compiles 1,086 of 1,087
with the existing `luaD_rawrunprotected` unsupported fallback. All report
zero internal and resource failures. With `--verify`, each reports
`code_certified=2351 code_uncertified=74` for SQLite and
`code_certified=931 code_uncertified=46` for Lua. These counters are retained
without claiming every emitted function is certified.

The default emitter suite reports **259,263 checks, zero failures**.
The initial fully enabled suite reports **259,263 checks, four failures**,
all shown in its retained lazy-call-row repeat-store fixture output for
carry cases 2 and 3. The new propagation mode omits stores the old fixture
expected at joins; a precise fixture update was being developed separately.
The original failure log is preserved as evidence and is not replaced with a
later source's test result.

No hosted-validation conclusion is attributed to local source `ad9047` in
this packet. It also contains no new hardware result or production acceptance.

## Files and reproduction

`rows-partition-evidence.tar.gz` contains a `packet/` tree with:

- All 16 compressed raw captures and compressed native/counted stdout/stderr.
- Complete compressed tags, joins, compiler reports and allocator dumps.
- Exact compiler, workload, partition-control, emitter-test and capture command records.
- Immutable source patch/tree and frozen compiler/program digests.
- Regenerated per-function and per-category deltas, including combined versus row-only.
- Native oracles, input/header manifests, unchanged C helpers and required licenses.
- Initial passing/failing emitter logs and tokenizer code/count comparisons.

The full-suite row run shares its origin sidecars with the row pair; those
complete sidecars are retained under `results/current-rows/`. Executables,
full-program disassemblies and uncompressed captures remain external with
hashes. The targeted tokenizer excerpts are included.

```sh
sha256sum -c rows-partition-evidence.sha256
tar -xzf rows-partition-evidence.tar.gz
cd packet
sha256sum -c SHA256SUMS
```

See `packet/COMMANDS.md`, `packet/PROVENANCE.md` and
`packet/INPUTS_AND_TOOLS.md`. The earlier published packets are unchanged.

The captures use the same AMD EPYC 9V74 cloud host and Valgrind 3.24.0.
No Benchpress/9700X access, queueing or timing measurement occurred.

---

Agent session: 6b086a82-e9b8-83eb-aad4-587684d3a052 (OpenAI session ID; no share URL is exposed)  
Model: OpenAI / GPT-6 Astra Pro
