# String initializer scaling, Buster #593

This record compares Buster's default `-c` path on generated inputs with one,
two, four and eight times as many string initializers. It also retains an
ordinary SQLite control. Times are whole fresh processes or the compiler's
explicit stage clock; these are different quantities.

## Revisions and machine

- Base: `buster14a/buster` main at
  `d8805cb7436542f16e1015c29f66feb15dac7c81`.
- Candidate: `3c0264e74ace5b8a5d532112cf012367511f3122` on
  `codex/593-linear-string-initializers`.
- Both trees built separately with `BUSTER_DEBUG_INFO=0 ./build.sh`, Clang
  23.1.1, `-O3 -march=native -fwrapv -funsigned-char -fno-strict-aliasing` and
  the unchanged build's remaining flags and linker selection (wild).
- AMD Ryzen 7 9700X; Linux `6.18.50-2-lts`; CPU 2, whose SMT sibling CPU 10
  was offline. `logs/setup.log` records the compiler, tcc, kernel, CPU and
  executable hashes. All builds, compiler tests, timings and counter runs on
  that host held its shared `exclusive.sh` lock.
- `base-sources.sha256` and `head-sources.sha256` cover all 646 tracked files
  of each source snapshot. Every hash was checked on the measured host;
  the successful checks are in `logs/setup.log`. Build products and the
  external c-testsuite checkout are outside those source manifests.

The issue's original timings were on hosted EPYC processors at `8fcf19c`.
Those numbers are context, not a matched baseline for this 9700X comparison.

## Inputs and measurement protocol

`generate.c` creates seven shapes at 20,000, 40,000, 80,000 and 160,000 entries:

1. A table of distinct ordinary string pointers, with a `get(int)` accessor.
2. The same table with identical literal contents at every occurrence.
3. A table of wide string pointers.
4. Records containing an integer, a string pointer, a double and two shorts.
   N counts complete records, each with one string literal.
5. N separate pointer declarations initialized by distinct strings.
6. N separate static character-array declarations initialized by strings.
7. An integer-table control.

`inputs.sha256` identifies every generated source. The sources are reproducible
from the generator; their large contents and the generated binaries are not
duplicated in this record.

## Results

All seven shapes remain linear through 160,000 entries after the change. The
full four-size stage and whole-process tables are in `tables.md`.

| Shape, 160,000 entries | Base wall ms | Candidate wall ms | tcc wall ms | Speedup |
| --- | ---: | ---: | ---: | ---: |
| Distinct strings | 16,432.625 | 148.418 | 59.139 | 110.72x |
| Repeated strings | 16,125.557 | 141.034 | 54.740 | 114.34x |
| Wide strings | 16,472.038 | 158.920 | 110.072 | 103.65x |
| Records containing strings | 17,273.350 | 446.806 | 122.655 | 38.66x |
| Separate pointer declarations | 4,917.781 | 231.281 | 103.431 | 21.26x |
| Separate character arrays | 4,884.362 | 205.742 | 71.050 | 23.74x |
| Integer-table control | 51.261 | 50.192 | 11.824 | 1.02x |

The integer table was already linear and stays so. Its small wall-time delta
is not a general compiler speedup claim. Whole-process and stage-clock medians
are separate quantities, so their independently measured medians need not add
up to the default process's median.

The index is the reader's existing four-byte-per-token column, moved from
scratch to output ownership so it survives expression checking. It adds no
second index or per-initializer allocation, but keeps the column alive longer.
The largest observed RSS increase is in the 160k separate-character-array
case: 813,188 to 828,728 KiB (+15,540 KiB, +1.9%). Its 80k case grows by 2.9%.
The other 160k shapes range from a decrease of 880 KiB to an increase of
1,192 KiB. These observed peaks and all smaller cases are retained in the table.

The ordinary SQLite control shows no meaningful whole-process timing change.
Each cell is the median of eleven fresh default-path processes after two
warmups, with base/head order alternating between pairs:

| Pair | Base wall ms | Candidate wall ms | Candidate change |
| ---: | ---: | ---: | ---: |
| 0 | 146.560 | 146.694 | +0.09% |
| 1 | 146.963 | 146.798 | -0.11% |
| 2 | 146.784 | 146.894 | +0.07% |
| 3 | 146.218 | 146.630 | +0.28% |

The median of these four pair medians is 146.672 ms for the base and
146.746 ms for the candidate (+0.05%). All individual process times, stage
reports and memory results remain in `logs/sqlite-*.log`.

User instruction and cycle counters are separate `perf stat -r 3` experiments;
each number below is perf's mean across its three processes. All events report
100% running time, with no unsupported or uncounted events.

| Workload | Base instructions | Candidate instructions | Base cycles | Candidate cycles |
| --- | ---: | ---: | ---: | ---: |
| SQLite pair 0 | 1,556,295,920 | 1,546,309,742 | 693,128,075 | 692,343,328 |
| SQLite pair 1 | 1,556,295,871 | 1,546,309,744 | 690,970,363 | 688,855,046 |
| SQLite pair 2 | 1,556,296,007 | 1,546,309,740 | 687,333,381 | 691,890,507 |
| SQLite pair 3 | 1,556,296,838 | 1,546,309,900 | 691,871,187 | 694,470,804 |
| 160k distinct strings | 297,753,582,427 | 3,321,967,079 | 90,907,701,710 | 713,321,521 |

The string stress case executes 98.88% fewer user instructions. SQLite uses
about 0.64% fewer instructions in each pair, while its wall times overlap.
The control's two Buster objects and the stress counter run's two objects are
byte-identical; their hashes are in `control-objects.sha256`.

## Measurement details

The primary protocol is `compare.c`, run by `comparisons.sh`. A bounded run
compares one table shape at 20k/40k/80k, or separately at 160k. The remaining
separate-declaration shapes and their integer control are grouped into one
bounded matrix to reduce queue overhead. Each size has one
discarded warmup and three measured rounds. Five variants rotate by round and
size: the base, candidate, tcc, base with `--time-stages`, and candidate with
`--time-stages`. Every invocation receives the same `-c inputs/NAME-N.c`, with
a separate output object. The harness uses `CLOCK_MONOTONIC` from fork through
`wait4`, records peak RSS, validates child exit status, and reads the two stage
reports from retained child logs.

Each `sample` row retains its warmup flag, variant, whole-process wall time,
RSS and the two relevant stage times. Each `summary` is the median of the
three measured values for that variant; stage medians come from its clocked
variant, while whole-process medians come from its default variant. Phase fields
are populated only for the two clocked variants; zeroes in those fields on
default/tcc rows are placeholders. No sample is omitted for its timing.
`summarize_pairs.c` reads these summaries into
`tables.md`, failing if any expected summary is absent.

After every round, the four Buster objects must be byte-identical. After each
size, `verify.c` is compiled by Clang and linked separately with base, candidate
and tcc objects, and all three programs must pass independently stated runtime
expectations. Every array entry is checked; for the separate-declaration
shapes, the accessor checks the first and last declarations and the complete
Buster object comparison covers all emitted declarations.

The primary matrix comprises 560 compiler processes including warmups, 112
rounds with all Buster objects identical, and 84 successful linked runtime
checks. `comparison-*.csv` also records all child statuses and comparison
outcomes. Empty successful child logs may be omitted from the published record;
their statuses remain in the CSVs. Object hashes are retained separately.

`control.sh` records four alternating-order SQLite pairs with
`measure-compile --runs 11 --warmups 2`, plus user instruction/cycle counters
from three processes per variant and pair. It uses the repository's frozen
SQLite amalgamation and the same `SQLITE_OMIT_LOAD_EXTENSION`,
`SQLITE_THREADSAFE=0`, `SQLITE_ENABLE_MEMSYS5` and `SQLITE_ENABLE_RTREE` options
as the existing compile-time qualification. Its two objects must match.
The same script records three instruction/cycle runs of each default compiler
on the 160k distinct-string input. Counter outputs retain every reported event.

## Correctness validation

- `test-checker --seed 133`: 265,500 checks, zero failures, including indexed
  literal lookup after pool reordering; concatenated, parenthesized and wide
  string copies; record initializers; and static-assert messages with strings
  in their conditions.
- `test-checker-deferred`: 70 fixtures, 1,113 checks, 684 merges, 6,480 bodies
  read apart, zero failures. Corpus comparisons now include the literal index;
  a new fixture mixes top-level and function-local string initializers.
- `test-checker-driver`: 21,591 checks, zero failures.
- c-testsuite at `5c7275656d751de0e68b2d340a95b5681858ed07`: all 220 programs
  and all 220 required subset entries pass end to end with `--cross-check`.
- `./build.sh check-call-graph`: 41 translation units, 23,944 functions,
  143,322 calls, zero prohibited cycles and zero split variables.

The first c-testsuite invocation found no corpus because the final rebuild
had removed its earlier build-directory checkout. The corpus was fetched again
at the same pin, and the complete run passed. The initial diagnostic is kept
as `logs/test-c-testsuite-missing-corpus.log`; `logs/remaining-tests.log` records
the successful corpus and call-graph runs through the native parallel runner.

The initial per-executable `measure-compile` protocol completed preliminary
20k and 40k distinct-string samples before being stopped in favor of the full
rotating A/B protocol above. Its logs and scripts are retained separately as
preliminary evidence and are not mixed into the primary table. No production
source changed between these protocols.

## Reproduction and scope

Extract each pinned compiler revision to sibling `base/` and `head/` folders,
and copy this record's tools and manifests into their sibling `evidence/`.
Build the trees separately through the shared lock, then run `setup.sh`,
`comparisons.sh` and `control.sh` from `evidence/`. The scripts record the issue
as their owner link, acquire the lock per bounded benchmark/counter invocation,
and yield between the comparison batches. `STOP` stops future comparison
batches. `STOP_OLD_CAMPAIGN` is only the retirement switch for the preliminary
protocol and is not needed for primary reproduction.

After building both snapshots and changing into `evidence/`, the complete
measurement and validation commands are:

```sh
export EXCLUSIVE_OWNER=codex-593
export EXCLUSIVE_TITLE='Buster #593 string initializer scaling'
export EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/593
mkdir -p logs
"$HOME/buster-fast-bench/exclusive.sh" bash setup.sh > logs/setup.log 2> logs/setup-lock.log
bash comparisons.sh > comparisons-progress.log
bash control.sh > control-progress.log
"$HOME/buster-fast-bench/exclusive.sh" bash finish.sh > logs/record-validation.log 2> logs/record-validation-lock.log
```

The scalar checker twin remains a correctness oracle: these changes share its
indexed lookup and message marking, and the tests exercise both twins. The
scaling measurements are of the production default path. The scalar twin's
deliberate value-chain walks, retained as the independent reference for #529,
are outside this timing claim. These generated tables establish this issue's
scaling behavior; they do not establish a general compiler throughput gain.

All new compiler changes, fixtures and measurement tools are original project
work under the existing submission terms. Clang and tcc run as external
compilers/oracles; c-testsuite and SQLite are external runtime inputs, not
incorporated implementation. Shared-lock waiting messages are kept out of the
public logs because they identify unrelated sessions. Only this campaign's
measurements and diagnostics are published.

The harness was extended at the remaining-declaration boundary to group those
shorter cases. `compare-v1.c`, `comparisons-v1.sh` and the original harness
binary hash retain the earlier scheduler; `compare.c` and `comparisons.sh`
provide the complete reproduction path. Both use the same child commands,
sample rotation, warmup policy, clocks and verification. No compiler source or
generated input changed, and no completed primary sample was replaced. The
completion marker lets the original scheduler retire without duplicate runs.

The control scheduler was also retired while waiting for the fourth base's
counter run, after all eight paired timing reports and seven counter sets had
completed. `compare --finish-controls` executes the unstarted suffix as one
bounded control experiment: the fourth base counter set and the two 160k
string counter sets. It preserves completed files and uses the same commands
and sample counts as `control.sh`; no measured child was interrupted.
It runs the final log and object-hash validation while still holding that lock.
This control-resumption helper was added after the primary matrix completed;
it does not change the primary comparison commands or sample selection.
