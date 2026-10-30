# Curation and manifest working directories

All copied files were taken from the finalized producer roots below using
native `find`, `cp --parents`, `cmp` and `sha256sum`. The package copies only
regular files and never follows intentional symlinks. Each of the 1,318 copied
files compared equal to its original. `raw-files.sha256` and
`raw-copy-verification.tsv` record the portable relative path and original
absolute path respectively. Original files, source manifests and existing
raw manifests were not rewritten.

Let P be
`/home/david/Documents/Codex/2026-10-30/tak/work/pr883-normal-ce1-cecd-preparation`
and A be
`/home/david/Documents/Codex/2026-10-30/tak/work/pr883-performance`.

| Original manifest | Entries | Original verification CWD | Published scope |
| --- | ---: | --- | --- |
| `P/PREPARATION-SHA256SUMS` | 42 | P | Preparation inputs; source archives and two unused prepared C helpers omitted |
| `P/FINAL-PREPARATION-SHA256SUMS` | 8 | P | Final preparation identities; source archives omitted |
| `P/host-inspection-v1/RAW-SHA256SUMS` | 35 | P | Complete read-only inspection receipts |
| `P/execution-v1/RAW-SHA256SUMS` | 194 | P, not `P/execution-v1` | 191 included named receipts; two full macro dumps and the transfer tar omitted |
| `A/c-review-v1.sources.sha256` | 27 | `A/c-review-v1` | All frozen v1 source files |
| `A/c-review-v1.receipts.sha256` | 288 | `A/c-review-v1-receipts` | All frozen regular v1 receipts |
| `A/c-review-v2.sources.sha256` | 29 | `A/c-review-v2` | All frozen v2 source files |
| `A/c-review-v2.receipts.sha256` | 630 | `A/c-review-v2-receipts` | All frozen regular v2 receipts |
| `A/support-tool-stage-v2/RAW-SHA256SUMS` | 65 | `A/support-tool-stage-v2` | 64 included named receipts; source transfer tar omitted |
| `A/objects-zero-v1/RAW-SHA256SUMS` | 56 | `A/objects-zero-v1` | Complete immutable first-failure top-level metadata |
| `A/objects-zero-v1/PAYLOAD-SHA256SUMS` | 304 | `A/objects-zero-v1` | 257 small payload receipts included; 47 compiled-image/object/full-assembly payloads omitted |

All original checks passed in those CWDs before copying. A curator's initial
v1 receipt check used the source CWD and consequently reported missing paths;
the correct receipt-CWD check passed. This was path-only inspection, not a
producer/control failure or a rerun of a failed experiment.

The additive frozen failure packet has its own 314-file raw-copy manifest and
comparison table under `failure-v1/`. Every new copy compares equal. Original
RAW56 and PAYLOAD304 hashes were verified in their owning CWD before copying.
The 52 child status files are rendered with native `find`, `printf` and `cat`;
all are zero, separately from the main exit 1. No image/object execution or
compiler/producer rerun was needed to copy or inspect them. The prior 1,318 raw
copies and their manifests/check logs are unchanged. The old tree and original
portable manifest are retained as construction-v1 history; current curated
narrative and package manifest disclose the later failure.

Original source/tool manifests may name remote absolute paths, original
working directories, or intentionally omitted payloads. They prove recorded
input identities when checked in their owning context; they are not portable
checks over this archive. Use `sha256sum -c package.sha256` from this record's
directory for all included regular files. Previous records and manifests in
this repository are untouched.

Raw Clang `-MJ` streams were made readable using the same native transformation
already used for evidence inspection:

```sh
sed 's/,[[:space:]]*$//' RAW_MJ_STREAM | jq -s .
tr '\0' '\n' < RAW_NUL_API
rg '^#define BUSTER_HOST_VECTOR ' ORIGINAL_FULL_MACRO_DUMP
```

The original streams and NUL captures remain exact. Each normalized array has
41 entries. Read-only jq checks confirm every actual unit has `-O3` and
`-march=znver5`, without `-g*` or `-fsanitize*`; the results are in `inspection/`.
Native `cmp` confirms equal ordered flag arrays, source arrays and full macro
dumps. No generated helper, compiler build, control, remote call, producer,
target execution or timing was run during this curation.

Whitespace checks apply normally to new curation and C code. Any narrow raw
capture exception is listed by exact path in the repository attributes; it
preserves historical fixture/output bytes rather than normalizing evidence.
