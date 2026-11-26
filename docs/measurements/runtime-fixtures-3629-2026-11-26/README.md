# Runtime fixture contracts and migration evidence — #3629

This directory contains the completed extraction, helper and local runtime evidence for
[buster #3629](https://github.com/buster14a/buster/issues/3629), submitted in
[PR #3654](https://github.com/buster14a/buster/pull/3654). It records the enumerated
follow-up to #2053; it does not claim that every fixed string in every compiler test
has been externalized. No 9700X qualification or performance measurement was run.
Elapsed times printed by existing test and build tools are retained as raw functional
logs, not benchmark results.

## Revisions and qualification boundary

- Original literal and metadata provenance: `8e4d32879e17b7d9548cad54257a2f8461328366`.
- Fresh main merged before submission: `5ce76f08c3ce7ed298009437d699bbc9c90471a4`.
- Local reviewed source snapshot: `fe439e97489bb617a5ad6ac10181a1d5534f21fc`.
- First published PR head: `3bf1c81d95d89d72159a549afa0965cdeb28e042`; its tree matches
  that local snapshot (tree prefix `e28904d`).
- Follow-up PR head: `1eb198ebff9458c04bf299d12dd52401f7b32eee`, tree
  `3ea42159196ff7d8ab65bc80811a30c2b60b6837`. It adds the suppress-recovery
  path repair, hosted dependency gate and generated CI cost-table entries.
- Fresh-main integration head: `424417e5c33d0aa9c671ec0e530a75f2c6529cf5`,
  tree `44d0938f11936a12161fa7e28bb5fd609f6c1f61`, merges main
  `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe`. The only conflicts were generated
  cost tables; all incoming measurements are preserved, and each of the eight
  tables differs from fresh main only by the new test's two generated lines.
- Pinned literal compiler and external oracle: LLVM/Clang **23.1.4**, revision
  `7a941dfb2877a0b8cf30323fefa85ad019e0b0f5`.

The completed local compiler runs used the **earlier development executable**:

```text
configuration: Debug, -O0 -g0, vector host target
size: 80,603,504 bytes
mtime in UTC: 2026-11-26 09:23:11.882155261
SHA256: 5ce521666f2d5277e9919e482a3bd04184ef72334ef9d1e91289b8499a3763c6
```

This is the executable referred to in the working logs as the “10:23 binary”
(the local timezone was UTC+1). No immutable commit captured its complete working
tree. It predates the final preprocessor argument-bound fix, later path cleanup,
the suppress-recovery catalog-path correction and the fresh-main merge. **The
passing local runs below are development evidence, not final-head qualification.**

The first published head's hosted selector found a missing generated cost-table row
for the new correctness heading. The follow-up head uses the documented
`costs refresh` operation to repair the eight tables without inventing measurements;
`costs-self-test.log` records the successful local check, and the follow-up head's
hosted selector passed. `hosted-1eb198e/` records completed Release correctness,
all 128 runtime controls, the actual Buster dependency graph and self-hosting for
that head. Its separate Build workflow was superseded when fresh main advanced.
`hosted-424417e/` separately records the fresh-main integration's completed
Release correctness, all 128 runtime controls, actual dependency probes and
self-hosting. Its broader Build regression workflow is still running at this
checkpoint. The older hosted results remain tied to their stated source tree.
The PR remains a draft under the cloud-only scope. `dco-audit-424417e.log` records three signed commits with no
missing trailer or finding, and `costs-fresh-main-self-test.log` records 161 checks
with no failure after the merge.

## What the extraction establishes

All listed migrated source and expectation bytes came from the original project
revision. Standalone C dumpers let pinned host Clang decode the original literals;
no hand-written escape decoder and no Buster-generated golden replaced them.
The corresponding verification manifests record successful byte comparisons,
metadata, order and any staging constraints.

| Family | Preserved records and bytes | Evidence |
| --- | --- | --- |
| Call, expression and syntax warnings | 21 + 8 + 13 rows; 10,671 source bytes; counts, flags, options and names | `checker/verification.txt`, `checker/warning-extraction.tsv` |
| Implicit-int programs | 3 sources; 906 bytes; original six C89/GNU89 configurations | `checker/implicit-extraction.tsv` |
| Auto qualifiers / record extensions | 22 → 42 and 22 → 44 explicit dialect rows, preserving policy order | `checker/catalog-conversion.tsv` |
| Imaginary diagnostics / malformed calls | 8 and 87 original metadata rows | `checker/catalog-conversion.tsv` |
| Driver program families | 23 extracted C files; 12,931 bytes; seven complete inventories and expectations | `driver/extraction-verification.txt`, `driver/fixture-source-sha256.txt` |
| Named UCNs | 15 sources, 1,544 bytes; 15 diagnostic files, 3,778 bytes, including five empty files | `ir-preproc/VALIDATION.md` |
| IR parser contracts | 53 invalid, 5 overflow, 4 reachable, 6 named diagnostics; 5,117 source bytes | `ir-preproc/VALIDATION.md` |

The original IR aggregate expectation remains `4aa02a17eaaa7b67`. Four driver
branch-truth sources remain references to canonical checker CFG inputs. The seven
pre-existing checker source moves also compared byte for byte to the base revision.

### Exact inventory disposition

| Inventory item | Before | After |
| --- | --- | --- |
| Default warning programs | 21 call + 8 expression + 13 syntax C literals | The same 42 source files and ordered policy rows in three runtime catalogs |
| Setjmp-held programs | 3 source literals and their policies | 3 source/expectation pairs, 3 catalog rows |
| Static-label programs | 4 source literals and their policies | 4 source/expectation pairs, 4 catalog rows |
| Stack-protector programs | 4 source literals and two ordinary frozen expectation lists | 4 sources, 2 expectation files, 1 row retaining the program roles |
| CET programs | 2 source literals | 2 sources, 1 row retaining both program roles |
| CET refusal/policy cases | 7 source/policy records | 7 source/expectation pairs, 7 catalog rows |
| Branch-truth fixed cases | 2 embedded sources + 4 existing checker CFG files; 6 frozen records | 2 local sources + 4 explicit shared-root references; 6 expectation files and rows |
| Quiet-root fixed data | 1 embedded source, four count values and 12 diagnostic messages | 1 source, 2 expectation files, 1 catalog row |
| Named UCN diagnostics | 15 source/expected/policy records | 15 sources, 15 expected files, 15 policy rows |
| IR parser records | 53 invalid + 5 overflow + 4 reachable + 6 syntax-diagnostic inputs | The same 68 IR files and ordered metadata; unchanged aggregate digest |
| Implicit-int native programs | 3 bodies exercised under 6 dialect configurations | 3 source files retaining all 6 configurations |

The pre-existing custom catalogs retain their coverage while making dialects
explicit: auto qualifiers expand 22 policy records into 42 dialect rows, record
extensions expand 22 into 44, imaginary diagnostics remain 8, and malformed calls
remain 87. The three separate GNU-empty controls are unchanged. Required named
constant-conversion and branch-condition cases remain mandatory; their former
compiled totals of 3 and 4 no longer reject additional ordinary catalog rows.

### Execution logic retained in C

The branch-truth and quiet-root generators remain executable code because they
construct families of programs and vary generated work. Their fixed seed programs
and ordinary recorded expectations are now data. The runners still perform the
original instruction, frame, symbol, count and diagnostic checks because those
checks interpret compiler output and determine whether a case passes.

Mode, dialect, feature and shard selection, temporary-file staging, native runs,
and independent Clang comparisons remain in C because they control execution.
The IR parser's structural assertions and generated stress inputs also remain
executable tests. Catalog readers add bounded parsing, required-name and companion
validation around the migrated data; they do not replace the independent oracles
or the original generated-input algorithms. This is the inventory in #3629, not an
assertion that every test string throughout the repository was migrated.

## Completed hosted qualification on fresh main

Source head `424417e5c33d0aa9c671ec0e530a75f2c6529cf5` and its CI merge
`fd50d1860b30332987d0add3df40df8ec5e9df24` have identical tree
`44d0938f11936a12161fa7e28bb5fd609f6c1f61`. The base is main
`74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe`.

- [Hosted Release correctness](https://github.com/buster14a/buster/actions/runs/45803637857):
  167 groups passed, 0 failed, 0 not started; one duplicate ownership group was
  skipped after the producer had already performed it successfully.
- Runtime fixture contracts: 128 checks, 0 failures, including negative controls,
  restoration and additions consumed by the unchanged compiler.
- Actual Buster build graph: source, expectation, catalog and added-case changes
  schedule zero compile/link/bake work. The C runner edit selects BACKEND plus
  link/bake, and all original data and timestamps are restored.
- [Self-host qualification](https://github.com/buster14a/buster/actions/runs/45803637310),
  static analysis, CI glue, DCO/storage and integration qualification passed.
- [Separate Build regressions](https://github.com/buster14a/buster/actions/runs/45803637355):
  still in progress at this checkpoint.

The hosted configuration is vector-g0 Release O3 with pinned Clang 23.1.4 and
sanitizer `none`. The 9700X job was skipped. The raw sections, per-shard counts,
CPU records, permanent job links and GitHub source/job metadata are in
`hosted-424417e/`. These completed runs supersede the older development binary
for qualification of this submitted source tree. No full-compiler sanitizer or
hardware performance result is claimed.

## Completed local runtime results

| Check | Observed result | Log |
| --- | --- | --- |
| Auto qualifiers | 42 fixtures, 2,661 checks, 0 failures | `checker/auto-qualifiers.log` |
| Record extensions and existing GNU-empty controls | 47 fixtures, 3,298 checks, 0 failures | `checker/record-extensions.log` |
| Imaginary diagnostics and native program | 538 checks, 0 failures | `checker/imaginary-bit-int.log` |
| Constant/branch/implicit native catalogs | 13 native comparisons, 1,533 checks, 0 failures | `checker/native-fixtures.log` |
| Malformed calls | All 87 rows, 10,539 checks, 0 failures | `checker/malformed-calls.log` |
| Newly migrated warning catalogs in isolation | 42 rows, 2,930 checks, 0 failures | `checker/focused-warning-runs.txt` and three `migrated-*-warnings.log` files |
| Stack protector | 76 checks, 0 failures | `driver/stack-protector-resource.log` |
| CET | 52 checks, 0 failures | `driver/cf-protection.log` |
| Branch truth | 27 checks, 0 failures | `driver/branch-truth.log` |
| Quiet roots | 519 checks, 0 failures | `driver/quiet-roots.log` |
| IR parser | 12,231 checks, 0 failures | `ir-preproc/ir-external.log` |
| Tier 1 masks | 211,144 checks, 1,280 native comparisons, 0 failures | `ir-preproc/masks-external.log` |
| Ordinary preprocessor cases with Clang | All 419 cases pass in the catalog's focused shard | `ir-preproc/pp-cases-clang-external.log` |
| Named UCNs with Clang | All 15 cases pass | `ir-preproc/ucn-clang-external.log` |

The isolated warning runs copied each catalog unchanged beneath the existing
auto-qualifier focus, which invokes the same v2 warning runner with dealing disabled.
They validate the data and policies; they do not independently validate the original
wrappers' part placement. The method and exact argument vectors are in
`checker/focused-warning-runs.txt`.

### Black-box controls and retained failures

`checker/runtime-fixtures-initial-binary.log` records **124 checks, 122 passes and two
expected old-binary failures**. Both failing controls target the subsequent strict
preprocessor argument builder: the old binary silently drops excess options, or
reports a downstream golden mismatch for excess bytes instead of the new explicit
bound diagnostic. Every other control passed, including selected-root digest and
companion mutations, malformed/missing/duplicate/orphan inventory data, required
native names, new ordinary rows, IR goldens and driver shared references.

The harness source corresponding to that log is
[`tools/ci/runtime-fixtures.c` at the first published head](https://github.com/buster14a/buster/blob/3bf1c81d95d89d72159a549afa0965cdeb28e042/tools/ci/runtime-fixtures.c),
SHA256 `9ca64683171185e18058ababb04e3f643d94402aa2618d28b1da9e1baa605a9e`.
Subsequent suppress-recovery controls are not claimed by that 124-check log.

Two other completed failure logs are preserved as findings, not passes:

- `driver/stack-protector.log`: the first run omitted the Clang resource directory,
  causing four system-header-dependent failures. The corrected-resource run passed.
- `driver/shard-01.log`: an external-root shard completed 16,353 checks with four
  suppress-recovery source-path failures. Those findings prompted the subsequent
  source/metadata repair; no final-head pass for that repair is claimed here.

### Isolated sanitizer controls

The exact extracted IR loader passed 14 controls under ASan/UBSan; the final
argument builder passed eight. `ir-preproc/loader-controls.log` and
`ir-preproc/arguments-controls.log` record them. The harness sources and required
`.inc` files are included. These are isolated helper checks, not a sanitizer run of
the complete compiler. LeakSanitizer could not operate under this environment's
ptrace arrangement, so the successful runs used `ASAN_OPTIONS=detect_leaks=0`.
Address and undefined-behavior instrumentation remained enabled; **leaks were not
checked**.

### Build dependency controls

The production build-regression helpers were exercised against ten disposable
Ninja graphs. Ordinary and parts-style Release graphs accepted runtime input,
expectation and catalog edits, plus an added case, with zero compile/link/bake
work and an unchanged compiler. A runner edit selected only the BACKEND owner,
then link and bake. Eight deliberately broken graphs failed as expected, including
leaked fixture dependencies, a missing or extra runner owner and missing link/bake
work. The outer harness verified restoration of original bytes, inode and timestamps
and removal of added files for every graph. All 48 hosted-product script controls
also passed.

`ir-preproc/DEPENDENCIES.md` gives the exact commands, scope and replay instructions;
`dependency_controls.c`, its summary log, the ten individual `probe.log` files and
`hosted-product-controls.log` preserve the evidence. These controls compile tiny
generated programs and exercise the production helpers. **They do not qualify
Buster's actual build graph.** The hosted Release producer now runs that actual
graph gate before packing the compiler or starting suites; its exact-head result
remains pending at packaging time. Signal-path restoration was reviewed, not
tested by sending signals during these controls.

The gate was added after the first published head. Its exact production source and
script hashes are recorded in `ir-preproc/build-dependency-sources.sha256`, with
paths relative to the Buster checkout. Replay requires the subsequent PR revision
containing those files; the first published head alone does not contain this gate.

## Reproduction and packaging

`checker/verification.txt`, `driver/extraction-verification.txt` and
`ir-preproc/COMMANDS.txt` supply the original commands or explicitly labelled
reproduction recipes. Absolute paths in raw logs identify the original run and do
not imply those paths exist on a reviewing machine. A complete Buster checkout at
the referenced revision is still required for comparisons and compiler tests.
For compiler runs, select the pinned Clang and its documented resource directory:

```sh
export PATH="/path/to/llvm-23.1.4/bin:$PATH"
export BUSTER_CLANG_RESOURCE_DIR=/path/to/llvm-23.1.4/lib/clang/23
```

The three original warning modules are included because the warning dumper includes
them directly. Larger complete copies of the original checker program, preprocessor,
IR parser and driver modules are intentionally omitted. Their pinned revision is
above; the exact extracted literal declarations needed by the dumpers are included
as `.inc` and `.h` inputs. `extract_implicit.c` can be replayed on the original
`src/buster/compiler/c_check_program_test.c` fetched from that revision.
`ownership-fingerprints.c` needs the checkout on its compiler include path because it
includes the repository's `tools/ci/build_regression.c`.

`package_evidence.c` copied an explicit manifest, excluding binaries, duplicate
fixture dump trees, complete duplicate modules, partial running logs, credentials
and unrelated probes. `packaging.tsv` records the input and output size and every
packaging adjustment. Raw logs and metadata remain byte-identical. Source files that
lacked an SPDX header received only these two comments, outside any C literal:

```c
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
// Copyright (c) 2026 David Gonzalez Martin. See LICENSE and LICENSING.md.
```

One additional recorded portability edit changes `ir-preproc/loader_check.c`'s
absolute include of `test_paths.h` to the bundled relative header. The header itself
is unchanged. These adjustments change packaged source hashes, not fixture bytes or
test behavior; historical hashes in the raw manifests refer to the original files.
`SHA256SUMS` identifies the packaged files. No binary is included.

The hosted subdirectories are separate evidence supplements with their own
source identity, extraction notes and checksums. The original packaging manifest
and `packaging.tsv` describe the initial development package; the root checksum
list also covers subsequently added hosted evidence and integration records.

The annotated copies were replayed with pinned Clang after packaging. All migrated
source/catalog/expectation outputs still compare byte for byte with the repository,
and the portable loader and argument harnesses pass all 22 ASan/UBSan controls with
the same leak-checking limitation. `package-replay/verification.txt` describes the
replay, with its raw helper logs alongside it. This verifies the packaging adjustments;
it does not qualify another compiler revision.

The compiler build logs include the successful earlier Debug build and later
Release/Debug attempts terminated with status 137 under the shared environment's
memory pressure. They provide the limitation behind the pending hosted run and are
not evidence that final-head compilation succeeded locally.

## Session provenance

Agent session: `6b07f058-e5f4-83ed-b42f-8d487dbec053` (OpenAI Codex session ID;
no share URL is exposed). Model: **OpenAI / GPT-6 Astra Pro**.

The parent `/root` integrated the work, managed the issue/PR and owned build and CI
integration. `/root/checker_audit` implemented the checker catalogs and digest roots,
assembled the shared black-box harness, ran its initial-binary checks and prepared
this package. `/root/history_audit` implemented and independently checked the driver
program migrations and their root contracts. `/root/ir_preproc_audit` implemented
and checked the IR/UCN migrations, shared digest reset, strict argument bounds and
the hosted build dependency gate.
The driver and checker loaders also received cross-review by the other owners.
All three subagents worked under this session and inherited the stated model.
