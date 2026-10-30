# PR #146: recorded workload binding and observation scope

**The retained packet and release do not provide a contemporaneous check binding the SQLite source, pinned predefines and header bytes consumed by the new profiles to the declared frozen workload.** This note narrows that attribution. It adds no historical verification and does not establish the missing frozen-workload predicate or automatically clear source #914 / issue #893 acceptance.

This is an additive response to [review 5714797424](https://github.com/buster14a/buster-performance/pull/146#pullrequestreview-5714797424). The original packet is unchanged. Its README line34 assertion about recorded SQLite/predefines hashes and its later acceptance conclusion remain inspectable as historical text, rather than being silently rewritten or taken as current unqualified conclusions.

## Immutable original record

- Original evidence head: `c1fb29a2e9139f41935429c21875073b47c5bd66`.
- Original full tree: `8a91401f090d85731df1610ac12d02497b8f079e`.
- Original packet: `docs/measurements/intrinsic-filter-914-acceptance-2026-10-30/`, tree `3fd2d0b020cf9d24303d44f1dda8455c709dc10d`, all 199 files and modes preserved.
- Original [README](https://github.com/buster14a/buster-performance/blob/c1fb29a2e9139f41935429c21875073b47c5bd66/docs/measurements/intrinsic-filter-914-acceptance-2026-10-30/README.md): SHA-256 `19139d9a5c10027ae8c009bd14ce4956c72e3be8a662818b49ed235fb45c0943`.
- Original `SHA256SUMS`: SHA-256 `c045f2e49f2face2f31de5b6649805ec4d5693fdddbdd6d2b628546a296d9adb`. Its 198 entries and the manifest itself are not regenerated.
- Original `release-assets.sha256`: SHA-256 `d4162d198b83631bc47b1cd00d23006b212109054be6794e95889c8418ea04e3`.

The [original release](https://github.com/buster14a/buster-performance/releases/tag/intrinsic-filter-914-acceptance-2026-10-30-58b11915), ID 429193931, retains tag `intrinsic-filter-914-acceptance-2026-10-30-58b11915` pointing to original c1. These are the same seven uploaded assets, names, byte sizes and published SHA-256 digests; this note changes none of them:

| Original asset | Asset ID | Bytes | SHA-256 |
| --- | ---: | ---: | --- |
| `base-safe-p1.perf.data.zst` | 692538321 | 13926734 | `f1bf71ea812ce3c5783d88cec6c47b5fbc15f5e233872c7427badba3618daec3` |
| `base-safe-p2.perf.data.zst` | 692538314 | 13916041 | `8f5508f65c0bcf853755bff48b4b6c9cfd78e54b65d7a4a5e2213c9561815e72` |
| `base-safe-p3-retry.perf.data.zst` | 692538313 | 13991690 | `e1a360c17e422ce9c5e7f47d3848a5a8459b03f8b5798c46a3f4a697491dcef1` |
| `head-safe-p1.perf.data.zst` | 692538319 | 13817718 | `6b1a0b62ea98c11cabf9de58f55397d8ac89fbced4d75b384999904331d01173` |
| `head-safe-p2.perf.data.zst` | 692538322 | 13777690 | `9b85046832bb0a82a733a56a46b0e3a1ba14e88afc5223f1565c5dbf8628a7f5` |
| `head-safe-p3-retry.perf.data.zst` | 692538566 | 13851663 | `e764b8c33e47a9edc227aa32afa92dad88e61fdfc36a12cf8fa3962df43db73b` |
| `matched-buster-binaries.tar.zst` | 692538588 | 21675015 | `ebd592fd6f5bcb0b6c6fbabc67cb49d09bf3bb8937fa7b2371666d2ba36d986a` |

The six accepted minimal-environment captures, original compiler archive and its notices/compile arguments remain intact. No new asset, recapture, binary normalization, tag move or release replacement is part of this note. Rejected/failed historical receipts remain in their original retained locations; no excluded capture is promoted into the accepted whitelist.

## What the identities do and do not bind

The packet freezes decoder/adapter/aggregate sources and executables, runtime libraries, the measured compiler binaries and raw perf-capture bytes before the final offline analysis. Its before/after checks support those specific analysis inputs and the interpretation of recorded samples. A capture hash identifies the recorded samples, not the source, predefines or headers consumed by the compiler.

For the new SQLite profiles, `tools/sqlite-once.sh` specifies frozen-corpus paths and flags without retaining a contemporaneous SQLite/predefines/header-content check tied to these executions. The original packet and seven assets do not supply that workload-binding receipt. The binary archive's source pins, compile arguments and licenses identify the compilers; they do not add the consumed workload files or their execution-time verification.

Fixed paths, older expected corpus hashes, currently observed file hashes or equal generated objects cannot retroactively verify the input bytes of these new runs. Equal outputs remain useful correctness evidence but can coexist with different comments, declarations, identifiers or preprocessing work, which can affect the catalog work being measured. No actual mutation, wrong arithmetic, fabricated capture or wrong-code result is alleged.

An authentic existing contemporaneous verification receipt covering the consumed SQLite, predefines and headers and demonstrably tied to these profiles is preferred if retained. Such a receipt can be independently reviewed; this note does not claim that no private receipt exists. A newly computed or rebuilt identity must not be represented as the missing historical check. No new campaign or recapture is automatically requested.

## Retained observations and acceptance boundary

Original source/binary identities, the actual command-at-path executions, raw CFI/saved-return and caller-to-PLT/GOT proofs, matched-work family definition, control outcomes and all numerical tables remain unchanged and reviewable. The lower sampled periods in the recorded initializer/outlined-lookup family and its proven `memcmp` callers are bounded observations of those recorded executions. They are not proof of the full exact-frozen-workload A/B predicate, exact accumulated function counters, a complete inclusive initializer interval or later-main runtime qualification.

The separately bound 220-unit c-testsuite correctness and complete timing observations retain their own scope. Per-unit mixed results, raw precision, ordering/copy limits, sampled-period uncertainty, unknown/other-callee coverage and all failed/rejected controls remain as recorded. Nothing here upgrades them to universal neutrality, placement robustness, balanced per-unit A/B, a new A/A floor or a whole-compiler throughput claim.

This editorial limitation can correct the paper's provenance/precision assertion. It does not manufacture the missing SQLite/predefines/header fact and must not be used alone to clear source #914's mandatory #893 performance criteria. Source reviewers and the maintainer must explicitly assess the remaining predicate; source correctness, certification, owner readiness and normal live merge gates are separate decisions.

All historical #140 packet files and its accepted helper-binding addendum remain unchanged and separate. Its expected input identities, old shipping results and qualified helper observations are not relabeled as verification of these new executions. No source code, historical README/manifest, raw value, control, license or input identity is rewritten by this additive note.
