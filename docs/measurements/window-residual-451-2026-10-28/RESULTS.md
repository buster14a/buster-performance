# #451: current-head completion and residual window costs

The original three criteria are covered by the retained #462/#486 work and
the current exactness/configuration record below. No new production change
is proposed. In current main, windows still help SQLite preprocessing, main's
whole-process differences are small, and about 2 MiB of extra peak memory
remains in three commands. The sparse-line heuristic still replays some bytes;
their bounded cost does not establish a reason to replace it in this record.

The final native source/header/status audit passes, receipt
`native-final-audit-v2.log`: 44 positive native status records and the one
retained original-layout negative, four complete/equal-work phase groups,
unchanged source/841-file dependency identities, and byte-identical executable copies.
The locked raw archive/export passes, SHA-256
`8d49109281e5909acd5292eae386d4db3513fb668317cf49f9bb5a7fa9391ccb`.
Local extraction verifies every `raw-payload.sha256` entry, and the local
readers reproduce all twelve whole and four phase-group summaries byte for
byte. The complete payload is under `native-export/`; large raw outputs and
ELF disposition are documented in `ARCHIVE-SCOPE.md`.

## Source and scope

Compiler source: `e7f89091648f68940b595aadd648841c1ffc3ec5`, tree
`4d76bb93e2950d437c834d289805c09a0e5b0eb3`. The private compiler worktree
`work/next-451` was clean for all measurements. It has no algorithm candidate.
The earlier 296e5b05 baseline was preserved when root advanced the starting
pin to e7 before any edit. Later main changes are outside this record.

One shared immutable native executable, built with official Clang 23.1.4,
native host architecture and debug information enabled, supplies both
configurations: SHA-256
`06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e`.
Its path, exact source tree, toolroot, flags and dependency recipe are in
`NATIVE-PLAN.md`. `SOURCE_DATE_EPOCH=1`, the official resource directory and
toolroot `LD_LIBRARY_PATH` were fixed per process; make jobserver variables
were unset. No host settings changed.

The shared native baseline's checker/deferred/ABI/SQLite QA was reused by
exact binary reference. Native PP/refinement/file checks were run separately
because that shared QA did not cover them. Native staging, builds of small
diagnostic helpers, tests, measurements, audit and packaging each held the
shared host lock. Single-thread work used CPU 2; the file gate used CPUs 0/1.
Every whole-process cohort and every phase process had a separate lock grant.
Conservative command/summary bounds are 20:13:27-20:19:52 UTC for the twelve
whole cohorts and 20:22:00-20:22:21 UTC for the sixteen phase processes on
2026-10-28. The earlier campaign's known unlocked-packaging windows around
11:46-12:08 UTC do not overlap this record. This does not assert knowledge
of otherwise unreported host activity; the shared-lock receipts are retained.

The comparison changes only `--window-bytes`: 131072 (production windows)
versus 2000000000 (whole files). Absolute values are not compared to the older
debug-disabled #462/#486 builds or to the rejected fusion build.

## Completion map and attribution

| Original criterion | Retained completion | Current confirmation |
| --- | --- | --- |
| Window versus whole wall/RSS/fault/release cost | #462, merged ff7c983a, 840 timed processes and release accounting | Four original command shapes, A/A/A-B/reverse controls, complete phase/release records |
| Attribute and reduce directive setup | #486, merged 35f26f68: vectorized places, empty-word skipping and prefetch; remaining line pages separately measured | Current directive interval is retained in every phase log; it includes page-line work and is not a fresh isolated measurement of the old directive tax |
| Avoid long logical-line replay or explain the residual | #486's bounded cut and unlexed window doubling remove most sparse-line replay | Exact historical inputs and replay counts reproduced; current main totals and synthetic residuals measured without changing the cut |

Historical records remain authoritative for those source effects:

- [#462 whole-process record](https://github.com/buster14a/buster-performance/tree/7ed12470d4615af85f9a7590f82a8ec8e3b12795/docs/measurements/window-process-451-part1-2026-10-26).
- [#486 directive/long-line record](https://github.com/buster14a/buster-performance/tree/3b0a4a57b4854bf0c1ae9044b3f4fc2d8594f45b/docs/measurements/window-tables-lines-451-2026-10-26).
- The later lexer/page fusion at `68e113ee445af2a80296412a2b8791d3bf9098a6`
  was rejected: preparation 10.000 to 10.000 ms, whole-process changes within
  A/A, and RSS +2188 KiB. Alias refinement emitted identical assembly and
  was reverted. Neither experiment is integrated, retuned or counted as a
  fix here. Its [retained record](https://github.com/buster14a/buster-performance/tree/4df43f7d7a685133b6beade655d9e9a306947081/docs/measurements/unclaimed-perf-2026-10-28/issue-451)
  is separate from this current-main run.

## Whole-process measurements

Four workloads each have one A/A (windows/windows), A/B (windows/whole) and
reverse B/A (whole/windows) cohort. Each cohort is one executable, two list
roles, one source input, two warmups per role and 21 timed processes per role:
504 timed children and 48 scheduled warmups in total. The profiler makes one
fresh executable copy shared by both roles of its cohort and deletes it on
completion. This avoids the prior campaign's mixed-input predecessor design.
There is no additional placement or cross-cohort source comparison.

All 504 printed timed statuses are zero, all 12 successful footers are present,
all 42 cells per cohort are unique, all timed major faults are zero, and user
cycles/instructions are counted throughout. The strict original C reader
`whole451.c` checks these conditions before producing a summary. Its bootstrap
is seeded (0x451e7f89091), 10,000 resamples of the 21 paired wall ratios. These
are **within-cohort** intervals; they do not estimate between-cohort drift.

Raw-list wall medians in milliseconds, plus the paired list2/list1 effect:

| Workload | A/A windows 1 / 2 | A/A paired % [95%] | A/B windows / whole | A/B paired % [95%] | B/A whole / windows | B/A paired % [95%] |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite `-E -o /dev/null` | 18.052 / 18.088 | +0.144 [-0.083,+0.316] | 18.343 / 18.557 | +0.878 [+0.758,+1.263] | 18.431 / 18.344 | -0.372 [-0.536,-0.212] |
| SQLite syntax, one lane | 99.507 / 99.410 | -0.171 [-0.241,+0.031] | 99.581 / 100.037 | +0.313 [+0.173,+0.500] | 99.906 / 99.621 | -0.344 [-0.596,-0.171] |
| Main `-E -o /dev/null` | 95.783 / 95.682 | -0.039 [-0.141,+0.116] | 95.409 / 95.438 | -0.003 [-0.142,+0.128] | 95.398 / 95.343 | +0.077 [-0.174,+0.198] |
| Main parse/syntax | 96.869 / 96.892 | -0.020 [-0.156,+0.062] | 97.001 / 96.725 | -0.264 [-0.418,-0.035] | 97.015 / 97.099 | +0.090 [-0.101,+0.384] |

Signs above follow the raw role order, so positive A/B favors windows and
negative B/A favors windows. Paired ratios differ from ratios of the two
independent wall medians. SQLite favors windows in both orders, but the
`-E` magnitude varies; no cross-cohort confidence claim is made. Main `-E`
is within control/reverse dispersion. Main parsing shows a small window cost
(about 0.26% in A/B, 0.09% in reverse); the reverse interval includes zero.
There is no evidence here for a new general compile-throughput improvement.

The corresponding RSS/fault medians are Linux `wait4` process observations.
The complete user/system/cycle/instruction fields remain in each raw log and
strict summary rather than being substituted with a preferred cohort.

| Workload | A/B peak KiB, windows / whole | B/A peak KiB, whole / windows | A/B minor faults, windows / whole | B/A minor faults, whole / windows |
| --- | ---: | ---: | ---: | ---: |
| SQLite `-E` | 58,076 / 55,916 | 55,916 / 58,076 | 824 / 821 | 821 / 824 |
| SQLite syntax | 364,752 / 362,732 | 362,704 / 364,752 | 1,843 / 1,842 | 1,842 / 1,843 |
| Main `-E` | 173,984 / 174,028 | 174,004 / 173,968 | 2,157 / 2,153 | 2,158 / 2,155 |
| Main parse/syntax | 520,168 / 518,268 | 518,100 / 520,196 | 2,820 / 2,661 | 2,808 / 2,815 |

The extra peak is about 2 MiB for both SQLite commands and main parsing;
main preprocessing is effectively unchanged. Small or inconsistent minor-
fault differences are retained, not described as an improvement. These are
configuration costs in current main, not source deltas from #462/#486.

## Preparation, printing and release

Four distinct processes per input ran windows1, whole1, whole2, windows2;
each reports the built-in 21-pass median. The table contains the median of
the two process medians (their arithmetic average), with native process
ranges in the complete `phase-*.summary`. The reader requires equal input
and output token counts and every phase, printing and release field.

Milliseconds, whole to windows:

| Interval | SQLite | Current main | Historical long-lines | Historical spliced |
| --- | ---: | ---: | ---: | ---: |
| Read | 0.8255 -> 0.7900 | 3.8245 -> 3.8350 | 0.1295 -> 0.1310 | 0.1195 -> 0.1180 |
| Lex | 2.3495 -> 2.3170 | 6.9460 -> 6.9950 | 1.9315 -> 1.9430 | 1.6895 -> 1.8630 |
| Refine | 1.5120 -> 1.3640 | 6.4790 -> 6.4550 | 0.6560 -> 0.4710 | 2.3665 -> 2.2435 |
| Directives, including line pages | 0.2820 -> 0.3095 | 0.4135 -> 0.4605 | 0.0500 -> 0.0950 | 0.0885 -> 0.1155 |
| Main loop/setup | 5.7695 -> 5.2880 | 37.5720 -> 37.5330 | 2.3155 -> 2.3105 | 0.4170 -> 0.4190 |
| Preprocessing total | 10.7605 -> 10.0825 | 55.2565 -> 55.2505 | 5.0890 -> 4.9625 | 4.6815 -> 4.7655 |
| Printing, separate | 3.6700 -> 3.8415 | 27.6300 -> 27.6910 | 11.5340 -> 11.5845 | 0.0070 -> 0.0090 |
| Release, separate | 0.4615 -> 0.4110 | 1.7330 -> 1.7240 | 0.3605 -> 0.3650 | 0.2940 -> 0.2805 |

Independent medians do not have to sum. The preprocessing timer excludes
printing and release. Printing is the benchmark's `-E -P` interval, whereas
whole `-E` commands print line markers. Release measures reusable-call
`pp_release`/`intern_release`; it is not process exit, nor an assurance that
all retained scratch mappings have been unmapped. Whole-process wall/RSS
measurements above include exit.

Total process-median ranges, whole versus windows, are: SQLite
10.685-10.836 / 10.072-10.093 ms; current main
55.078-55.435 / 55.138-55.363 ms; long-lines
5.087-5.091 / 4.958-4.967 ms; spliced
4.624-4.739 / 4.761-4.770 ms. Only two process samples per configuration
were authorized; no between-process statistical confidence is claimed.
Spliced is a retained negative control: windows cost about 0.084 ms total
here, even though #486's original improvement over its old window rule remains
separately established. This current configuration comparison must not be
presented as a new improvement to that rule.

## Residual replay and line exactness

`make451.c` copies exact e7 main/preprocessor sources, retaining their notices,
empties module linkage and inserts only counters around existing lexer/page
calls. It does not change cut, lexing, refinement or page-line algorithms.
`prepare451.c` uses the real preparation route, validates scalar/whole/window
records and checks every token's physical line query against an independent
source-byte oracle at 64, 4096 and 131072-byte windows. The local build passes
ASan/UBSan; the official native build produces identical counts and records.
It is a work-count helper and is never a timing/RSS candidate.

Default-window logical ranges (not hardware traffic):

| Input | Source/windowed bytes | Lexer range bytes | Replayed bytes | Page-covered bytes |
| --- | ---: | ---: | ---: | ---: |
| SQLite source | 9,507,037 | 9,530,200 | 23,163 | 9,507,037 |
| Current encoder | 586,005 | 593,769 | 7,764 | 586,005 |
| Historical long-lines | 8,002,841 | 8,247,914 | 245,073 | 8,002,841 |
| Historical spliced | 8,018,225 | 8,094,259 | 76,034 | 8,018,225 |
| Main's complete windowed include subset | 8,173,523 | 8,188,156 | 14,633 | 8,173,523 |

Main's covered sum independently equals the size of its 18 Clang dependency
files at least two production windows long; all 841 dependencies are hashed.
The reused pinned SQL header/source pack also has a 786-path postrun content
inventory, including its predefines, SHA-256
`e01886bcd9ea04ee8cfa9a23b28246d1cdc67ecc49dfdd66a46e9a5ef9aab396`;
this is not a separate observed before/after pack comparison. It has no
symlink dependencies. The native predefine/header environment is retained
independently from the local environment.
Its residual replay is about 0.179% of the windowed source ranges. The
historical synthetic inputs' hashes and work counts exactly reproduce #486.
They verify the retained algorithm, not a new work reduction.

The bounded tail rule deliberately allows short line replay. A logical line
with no usable boundary grows the next window before lexing; the scanner
stops at the useful line end. Current main spends about 0.049 ms more in lex
while total preparation is neutral over these two pairs. The generated
spliced case still has a roughly 0.174 ms lexical cost versus whole files,
partly offset by refinement. Eliminating all replay would need another
storage/lexer arrangement. The prior fusion did not earn that complexity or
memory cost, and this record supplies no qualified replacement mechanism.
The documented residual is retained rather than manufacturing a source fix.

## Correctness, negatives and boundaries

- All eight actual native preflights pass: SQLite `-E`/syntax and main
  `-E`/parse in both configurations. Complete native `-E` outputs match:
  SQL SHA-256 `2ec1c76652ced6cdf824b018e352f4c66caf124c298249b8ebba4acc59f42a9f`;
  main `d6fdae835a36346d45b4fd1a30edc181a818a75c45a7df42b830ee633d42d160`.
  The four full-inclusion helper outputs match them byte for byte; its direct
  four-file record/page oracle also passes.
- Native PP/window/Clang: 390 fixtures, 240 generated window sources/1833
  preparations, 119625 cut checks, 976 place checks, 2892217 line checks and
  24 complete units/93 windowed units/128264 `__LINE__` outputs agree.
  Guarded line fixtures include CRLF across 64-byte blocks/pages, standalone
  CR/LF and terminal CR; window/cut twins include splices and CRLF tails.
  Directive random/structural/recovery tests pass; 176 header/mode/hosting
  sets and the source/file lookup checks pass. Fuzz is intentionally zero;
  this record does not claim an extra broad fuzz run.
- Native refinement passes 520 files/26584594 bytes, randomized spellings
  and 9600 guarded tails. The one/two-lane file gate passes, including 48
  short-memory runs and resource failures. The local matching gates and
  sanitized helper checks are detailed in `LOCAL-RESULTS.md`.
- Native `gate-preprocessor` is a retained exit-1 configuration negative:
  the shared binary is stored as `compiler-native`, while the header fixture
  walks two executable parents assuming `tree/build/compiler`. Its PP/window
  families pass; its own-header directory is absent. `gate-preprocessor-layout`
  passes with a regular identical executable copy under a private `build/`
  and a `src` link to the immutable source. Both executable hashes are the
  same. No shared binary/source or timed arguments changed.
- The four earlier local main failures using the older SQL header pack
  remain: that pack lacks `linux/audit.h`. They are not timing samples or
  compiler defects. Main uses current-tool predefines and native headers;
  SQL keeps its original pinned pack. Local and native output hashes need
  not match across those distinct path/header environments.
- Reader fault injections reject a missing success footer, duplicate row,
  nonzero timed status and unknown list, as well as a missing release field
  or unequal token counts. A forced unavailable-PMU marker retains all raw
  data and suppresses aggregate PMU fields. The valid local tiny cohort is
  a reader protocol check only. The older local phase-reader shape check
  duplicated files; it is not two independent process pairs and is never
  counted among the sixteen native processes.
- The first final-audit receipt rejects the older preflight status spelling
  `exit=0` before any identity acceptance. The second audit explicitly accepts
  only exact `0`/`exit=0` and `1`/`exit=1` records, retaining each raw spelling;
  it requires zero except for the known original layout-negative. This is a
  status-reader correction, not a repeated measurement or a compiler fix.

The recommended disposition is evidence/documentation completion of #451. Existing
scratch words and page indices retain results until whole-file positions are
known and support physical-line queries without repeatedly walking cold
source. Their measured memory tradeoff remains explicit. Historical source
effects, current configuration costs, negative experiments, native correctness
and publication/CI status remain separate.
