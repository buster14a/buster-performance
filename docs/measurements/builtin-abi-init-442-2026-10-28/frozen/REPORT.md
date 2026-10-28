# Buster #442 builtin ABI residual — qualification in progress

Target qualification is summarized in `TARGET_REPORT.md`: native functional
gates pass and isolated initialization improves clearly; whole-CLI effect remains
below layout/noise qualification after one approved warm-image repeat. Broader
timing expansion is stopped. `REVIEW_HANDOFF.md` is the concise reviewer packet.
The progress history below retains earlier local/probe boundaries and raw failures.

Source: `73b6ba60604ca3da7494375f2468b23ae7d4c258`, branch
`codex/perf-442-residual`, parent `e7f89091648f68940b595aadd648841c1ffc3ec5`.
Whole tree: `4d5e133b43f24b44808bff0015fb5b5faf27d5b8`.
The normal compiler-repository hook added its authorized DCO trailer. There is
no performance-repository commit, PR, push or host change in this record yet.
Root-approved target source staging has begun; results below distinguish every
stage. This is a bounded remainder of #442, not blanket closure.

## Reconciliation and scope

The current issue body and all five comments are preserved as
`issue-current-body.json` and `issue-current-comments.json`. Claim:
<https://github.com/buster14a/buster/issues/442#issuecomment-6477117017>.
The earlier owner's implementation and hardware acceptance are completed work:
#517 merged as `a66f8638`; its retained evidence is
<https://github.com/buster14a/buster-performance/tree/3fdc427d36380adc830f5484cc3cf5a08bd3149c/docs/measurements/lowering-scans-442-2026-10-26>.
That record includes the pre-#418 main, #418 merge, #517, later-main comparisons,
stage attribution, medians and paired variation as well as the prominent floor
tables, same-output216/different-output4 subsets, raw logs, scripts and manifests.
Its four historically differing files are 00150, 00182, 00208 and 00216. Those
historical semantics and compiler revisions are not relabeled as current results.

#610 (`00fec58e`) retains declaration metadata rather than rediscovering it.
#694 (`67d91e00`, #641) further bounds retained object/attribute initialization;
selection maps and attributed-declaration lists remain separate #641 scope.
#629 (`f6f9dc78`) bounds ABI dependency discovery with scans/topological frontiers
and skips ABI setup for a selected program without function bodies. It still
classifies the builtin prefix on every successful ABI initialization. Current
source has 42 present builtin types in 64 reserved indices, not 64 present types.

The present change replaces that repeatable classification and class-merge
construction with immutable facts projected from original project code. It
copies all seven columns after existing validation, limits the prefix to the
logical type count, patches plain-char pass/result extension in unsigned mode,
and preserves the existing pass/storage/layout tail clear. Derived rows,
completion, scratch fallback, target vector policy and dependency scheduling
stay private to the live TypeTable. Each projection is2,752 readonly bytes;
the local final ELF has five include-owned copies,13,760 bytes total. There is
no mutable process cache, lazy initialization or synchronization protocol.
The local .bss section size is unchanged; addresses move with code/data layout.

A general signature-only demand classifier is not justified by this experiment.
Lowering reads ABI facts before final call batching for by-value validation,
aggregate results, va_arg and incoming/variadic frames. #629 already bounds the
dependency work. A narrower demand policy would need a measured producer/read
frontier and its own contract/gates; this change makes no throughput claim for it.

## Original projection and provenance

`seed-generation-identities.txt` pins the original e7 input modules and original C
generator. The maintained generator is `tools/generate_builtin_abi.c`; it clears
and recomputes all facts before output, not merely prints cached columns.
`regeneration.log` records a current-source build, successful temporary output
and byte-for-byte comparison. Documentation requires compile-first, temporary
output, successful status and review before replacement, because the generator
includes the existing generated file during compilation. No external code,
dataset or implementation was imported; lane.c retains its MIT notice.

## Local gates

Host: AMD Ryzen9 7940HS (details in `local-host.txt`), not the 9700X. All commands
used the shared local allocator with two cores. Tool versions, input identities,
source hashes and allocator receipts are retained alongside these files.

- Native ABI builtin-prefix oracle: 51,259 checks, zero failures; all seven
  fields, zero holes, both char modes, widths16/32/64, logical counts0..65,
  requested capacities0..66, invalid widths/capacities, padding and tails,
  larger/rare state and first-derived scheduling. `abi-native.log`.
- Native ABI cross-link64 signatures per run: all Clang/GCC/compiled C and both
  plain-char extension runs pass. `abi-cross64.log`.
- c-testsuite frozen revision5c727565: all220 pass, scalar/vector executables
  and cross-check behavior agree. `c-testsuite-pinned.log`.
- Checker497,025 checks, zero failures. `checker.log`.
- Original standalone output/allocation-cutoff fixture: 67,536 cases pass with
  adjacent PROT_NONE pages, independent scalar recomputation, poisoned bytes and
  ASan+UBSan. `abi_init_guard.c`, `abi-init-guard-san.log`.
  A baseline x86-64 host build with signed host char also passes the same67,536
  cases under ASan+UBSan, `abi-init-guard-scalar-san.log`.
- Call graph41 translation units: no forbidden cycles or split variables.
  `callgraph.log`.
- CI source closure1171 checks, zero failures. `ci-changes-retest.log`.
- Exact current-source regeneration succeeds and matches generated facts.
  `regeneration.log`.

The initial CI closure run caught the relative include spelling not followed by
the selector; its failed log is retained as `ci-changes.log`. The corrected
project-root include and explicitly named generated consumer pattern pass. The
first c-testsuite command used a missing historical corpus path and exited1;
`c-testsuite.log` preserves it; no test results are inferred from that run.

Pre-freeze candidate binary was b3ad8760d5ebc14eca31269bd5376f7aee1fe09c67bd22d8dcb84b4236b44511.
The last production edit was equivalent include-path spelling; other subsequent
edits were comments/docs/CI. The exact frozen source was rebuilt with local
Clang23.1.4/native/debug1: binary
`c10cb3b416a8d89f2a8017f86f289079894879d1b03816184eb3e96064768280`,
41 sources/167.7s. Final cross400 passes (`frozen-abi-cross400.log`). All220
baseline/head objects by scalar/vector paths are byte-identical
(`frozen-four-path-objects.log`). All four SQLite objects match
`1cafbadf926eed2245cb6a81ac1ee511f42d300995c2b2144c98e495d8c394d6`
(`frozen-sqlite-objects.log`). The exact maintained frozen musl symbol gate
compares354 of354 required, with zero differences/unexplained/failures;
613 files,574 accepted on each side, no acceptance or diagnostic differences
(`frozen-musl-symbols-exact.log`). These are Zig0.14.1-vendored musl1.2.5 bytes
with documented patches and the frozen copy-only overlay, verified against
their retained manifests. The initial symbols command mistakenly used an
unrelated directory list and failed before any file was compared; it remains
`frozen-musl-symbols.log` and is not treated as a qualification result.

## Local performance screens, not acceptance claims

`abi_init_samples.c` is an original isolated initializer with an opaque memory
consumer after every call, fixed output checksums, no allocations in its timed
loop and a separate warmup. One binary includes pure e7; the other the candidate.
They use matching local Clang23.1.4/O3/native/debug1 flags. Five alternating
ABA/BAB rounds are CPU-pinned; larger reservations use ABA controls. Raw data:
`abi-init-local.tsv`, allocator/command receipt: `abi-init-local.log`.
Means/ranges are in `abi-init-local-summary.tsv`.

At capacity64 across both char modes and all widths, baseline mean cost is
885–918ns and candidate36–41ns per initialization. At capacity256 it is906→62ns;
at4096 it is1299→480ns. Capacity65536 retains the tail-clearing cost. Every output
checksum agrees within its configuration. This hot repeated helper excludes
process startup, type construction and all lowering; it is not a whole compile
or a modern reproduction of the historical25ns remainder.

**Rejected flag-confounded screens:** root subsequently confirmed shared local
e7 binary523ceb8d was built with debug0, while candidate/pre-freeze binaries use
debug1. The local whole-path and fresh-exec screens below are retained negative
method evidence and excluded from performance conclusions. The standalone
initializer helpers above were each explicitly compiled with matching -g flags;
that separate isolated comparison is not affected.

`lowering-local-ROUND-ROLE.txt` screens all220 c-testsuite files with checking
outside the timed region,101 passes per file, three CPU-pinned base/head/baseagain
rounds. Candidate sums of per-TU medians are4.843/5.014/4.986ms; paired baseline
means5.074/5.354/5.188ms. All counts are identical and failures0. Baseline drift
reaches about5%; the debug0/debug1 mismatch independently invalidates performance
attribution. Selective/all modes remain within-tree comparisons. Their
differences are never labeled candidate versus main or whole-process gains.

`fresh_process.c` records original per-child fresh-exec wall/user/system/RSS,
faults, context switches, exit and output-byte counts. Its real-compiler positive
control passes; exit0/missing-object and nonzero-child controls are rejected.
`fresh-local-*.tsv/.stderr` retain192 samples per role/case for function, char,
aggregate and no-body cases. Candidate peakRSS is roughly1.85–1.97MiB higher,
including the no-body control where ABI initialization is skipped; minor faults
are lower. The mismatched debug builds and fixed order prohibit an ABI memory
or whole-process performance inference from those samples. The matching target
comparison must include this negative control and whole-process costs.

## Pending target boundary

Root approved `target-plan.md` after exact-source local gates and common official
baseline QA passed. `target-bundle.tar` is an exact source archive plus original
helpers, with710 content hashes, SHA256
`5dcd097ad2485e18b31e86d3adf3919b05815831a9e33d720a15ce6cfc22ef88`.
Its private target extraction completed under the shared lock and verified all
content hashes (`target-stage-command.txt`, `target-stage.log`). Toolchain and
baseline verification is queued behind shared CI; no candidate build or timings
have run. Further commands/receipts remain separate from local screens.
Match root's official Clang23.1.4, BUSTER_HOST_ARCH=native, BUSTER_DEBUG_INFO=1
and immutable e7 baseline06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e.
Every build/test/benchmark must take the shared lock separately, with matched
affinity and bounded runs. Include both post-checking220-file distributions and
fresh-process function-containing tiny cases/SQLite, A/A drift, rodata/minor
fault/system/RSS costs, object bytes and the frozen symbols gate. The object-only
fixture is a negative control because #629 skips ABI initialization there.
Until those controls pass, there is no target throughput/neutrality claim or PR.
