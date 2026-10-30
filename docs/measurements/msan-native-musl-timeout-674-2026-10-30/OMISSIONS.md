# Retained locally, omitted from this package

| Artifact class | Retained identity/context |
| --- | --- |
| Buster source tar and full 803-file source tree | Exact public source/tree; source-before manifest and source pre/post logs; tar hash in trusted-input receipts. |
| Compiler, probe, C controller/fixture and old supervisor executables; generated objects | `READ-BINARY-IDENTITIES.sha256`, utility/supervisor identities, build/compile receipts and actual C sources. |
| Official LLVM archive and installed toolchain payloads | Archive `efdd1dbd…5e0378`, stage receipts, all 9,177 staged regular-file hashes, symlink metadata, versions/license and independent verification. |
| Frozen corpus and system-header contents | Original archive pin, component manifests, selected 613-source inventory and trusted/staging verification. Corpus metadata README refers to that external archive. |
| Private oracle-cache and temporary payloads | Cache paths/hashes, observed cache counters and successful bounded cache receipt; no shared-cache deletion. |
| Original hosted artifact ZIP | Original hash `e00fb2c3…912cb`, member listing and seven exact text-member comparisons. Its probe executable is omitted. |
| Full mixed host/compiler/header macro dumps | Original small-file hashes, raw independent verification and selected first-party host-vector predicates. |
| Superseded Python inspection helper, unexecuted review-initial drafts and future-comment draft | Local originals and small-file hashes; actual C producer/control code and executed phase receipts are included. |

No payload is silently replaced by a generated stand-in. Producer manifests may reference
these omitted paths; those original identities are preserved, not portable package checks.
The failed hosted compiler, active-file/phase receipt and stack sample were never retained
by that original artifact, so this packet cannot reconstruct or diagnose them.
