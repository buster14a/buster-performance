# Attribute argument boundary scaling (#605)

Original measurement inputs and tools for
[Buster #605](https://github.com/buster14a/buster/issues/605), implemented in
[compiler PR #626](https://github.com/buster14a/buster/pull/626).

The reference is Buster `92c025e71856d13eb34247477c5294d2cead139e`.
The candidate is `35f25a629e990eceabd0ded3132759ec5f23089d`.
The candidate stores one u32 comma position per separator, with no boundary
allocation for zero/single arguments, and reuses those bounds in validation,
declaration ICEs and constant-reader preparation/evaluation. Boundary discovery
uses two forward walks; lookup reads at most two retained positions.

The initial complete scaling snapshot is commit
`34f8e27ec8d8fdfc69d19bba7608999413b51bfe`; the isolated arity controls and
explicit corpus result below supplement it without changing either compiler
executable or the original campaign/tools.

## Results

All three rounds completed: 1,056 successful processes including warm-ups, with
all 264 object pairs byte-identical. The combined medians below use 21 measured
processes per tree/source/mode. Times are milliseconds; each cell is reference
then candidate. The checker-input column is the `-fsyntax-only` driver's stage.

| Arguments | Checker input stage | Whole `-fsyntax-only` | Whole `-c` |
| ---: | ---: | ---: | ---: |
| 256 | 0.147 → 0.089 | 0.991 → 0.927 | 1.665 → 1.595 |
| 512 | 0.338 → 0.116 | 1.187 → 0.958 | 1.871 → 1.644 |
| 1,024 | 1.128 → 0.176 | 1.990 → 1.033 | 2.663 → 1.707 |
| 2,048 | 4.046 → 0.296 | 4.931 → 1.190 | 5.615 → 1.937 |
| 4,096 | 15.052 → 0.574 | 16.067 → 1.555 | 17.036 → 2.401 |
| 8,192 | 57.878 → 1.422 | 59.340 → 3.028 | 60.421 → 4.023 |

The 8,192-argument whole object compile improves **93.34%**; its three rounds'
individual reductions are 93.30%, 93.49% and 93.32%. The corresponding object
compile's checker-input stage is 57.684 → 1.331 ms (97.69% less time).

| Other original input | Whole `-fsyntax-only` | Whole `-c` |
| --- | ---: | ---: |
| 8,192 concatenated-string arguments | 58.509 → 3.916 | 59.547 → 4.796 |
| 2,048 grouped expressions | 10.861 → 5.444 | 11.951 → 6.453 |
| 1,024 raw constant-reader arguments | 2.811 → 1.300 | 3.402 → 1.962 |
| 128 ordinary one-argument attributes | 1.215 → 1.207 | 2.024 → 2.028 |
| 128 ordinary mixed declarations | 1.153 → 1.148 | 1.920 → 1.919 |

All ordinary controls' whole-process changes in each individual round are
within 0.9%. The combined ordinary object results are +0.23% and -0.09%, below
this study's ability to resolve small changes over executable placements.
There is no resolved ordinary-attribute regression. Peak RSS medians change
by less than 0.7% in every row; the complete values are in `summary.csv`.
The additional boundary payload for 8,192 arguments is 32,764 bytes, plus one
pointer in each attribute record; copies share the payload.

The work counter independently gives the algorithm's scaling. The scalar and
vector source paths give identical counts in every case. For a repeated-index
list of A arguments, reference boundary visits are exactly `2*A*A + 4*A - 3`;
candidate visits are `4*A - 3` for A > 1. Numeric value publication remains
exactly A in both trees, with the caller evaluating each numeric operand once.

| Arguments | Reference boundary visits | Candidate boundary visits |
| ---: | ---: | ---: |
| 256 | 132,093 | 1,021 |
| 512 | 526,333 | 2,045 |
| 1,024 | 2,101,245 | 4,093 |
| 2,048 | 8,396,797 | 8,189 |
| 4,096 | 33,570,813 | 16,381 |
| 8,192 | 134,250,493 | 32,765 |

At 8,192 arguments, accessor calls fall from 16,384 to 8,192. The raw
constant-reader case falls from 3,150,844 to 4,093 boundary visits and 3,072 to
2,048 accessor calls, retaining exactly 1,024 numeric publications. The string
list falls from 100,700,158 to 49,148 visits and from 8,192 accessor calls to
zero. The grouped case has the same boundary counts as a plain 2,048-argument
list, independent of the skipped groups' sizes. These are logical boundary
dispatch counts, not hardware instruction counts.

### Isolated zero/one/two-argument controls

The review's short-arity supplement uses `short-controls.c`: 128 functions per
source with `nothrow` (zero arguments), `nonnull(1)`, or `alloc_size(1,2)`.
It uses the same fork/exec/stage/RSS and object-comparison protocol as the
original campaign, in one separately locked round with 21 measured repetitions
and one warm-up per tree/source/mode. All 264 processes succeed, including the
12 warm-ups, and all 66 object pairs are byte-identical.

| Arity | Checker-input stage, syntax | Whole `-fsyntax-only` | Whole `-c` | Whole `-c` change |
| ---: | ---: | ---: | ---: | ---: |
| 0 | 0.199 → 0.202 | 1.144 → 1.141 | 1.928 → 1.931 | +0.11% |
| 1 | 0.236 → 0.238 | 1.187 → 1.186 | 1.968 → 1.969 | +0.04% |
| 2 | 0.301 → 0.300 | 1.279 → 1.274 | 2.173 → 2.162 | -0.50% |

All six whole-driver changes are within 0.6%; peak RSS medians change by less
than 0.5%. These differences do not resolve a short-list regression. The raw
values, stage logs and identities are in `short-controls.csv`, `short-cases/`,
`short-summary.csv` and `short-identities.sha256`. The helper uses the same
local generic Clang 23.1.4 build configuration as the original harness.

## Correctness

On the locked 9700X, the candidate's full checker suite passes 274,912 checks
and its executable driver suite passes 21,591 checks, both with zero failures.
The call-graph gate covers 41 translation units and 23,957 functions, reporting
zero unapproved cycles and zero split static variables (three existing allowed
cycles).
All 28 scalar/vector, syntax/object diagnostic comparisons against the normal
reference build pass, with byte-identical stderr and no object left by a rejected
input. The local focused attribute suite passes 13,599 checks. An explicit local
Buster-vs-Clang 23.1.4 GNU C17 corpus run accepts all 14 generated performance
sources, including the normal/raw constant-reader paths and the isolated short
controls: 118,599 tokens, zero acceptance, first-line, diagnostic-path or
scalar/vector differences, and zero resource/preprocessing failures
(`corpus-local.log`).

## Protocol

Both normal compiler executables were built on the Ryzen 7 9700X with Clang
23.1.1, Linux `6.18.50-2-lts`, `BUSTER_DEBUG_INFO=0 LC_NUMERIC=C ./build.sh`.
This uses the repository's `-O3 -march=native -fwrapv -funsigned-char
-fno-strict-aliasing -Wall -Werror` configuration and wild linker. Every build,
test and measurement takes the host's shared `exclusive.sh` lock separately.
Single-thread measurements and their children are pinned to CPU 2, whose
governor is `performance`; its SMT sibling CPU 10 is offline. `metadata.txt`
retains the machine, source and executable identities.

`campaign.c` generates six repeated-index `nonnull` lists (256–8,192 arguments),
an 8,192-argument concatenated-string list, 2,048 grouped expressions including
array brackets, and a 1,024-argument raw constant-reader tag attribute. Each
uses one pointer parameter, avoiding prototype-size effects. The short control
defines 128 functions with one-argument attributes. The mixed control declares
128 functions with ordinary `format`, `nonnull` and `nothrow` attributes.
Clang checks the original generated inputs externally; no external corpus or
compiler implementation is copied.

Each of three rounds runs every source with `-fsyntax-only` and `-c`, alternating
reference/candidate order by round, repetition, source and mode. Repetition 0
warms each combination; repetitions 1–7 are retained. That is 21 measured
processes per tree/source/mode, 924 measured processes and 132 warm-ups. Every
process must exit 0. Every object pair must be byte-identical after each pair
of compilations (264 pairs, including warm-ups).

Wall time is measured around fork/exec/wait4, including startup and release;
the checker input stage comes from the driver's `--time-stages` output. User
and system CPU time and peak RSS come from wait4. Both builds have the same
length executable paths and use the same source paths. Raw per-process values
are in `round-*.csv`; `cases/round-*-stages.log` retains every stage report.
`summary.csv` excludes warm-ups and uses medians, as `summarize.c` implements.

The small POSIX harnesses were compiled locally with Clang 23.1.4 and
`-std=c17 -O2 -Wall -Wextra -Werror` (the generic x86-64 target), then copied to
the 9700X. They time the normal target-built compiler executables. The fixed
harness binaries' hashes are retained; the same binary serves both trees in
all rounds. No timing from an instrumented compiler is used.

## Deterministic work and diagnostic checks

`instrument.c` adds counters to a temporary copy of each tree's attribute
reader. A boundary visit is a top-level token/group dispatch or a separating
comma; a complete grouped expression is skipped in one dispatch in both trees.
Accessor calls and numeric-list value publications are counted separately.
`probe.c` runs the original source driver with module homes made static in one
translation unit, built on the 9700X at `-O1 -march=native`. It supplies work
counts only. `probe.log` records both scalar and vector source paths on every
valid generated source. These counts are not CPU instructions or timings.

`diagnostics.c` generates seven malformed/late-invalid 1,024-argument lists:
zero and out-of-prototype indices, a nonconstant index, grouped zero, trailing
and empty-middle arguments, and a late non-string operand. It compares exact
stderr and exit status between the normal reference/candidate executables,
with both source paths and both driver modes. Every invocation must exit 1
and leave no object. The 28 comparisons and their original inputs/reports are
retained in `diagnostics.log` and `diagnostic-cases/`.

## Reproduction

Prepare `base/` and `head/` from the two source commits and place this directory
at `evidence/` beside them. Build each normal compiler under its own shared lock
with the configuration above. Build the four standalone tools from `campaign.c`,
`instrument.c`, `summarize.c` and `diagnostics.c`; name the first two
`evidence/campaign-fixed` and `evidence/instrument-fixed`. `probe.c` builds with
the corresponding source tree through `run.sh probe-build`.

```sh
evidence/campaign-fixed generate evidence/cases
bash evidence/run.sh checker
bash evidence/run.sh driver
bash evidence/run.sh call-graph
for round in 1 2 3; do
    bash evidence/run.sh measure "$round" > "evidence/round-$round.csv" 2> "evidence/round-$round.stderr"
done
bash evidence/run.sh probe-build base
bash evidence/run.sh probe-build head
bash evidence/run.sh probe > evidence/probe.log 2>&1
EXCLUSIVE_OWNER=codex-605 EXCLUSIVE_TITLE='Buster #605 exact diagnostics' \
EXCLUSIVE_LINK=https://github.com/buster14a/buster/issues/605 \
~/buster-fast-bench/exclusive.sh taskset -c 2 evidence/diagnostics \
    "$PWD/base/build/compiler" "$PWD/head/build/compiler" "$PWD/evidence/diagnostic-cases"
evidence/summarize evidence/round-{1,2,3}.csv > evidence/summary.csv
```

Compile `short-controls.c` with the same standalone-tool flags, generate
`evidence/short-cases`, and run its `measure` command once under `exclusive.sh`
and `taskset -c 2`, passing the same normal base/head compiler paths, the new
case directory and round `1`. This supplement deliberately uses 21 timed
repetitions in one invocation. Summarize `short-controls.csv` with `summarize`.
The corpus command is `head/build/compiler test-checker-corpus --clang
/usr/bin/clang evidence/cases/*.c evidence/short-cases/*.c`, run on the recorded
local machine for the retained report; do not interpret it as target timing.

`focused.c`/`focused-tests.log` retain the local attribute-only regression run.
Prepare its `focused-main.c` from the candidate's `main.c` with the same
`BUSTER_ELSEWHERE` replacement shown in `run.sh`; compile with `-O1 -march=native
-Ihead/src -fwrapv -funsigned-char -fno-strict-aliasing -Wall -Werror
-Wno-unused-function -pthread -lm`. It calls the project's existing attribute
test entry points directly. `driver-local.log` is the normal local driver's
test result. These are correctness checks, with no laptop performance claim.

The record measures one compiler executable placement per tree. Ordinary
control differences near the run-to-run spread cannot establish small timing
changes; this is a long-list scaling study. It does not establish an optimal
remaining delimiter kernel, broad source-corpus performance, or unrelated
language/backend acceptance. The boundary representation and numeric evaluation
order are shared by the scalar/vector source paths; this change adds no new
SIMD kernel.
