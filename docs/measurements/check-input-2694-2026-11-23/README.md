# check-input on sqlite3.c, main against #2694's references, and a reading's setup (Buster #2694), 2026-11-23

- **Compiler issue:** [#2694](https://github.com/buster14a/buster/issues/2694), claim
  [7112323084](https://github.com/buster14a/buster/issues/2694#issuecomment-7112323084).
- **Workload:** tools/microarch's `sq-c` (`scripts/workloads.sh`, copied from
  `check-input-1489-regrowth-2026-11-13`): `-c --lanes 1` of the frozen corpus's `sqlite3.c`
  (`preprocessor-391e729af658`) with the CI's options, `--time-stages`, on CPU 2. The run root's corpus,
  `predefines-znver5.h` and `self-main.i` are `~/buster-fast-bench/1340-droid/root`'s, as #1489's records' are.
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50-2-lts, perf 7.2.9-1, CPU 2's governor and EPP
  `performance`, THP `always` (`ab/*/host.txt`).
- **Toolchain:** every executable here was built on the host with the 9700X job's staged Clang 23.1.4
  (`~/.cache/buster/benchpress-clang/efdd1dbd…`, first on `PATH` for the trees whose `build.sh` predates the staged
  toolchain: `scripts/build.sh`), Release, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0` (`-g` builds `=1`).
  `raw/builds/` has their logs without the lock's waiting lines.

## What was measured

| label | revision |
| --- | --- |
| `aca9e53a` | `aca9e53aa981bb3f61d21cdd5a408ce5167a06f8`, before #1049, the issue's 45.16 ms |
| `829eb71a` | `829eb71a7caf3d7191ef34c91f321fc11814e046`, after #1671's cuts (7 November), the issue's 43.64 ms |
| `b7a95eed` | `b7a95eedbe16fbd8434654f192f8f7aab76c56e5`, the issue's main (13 November), 46.17 ms |
| `main` | `968a085fe968600a447095f349464660790aa055`, main when this record began (23 November) |
| `main-g`, `829eb71a-g`, `b7a95eed-g` | the same revisions with `-g`, for the profiles |
| `cand1` | `main` with `raw/patches/cand1-on-968a085f.patch`, the pull request's code |

The executables' SHA-256 are in `ab/*/host.txt` (and `prof/i1/SHA256SUMS` for the `-g` ones).

## Method

- **The A/Bs** (`scripts/ab2.sh NAME ROUNDS VARIANT...`): one lock grant (`exclusive.sh`) a round, which runs
  `scripts/round.sh`: every variant's compile, in an order rotated by the round, then every variant's single-run
  `perf stat` (`cycles:u`, `instructions:u`, `branch-misses:u`, `task-clock`) in the same order. A grant takes about
  3 s. About twenty sessions' jobs waited on the lock, so `ab/r1`'s 56 runs took 7 grants rather than 56, as one a
  compile (#1489's record) would have. Each grant appends its holder line (`holds.txt`), `/proc/loadavg` and the
  eight busiest processes before and after it (`procs.txt`), and each run's exit status (`status.txt`) and object
  SHA-256 (`objects.txt`). `diagnostics.txt` has each compile's diagnostics' SHA-256 (the `time-`, `lowering-nodes`
  and `worker-budget` lines removed; `sq-c` gives none, so they are all the empty input's). `summary.tsv` has the
  medians and ranges, with check-input's minor faults and system milliseconds. `lock-summary.txt` replaces
  `exclusive.sh`'s waiting lines, which name other sessions' commands.
- **The profiles** (`scripts/prof.sh NAME RUNS VARIANT...`): `perf record -e instructions:u -c 200003`, a grant a
  round recording one compile of each `-g` build, three rounds; each grant then writes the samples' addresses
  (`perf script -F ip,dso`, `prof/i1/*.ips`: `C` in the compiler). The executables were copied off the host and the
  addresses mapped to inlined frames with `llvm-symbolizer --inlining` (`scripts/attr.py`: innermost, inclusive,
  out-of-line and line tables per run, `prof/i1/*.tsv`; `scripts/stage.py`: the input reader's samples by innermost
  function, A against B, `prof/i1/stage-*.txt`; `scripts/chain.py`, `scripts/callers.py`: one function's samples by
  line, by the function holding it and by its caller; `scripts/diff.py`: two tables' difference). Values are millions of `instructions:u` a compile.
- **The counts** (`counts/`): a throwaway Develop build of `main` with counters (`counts/counters-on-968a085f.patch`,
  never committed), run on `sq-c` in the cloud container. Its object is `main`'s, byte for byte.

## Results

### Where check-input stands (`ab/r1`)

7 rounds, medians in ms (ranges in `ab/r1/summary.tsv`):

| | `aca9e53a` | `829eb71a` | `b7a95eed` | `main` |
| --- | ---: | ---: | ---: | ---: |
| check-input | 45.151 | 43.836 | 46.184 | **41.571** |
| check-expressions | 10.430 | 10.560 | 11.596 | 11.042 |
| check-program | 10.393 | 25.179 | 23.995 | 23.545 |
| total | 107.321 | 120.759 | 124.416 | 115.486 |
| cycles:u | 503.78 M | 574.01 M | 602.53 M | 554.69 M |
| instructions:u | 1,155.62 M | 1,279.86 M | 1,354.05 M | 1,281.17 M |

The three references read as the issue read them (45.16, 43.64 and 46.17 ms then). `main`'s check-input is 2.3 ms
under `829eb71a`'s and 4.6 ms under `b7a95eed`'s: the regrowth is gone, and 2.3 ms more. Its five rounds in huge
pages read 41.0 to 42.3 ms.

Rounds 0 and 1 of `main` and 0 to 2 of `829eb71a` took 29,000 to 32,000 faults in check-input (THP fell back to
base pages; 16 to 27 ms of system time), as #1489's record saw once; the other rounds took 3,047 to 3,099 (`main`) and
4,172 (`829eb71a`). The medians take those rounds in; the rounds in huge pages alone give
41.336 ms (`main`) and 43.601 ms (`829eb71a`). Every variant's seven objects are one SHA-256 each.

### Where the instructions went (`prof/i1`)

The input reader's out-of-line functions (`check_input_*`, `c_binding*`, `check_tag*`, `check_constant*`,
`check_deferred*`, `check_declspec*`, `check_sparse*`, `type_*`), by their samples' innermost function: 371.4 M at
`829eb71a`, 415.6 M at `b7a95eed`, 361.9 M at `main` (`prof/i1/stage-*.txt`).

The issue's table's functions, inclusive of what they inline, three compiles each:

| function | `829eb71a` | `b7a95eed` | `main` | `main` − `829eb71a` |
| --- | ---: | ---: | ---: | ---: |
| `check_input_declarator_step` | 26.7 | 33.3 | 21.9 | -4.7 |
| `check_input_declaration` | 21.7 | 30.5 | 25.7 | +4.0 |
| `check_input_binding_answers` | 15.4 | 20.7 | 3.4 | -12.0 |
| `check_input_specifiers` | 17.6 | 18.2 | 16.9 | -0.7 |
| of which `check_input_named_specifiers` | — | — | 6.9 | +6.9 |
| `check_input_bind_checked` | — | 4.8 | 5.6 | +5.6 |
| `check_input_bind` | 4.7 | 1.5 | 1.7 | -2.9 |
| `check_input_discarded_set` | — | 1.5 | — | |
| `check_input_intrinsic_initialize` | 7.3 | 10.5 | 1.5 | -5.9 |
| `check_input_declarator` | 8.9 | 10.1 | 7.9 | -1.0 |
| `check_input_publish_parameter` (out of the step since) | — | — | 3.5 | +3.5 |
| `check_input_resolve_range` | 64.5 | 62.5 | 56.9 | -7.5 |
| `check_input_expressions_coded_range` | 63.3 | 62.3 | 60.6 | -2.7 |

What took it back, by the merges that touched these functions since `b7a95eed`:

- **The binding answers' unused-name pass** (−12.0 M against `829eb71a`): #3237 (merged as `f6098a388`) skips it
  where none of its diagnostics can be published, as on `sq-c`, which asks for no `-Wunused` warning.
- **The intrinsics' set-up** (−5.9 M): #893's memo (#2653, `16486674f`) and #2654's id-order fill and exact table
  (#2686, `525a425e6`).
- **The declarator step** (−4.7 M): #2850's named declarations (`b76d5d237`, merged by #3268 as `db9efba72`), whose
  recipes (`check_input_named_prefixes`, 1.4 M) let 8,365 of sqlite3.c's 25,818 declarators skip the step and 20,864 of its
  44,092 specifier lists take `check_input_named_specifiers`; and the parameter's publication, out of line since.
- **The walks** (`check_input_resolve_range` −7.5 M, `check_input_expressions_coded_range` −2.7 M), by merges this
  record did not single out.

What stays above `829eb71a` in the issue's declaration steps is `check_input_declaration`'s +4.0 M and the binding's
+2.6 M (`check_input_bind` and `check_input_bind_checked`), with no line above about 1 M (`prof/i1/main-g.lines.tsv`).
`instructions:u` samples on Zen 5 land after slow instructions, so a line's share mixes its instructions with the
cache misses before it (`check_input_named_specifiers`' first loads, of its recipe column and the parser's depths).

### The counts (`counts/sq-c.txt`)

sqlite3.c's `sq-c`: 16,463 declarations, 25,818 declarators (8,365 plain, 17,453 with a run), 20,263 declarator steps,
44,092 specifier lists (20,864 named), 15,407 parameters, 22,740 bindings, and 5,113 constant readings of 9,002
tokens in all, 1.8 tokens a reading.

A constant reading's set-up (`check_constant_input_initialize`) pushed 17 columns one by one and filled them with 15
`memset`s: 3.4 M instructions inside it, 2.7 M of them its pushes, about 670 a reading, before the reading itself
(`check_constant_evaluate`, 2.7 M). Each declarator run pushed its record, frames, parts and parameters on their
own: 3.0 M of `arena_push`'s 10.0 M are in `check_input_declarator`.

### The change (`ab/c1`)

`raw/patches/cand1-on-968a085f.patch`, the pull request's code:

- **A constant reading's columns** (`check_constant_input_initialize`) are placed in one block of the scratch, each at
  16 bytes as its own push placed it: first the five that start all ones (`first_value`, `last_value`, `next_value`,
  `warning_begin`, `type_begin`), then the ten that start zero, then `values` and `tag_next`, which start unset as
  they did. One `memset` a run replaces the 15. `check_constant_values_reset`, which resets a slice of each column
  for a job's header (`check_constant_job_header`), is unchanged.
- **A declarator run's record, frames, parts and parameters** (`check_input_declarator_begin`) take one push, at the
  places four pushes gave them (a `_Static_assert` holds the sizes and alignments that make them the same).

`ab/c1`, 9 rounds, `main` against `cand1`, each round's compiles and `perf stat` runs in one grant:

| | `main` | `cand1` | `cand1` − `main` |
| --- | ---: | ---: | ---: |
| check-input, median of 9 | 40.799 ms | 40.608 ms | -0.191 |
| check-input, the 8 rounds in huge pages | 40.785 ms | 40.525 ms | -0.386 (paired median; 8 of 8 lower) |
| total, median of 9 | 114.396 ms | 113.960 ms | -0.436 |
| cycles:u | 556.60 M | 552.15 M | -3.87 M paired median (-0.7%; 9 of 9 lower) |
| instructions:u | 1,281.174 M | 1,275.351 M | -5.82 M (-0.45%) |
| task-clock | 114.13 ms | 113.29 ms | -0.72 paired median (8 of 9 lower) |

Round 0 took base pages for both (29,237 and 29,288 faults), the others 3,046 to 3,048. All 36 runs' objects are
one SHA-256 (`ff6ac04b…`), `main`'s.

### Correctness (`raw/local-checks/`)

Run in the cloud container (Intel AVX-512, clang 23.1.6, `BUSTER_TOOLCHAIN=path`) on the pull request's commit:

- `test-checker --seed 133`: 856,356 checks, 0 failures; the same under `BUSTER_SANITIZER=undefined`
  (`UBSAN_OPTIONS=print_stacktrace=1:halt_on_error=1`), with no runtime error.
- `test-checker-driver --executable ./build/compiler`: 238,645 checks, 0 failures; its warning sweep's 1,574 fixtures
  with 0 differences.
- `test-c-testsuite --cross-check --subset tests/c-testsuite/subset.txt`: 220 of 220 passed.
- `sq-c`'s object is `main`'s on the Develop build and on the UBSan one; the `-Wall -Wextra` diagnostics of
  `sqlite3.c` (`sq-syn`, none) and of the compiler's own `main.c` (two warnings) are `main`'s bytes.

## Not done

- **The bisection** of 829eb71a..f0668e15 and e8dabee3..b7a95eed. The growth it was to find was spread over the
  steps' own code by many of #1447's merges (the issue's own finding), and `main` has since gone below `829eb71a` by
  other merges, which the profile names. A commit-by-commit timeline of a reversed regrowth would change nothing
  this record or its pull request does, at about ten minutes of lock waits a round while it was busy; it was left
  out.
