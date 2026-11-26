# Call-window relocation recovery measurements — 2026-11-26

This is an unsuccessful experimental checkpoint for
[buster#2610](https://github.com/buster14a/buster/issues/2610).
The best observed `yy_reduce` call-preservation count here is **2,010,054 C/R
instructions**, still above the 660,000 goal. All three candidates passed
native output checks for the measured SQLite and Lua arithmetic workloads,
and their allocation transport totals did not increase in any function
against the original main control. This is not an acceptance record:
windows alone increases the observed SQLite instruction total by 13, and
adding windows to the earlier row-retention candidates increases transport
against those optimized baselines.

## Captured candidates and direct results

All new results use source
`bb10db3b3aa023100f5501961be311295e1d11a6`, tree
`fc09354951cdd06f034e96b4865327a6beb72332`, and the frozen
`compiler-call-windows-v2` binary whose SHA256 is
`2be5e3058e24e11ad7ea823dfeaa0160151972dcc298d7b466efa823acffbe59`.
The table contains program instructions counted inside the executable object,
not wall-clock time. Signed differences use the archived `current-0`
baseline.

The identical measured tree was subsequently published on draft PR #3639 as
`34dff18e25126d8ec939a73f2c3d58cce95da0b6` (parent `b13983ac`). The local
measured commit remains `bb10db3b`; publication does not change this identity.

| Candidate | SQLite total | Difference | SQLite transport | Interior register moves `m` | `yy_reduce` C/R |
| --- | ---: | ---: | ---: | ---: | ---: |
| Original main control | 2,238,433,975 | 0 | 253,798,812 | 0 | 3,923,938 |
| Windows | 2,238,433,988 | +13 | 253,798,812 | 8,362,364 | 2,616,646 |
| Windows + rows | 2,228,636,308 | −9,797,667 | 244,001,146 | 8,362,364 | 2,290,818 |
| Windows + batch + branch costs + partition + rows | 2,229,180,912 | −9,253,063 | 244,346,742 | 2,999,578 | 2,010,054 |

| Candidate | Lua arithmetic total | Difference | Arithmetic transport | Arithmetic `m` |
| --- | ---: | ---: | ---: | ---: |
| Original main control | 954,459,083 | 0 | 80,792,166 | 0 |
| Windows | 954,459,083 | 0 | 80,792,166 | 2,248 |
| Windows + rows | 954,455,947 | −3,136 | 80,789,030 | 2,248 |
| Combined | 954,455,469 | −3,614 | 80,787,986 | 676 |

[summary.tsv](summary.tsv) retains every origin column, audit status, and hot
function count. [comparison.tsv](comparison.tsv) includes every category
difference. Each captured program has a full compressed instruction join,
origin sidecar, raw Callgrind output, and native stdout/stderr in the archive.

The three new modes all set `BUSTER_TIER1_CALL_WINDOWS=1` and use the
8,589,934,592 work cap. Windows and windows + rows use experiment mask 0.
The latter also sets `BUSTER_TIER1_PARAMETER_ROWS=1`. Combined sets mask
2048 and additionally enables batch branch pricing, parameter partitioning,
and parameter rows. Trace instruction count is 26310; SQLite also requests
the 1900-block allocation dump. Full executed argument vectors, including
the Lua source order and frozen seed, are retained.

## Register moves remain in the measured transport total

Call-window relocation replaces some memory preservation operations with
actual register-to-register instructions at interior allocation boundaries.
Origin `m` records those instructions. This revision adds `m` to both
measurement helpers' accepted categories, reports it separately, and
includes it in the transport union `SLCTURehxtum`. Edge traffic, spill
traffic, and call traffic remain separately visible; overlapping category
groups must not be added together.

For windows alone, SQLite C/R falls by 8,362,364 and `m` rises by exactly
8,362,364. Every function's total allocation transport is unchanged.
Arithmetic similarly exchanges 2,248 C/R instructions for 2,248 real
register moves. These are changes in emitted instructions, not a relabeling
of unchanged memory operations. The experiment therefore reduces the C/R
metric without reducing allocation transport in this mode.

The version-2 runner preserves the original capture procedure. Both original
and revised C helpers, exact patches, hashes, and two small origin-contract
fixtures are retained. The valid `m` fixture accounts for all 11 instructions,
including four `m` instructions and ten transport instructions; the invalid
origin fixture is expected to fail accounting. Rejoining both original
control captures with the version-2 gap helper produced byte-identical joins.
The archived control therefore does not acquire a new classification.

## Per-function changes and the positive instruction counts

Against original main, neither measured workload has a positive per-function
transport difference for any candidate. Windows alone has no transport
differences. Windows + rows reduces transport in 238 SQLite functions and
41 arithmetic functions. Combined reduces it in 248 SQLite functions and
49 arithmetic functions.

Total instructions have a narrower exception. Windows alone changes two
SQLite function totals: `yy_reduce` decreases by 15 through argument-copy
changes, while `sqlite3GetToken` increases by 28, yielding the observed
**+13** program total. Windows + rows has 238 negative SQLite function totals
and `sqlite3GetToken` +14. Combined has 246 negative function totals and
`sqlite3GetToken` +28. Arithmetic has no positive function total in these
comparisons.

The archive retains the four tokenizer instruction listings, normalized
listings, and per-instruction-type counts. After removing instruction/target
addresses and normalizing RIP displacements, all candidate listings match
the original control. The +28 observations comprise +14 each of load,
compare, and ALU instructions and −14 compare-with-load instructions; the
+14 observation has half those differences. These are observed path-count
variations in equivalent normalized tokenizer code. They remain in every
total, and the evidence does not establish their cause.

[function-category-summary.tsv](function-category-summary.tsv) summarizes
positive and negative function counts for each category.
[positive-function-category-deltas.tsv](positive-function-category-deltas.tsv)
retains all positive category differences, including the intentional new
register moves and the combined candidate's added edge, branch, and
argument-copy instructions. Zero positive transport differences does not
mean zero positive individual categories.

## Comparison with the earlier optimized candidates

The prior row-only and combined records are from the separately frozen
[rows/partition checkpoint](../rows-partition-20261126/README.md). Their
existing joins were summarized with the version-2 helper, with `m=0`; they
were not recaptured for this packet. Their raw evidence remains in that
sibling packet.

| New candidate versus prior optimized candidate | SQLite total difference | SQLite transport difference | Arithmetic total / transport difference |
| --- | ---: | ---: | ---: |
| Windows + rows versus prior rows, six-workload capture | +2,086,979 | +2,086,994 | +323 / +323 |
| New combined versus prior combined | +725,545 | +725,517 | +83 / +83 |

The first comparison has positive transport differences in 133 SQLite
functions and 12 arithmetic functions. The second has positive transport
differences in 75 SQLite functions and three arithmetic functions.
The extra SQLite total-positive function in the second comparison is the
tokenizer variation.

The intended proof composition is window relocation against the original
row-off program, followed by a separate pass that deletes proven redundant
row stores. It does not promise improvement against a program already
optimized by the row pass. These observations preserve that distinction;
the C/R improvement must not be presented as a transport improvement over
the earlier optimized candidates.
[against-prior-candidates-summary.tsv](against-prior-candidates-summary.tsv)
and [prior-candidate-summary.tsv](prior-candidate-summary.tsv) retain those
comparisons.

## Source stages, normalization, and tests

The allocation/window implementation was first frozen at
`f53fa950052be6bbf3840f553f8bbaf476011d5e`, tree
`f0ebe84eb59fca9f0f641183f7c82ef4a6aa2cbe`, on parent
`ad9047dd851f25c323f715ca8b43b1d8ef3b2264`.
That stage includes the precise row/partition fixture corrections that were
absent from the earlier measured source. Its compiler SHA256 is
`0543bca9f34fb41bb7ff724ebd1d49d5e8f835d8ac247bea33c6a1996a20ca45`.

Initial active SQLite exports refused the new `m` category. The three
`*-export-refused` directories retain their incomplete sidecars and error
reports as failure provenance, not successful captures. Commit `bb10db3b`
changes only the origin-export whitelist and explanatory comment in
`c_check_program_emit.c` relative to the core source. All six measured
compilations are successful later `bb10db3b` compilations with `--verify`.

For both source stages, the default emitter suite, normalization mode 2,
and active window mode 1 each pass **259,280 checks, zero failures**.
Mode 1 with parameter rows passes **259,284 checks, zero failures**.
The archive contains all eight logs and the exact executed command record.
The first core build attempt had an empty retained log and no surviving
process handle; no successful completion is claimed for it. Its successful
retry and the successful exporter-fix build are recorded separately.

Mode-2 normalization at both source stages produces complete SQLite and Lua
ELFs byte-identical to original main control. The ELF hashes are:

- SQLite: `dba5e7c4382df7f8cea6d72e9aed6619535ea2af193d99695117127de3b5f7f3`.
- Lua: `610c60a34458d25ec177d097b7603d83d95d699fb18a7527e2bc6155e2096765`.

Original main was pinned at `8cfefb2dccc92c754092cd3ce9a0eafa62c6bdca`.
A later independent main build at
`c9921c19dcb75d9af678530ee7045da4971d622c` also reproduced both complete
ELFs exactly. The compact refresh appendix retains its source/tree,
compiler hash, compile command record, and build reports. The old control
captures are reused because the executable is identical; no fresh dynamic
capture is claimed for the refreshed main.

## Correctness and certificate limits

The three SQLite candidates compile all 2,709 functions through Tier 1.
Lua compiles 1,086 of 1,087; the existing unsupported
`luaD_rawrunprotected` fallback remains. All six successful builds report
zero internal and resource failures. Native SQLite verification hashes and
arithmetic stdout match the frozen oracles; the relevant stderr files are
empty. There are two workloads per new candidate, not a new six-workload
suite for each mode.

For the actual `yy_reduce`, each trace reports `allocation=1` but also
`code_checked=1 code_reason=5 code_reason_name=indirect`. The emitted-code
certificate is unsupported for this actual function. Passing allocation
certification and focused emitter tests must not be described as a complete
emitted-code certificate for `yy_reduce`.

All eight archived instruction joins (two reused control captures and six
new captures) account for their complete object totals with zero unmatched
instructions. Existing startup/PLT instructions remain visibly untagged;
outside-object observations remain separately reported (15 for SQLite and
25 for arithmetic).

## Reproduction and provenance

[call-windows-evidence.tar.gz](call-windows-evidence.tar.gz) contains the
small C tools, source patches, input digests, command records, complete
compressed tags/counts/stdout, trace/build/test logs, native oracles, and
license notices. It omits compiler binaries, full workload source, huge
whole-program disassemblies, and uncompressed raw Callgrind files.
`packet/SHA256SUMS` checks every archived file; the adjacent
[archive-verification.txt](archive-verification.txt) records a fresh
extraction and gzip-integrity check.

The host was the local AMD EPYC recovery environment using Clang 23.1.4
and Valgrind 3.24.0-3. No Benchpress/9700X hardware execution was requested
or performed for this packet. No hosted-CI result is claimed for these
source stages. Build-log elapsed figures are build-status observations,
not compile-throughput measurements.

Prepared in session `6b086a82-e9b8-83eb-aad4-587684d3a052` by
OpenAI / GPT-6 Astra Pro. Measurement/source production, independent
artifact checks, and packet construction are distinguished in the archived
provenance. This checkpoint preserves the missed target and the unresolved
certificate/acceptance limits for subsequent work.

