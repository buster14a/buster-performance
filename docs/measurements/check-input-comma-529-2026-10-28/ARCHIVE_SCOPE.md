# Archive scope and retention

This folder publishes original methods, full raw text receipts, source patch,
identities and summaries. It does not distribute compiled compilers, generated
ELF objects/executables, captured assembly, pinned system header trees or perf.data.
Those large payloads remain private and unchanged at the paths below, with
SHA256 and byte-size inventories. A text archive is not a full native payload
backup; the hash inventory establishes identity, not public availability.

- Local retention: `/home/david/Documents/Codex/2026-10-28/solv/work/evidence-529`.
  `archives/local-text.tar.zst` preserves the selected original relative text
  paths, including raw local failures, diagnostics and generated adapters.
  `local-payload-SHA256SUMS` and `local-payload-sizes.txt` inventory excluded
  local compiled/object/perf/archive payloads.
  This inventory has756 entries totaling453,933,296 bytes; entries can include
  archived copies of the same material and are not deduplicated storage usage.
- Native retention:
  `/home/david/buster-fast-bench/unclaimed-perf-20261028/issue-529-b8ee-clang2314`.
  `archives/native-text.tar.zst` preserves the closure-selected native text
  paths. Its `payload-SHA256SUMS` and `payload-sizes.txt` inventory the retained
  native ELF/object/assembly and prior-build archive payloads, including both
  rejected frontend padding sets, uncorrected zero controls, corrected zero
  controls and all six actual placements per role.
  This native inventory has346 entries totaling9,435,206,948 bytes; entries
  include redundant controls and are not deduplicated storage usage.
- Immutable shared native baseline:
  `/home/david/buster-fast-bench/unclaimed-perf-20261028/integrated-e7-672-clang2314/compiler-native`.
  Its SHA remains `06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e`.

The native archive prunes the full `head/` source tree; its source manifests,
exact revision/patch and actual compile commands reconstruct source identity.
The local archive prunes `target/base-source-hash/` (an unchanged source copy)
and the duplicate native archive extraction. It has1,226 members, while the
native text archive has688 members. Shared frozen tool/header/input manifests
are browseable in `raw/identity/`, reused from already-local exact-baseline
evidence as `manifest-reuse.txt` records.
The local archive includes streamed timing logs absent from target files; the
four final cohorts are also browseable under `raw/layout/`. Archive member paths
retain their original working-tree form. Paths in historical receipts therefore
refer to the retained originals, not to a flat browseable folder here.

The final accepted record is exactly648 measured rows plus216 warm-ups; Stage1's
198 measured whole processes and15 reader processes remain separate. Failed
harness attempts, absent `/usr/bin/time`, failed-closed ELF controls, ineffective
padding, the cold x87 alias analysis, all A/A/copy tails and local RSS costs are
retained. None is silently promoted to a qualifying result. `SHA256SUMS` covers
every published file except itself and can be checked from this folder.
