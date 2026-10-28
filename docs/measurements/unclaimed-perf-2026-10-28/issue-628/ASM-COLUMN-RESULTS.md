# #628 empty assembly-ID output column

Frozen source slice: `dc15a18ed3ad273888ae1cb87e903969e876acfa`, on parser+416
head `1b98b195139a114c9b5da6cf7f82c083ce14c165`. The separate parser patch is
`050dbfcde5687c339a7a2ea33237e5667162d01e`; this report isolates the additional
assembly-ID change. No stream payload, graph-leaf, reader-walk policy or
reader-internal arena format is changed.

The parser's OPEN_ASM statement-group count proves whether token IDs can exist.
Assembly linkage labels contain ASM keywords but do not require IDs: the pinned
SQLite input has 716,157 tokens, 45 ASM keywords and zero statement groups.
The absent column saves a 2,864,632-byte reservation and its explicit fill.
The original keyword-based statement capacity, diagnostics and statement-array
allocation are preserved. Requested scalar parsing retains a fully initialized
dense ID array as an oracle. Unknown roles with ASM keywords retain the legacy
allocation. All consumers use a zero accessor or a guard before vector pointer
arithmetic; deferred remapping skips an absent column. No fresh-zero or global
arena high-water assumption is used.

An independent review by the region/control-flow owner found no source defect
in the proof, consumers, deferred ownership, pointer bounds, scalar oracle or
dirty/borrowed arena contract. No source edit was made by that reviewer.

## Correctness

- Release: all 41 units built, local and native.
- Full checker: local 464,841 checks with only the four known fpclassify oracle
  disagreements; native 464,841 checks and zero failures.
- Assembly/Clang corpus: 1,010 checks, zero failures, 632 sources, both local
  and native. Six focused source paths distinguish no ASM, linkage label, and
  actual statement cases through both scalar and vector readers.
- Deferred: 72 fixtures, 1,147 checks, 708 merges and 6,552 bodies read apart,
  zero failures, local and native.
- Local driver: 21,648 checks, zero failures, including resource failures.
- Focused ASan/UBSan: 423 checks, zero failures. Dense zero columns are read to
  compute expected classes before substituting NULL, at every token count
  0–200 next to a guard page, on scalar/vector paths and through the sentinel.
- Local whole SQLite default/stage/reference objects match. All 248 native
  timing objects also match the complete baseline object.

The first local assembly invocation supplied `--clang` without its required
path. Its log (`asm-column-asm-invocation-error.log`) records one invocation
failure with zero corpus sources. The corrected `--clang /usr/bin/clang`
invocation passed the complete corpus; no source failure is hidden.

## Native cost screen

Native candidate SHA-256:
`a8d411dc1c123a13962627af947c4bd9f700133b0451d45279ae33375aad06e4`.
Parser-only reference SHA-256:
`5995d7ee9e1a7489d429aa6b1a0c9e92869b932f351ceb94756bd1c3a15bdfb0`.
Pure416 reference SHA-256:
`46bec1e120ca54b1ae99502136988cea0890e96f4af8eb704cdcd2b6cef748ed`.
All use target Clang 23.1.1, native/O3 fixed build flags, debug information off.
The ordinary SQLite flags are in `LOCAL-METHOD.md`, with target `corpus/` paths.

Each campaign has 31 rotated fresh-process pairs, one lane on CPU 2, real full
object output, normal buffered I/O and warm shared file cache. All samples and
outliers are retained; no host setting changes. Every staging/build/test/
benchmark/validation/hash/compression invocation took the shared host lock.

| Native campaign | Role 0 wall / median peak RSS | Role 1 wall / median peak RSS |
| --- | --- | --- |
| A/A, parser / parser | 129.899 ms / 387,164 KiB | 129.768 ms / 387,176 KiB |
| Incremental, parser / ASM slice | 129.779 ms / 387,192 KiB | 129.917 ms / 385,164 KiB |
| Reverse, ASM slice / parser | 129.650 ms / 385,156 KiB | 129.616 ms / 387,200 KiB |
| Full, pure416 / parser+ASM | 129.980 ms / 393,340 KiB | 129.722 ms / 385,240 KiB |

The incremental resident-memory reduction is about 2 MiB in both orders. The
combined parser+ASM reduction against pure416 is about 8 MiB, directly measured
in the full comparison. These RSS effects are smaller than the virtual byte
reservations removed. The incremental timing differences (-0.106% throughput,
-0.026% with reverse orientation) are within the A/A role bias (+0.100%) and
noise. The full comparison's small +0.199% observation is also not a qualified
speedup claim. All native cohorts have zero failed compiles and zero major
faults. System-time medians remain mixed; no system-time gain is established.

A shared-development-machine local screen had shown a +5.5% wall cost with
overlapping ranges. The quiet native matched and reverse screens did not
reproduce it. Local disassembly shows only test callers of the out-of-line
getter; production callers inline it. The local negative result remains in
`asm-column-sqlite-local.log`, not discarded or used as native evidence.

Raw native files are isolated under `target-asm/evidence628-asm/`, including
all four `asm-*-31.log` campaigns, counters/stderr/objects, native test logs,
`timing-objects.log` and `all-objects.sha256`. The parser-only accepted raw tree
under `target/` remains unchanged. This is a bounded memory/correctness slice;
the broader #628 output/stream work and its combined RSS-and-system-time goal
remain open. No PR, push or external status comment was made by this agent.
