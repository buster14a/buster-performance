# Issue 636: native 9700X qualification

The compiler, fixtures, and capture/timing helpers remain local. No PR or push
was made. Every native build, test/capture, and timing cohort uses the shared
`exclusive.sh` lock with an owner, descriptive title, and issue link. Timings
are pinned to CPU 2. No host settings were changed.

The host is Ryzen 7 9700X, Linux 6.18.50-2-lts, Clang 23.1.1, glibc
2.44+r50+g1848099f063e-1 and strace 7.2-1. Compiler builds use the normal
`-O3 -march=native`, `BUSTER_DEBUG_INFO=0` configuration.

| Image | Source commit | SHA-256 |
| --- | --- | --- |
| Baseline | bc1b486150850fe00bad1361a19f57d67706bb3b | d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d |
| Candidate | 60ff4b259cc98912f819ade74f92b864e723eb25 | 4a1b45dba932f9273f7227c055d87ef2d398a986e5e65348865a6bd86f369687 |

## Bytes and system calls

The original C generator makes 4,000 `#warning` directives, 4,000 definitions
of `R` with changing replacement text (3,999 warning-plus-note diagnostics),
and 4,000 global integer-overflow initializers. `capture.c` runs each compiler
under strace with stderr as either a regular file or a pipe drained into a
capture file. Tracing is separate from timing.

Every stdout, stderr and object capture is byte-identical between baseline
and candidate, for all three workloads and both sinks. Both kinds of stderr
write syscall are counted in `syscalls.tsv`; these captures use `write`, with
no hidden `writev` contribution.

| Workload | Sink | Baseline stderr writes | Candidate stderr writes |
| --- | --- | ---: | ---: |
| 4,000 warnings | file | 16,000 | 4,000 |
| 4,000 warnings | pipe | 16,000 | 4,000 |
| 3,999 redefinitions plus notes | file | 23,994 | 3,999 |
| 3,999 redefinitions plus notes | pipe | 23,994 | 3,999 |
| 4,000 overflow warnings | file | 16,000 | 4,000 |
| 4,000 overflow warnings | pipe | 16,000 | 4,000 |

The ordinary path publishes one complete primary diagnostic with its notes
per write. The existing text and ordering are preserved.

## Fresh-process timing

`probe.c` runs `COMPILER --lanes 1 -c INPUT -o FILE`, rotating binary order
each round. Each case/sink has 21 paired rounds, all 42 processes succeeding.
The measured interval includes process creation, full compile, diagnostic
writes, actual object output, close and teardown. The file sink is overwritten
between samples; the pipe sink is drained in the parent. No `fsync` durability
is requested. All samples are retained without trimming.

| Workload | Sink | Baseline median ms | Candidate median ms | Median paired delta ms |
| --- | --- | ---: | ---: | ---: |
| Warnings | file | 11.104269 | 5.269821 | -5.843055 |
| Warnings | pipe | 8.112103 | 6.340374 | -1.645021 |
| Redefinitions plus notes | file | 15.528721 | 5.748145 | -9.752365 |
| Redefinitions plus notes | pipe | 13.291341 | 7.774870 | -5.392860 |
| Overflow warnings | file | 16.298991 | 10.514478 | -5.804140 |
| Overflow warnings | pipe | 12.847136 | 10.349599 | -2.539295 |

Raw `wait4` user/system CPU counts and RSS are retained in every JSON record.
The short-process CPU-time split is coarse and sometimes reports a zero
system-time median despite measured syscalls. Wall time and exact write counts
are the primary evidence; a reported zero does not mean there was no kernel
work.

### Silent startup control

The no-diagnostic input is `int a;`. Each control has 61 paired rounds with
rotated order and successful completion throughout:

| Control | First role median ms | Second role median ms |
| --- | ---: | ---: |
| Baseline / candidate | 1.390134 | 1.388250 |
| Baseline / identical baseline | 1.394552 | 1.398389 |
| Candidate / baseline, roles reversed | 1.393649 | 1.396234 |

Both candidate comparisons are within the identical-binary control variation.
The earlier laptop startup concern does not reproduce on the qualified target.
The frozen candidate is retained; no source-layout follow-up was needed.

### tcc orientation

The external tcc is 0.9.28rc, 2026-01-17 makepkg@b39cbc70, executable SHA-256
`49e2d1afd09cdab6593ca127b056ccc35fc5f3a2d0e08dae67f604db2751c082`.
It is run with its ordinary `-c` interface, in 21 rotated pairs against the
candidate. Diagnostic text/detail differs between compilers, so these rows are
orientation rather than an exact-output performance comparison.

| Workload | Sink | Buster candidate median ms | tcc median ms |
| --- | --- | ---: | ---: |
| Warnings | file | 5.275750 | 3.613136 |
| Warnings | pipe | 6.386409 | 4.161032 |
| Redefinitions | file | 5.770043 | 3.695348 |
| Redefinitions | pipe | 7.683514 | 4.712809 |

## Artifacts and prior correctness checks

The source generator/timer is `../probe.c`; `capture.c` is the original
file/pipe byte/syscall adapter. Their exact sources, native helper identities,
input hashes, package identities, raw successful captures, strace records,
timings, object files and queue receipts are retained. Local summary JSON and
`syscalls.tsv` can be independently regenerated from the raw records.

`../target-all-raw.tar.gz` is a checked complete raw archive, SHA-256
`5d67c11a8b61fcfbb0b65b3e8a1c289c3bd6736adbedddbfae8655e37dcfeb19`.
All raw files are also extracted in this directory.

The frozen source's earlier local release build, full preprocessor/Clang suite
including 3,000 fuzz cases, and focused ASan/UBSan/leak checks all passed. The
permanent buffer checks cover 90 boundary/message-size combinations, repeated
growth, unavailable scratch, exact prefix/suffix ordering, a caller-supplied
unbuffered stream, immediate output and quiet severity counts. Those local
checks and the target capture/timing matrix are distinct evidence.

## Later interference audit

A retrospective packaging-interference screen is in `contamination-audit.txt`. All primary timing and startup/control cohorts predate the reported windows. The extra TCC redefinitions/pipe orientation row has uncertain overlap and is excluded from acceptance; deterministic byte/write-count checks remain retained.
