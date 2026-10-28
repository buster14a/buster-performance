# Issue 658: bounded integer literal tables

Compiler source: `e056a4297c98c7ee3ef3c5c113834f63acbf448b` on
`codex/perf-658`, based on `bc1b486150850fe00bad1361a19f57d67706bb3b`.
No PR or push. Original C generators, native oracles and raw logs are retained
here, outside the compiler repository.

The change accepts file-scope ordinary integer arrays with at least 128 literal
elements only after proving their brace/comma grammar and exact representable
conversion. It batches syntax and common literal spellings, keeps one payload
and one initializer part in source order, and skips expression graph nodes for
the table. The scalar compact path and ordinary dense graph are permanent test
oracles. Unsupported or warning-producing cases keep the ordinary path.

This is a bounded part of #658: reader token columns, lexing and parsing remain.
It does not reach the issue's few-nanoseconds-per-element/minimal-memory goal,
optimize floating/automatic/volatile tables, or establish a general throughput
improvement. It is distinct from the automatic initializer pool owned in #598.

## Local correctness

The final release built all 41 units (`build-final.log`).

- Full checker, seed 658: 392,250 checks and exactly four existing fpclassify
  oracle disagreements (`checker-final.log`). The centrally frozen baseline
  has the same four: `../evidence-integration/base-checker.log`, seed 20261028,
  389,418 checks. Seed/count differences prevent interpreting the count delta
  as the exact number of new tests.
- Focused ASan/UBSan: 2,838 checks, zero failures (`asan-final.log`), including
  compact vector/scalar/dense equivalence, native Clang comparisons, guarded
  input/output tails, failed reservations and deferred type replay/fallback.
- Driver: 21,639 checks, zero failures (`driver-corrected.log`).
- Call graph: 41 units, 25,116 functions, 149,594 calls, zero bad cycles,
  three allowed cycles and zero split (`call-graph.log`).
- Five frozen-baseline/candidate objects were byte identical: byte tables
  128/100k/800k, int table 320k, zero table 100k. An independent native oracle
  checked 1,025 indices per object, 5,125 total, zero failures
  (`native-equivalence.log`). A 129-element `-5U` to long table was also byte
  identical; a final malformed `1zz` literal had equal failure status/stderr.

Retained unsuccessful attempts: `build-tests.log` contains an unused helper
build failure; that helper was removed and `build-tests-fixed.log` and the
final build passed. `driver-final.log` was invoked with `--executable` but without its
required value, producing two invocation failures; the complete corrected
command and passing result are in `driver-corrected.log`.

## Local cost screen (not Zen 5 acceptance)

Ryzen 9 7940HS, shared development machine, two-core build/run grant, one
compiler lane. Both images use matching native Clang release builds and normal
object output. `measure-compile` also verified default/instrumented outputs;
cross-image byte identity was checked separately above. Retain all rounds and
warmups. These are large-effect screening results, not general speed claims.

| Table | Candidate median | Frozen baseline median | Candidate peak RSS | Baseline peak RSS |
| --- | ---: | ---: | ---: | ---: |
| 100k bytes (early image, 3 rounds) | 17.288 ms | 40.646 ms | 153,080 KiB | 218,788 KiB |
| 800k bytes (final, 5 rounds) | 104.115 ms | 343.459 ms | 649,364 KiB | 1,215,344 KiB |
| 320k ints (final, 5 rounds) | 57.789 ms | 152.199 ms | 341,020 KiB | 552,692 KiB |

The first image is retained as `compiler-initial`. Exact final binary/input
hashes are in `identities.sha256`. Representative generated instructions are
retained in `literal-batch.asm` and `literal-prepare.asm`; these include vector
digit transforms/comparisons and masked narrowing stores.

## Native 9700X qualification

Target artifacts and the final method/results are under `target/`, especially
`target/METHOD.md` and `target/RESULTS.md`. The source
is archived directly from the commit above. Baseline native compiler SHA-256:
`d4420d3786771dc3f9b851b6931bc8d8cdb7d01959b3213f4927821847fe871d`.
Every build/test/benchmark takes the shared host lock with owner/title/issue
link. No host settings are changed. Large compilations are sequential on CPU 2.

`generate_table.c` creates the byte/integer/zero/negative, volatile, float and
malformed sources. `run_table.c` computes an independent index/value oracle,
including count-1, count, UINT_MAX and 1,021 further wrapped indices.
`native_qa.c` executes both frozen compilers, compares full output objects and
diagnostics, links candidate objects with Clang and runs the native oracle.
The invalid source must fail identically and create no object. All helpers are
original C with their source retained.

Exact native correctness passed: checker 392,250/0, driver 21,639/0, all nine
accepted table objects byte identical with 9,225 independent runtime checks/0,
and the malformed table rejected identically with no object. Target logs are
`native-checker.log`, `native-driver.log`, `native-equivalence.log` and each
case's `.base.log`, `.head.log`, `.run.log`, and objects under `target/`.

The 800k diagnostic `stages-uchar800000.log` also verifies default/instrumented
object equality. Its five-run native medians were 75.655 ms candidate and
223.273 ms baseline. Candidate check-input remains 45.945 ms (61.2% of its
instrumented span) and parse 15.276 ms (20.3%): the remaining front-end costs
are material. Prefer the separate uninstrumented 21-pair scaling series for
the final effect estimate; this diagnostic explains its practical limits.
