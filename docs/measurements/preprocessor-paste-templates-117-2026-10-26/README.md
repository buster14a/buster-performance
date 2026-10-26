# Templates for `##` and `#` (#117), 2026-10-26

The 9700X's measurements behind Buster's PR [#473](https://github.com/buster14a/buster/pull/473), the second step of
#117's leaner expansion engine, after [#444's templates for simple macros](../preprocessor-templates-117-2026-10-25/README.md).
In a vectorized run that records no history (as `-E`, `parse` and the checker's driver run a unit), a function-like
macro of at most 16 items of tokens, parameters, `##` and `#` gets a template. Its invocations, collected
(`pp_finish_simple`) or in a file's text without `#` (`pp_invoke_file`), are planned (`pp_plan_operators`), their
pastes and strings made in item order (`pp_template_make`), and the expansion written in registers
(`pp_template_write`), without the invocation stack and `pp_substitute`. Cited by Buster's `docs/c-preprocessor.md`
("The main loop against #117's budget").

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `main-dd982df` | `dd982dfb160648b52aae4959c07362f5662ecbed` (main under the PR's final head, with #481) | 627 | `f581204b407779212f2239e0ced6267af83e425b5705832a79f26deb4aad9ca1` |
| `cand-5d2c540` | `5d2c5407` (the PR's final head: main and #482 merged, and the review's fix) | 627 | `efba2338c76495295da2bf041c08180973856f1418b13feec315362a67b513bc` |
| `main-3b025c7` | `3b025c73` (main under the PR's first head) | | `d0d5da1fcf43069c1e3366098965b2e84871e0940a60c460b2802e110890ed89` |
| `cand-6a91b3b` | `6a91b3bf` (the PR's first head) | | `f4ee79b2e387252439c7e0a681064f9642cca94520c6cba4a7908b751ea35f52` |

Each `source-*.sha256` lists the SHA-256 of every file of `git archive` of the commit. The trees were sent to the host
by `git archive`; the final pair's files, apart from `build/`, match their manifests. Buster's `./build.sh` built each
tree there under the lock (`logs/build22-*.txt`). The `build/compiler` SHA-256s:

- `main-dd982df`: `caf1ded9ca0576608d73da68eec72a9c7d327e4133656ac0090f8a0da8e47484`;
- `cand-5d2c540`: `f63e945ae382e294e8e107e3f085d503a2b76433e55dfdaad4a3b3d1d2c847c4`;
- `main-3b025c7`: `d4d7a2ec0b2d3deda26a32429d9927397db7f9d666dc2b71e9ab63828a7b4d42`;
- `cand-6a91b3b`: `ae549ab589a114e7c9666b2ed2aebed5c35f37a3cb80f40de3c27c6f4d18a48f`;
- `cand-pad32` (below): `b9884cefa331f7b2b44c891763c71cd2544ccea961cfad345ec43f13c51ec106`.

The inputs are the 2026-10-23 acceptance's, as #444's record has them (`scripts/args.sh`): the frozen `sqlite3.c`
3.53.2 with the bundle `preprocessor-corpora-astra-01a158dd`'s pinned headers, and `main.c` of the frozen tree
`635434f2` with the system's headers. `SOURCE_DATE_EPOCH=1792454400`; `CPATH`, `C_INCLUDE_PATH` and
`CPLUS_INCLUDE_PATH` are unset.

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, CPU 2 with the `performance` governor and energy
preference. Every run took the shared lock on its own, through `~/buster-fast-bench/exclusive.sh` with
`EXCLUSIVE_OWNER=claude-117-templates` (`scripts/locked.sh`), pinned to CPU 2. The lock's waiting messages, which name
other sessions' runs, are removed from the logs; nothing else in them is changed.

## Method

`scripts/queue22.sh main-dd982df cand-5d2c540` ran, in order:

- `benchmark-preprocessor --history-cost --only scalar` on the two trees by turns, four rounds on `sqlite3.c` and three
  on `main.c`: the vectorized kernels with the history deferred, as compiles run a unit, which takes the templates;
- `benchmark-preprocessor --only vectorized`, three rounds on `sqlite3.c`: the history recorded, which takes the old
  paths;
- `time-runs` under `ab` (Buster's `docs/profiling.md`, "Whole drivers"): three rounds, the trees' order rotating, each
  round 22 processes per tree of `-E`, `parse -fsyntax-only` and `-fsyntax-only` of `sqlite3.c` after a warm-up, timed
  from `fork` to `wait4`. The script was made from `queue21.sh` by renaming 21 to 22, which also changed `--runs 21`
  to `--runs 22`: these medians are of 22 processes;
- `perf stat -r 21` of `-fsyntax-only` (user and kernel cycles, user instructions, page faults), two rounds by turns.

Each benchmark run reports medians of 21 passes after a warm-up; a range below is the rounds' medians.

## The final head

`sqlite3.c`, history deferred (`logs/ab22-deferred-sqlite-*.txt`):

| `sqlite3.c` | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | ---: | ---: | ---: | ---: |
| `main-dd982df` | 9.227-9.257 ms | 0.335-0.336 ms | 4.432-4.439 ms | 106.56 |
| `cand-5d2c540` | 9.203-9.327 ms | 0.334-0.344 ms | 4.427-4.538 ms | 105.21 |

The first round of the PR's head is the slowest (main loop 4.538 ms); the other three take 4.427-4.455 ms. Directive
tables plus main loop: 4.767-4.775 ms on main and 4.761-4.882 ms with the PR. The PR's 1.35 fewer instructions per input
token don't show as time on `sqlite3.c`.

`main.c` (frozen at `635434f2`), history deferred (`logs/ab22-deferred-main-*.txt`):

| `main.c` | Whole run | Directive tables | Main loop/setup | Instructions/input token |
| --- | ---: | ---: | ---: | ---: |
| `main-dd982df` | 29.864-29.907 ms | 0.305-0.310 ms | 20.983-21.018 ms | 283.95 |
| `cand-5d2c540` | 29.377-29.682 ms | 0.305-0.310 ms | **20.583-20.829 ms** | 278.15 |

`sqlite3.c`, history recorded (`logs/ab22-recorded-sqlite-*.txt`), the old paths:

| `sqlite3.c` | Whole run | Main loop/setup | Instructions/input token |
| --- | ---: | ---: | ---: |
| `main-dd982df` | 10.170-10.249 ms | 5.350-5.411 ms | 118.33 |
| `cand-5d2c540` | 10.237-10.254 ms | 5.421-5.428 ms | 118.39 |

The recorded run's main loop is up to 0.07 ms slower, with 0.05% more instructions: it runs the same paths, whose
code the templates' callers moved.

### Whole drivers

`logs/drivers22-sqlite.txt`, a range of the rounds' medians:

| `sqlite3.c` | Tree | Wall time | Peak resident set | Minor faults |
| --- | --- | ---: | ---: | ---: |
| `-E -o /dev/null` | `main-dd982df` | 19.313-19.421 ms | 59,016-59,024 KB | 807 |
| | `cand-5d2c540` | 19.266-19.418 ms | 59,256-59,308 KB | 812 |
| `parse -fsyntax-only` | `main-dd982df` | 18.049-18.269 ms | 141,428-141,452 KB | 922-923 |
| | `cand-5d2c540` | 18.058-18.181 ms | 141,684-141,696 KB | 927-928 |
| `-fsyntax-only` | `main-dd982df` | 147.436-147.585 ms | 597,272-597,284 KB | 1,443 |
| | `cand-5d2c540` | **147.680-148.096 ms** | 597,408 KB | 1,447 |

`-E` and `parse` don't change measurably. The PR takes 240-290 KB more of peak resident set, with 4 or 5 more minor
faults: more macros have templates, in `pp_array_small`'s base pages, and `PPTemplate` grew from 260 to 272 bytes.

The checker's driver is 0.2-0.5 ms slower. `perf stat` (`logs/stat22-fsyntax-*.txt`): user instructions
1,713,213,290 on main and 1,711,489,170 with the PR (1.72 million fewer, the preprocessor's), user cycles
679.7-680.4 million against 682.4-682.9 million (+0.4%), kernel cycles 136.2-136.6 million against 136.5-136.8 million,
and page faults 1,268 against 1,272. The checker runs the same instructions in more cycles. The first head's control
(below) found the same kind of difference, and moved about 60% of it back by shifting the checker's code 32 bytes.

## The first head, and the checker's placement

`scripts/queue21.sh main-3b025c7 cand-6a91b3b` measured the PR's first head the same way (`logs/first-head/`), with
`--runs 21`. Its numbers agree with the final head's: `sqlite3.c`'s deferred main loop 4.456-4.496 ms on main and
4.426-4.484 ms, `main.c`'s 21.058-21.313 ms and 20.708-20.862 ms; `-E` and `parse` unchanged; and `-fsyntax-only`
146.993-147.290 ms on main and 148.289-148.552 ms with the PR, 1.0-1.5 ms slower.

A profile of each (`logs/first-head/prof21-*.txt`, `perf record -e cycles:u -c 200003` over 8 runs) put the difference
in checker functions the PR doesn't change: `check_input_expressions` 15.19% against 15.68% and
`check_input_resolve_range` 8.20% against 8.65%. Their code is the same in both binaries (`objdump` without addresses),
but they start at other offsets in their 64-byte lines: `check_input_expressions` and `check_input_resolve_range` at
32 on main and 0 with the PR, `check_input_run` at 16 and 48.

The control, `cand-pad32`, is `cand-6a91b3b` with `__asm__(".text\n.skip 32, 0xcc\n");` at the top of
`main_unit_checker.c`, which moves the checker's unit 32 bytes and puts those three functions back at main's offsets.
`-fsyntax-only` by turns (`logs/first-head/drivers21-pad32.txt`, 21 processes per round):

| Tree | Wall time, three rounds |
| --- | ---: |
| `main-3b025c7` | 146.961-147.269 ms |
| `cand-6a91b3b` | 148.308-148.519 ms |
| `cand-pad32` | 147.747-148.078 ms |

And `perf stat -r 21` of each, twice (`logs/first-head/stat21-fsyntax-pad32.txt`): user cycles 678.8-679.2 million on
main, 685.6-686.1 million with the PR and 681.9-682.1 million for the control, with the PR's and the control's
instructions equal, and kernel cycles 135.0-137.1 million in all three. So the checker's slowdown is in where its
unchanged code falls, not in work: about 60% of it comes back with a 32-byte shift, and the rest is in functions the
shift didn't put back.

## What takes the templates

From a counting build (not on the 9700X; `-E -P` locally), on `sqlite3.c` 3,522 of the 7,051 invocations that went
through the invocation stack take the templates (1,787 written straight into the output, 1,735 into the expansions for
a rescan). Of the 3,529 left, 3,490 have arguments that are expanded first (math.h's `__MATHDECL_1`, `__MATHDECL`,
`__SIMD_DECL`, `__MATHCALL`) and 39 are declined otherwise. On `main.c`, 24,718 take them.

## Limitations

- The driver medians are of 22 processes per round (above), not 21 as in #444's record.
- `sqlite3.c`'s deferred main loop of the PR's head has one slow round (4.538 ms); with four rounds per tree the
  ranges overlap and no difference is claimed.
- The checker's placement control was measured on the first head only. The final head moves the code again; its
  slowdown is smaller (0.2-0.5 ms), with the same signature in `perf stat`.
- The counting build's census and the instruction counts of the PR's description are the laptop's (Ryzen 9 7940HS),
  not this host's.

## Addendum: what the checker's slowdown is

The owner held #473 until the `-fsyntax-only` slowdown was understood. On the final pair:

- **Counters.** `perf stat -r 11` of the front end and the back end, by turns (two groups of six: front-end and
  back-end dispatch stalls, mispredicted branches, op-cache misses, decoder ops, instruction-cache misses, resyncs,
  `stli_other`, loads not complete, instruction reads from L2) differ by at most about 1% between the two binaries, and
  the front-end stall slots are lower with the PR (1,314-1,316 million against 1,336-1,337 million). With six counters
  at once, the cycles themselves overlapped (686.4 and 689.8 million on main, 689.9 and 687.5 million with the PR).
- **Where the cycles go.** A profile of 16 compiles each (`perf record -e cycles:u -c 100003`) has 111,626 samples on
  main and 112,057 with the PR. The increase is in unchanged checker code: `check_literal_number_plain` +333 samples
  (+18%), `check_input_resolve_range` +300, `check_action_operand` +167, `check_input_expressions` +166; the PR's own
  `pp_plan_operators` and `pp_finish_operators` take 155, against `pp_substitute`'s 86 fewer. Most of
  `check_literal_number_plain`'s samples (74% on main, 79% with the PR) land on one store, after an 8-byte load of a
  stack temporary whose tail clang zeroed with two overlapping 8-byte stores: a store-to-load forward that fails on
  every integer literal. The hot checker functions also start at different offsets on each main commit
  (`check_input_expressions` at 32 in `3b025c7`, 48 in `dd982df`, and 0 with the PR).
- **A control with another change to the checker.** `scripts/literal.patch` has `check_literal_integer` write its
  fields into the caller's result, which removes the temporary and the failed forward, and 0.8 million instructions.
  `scripts/queue23.sh` built it on main and on the PR (`main-dd982df-lit`, `518ded56...`; `cand-5d2c540-lit`,
  `30bf63c5...`) and timed the four builds by turns (`logs/placement/`):

| `-fsyntax-only` of `sqlite3.c` | User cycles, two rounds | User instructions | Wall time, three rounds |
| --- | ---: | ---: | ---: |
| `main-dd982df` | 678.8, 679.4 million | 1,713.2 million | 147.467-147.765 ms |
| `cand-5d2c540` | 680.8, 681.7 million | 1,711.5 million | 147.907-148.176 ms |
| `main-dd982df-lit` | 680.7, 681.5 million | 1,712.4 million | 147.634-147.976 ms |
| `cand-5d2c540-lit` | 681.2, 682.7 million | 1,710.7 million | 147.756-147.999 ms |

The literal change takes 0.8 million instructions out of main and makes it 1.3-2.7 million cycles slower, as much as
the PR. So the whole compile moves by about 0.3% in either direction with any change that moves the checker's code,
including one that only removes work; the PR's 0.2-0.5 ms is within that. In this queue the PR's head took 1.4-2.9
million cycles more than main, less than the 2.0-3.2 million of the final pair's first queue.
