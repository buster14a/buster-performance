# bind.c's exact path (#2924, linker group, piece 2)

The second piece of the linker and executable group
([claim](https://github.com/buster14a/buster/issues/2924#issuecomment-7113415815)): `BIND_PATH_EXACT`, the scalar twin of
binding's vector match, resolve, closure and join, which the checker's `--scalar`, the tests and `benchmark-bind`
selected. The owner's rule 2 applied: the vector path lost to its twin at small links (match and the dynamic
`bind_end`), so it was made faster first. Base is main `68cc356a4`. The experiments were applied as
[`scripts/bind1.patch`](scripts/bind1.patch) to [`bind3.patch`](scripts/bind3.patch) in `~/buster-fast-bench/2924-linker/bind`
on the 9700X; head is the branch `claude/2924-linker-2` (`hbind/`). Release, every run under `exclusive.sh`
([`scripts/run.sh`](scripts/run.sh)), timings on CPU 2.

## Classification

- `BIND_PATH_EXACT` (`Bind.path`, `bind_begin`'s and `bind_begin_borrowed`'s path argument, `bind_match_exact`,
  `bind_resolve_exact`, `bind_library_satisfied_exact` and the exact arms of the shared and library exports and the
  closure): a twin. `c_checker_driver.c` chose it from the checker's `--scalar` through
  `CheckProgramBinding.path` (`c_check_program_emit.c`); the tests and `benchmark-bind` chose it too.
- `bind_closure_exact`, the closure's queue, stays as `bind_closure_queue`: the vector closure falls back to it when a
  round's blocked members pass `BUSTER_BIND_BLOCKED`. That is a data-selected fallback (phase D), not a twin.
- `bind_join_records` stays: COMDAT groups join record by record. Data-selected too.

## The gate: `benchmark-bind` at main

Both paths in one process, 1 to 102,400 workers against each runtime
([`logs/gate-bind-small.log`](logs/gate-bind-small.log), [`logs/gate-bind-large.log`](logs/gate-bind-large.log),
[`scripts/gate-bind.sh`](scripts/gate-bind.sh)). The vector path won `bind_begin` and the closure at every size, and
lost:

- the match at 1 to 16 workers: main's exact over vector 0.83 to 0.99, in cycles a global symbol;
- `bind_end` of the dynamic runtimes (the PIE, the PIE with `-lm`, the position-dependent executable) at every size,
  and the shared library's at 1 to 64 workers: 0.82 to 0.99, in cycles.

## What made the vector path faster

1. `b98e2f2a2`: the resolve scans 64 symbols at a time (their sources as bytes in one vector), and the match 16, as
   two chains of 8 gathers each, so that each chain's dependent loads overlap the other's.
2. `c6188c74c`: a chain with no symbol to look up gathers nothing. A gather issues its loads' work whatever its mask,
   and a small link's last batch is mostly empty.
3. `cac887ddd`: `bind_join_block` copies and clears a piece's columns with inline masked 64-byte moves instead of
   about a dozen `memcpy` and `memset` calls, which cost more than the moves for a piece of a few records.

## Head against main

`benchmark-bind`, main's build and head's in alternating processes, median of 3 rounds (1 to 64 workers) or 2 (2,000 and
102,400) each ([`logs/ab-bind3-small.log`](logs/ab-bind3-small.log): 1, 2, 4, 16 and 64 workers;
[`logs/ab-bind3-large.log`](logs/ab-bind3-large.log): 2,000 and 102,400 workers; [`scripts/ab-bind.sh`](scripts/ab-bind.sh)).
Every ratio below is main's exact path's time over the other's: above 1 is faster than the twin. The match is in
cycles a global symbol, because its time at a few workers is below the log's 0.01 µs resolution.

**match** (cycles a global; ratios are main's exact over the other):

| Workers | Runtime | Main's exact | Main's vector | Head | Exact / main's vector | Exact / head |
| ---: | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | dynamic PIE | 32.00 | 36.39 | 29.72 | 0.879 | 1.077 |
| 1 | shared library | 29.39 | 29.44 | 27.78 | 0.998 | 1.058 |
| 1 | static runtime | 35.17 | 42.28 | 34.83 | 0.832 | 1.010 |
| 4 | dynamic PIE | 28.95 | 31.43 | 25.90 | 0.921 | 1.118 |
| 4 | shared library | 27.19 | 26.00 | 24.19 | 1.046 | 1.124 |
| 4 | static runtime | 32.05 | 36.38 | 30.62 | 0.881 | 1.047 |
| 16 | dynamic PIE | 23.82 | 21.85 | 18.55 | 1.090 | 1.284 |
| 16 | shared library | 21.97 | 18.48 | 16.82 | 1.189 | 1.306 |
| 16 | static runtime | 25.67 | 24.67 | 21.76 | 1.041 | 1.180 |
| 64 | dynamic PIE | 17.57 | 12.02 | 10.14 | 1.462 | 1.733 |
| 64 | shared library | 16.78 | 10.23 | 9.46 | 1.640 | 1.774 |
| 64 | static runtime | 18.32 | 13.05 | 11.27 | 1.404 | 1.626 |
| 2,000 | dynamic PIE | 12.73 | 4.95 | 4.38 | 2.573 | 2.904 |
| 2,000 | shared library | 12.70 | 4.88 | 4.36 | 2.605 | 2.913 |
| 2,000 | static runtime | 12.74 | 4.92 | 4.33 | 2.587 | 2.942 |
| 102,400 | dynamic PIE | 42.50 | 4.82 | 4.23 | 8.816 | 10.046 |
| 102,400 | shared library | 42.11 | 4.79 | 4.22 | 8.791 | 9.967 |
| 102,400 | static runtime | 41.33 | 4.75 | 4.20 | 8.700 | 9.839 |

**bind_end** (cycles; ratios are main's exact over the other):

| Workers | Runtime | Main's exact | Main's vector | Head | Exact / main's vector | Exact / head |
| ---: | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | dynamic PIE | 1,801 | 1,984 | 1,654 | 0.908 | 1.089 |
| 1 | shared library | 1,922 | 2,003 | 1,613 | 0.960 | 1.192 |
| 1 | static runtime | 772,783 | 443,344 | 428,418 | 1.743 | 1.804 |
| 4 | dynamic PIE | 1,798 | 2,055 | 1,787 | 0.875 | 1.006 |
| 4 | shared library | 1,901 | 1,989 | 1,609 | 0.956 | 1.181 |
| 4 | static runtime | 764,093 | 442,362 | 424,273 | 1.727 | 1.801 |
| 16 | dynamic PIE | 1,807 | 2,052 | 1,716 | 0.881 | 1.053 |
| 16 | shared library | 1,957 | 1,980 | 1,687 | 0.988 | 1.160 |
| 16 | static runtime | 762,718 | 442,914 | 423,346 | 1.722 | 1.802 |
| 64 | dynamic PIE | 1,869 | 2,135 | 1,687 | 0.875 | 1.108 |
| 64 | shared library | 2,210 | 2,186 | 1,810 | 1.011 | 1.221 |
| 64 | static runtime | 765,465 | 442,364 | 424,049 | 1.730 | 1.805 |
| 2,000 | dynamic PIE | 4,101 | 4,666 | 2,736 | 0.879 | 1.499 |
| 2,000 | shared library | 12,430 | 8,700 | 7,093 | 1.429 | 1.752 |
| 2,000 | static runtime | 762,403 | 446,862 | 423,726 | 1.706 | 1.799 |
| 102,400 | dynamic PIE | 116,656 | 143,322 | 52,804 | 0.814 | 2.209 |
| 102,400 | shared library | 614,554 | 352,936 | 272,910 | 1.741 | 2.252 |
| 102,400 | static runtime | 967,990 | 576,256 | 473,990 | 1.680 | 2.042 |

Over all 42 rows (7 sizes, 6 runtimes), head over main's exact path: match 1.010 to 10.16, `bind_begin` 1.52 to 9.99,
`bind_end` 1.006 to 2.25, the closure 1.65 to 2.18. Head is at least as fast as the twin at every size and runtime.
The gate's two other sizes, 8 and 256 workers, were timed afterwards on head's build at the branch's head
([`logs/ab-hbind-mid.log`](logs/ab-hbind-mid.log), [`scripts/ab-hbind.sh`](scripts/ab-hbind.sh), 3 rounds; head's
rows carry no path label): match 1.08 to 2.52, `bind_begin` 1.61 to 2.24, `bind_end` 1.07 to 1.80, the closure 1.73
or more. The earlier experiments' logs are [`logs/ab-bind1-small.log`](logs/ab-bind1-small.log) and
[`logs/ab-bind2-small.log`](logs/ab-bind2-small.log).

## Same output

Lua 5.4.8's interpreter (every `.c` but `luac.c`, `-O0`, `-lm`) linked by main, by head, and by piece 3's head, as a
dynamic PIE, `-static`, `-static-pie` and `-no-pie`, by default and with `--scalar`: each executable is the same bytes
as main's, and each runs and prints `42 a,b` ([`logs/exes-compare.txt`](logs/exes-compare.txt), the `exes-*.log`
files, [`scripts/exes.sh`](scripts/exes.sh)).

## Tests and mutation

The deletion removed the tests' comparisons of the two paths' links and bindings; nothing was left comparing the
vector path with itself. `bind_test.c`'s own checks (each rule's expected symbols, sources and members, the static
programs' members against an archive-scan oracle of the test's own, the libraries' imports, and the room checks) and
the executables the other tests write and run carry the semantics. The branch adds one rule, a strong absolute
definition of a name nothing else defines, which must keep its source and value.

20 mutants of the vector code ([`mutation/mutants.txt`](mutation/mutants.txt), [`mutation/run.sh`](mutation/run.sh)),
each built in Release and run against `test-bind`, `test-dynamic`, `test-static`, `test-snapshot` and
`test-executable` ([`mutation/results.txt`](mutation/results.txt)). 4 did not build (an unused variable), and each has a
replacement that keeps the variable in use: 3 → 17, 7 → 18, 8 → 19, 13 → 20. Of the 16 that built:

- 13 are killed. Mutant 14 (the closure's next members not excluding those already needed) hangs past the 900 s
  timeout: killed by the timeout.
- 16 (the match's batch keeps a binding without a name) is equivalent: a symbol with a binding has a name, and an
  unnamed lookup would find no runtime name anyway.
- 18 (a joined atom's empty fixup range moved too) is equivalent: every reader of `fixup_begin` reads `fixup_count`
  fixups from it, none for an empty range.
- 19 (a joined piece's wide addends' indices not moved) survives because no runtime reaches it: no member of this
  system's `libc.a`, `libm.a`, `libgcc.a` or `libgcc_eh.a`, nor `crt1.o`, has an addend outside int32 (`readelf -rW`).
  The exact path's comparison could not see it either. A test needs a synthetic runtime with a wide addend.

16, 18 and 19 were rebuilt and rerun one at a time on the branch's head ([`mutation/rerun.sh`](mutation/rerun.sh),
[`mutation/rerun-results.txt`](mutation/rerun-results.txt)), with the same results.

## Checks

- On the 9700X, the 5 blocks of `tools/ci/correctness.tests` that name `test-bind`, `test-dynamic`, `test-static`,
  `test-snapshot` and `test-executable` pass through `parallel` on head ([`logs/p2-tests.log`](logs/p2-tests.log): 5
  passed, 0 failed).
- The same five commands pass under `BUSTER_SANITIZER=undefined`, `address` and `memory` builds.
- `./build.sh check-call-graph --config Release` finds 0 cycles, and `build_regression --ownership-only` passes once
  `bind_test.c`'s fingerprint is updated (its shared builders lost their `BindPath` argument).
