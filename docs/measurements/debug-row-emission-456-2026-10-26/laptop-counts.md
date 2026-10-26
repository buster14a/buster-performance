# #456 on the laptop: exact counts and where they go

Ryzen 9 7940HS (Zen 4), clang 23.1.4, `build.sh` with debug information (so that `perf report` has lines),
`-march=native` (znver4). Instruction counts are deterministic and machine-independent to within a few instructions
for the same code; the 9700X's own counts (`counts.log`) agree with these to within the znver4/znver5 code
differences (0.2%).

## Instructions per emission

`perf stat -x, -e instructions:u ./build/compiler benchmark-check-debug --only emit --path P --runs R`, with
`--path scalar` (the emission without the raw rows) and `--path vector` (with them), for `--runs 10` and `--runs 30`:
the difference over 20 is one emission, the setup and the warm-ups cancelling. Pinned to one CPU at niceness 19.

| Tree | Without the rows | With them | `-g` adds |
| --- | ---: | ---: | ---: |
| main `3b025c73` | 131,938,388 | 138,177,647 | +6,239,259 (+4.73%) |
| screen, all on (0) | 131,928,773 | 138,176,259 | +6,247,486 |
| screen, no per-function rows (1) | | 137,637,085 | +5,708,312 |
| screen, nor Tier 0's entry records (3) | | 137,541,915 | +5,613,142 |
| screen, nor the tokens' lowering (7) | | 131,928,926 | +153 |
| screen, nor the rows' room (15) | | 131,928,837 | +64 |
| v1: settle from locals, bookkeeping before the pop, token columns read once per drain | 131,938,452 | 140,116,148 | +8,177,696 |
| v2: v1 with the settle loops not vectorized | 131,938,389 | 140,572,819 | +8,634,430 |
| v3: v2 with them not unrolled | 131,938,389 | 138,931,174 | +6,992,785 |
| vM: main with only the settle loops from locals, not vectorized or unrolled | 131,938,452 | 137,848,336 | +5,909,884 |
| vN: vM with the bookkeeping out of line, before the pop | 131,938,350 | 139,071,537 | +7,133,187 |

The screening build's variant bits (`BUSTER_456_VARIANT`, `variants/screen-switches.py`) apply only to the emission
with the rows, after the benchmark's setup: 1 leaves out `check_program_emit_body_rows`, 2 Tier 0's entry records, 4
the lowering's copy that keeps the tokens (`check_program_lower_sources`), 8 `check_program_emit_reserve_rows`. Its own
switches cost the plain emission 9,600 instructions against main's, which is why its "without" differs from main's.
`variants/*.patch` hold v1 to vN against `3b025c73`'s `c_check_program_lower.c`. Every variant's plain emission is
main's to within 100 instructions (the plain lowering's code is unchanged in each).

## What the token-keeping lowering spends

A counting build (main with counters in `check_lower_settle` and `check_lower_task_source`, not kept) gave, per
emission with the rows: 197,144 task pops, 242,544 settles (the pops and the statements' and calls' token changes),
135,324 entries and 107,516 tasks settled, 45,105 pops whose token didn't change (23%), 114,845 pops of an expression
task and none of a statement's. 5.61 million instructions over 197,144 pops is 28.5 per pop.

At main, the pop's bookkeeping (`check_lower_task_source`, inlined into `check_lower_drain_sources`) reads the task's
fields before its stores (a store through the writer could change the task), compares the task's kind twice, follows
`program->input->graph.tokens` through three loads, clamps `settled`, and runs the two settle loops, which read
`writer->tokens` (or `task_sources`), `writer->source` and their bound again after every store.

IBS op sampling (`perf record -e ibs_op/cnt_ctl=1,swfilt=1/u -c 40000`), 40 timed emissions with each path, separating
each copy's share by solving for the plain and the `-g` copies' samples per emission (the setup and warm-ups run both):

| Build | Plain drain | `-g` drain | `check_program_lower` | `..._sources` | All symbols, with minus without |
| --- | ---: | ---: | ---: | ---: | ---: |
| main | 545.7 | 668.0 | 430.8 | 429.1 | 156.9 |
| v3 | 552.2 | 701.1 | 430.8 | 432.7 | 181.2 |

(samples per emission, one per 40,000 ops.) At v3 the pop's own code is about 8 instructions shorter, and the task's
fields are read lazily as in the plain loop, but the rest of the 17 KB `-g` loop got worse: by line, v3 has 1,910 more
samples at line 0 (spills and moves clang attributes to no line), from a register allocation of the whole function
that the change perturbed. Fixed-period `instructions:u` sampling (`-c 100003`) had put those differences on other
functions (`check_lower_class`, `check_lower_emit`) whose code didn't change: it aliased with loop lengths, as the
repository's notes warn.
