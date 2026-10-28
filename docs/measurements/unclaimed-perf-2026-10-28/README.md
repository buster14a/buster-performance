# Unclaimed performance work, 2026-10-28

This is a local work record. No PR or remote branch push has been made by this
session. Individual source branches and raw artifacts remain available in the
same workspace. This record is still being completed.

## Frozen individual qualification

The following records compare baseline
`bc1b486150850fe00bad1361a19f57d67706bb3b` with the exact individual source
revision named in each report. They do not measure a later main branch or the
combined effect of the fixes. Separate speedups must not be multiplied.

| Issue | Native qualification record | Scope and limits |
| --- | --- | --- |
| 590 | [Record](issue-590/target/README.md) | Empty/data-only backend setup; body-bearing controls stable, tcc remains faster on tiny files. |
| 636 | [Record](issue-636/target/README.md) | Buffered diagnostic bytes, syscall counts, file/pipe process timings and silent controls. |
| 641 | [Record](issue-641/target/README.md) | Retained sparse/count/key slice only; larger compact selection experiment rejected. |
| 649 | [Record](issue-649/target/README.md) | Exact printer output, printing and whole `-E -P`; not ordinary `-c` throughput. |
| 652 | [Record](issue-652/target/README.md) | Terminal cleanup only; isolated A/A/reversal controls supersede mixed-input conditioning bias. |
| 657 | [Record](issue-657/target/README.md) | Bounded region lookup with dense independent oracle and deep scaling. |
| 658 | [Record](issue-658/target/RESULTS.md) | Eligible integer literal tables; general tables and token storage remain open. |
| 664 | [Record](issue-664/target/README.md) | Bounded stable home selection; scalar twin cost is retained explicitly. |
| 674 | [Record](issue-674/target/README.md) | Eight-worker throughput survives placement/copy/order controls; one-worker gain unresolved. |

The host is Ryzen 7 9700X / Linux 6.18.50-2-lts, ordinary Clang 23.1.1 native
release builds with `BUSTER_DEBUG_INFO=0`. Every target build, test and timed
run uses the shared `exclusive.sh` lock; no machine settings were changed.
Reports retain exact executable/input/source identities, affinities, commands,
repetitions, statuses and resource metrics. Captured faults and adverse results
are not trimmed.

## Current-main and draft-PR compatibility

The independent current-main integration is frozen at
`b8cd163ce33bb8042e42fd9fea7c675ae13fa487`, incorporating main
`4165454ebadf9b96c2b40ab99c55f4c0b28ba975` and its #682 test-build change.
The source contract adaptations preserve #640's optional parser traversal,
compact graph leaves, new warning interval producers, string IDs, symbolic
zero data and automatic initializer pools.

On the target, all 41 units build in 28.9 seconds; nine correctness groups
pass in 45.0 seconds, including checker 488,765/zero, deferred 1,147/zero,
Tier 0 95,965/zero and all 220 native cross-checked corpus programs. All 672
tracked source hashes match the staged source tree. These functional results
do not transfer the individual speedups to the new main.

A separate private #678 compatibility trial preserves the main-only branch.
Six added scalar equivalents are needed by the retained performance fixes;
their boundary tests pass, and native vector paths remain unchanged. The first
trial against `8af0904b` exposes scalar failures and is retained as negative
evidence. The PR advanced to `ed1e848e`; fresh native/scalar builds and exact
clean-PR controls distinguish pre-existing failures from interactions. No
compatibility acceptance is implied until that comparison is complete.

## Archival method and provenance

Original project implementation, fixtures and reproduction helpers use
Apache-2.0 WITH LLVM-exception. Existing source notices are retained. Clang,
libc, binutils, tcc and pinned source corpora are external runtime/test inputs;
they are not imported implementations. Each individual report names input and
toolchain provenance and separates external comparisons from byte-exact ones.

`method/curate_evidence.py` copies UTF-8 text evidence up to 5 MiB per file.
Each issue's `COLLECTION.tsv` records every original file's path, byte count,
SHA-256 and disposition. Binaries, objects, large generated inputs and complete
compressed raw archives remain in the local workspace; reports name their
archive identities. Generators and exact commands reproduce omitted payloads.
The local delivery bundle will retain the full raw artifacts separately.

The original `cohort.c` and `samples.c` in `method/` record each process and
real output. Balanced placement/copy controllers and independent schedule
verification are retained in issue 674's record. Simple cyclic rotation of
mixed workloads can confound predecessor workload state; failed controls and
their isolated/balanced replacements are retained in 652, 673 and 674.

Incidental target packaging outside the lock was discovered during provenance
audit. Every known interval was distributed to all campaign owners; original
and uncertain records remain annotated. Where acceptance depended on an
overlap, a complete clean balanced pass was added. The issue reports retain
the interval audit and replacement identities. All subsequent target packaging
also uses the shared lock.
