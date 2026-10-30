<!-- SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception -->
<!-- Copyright (c) 2026 David Gonzalez Martin. -->
# Provenance and component terms

This report and the five original project harnesses are Apache-2.0 WITH
LLVM-exception, copyright 2026 David Gonzalez Martin. They were copied byte for
byte from the root-tested `work/acceptance-126/` files; their source hashes are
in [harnesses/SHA256SUMS](harnesses/SHA256SUMS). The full default text is retained
in [licenses/Apache-2.0-with-LLVM-exception.txt](licenses/Apache-2.0-with-LLVM-exception.txt).
No Python program, compiled analysis executable or synthetic timing fixture is
incorporated in this record.

## Final artifact provenance and dispositions

| Artifact family | Required owning identity / disposition |
| --- | --- |
| Buster source archive and tracked-file hashes | Public commit `20e01cebc77a0142260f3e0a6b3e9c66228ef3bf`; reproducible tar SHA-256 `47ab326dbcd45043b826f14515c69194c1cfb45873c8bbd405e78bf8939e4355`; inventory in `hardware/source.sha256`. Archive retains its complete source license/notice bundle. |
| Exact measured compiler | Private 39,110,547-byte executable, SHA-256 `04560fb216755aa152b91f634c92e79175e492acd313991009c2e0429f7f4a68`; build/environment and dynamic dependencies retained. No public binary release or runtime library payload is included. |
| `main.preprocessed.c.gz` | **PRIVATE on the measurement host; not uploaded.** Mixed Buster/Clang/system source. Compressed SHA-256 `7fdf827765903b13315c62afd3b06a7982192a462ded50563e0d9e5d031281d3`, 6,581,074 bytes; uncompressed digest and host path in `hardware/`. |
| `main.d`, `main-inputs.txt`, `main-inputs.sha256` | Final exact input/header paths and hashes retained; original Make dependency inventory is authoritative. |
| External toolchain / resource headers / linker | Official Clang 23.1.4 archive/executable and Wild hashes in report; all final 378 external header identities match the audited inventory byte for byte. |
| System headers / external libraries | Actual host glibc/Linux-header package versions, ownership and license texts under `external-inventory/` and `licenses/`; final hash comparison succeeded. Compiler dynamic dependency names are recorded; no runtime library is bundled here. |
| Corpus qualification | Pinned c-testsuite Git identity, frozen musl/SQLite/header manifest digests, exact argv, statuses and results in `local/`; corpora remain external. |
| Qualification and timing outputs | Local and hardware packets separately identify source/compiler/commands/statuses. The 11 raw process reports and exact C-reader summary are in `hardware/postcheck/`. |

Source-only Buster material is not uniformly original: its lexer, lane and
identified helper portions retain component-specific notices and terms. The
final source's portion inventory governs. The retained Buster license texts
include LLVM, Accelerated-Zig-Parser/simdjson, Unicode, RAD Debugger, SplitMix64
and wyhash notices; they are not a new license grant or a claim that every one
is included in every artifact. Consult the final source's own inventory for the
actual included portions and mark modifications where required.

## The preprocessed source is incorporated material

Compression does not turn `main.preprocessed.c.gz` into an original benchmark
log. `-CC` retains comments and existing notices, but preprocessing expands
macros/includes, changes source layout and drops directives. This is a
mechanically transformed input snapshot; original component ownership and
license terms remain. Retain its original `#line` path mapping, input manifest,
upstream package/source identities and applicable complete notices/texts.

The [mechanical external-header audit](external-inventory/README.md) identifies
152 staged Clang headers and 226 system headers in the prior attempt: 183 owned
by glibc and 43 by linux-api-headers. Four Clang headers have explicit MIT-style
notices; their complete permission blocks are retained individually rather than
relabeled with the other headers' common LLVM SPDX terms. The exact official
Clang `LICENSE.TXT`, full host GPL/LGPL texts, Linux syscall exception and
`sys/ttydefaults.h` BSD-style notice are retained with hashes/origin paths.

Thirty glibc and nine Linux wrapper/generated headers lack explicit prefix
notices. Package ownership is established, but precise per-file inheritance and
the combined snapshot's complete source/portion map are not independently
proved by that metadata. The chosen disposition is therefore **PRIVATE**:
retain the compressed mixed snapshot on the measurement host, publish its
digests/inventories/package versions/notices, and do not upload its contents.
Final external-input comparison succeeded for all 378 files; the exact compared
inventory and receipt are in `hardware/`. The project default replaces none of these terms.

Objects produced from that unit and the compiler executable retain the terms
of their incorporated material. Compiler use alone does not relicense independent
source or output; conversely, the compiler's own binary/source distribution
needs its component notices. The LLVM exception is not a blanket waiver for
copied source, arbitrary system headers or separately bundled libraries.

## Publication completion

Before public source/binary archives are distributed, fill all final
identities and artifact dispositions, verify the notice/source inventory against
the exact archived bytes, and retain complete matching component terms. If a
large artifact is placed in an immutable release, record its asset receipt and
hash in the report. No artifact in this record should silently refer to a
discarded compiler candidate, a moving branch, a private-only copy without an
explicit disposition, or synthetic data presented as observations.
The mixed snapshot is explicitly private and must be excluded from public
copies and release assets; its retention receipt and hashes remain public.
