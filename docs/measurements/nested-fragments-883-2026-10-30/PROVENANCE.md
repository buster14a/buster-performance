# Provenance and retained scope

This is an evidence-only record for [Buster #883](https://github.com/buster14a/buster/pull/883),
prepared on 2026-10-30 in the maintainer-directed takeover session. Source and result boundaries
are stated in [README.md](README.md); the later public head does not change the source executed
by the historical sanitizer/inventory runs.

## Raw origins

- Original/corrected checker qualification: `/home/david/Documents/Codex/2026-10-30/tak/work/pr883-fullsan`.
  The original stage uses clean composition tree `d7dd1b1c7b94be3c318132c4db72c19a7c35e541`;
  corrected stage uses tree `5648a6b82f166faea3d3d4cbc7b3c2093836ce43`, later committed unchanged
  as public ancestor `9b33f1331f542254fb0f0a695f052ab8ba6f3ef8`.
- Raw four-build compile metadata: `build/compile_commands.json` in the original native/baseline
  and corrected native/baseline source snapshots named by the copy ledger.
- Attempted-root inventory: `/home/david/Documents/Codex/2026-10-30/tak/work/pr883-inventory`.
  The trace uses the corrected tree plus the exact `trace-flag.patch` overlay; the matched
  untraced compiler uses that corrected tree with disclosed ASan/UBSan/bounds host instrumentation.
- `source/raw-copy-verification.tsv` maps all 206 copied raw files to original paths and hashes.
  `source/raw-files.sha256` and `source/raw-copy-check.log` verify those copies.

The raw reports, scripts, diagnostics, manifests and failed attempts are preserved byte for byte.
Absolute working paths, source locations, temporary names, detector addresses and PIDs are historical
context. Empty files are intentional. Detector-canary reports are expected fatal proofs, separate
from the audited checker/inventory report directories.

The `PLAN*.txt` snapshots retain preparation history, including superseded commands and pending
gates. Interpret the completed run using `inventory/RESULTS.txt`, the actual argv/status receipts,
and the current README. Earlier categorical wording about repeated root indices is not an observed
property of this trace; the current statement is only that the schema supplies graph indices
without source/function attribution and aggregation does not deduplicate them.

## Final published-head addendum

`final-head-b68/` comes from `/home/david/Documents/Codex/2026-10-30/tak/work/pr883-finalsan`.
It records fresh complete O3 combined-sanitizer checker execution of published commit
`b68c62de6f3a15eb70056835925979bc3079a433`, tree
`88dc687093996c6f9360676bd0e40c5a4101c073`, with both post-run source archives
independently verified against all 805 tracked public-tree blobs. The receipt records
remote-head checks before and after execution. This is new final-head execution, not
a relabeling of the earlier 9b33/5648 results.

All 76 copied raw addendum files match their originals; its `raw-copy-verification.tsv`,
`raw-files.sha256` and `raw-copy-check.log` record the transfer checks. Fresh per-host
versions, argument metadata, 41-unit compile streams, binary identities, detector proofs,
runtime settings, unfiltered checker logs, statuses and empty-report audits are separate
from the original/corrected historical directories. Probe executables, compiler binaries,
objects, corpus data and draft PR-body planning text are omitted. Metadata normalization
and NUL-argument rendering follow the same disclosed inspection transformations below.

The original 206 copied raw files remain byte-identical, including failed runs and the
earlier 9b33/5648 inventory. A separate fresh b68/88dc trace and matched-object comparison
is added under `final-head-b68/inventory/` only after independent source/identity and
reaggregation review. Its origin is
`/home/david/Documents/Codex/2026-10-30/tak/work/pr883-final-inventory`; all 55 copied raw
files match that source and have their own copy ledger/hash checks. The trace compiler
uses exact public b68 plus the reviewed diagnostic-only patch, and the untraced compiler
is the source-identical final-head native O3 sanitizer binary, with the instrumentation
difference disclosed. New binary hashes, exact common argv/cwd, raw records and aggregation,
strict audit, object identities and post-run source/input checks are all retained.

Fresh observed counts and object bytes match the earlier run, but this is independent
execution on b68/88dc, not reuse of the 9b33/5648 receipt. No compiled binaries, objects,
source archive or corpus contents are copied. Later main/source compositions, timing and
the whole repository correctness inventory remain outside these bounded qualifications.

## New curation and derivations

`README.md`, this provenance note, the copy ledger, metadata audit, package manifest and source
identity summaries are original curation. The inventory aggregator is original C17 preparation
tooling with its retained `Apache-2.0 WITH LLVM-exception` SPDX header. The diagnostic patch derives
one build-flag line from Buster's exact corrected source; no compiler implementation is copied.
The command wrappers are original qualification scripts, retained unchanged.

The compiler metadata normalization removes only the final comma from each Clang `-MJ` record
line and groups the records using `jq -s`. The raw stream remains beside it. The native flag
rendering replaces NUL argument separators with newlines; its raw form also remains.
These are inspection formats, not additional build executions. `source/curation-commands.txt`
documents the transformations and checks.

Clang 23.1.4 and the sanitizer runtimes are external compiler/oracle/diagnostic tools. SQLite,
the pinned predefines and system headers are external runtime inputs: only identities and header
hash lists are included, not their contents. The new curation does not import LLVM implementation,
third-party test corpora, compiler binaries or generated object code.

The repository's existing license/notice terms continue to apply to original reports, scripts
and helper code and any identified component portions. This packet neither relicenses historical
material nor imports the compiler's contribution-certification policy. It adds no certification
for original compiler commits, and passing these checks does not waive those independent gates.

## Omitted retained artifacts

Compiled compiler/probe/aggregator executables, target objects, full source archives and the frozen
corpus remain outside this package. Source revisions and binary/object/input hashes identify them.
The original locally retained oracle-failure directories also contain generated sources and binaries;
this bounded packet retains the complete checker failure logs instead of copying those directories.
Their source tests are recoverable from the exact recorded Buster tree. No measurement timings,
second-input campaign or performance conclusion is added. The final-head sanitizer and
diagnostic addendum is limited to exact b68/88dc; it does not execute later main.
