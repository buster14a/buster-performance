Closes #681.

`build.sh` waits for its longest unit, `main_unit_checker.c`. This compiles that unit's own tests unoptimized (`#pragma clang optimize off` around its 12 test includes), which takes about a quarter off the unit and makes the build bound by total CPU rather than by that unit.

## Why not a split or a home

From the units' LLVM IR (the build's flags before any pass), weighting functions by IR size:

- `test-checker` alone reaches 851k of the unit's 925k IR lines (92%), and `check`'s pipeline is 581k.
- Its sections, taken together, reach the whole pipeline: most of them run programs natively. Moving them to another unit would duplicate 607k lines in both halves (746k and 786k).
- The backend modules (Tier 0, the encoder, x86 semantics, branch sizing, unwind, x86 target and match) are a tenth of the unit (93.6k lines, behind 30 functions other code calls). Tier 0 runs on the encoder's and x86 semantics' tables, which the emission initializes in its own unit, so a Tier 0 home would split state the call-graph check refuses, short of homing the whole backend pipeline with its tests.

## The change

The unit's 12 test includes, `c_checker_test.c` (which includes about 45 section files) and its commands' other `*_test.c`, sit between `#pragma clang optimize off` and `on`. `c_check_corpus.c` and the benchmarks stay optimized. AGENTS.md says where a new checker test goes, and which tests don't belong there (one whose own code is its time).

## Measurements

The checker unit compiled alone, on a Ryzen 9 7940HS, alternating:

| | Round 1 | Round 2 |
| --- | --- | --- |
| main | 34.4 s | 31.4 s |
| this branch | 25.8 s | 24.3 s |

`build.sh`'s schedule simulated with every source's time: on 8 slots 34.8 → 28.2 s, on 4 slots 58.2 → 56.1 s.

On the 9700X (`~/buster-fast-bench/ci-681-claude/measure-681.sh`: main at 716c980d and this branch at 4ce693ad, each built as the 9700X job builds, `BUSTER_DEBUG_INFO=0 taskset -c 0-7 ./build.sh`, twice in alternation, each run under the host lock alone):

| | Round 1 | Round 2 | `main_unit_checker.c` | `main_unit_backend.c` |
| --- | --- | --- | --- | --- |
| main | 33.8 s | 33.6 s | 33.8, 33.6 s | 25.9, 26.1 s |
| this branch | 28.5 s | 28.5 s | 27.4, 27.3 s | 26.0, 26.0 s |

That's 5.2 s (15%) off every 9700X build, an agent's or a job's. The checker unit is now about a second longer than the backend unit, so total CPU sets the build.

The default compile is unchanged: `-c` of the frozen `sqlite3.c` with #518's options, 21 runs of each build in rotation (`time-runs`, CPU 2, one hold):

| | Wall, median (range) | User cycles | User instructions |
| --- | --- | --- | --- |
| main | 131.022 ms (130.266 to 132.292) | 619.564 M | 1,379,783,999 |
| this branch | 131.155 ms (130.269 to 133.009) | 619.831 M | 1,379,832,703 |

That's +0.10% wall and +0.04% cycles. The +48.7k instructions (+0.0035%) are steady within each build (±20 per run), and nothing `check` reaches is in the wrapped files. `.text` is 358 KB smaller, which moves the code after the checker unit's tests, so they are most likely where code lands, the effect `docs/profiling.md` puts at up to about 1.5%. The unoptimized tests also import libm's `cos`, `pow`, `sin` and `sqrt`, which clang had folded.

## The tests

Run by both builds on the laptop, alternating:

| Test | CPU, main | CPU, branch |
| --- | --- | --- |
| `test-checker --seed 133` | 50.8 s | 50.4 s |
| `test-checker-asm` | 8.9 | 8.9 |
| `test-checker-driver --executable` (both) | 7.0 | 7.1, 7.0 |
| `test-check-debug --cross-check` | 2.5 | 2.5 |
| `test-check-lanes` | 6.3 | 6.3 |
| `test-checker-deferred` | 5.0 | 4.9 |
| `test-checker-corpus --deferred 8` (c-testsuite) | 3.9 | 3.7 |
| `test-c-testsuite --cross-check` | 10.7 | 10.2 |
| `test-check-builtins`, `test-builtin-lower`, `test-tier0` | 0.2, 0.3, 2.6 | 0.2, 0.3, 2.6 |

The outputs are the same: `test-checker` 392,187 checks with the laptop's 4 known clang 23.1.4 differences on both, and `test-check-lanes`' count varies between runs of one binary, 2,683 to 2,697. Their time is the compiler's code they call and clang's processes.

No benchmark's timed code calls the wrapped files: from the IR, three benchmarks reach them. `benchmark-check-debug` reaches the generator and pipeline it runs before its samples. `benchmark-checker-source` and `benchmark-checker-bindings` reach `check_test_value_equal` and `check_test_stream_equal`, in their untimed verification ("Timed samples perform no comparison"). The builtins unit's 14 test commands share six of the helpers and pass as on main; four of them differ from main's expectations on the laptop's clang the same way on both builds.

## Checks

- `./build.sh check-call-graph`: 0 cycles beyond the 3 allowed, 0 split variables; `test-call-graph` passes.
- `./build/compiler parse -fsyntax-only ... main.c` passes, and `test-preprocessor --clang`, `test-files`, `test-parser` and `test-parser-bindings --clang` on the repository's units pass with the new pragma lines.

Earlier, wrapping every unit's tests the same way (112 includes) cut `main.c`'s units from 155 to 125 s of CPU. But it slowed tests whose own code is their time (`test-ir-lowering` 1.9×, `test-x86-encoder` 1.48×, `test-lexer` 1.35×). It also broke `test-parser`'s driver checks, which measure a run's peak address space. So this PR wraps only the unit the build waits for.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
