# Windowed preparation: whole-process cost (#451 part 1), 2026-10-26

This completes the measurement scope of [Buster #451 part 1](https://github.com/buster14a/buster/issues/451), claimed [here](https://github.com/buster14a/buster/issues/451#issuecomment-6413010697) on `codex/451-part1-window-process-cost`. Parts 2 (directive tables) and 3 (long logical lines) remain available. There is no compiler source change and no speculative optimization.

## Compiler, inputs and scheduling

Every variant uses one Buster executable from `9de3d30ba437b381394095d7a77635a2e877435d`, built on the Ryzen 7 9700X with clang 23.1.1, the repository's `build.sh`, and `BUSTER_DEBUG_INFO=0`. Executable SHA-256: `a5faaad818d33f1ea44a31be5550f9988db009d323ef09a13f7def702c782de5`.

The sources are #408's frozen inputs, outside the compiler build tree:

- `/home/david/buster-fast-bench/refine-116-claude/inputs/sqlite3.c` with its normal system header search.
- `/home/david/buster-fast-bench/refine-116-claude/inputs/mainc/src/buster/compiler/main.c`, run from its frozen tree with `-march=native -Isrc -fwrapv -funsigned-char --predefines predefines.h`. The frozen predefines SHA-256 is `40c31757e3ffd1ce3f95f79ee9ba347ba97ba893aa66f6e69df4cc9e3b344c58`.

`raw/mainc-inputs-before.sha256` preserves the full frozen source/predefines manifest. The full 443-file manifest was unchanged after the campaign. The coordinator also captures the source/header identities, host setup and after-run verification. `acceptance/` preserves clang dependency closures of 170 paths on SQLite and 736 on main, their SHA-256s, exact commands and compiler identity, made by `dependencies.sh`. Its main closure uses `-undef -imacros predefines.h`, since clang does not accept Buster's custom `--predefines`; this is a clang dependency closure rather than a trace of Buster's file accesses.

The control is `--window-bytes 2000000000`, which makes these files whole. The treatment uses default 131,072-byte windows for files of at least two windows. Both variants are selected in the same executable, avoiding changes in code placement between builds. `SOURCE_DATE_EPOCH=1792454400`; include-path environment variables are unset.

The coordinator alone dispatched the campaign in its shared FIFO. Each of 40 measurement invocations independently acquired the actual `exclusive.sh` shared-host lock and ran on CPU 2. It released the lock between invocations so other sessions and CI could proceed. The coding agent ran no commands on the 9700X. Builds and acceptance commands occupy separate lock holds outside measurements. `held.sh` and the raw logs preserve actual ownership and exit records.

## Whole processes

Each workload has five rounds of `time-runs --runs 21 --warmups 2`, with two argument lists: default windows and whole files. The first list reverses each round; timed order also rotates within each round. All eight direct preflights exited zero. The 840 timed processes all exited zero; `time-runs` itself reported no failed process in any command. All timed processes had zero major faults.

Values are medians of the five round medians. Memory is Linux `wait4` peak RSS in KiB, even though the existing tool prints `KB`. The raw logs retain every process's wall/user/system time, memory and faults. `results-summary.tsv` also retains the range of round medians, and `results-process-rounds.tsv` retains within-round wall minima/maxima. The change is windows relative to whole files.

| Whole process | Wall ms, whole → windows | Change | Peak RSS KiB, whole → windows | Minor faults, whole → windows |
| --- | ---: | ---: | ---: | ---: |
| SQLite `-E -o /dev/null` | 18.903 → 18.636 | −1.41% | 57,188 → 59,240 | 795 → 795 |
| SQLite `-fsyntax-only` | 147.744 → 147.565 | −0.12% | 593,904 → 595,948 | 1,594 → 1,595 |
| main `-E -o /dev/null` | 77.755 → 77.954 | +0.26% | 144,228 → 144,180 | 1,915 → 1,914 |
| main `parse -fsyntax-only` | 78.979 → 79.180 | +0.25% | 429,212 → 431,276 | 2,147 → 2,153 |

SQLite `-E` round medians were 18.863–18.959 ms whole and 18.618–18.704 ms windowed. The other round ranges overlap: checking was 147.571–147.969 vs 147.403–147.798 ms, main preprocessing 77.601–77.984 vs 77.784–78.039 ms, and main parsing 78.891–79.234 vs 79.108–79.530 ms. The checker has no established wall-time win; both main medians are about 0.20 ms slower.

## Preprocessor phases and release

Each input has five alternating process pairs of `benchmark-preprocessor --only vectorized`, with its existing warmup and 21 passes per process. Input/output token counts remain exactly 1,243,784/707,153 on SQLite and 3,431,361/4,037,308 on main for every process. Each pass starts a fresh preprocessor and intern table; thread scratch mappings retain their existing lifetime.

| Interval, ms | SQLite, whole → windows | Main, whole → windows |
| --- | ---: | ---: |
| Read | 0.697 → 0.662 | 3.360 → 3.354 |
| Lex | 2.369 → 2.345 | 5.421 → 5.482 |
| Refine | 1.482 → 1.383 | 5.100 → 5.061 |
| Directive tables | 0.289 → 0.346 | 0.355 → 0.390 |
| Main loop/setup | 5.870 → 5.423 | 31.673 → 31.729 |
| Preprocessing total | 10.699 → 10.163 | 45.889 → 46.017 |
| Printing, separate | 4.364 → 4.541 | 25.737 → 25.629 |
| Release, separate | 0.446 → 0.417 | 1.513 → 1.513 |

Reported user instructions per input token are 118.92 → 118.24 on SQLite and 226.37 → 226.66 on main. These are the report's rounded per-token values, not exact whole-process instruction totals.

Independent medians need not sum. The preprocessing interval excludes printing and release. Printing in this benchmark is `-E -P`; whole `-E` also prints line markers. Release times `pp_release` and `intern_release`, and does not include process exit or every scratch mapping: `scratch_end` restores arena length without unmapping it. Whole-process measurements include exit. No release-time penalty appears in the medians here.

The directive interval for windows also includes #439's page-line counting. Its increase must be considered alongside the main loop; it does not isolate or complete part 2. Main's extra lexing remains observed rather than fixed, and part 3 remains unclaimed.

## Interpretation and disposition

The memory cost remains visible: about 2 MiB of additional peak RSS for SQLite preprocessing/checking and main parsing, with main's preprocessing peak effectively unchanged. The scratch words retain results whose whole-file locations wait for the total token count, and line pages let queries avoid rescanning cold source. Their current representation is retained for its locality benefits; this same-build experiment gives a 0.267 ms SQLite preprocessing saving while recording about 0.20 ms of main-process overhead. It does not justify a more complicated storage scheme, and part 1 makes no source change. The data does not establish a throughput win for every workload or zero overhead from windows.

## Correctness and reproducibility

All nine acceptance commands and both dependency captures exited zero under separate real shared-lock holds. `acceptance.sh` dispatches one test per invocation; `acceptance/` retains the raw reports.

- Default `test-preprocessor` passed. Its windows check had 0 of 240 sources differ (1,812 preparations, 1,574,716 tokens), the line-end scan had 0 of 28,752 checks fail, and the line-page unit check had 0 of 24 sources differ across 93 windowed units.
- Default `test-files` passed, including the expected injected allocation-failure cases (48 short-memory runs, 38 deliberately failed, every unit still matching its independent run).
- `test-refinement` covered 442 files and 29,867,097 bytes; 0 of 9,600 page-edge cases and 0 of 20,000 random inputs differed.
- Each frozen input passed `test-preprocessor` at both 64-byte windows and whole-file settings: 0 of 1 files differed in each command, with 707,153 tokens on SQLite and 4,037,308 on main.
- Both source `test-files` commands passed on every tested lane count. These commands use their own internal options and report 706,586 and 4,036,727 output tokens respectively; their acceptance is agreement within each command's variants, rather than equality with a different command's token count.
- The complete frozen manifest matched before and after the campaign. Both dependency captures passed.

`commands.sh`, `queue451.sh`, `held.sh`, `acceptance.sh`, `dependencies.sh`, the raw reports and manifests retain the complete commands. Build the original C report reader with `clang -O2 -Wall -Wextra -Werror -std=c17 summarize.c -o summarize`, then run `./summarize raw results 5`. Final validation reported **60 completed rows; expected rounds 5; statuses passed**. It requires every round/variant/workload and unchanged phase token counts, verifies all timed process statuses and report structure, and rejects completed nonzero exits. `validate-reader.sh` also checks incomplete-file handling and rejects nonzero statuses, missing required rounds and absent release timings. An expected-round count of zero permits explicitly partial snapshots.

No external implementation or data was imported into compiler production code. The measurement glue and C reader are original work for this campaign; the frozen compiler sources, installed headers and clang serve as recorded runtime inputs.
