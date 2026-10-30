# #883 ce1/cecd normal construction and C placement-tool preparation

This record preserves two successful ordinary compiler constructions on the
Ryzen 7 9700X, the frozen C placement-tool sources and local synthetic controls,
and one successful build of that supporting tool. These are distinct completed
construction layers; neither constructed normal compiler nor the resulting
`hp_method` was executed by those phases. The later first BASE `hp_method objects`
attempt is retained separately: direct-normal matched, but inside-zero failed
the mandatory whole-image SHA gate. The candidate was never launched. This
packet establishes no successful full compatibility, nonzero placement,
generated-object semantics, target execution, timing or speedup result.

The selected Buster pair is exact and has no source overlay:

| Role | Commit | Tree | Tracked regular files |
| --- | --- | --- | ---: |
| Base | `ce1bea1eeb8ece6db744726875b136fba023d317` | `b50d57fbe44c3a7225e60ba6e2d3cfd67b3bebf2` | 805 |
| Candidate | `cecd49628570e28004254a5639f10d74a13d3346` | `4558f8ae3a7260670a186df0871088b250df1a3f` | 807 |

Only the four #883 batch/fragment paths differ. Source hashes, Git blobs, full
path inventories, executable modes, commit metadata and the exact pair diff are
retained under `raw/normal/manifests/` and `raw/normal/provenance/`. Both snapshots
have six executable files; no symlinks, submodules or other special source
entries were accepted. Later main is outside this pair. Earlier sanitizer and
attempted-root inventory records, including performance #137/#138, keep their
own source, machine and workload scopes.

## Completed normal-image phase

Local producer root P was
`/home/david/Documents/Codex/2026-10-30/tak/work/pr883-normal-ce1-cecd-preparation`.
The fresh remote root Q was
`/home/david/buster-fast-bench/codex-883-qualification-ce1-cecd-normal-v1`.
Each role ran the unchanged `/bin/bash ./build.sh` once in `Q/base` or
`Q/candidate`, exit 0. Four separate calls to `print-compile-flags` and
`print-sources` also exited 0. Actual commands, launch/poll/completion records,
split output, NUL API bytes, effective-driver observations, ELF sections/symbols,
and pre/post source/mode/tool/reference checks are retained.

| Normal image | SHA-256 |
| --- | --- |
| `Q/base/build/compiler` | `db8cbb4409be4ac4e0244c9aed773dcfcb733464d9022160365dc2f386dcb6ea` |
| `Q/candidate/build/compiler` | `0b26071d237b416195b75dfb6a89fd5c1861705d432ad628b1c6dd5344e82edb` |

Both use official Clang 23.1.4, `-O3`, `-march=znver5`, debug information 0,
`BUSTER_SANITIZER=none`, pinned Wild 0.10.0, `-no-pie`, production wrap/char/aliasing
flags, `-lm/-ldl` and `SOURCE_DATE_EPOCH=1792454400`. The four actual NUL API
captures give equal ordered arrays of nine flags and 41 unique sources. Each
raw Clang `-MJ` stream contains 41 actual compile records, all ordinary O3/znver5
with no debug or sanitizer flags. They are comma-separated fragments, not a
standalone JSON document. Readable derivations under `inspection/` preserve the
original streams separately.

Both effective-driver receipts select `x86_64-unknown-linux-gnu` and `znver5`.
Their explicit target-feature arrays are empty; the CPU profile supplies implicit
defaults. This record does not claim an expanded driver feature list. Equal
full macro dumps selected the first-party `BUSTER_HOST_VECTOR=1` predicate; only
that predicate and full-dump hashes are published. Final-link argv was not
captured. The pinned unmodified build recipe and ordered source API document
the link recipe; retained temporary objects or a raw final-link invocation are
not claimed.

The host receipts identify Ryzen 7 9700X, Linux 6.18.50-2-lts, performance
governor, CPU 10 offline and allowed CPUs 0–9,11–15. A clean explicit environment
preceded the genuine existing per-run exclusive lock. Waiting with CI remained
outside each inner 470-second limit plus 10-second cleanup allowance. The
`cores` tool was absent from the inspected PATH and four explicit locations;
no scheduler was installed, grant fabricated or outer series lock taken.
The private official toolchain's 9,178 regular-file hashes and four symlinks
remain equal before/after both builds. No system settings were changed.

The raw build reports say 26.9 and 26.7 seconds. Those are construction-phase
reports, not controlled compiler-throughput samples or a speed comparison.
All final source, mode, reference, nonregular and tool checks passed. Independent
actual-receipt review cleared this completed layer. Neither compiler was run.

## C method, controls and support-tool construction

The C method derives from the accepted inside-hot-section method at performance
commit `dd92b91a3a98f57b505cc76ea13cbd74d23edffa`. Byte-exact original scripts,
the C implementation and complete/delta patches are retained. It uses raw argv,
the current build APIs and pinned identity checks; it has no shell-evaluated
flags. Its documented future gates do not become results through this archive.

| Frozen layer | Source files | Regular receipt files | Actual scope |
| --- | ---: | ---: | --- |
| C v1 | 27 | 288 | Historical final synthetic 612/612 assertions per strict and checked mode |
| C v2 | 29 | 630 | Fresh focused 183/183 per strict and checked mode: 95 common + 57 controller + 21 Bash + 10 raw environment |

These overlapping totals must not be added or interpreted as source coverage.
The unchanged v1 components retain their original results. V2 does not claim
that all 612 assertions were rerun. Synthetic strings, ELF bytes, private files,
self-child processes and actual Bash boundary fixtures do not qualify a real
compiler image. The new Bash workers use `_exit`: ASan/UBSan execute their paths,
while LSan's exit scan covers the parent, not every worker. Actual Bash build
argv and runtime settings govern; reproduction examples are not substituted
for those receipts.

The first Bash 23-case control run had four unsupported dirty-fixture expectation
failures, with all clean cases passing. Its exact initial source and raw results
remain history. Corrected 21-case controls passed. The queued exit-127 attempt
occurred before fixtures because its supporting binary did not yet exist.
The intermediate `5d95e2a9` environment helper and its results remain distinct
from final `46caf` malformed-entry refusal. These are development/control
outcomes, not compiler-source build failures. The frozen Python prototype and
unreviewed driver refresh were never producer-used; only their historical scope
document and hashes are included.

The later support-tool phase used a new remote root
`/home/david/buster-fast-bench/codex-883-qualification-ce1-cecd-hot-v2`.
It transferred exactly the frozen 29-file C-v2 tree and compiled its eight
implementation units once with official Clang, C17, O2, strict warnings and
`--no-default-config`. The real clean-environment, separate-lock, bounded build
exited 0 with empty stdout/stderr. Both source pre/postchecks and tool pins pass.
Resulting `bin/hp_method` SHA-256 is
`2603f72eff7de12f3de6d822aa3315ba810aa92e0cba33db01fc9f8eed77ce52`.
This phase never executed `hp_method`, including help/objects/inside; it ran no
compiler-image/assembly/link producer, produced compiler or target.

## Preserved history and remaining boundaries

Frozen plans, pending files and authored summaries retain their original
preparation-only or review-pending wording. This README describes the completed
scope without rewriting those historical bytes. Normal preparation's initial
private Git indices were unrefreshed: nonzero dirty-stat results were masked by
a later command. Those original diagnostics did not pass. Four corrected
standalone refresh/diff operations passed without changing source/archive bytes.

After the baseline build, a source postcheck yielded while waiting behind CI.
The outer orchestration initially mishandled that pending tool result. The
same session 86360 was resumed to actual exit 0; it was not killed, replaced or
retried. Original partial and completion records and the erratum are separate.
Expected ENOENT/lookup observations during fresh-root/tool checks remain visible.

The frozen [first BASE compatibility failure](failure-v1/README.md) adds the
later actual exit-1 attempt, including all 52 zero producer-child statuses,
the direct-normal identity match, failed inside-zero SHA, static one-byte
ordinary-text difference and separate successful external postchecks. The
tool's internal object/linked/final-source/snapshot/prepared/ready gates were
never reached. Candidate and all dependent placement/semantic/timing work
stopped. Any new guarded correction is local, unqualified and excluded.

No live outputs or successful direct-normal/inside-zero pair are claimed.
Nonzero displacement/layout proofs, object/node semantic qualification, target
execution, timing and speedup require their own completed receipts and review.
This evidence changes no compiler source, draft status, gate or certification.

## Package verification

`raw-files.sha256` binds the unchanged 1,318 construction/control originals;
`failure-v1/raw-files.sha256` binds 314 additional failed-attempt originals.
Every copy was compared to its producer path in the corresponding
`raw-copy-verification.tsv`. The initial construction-only tree
`4cc0edcf700010c8dee3df03bdb7d0df3d81fb3e` and its exact original manifest
`construction-v1.package.sha256` are preserved as history. That historical
manifest describes the earlier curated text; use the current `package.sha256`
as the portable check for all included regular files. Run it from this directory:

```sh
sha256sum -c package.sha256
```

Original producer manifests are retained unchanged, with the required original
working directories and omission boundaries documented in [CURATION.md](CURATION.md).
They include omitted or original absolute-path payloads and are not replacement
portable package checks. See [OMISSIONS.md](OMISSIONS.md) and
[PROVENANCE.md](PROVENANCE.md) for dispositions and terms. No producer/control,
compiler test, remote operation or measurement was rerun during curation.
