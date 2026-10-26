# Loop-hint diagnostic ordering (#503)

Original correctness and default-driver cost evidence for
[Buster #513](https://github.com/buster14a/buster/pull/513), fixing
[#503](https://github.com/buster14a/buster/issues/503).

The parent is #480's loop-hint implementation at
`46b4e0d4295f7a40070199018b5fa60d5d0ef003`; the candidate is
`604d782c4be2ed10506e13f8e28a9ebc03c7b930`. Both include #480's latest
initializer fix. Both sources were exported with `git archive`. The
changed-file manifest was verified on the target before building.

## Machine and procedure

The shared Ryzen 7 9700X, Linux/x86-64, with every build, test run and
measurement holding `~/buster-fast-bench/exclusive.sh` separately. Measurements
use CPU 2. Both compilers use the unchanged
`BUSTER_DEBUG_INFO=0 ./build.sh`: Clang 23.1.1, `-O3 -march=native -Isrc
-fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror`, without debug
information. Tool, input, source and binary identities are recorded in
`final-receipt.txt` and `final-source-files.sha256`.

`measure.c` is an original C harness. Its `--generate` writes one or 1,024
functions, each with `vectorize(disable) unroll_count(4)` before a for loop.
These exercise the successful pragma path; the tiny file also exposes startup
cost. The large general workload is the external frozen SQLite amalgamation
at `~/buster-fast-bench/refine-claude/inputs/sqlite3.c`; its source is not copied
into this record.

For each input and scalar/vector mode, one untimed successful process per
variant warms the inputs. Six blocks alternate ABBA and BAAB, two fresh
processes per variant per block (12 measurements per variant). Every process
must exit successfully; a refusal fails the harness. The driver arguments are
`-fsyntax-only -std=gnu17 -march=znver5 FILE`, with `--scalar` for that mode.
The vector invocation repeats `-fsyntax-only`, which has the same effect.
`measure-matrix.c` calls that exact procedure for all six input/path cases
as one bounded benchmark run. `reproduce.sh` records its commands and locking.

CSV rows contain wall nanoseconds from before fork through wait, child user
and system microseconds, and peak RSS in KiB. The paired percentage is the
head/base ratio of each block's two wall-time sums, minus one. The mean and
Student t interval (six block ratios, df=5, critical value 2.571) appear in
each sample log. `summarize.c` verifies all 24 rows per case and computes the
table, retaining every successful sample. An interval containing zero
establishes no positive improvement or regression. This small campaign does
not prove equivalence, and a single pair of builds does not separate changed
work from code placement or frequency effects.

## Results

All 144 timed processes and 12 warmups exited successfully. Every paired
interval includes zero, so this campaign establishes neither a speedup nor a
slowdown. The scalar hint-heavy case has a wide interval: its first parent
block includes a 10.963 ms process among processes near 8 ms. It is retained.

| Input/path | Parent median ms | Candidate median ms | Paired wall % [t95] | Peak RSS KiB, parent / candidate |
|---|---:|---:|---:|---|
| One hinted function, scalar | 0.778 | 0.779 | -0.598 [-3.470, 2.275] | 14156–14332 / 14228–14340 |
| One hinted function, vector | 0.726 | 0.722 | -0.332 [-0.928, 0.263] | 16352–16480 / 16416–16584 |
| 1,024 hinted functions, scalar | 8.044 | 7.967 | -3.411 [-9.720, 2.897] | 67048–67140 / 67080–67176 |
| 1,024 hinted functions, vector | 7.500 | 7.504 | -0.303 [-1.076, 0.470] | 74988–75048 / 75056–75184 |
| SQLite, scalar | 174.882 | 175.009 | -0.085 [-0.530, 0.360] | 545860–545984 / 545688–545880 |
| SQLite, vector | 146.932 | 146.844 | -0.021 [-0.512, 0.470] | 595028–595140 / 594920–595008 |

Raw samples and individual interval calculations are the six `final-*.csv`
files and their matching logs. [summary.md](summary.md) is the unedited output
of `summarize.c` over all six files.

The final candidate's manual qualification completed all five commands in
46.4 seconds, one at a time, under one bounded test-runner invocation. See
[final-tests.list](final-tests.list) and [final-tests.log](final-tests.log).

| Check | Result |
|---|---|
| `test-checker --seed 133` | 254,175 checks, 0 failures |
| `test-checker-driver --executable ./build/compiler` | 2,171 checks, 0 failures |
| `test-checker-deferred` | 61 fixtures, 959 checks, 576 merged, 6,252 bodies read apart, 0 failures |
| `./build.sh check-call-graph` | 42 translation units, 23,693 functions, 140,606 calls, 0 unallowed cycles, 3 allowed cycles, 0 split variables |
| Parent external-driver negative control | 116 expected mismatches; exit 1 required and observed |

This is separate from the whole-compiler GitHub workflow. At the evidence
audit on 2026-10-26 UTC, [the candidate's 9700X CI run](https://github.com/buster14a/buster/actions/runs/40416052530)
was queued; its measurement-storage workflow had passed. A queued CI run is
not counted as passing qualification.

## Correctness and boundaries

The driver suite adds 43 original fixtures through scalar/vector,
direct/default command routes. They compare Clang's first-error location,
exact hint text where applicable, and absence of an emitted object. The cases
include reader and typed errors in while/for/do bodies, declaration
initializers, labels and switch cases, nested completions, argument versus
handler lookahead, later malformed statements, original versus synthetic
closure, and `_Pragma` source history. Existing malformed-argument and control
column differences are outside this change; those precedence cases compare
the first-error line. Five new deferred-reader fixtures compare ordinary and
deferred results, including a duplicate label before a hint conflict.

The negative control runs the candidate's suite with the parent's external
driver. Its mismatch failures demonstrate that the fixtures detect the old
behavior; the wrapper requires exit status 1. This is not a passing parent
diagnostic suite. The other direct routes still use the candidate inside that
test process.

The change reuses the reader's postorder subtree ends and parent links to
find statement completion. It adds no source rescan or successful-input
retained hint metadata. Only rejected pragma prefixes run the additional
control walk; forward label names are collected, while unfinished-function
obligations remain deferred. Temporary label-reference identities belong to
a diagnostic-only graph that cannot be accepted or emitted. The ordinary
control walk is specialized without prefix checks.

Both production parser/checker schedules exercise the existing scalar
exceptional pragma handling. The hint-heavy workload charges preparation,
handoff and the consumer to the whole driver, including allocation and process
teardown. Invalid-input performance is not measured. Counts not evaluated by
the literal-only reader remain unsupported; this does not implement additional
constant-expression evaluation or loop transformations. Source-corpus,
sanitizer and language-wide acceptance are not inferred from these suites.

## Provenance

The implementation, fixtures, generator and measurement tools are original,
under the repository's Apache-2.0 WITH LLVM-exception terms. Clang is an
external behavior oracle, not incorporated code. The compiler records its
LLVM source-reference provenance in `THIRD_PARTY_NOTICES.md`. This record
adds no external implementation, copied corpus source or new dependency.
