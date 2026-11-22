# Preprocessing a large primary file from the live conditional cursor

The corrected compiler emitted 268,434 fewer raw SQLite token rows and compiled the ordinary frozen translation unit in 113.791 ms on the Ryzen 7 9700X. The baseline took 113.814 ms. Both produced the same 2,061,192-byte native object. The target for this 9,507,037-byte source is 9.507037 ms.

The compiler prepares a private source fragment at a time. Each fragment ends at a preprocessing directive. When the real preprocessor excludes a branch that continues past the prepared bytes, a source scanner follows the nested conditional structure from the frontier to the next sibling. It emits zero raw token rows for those bytes. Macros keep their immutable definition fragments and physical source offsets. Exceptional lexical or diagnostic cases can return to ordinary source preparation. The corrected compiler constructs the primary physical-line page index as it progresses through the source.

## Locked Ryzen 7 9700X observations

| Measurement | Baseline | Corrected cursor | Within-round change |
| --- | ---: | ---: | --- |
| Fresh preprocessing, without printing | 9.8905 ms | 9.7985 ms | −1.19%, −0.84%, −0.60% |
| Cycles per emitted preprocessing token | 63.025 | 62.775 | |
| Ordinary full compilation, child wall | 113.814 ms | 113.791 ms | +0.86%, +0.05%, −0.41% |
| Ordinary full compilation, decimal MB/s | 83.531 | 83.548 | |

Each row uses six observations per arm over three alternating or mirrored rounds pinned to CPU 2. Each preprocessor observation is the median of 21 fresh runs. Each whole-compile observation includes one unmeasured warmup and measures an ordinary compiler process under the default page policy. The machine-wide lease covered each four-arm round. Every iteration checked its native object against the frozen baseline. The stage and child measurements came from separate invocations. The checked source patches and binary fingerprints are in the source directory and raw archive. [Raw observations](measurements/locked-sqlite.tar.gz) and [normalized measurements](measurements/observations.tsv).

On the same preprocessing observations, median lexing fell from 2.306 to 1.940 ms and identifier refinement fell from 1.449 to 1.190 ms. The measured main loop and setup grew from 5.294 to 5.883 ms. In the ordinary child observations, median user CPU time fell from 104.338 to 101.496 ms, system CPU time rose from 8.291 to 11.684 ms, and peak resident memory rose from 240,446 to 251,798 KiB. These are medians of distinct fields and need not sum to median wall time.

| Primary input | Eager raw rows | Cursor raw rows | Source bytes left unlexed | Prepared fragments | Cross-fragment false branches |
| --- | ---: | ---: | ---: | ---: | ---: |
| Frozen SQLite | 1,166,437 | 898,003 | 1,798,055 | 110 | 22 |
| SQLite with six additional features | 1,166,437 | 1,125,042 | 286,616 | 128 | 20 |

The fragment ranges were disjoint in both source traces. Neither trace needed the fallback that prepares the full remaining suffix or a whole-primary pass to build the source-line index. The scanner still reads bytes to identify nested conditions. Frozen options enable RTREE and MEMSYS5, disable threads, and omit extension loading. The feature comparison adds FTS5, FTS3, SESSION, PREUPDATE_HOOK, GEOPOLY and DBSTAT_VTAB. [Frozen trace](measurements/final-cover-default.log) and [feature trace](measurements/final-cover-features.log).

## Source and checks

The full implementation patch applies to Buster `0e1d5b825801135bf50e79da9d546bc95209ab30`. The signed corrected head is `0f02ccb832c286df4e215c3cb121b865695cd378`. Both earlier implementations have reproducible correctness failures. [Final patch](source/fixed.patch) and [signed commit history](source/signed-commits.txt).

- The scalar cursor at `47e99d74130a28c7e47581a707194f6f6134592f` duplicated a declaration when an angle header contained a literal `/*` after a fragment boundary. Its opaque-header recovery had used a local directive index against the full primary file. Recovery now prepares the same source interval and preserves absolute offsets. Clang, the baseline and the repaired cursor emit the same 27 bytes. [One-MiB reproducer generator and outputs](oracles/header-recovery/).
- The first vector cursor at `ed8579d10a1a22edff16724b5de1df7c0fbe909e` diagnosed an unterminated conditional when its opening `#if` was in one fragment and a skipped `#else` was in the final fragment. The corrected cursor finds the next sibling in the current fragment even when its opening directive lives in an earlier fragment. Clang and the baseline both accepted the case. The corrected preprocessor matches baseline output byte for byte. [One-MiB reproducer generator and outputs](oracles/orphan-arm/).
- The corrected ordinary driver passed 80 comparisons covering markers, marker-free output, default and extended warnings, successful and rejected inputs, native objects and linked fixture execution. The generated samples cover trigraphs, digraphs, splices, misleading quoted and commented directives, nested includes, macro arguments that straddle a false arm and macro definitions used beyond their source fragment. A separate set passed 280 randomized nested-conditional comparisons. [Directed native results](oracles/directed-native.log) and [fuzz results](oracles/fuzz.txt).
- Frozen and six-feature SQLite produced byte-identical objects, standard output and diagnostics under both the default warning policy and `-Weverything` on the local Ryzen 9 7940HS. Normalized fixture directories and compiler configurations differ between the local and 9700X runs. Each machine compared exact outputs between its own matched arms. [Output sizes and SHA-256](oracles/frozen.tsv).
- One Clang-compiled test driver linked independently against the frozen Clang, baseline Buster and corrected Buster SQLite objects. The executables agreed on all 144 output bytes and exited successfully. The tests cover bound text and blobs, Unicode, an R-tree, a recursive CTE, window functions, UNIQUE constraints, rollback and database integrity. [Runtime driver](reproduce/sqlite-driver.c) and [runtime output](oracles/sqlite-candidate.stdout).

Run either reproducer generator with Python and a destination argument. The header case takes a directory. The conditional case takes a file path. Run the compiler in `-E -P` mode on the generated `case.c`, adding the generated directory to the include path for the header case. The scheduler scripts use the existing Buster benchmark checkout and machine-wide lease.

## Fragment allocation

The signed follow-up `e2c2f1d3308195c9d04d77902f958519deb4a1db` allocates a fragment from the file-cache lane when the translation unit owns that cache. In three machine-locked six-position rounds, its 9700X median whole-compile time was 114.140 ms, compared with 113.875 ms for the eager baseline and 114.212 ms for the corrected cursor. Its per-round wall changes against the eager baseline were +0.59%, +0.24% and −0.41%. The peak resident memory medians were 240,448 KiB for the eager compiler, 251,804 KiB for the corrected cursor, and 239,408 KiB with arena reuse. Every native object matched the corresponding baseline. Ordinary and `-Wall -Wextra` output and diagnostics also matched. [Source patch](source/allocator.patch), [target raw records](measurements/allocator-raw.tar.gz), [target observations](measurements/allocator-observations.tsv) and [local preprocessor screen](measurements/allocator-local.tsv).

## Four-corpus ordinary compilation

The standard 9700X series used three alternating rounds with six measured processes per arm and a separate set of performance-counter runs. Each child compiled the requested translation units into native object files, with one lane for the multiple-file invocations. The corrected cursor matched all 30 ordered native-object manifests on every corpus, including preflight, warning-policy, stage, counter, and wall runs. Ordinary output and diagnostics agreed under the default warning policy and under `-Wall -Wextra`. All grouped performance-counter observations had 100% running coverage.

| Workload | Translation units | Baseline median | Corrected median | Median within-round change |
| --- | ---: | ---: | ---: | ---: |
| SQLite | 1 | 113.303 ms | 113.489 ms | +0.45% |
| Lua | 34 | 63.288 ms | 63.406 ms | +0.35% |
| musl | 1,336 | 635.504 ms | 634.120 ms | −0.27% |
| Buster compiler main | 1 | 609.097 ms | 609.416 ms | −0.09% |

The standard and dedicated SQLite series used separate process observations. Both place the ordinary compile near 114 ms. The archive includes the measured SQLite runs for the two earlier heads. Their other three corpora retain the six native preflight, policy and stage runs completed before their correctness defects were identified. [Raw records](measurements/standard-raw.tar.gz), [all observations](measurements/standard-observations.tsv), [paired summaries](measurements/standard-summary.tsv) and [object manifest verification](oracles/standard-objects.tsv).

## Source-local identifier spelling

A separate 7940HS experiment reused a representative for equal one-to-four-byte names within a source block. SQLite performed 282,185 canonical string-table lookups for 454,224 raw identifier occurrences, saving 172,039 lookups. The isolated refinement stage grew from 2.983 to 5.063 ms. Prebinding single-letter names alone took 3.115 ms. Both variants passed the protected-page, randomly generated and frozen source comparisons. Their timing evidence is specific to the 7940HS refinement stage. [Representative source](source/representatives.patch), [single-letter source](source/letters.patch) and [local timing and oracle receipts](measurements/short-spellings-local.tar.gz).
