# First BASE compatibility attempt: failed, retained, no retry

The first actual C-v2 `hp_method objects` BASE invocation failed the required
inside-zero whole-image SHA-256 gate. Original session 72531 was resumed until
actual exit 1, observed at 15:08:30 UTC. It was not a timeout or a failed Clang
child. The candidate invocation was never launched. All dependent producer,
nonzero placement, semantic/target and timing work stopped.

This is separate from the completed normal/reference and support-tool builds.
Their original receipts and pending/preparation documents remain unchanged.
The selected BASE is Buster commit
`ce1bea1eeb8ece6db744726875b136fba023d317`, tree
`b50d57fbe44c3a7225e60ba6e2d3cfd67b3bebf2`, with 805 source files and no overlay.
The failed attempt used the reviewed C-v2 tool
`2603f72eff7de12f3de6d822aa3315ba810aa92e0cba33db01fc9f8eed77ce52`,
the exact source and NUL references, official Clang 23.1.4 and pinned Wild.
Full environment, argv, driver jobs, statuses, wait/completion observations and
external postchecks are retained under `raw/`.

## Actual boundary reached

The tool compiled 41 source objects, emitted checker assembly, assembled its
unchanged zero input and linked direct-normal and inside-zero images. All 52
recorded producer-child statuses are zero; the controller subsequently exited
1 on the mandatory whole-image SHA mismatch. `inspection/child-statuses.tsv`
is a readable listing of those exact status files, not a successful main status.

| Output | SHA-256 |
| --- | --- |
| Qualified normal and new direct-normal | `db8cbb4409be4ac4e0244c9aed773dcfcb733464d9022160365dc2f386dcb6ea` |
| Failed inside-zero image | `24a7960898c231c8f1b767966431e4866d7996e1cb407acf9eaba60cb681f62c` |
| Original checker object `objects/8.o` | `b87831410140924f2cc5caed0ca0bcadc60d477900e309328dd652aa7b875039` |
| Reassembled zero checker object | `13d5e0675654fda2643bf7effafc690a42219aecae312e2dbefeb7c40af11175` |
| Raw and zero-input checker assembly, identical | `dc337bbed39e24d0f7bdcb4b5dd30c85f33644458abcf73098c75eb05999db21` |

The direct-normal identity check passed. The full compatibility prerequisite
failed because inside-zero did not match. The tool never reached the real
object or linked proof gates, either internal final source postcheck,
`snapshot.sha256`, `prepared.json` or `ready.nul`. Those artifacts/results are
unavailable; later byte inspection does not retroactively qualify them.

Separate external postchecks of the normal 805-file source tree and C-v2
29-file tool source exited zero. Normal/tool/reference/toolchain/guidance pins
also match after failure. Original queued sessions were resumed to completion;
no producer was retried. These are external checks, not a claim that the
failed method reached its internal final checks.

## Static encoding difference

Read-only comparison, independently checked on the original artifacts, found
exactly one changed byte in each checker object and final image. The direct
object's `DC C0` becomes `D8 C0` after the assembly round trip:

| Scope | Zero-based file offset | Ordinary `.text` offset | Function offset |
| --- | --- | --- | --- |
| Checker object | `0xF75D1` | `0xF7591` | `check_test_action_constraints+0xCF1` |
| Linked image | `0x1243FB1` | `0xD49FB1` | `check_test_action_constraints+0xCF1` |

The linked virtual address is `0x1644FB1`. The hot input section starts at object
file offset `0x239000`, so this change is outside that section. All other bytes
are equal; sizes, headers, sections/segments, symbols and relocations do not
explain the mismatch. The one-line `cmp` maps use decimal one-based file
positions and octal byte values; `FIRST-DIFFERENCE.tsv` records zero-based hex
coordinates.

Bounded aligned disassembly decodes the x87 FADD direction forms with ST(0)
and ST(0). The identical saved assembly has `fadd %st, %st(0)` at line 812247,
immediately after `callq __floatuntixf@PLT`. The retained small source context
and disassemblies describe an encoding-roundtrip divergence. They establish
no semantic/runtime equivalence and do not waive the full-SHA gate. Neither
actual cc1 nor cc1as job contains `-mrelax-all`; this is not evidence of an
alignment, metadata or relaxation cause. No corrected assembly was produced
or image executed in this attempt.

Any guarded normalization correction is separate local implementation work,
unqualified and not included here. This failed C-v2 attempt is not rerun or
replaced by such work. Source #883 remains outside any new performance claim.

## Copy and omission boundary

Producer root F was
`/home/david/Documents/Codex/2026-10-30/tak/work/pr883-performance/objects-zero-v1`.
Its immutable top-level `RAW-SHA256SUMS` has 56 metadata entries; all are included
along with that manifest. `PAYLOAD-SHA256SUMS` has 304 original payload entries.
The packet includes 257 small payload files: actual argv, driver output,
statuses, raw Clang metadata, NUL settings/references and the source manifest.
It omits 42 object files, three compiled images and two full assembly streams,
with all 47 hashes repeated in `inspection/omitted-payloads.sha256`.

The raw archive is also omitted: 286,013,440 bytes, 308 entries/304 regular
files, SHA-256
`51359885e619cdef6125af11efd7c2ad7ec8796297c4ed470ab0b0699e6ed23d`.
Its origin, hash and member list remain. The failed remote root and local
original payload remain preserved at their recorded locations. No compiled
image/object, full assembly, source/toolchain/corpus archive or cache payload
is added to Git.

All 314 included original files compare byte-for-byte to F and are covered by
this directory's `raw-files.sha256`. The root `package.sha256` covers the full
additive packet. Original manifests retain their owning CWD and omitted-payload
meaning; see the root [curation table](../CURATION.md). No compiler/control,
producer, target, timing or remote operation was rerun for this evidence copy.
