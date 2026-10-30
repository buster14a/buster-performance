<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# Completed local qualification of 20e01ceb

These are local functional receipts for
[`20e01cebc77a0142260f3e0a6b3e9c66228ef3bf`](https://github.com/buster14a/buster/tree/20e01cebc77a0142260f3e0a6b3e9c66228ef3bf),
published in [Buster PR #913](https://github.com/buster14a/buster/pull/913).
They are not 9700X measurements or qualification of the separate hardware
executable. No test was rerun to curate this directory; only completed receipts,
file identities and read-only provenance were copied/checked.

The preserved local compiler is 39,373,208 bytes, SHA-256
`aeb6d01ca69167c5eed5b6f2d1c25135379ae7fa4f61756a4c688b56c9963991`.
It matches the copy at `work/complete-126/build/compiler`. The local build
used Clang 23.1.4, `-O3 -march=native`, no debug information and Wild, as retained
in `source-receipt.txt`, `build.log` and `build-compile-commands.json`. That last
file is the unchanged Clang `-MJ` object-fragment stream, despite its `.json`
suffix. It is not rewritten into a different compilation database.

The **input unit** for the actual selected/all object gates instead uses the
captured `-march=znver5` argv in `main-compile-flags.argv0` (NUL-delimited),
rendered one shell-escaped argument per line in `main-compile-flags.shell`.
Compiler build ISA and compiled-unit target ISA are distinct identities.

| Completed gate | Result | Receipt |
| --- | --- | --- |
| Full checker | 539,366 checks, zero failures; exit 0 | `checker.log`, `reviewer-execution.json` |
| Strict own-main emitted-symbol comparison | Compared 1, minimum 1, different 0, unexplained 0, unsupported 0, failures 0; exit 0 | `main-symbols.log`, `main-symbols.tsv`, `reviewer-execution.json` |
| Actual selected main.c object | `--lanes 1 --verify -c`, exit 0 | `root-execution.json`, `main-selected.log`, private object identity below |
| Actual all-definition main.c object | `--lanes 1 --verify --lower-all -c`, exit 0 | `root-execution.json`, `main-all.log`, private object identity below |
| Final-source call graph | 41 units, 27,195 functions, zero forbidden cycles, three explicitly allowed cycles, zero split variables; exit 0 | `root-execution.json`, `call-graph.log` |

The symbol comparison accepts the documented model differences: seven folded,
11,829 dropped and 164 inlined entries, with zero unselected and zero unexplained
entries. This is not a claim that the raw unmodeled symbol lists were identical.
The TSV retains both checker-path acceptance and the actual input/token count.

`corpus-execution.json` records the additional final-source commands, expanded
argv, explicit environment, source/binary identity and root-attested successful
tool sessions. Its corpus and fixture groups used `set -e`; all listed commands
completed with exit 0. None was rerun to curate this record. The empty outer-group
log is not the basis for the recorded status.

| Additional raw log | Terminal result |
| --- | --- |
| `selection.log` | Exit 0; 3,990,695 checks, zero failures; 56 Clang object comparisons |
| `intrinsics.log` | Exit 0; all 489 cases' code agrees with Clang -O0; 492 checks, zero failures |
| `c-testsuite.log` | Exit 0; 220/220 passed; zero unsupported, failed or not run |
| `sqlite.log`, `sqlite.tsv` | Exit 0; one actual symbol comparison/minimum one; zero unexplained differences, unsupported or failures; one documented inlined difference |
| `musl.log`, `musl.tsv` | Exit 0; 496 actual object comparisons/minimum 354; zero unexplained differences or failures; 78 named unsupported files; overall passed |

The musl inventory contains 613 files, of which Clang/checker accept the same
574; 496 are compared as emitted objects and 78 report named backend refusals.
It is not a claim that all 613 files emitted. The existing named-refusal scope
and the nonzero minimum remain explicit.

The root separately completed a fresh post-run frozen-input integrity check
with tool exit 0. `corpus-integrity.log` preserves the pinned top-level and
header/libc/SQLite/generated-header manifest digests; all actual files matched
those manifests. `corpus-integrity-status.txt` distinguishes the root's tool-status
attestation from a reconstructed command. The c-testsuite checkout was also
read-only checked during curation: `c-testsuite-source.txt` records commit
`5c7275656d751de0e68b2d340a95b5681858ed07` and a clean tracked/untracked status.

`root-execution.json` is the authoritative root execution receipt, with normalized
actual argv arrays, working directory, explicit environment, confirmed statuses
and tool session IDs. Its selected/all commands ran in one `set -e` shell which
returned 0, so both completed; their empty logs are not the basis for inferring
success. The call-graph invocation also has an explicit successful tool receipt.
`reviewer-execution.json` separately records the actual final build/checker/symbol
commands, wrappers, working directory, exit-0 tool completions and source/binary
binding. It explicitly records that source edits preceded the build and no source
edits occurred through tests/commit; the precommit tree hash was not captured
contemporaneously. Unknown inherited environment values and the symbol job's
exact CPU grant are not reconstructed. The preserved reviewer argv file is
byte-identical to `main-compile-flags.argv0`. `receipt-origins.tsv` maps every
copied original record to its published name and hash.

`curation-host.txt` records a read-only metadata check on the local Ryzen 9
7940HS host, Linux `7.3.0-5-cachyos`. It is curation-time metadata, not a captured
timing condition or proof of historical governor/affinity. Tests explicitly skip
native arithmetic for absent features; AMX decoding/ABI checks do not establish
native AMX arithmetic.

## Source and private payload identities

The local `git archive --format=tar` payload for this exact commit is
37,396,480 bytes, SHA-256
`47ab326dbcd45043b826f14515c69194c1cfb45873c8bbd405e78bf8939e4355`.
Recreating the archive directly from the owning Git object produced the same
hash during curation. `source-files.sha256` retains 808 tracked-file identities;
`source-archive.sha256` is the original source-root-relative archive receipt.
Its `../complete-126-measured-source.tar` path is contextual to that source
checkout, not a missing file in this publication.

`private-artifacts.tsv` records the source archive, preserved compiler and
actual selected/all object hashes, sizes and retention locations. Payloads are
**PRIVATE and are not copied into this evidence directory**. The source itself
is public at the exact GitHub commit above; a public binary release is not
needed for these receipts. Source/byte hashes identify the locally preserved
payloads rather than claiming an unverified GitHub-generated archive hash.

The root 9700X build and paired post-checking campaign have separate completed
receipts in `../hardware/`; they are not duplicated here. No old
`ba2d8a33` or `417a0897` acceptance is promoted to final-source evidence. Every
copied receipt and manifest is hashed in `SHA256SUMS`.
