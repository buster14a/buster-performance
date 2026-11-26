# Current-main baseline and completed regional traversal for #2610

**The recovered contained-interval policy remains rejected as a solution to
[buster#2610](https://github.com/buster14a/buster/issues/2610).** At main pin
`8cfefb2dccc92c754092cd3ce9a0eafa62c6bdca`, a diagnostic larger work allowance
lets the existing search finish its configured interval traversal, including
R9. `yy_reduce` still executes **2,947,340 C/R instructions**, above the required
660,000. Removing the previous work-limit stop is insufficient by itself.

This is a separate measurement pair from [the old-source recovery
packet](../recovery-20261126/README.md). Main advanced independently between
those source pins; neither their generated programs nor their counts are
interchangeable. No production allocation policy, production work limit or
hardware qualification is accepted here.

## Exact source and baseline control

The uninstrumented compiler was built from main
[`8cfefb2d`](https://github.com/buster14a/buster/commit/8cfefb2dccc92c754092cd3ce9a0eafa62c6bdca),
tree `4241118797538fffdade71a25345b7b2575137f7`.

The published measurement source is
[`98a3ce6b`](https://github.com/buster14a/buster/commit/98a3ce6b84e68bb91382ef9d30c152fd74f2e4cf),
tree `ac3a25d98b8e1dff7977047a0b72aa7096c2e0c0`. Its parents are that main
pin and the recovered `79510829fb67510fb1ac2dfe4a28a0a12a9f2912` measurement
head. The actual local build commit is
`87c533f3ee942788082508854cb7355b4b193fda`, with the **same complete source
tree** as the published commit. This identity distinction is retained in the
archive rather than describing the local build as a hosted merge build.

Both local compilers use the pinned Clang 23.1.4 Release vector build,
debug information disabled and two build jobs. Build logs, complete source-tree
listings, CMake configuration and compile-command databases are retained.
Incidental build durations in those logs are not performance evidence.

The measurement compiler with policy 0 produces **complete executable parity**
with the independently built uninstrumented main compiler:

| Program | Shared SHA256 |
| --- | --- |
| SQLite speedtest1 | `dba5e7c4382df7f8cea6d72e9aed6619535ea2af193d99695117127de3b5f7f3` |
| Lua | `610c60a34458d25ec177d097b7603d83d95d699fb18a7527e2bc6155e2096765` |

Both comparisons used `cmp` over the whole ELF. Policy 0 supplies the sidecars
for the paired dynamic baseline. The record qualifies this exact main pin; it
does not assert parity with later main revisions.

Hosted [test run 45869082244](https://github.com/buster14a/buster/actions/runs/45869082244)
also completed successfully for the published head: all 12 vector candidates,
the static analyzer, integration qualification and coverage record passed.
Its merge `383ba11dc497ef386e16f3ae5c3e0d1c643759e7` has the same complete
source tree as the locally measured compiler. The Benchpress job was explicitly
skipped with no runner assigned. The archive retains the full 39-job status
snapshot; it does not claim a conclusion for other workflows.

## Completed-search pair

The candidate uses experimental bit 1024, parameter-major traversal and a
finite diagnostic work limit of 2,147,483,648 structural units. It finishes the
target search after charging 197,535,289 units. The production default has not
been raised.

| Metric | Current-main control 0 | Candidate 1024, enlarged allowance | Difference |
| --- | ---: | ---: | ---: |
| SQLite target instructions | 2,238,433,975 | 2,238,000,153 | -433,822 |
| SQLite call saves/restores | 92,488,848 | 88,290,569 | -4,198,279 |
| SQLite edge traffic | 120,718,813 | 124,380,403 | +3,661,590 |
| SQLite argument copies | 95,034,050 | 95,136,889 | +102,839 |
| SQLite transport union | 253,798,812 | 253,262,123 | -536,689 |
| SQLite spills/reloads | 124,924,264 | 124,924,264 | 0 |
| `yy_reduce` target instructions | 97,144,176 | 97,007,960 | -136,216 |
| `yy_reduce` C/R | 3,923,938 | 2,947,340 | -976,598 |
| Lua arithmetic target instructions | 954,459,083 | 954,458,594 | -489 |
| Lua arithmetic transport union | 80,792,166 | 80,791,648 | -518 |

[comparison.tsv](comparison.tsv) records every origin and derived-count delta.
The transport union deduplicates spills/reloads, call saves/restores and edge
traffic. Its edge and spill component categories overlap and must not be added
to reconstruct the union. Argument copies are outside the union.

### Per-function results and the small positive delta

The SQLite comparison has 32 functions with lower instruction totals and one
positive total: **`sqlite3GetToken` rises by 28 instructions**, from 39,621,360 to
39,621,388. Arithmetic has 12 improved functions and no positive function total.
The complete differences are retained in
[speedtest1.function-deltas.tsv](speedtest1.function-deltas.tsv) and
[arithmetic.function-deltas.tsv](arithmetic.function-deltas.tsv).

The tokenizer's two 499-instruction disassemblies match after replacing only
their hexadecimal RIP-relative displacements; the same symbolic targets and
every other instruction text remain. Its dynamic category differences are
+14 ordinary loads, +14 compares, +14 ALU instructions and -14 memory compares.
Branches, returns, rematerialization and transport are unchanged. This is an
observed path-count variation in structurally unchanged code. Its specific
cause is not established. The positive count is retained without subtracting it
from the result or dismissing it as noise. Both disassemblies, normalized copies,
the normalization command and comparison receipt are archived.

There are no positive per-function deltas for transport union, spills/reloads
or call saves/restores in either captured candidate workload. Separate edge and
argument categories do rise: 110 SQLite functions have increased edge counts,
and 9 have increased argument counts; arithmetic has 17 and 4 respectively.
[function-category-summary.tsv](function-category-summary.tsv) summarizes each
category and [positive-function-category-deltas.tsv](positive-function-category-deltas.tsv)
retains every positive category delta. Aggregate improvements are not presented
as an absence of all positive component counts.

## Fresh baseline coverage

All six baseline workloads were newly captured on the exact control:

| Workload | Target instructions |
| --- | ---: |
| SQLite size-5 mix1 | 2,238,433,975 |
| Lua arithmetic | 954,459,083 |
| Lua calls | 514,194,341 |
| Lua closures | 1,057,541,169 |
| Lua strings | 720,674,383 |
| Lua tables | 879,188,189 |

[baseline-all-six.tsv](baseline-all-six.tsv) includes the complete categories.
Candidate dynamic capture covers SQLite and arithmetic only. Calls, closures,
strings and tables have native correctness checks for the candidate, but no
candidate Callgrind result in this packet.

All eight joined captures have zero unmatched executable instructions and
passing origin/tag-fit accounting. The outside-object counts are 15 for SQLite
and 25 for each Lua workload. Every compressed raw capture was checked against
its uncompressed original, and every included compressed output passed gzip
integrity checks.

Both variants reproduce the frozen SQLite verification hash:

```text
Verification Hash: 1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739
```

All five fixed-seed Lua native stdout outputs match the archived Clang oracles
for both variants, with empty stderr. The candidate's enlarged-allowance
`test-tier1-emit` run passes **259,244 checks with zero failures**; its full log
is included. This does not stand in for a complete new six-workload dynamic
candidate qualification or a new full-corpus emitted-code certificate.

Compilation coverage is unchanged across this pair: SQLite compiles all 2,709
functions; Lua compiles 1,086 of 1,087, with the existing unsupported
`luaD_rawrunprotected` fallback. Both variants report zero internal failures
and zero resource failures. Complete compiler reports and a compact coverage
receipt are archived.

## Search coverage

The final target trace reports 1,910 blocks, 3,073 edges, 4,013 values, 7,637
intervals and 7,866 fragments. The existing eligible traversal considers 955
intervals and selects 274: 115 for RDI, another 116 for RSI and another 43 for R9.
The configured traversal finishes with `bounded=1` and publishes the accepted
prefix. It does not enumerate every conceivable register-allocation strategy.

There are 5,557 considered targets, 3,246 sparse trials, 2,311 proposal
refusals, 2,125 weighted-cost refusals and 97 path refusals, all from the
transport guard. Epoch replay visits 9,360 blocks. The measured structural work
breakdown is:

| Stage | Charged work |
| --- | ---: |
| Setup | 10,197,684 |
| Search bookkeeping | 52,626 |
| Interval admission | 53,341,705 |
| Sparse proposal | 6,369,218 |
| Epoch replay | 36,602,720 |
| Cost scoring | 27,116,915 |
| Path checks | 13,019,095 |
| Full materialization | 50,806,400 |
| Cache commit | 28,926 |

These are the implementation's charged structural visits, not measured CPU
instructions or compiler timings. The full trace is preserved inside the
compressed compilation report and in a compact trace receipt.

## Evidence and reproduction

`current-main-evidence.tar.gz` contains a `packet/` tree with eight new compressed
raw captures, compressed native/counted outputs, complete compressed tags/joins
and compilation reports, input/resource-header hashes, unchanged C helpers,
native oracles and licenses, source/build identities, main-control parity,
exact commands, validation logs and the targeted tokenizer comparison.

Executables and large full-program disassemblies are external; their hashes
and reproducible commands are retained. The small targeted tokenizer
disassemblies are included because they establish the scope of the +28 result.

```sh
sha256sum -c current-main-evidence.sha256
tar -xzf current-main-evidence.tar.gz
cd packet
sha256sum -c SHA256SUMS
```

See `packet/COMMANDS.md` and `packet/PROVENANCE.md` after extraction.
The previous recovery archive is unchanged.

The cloud host is AMD EPYC 9V74 with Linux 6.18.57, glibc 2.41 and the original
Valgrind 3.24.0 package. No Benchpress/9700X access, queueing or timing result is
part of this packet. The primary target is still unmet, so this record does not
declare the issue solved or a production change ready.

---

Agent session: 6b086a82-e9b8-83eb-aad4-587684d3a052 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
