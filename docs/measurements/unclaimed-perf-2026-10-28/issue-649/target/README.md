# Issue 649: native 9700X qualification

All runs use the shared `exclusive.sh` lock with an owner, descriptive title
and issue link. Timings are pinned to CPU 2; no host settings were changed.
The host compiler is Clang 23.1.1, `BUSTER_DEBUG_INFO=0`, the normal `-O3
-march=native` build. New code and tests remain local; no PR or push was made.

| Image | Source commit | SHA-256 |
| --- | --- | --- |
| Baseline | bc1b486150850fe00bad1361a19f57d67706bb3b | d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d |
| Candidate | 123d22aef6f9298541dbe869ba00e794805322c4 | 3b375bfeb0547b11a63803c4749f3ad5e580925e1a3804e7037f98cf588aadb2 |

The complete native preprocessor/Clang test suite passes, including 325 guarded
prefix batches, all 64 pragma alignments, a >1 MiB rollover, both marker modes,
long/spliced/UCN/trigraph spellings, embeds and 3,000 differential fuzz cases.
The successful build and complete test output are retained.

## Measurements

The existing `benchmark-preprocessor --only vectorized` runs a warmup and 21
passes, measuring preprocessing and printing separately. Each row below is a
fresh benchmark process. Binary order rotates by pair. The pipeline column
includes initialization, preprocessing and printing to `/dev/null`; release
is reported separately by the benchmark.

| Input / pair | Printing, baseline → candidate ms | Benchmark pipeline, baseline → candidate ms |
| --- | ---: | ---: |
| Frozen SQLite / 0 | 4.604 → 3.833 | 14.596 → 13.859 |
| Frozen SQLite / 1 | 4.638 → 3.853 | 14.790 → 13.903 |
| Frozen SQLite / 2 | 4.640 → 3.899 | 14.719 → 14.123 |
| Frozen main.c tree / 0 | 31.485 → 26.404 | 82.710 → 77.809 |
| Frozen main.c tree / 1 | 31.858 → 26.476 | 83.410 → 77.864 |

The independent fresh-process cohorts include startup, preprocessing,
printing to a real buffered file, closing it, and teardown. Each input has
21 rotated pairs, one task on CPU 2 per cohort, with all 42 processes
succeeding. No `fsync` durability is requested.

| Input | Baseline median ms | Candidate median ms | Median paired delta ms |
| --- | ---: | ---: | ---: |
| Frozen SQLite | 15.799383 | 14.623850 | -1.150426 |
| Frozen main.c tree | 85.306138 | 78.067190 | -7.445492 |

These are `-E -P` results. They do not measure ordinary `-c` throughput. The
change optimizes bounded short-token copying; spelling lookup and exceptional
batches retain their existing routes.

## Output and input identities

All 42 preprocessed output files for each input match their baseline byte for
byte (`byte-oracle.log`). Each SQLite output is 2,358,163 bytes. Each frozen
main output has SHA-256
`d97203fa0cdc8abab405d739f5f671a7b2092d37b69509eeabf031154a22f776`.
The cohort helper's `object_bytes`/`.o` naming refers to preprocessed text in
these runs, rather than machine-code objects.

Both binaries read the same input paths. SQLite is source SHA-256
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`,
with the campaign's frozen headers and GNU17 predefines SHA-256
`a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33`.
Its flags are:

```sh
-DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
-DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17
--predefines corpus/gnu17-pinned-predefines.txt --clang-features
--target=x86_64-linux-gnu -march=znver5 -nostdinc
-isystem corpus/headers/usr/lib/clang/23/include
-isystem corpus/headers/usr/local/include
-isystem corpus/headers/usr/include -Icorpus/sqlite corpus/sqlite/sqlite3.c
```

The main.c input is always `base/src/buster/compiler/main.c` at the baseline
source tree, with `-Ibase/src`, the same pinned predefines and target, plus
`-std=gnu17 -fwrapv -funsigned-char`. It uses the host's complete default
header search paths for both binaries. Header package identities and stderr
comparisons are retained in `stderr-and-headers.log`. Prepared input bytes
are 10,219,361 for SQLite and 29,873,972 for the main.c tree; the whole-process
helper's `source_bytes` counts only the top-level file, so its main.c MB/s is
not used here.

The earlier `main-base-0.log` and `whole-main-ab/` trials used the SQLite-only
header capsule and failed because it lacks `linux/audit.h`. Their errors and
partial output remain retained and excluded. Valid main results use the
distinct `main-host-*` and `whole-main-host-ab/` prefixes. A nonempty output
from a failed compiler is never accepted as a measurement.

The campaign `samples.c`/`cohort.c` helpers retain every round, role, child
status, wall time, CPU/resource counts and output. Binary order rotates by
round; summaries use all samples without trimming. User/system resource
splits on short processes are retained as reported and do not replace the
whole-process wall measurement.

## Later interference audit

A retrospective packaging-interference screen is in `contamination-audit.txt`. The extra reversed main phase pair1 has uncertain overlap with other work and is retained but excluded from acceptance. All three SQLite phase pairs, main pair0, and both 21-pair whole-process cohorts predate the reported windows and remain the qualification basis.
