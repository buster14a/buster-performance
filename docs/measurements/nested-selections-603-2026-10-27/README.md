# Nested selections: Buster #603

Original source/constant-expression chains show that removing root scans alone
does not fix discarded-arm nesting: warning clearing/marking also rescans it.
The change replaces both kinds of repeated subtree work. At depth 2048 the
eight default-driver cases are **4.1–8.4 times faster as whole processes**.
The structural counts below distinguish the removed root scans from warning
updates and the compact interval index's logarithmic traversal.

## Revisions and environment

- Compiler base: `92c025e71856d13eb34247477c5294d2cead139e`.
- Measured/qualified compiler head: `1014c2968ef0f3c02d9be4ba2130c8c78d5a6cc7`.
  Its implementation commit is `a4f0dfd5b82357bd779d78bb44e52483389e62c4`;
  the second commit bounds the Clang-facing regression fixture.
- Publication head `2f659f26d9935837e18f448816b825e80dd2a7a5` only wraps
  initializer formatting and documents the results. The reformatted C files'
  non-whitespace bytes match the qualified versions (`logs/format-identity.txt`).
- AMD Ryzen 7 9700X, Linux `6.18.50-2-lts`, Clang 23.1.1, native `-O3`
  `./build.sh` with `BUSTER_DEBUG_INFO=0`. Each build, test and measurement
  took the shared `exclusive.sh` lock separately. Measurements were pinned to
  CPU 2. CPU 10 was offline; the other 15 logical CPUs were online.
- `logs/host.txt` and `logs/binaries.txt` retain the environment and exact
  uninstrumented/instrumented binary hashes. Source is original project code;
  no external implementation or corpus is incorporated.

## Inputs and measurement

`generate.c` writes 40 original C files: depths 128, 256, 512, 1024 and 2048,
four forms (choose/generic, selected/discarded nesting), and two contexts
(runtime return and enum initializer). Each deepest input has a `main` that
checks its expected result; enum inputs also have a static assertion.
`inputs/` retains those files and the actual command lists.

The four `*-vector/scalar` campaigns use ordinary compiler processes with
`-fsyntax-only --time-stages`, three rotated rounds, one discarded warm-up and
three recorded processes per case per round. Tables are medians of nine
recorded processes; all 1,920 processes including warm-ups returned zero.
These use the uninstrumented binaries. Process counters include startup and
cleanup; `check_input_ms` comes from the existing driver stage clock.
Empty captures are represented losslessly by their paths in
`empty-captures.txt`; all nonempty captures are retained under `samples/`.
The disassembly capture trims trailing whitespace while retaining instruction
bytes and addresses.

## Entry after lighter scalar work

`logs/process-conditioned-r2.txt` is an additional whole-process comparison
using the existing `time-runs` scalar integer spin for 100 ms immediately
before each recorded compile. Seven rotated runs, one discarded warm-up and
one executable copy per build compare base/head/base-again on all eight deep
inputs and frozen SQLite. All 189 recorded processes and the 27 warm-ups
succeed. Exact commands are in `logs/process-conditioned-command-r2.txt`.

| Input, D=2048 | Base A ms | Head ms | Base B ms |
|---|---:|---:|---:|
| Runtime choose, selected | 9.381 | 2.596 | 8.665 |
| Runtime choose, discarded | 13.051 | 2.260 | 12.980 |
| Runtime generic, selected | 13.491 | 3.539 | 13.719 |
| Runtime generic, discarded | 30.804 | 3.705 | 30.481 |
| Constant choose, selected | 14.893 | 2.372 | 14.674 |
| Constant choose, discarded | 13.318 | 2.301 | 12.992 |
| Constant generic, selected | 22.855 | 3.691 | 23.052 |
| Constant generic, discarded | 21.219 | 3.926 | 20.783 |
| Frozen SQLite syntax | 116.197 | 115.925 | 116.297 |

The deep cases retain about 3.5–8.3 times whole-process improvement against
the mean base controls. SQLite is -0.28% in this additional run. The first
small case's base controls differ by 7.6%, so retain the controls and ranges
when interpreting small changes. This run omits `--time-stages` and collects
user-only PMUs; it is an additional A/B comparison, not a direct subtraction
of clock states from the earlier collector's results.

The first invocation of this additional check exited during setup because
the parent directory for executable copies had not been created. Its two-line
failure is retained in `logs/process-conditioned-setup-failed.txt`; no failed
setup data contributes to the measurements. The corrected command ran only
after creating the parent directory.

The two `*-check-input` campaigns separately use the existing
`benchmark-checker-bindings --only direct --passes 7`: three independent
processes per case, each with its own warm-up and seven timed reader calls.
Their summaries report the median of the three process medians, including
reader initialization, existing traversal metadata construction and cleanup.
The process duration/RSS in these summaries belongs to the benchmark harness;
only its `check_input_ms` and `check_input_cycles` describe the timed reader.

`instrument.c` applies explicit counters to separate copies of base/head.
Those binaries are used only by `*-work`, never for timing claims. Root
queries, token visits inside root scans, token visits inside warning updates,
and popped interval-index nodes are counted separately. Their process times
and PMU readings are not performance evidence.

## Default driver, depth 2048

| Context and form | Process ms, base → head | Driver check-input ms, base → head |
|---|---:|---:|
| Runtime choose, selected | 8.423 → 2.043 | 6.933 → 0.629 |
| Runtime choose, discarded | 13.004 → 2.220 | 11.578 → 0.800 |
| Runtime generic, selected | 13.893 → 3.410 | 11.557 → 1.206 |
| Runtime generic, discarded | 30.566 → 3.638 | 28.389 → 1.457 |
| Constant choose, selected | 14.815 → 2.163 | 13.324 → 0.733 |
| Constant choose, discarded | 12.963 → 2.264 | 11.471 → 0.852 |
| Constant generic, selected | 23.329 → 3.658 | 20.831 → 1.357 |
| Constant generic, discarded | 20.738 → 3.907 | 18.479 → 1.602 |

All five depths and the scalar schedule are in `summaries/`. The separate
reader benchmark, for example, measures runtime discarded generics at
27.891 → 1.100 ms and 154,617,357 → 6,105,298 core cycles. Constant selected
generics take 21.060 → 0.791 ms and 116,776,658 → 4,379,385 core cycles.

The `*-after-scalar` campaigns repeat depth 2048 in three processes with seven
timed calls each and the existing reader benchmark's 200 ms conditioning.
Runtime discarded generics measure 28.191 → 1.079 ms after that conditioning;
constant selected generics measure 20.146 → 0.778 ms. All 48 processes pass.
This reader benchmark conditions with scalar **binding-stack replay** while
its other reader kernels retain their usual mode; it is not a forced-scalar
run of the entire reader. The ordinary whole-process results include their
actual preprocessing/parsing predecessors.

## Structural scaling

Runtime discarded `_Generic` is the witness that exercises both root discovery
and repeated warning suppression. Head performs zero whole-range root-scan
token visits. Its root-query count is exactly 4D; these are bounded metadata
lookups, not scans. Warning visits approximately double with D; index-node
work has the documented logarithmic factor.

| D | Tokens | Base root visits | Base warning visits | Head root queries | Head warning visits | Head index nodes |
|---:|---:|---:|---:|---:|---:|---:|
| 128 | 1,432 | 89,920 | 179,328 | 512 | 9,472 | 3,524 |
| 256 | 2,840 | 360,064 | 719,104 | 1,024 | 19,136 | 8,714 |
| 512 | 5,656 | 1,441,024 | 2,880,000 | 2,048 | 38,464 | 20,666 |
| 1024 | 11,288 | 5,765,632 | 11,527,168 | 4,096 | 77,120 | 47,682 |
| 2048 | 22,552 | 23,065,600 | 46,123,008 | 8,192 | 154,432 | 107,908 |

Selected runtime choose nesting separately drops 14,679,040 root visits to
6,144 bounded root queries and zero root-scan visits at D=2048. All eight
forms' complete counts are retained in `samples/*-work/*.err`.

## Representative whole compiler

Frozen SQLite input SHA-256:
`0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`.
The exact frozen headers and feature options are in `inputs/representative.list`.
Five rotated rounds give 25 recorded processes plus five warm-ups per row.
Two labels of the same base binary provide an A/A control.

| Command | Base A ms | Head ms | Base B ms | Head vs mean base |
|---|---:|---:|---:|---:|
| `-fsyntax-only` | 116.269 | 116.533 | 116.429 | +0.16% |
| `-c` | 146.762 | 147.293 | 146.768 | +0.36% |

All 180 processes returned zero. Instructions increase about 0.044% for syntax
and 0.032% for object compilation. Median peak RSS is 483,592 KB for head's
syntax check (base 483,456/483,492 KB), and 513,052 KB for head's `-c` (base
512,948/512,952 KB). These are small measured costs on this representative file;
the improvement claim is for nested selections. The three emitted SQLite
objects are byte-identical, SHA-256
`0c48ff92978c3125b1822a1552eb48d2742ea09d80176488d8dc5320c4afe91f`.

## Correctness and limits

- Locked 9700X `test-checker --seed 603`: 265,667 checks, zero failures.
- Locked `test-checker-deferred`: 70 fixtures, 1,113 checks, 684 merged units,
  6,492 bodies read apart, zero failures.
- Locked driver suite: 21,591 checks, zero failures.
- `qualify.c`: 80 syntax checks (all 40 inputs, both schedules), 16 deepest
  compilations and 16 native executions; all 112 subprocesses pass.
- The full call-graph check covers 41 units and 23,961 functions: no forbidden
  cycles and no split static variables.
- The independent guarded warning-update oracle passes with local ASan/UBSan.
  It compares ordered mutations at every length through 257, including later
  warning writes and independent bounds. This is focused sanitizer evidence,
  not a whole-compiler sanitizer/corpus claim.

Clang 23.1.4 on the local Zen 4 machine stalls on the selected depth-1024
choose-expression enum (stopped after about three minutes). This oracle run
is excluded. Bounded Clang syntax checks accept all four runtime forms and
both constant generic forms at depth 2048, with `-fbracket-depth=4096` and a
128 MiB stack. Deep constant choose values are independently stated, checked
by Buster's static assertions and executed through both schedules; a deep
Clang enum result is not claimed. The persistent Clang-facing choose fixtures
use runtime syntax to keep the ordinary suite bounded.

## Reproduction and provenance

Build the pinned revisions with the repository's `build.sh` under the 9700X
lock, retaining the usual `-march=native`, `-fwrapv`, `-funsigned-char` and
`-fno-strict-aliasing` semantics. `logs/*build.log` retains those builds.
Compile the original tools with `clang -std=c17 -O2 -Wall -Wextra -Werror`.

```
./generate INPUT_DIRECTORY BASE_COMPILER HEAD_COMPILER
./procbench --rounds 3 --out samples/runtime-vector INPUT_DIRECTORY/runtime-vector.list > runtime-vector.tsv
./procbench --rounds 1 --out samples/runtime-check-input INPUT_DIRECTORY/runtime-check-input.list > runtime-check-input.tsv
./summarize runtime-vector.tsv samples/runtime-vector
./summarize runtime-check-input.tsv samples/runtime-check-input --reader
./qualify CAMPAIGN_ROOT
./instrument base SEPARATE_BASE_SOURCE_COPY
./instrument head SEPARATE_HEAD_SOURCE_COPY
clang -std=c17 -O2 -march=native -fwrapv -funsigned-char -fno-strict-aliasing -fsanitize=address,undefined -I BUSTER_SOURCE/src warning_probe.c -o warning-probe
./warning-probe
```

Each benchmark/test command takes its own `exclusive.sh` lock; pin measurements
to CPU 2. Build the instrumented copies separately. The retained command lists
are the actual run arguments; adjust their absolute compiler/input paths when
reproducing elsewhere. The collector's first invocation may compile its own
plain C tool under the same lock before starting the discarded warm-up.

`generate.c`, `instrument.c`, `summarize.c`, `qualify.c` and `warning_probe.c` are original work
under Apache-2.0 WITH LLVM-exception. `procbench.c` is reused unchanged from
`docs/measurements/checker-source-slow-state-445-2026-10-26/procbench.c` at
buster-performance `32fdc4db4da6807cca13904a9022f1fc0147e992`, retaining its
notice and terms. Clang and frozen SQLite/headers are external tools/inputs;
their implementation and corpus are not vendored here. The generated inputs
contain only original constants, selections and result assertions.
