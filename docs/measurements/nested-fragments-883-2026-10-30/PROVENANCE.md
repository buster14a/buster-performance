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
second-input campaign, performance conclusion or later-head sanitizer execution is added here.
