# Checker binding handoff #336: approved-host evidence

Repository: `buster14a/buster`, ID `1421805693`. Issue #336, PR #381.

All executable validation and measurement evidence here comes from the approved
AMD Ryzen 7 9700X GitHub runner, whose job hook holds the shared host lock. Timed
binding commands pin CPU 2. Local work was static review, source preparation and
read-only evidence extraction; the separately queued remote build was cancelled
before it started, including its exact orphan flock child.

## Source and run identity

Original PR head: `5e538cb5fe93b172e0697f0e70e86d586c4a4c65`.
Original run: https://github.com/buster14a/buster/actions/runs/40089203533
Job: `120858240606`, success, completed October 24, 2026 at 11:30:26 UTC.

The workflow actually checked out PR test merge
`bc7e78d26487d2897e78daff2a6cbcd243235894`, with parents
`a7741e836353642041aca0e3c653f38226153358` and
`5e538cb5fe93b172e0697f0e70e86d586c4a4c65`, tree
`51734373b0daef3227ae2d4873b3a65ca1b38f24`.
The archived original harness has blob SHA-1
`a7ccddbf3a65a670c632551ee0c9cdf478f13b41` at both PR head and tested merge.

Qualification candidate head: `fe7c6f6b2fea4f46176d04543ca7b2d323d2625c`.
Candidate run: https://github.com/buster14a/buster/actions/runs/40095665758
Job: `120877304412`. Its final result, tested merge identity, and full raw log
are retained here: **success**, completed October 24, 2026 at 13:03:56 UTC.
The actual tested merge was `ce5ca7fcdcd7c1f8a4f8285721f4a660b78b034b`,
parents `608ff3d4d179acac6faf5bdbc83e4b1db9d3031f` and
`fe7c6f6b2fea4f46176d04543ca7b2d323d2625c`, tree
`0ac7a4e6c1c23356c256d4f091a9457f99f956a9`. Full commit metadata, job/run
metadata and logs are separate archive files.
The candidate harness has blob SHA-1
`95bf443a4cf36314db35a25e03b50c3d70e2438a` at both PR head and tested merge.

`candidate-binary-provenance.txt` records the built compiler while this exact
job ran its tests: SHA-256
`9b53ae691cc1762ab631542491326c968a6407caa2fa734f8026799b87cbb405`,
85,962,668 bytes, modified at 12:58:12 UTC. Before/after source HEAD reads both
matched the tested merge, and the build step had completed. The receipt reads
only revision, size, timestamp and digest from the protected runner checkout.

The harness files are original first-party C source snapshots under
`Apache-2.0 WITH LLVM-exception`, with their retained SPDX and copyright notices.
They are provenance copies of repository-native commands, not an externally
dispatched harness. Every archive file's bytes are covered by `SHA256SUMS`.

## Host, toolchain and frozen inputs

`host-input-provenance.txt` is a read-only host/input receipt at
2026-10-24 12:55:05 UTC. It records the actual CPU model, Clang version and SHA,
manifest digests, pinned predefines and SQLite source digest. This receipt is
provenance, not a performance run.

- CPU: AMD Ryzen 7 9700X 8-Core Processor.
- Clang: `/usr/bin/clang` 23.1.1, SHA-256
  `939a882527432ec23b094c289e7f170bf2d6ec282e74dde75e31b08602fa3eae`.
- Corpus manifest root: `preprocessor-391e729af658`, complete manifest SHA-256
  `391e729af6587355050881752558e790299cfe638c7dc7803bd028a8535ebcbd`.
- SQLite 3.53.2 `sqlite3.c`: SHA-256
  `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
- Pinned GNU17 predefines: SHA-256
  `a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
- Built-in small input source: SHA-256
  `be568cb5db8dd471edc19be730653ce43623143c033ccc8cc883b640e263dcee`.
- Built-in large input source: SHA-256
  `0e33678843ad025277ad6bf0c918c556e526d9421ca78c3f42ab3dd5f5dc47a7`.
- Built-in header-heavy source: SHA-256
  `b62447a1cbdccfcb310f3c43f644c081e8af7c720c7565d9184c22c5a25518e0`.

The synthetic hashes identify the source generators' emitted text. The header
and SQLite token/event counts additionally depend on the pinned search paths,
headers, predefines and options. The raw workflow log contains those exact
commands and manifest-verification steps. No third-party corpus or header source
is copied into this archive. The original compiler executable's binary digest
was not retained by its workflow and cannot be reconstructed retroactively.

## Measurement interpretation

The original harness times only `check_input`, after type initialization and
arena reset. Initial parsing, expression checking and cleanup are excluded.
Its hardware-cycle interval includes initialization excluded from nanoseconds;
the original cycle counts must not be treated as the matching nanosecond scope.
Original reader measurements independently establish about 20% less reader time
on large and SQLite and about 24% on small and headers, beyond observed spread.

The candidate keeps an explicitly reusable `reader-initialize` measurement and
adds `--pipeline` / `parse-reader-check-cleanup`: fresh parser initialization,
token extraction and parsing, all checker/type arena reservation and
initialization, semantic reading, binding publication, expression checking, and
all per-invocation parser/checker arena release. Before timing, complete source
columns/graphs and checked streams must match the retained reference on fresh
type tables. Timed pipeline calls retain only scalar metadata after cleanup.

Preprocessing and identifier initialization/run/cleanup are a common phase,
reported as one separate process observation. They are not repeated whole-driver
measurements; do not claim a measured whole-compiler speedup. The pipeline's
paired difference changes only the binding handoff over identical preprocessed
input and the same common work.

Reader memory probes are written-byte lower bounds, not RSS or guaranteed peak
allocations. Fresh pipeline output/parser/type retained lengths are recorded
before cleanup. Poisoned written-byte probes are unavailable for released
pipeline arenas (`written_bytes_available=0`); their zero fields do not mean
the pipeline wrote no scratch memory. The source-oracle tests independently
exercise forced candidate-walk fallback, which is absent from SQLite timings.

## Candidate correctness

The exact candidate job passed:

- `test-checker --seed 133`: 246,298 checks, zero failures, including every
  legal source-order prefix of 0..64-event guarded streams, independent source
  identities, fresh-table mode comparisons and rollback/exhaustion probes.
- Both eager and lazy checker-driver suites: 1,473 checks each, zero failures.
- Frozen SQLite against Clang: zero acceptance, first-line, diagnostic-path,
  scalar/vector, resource, or preprocessing differences.
- Call graph: 42 translation units, zero unapproved cycles.

Every pipeline mode's pre-timing fresh-table source columns/graph and complete
checked stream matched the reference (`comparison=identical`) on every input.

## Candidate pipeline results and spread

Each entry is a separate process's median of nine interleaved passes, after a
warm-up. All values below include fresh parser/checker allocation, initialization,
parsing, semantic reading, expression checking and cleanup. The full five-mode
rows, extrema, cycles and memory are in `candidate-pipeline.tsv` and the raw log.

| Input | Direct medians, processes 1/2/3 | Previous parser-batch medians, processes 1/2/3 |
| --- | --- | --- |
| small | 131.125 / 131.296 / 131.927 us | 135.114 / 136.205 / 136.716 us |
| headers | 6.795777 / 6.732258 / 6.800487 ms | 8.508821 / 8.480107 / 8.514321 ms |
| large | 34.491718 / 34.990474 / 34.316730 ms | 40.209623 / 41.322892 / 40.259587 ms |
| SQLite | 114.855983 / 114.665375 / 114.397853 ms | 134.721786 / 134.533473 / 134.207331 ms |
| SQLite after 100 ms stack reader | 114.425816 / 114.268020 / 114.406369 ms | 133.929560 / 133.826918 / 134.037041 ms |

The sustained SQLite reduction is about 14.8%, and the conditioned reduction
about 14.6%. Across all sustained samples, direct's slowest SQLite sample was
115.392719 ms and the previous path's fastest was 133.530682 ms. Conditioned,
they were 115.165924 and 132.628440 ms. Headers likewise separate at 7.012945
versus 8.306792 ms; large at 35.505830 versus 39.804123 ms.

Small's process medians improve about 3%. Its slowest direct process median
(131.927 us) beats the fastest previous-path process median (135.114 us), a
3.187 us gap larger than either path's between-process median range (0.802 us
direct, 1.602 us previous). Individual small-unit samples overlap: direct
129.093..138.089 us and previous 131.858..143.890 us. The repeated-median result
does not establish that every small-unit invocation improves. The independent
reader-only baseline shows about 24% less work in this phase on the same unit.
No special small-unit replay branch is justified by these measurements.

Shared retained allocations are unchanged between handoff modes. Before fresh
pipeline cleanup, SQLite retained 284,920,208 output bytes, 163,003,914 parser
bytes and 136,439,800 type/index bytes. These are arena lengths, not RSS or a
complete peak scratch accounting. Name capacity was 24,038, with 9,948 distinct
namespace/names, maximum name occupancy 7,007 events and 7,817 peak active
declarations. No SQLite uses walked or fell back. Headers had 8,407 name slots,
3,725 distinct names, maximum occupancy 1,514, 3,515 active declarations, and
three batch-walked uses with zero fallback. Forced fallback is checked separately.

Per-process common preprocessing observations are present in the full log;
for example process 1 reported initialization/run plus cleanup of
0.366187+0.127540 ms for small, 4.963670+0.306685 ms for headers,
1.595122+0.185879 ms for large, and 12.679063+0.476594 ms for SQLite.
These common costs are quantified, excluded from paired pipeline timing, and
must not be presented as repeated whole-driver performance evidence.

## Retain decision

Retain direct retained-use answers as the default. Independent source/Clang,
stack, batch and fresh-table oracles preserve correctness. The complete
parse/reader/check/cleanup comparison confirms substantial gains beyond sample
spread on header-heavy, large and SQLite units, maintained after lighter scalar
work, while small's three process medians improve with overlapping individual
samples. Stack replay remains the independent scalar twin; the sort/replay paths
remain oracles and benchmark alternatives. There is no evidence to pay for an
additional grammar replay or batch sort in production.

This is evidence for this binding handoff and the precisely defined frontend
scope. It does not establish downstream lowering, deferred-body integration,
or repeated whole-compiler throughput.
Do not equate a correct implementation, an approved-host reader-only result,
hosted CI, protected merge, main containment, or issue closure with one another.
