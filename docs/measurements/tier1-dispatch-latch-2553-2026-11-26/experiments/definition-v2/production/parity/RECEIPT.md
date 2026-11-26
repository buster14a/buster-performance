# Final production executable parity for #2553

Both generated executables from the normal hosted production Release compiler have exactly the same SHA-256 hashes as the measured definition-v2 executables. This connects the published measurements to the final production PR, including the newer main revision present in the hosted merge build.

| Program | Published measured SHA-256 | Production-generated SHA-256 | Result |
| --- | --- | --- | --- |
| SQLite speedtest1 | `759ed0915408672ec6a77b08fcd5fa18194b7ec80bc5f189922208e6717e3383` | `759ed0915408672ec6a77b08fcd5fa18194b7ec80bc5f189922208e6717e3383` | PASS |
| Lua 5.4.8 | `50b8a16f39c4475c4c1a933e0ae8c326c10d23b2b5a23cddaebc05a76587770b` | `50b8a16f39c4475c4c1a933e0ae8c326c10d23b2b5a23cddaebc05a76587770b` | PASS |

The reference hashes are from [the published definition-v2 evidence at performance commit 8c5987b](https://github.com/buster14a/buster-performance/tree/8c5987b19e9a150e3a856e08b2f0752a57585ee2/docs/measurements/tier1-dispatch-latch-2553-2026-11-26/experiments/definition-v2). This is a fresh cryptographic hash comparison against that record. The previously measured ELF files were lost when the transient execution environment reset, so this receipt does not claim a fresh direct file comparison against those files.

## Production provenance

- PR: [buster14a/buster#3631](https://github.com/buster14a/buster/pull/3631).
- Final production head: `171b5cddb405beef37cfba0489d729584703fc8f`; tree `a4e8daa4ff6469aa48e0704a924df45307fdcb0d`.
- Normal hosted CI: [run 45809145116](https://github.com/buster14a/buster/actions/runs/45809145116); product builder job `139872948258`.
- Actual hosted synthetic merge: `96609e4add048cb4a471d01b46d8ed2d7300828d`; tree `43624317b9d314763a03f9c6bd12e1efce0d19d6`.
- Verified merge parents: `74eacd4744a8131ba4c1a5bd8ad87b89ec0f7dbe` and final PR head `171b5cddb405beef37cfba0489d729584703fc8f`.
- Artifact `15111291560`, named `vector-product-O3-1-none-50ed988667e04b725872a72201fbd8d224456d21a069115f143540288df400ed`.
- Compiler SHA-256: `176fa03e2272e93fda2f57091d0459815c7c06093a893dd5986fac4d116719a2`.
- Product row: `vector none O3`, `BUSTER_BAKE=1`, `BUSTER_RELEASE_PARTS=0`, empty `BUSTER_BUILD_DEFINES`. This is the normal uninstrumented production product.

The actual hosted merge includes a newer main revision than the original measurement base. The exact generated-program hash matches above establish the relevant output identity despite that source-tree difference.

## Artifact verification

The artifact ZIP hash matches the GitHub digest `d4dd5934e57f20b92304c8a9c0477caf411403fb1707a2d6ed579710a6ecbbdf`. ZIP CRC validation passed, and the ZIP contained exactly `product.tar.zst`. Its hash is `50ed988667e04b725872a72201fbd8d224456d21a069115f143540288df400ed`, matching the artifact name.

All tar paths were checked for traversal or unsupported member types. Every regular file was hashed while streaming extraction; the complete file set and all 16 entries in `product/files.sha256` matched. The compiler and product metadata were retained; the unused clang-server and preprocessor oracle were verified without keeping another extracted copy. `product-verification.tsv` records every file digest and retention choice. `archive-verification.json` records the archive checks.

## Compilation and resource-header provenance

Compilation used the existing `compile-workloads.sh` recipe without changes, with `LC_ALL=C`, `--tier1 --lanes 1 -fno-asynchronous-unwind-tables --tier1-report`, the same SQLite defines, the same Lua source order and feature defines, and fixed Lua seed `luai_makeseed(L)=0x2768u`. Exact executed compiler commands and full successful compiler reports are in `workloads/`.

The original local Clang 23.1.4 resource cache disappeared during the transient environment reset. This final parity compilation explicitly used the complete surviving frozen Clang **23.1.1** resource-header tree from the pinned input corpus:

```
BUSTER_CLANG_RESOURCE_DIR=/workspace/scratch/dfc32981403d/inputs-2553/corpus/headers/usr/lib/clang/23
```

The copied corpus provenance identifies that tree as Clang 23.1.1. It is not represented as a recovered 23.1.4 tree. The production compiler itself was built by hosted Clang 23.1.4, as documented by its verified product identity. The local resource-header variation did not alter either generated executable hash. `resource-headers.sha256` inventories every supplied resource header; `workload-inputs.sha256` inventories the workload source inputs. Original corpus and pin provenance is retained alongside this receipt.

The final compilation invocation was:

```sh
BUSTER_CLANG_RESOURCE_DIR=/workspace/scratch/dfc32981403d/inputs-2553/corpus/headers/usr/lib/clang/23 \
  bash /workspace/scratch/dfc32981403d/validation/compile-workloads.sh \
  /dev/shm/buster-2553-production-v2-product/product/bin/compiler \
  /workspace/scratch/dfc32981403d/validation/production-v2-parity/workloads
```

Both commands exited successfully. SQLite compiled all 2,709 requested functions with Tier1 and zero fallbacks. Lua compiled 1,086 of 1,087 requested functions with Tier1, reporting one lowering fallback, as in the original baseline report. Both reports have zero resource or internal failures. The final ELF files are omitted from this evidence bundle; their hashes and sizes are recorded in `generated-program-parity.tsv`.

## Scope

No new native workload or Callgrind run was needed: exact generated-program identity connects this production build to the already verified native outputs and dynamic counts in the published evidence. No Benchpress/9700X hardware was accessed or queued. This receipt establishes production-output parity; it does not add an elapsed-time performance claim or assert that all remaining requirements of #2553 have been met.

The final normal hosted CI evidence and DCO audit supplied by the root task are included as `production-v2-ci-final.json` and `dco-v2-audit.log`. The final CI record reports 22 successful jobs and 17 skipped jobs, including a skipped native Benchpress job with no runner assigned.

`SHA256SUMS` covers every file in this frozen evidence bundle except the manifest itself.
