# IR and preprocessor fixture migration evidence

This records the work for buster issue #3629 performed by the `ir_preproc_audit` subagent. It distinguishes extraction equivalence, isolated loader checks, and tests of the available compiler executable. The compiler executable predates the final source changes; its passing results are not an exact-head qualification.

## Extraction and preserved records

The extraction input is commit `8e4d32879e17b7d9548cad54257a2f8461328366`, the fresh main used when the investigation began. `original_pp.c` and `original_ir.c` preserve those complete source files. The five `.inc` files preserve the original initializers, with identifiers renamed only to permit one standalone translation unit. `extract.c` includes these initializers and lets the pinned host Clang decode the C literals. Buster does not generate the migrated source bytes, diagnostic goldens, error categories, or coordinates.

Pinned compiler:

```text
clang version 23.1.4 (https://github.com/llvm/llvm-project 7a941dfb2877a0b8cf30323fefa85ad019e0b0f5)
Target: x86_64-unknown-linux-gnu
/home/agent/.cache/buster/toolchain/4444af0bee44de2d/llvm-23.1.4/bin/clang
```

| Family | Records | Preserved data |
| --- | ---: | --- |
| Preprocessor named UCN | 15 | Raw source, normalized diagnostic bytes, order, language standard, warnings flag, options and name |
| IR invalid | 53 | Raw source, order and exact expected error category |
| IR numeric overflow | 5 | Raw source, order and the existing limit-or-syntax assertion |
| IR reachable | 4 | Raw source, order and expected parse/verification result |
| IR named diagnostics | 6 | Raw source, order, rejected token, first-token offset rule, line and column |

The 15 UCN sources total **1,544 bytes**; their 15 diagnostic files total **3,778 bytes**, including five deliberately empty files. The 68 IR sources total **5,117 bytes**, including the deliberately empty first invalid input. The original IR contract aggregate expectation remains `4aa02a17eaaa7b67`, now serialized as sixteen lowercase hexadecimal digits and a newline in `tests/ir/parser-digest.expected`.

`clang-dump/` is the pinned-Clang extraction. All five catalog directories and the aggregate digest file compare exactly to the checked-in files. The final read-only comparison was repeated at repository HEAD `fe439e97489bb617a5ad6ac10181a1d5534f21fc`, after main `5ce76f0` had been merged and the fixture whitespace attributes corrected. Every `diff -ru` and `cmp` returned success. This comparison covers catalog metadata as well as raw input and expected bytes.

The temporary C dumper's SHA-256 is `a6b59f7f1972b1a9e72b708570ea694301ceca51ae8a004d210daae5fe22bf54`. Original full-source hashes are:

```text
35b313ed02362cacd3e9d90cfbc2162b932147dd220f75d9b0b0ccf0532b7a56  original_pp.c
0457058ae39e5cd50acfb93701e085af15b161402222173525fe4236c42cec1d  original_ir.c
```

## Implementation and contract review

The UCN runner uses the existing preprocessor catalog reader, keeps its original `case.c` staging, diagnostic normalization and Clang comparison, and adds a focused `--named-ucns-only` route through that same loop. Its new rows require a recognized language standard and either `warnings` or `-`. Empty expected diagnostic files remain valid.

The IR loader requires the versioned six-field catalog, bounded case count and decimal metadata, unique IDs and files, readable raw inputs, a nonempty inventory, and no orphan files. Each contract family retains its original execution point and assertions. Named diagnostics still compare the first occurrence of the rejected token and the independently recorded line/column. Canonical IR and new contract paths use bounded joins and each `test-ir-parse` invocation resets the default fixture root.

Preprocessor frozen expectations now follow the selected fixture root. The shared `test_digests_reset` helper releases cached text and lookup arrays while preserving table policy, so subsequent invocations can select another root without retaining the previous table. Preprocessor runtime case storage is released at command completion.

Independent review found that the existing preprocessor argument builder could silently discard a catalog's final options. The final source now rejects argument-count overflow, text overflow and oversized directory expansion; all four callers check the failure result and initialize their `PPOptions`. Successful argument bytes and the previous 30-option limit remain unchanged. This final builder fix is **not present in the available 10:23 local compiler executable** described below.

The independent driver migration review found no correctness blocker in catalog iteration order, per-case storage lifetime, shared CFG input paths, branch-truth counts, quiet-root counts/messages, CET refusal ordering, stack structural checks, or setjmp/static-label metadata. Minor style feedback was sent to that owner.

## Isolated checks

### IR loader

`loader_check.c`/`loader_controls.c` include the exact extracted production reader, word validator and new loader from `read.inc`, `word.inc` and `loader.inc`, with a bounded arena adapter. The 14 controls passed with AddressSanitizer and UndefinedBehaviorSanitizer:

- All four actual inventories: 53, 5, 4 and 6 records.
- A newly added empty-input case.
- Rejection of a duplicate, empty inventory, missing final newline, embedded catalog NUL, unlisted non-IR file, missing input, directory as input, overflowing coordinate metadata and missing catalog.

The first sanitizer execution reached a LeakSanitizer fatal error because leak checking is not supported under this environment's ptrace arrangement. No host setting was changed. The successful rerun used `ASAN_OPTIONS=detect_leaks=0`; address and undefined-behavior instrumentation remained enabled. **Leak detection was not performed.** See `loader-controls.log`.

### Argument bounds

`arguments_check.c` includes `arguments.inc`, extracted from the final strict argument builder. Eight controls passed under ASan/UBSan with leak checking disabled for the same environment limitation: ordinary defaults, the final allowed option, an excess final option, oversized option text, exact standard-buffer capacity, a truncated standard, directory expansion containing spaces, and oversized directory expansion. See `arguments-controls.log`.

### Unity syntax checks

Pinned Clang accepted both `main_unit_frontend.c` and `main_unit_backend.c` with the repository's vector target and `-Wall -Werror -fsyntax-only`. `frontend-syntax.log` and `backend-syntax.log` are empty because both commands exited successfully. These checks preceded the final argument-builder change and the last small path-join/focused-option edits. They are supporting evidence, not a final-head build claim.

## Actual compiler executable and runtime results

The actual executable used by this subagent was:

```text
/tmp/buster-3629/build/cmake/vector-g0/Debug/compiler
configuration: Debug, -O0 -g0, vector host target
size: 80,603,504 bytes
mtime: 2026-11-26 09:23:11.882155261 +0000
SHA-256: 5ce521666f2d5277e9919e482a3bd04184ef72334ef9d1e91289b8499a3763c6
```

This is the executable referred to by the parent agent as the “10:23 binary”; the timestamp above is normalized to UTC. It was built from the in-progress migration before the final strict argument fix and before the later merge of fresh main. There was no commit corresponding exactly to that complete working-tree snapshot, so the binary hash is its precise identity.

All four runtime commands below ran from `/tmp/buster3629-validation/ir-preproc`, outside the checkout, with absolute `--fixtures /tmp/buster-3629/tests`:

| Command | Observed result | Log |
| --- | --- | --- |
| `test-ir-parse` | 40 canonical, 53 invalid, 5 overflow, 4 reachable and 6 diagnostic fixtures; 12,231 checks, 52 functions, 0 failures | `ir-external.log` |
| `test-tier1-masks` | 211,144 checks, 1,280 native runs against the interpreter, 0 failures | `masks-external.log` |
| `test-preprocessor --part 4/128 --fuzz 0 --clang` | All 419 ordinary cases passed with pinned Clang | `pp-cases-clang-external.log` |
| `test-preprocessor --named-ucns-only --clang` | All 15 named UCN cases passed with pinned Clang | `ucn-clang-external.log` |

For the two Clang commands, PATH explicitly selected the pinned Clang and `BUSTER_PARALLEL_CPUS=2` limited child concurrency. These runs preceded the parent's instruction to set `BUSTER_CLANG_RESOURCE_DIR`; the exact recorded invocations did not set that variable. Future compiler validation should use the documented resource directory shown in `COMMANDS.txt`.

The case shard is a focused run of the complete 419-case ordinary preprocessor catalog, not a claim that every preprocessor section or fuzz mode ran. No timing here is a performance claim.

## Checked-in regression harness and remaining qualification

The fragment `runtime_fixture_controls.c` was delivered to the checker agent and incorporated into `tools/ci/runtime-fixtures.c`. It covers alternate roots from outside the checkout; changed/missing frozen preprocessor tables; changed UCN diagnostics; malformed, duplicate, empty, missing and orphan inventory data; UCN option-count/text overflow; a data-only UCN case addition checked with Clang; changed/malformed/missing IR aggregate expectations; IR source and catalog mutations; and a data-only canonical IR addition.

The preprocessor digest controls stage an existing case and its original catalog row under a new root. The selected table must pass, mutation must fail, deletion must fail, and restoration must pass. These controls do not rely on the repository's default digest path.

This subagent did not run the final assembled harness after the final source edit. The parent assigned its execution to the checker agent and held further local runtime work while rebuilding. Subsequent local rebuild attempts were killed with status 137 during the large checker unity compilation under shared host memory pressure, without a compiler diagnostic; `build-debug-final.log` records this. The parent is arranging exact-head hosted Release qualification. The older executable's test results and isolated final-builder checks must remain separately identified until that gate finishes.

No 9700X or benchpress work was performed by this subagent. No commits, pushes, GitHub posts or CI jobs were initiated by this subagent.
