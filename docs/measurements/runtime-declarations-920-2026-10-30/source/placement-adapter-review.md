# #920 local placement preparation

`place-local.sh` is original Bash orchestration for the requested reuse of the
existing #917 placement method. It does not run any compiler image. Run it with
the local core reservation around the entire operation:

```sh
bash place-local.sh SOURCE_ROOT RETAINED_41_OBJECTS ORDINARY_COMPILER \
  OFFICIAL_TOOLCHAIN NEW_OUTPUT PROOF_TOOLS
```

The output directory must not exist. It must be outside the immutable source,
retained-object, toolchain and proof-tool directories. Its `receipts/status` is
written on exit; `receipts/passed.txt` exists only after every gate passes.

The driver pins official upstream Clang 23.1.4 (`c336d483...`) and local Wild
0.11.0 (`da1bd2ff...`). It records their versions, expanded production compile
flags and source list, all 41 retained per-unit compile-command records, and
SHA-256 manifests before and after. It copies all 41 objects before linking and
uses exactly those other 40 input objects for every placement. The caller must
separately bind the retained ordinary build and its source/flag provenance to
the intended baseline or candidate revision, and compare the 40 non-checker
objects between baseline and candidate. This driver does not replace that
source/build receipt.

The checker assembly is captured with this checkout's exact expanded production
compile flags, with no source or algorithm change. The already qualified x87
normalizer is applied. Before any shifted image is accepted, zero shift must
produce a whole object byte-identical to the retained ordinary checker object
and a whole final image byte-identical to the retained ordinary compiler. A new
assembly-printer difference therefore refuses the method instead of silently
broadening the adapter.

The six shifts are 0, 16, 64, 256, 1024 and 2048 bytes inside the page-aligned
`.text.buster_checker` contribution. Each one must pass the retained full-object
translation proof and the object-qualified actual linked-image proof. The
additional required function is `check_lower_prepare`, the actual production
caller of the runtime scan. The small helper itself may inline and is not used
as a substitute ownership anchor. The unmodified linked verifier additionally
requires `check_program_emit`, `check_lower_drain` and
`check_lower_batch_classify`, and verifies every object-owned hot function.

The four copied proof inputs are reused unchanged from performance evidence
commit `a7211b80e1b8490fa6d65abf41a3e49051aade4e` (PR #142), directory
`docs/measurements/label-capacity-917-2026-10-30/proof-tools`. Their complete
SHA-256 digests are hard-coded in the script, checked before and after, and
retained in its receipts. Their SPDX and copyright notices remain intact.
No new ELF-reader, relocation, linked-ownership or padding acceptance was added.

Preparation checks performed here: `bash -n` passed; an invalid argument count
returned status 2; an attempted output inside the source directory returned
status 2 without creating it. ShellCheck is not installed. No assembly capture,
compilation, link, benchmark, remote action or tracked repository mutation was
performed. Positive build/proof execution and the retained nine mutated-file
controls remain for the owning qualification campaign.
