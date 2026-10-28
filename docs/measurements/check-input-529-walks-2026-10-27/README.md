# Sparse checker-reader visits, completed 9700X qualification

This retains the previously queued final campaign for Buster #529 / PR #646. It compares main
`92c025e71856d13eb34247477c5294d2cead139e` (`main2`) with
`6073258205b6183d450107f5d61234954a53d562` (`head4`), before #640's retained traversal is integrated.
Later `70ad02c5` changes comments and `6ce1d73a` documentation. Source-file SHA-256 manifests are in `manifests/`.
This is not a measurement of the later combination with #617 or #640.

The host was benchpress, Ryzen 7 9700X, Clang 23.1.1, the ordinary optimized `BUSTER_DEBUG_INFO=0` build.
Each campaign step ran through the host's shared `exclusive.sh`; timed single-thread work was pinned to CPU 2.
`scripts/` contains the prepared reproduction scripts and `runs/` the completed final outputs plus their actual
per-step scripts. `runs/final.log` ends with `final done`.

The frozen SQLite source is `/var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c`, SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`. Whole compiles use `-c`,
`-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE` and its directory
as an include path. The reader-only benchmark uses the frozen corpus's pinned predefines and headers; its token
denominator differs from the system-header whole compile, as the raw outputs state.

| Completed measurement | main | sparse visits |
| --- | ---: | ---: |
| 8 alternating perf rounds, task-clock median (`-r 3` each) | 146.340 ms | 141.725 ms |
| user-cycle median | 690,794,554.5 | 664,728,755.5 |
| user-instruction median | 1,552,456,510 | 1,471,593,803 |
| whole-process wall median, main-first (`measure-compile`, 11 rounds) | 146.462 ms | 142.098 ms |
| whole-process wall median, reverse comparison | 147.174 ms | 142.364 ms |
| check-input stage median | 63.682 ms | 58.927 ms |
| reader-only direct benchmark (11 passes) | 53.912 ms | 49.375 ms |
| peak RSS, main-first | 512,872 KB | 510,820 KB |

The matched perf medians reduce task clock by 3.15%, user cycles by 3.77% and user instructions by 5.21%.
One sparse-visit perf round is visibly higher (146.08 ms); all observations are retained rather than filtered.
The direct reader retains the same 234,336,400 bytes; its scratch-written extent grows by 706,240 bytes, the
per-token visit column. Its vector source-order walk visits 259,723 tokens and its expression walk 516,571.

`check-head4` records unchanged objects for one lane, eight lanes and the scalar path, plus stage reports.
`tests-head4` retains the target checker-suite results. These are correctness checks, distinct from the performance
comparison. No generated object or external SQLite implementation is copied into this record. Corpus inputs and
system headers retain their own terms; the scripts and manifests refer to the existing frozen corpus.
