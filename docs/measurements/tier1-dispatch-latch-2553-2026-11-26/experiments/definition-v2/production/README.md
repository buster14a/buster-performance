# Final production CI and emitted-program identity

This record connects the measured allocator to the production PR's uninstrumented CI compiler.

## Production source and CI

- PR: [buster#3631](https://github.com/buster14a/buster/pull/3631).
- Final source head: `171b5cddb405beef37cfba0489d729584703fc8f`, tree `a4e8daa4ff6469aa48e0704a924df45307fdcb0d`.
- CI synthetic merge: `96609e4add048cb4a471d01b46d8ed2d7300828d`, tree `43624317b9d314763a03f9c6bd12e1efce0d19d6`.
- Merge parents: current main `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe` and the final source head above.
- [Hosted CI run 45809145116](https://github.com/buster14a/buster/actions/runs/45809145116), attempt 1: **success**; 22 successful jobs and 17 skipped jobs.
- Integration qualification: success. Native tests and benchmarks on Benchpress: **skipped**, with no runner assigned. No native job was accessed or queued.
- [ci-run.json](ci-run.json) records every job's result and exact source identity.
- [dco-audit.txt](dco-audit.txt) records both PR commits having sign-off records, with no missing trailers or trailer findings.

The synthetic merge includes unrelated main changes that landed after the measurement baseline. Matching emitted-program identities below verifies that those changes and the normal uninstrumented compiler build do not alter these measured programs.

## Product verification

The normal hosted CI artifact is `15111291560`, ZIP SHA-256 `d4dd5934e57f20b92304c8a9c0477caf411403fb1707a2d6ed579710a6ecbbdf`. Its enclosed product tar.zst has SHA-256 `50ed988667e04b725872a72201fbd8d224456d21a069115f143540288df400ed`. All 16 manifested files matched their recorded hashes. Product identity names the synthetic merge and tree above.

The compiler executable SHA-256 is `176fa03e2272e93fda2f57091d0459815c7c06093a893dd5986fac4d116719a2`.

The [frozen evidence archive](parity/production-v2-parity.tar.xz) retains the full product metadata, checksums, compilation commands and reports, resource-header and workload-input manifests, and verification receipts. [archive-manifest.json](parity/archive-manifest.json) identifies that archive; its internal SHA256SUMS covers all retained evidence files.

## Emitted programs

The normal production compiler emits both programs with exactly the published measurement SHA-256 identities:

| Program | Production and measured SHA-256 |
| --- | --- |
| SQLite speedtest1 | `759ed0915408672ec6a77b08fcd5fa18194b7ec80bc5f189922208e6717e3383` |
| Lua | `50b8a16f39c4475c4c1a933e0ae8c326c10d23b2b5a23cddaebc05a76587770b` |

[The parity receipt](parity/RECEIPT.md) records exact commands, flags, product/source identity and header provenance. The final compile used the surviving Clang 23.1.1 resource headers after the execution environment reset removed the earlier Clang 23.1.4 resource cache. This fallback is explicit in the receipt; the emitted program identities still match exactly.

This is a SHA-256 comparison against the already-published measured identities. The measured executables were no longer present locally after the reset, so this record does not claim a new direct `cmp` of those files. The raw measurement traces and checksums had already been preserved before that reset. No additional workload execution was needed once the emitted identities matched.

The measured reference hashes and raw instruction-count evidence were published before this check at performance commit `8c5987b19e9a150e3a856e08b2f0752a57585ee2`. This check does not rerun Callgrind or claim additional native timing. The issue's 9700X placement qualification remains unmeasured, the PR remains draft, and #2553 remains open.

---
Agent session: 6b07eefe-ecbc-83eb-8e50-5060ad2a8075 (OpenAI session ID; no share URL is exposed)
Model: OpenAI / GPT-6 Astra Pro
