# Where a clean sanitizer build's time goes (buster#2739)

Clean builds of [buster](https://github.com/buster14a/buster) at `c471f32f0` (main, 2026-11-14), traced with clang's
`-ftime-trace` and `-ftime-report` on every compile, units and parts' jobs alike, to find what dominates and fix it
without changing a detector, a sanitizer option or `-O3`; then before/after builds of the fix, and the experiment
#2639's "sanitizer parts" lever needed.

## Machine and toolchain

A cloud container: 4 cores (no SMT) of an Intel Xeon at 2.1 GHz, 16 GB, Linux 6.18. CI's pinned toolchain
(`tools/ci/session-toolchain.sh stage`: the official LLVM 23.1.4, CMake 4.4.3, Ninja 1.13.2). The x86-64 MSan build is
a hosted row's product as `tools/ci/hosted-product.sh` builds it: `BUSTER_HOST_ARCH=x86-64 BUSTER_SANITIZER=memory
BUSTER_SANITIZER_OPTIMIZATION=3 BUSTER_DEBUG_INFO=0 ./build.sh --config Release --jobs 4`. Its traced build took
495.6 s here; the hosted EPYC 7763 runners' product step took 492.7 s for the same build (#2703's record).

## How it was traced

`tools/trace-clang.sh` stands first on `PATH` as `clang` (with `REAL_CLANG` naming CI's clang) and adds
`-ftime-trace -ftime-trace-granularity=500 -ftime-report` to every command with `-c` and `-o`: the trace lands beside
the object (`OBJECT.json`), the report in `OBJECT.time-report`. `tools/traces.py TREE` aggregates them: per compile
(front end, optimizer, code generation), per pass (LLVM's `Total` events, wrappers left out), per function
(`OptFunction`), per machine pass (`RunPass`) and per header. `traced-msan/traces.tgz` holds every trace and report;
`traced-msan/summary.txt` is the aggregate.

## What the traces show

The compiles' 1,815 s: front end 72 s, optimizer 511 s, code generation 1,201 s. The costliest passes, summed:

| Pass | Seconds |
| --- | ---: |
| Greedy Register Allocator | 308.8 |
| ModuleInlinerWrapperPass (the CGSCC pipeline) | 212.4 |
| X86 DAG->DAG Instruction Selection | 194.3 |
| **Live DEBUG_VALUE analysis** | **188.5** |
| InstCombinePass | 103.4 |
| GVNPass | 82.1 |
| Register Coalescer | 71.5 |
| CodeGen Prepare | 53.1 |

A sanitizer build's units have line tables alone (`-gline-tables-only`): no variable has a location to track, yet
LLVM's default instruction-referencing LiveDebugValues analyzed every function's machine values, 14.6 s of the
checker's part 0's 86.6 s. Its cost follows the instrumented code's long functions.

The build is bound by its work, not its critical path: Ninja ran 4 jobs from second 1 to second 461, and the steps
left 81 CPU-seconds idle in all (`tools/ninjawork.py`). Restructuring it can win at most those; only less work makes
it shorter on a 4-CPU runner.

## The fix: the older variable-location pass where there are no variables

`-mllvm -experimental-debug-variable-locations=false` selects LLVM's older LiveDebugValues, which has nothing to track
either. On the checker's part 0 alone: 83.4 s -> 69.4 s, and the object is the same, byte for byte. buster's change
applies it to Develop and to a sanitizer build's Release (units and parts' jobs), never to a `-g` compile.

Clean builds before (main) and after (the change), untraced, one after the other (`tools/ab-msan.sh`,
`tools/ab-develop.sh`; `ab/`):

| Build | Before | After | Ninja's step time |
| --- | ---: | ---: | ---: |
| x86-64 MSan Release, 4 jobs | 450.3 s | 399.9 s | 1,737.1 -> 1,581.6 s |
| native Develop, 4 jobs (build.sh's default) | 124.7 s | 125.8 s | 483.5 -> 489.0 s |

`tools/cmp_sections.py` compares the executables section by section: every allocated section is the same in both
pairs; the debug sections' strings differ by the checkouts' directory names (`wt-base`, `wt-trace`), as
`ab/comparison.txt` shows. An uninstrumented Develop build gains nothing measurable: its functions are short.

## The experiment: sanitizer units split before the optimizer (#2639)

`experiment/patch.diff` (on top of the change, not proposed): the MSan tree's Develop configuration in parts, as an
uninstrumented tree's is, with the sanitizer's flags on the parts' jobs and without `--tests-optnone`, so that its
parts run the whole `-O3` pipeline with MSan's instrumentation on code optimized as Release's: what splitting a
sanitizer build's units before the optimizer would build.

| x86-64 MSan, 4 jobs | Wall | Ninja's step time | Idle CPU-seconds |
| --- | ---: | ---: | ---: |
| Release, parts after the optimizer (the change) | 399.9 s | 1,581.6 s | 21 |
| units split before the optimizer | 419.2 s | 1,644.5 s | 37 |

The split adds 4% of work (the parts' imported bodies), and one part, `main_unit_x86`'s part 6, took 277.6 s alone
(the whole unit compiles in 56 s in Release): slower on a hosted runner's 4 CPUs, and on a machine with more cores
that part would be the build's new longest step. Not built.
