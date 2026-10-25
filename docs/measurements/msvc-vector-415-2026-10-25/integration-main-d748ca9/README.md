# PR 415 current-main integration qualification

This report addresses the [second review](https://github.com/buster14a/buster/pull/415#pullrequestreview-5643018821) of PR 415. The earlier [performance acceptance report](../review-acceptance/README.md) qualified original `e60251d` against PR head `cf147dc`. This supplement checks the native executable produced by integrating that head with the newer main snapshot below.

- Main: `d748ca959b3726593897fe7678169d1b2f91351c`.
- Unchanged PR head: `cf147dc3257615680a7e694ffc25d87a3cc2576b`.
- Fresh synthetic merge tree: `0911ada13673e6807c4764b4a29f8e94ad556aa8`.
- Construction: `git merge-tree --write-tree d748ca959b3726593897fe7678169d1b2f91351c cf147dc3257615680a7e694ffc25d87a3cc2576b`, which completed without conflicts.
- The integration changes only the same two compiler implementation files as the PR. The unused parser typedef is replaced with a comment of the same line count; all newer main changes are retained. Exact merge inputs, the resulting tree identity and all source-file manifests are retained here.
- Main's [9700X CI](https://github.com/buster14a/buster/actions/runs/40190862482) passed for this main revision. The PR head's [9700X CI](https://github.com/buster14a/buster/actions/runs/40180197108) also passed.

**Passed:** current main and its fresh synthetic integration with PR 415 produce **byte-identical complete native compiler executables**, including all native code and read-only data. This satisfies the second review's integration-identity acceptance branch and carries forward native performance preservation for this main/head pair. Additional timing runs were not required by that branch.

## Build and comparison method

Both trees were independently exported with `git archive`, transferred to the approved Ryzen 7 9700X, and built using `env BUSTER_DEBUG_INFO=0 ./build.sh`. Each build held the shared `exclusive.sh` lock separately. The build uses Clang `-O3 -march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror` and the installed Wild linker. Compiler/linker versions and identities, complete compilation commands, CPU and kernel state, source manifests, logs and exit statuses are retained.

The comparison is a separate operation under the same shared lock. It hashes the original executable files before and after inspection and compares the complete files without normalization. GNU objcopy extracts `.text`, `.rodata` and `.data.rel.ro` into separate files while writing a separate inspection-copy ELF. The original executables are not passed as output files or modified. Each section's length, SHA-256 and comparison exit status is retained.

The `.data.rel.ro` comparison includes the compiler's pointer-rich tables that become read-only after relocation. Complete executable equality additionally covers every other file section and its metadata. The binary and section bodies remain reproducible outputs on the measurement host; this archive retains comparison receipts and hashes rather than distributing another compiler binary.

| Artifact | Bytes in each build | Shared SHA-256 | Comparison exit |
| --- | ---: | --- | ---: |
| Complete executable | 35,477,836 | `3d15d48fc37df41975cd51c08382f42d09ac1ae93f051b04c7a2767d0a39830a` | 0 |
| `.text` | 20,238,738 | `00f327dfb34697f1faa3d28c8836b18dfbfe31d73f03ffd063f56375685c2469` | 0 |
| `.rodata` | 3,523,416 | `2a9a9621ec7f3259da94ed030e1e13adcdac5215b4658c99b4b0abc7645c6190` | 0 |
| `.data.rel.ro` | 10,893,136 | `b181e48bcdd356dcd134f29ac589bc14c2cb78618f59180c00c8772c03f184a6` | 0 |

Both 42-translation-unit builds exited successfully. The original executable hashes were unchanged by section inspection. Source manifests contain 587 regular files in each tree and differ only in the expected two compiler implementation files; `source_manifest_diff_exit=1` records that deliberate source difference. The machine-code and executable comparisons all exit zero.

The prior absolute benchmark timings remain qualified to their original e60251d/cf147dc pair. This new result establishes that the PR adds no native instruction, allocation or layout change when applied to d748ca9; it does not reuse those old absolute timings as measurements of the newer compiler. Main was checked again after the builds and still named d748ca959b3726593897fe7678169d1b2f91351c.

## Reproduction

Check out or archive the exact main revision and construct the exact synthetic tree shown above. Run each build separately on the approved host:

```sh
EXCLUSIVE_OWNER=msvc415-main EXCLUSIVE_TITLE=PR415-integration EXCLUSIVE_LINK=https://github.com/buster14a/buster/pull/415 \
  ~/buster-fast-bench/exclusive.sh env BUSTER_DEBUG_INFO=0 ./build.sh
```

The same command is used from the synthetic integration root. `comparison-command.txt` contains the precise section-extraction and comparison commands, run from the common parent directory under one shared lock as one comparison operation.

## Scope and retained provenance

This is a fresh, local synthetic-integration qualification for the exact main/head/tree identities recorded above. It does not update or rebase the PR branch, merge the PR, or certify a later main revision. The previous frozen-input lexer and downstream timing report remains retained unchanged.

The original measurement reports and receipts follow this repository's existing project terms. No new third-party implementation or runtime input is incorporated by this supplement. Compiler outputs are inspected externally; the compiler source retains its existing component notices. Shared-lock queue notifications are kept privately on the host, separate from the retained build/comparison outputs, so unrelated session commands and links are not published.

The existing Windows-target `clang-cl` COFF probe and forced-intrinsic Linux correctness checks retain their original scope. Native Microsoft `cl.exe`, a full Windows SDK compiler build and native MSVC performance remain unverified.
