# #451 current-head completion accounting: native review plan

Root approved the local gates and the smaller initial stage: 12 whole-process
cohorts and 16 phase processes. Reuse the shared official-23.1.4 baseline;
do not build a second baseline or a source candidate. Expand only for a new
unresolved concern that could change the completion/disposition.

## Immutable bindings

`BIN` is `/home/david/buster-fast-bench/unclaimed-perf-20261028/integrated-e7-672-clang2314/compiler-native`,
SHA-256 `06132c96872df0d3ffa910c0c7ef7814f0547deb4f40209840bcba1c63f1947e`.
`SRC` is that directory's `source` subdirectory. `CLANG` is `bin/clang` under
`/home/david/buster-fast-bench/unclaimed-perf-20261028/toolchain-clang2314/buster/benchpress-clang/efdd1dbd089b99bfcfcde7b8eb1236163f2e88df5a981cca4f783ec9cb5e0378`.
Add that toolroot's `lib` to `LD_LIBRARY_PATH` for each process. Record hashes.
`RUN` is a new private `451-residual-e7f89091` directory under the shared
campaign root; `CORPUS` is the existing pinned corpus. All source builds,
tests, staging/extraction, hashing and measurements take the shared lock.

Every invocation has owner `codex-451-residual`, an individual descriptive
title and link `https://github.com/buster14a/buster/issues/451`. Use CPU 2 for
single-thread work. The file-lane gate uses physical CPUs 0 and 1. No host
settings change. Process-local environment for every child is:

```sh
env -u MAKEFLAGS -u MFLAGS -u GNUMAKEFLAGS \
  PATH="$(dirname "$CLANG"):$PATH" \
  SOURCE_DATE_EPOCH=1 BUSTER_CLANG_RESOURCE_DIR="$RESOURCE"
```

`RESOURCE` is the exact result of `"$CLANG" -print-resource-dir` (the directory
above `include`). Save Clang version/target, tool and resource identity. Main's
predefines come from the same tool and build flags:

```sh
"$CLANG" -std=gnu17 -O3 -g -march=native -fwrapv -funsigned-char \
  -fno-strict-aliasing '-DBUSTER_CLANG_DEFAULT_TARGET="x86_64-pc-linux-gnu"' \
  -dM -E -x c /dev/null > "$RUN/main-native-predefines.h"
```

Also run that tool's `-M -MT main451 -Isrc` on `src/buster/compiler/main.c`
with the same flags. `deps451` decodes escaped names into NUL-separated paths;
hash the complete source/header closure before and after the campaign. Verify
the source tree remains e7. Current main needs kernel UAPI headers such as
`linux/audit.h`; the old SQL header bundle is intentionally not used for main.
The four failed local attempts using that incomplete bundle are retained.

## Exact workload arguments

The following argument lists run from `SRC`. Arrays below only shorten this
review recipe; logs retain each fully expanded child argument list.

```sh
SQL_FLAGS=(
  -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0
  -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -std=gnu17
  --predefines "$CORPUS/gnu17-pinned-predefines.txt" --clang-features
  --target=x86_64-linux-gnu -march=znver5 -nostdinc
  -isystem "$CORPUS/headers/usr/lib/clang/23/include"
  -isystem "$CORPUS/headers/usr/local/include"
  -isystem "$CORPUS/headers/usr/include" -I"$CORPUS/sqlite"
)
MAIN_FLAGS=(
  -std=gnu17 --predefines "$RUN/main-native-predefines.h" --clang-features
  --target=x86_64-linux-gnu -march=native -Isrc -fwrapv -funsigned-char
)
```

For each workload, `W=131072` is explicit production window size; `W=2000000000`
forces whole-file preparation. This is a configuration comparison within one
executable, not a new source fix or a comparison to the historical builds.

```sh
"$BIN" -E "${SQL_FLAGS[@]}" --window-bytes "$W" "$CORPUS/sqlite/sqlite3.c" -o /dev/null
"$BIN" -fsyntax-only --lanes 1 "${SQL_FLAGS[@]}" --window-bytes "$W" "$CORPUS/sqlite/sqlite3.c"
"$BIN" -E "${MAIN_FLAGS[@]}" --window-bytes "$W" src/buster/compiler/main.c -o /dev/null
"$BIN" parse -fsyntax-only "${MAIN_FLAGS[@]}" --window-bytes "$W" src/buster/compiler/main.c
```

First run every argument list once as a preflight. For the two `-E` workloads,
write distinct output files and require byte equality between modes. Retain
every status, stdout and stderr, including any failure; do not time a failing
configuration. Hash the inputs, predefines and dependency closure.

## Local gates completed

Pure local e7 binary SHA-256
`523ceb8df0435c089e10ba78dbc8e08be8062d7a2f10d96f4c3bbd734006865a`:

- Preprocessor/Clang with fuzz disabled: 240 generated sources, 1,833 windowed
  preparations exact; cuts 119,625/0; directive places 976/0; line ends
  2,892,217/0; 24 units/93 windowed units/128,264 `__LINE__` outputs exact.
- Refinement: 520 files/26,584,594 bytes; randomized and 9,600 guarded tails
  exact. File preparation on one/two lanes passes, including resource failures.
- SQL and native-header main: `-E` and syntax/parse preflights pass in both
  configurations; complete `-E` bytes match. Main's 841 Clang dependencies
  hash and verify. Its 18 files at least 256 KiB total 8,173,523 bytes.
- Original ASan/UBSan work-count adapter: scalar/whole/window records and
  every token's line-page query agree for SQL, current encoder and the exact
  historical long-line/spliced inputs at 64/4,096/131,072-byte windows.
  Full SQL/main inclusions also pass, with byte-identical `-E` outputs to the
  uninstrumented binary and each other. Main's page-covered byte sum equals
  the independent 18-file dependency inventory above.

## Native correctness/count gates

Reuse root's baseline QA where it covers the same gate. Otherwise, one lock
per `test-preprocessor --clang --fuzz 0 --seed 451 --jobs 1`,
`test-refinement src`, and `test-files --lanes 1,2 --seed 451` (respectively
CPU 2, CPU 2 and CPUs 0/1). Typical budget is 1–30 seconds each, with the
Clang fixture suite conservatively allowed up to 90 seconds.

Build the small original C generator/dependency reader, generate the two
historical inputs with 8,000,000 bytes/seed 451, and build `prepare451` with
the exact official tool and `-O2 -g -march=native`, ordinary wrap/alias flags,
function/data sections and linker GC. This is a diagnostic helper, not another
compiler baseline. Expected helper build budget: 10–60 seconds. Its generated
copies change only module linkage and call/byte accounting, never a lexer or
preparation algorithm. The helper runs under CPU 2 and prints host-vector=1.

Run its exact file-record/page oracle on SQL, current encoder, long-lines and
spliced inputs, then its `--preprocess -E` route on SQL and main in both modes.
Require all statuses and complete output comparisons to pass. Budget 1–30
seconds per helper invocation. Counters are logical requested byte ranges,
not hardware traffic; the helper is never used for latency/RSS attribution.

## Whole-process controls

For each of the four argument lists, use **one input and two roles only** in
each `time-runs` invocation. One initial cohort each of:

- A/A: both lists are the exact `W=131072` arguments;
- A/B: first list `W=131072`, second list `W=2000000000`;
- reverse B/A: first list whole, second list windows.

One fresh lock per cohort, with the fixed process environment and:

```sh
taskset -c 2 "$BIN" time-runs --runs 21 --warmups 2 --copies 1 \
  --directory "$RUN/copies-UNIQUE" --build e7 "$BIN" \
  --list CHILD_ARGUMENTS_ROLE_ONE --list CHILD_ARGUMENTS_ROLE_TWO
```

There are 12 cohorts: 504 timed children plus 48 warmups. The two slots are
list roles of the same executable; analyzers must not confuse them with two
builds. Expected lock time: 1–30 seconds per cohort; conservatively under 90
seconds for main parsing. Confirm from preflight and shorten/split batches if
needed to keep each grant near or below two minutes. Never combine inputs in
a cohort: the earlier campaign's mixed-input predecessor bias is preserved
separately and is not repeated here. Report paired round distributions and
A/A/reverse dispersion, wall/user/system time, RSS, faults, statuses and PMU
availability. Missing counters stay unavailable.

## Preparation phases and release

Two alternating window/whole process pairs for each of SQL, current main,
long-lines and spliced inputs; one lock per process, CPU 2. Each command uses
the benchmark's existing 21 passes and reports all phases and release:

```sh
"$BIN" benchmark-preprocessor --only vectorized "${SQL_FLAGS[@]}" --window-bytes "$W" "$CORPUS/sqlite/sqlite3.c"
"$BIN" benchmark-preprocessor --only vectorized "${MAIN_FLAGS[@]}" --window-bytes "$W" src/buster/compiler/main.c
"$BIN" benchmark-preprocessor --only vectorized --window-bytes "$W" "$RUN/inputs/long-lines.c"
"$BIN" benchmark-preprocessor --only vectorized --window-bytes "$W" "$RUN/inputs/spliced.c"
```

Expect 1–20 seconds per process. These are configuration measurements under
the current debug-enabled baseline, kept separate from historical #462/#486
release builds and the rejected page-line fusion. Benchmark release is
reusable-call teardown; terminal source commands may leave mappings to exit.

## Raw artifact inventory

Keep source/binary/tool/resource/predefine/input/header identities; reuse
the shared baseline build/QA receipt by exact reference. Retain the original
C sources, generated copies, commands, helper build/gate logs, direct byte
comparisons and output hashes, all preflight failures, 12 complete whole-run
logs, 16 phase-process logs, derived summaries and parser negative controls.
Verify every expected child/status/round before summary. Preserve uncounted
PMU state and all zero/nonzero faults as recorded. Native staging, packaging,
compression and hashes also hold the target lock. The compiler branch stays
free of measurement artifacts. No new source-performance improvement claim.
