# Immutable builtin ABI initialization: bounded #442 evidence

This records compiler source [`73b6ba60604ca3da7494375f2468b23ae7d4c258`](https://github.com/buster14a/buster/commit/73b6ba60604ca3da7494375f2468b23ae7d4c258), based on `e7f89091648f68940b595aadd648841c1ffc3ec5`. It is the remaining builtin-initializer experiment in [compiler issue #442](https://github.com/buster14a/buster/issues/442), following the completed #517 work. It does not close the broader issue, deliver signature-demand classification, or measure later main compositions.

The frozen candidate copies all seven canonical builtin ABI columns and the merge table, then adjusts plain-char extension flags. It preserves bounded prefixes/capacities and caller-owned derived classification. The review decision weighs roughly **0.47–0.48 microseconds saved per hot 64-row initialization** against **13,760 bytes of read-only table copies in the local ELF** and the generator/oracle maintenance. Whole-compiler benefit and a neutral equivalence bound remain unqualified.

| Evidence | Disposition |
|---|---|
| Locked 9700X isolated initializer: 486.55–503.23 → 18.18–19.42 ns | Clear improvement in repeated initialization, excluding allocation, type construction, lowering and process startup. |
| Exact frozen native correctness and output controls | Pass: ABI cross400, 67,536 guarded cases, checker497,021/0, c-testsuite220/220, scalar/vector baseline/head object equality, SQLite four-path equality, frozen Zig-vendored musl symbols354/354. These gates establish only the recorded revisions. |
| Local whole-path/fresh-exec screens | Rejected for mismatched debug0/debug1 builds; raw observations and their dispositions are retained. |
| First target fresh-exec pass | Unequal image priming and first-image major faults; complete data retained, with no attribution conclusion. |
| One corrected warm-image/new-exec repeat | Every image primed, all samples retained. Function cohort medians move −0.53% against A/A, while the no-body control also shows apparent improvements in means. Layout and noise prevent a general CLI claim. |

Start with [the target report](frozen/TARGET_REPORT.md), [local methods and rejected evidence](frozen/REPORT.md), and [the review handoff](frozen/REVIEW_HANDOFF.md). Top-level frozen logs, command receipts, summaries and original C helpers are also browseable under `frozen/`.

## Complete raw records and reproduction

`archives/frozen-receipts-and-methods.tar.zst` expands to the original relative evidence tree's text records and methods, including raw child rows, perf CSV, diagnostics, local rejected screens, helper sources and the exact source patch. There is no trimming of unfavorable timing samples. Root-level publication-composition logs are kept separate when added; they are not frozen timing evidence.

The following are lossless compressed copies of the **original tar byte streams**. Their decompressed SHA-256 values are in `ARCHIVES.original.sha256`:

- `target-first-results.tar.zst`: complete first-pass native results, including all retained object payloads and SQLite object proof.
- `target-warm-results.tar.zst`: complete corrected warm-repeat results and emitted tiny-fixture objects.
- `target-bundle.tar.zst`: exact staged compiler source, baseline module inputs, original helpers and run recipe. The source archive includes its license, component notices and `LICENSES/` files.

`SHA256SUMS` verifies this published tree. `original-payloads.sha256.zst` inventories the original local evidence tree, including payloads not duplicated here. Local c-testsuite object trees, helper executables and sanitizer-runtime binaries remain retained locally rather than redistributed; their hashes and output-comparison receipts are preserved. The native result archives above retain their full original payloads. Frozen compiler binaries are identified by hashes and reproducible source/toolchain receipts rather than bundled.

For example, after checkout:

```sh
sha256sum -c SHA256SUMS
mkdir raw
tar --zstd -xf archives/frozen-receipts-and-methods.tar.zst -C raw
zstd -dc archives/target-first-results.tar.zst | sha256sum
```

Use the archived commands with their exact source, official Clang23.1.4/native/debug1 build, frozen inputs and CPU placements. Every substantial target operation requires the existing per-run shared lock. Local multicore work requires the owner's `cores` allocation. No hardware or host settings were changed.

The projection and campaign helpers are original project work. Archived compiler source retains its original/component terms and notices; `lane.c` retains its MIT grant. External Clang/GCC, c-testsuite, the frozen SQLite source and Zig-vendored musl were tools or qualification inputs, with exact identities and limitations recorded. No external implementation was copied into the compiler change. This performance-repository publication carries no human DCO trailer under the compiler-only standing certification.
