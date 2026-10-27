# _Generic association indexing: #602

Companion evidence for [Buster PR #630](https://github.com/buster14a/buster/pull/630)
and [issue #602](https://github.com/buster14a/buster/issues/602).

## Sources and scope

- Baseline: `92c025e71856d13eb34247477c5294d2cead139e`.
- Candidate: `3683a159e19b0f260b5af36a0fd739695233f121`.
- Release builds: `BUSTER_DEBUG_INFO=0 ./build.sh`, on the AMD Ryzen 7 9700X.
  The build's own flags include `-O3 -march=native -fwrapv -funsigned-char
  -fno-strict-aliasing -Wall -Werror`; these are uninstrumented executables.
- Measurement: one compiler lane, parent and child pinned to CPU 2. Every
  target build, test and experiment takes the existing shared host lock.

The candidate groups associations by a necessary nominal-record compatibility
key, including pointer/array/atomic wrappers. Every candidate still receives
the established source-position-aware compatibility check. A distinct-tag
family makes no duplicate queries and one control query when its key occurs
once. This is a bounded fix: a large candidate group, including different
pointer depths around the same tag or the general ambiguous bucket, can still
require quadratic exact compatibility work.

## Inputs and measurement

`generate.c` makes four families: pointers to distinct forward-declared structs
and distinct complete structs, each in a function return and in an enum
initializer. Every selection chooses the first association's zero value; the
unselected fallback is seven. Both functions in each generated program are
ordinary C and its executable must exit zero. The record control's dereference
is in the unevaluated `_Generic` controlling expression.

Sizes are 256, 512, 1,024, 2,048, 4,096, 8,192 and 10,000 associations. Inputs
are identical between variants and their SHA-256 digests are retained. Clang
syntax-checks every input. The native check also compiles all four 10,000-item
cases with Clang and with both Buster paths, requires byte-identical baseline,
candidate and scalar object files, and executes the resulting programs.

`measure.c` runs one fresh compiler process at a time. Round zero discards a
warm-up for every executable/input combination; six recorded rounds rotate
baseline/candidate/scalar order and family order, and reverse size order on
alternate rounds. The scalar variant uses the candidate with `--scalar`, which
selects scalar paths throughout the compiler. It is a whole-compiler comparison,
not an isolated mask-kernel timing. Six rounds give each variant two turns at
each starting position.

Wall time covers releasing the child through its pre-exec gate through reaping
it, including startup, input preparation, checking, lowering and object writing.
The shared pipe/parent overhead is included. Peak RSS comes from `wait4`.
User instructions use a child-specific hardware event enabled on exec; any
unavailable, zero or multiplexed event fails the experiment. Raw rows retain
enabled/running counter times and every exit status. Reported times and counts
are medians. These are fresh-process whole-compilation measurements after the
compiler's preceding phases; they do not establish an isolated kernel's power
transition behavior.

The frozen SQLite input is a control workload, using the same single-lane
`-c` invocation without extra defines. Its exact path and digest are recorded.
There is no binary-placement sweep, so a small SQLite timing difference should
not be treated as an established general compiler speedup or regression.

## Exact query counts

`counts.sh` copies each pinned source's `src` tree into a count-only directory.
`instrument.c` adds counters immediately around the baseline's existing
duplicate/control queries, and prints the candidate's existing per-selection
counters. It leaves compatibility operands and source-position arguments intact.

The count-only adapter preprocesses/parses each generated source, executes the
real `check_input` readers, and validates the emitted graph. It compiles the
source prefix at `-O1`, with module entry points made local to its standalone
translation unit. Its arenas have enough capacity for these bounded inputs.
These executables are used only for query counts, never for timing. The release
executables used for wall time and hardware instructions are unchanged builds.

Every 10,000-association selection in both readers reported:

| Exact queries | Baseline | Candidate |
|---|---:|---:|
| Duplicate association checks | 49,995,000 | 0 |
| Control-type checks | 10,000 | 1 |

The raw count log identifies every family/size and which reader actually ran.
The permanent focused tests additionally cover qualifiers, aligned typedefs,
enum/integer compatibility, arrays, function prototypes, source-time transparent
unions, candidate order through collisions and wraparound, guarded loads and
allocation failure. The scalar mask loop explicitly disables automatic
vectorization/unrolling; inspection had shown Clang otherwise folding the
scalar and intrinsic branches into the same vector instructions.

## Results and validation

Six fresh-process samples per variant/input, plus discarded warm-ups, produced
these medians at 10,000 associations:

| Family | Baseline ms | Indexed ms | Whole-compiler scalar ms | Speedup | User instructions reduction |
|---|---:|---:|---:|---:|---:|
| Pointer, ordinary | 738.960 | 12.474 | 60.121 | 59.24x | 99.40% |
| Pointer, constant | 785.990 | 58.097 | 60.062 | 13.53x | 98.01% |
| Record, ordinary | 280.686 | 15.281 | 64.029 | 18.37x | 97.91% |
| Record, constant | 328.707 | 60.829 | 64.186 | 5.40x | 94.28% |

[The full scaling table](summary.md) includes every size, peak RSS, absolute
instruction counts and observed wall-time ranges. All 522 recorded samples
exited zero with non-multiplexed instruction counters. The separate query log
confirms the zero-duplicate/one-control bound at every measured size.

The complete constant-expression compilation still grows faster than linearly:
for example, indexed pointer constants take 14.073 / 41.138 / 58.097 ms at
4,096 / 8,192 / 10,000 associations despite zero duplicate queries. This result
removes the quadratic *compatibility-query* work identified by #602; it does
not establish linear complexity for every other part of declaration-time
constant handling. No cause for that remaining growth is inferred from this
experiment.

SQLite's median was 144.368 -> 143.915 ms, with overlapping observed ranges
(143.974–145.332 vs 143.106–144.682 ms). User instructions were
1,529,804,348 -> 1,529,802,292, effectively unchanged. Treat this as a control,
not a demonstrated corpus-wide speedup. Median peak RSS was 506,920 -> 505,840
KiB; the synthetic families also have their RSS in the full table.

The unchanged target baseline's full checker suite passed 265,523 checks, and
the candidate passed 270,663. The candidate's driver suite passed 21,591 checks;
the type suite passed, including 6,197 Clang-oracle checks. The call-graph check
reported zero unapproved cycles and zero split variables. All four largest
native fixtures passed the object-identity and execution checks above. The
focused source/index suite also passed 12,652 checks locally.

The local Clang 23.1.4 run had four FP-classification oracle differences; none
reproduced in either target build with its installed Clang. Required GitHub CI
is reported separately in PR #630 rather than inferred from manual tests.

## Reproduction and provenance

The shell files are small build/experiment glue around the retained C tools.
`prepare.sh` builds the tools, regenerates inputs, invokes the Clang oracle and
records host/binary identity. `native.sh`, `counts.sh` and the measurement
command run under separate shared-lock acquisitions. The qualification runner
may queue independent checks together; the shared lock serializes all actual
target execution.

To reproduce on the approved host, archive the two source commits into
`$HOME/buster-fast-bench/codex-602-20261027/base` and `head`, and put this
directory's C/shell tools in `evidence/` beside them. Build each source with a
separate invocation of the shared lock and `BUSTER_DEBUG_INFO=0 ./build.sh`.
Then run `bash evidence/native.sh` and `bash evidence/counts.sh`, each through
the same lock, and run the following measurement through a third acquisition:

```sh
taskset -c 2 ./measure "$PWD/base/build/compiler" "$PWD/head/build/compiler" \
    "$PWD/inputs" 6 \
    /var/lib/buster-9700x/corpora/preprocessor-391e729af658/sqlite/sqlite3.c
```

From this evidence directory, `clang -std=c17 -O2 summarize.c -o summarize`
and `./summarize 9700x/measure.log` regenerate `summary.md`. The build logs and
host record contain the actual toolchain, source pin, governor/EPP, input
digests and release-executable digests. The retained `build-head-next.sh`
records the staging-directory rename used in this run; it is not needed when
reproducing into `head` directly.

All harnesses and generator inputs here are original work. Clang is an external
oracle, and compiler sources are read from the pinned Buster checkouts at run
time, retaining their existing terms. The frozen SQLite amalgamation is an
external runtime input and is not copied into this evidence directory. Original
material follows this repository's Apache-2.0 WITH LLVM-exception terms; this
does not relicense any included source component or external runtime input.
