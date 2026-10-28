# Literal-table publication on the current stack

Frozen source: `96a4ad102cb7882ba834374ddfcf38eac080b924`, branch
`codex/pub-658`, parent `725fe7fd178b9bcac7819cfc74b395f1bf58e6ad`
(`codex/pub-641`, draft #694). That parent includes main
`321f5976d5af2b4c54fa45a639895739f2b8a8c9` and the focused #628 draft #693.
This is an eight-file port of the qualified literal-table change, not a new
native timing campaign. The immutable historical performance record is
[the frozen results](https://github.com/buster14a/buster-performance/blob/32b96dd2a12c12c7aaf25be3639a31b7fc87cdd9/docs/measurements/unclaimed-perf-2026-10-28/issue-658/target/RESULTS.md).

Published and attached as [draft #696](https://github.com/buster14a/buster/pull/696)
on 2026-10-28, targeting `codex/pub-641`. No merge or issue comment was made.

The port preserves current retained string indices and sparse initializer
lookup. Both compact and ordinary plans reach the common ascending
`declaration_tokens[at]` write, with `count` published only on success. Payloads
and embedded byte parts remain in the output-arena prefix. Reader environment
publication is independent of literal-table selection: production compilation
uses `(false, true)` and the ordinary source oracle uses `(true, false)`.
Deferred type replay keeps prepared warning metadata and remaps both retained
plan and part types.

A new permanent fixture mixes two compact tables with ordinary scalar and
string initializers. It compares all five objects' bytes with ordinary graph
planning and checks every present/absent sparse lookup, including `UINT32_MAX`.
The existing literal grammar, signed conversion, fallback, guarded tail,
reservation rollback, deferred replay and native source cases remain active.
An independent read-only review found no concrete source or lifetime defect.

## Local exact-source correctness

All builds and test invocations use a separate two-core `cores` grant. Release
build flags are in `compile-commands.json`; all 41 units passed. Compiler
SHA-256 is `12e26446e4ae1b7760494e3014e084ec181b7f1dd59e7893d75de69b300ab118`.

- Full checker seed658: 466,880 checks, four local Clang23.1.4 fpclassify oracle
  disagreements. The shared pure-main321 baseline and #628 publication both
  have the same four effects; no additional failure occurred here.
- Assembly/Clang: 1,010 checks, zero failures; 632 sources, 197 accepted.
- Deferred: 1,147 checks, zero failures; 72 fixtures, 708 merges, 6,552 bodies.
- Driver using this executable: 21,655 checks, zero failures.
- Focused ASan/UBSan: 2,869 checks, zero failures, including the new mixed
  compact/ordinary sparse-index fixture.
- Pinned c-testsuite `5c7275656d751de0e68b2d340a95b5681858ed07`, own
  `tests/c-testsuite/subset.txt`, cross-check: 220 passed, zero other outcomes.
- Call graph: 41 units, 25,404 functions, 151,092 calls, zero bad cycles,
  three allowed cycles, zero split variables.
- Original C object/runtime controller: nine complete objects and diagnostics
  match the pure-main321 reference. Its 9,225 independent native index/value
  checks pass. The malformed 129-element case rejects identically with no
  object. Accepted cases include 100k/200k/400k/800k bytes, 320k ints, 100k
  zeros/volatile bytes/floats and widened unsigned-negative values.
- Pinned whole SQLite: default, stage-instrumented and pure-main321 reference
  objects have the same SHA-256
  `1cafbadf926eed2245cb6a81ac1ee511f42d300995c2b2144c98e495d8c394d6`.
  The one-round run establishes byte equality; it is not timing qualification.

`native_qa.c`, `generate_table.c`, `run_table.c`, all emitted objects and logs
are retained here. `identities.sha256` identifies source helpers and objects.
The pure-main321 reference is the shared local debug0 Clang23.1.4 build,
SHA-256 `82971a83b1041f9fac64d1db55c3787fb9e5df3a57912454042e7b42aaf84f54`.

The first focused sanitizer adapter link missed main421's newly externalized
canonical target table, recorded in `asan-build-initial.log`. The standalone
adapter was updated to own the unchanged target data, just as ordinary
standalone source inclusion does. Production source was not changed by this
adapter repair. Exact-head native CI remains distinct from the old frozen
9700X performance record.
