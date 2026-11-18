# The interpreters' steps (buster#2758, second part), 2026-11-18

Measurements for buster branch `claude/wonderful-sagan-gyh5jd` (code commit 4929f98, on main c2b9a74). The issue:
c-testsuite's `00040.c` (8 queens by brute force, 4.57 billion interpreter steps in its four forms) sets the wall time
of "Compare c-testsuite's typed streams, SSA and strict Tier 1 programs", the costliest command of the sanitizer rows.
The first part ([`interpreter-call-path-2758-2026-11-14`](../interpreter-call-path-2758-2026-11-14)) took MSan's
runtime calls out of the steps; this part cuts the instrumented work of a step itself (the PR's description has the
changes).

## Contents

| Path | What |
|---|---|
| `scripts/time-runs.sh` | `test-ssa-source --typed --tier1` of `00040.c` alone and of CI's 220 programs, main and the branch alternating, each run's wall/user/sys (GNU time) |
| `scripts/profile-00040.sh` | `perf record -F 199 -e cpu-clock:u` of `00040.c` alone, with its reports by process (each form is a child), by process and symbol, and by symbol |
| `scripts/verify.sh` | The interpreters' commands of `tools/ci/correctness.tests`, a line each |
| `msan/runs/`, `asan/runs/`, `plain/runs/` | Each timed run's report and `.time`; `summary.txt`, the runs in order |
| `msan/profile-main/`, `msan/profile-branch/` (and `asan/`) | `profile-00040.sh`'s output for each build; `forms.txt`, each form's samples and CPU seconds |
| `msan/tests/`, `asan/tests/`, `tsan/tests/`, `plain/tests/` | `verify.sh`'s logs for the branch's build of each sanitizer; `summary.txt`, a line each |
| `msan/explore/` | The single exploratory runs of intermediate states (below) |

## Setup

A 4-CPU cloud container (Intel Xeon @ 2.10 GHz, Linux 6.18.44), CI's toolchain (clang 23.1.4). Builds:
`BUSTER_HOST_ARCH=vector BUSTER_SANITIZER=memory|address ./build.sh --config Release`, the vector rows' configuration
(MSan with `-fsanitize-memory-track-origins=2`); main from a clean worktree of c2b9a74. Nothing else ran beside a timed
run. Every run gave the same totals: for `00040.c`, steps 1,350,907,667 / 1,086,721,021 / 1,086,721,021 /
1,044,385,698 (memory, vector SSA, scalar SSA, typed) and its expected output in every form and both native builds; for
the 220 programs, 220 passed with the same steps.

## MSan

| Run | main | branch | change (medians) |
|---|---:|---:|---:|
| `00040.c` alone, wall | 117.71 / 109.37 / 113.17 s | 66.76 / 64.05 / 67.74 s | 113.17 → 66.76 s, −41% |
| CI's command on the 220 programs, wall | 140.36 / 134.72 / 139.98 s | 91.18 / 92.41 / 88.28 s | 139.98 → 91.18 s, −35% |

`00040.c`'s forms' CPU (the profile's samples per process at 199 Hz; wall 112.3 s and 64.2 s under perf):

| Form | main | branch | change |
|---|---:|---:|---:|
| memory | 110.9 s | 62.5 s | −44% |
| vector SSA | 81.8 s | 40.9 s | −50% |
| scalar SSA | 84.2 s | 43.1 s | −49% |
| typed | 70.9 s | 55.4 s | −22% |

The memory form still sets the wall time. In the branch's profile MSan's runtime is 0.1% (main's 2.1%); the step loops
(`ir_interpret`, `interpreter_typed_run`) and the memory lookup (`interpreter_memory_access`) are the rest.

## ASan

| Run | main | branch | change (medians) |
|---|---:|---:|---:|
| `00040.c` alone, wall | 122.54 / 114.59 / 113.62 s | 46.94 / 46.20 / 46.85 s | 114.59 → 46.85 s, −59% |
| CI's command on the 220 programs, wall | 136.05 / 123.56 / 127.76 s | 57.99 / 57.28 / 57.04 s | 127.76 → 57.28 s, −55% |

| Form | main | branch | change |
|---|---:|---:|---:|
| memory | 115.5 s | 47.7 s | −59% |
| vector SSA | 88.6 s | 32.2 s | −64% |
| scalar SSA | 87.9 s | 32.3 s | −63% |
| typed | 47.3 s | 35.2 s | −26% |

In main's ASan profile the fake stack and poisoning of each step's address-taken locals (`__asan_stack_malloc_always_2`
4.7%, `_1` 2.7%, `PoisonShadow` 5.0%) and the helpers called at every step (`ir_value_mask` 8.2%,
`ir_ternary_instruction` 4.3%) were 24% of the samples; in the branch's, the first is 0.4% and the helpers are gone from
the step. MSan's runtime: 2.1% of main's samples, 0.1% of the branch's.

## Plain builds

`BUSTER_HOST_ARCH=vector ./build.sh --config Release`, no sanitizer, the same container:

| Run | main | branch | change (medians) |
|---|---:|---:|---:|
| `00040.c` alone, wall | 28.36 / 28.34 / 29.36 s | 21.90 / 21.53 / 23.31 s | 28.36 → 21.90 s, −23% |
| its user CPU | 94.10 / 94.98 / 97.42 s | 60.98 / 60.26 / 63.14 s | 94.98 → 60.98 s, −36% |
| CI's command on the 220 programs, wall | 30.04 / 29.56 / 31.82 s | 22.96 / 22.29 / 22.64 s | 30.04 → 22.64 s, −25% |

No 9700X timings: the host is reserved for #2850 and #2924 while this ran.

## Exploration (single runs, MSan, `00040.c` alone)

Each state built on the one before; `(perf)` runs were under `profile-00040.sh`, whose overhead is a few percent.

| State | wall | what it added |
|---|---:|---|
| main | 113.8 s | |
| 1 | 86.0 s | undefined checks only where asked, the run's symbol cache, the SIMD scan with the verification, no self-copies in the compaction |
| 2 | 71.0 s | status and steps in locals, inlined operation/block entry/static chain, value mask without its branch, the mask table, signed values only for signed predicates |
| 3 | 71.2 s | the typed front's status, steps and top in locals, its kind table and symbol cache |
| 4 | 73.8 s | per-call field-by-field frames and memories, the variadic anchors' record only for a variadic callee, typed DUP/STORE word copies, the FPTOSI case's own temporary |
| 5 | 65.2 s (perf) | both fronts' current frame kept in locals between steps |
| 6 | 69.3 s (perf) | the typed shape check as one switch, the traits table, inlined `interpreter_value_signed`, the lookup table's conditional store: the branch's code (4929f98) |
| 7 | 83.2 s (perf) | each instruction's operand mask computed once a function (AVX-512, 16 at a time) and read per step: the IR forms got 25–35% slower (the time moved into the two `switch (op)` dispatches), reverted; the rebuild was byte-identical to state 6 |
| 9 (8 was state 6 rebuilt) | 66.7 / 61.6 s against state 6's 66.3 / 64.0 s | the memory access inlined at the load/store sites and the instruction count with the frame: within noise, reverted |

## Tests

`scripts/verify.sh` on the branch's MSan, ASan, TSan and plain builds (`*/tests/`), 24 commands each, all passing: `test-interpreter`, `test-interpreter-native`,
`test-interpreter-link`, `test-ir-interpreter`, `test-ir-parse`, `test-ir-reduce`, `test-ir-metamorphic --seed 731
--count 6`, `test-ir-optimize`, `test-ssa-ir`, `test-ssa`, both `interpret-ir --bind` checks, `interpret-c`'s linked
units, `test-ssa-source` (`tests/interpreter/source.c` both ways, the self-test, `--generate 48`, `--generate 24
--seed 141 --lifetimes`, fences, atomics, atomic stores, overflow builtins and the 220 programs with `--typed
--tier1`), and `test-c-testsuite --cross-check` of the subset (220 of 220).
