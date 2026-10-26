# Label-address cost in the checker (#449), 2026-10-26

The candidate removes the four unconditional label-address tests identified in
[#449](https://github.com/buster14a/buster/issues/449), reuses already-loaded
kind/role information, and omits `check_program`'s addressed-label allocation,
clearing and scan for units without label addresses. Units that have them use a
bounded vector filter with an exact scalar twin. This is original project work;
the generated workload expands the project's existing original dispatch fixture.
The [claim](https://github.com/buster14a/buster/issues/449#issuecomment-6413010319)
names branch `codex/449-label-address-hot-loops` and its scope.

The campaign measures a 2.315 million instruction saving on SQLite, rather than
establishing recovery of the issue's historical 13.3 million instruction increase.
No material wall-time or peak-RSS regression appears in these measurements.
Historical attribution remains open; do not use this record to close that
stronger instruction target without further evidence.

## Revisions and host

- Baseline: `9de3d30ba437b381394095d7a77635a2e877435d`.
- Candidate compiler source: `c79bc86e249de2d33c3dd89cd9bbda471888daef`.
- The branch later carries separate CI resource guards as
  `1a529bc54c1977c0e2dec0881aa64396957ec03a` and
  `2f6bbb6f7cce2afb1f811bdbeddf16caca20b994`. Those change no compiler source
  or build flags from the measured candidate.
- Ryzen 7 9700X, Linux `6.18.50-2-lts`, Clang 23.1.1, perf 7.2.9-1;
  `performance` governor with `amd-pstate-epp`, CPU 10 offline. Every
  measurement command was pinned to CPU 2. Host, kernel, microcode and other
  configuration observations are in the
  [shared host receipt](../coordination-449-450-451-2026-10-26/raw/host.txt).
- Native builds used `BUSTER_DEBUG_INFO=0`, `-O3 -march=native -Isrc -fwrapv
  -funsigned-char -fno-strict-aliasing -Wall -Werror`, and `/usr/bin/wild`.
  The candidate build is in [raw/build.log](raw/build.log); the baseline was
  built once for all three coordinated campaigns, separately from measurements.
  Native binary hashes are in the
  [shared binary manifest](../coordination-449-450-451-2026-10-26/raw/native-binaries.sha256):
  baseline `a5faaad818d33f1ea44a31be5550f9988db009d323ef09a13f7def702c782de5`,
  candidate `7255ef286ac8c6423f5a26e4cf4aa19a52ff964340a91329b8c95609beaa1372`.
  [raw/source-tree.txt](raw/source-tree.txt) retains the candidate tree's object IDs.

Only the coordinator accessed Benchpress. Every preflight, process command and
perf command entered the existing `~/buster-fast-bench/exclusive.sh` lock, with
the owner/title/link and completion status retained in its raw log. The lock was
released between commands; unrelated sessions could interleave between holds.
No build ran during a measurement hold. The shared coordinator record documents
the [resource budgets and FIFO campaign order](../coordination-449-450-451-2026-10-26/README.md).

## Experimental design and inputs

[queue449.sh](queue449.sh) performs eight preflights, then five rounds in
alternating tree order. Each tree has three commands per round: SQLite perf,
label-dispatch perf, and a four-list process run. Every one has its own shared
lock hold. All 38 command logs completed with status 0.

[commands449.sh](commands449.sh) is the exact command authority. The process
runner uses `time-runs --runs 21 --warmups 2`, rotating the four lists' order
within each run. That is 105 measured processes per workload and tree, or 840
measured processes in total, plus 80 warmups. The perf runs use
`perf stat -x, -e instructions:u,cycles:u -r 11`, for 220 counted processes in
total. `perf -r` prints an event mean: the reported counter result is the median
of five round means, not a median of individual counter observations.

| Process list | Arguments after the executable |
| --- | --- |
| SQLite checking | `-fsyntax-only` with the pinned predefines, `--clang-features -march=znver5 -std=gnu17 -nostdinc` and three frozen system include roots |
| Lua string library | `-c /home/david/buster-fast-bench/x87-136/lua/lstrlib.c -o /dev/null` |
| Lua parser | `-c -U__ELF__ /home/david/buster-fast-bench/x87-136/lua/lparser.c -o /dev/null` |
| Label dispatch | `-fsyntax-only label-dispatch-128.c` |

The environment uses `SOURCE_DATE_EPOCH=1792454400` and unsets `CPATH`,
`C_INCLUDE_PATH` and `CPLUS_INCLUDE_PATH`. System headers are the frozen
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658/headers` tree. Its
predefines and header hashes are retained under the shared record's
[frozen configuration](../coordination-449-450-451-2026-10-26/frozen-config/).
The [shared input manifest](../coordination-449-450-451-2026-10-26/raw/binaries-and-inputs.sha256)
includes these top-level inputs:

| Input | SHA256 |
| --- | --- |
| Frozen `sqlite3.c` | `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d` |
| `gnu17-pinned-predefines.txt` | `a39036d8215977b5a205f7fd3c4e7dfe6576b58eaa76a7bb0b0e214a164e8d33` |
| Lua `lstrlib.c` | `3257cd857653560773947d70b65c8b8bf8ef43f920ed449587fa662224d859e1` |
| Lua `lparser.c` | `c5507307586c1a2336a7722229f7b350ae9c548b854933b370ad150e9e6e7f84` |
| Generated `label-dispatch-128.c` | `b6d81b2fefd5bffa8ee5607589f959a1dbcfd520ea8ca7eba2b8555858821dc6` |

The generated unit has 81,030 bytes and 43,537 tokens. It expands
`c_check_program_test.c`'s `labels-as-values-dispatch` fixture into 128 independent
functions, exercising static address tables, conditional computed-goto operands,
address comparisons and jumps out of VLA blocks. To regenerate it:

```sh
clang -O2 -Wall -Wextra -Werror label-dispatch-gen.c -o label-dispatch-gen
./label-dispatch-gen 128 > label-dispatch-128.c
```

The generator and generated source are stored beside this record. Baseline and
candidate checking both succeeded. Candidate and Clang `-O0` executables both
return 0 against the independent expected sum `128 * 34122`.

## Results

Wall time, RSS and faults below are the medians of five round medians, each
round having 21 measured processes. Paired ranges use the same numbered round's
candidate and baseline. The full values, user/system times, faults and ranges
are in [summary.tsv](summary.tsv), computed from raw process rows rather than
copied from their printed summaries.

| Workload | Wall base → candidate (ms) | Change | Paired wall range | Peak RSS base → candidate (KB) | Minor faults base → candidate |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite checking | 147.709 → 147.175 | −0.3615% | −0.5610% to −0.2336% | 599,384 → 598,348 | 1,433 → 1,449 |
| Lua `lstrlib.c`, `-c` | 10.088 → 10.095 | +0.0694% | −0.3955% to +0.6357% | 81,824 → 80,952 | 764 → 782 |
| Lua `lparser.c`, `-c` | 8.360 → 8.379 | +0.2273% | −0.2033% to +0.6942% | 73,360 → 72,404 | 713 → 731 |
| Generated dispatch checking | 8.613 → 8.559 | −0.6270% | −0.9045% to +0.7113% | 82,312 → 81,268 | 671 → 688 |

All major-fault medians are zero. RSS round medians vary with process mappings;
the paired upper changes are +16 KB on SQLite, +4 KB on `lstrlib.c` and +8 KB
on the other two. These measurements support omitting the unused allocation,
but do not isolate every part of the RSS difference to its bytes. Minor faults
increase by 16–18 on the five-round medians; that change is recorded rather
than called a fault-count improvement.

| Input | User instructions base → candidate | Change | User cycles base → candidate | Change | Paired cycle range |
| --- | ---: | ---: | ---: | ---: | ---: |
| SQLite | 1,718,752,959 → 1,716,437,996 | −2,314,963 (−0.1347%) | 681,430,809 → 679,926,868 | −0.2207% | −0.4761% to +0.0782% |
| Generated dispatch | 108,016,015 → 107,930,163 | −85,852 (−0.0795%) | 28,781,833 → 28,859,404 | +0.2695% | −0.7254% to +1.2482% |

The candidate's gated vector scan does not create an observed net wall/RSS cost
on the label-using fixture. Its cycle change varies in sign by round, so this
record does not claim a cycle improvement there. The small Lua wall changes
are within their paired spreads. SQLite is faster in all five paired wall
rounds, with lower median instructions and RSS.

### The historical 13.3 million instructions

[#449's context](https://github.com/buster14a/buster/issues/449) compares
`2cb9299` with #431's `79cdafe` and attributes approximately 13.3 million extra
SQLite instructions to the label-address support. This campaign compares
current `9de3d30` with `c79bc86`, and saves 2.315 million instructions. It
establishes neither recovery of all 13.3 million nor a precise historical
residual: intervening compiler changes make subtracting the old numbers a
different comparison.

The four requested unconditional helper calls and unused addressed-label work
are removed by construction. Label-name exclusion during the ordinary binding
walk and label-object handling in selection/emission remain, as their semantics
require. Their contribution on these inputs has not been isolated here. A
current-base causal ablation or source-attributed profile is the next evidence
needed to account for any remaining no-label cost. Keep that attribution open;
do not label this record complete recovery of #431's measured increase.

## Correctness and qualification limits

The candidate's local 7940HS production build passes, with these validations in
[local-validation/](local-validation/):

- Parser with Clang: passed; Tier 0 cross-check: 152,136 checks, zero failures;
  c-testsuite cross-check: 220/220 programs passed, with two harness jobs.
- Checker: 249,318 checks and four floating-classification oracle mismatches.
  The unchanged baseline independently reproduces the same four in 249,187
  checks. All 131 added guarded filter/tail checks pass, including empty inputs,
  every tail through 129 tokens, logical `&&`, prefix roles and invalid targets.
- Full call-graph/split-state gate: 42 translation units, 23,474 functions,
  zero disallowed cycles and zero split variables; captures were capped at two.
- Focused ASan+UBSan checker runs: no ASan errors. Both baseline and candidate
  report the same two unchanged null/zero-length `qsort` argument violations
  in `c_lowering_symbols.c:180` and `:398`, plus the same four oracle mismatches.
  These are not sanitizer-clean runs, and the record does not call them so.
- Frozen SQLite acceptance and diagnostics agree with Clang. Its `--symbols`
  comparison remains unsupported for one existing C type/operation; symbol
  qualification is not claimed.
- `CheckInput.label_address_count` is zeroed with the complete input before
  each read, and counted once after any deferred-body merge. Lanes copy state
  before that phase, so no per-lane accumulation or stale reread count occurs.

The serial CI/capture resource guards are separate from the measured compiler
change. CI status and PR readiness must be checked on the eventual submitted
head. No PR is automatically merged, and this record does not close #449's
unresolved historical attribution.

## Recompute the table

```sh
clang -O2 -Wall -Wextra -Werror summary449.c -o summary449 -lm
./summary449 --self-test
./summary449 raw > summary.tsv
```

The C reader requires all 30 measurement logs and eight successful preflights.
It rejects missing completion receipts, nonzero statuses, missing/duplicate or
out-of-range process rows, failed warmups and missing/unavailable counters. Its
synthetic parser self-tests pass in normal and ASan+UBSan builds. An incomplete
campaign emits no result table. It reports counters as round means and uses
`NA` for undefined percentage changes when the baseline fault count is zero.
