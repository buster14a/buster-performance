# Buster #624: bounded expression templates and pending task layout

Campaign started 2026-10-27; final 9700X measurements were taken 2026-10-28 UTC.

- Issue: https://github.com/buster14a/buster/issues/624
- Baseline: `92c025e71856d13eb34247477c5294d2cead139e`.
- Qualified implementation: `07df7873cde737d6bae914ff4eb81a75bf8c4f72`.
- Compiler source: https://github.com/buster14a/buster/tree/07df7873cde737d6bae914ff4eb81a75bf8c4f72
- Machine: approved shared Ryzen 7 9700X, CPU 2, sibling CPU 10 offline.
- Target compiler and native oracle: Clang 23.1.1. Local sanitizer host: Ryzen 9 7940HS, Clang 23.1.4 ([details](local/toolchain.txt)).
- Frozen SQLite source: `/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`.
- Source SHA-256: `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.

## Result and limits

The lower-stage median improved at all six checker code placements: **1.89% to 2.90%**, with a **2.26% median paired reduction** against the mean of the two baseline-copy medians at each placement. The largest baseline A/A lower-stage gap was 0.71%. The ordinary unshifted build also improved, from 15.467 / 15.477 ms to 15.333 ms (0.90%).

Whole-process medians have a 0.22% median paired reduction over the six placements, inside the observed 0.82% maximum baseline-copy gap. These measurements therefore establish a lower-stage improvement on this workload, not a resolved whole-compiler throughput gain or a claim about other corpora.

All times below are medians in milliseconds. A negative delta is faster; the comparison denominator is the arithmetic mean of the A/A medians. `standard` uses the normal build; numeric rows use the build script's checker-unit text padding.

| Placement bytes | Lower base A | Lower base B | Lower candidate | Lower delta | Wall base A / B | Wall candidate |
|---|---:|---:|---:|---:|---:|---:|
| standard | 15.467 | 15.477 | 15.333 | -0.90% | 146.795 / 146.552 | 146.485 |
| 0 | 15.581 | 15.471 | 15.159 | -2.36% | 146.850 / 146.332 | 146.694 |
| 16 | 15.464 | 15.500 | 15.189 | -1.89% | 146.455 / 146.540 | 146.035 |
| 64 | 15.404 | 15.505 | 15.135 | -2.07% | 146.460 / 146.828 | 146.707 |
| 256 | 15.680 | 15.588 | 15.232 | -2.57% | 147.664 / 146.461 | 146.587 |
| 1024 | 15.636 | 15.570 | 15.151 | -2.90% | 146.995 / 146.290 | 146.452 |
| 2048 | 15.593 | 15.568 | 15.246 | -2.15% | 147.015 / 146.516 | 146.289 |

The vector templates handled **14,573 / 266,823 evaluated expression occurrences (5.46%)**, with 14,675 immutable records classified. This is deliberately a small initial share. Scalar VALUE handling, complex conversions, control flow and the other non-eligible shapes remain in the original expression expansion. Scalar constant templates and dispatch changes are not counted as vector nodes. Repeated uses count as repeated evaluated occurrences; unselected definitions and skipped operands are excluded.

Every timed round's objects, and the candidate's separate full `--scalar` compile after each placement's timed rounds, were identical. Their SHA-256 was:

```text
0c48ff92978c3125b1822a1552eb48d2742ea09d80176488d8dc5320c4afe91f
```

The result is for the combined patch: bounded joined templates, compact pending records, common-task dispatch, packed type facts and controlled column placement. It does not isolate a speedup for each component.

## Protocol and reproduction

[compare.c](compare.c) is an original C harness. It copies the baseline executable twice and the candidate once into fresh files, warms every variant twice, then rotates all three variants over 21 rounds. Every child uses `--lanes 1 --time-stages`. The harness records lower-stage time, fork-to-wait wall time, peak RSS and node coverage, saves the driver's full stderr, and checks every round's object bytes. The slower scalar qualification follows the timed rounds.

[compare-layout.sh](compare-layout.sh) records source and binary identities, Clang and CPU details, runs that comparison on CPU 2, then takes five whole-process `perf stat` samples per variant and saves the relevant assembly. Those counter samples do not use `--time-stages` and are not stage-specific counters. No executables or object binaries are incorporated here; checksums, byte comparisons and the reproduction sources are retained.

The source invocation, in addition to `--lanes 1 --time-stages`, is:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 \
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE \
-I/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite \
/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
```

`CPATH` and `C_INCLUDE_PATH` are unset, `SOURCE_DATE_EPOCH=1792454400`, and `LC_ALL=C`. Builds use the repository's normal `-O3 -march=native` configuration, `BUSTER_DEBUG_INFO=0`, `LC_NUMERIC=C`, and Wild as selected by the build script. Compiler sources were extracted with `git archive` from the exact revisions above into `~/buster-fast-bench/issue624/base` and `layout`. The two revisions' normal compiler plus six placements were built with:

```sh
./build.sh shifts ../placements-base main_unit_checker.c 0 16 64 256 1024 2048
./build.sh shifts ../placements-layout main_unit_checker.c 0 16 64 256 1024 2048
```

Each build, each placement comparison, and each qualification suite invocation separately acquires `~/buster-fast-bench/exclusive.sh`, with issue #624 as its link and an owner/title. Each measurement is one invocation of `bash compare-layout.sh PLACEMENT`, for `standard`, `0`, `16`, `64`, `256`, `1024`, or `2048`. The lock is released between placements so the host's other users and CI can run.

[summary.json](summary.json) contains the transcribed medians and explicitly defined paired calculations. [target/](target/) retains the complete per-child reports, comparison and build logs, perf counters, and disassemblies.

## Qualification of the exact implementation head

The target's [test-layout.log](target/test-layout.log) runs [tests-final.txt](tests-final.txt) under one exclusive suite invocation with a budget of eight CPUs:

| Check | Result |
|---|---|
| Checker, scalar/vector streams and native Clang oracles, seed 624 | 299,595 checks, zero failures |
| Source driver and coverage/time report | 21,592 checks, zero failures |
| Function workers, fallback and object identity | 2,721 checks, zero failures |
| Debug/source rows and Clang DWARF | 2,534 checks, zero failures |
| Pinned c-testsuite subset and Clang cross-check | 220 / 220 passed |

The c-testsuite runtime input was revision `5c7275656d751de0e68b2d340a95b5681858ed07`, using the compiler revision's `tests/c-testsuite/subset.txt`.

The local guarded suite also passed **34,043 checks** under AddressSanitizer and UndefinedBehaviorSanitizer: [log](local/guarded-asan-ubsan.log), [harness](guarded-sanitizer.c), [reproduction script](guarded-sanitizer.sh). It compiles the actual checker batch test entry point, disables only main.c's section grouping so unrelated commands can be garbage collected, uses `-O0`, and sets `ASAN_OPTIONS=detect_leaks=0`. This is a bounds/UB check, not a leak qualification.

The source call graph checked 41 translation units, 23,982 functions and 143,534 calls: zero cycles, the same three explicitly allowed preprocessor-fuzz cycles, zero split variables ([log](local/callgraph.log)). The CI module selector self-test passed 1,008 checks ([log](local/ci-module-gates.log)); lowering/template edits now enable the compile-time job.

## Why this layout and scope

A pending record uses 16 bytes instead of the original C record's 32. For capacity N, reserving `16 * (N + (N mod 256))` bytes preserves the offset of the following columns modulo 4096 relative to the task base: the difference from `32 * N` is a multiple of 4096. This adds at most 4080 bytes of padding. Active stack records still touch only 16 bytes each.

The selected hot fragments use scalar type loads for at most four rows and a vector byte-table lookup. The classifier's larger masked form is exercised through all partial tails to 16 rows, but production joins are currently two or three nodes. Compression happens in registers followed by prefix-masked output stores. The experiment does not claim that wider speculative graph plans or queued-instruction batching are profitable.

Several earlier candidates were correct but slower, and were rejected:

| Candidate | Shape | Lower base A / B ms | Lower candidate ms | Evidence |
|---|---|---:|---:|---|
| `e661c8797ae84f71de10b712dcde9b223c328d30` | Compact tasks with cached expression windows | 15.516 / 15.468 | 16.530 | [compact](rejected/compact/) |
| `552a543e34bf7c6be7ba642467e7b7b28d794bad` | Isolated leaf templates and retained windows | 15.746 / 15.590 | 16.172 | [values](rejected/values/) |
| `21376d6e8e7339848dce91a0165e6ace8416e73b` | Member/conversion chains and queued instruction batches | 15.526 / 15.509 | 16.459 | [chains](rejected/chains/) |
| `b62f1c26274a9eb18e36f35d61aac5e5955e0c11` | Common-task dispatch, still unpadded and batching queued instructions | 15.433 / 15.413 | 15.992 | [hot](rejected/hot/) |

The hot candidate was slower in all six placements too; that record preserves the A/A and placement controls rather than selecting one favorable binary. Final qualification belongs only to `07df7873`.

## Licensing and provenance

The harness and shell glue are original material for this issue, under Apache-2.0 WITH LLVM-exception, as their source headers state. Clang, Linux perf, binutils and the linker are external runtime tools. SQLite and c-testsuite were external runtime inputs, not incorporated sources. Compiler disassembly is derived from the exact original Buster revisions identified above; their notices remain in that repository. No third-party implementation was imported.
