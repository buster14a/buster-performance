# #1360: a debug build's asserts in the common warnings, 15 November 2026

Evidence for [buster#2800](https://github.com/buster14a/buster/pull/2800), which addresses what was left of
[buster#1360](https://github.com/buster14a/buster/issues/1360) after #1516. The PR's measured commit,
[`964eb8c2`](https://github.com/buster14a/buster/tree/964eb8c2b30e1c43e72d462185f4b4b90f9afd43), is compared with its base,
`main` at [`2ebfe68a`](https://github.com/buster14a/buster/tree/2ebfe68a856613e300231520af5e7ec5627708b6). The branch's last
commit, `dbc72ed8`, changes only a unit test's random input, so it gives the same compiler code.

Every timing, counter and profile here comes from the Ryzen 7 9700X (`benchpress`), CPU 2 (governor and EPP
`performance`), with each run under the shared lock (`exclusive.sh`). [`ab/host.txt`](ab/host.txt) has the kernel, perf,
the CPU and the SHA-256 of each executable. Other sessions' lock-wait messages (`exclusive.sh: waiting …` and the
holder's title and link lines) were removed from the logs before publishing. No busy-process lines were printed.

## Sources and builds

| Name | Revision | Tree |
| --- | --- | --- |
| `base` | buster `2ebfe68a856613e300231520af5e7ec5627708b6` | `git archive` of main ([`trees/base-COMMIT`](trees/base-COMMIT)) |
| `head` | buster `964eb8c2b30e1c43e72d462185f4b4b90f9afd43` | base plus [`trees/head-964eb8c.patch`](trees/head-964eb8c.patch), which is `git diff 2ebfe68a 964eb8c2` byte for byte |
| `head1` (profile only) | base plus [`trees/head1.patch`](trees/head1.patch) | the first commit's per-body region lists alone, an intermediate state, built with debug info for line attribution |

`base` and `head` were built with `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release`, one lock hold
each, by CI's staged Clang 23.1.4 ([`builds/`](builds/)). `head1` used the same command but kept the debug info.

## What was measured

[`scripts/measure.sh`](scripts/measure.sh) runs 7 rounds, each in one lock hold ([`ab/holds.txt`](ab/holds.txt)).
[`scripts/round.sh`](scripts/round.sh) runs every workload by both builds within a round, alternating which build goes
first by round and workload. Each process runs as
`perf stat -x, -e instructions:u,cycles:u taskset -c 2 COMPILER ARGS -o OUT --time-stages`. `total` and `check-program`
are the compiler's own `--time-stages` lines. Every one of the 238 runs exited 0 ([`ab/results.tsv`](ab/results.tsv)).
[`scripts/summarize.sh`](scripts/summarize.sh) takes the medians ([`ab/summary.md`](ab/summary.md)).

- `sq-ci`, `sq-ci-w`: the frozen corpus's sqlite3.c (SHA-256 in [`inputs.sha256`](inputs.sha256)) with CI's options,
  `-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`, without and with
  `-w`.
- `sq-debug`, `sq-debug-w`: the same with `-DSQLITE_DEBUG`, which keeps sqlite3.c's asserts, as in #1360's first table.
- `bodies-N`: N functions of 3 glibc `assert`s each after `#include <assert.h>`, `-c`. This is the shape of a real debug
  build, many bodies with a few asserts each, which the quadratic scan took. `bodies-8000-w` adds `-w`.
- `asserts-N`: one function of N `assert(x != i);`, `-c`, #1360's scaling table (the inputs of #1516's record, same
  SHA-256).
- `lua`, `lua-w`, `lua-assert`, `lua-assert-w`: Lua 5.4.8's 34 files ([`lua-5.4.8.sha256`](lua-5.4.8.sha256)), each
  `-c -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX`, with `-w`, with `-DLUAI_ASSERT` (#1360's second table), or with both,
  by [`scripts/lua-all.sh`](scripts/lua-all.sh). Its `total` is the sum of 34 processes' totals. That sum swings by tens
  of milliseconds with whichever build ran first in the round (148 to 228 ms at equal cycles), so Lua is read by its user
  cycles and `check-program`.

## Results

Medians of the 7 rounds:

| workload | base total ms | head total ms | head/base | base `check-program` ms | head `check-program` ms | base user instructions | head user instructions |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| sq-debug | 216.7 | **210.4** | 0.971 | 43.7 | **37.4** | 2,422.7 M | 2,274.9 M |
| sq-debug-w | 190.1 | 189.3 | 0.995 | 17.2 | 17.3 | 2,047.9 M | 2,047.9 M |
| sq-ci | 123.2 | 122.9 | 0.998 | 23.6 | 23.7 | 1,364.3 M | 1,364.4 M |
| sq-ci-w | 110.1 | 110.0 | 0.999 | 10.9 | 10.8 | 1,224.9 M | 1,224.9 M |
| bodies-1000 | 28.0 | 27.1 | 0.965 | 4.9 | 3.8 | 429.4 M | 386.7 M |
| bodies-2000 | 62.5 | 57.9 | 0.926 | 13.5 | 9.2 | 941.3 M | 771.8 M |
| bodies-4000 | 138.0 | 120.5 | 0.874 | 37.3 | 19.8 | 2,217.6 M | 1,542.4 M |
| bodies-8000 | 318.5 | **248.6** | 0.780 | 111.5 | **42.5** | 5,780.4 M | 3,085.7 M |
| bodies-8000-w | 233.0 | 233.1 | 1.000 | 26.7 | 27.1 | 2,808.2 M | 2,808.4 M |
| asserts-1000 | 7.5 | 7.4 | 0.993 | 0.8 | 0.8 | 105.2 M | 105.0 M |
| asserts-2000 | 13.4 | 13.1 | 0.983 | 1.5 | 1.5 | 207.8 M | 207.3 M |
| asserts-4000 | 25.4 | 25.7 | 1.010 | 3.0 | 3.2 | 413.3 M | 412.2 M |
| asserts-8000 | 51.8 | 52.1 | 1.004 | 6.3 | 6.5 | 824.4 M | 822.2 M |

| Lua's 34 files | base user cycles | head user cycles | base `check-program` ms | head `check-program` ms |
| --- | ---: | ---: | ---: | ---: |
| lua | 756.4 M | 754.6 M | 22.8 | 22.9 |
| lua-w | 677.0 M | 674.1 M | 6.9 | 6.9 |
| lua-assert | 914.0 M | 909.6 M | 30.4 | 30.1 |
| lua-assert-w | 806.1 M | 803.6 M | 8.8 | 8.8 |

- **sqlite3.c's debug build** loses 6.3 ms of `check-program` and 147.8 M user instructions (−6.1%). The warnings'
  own cost, `check-program` with warnings on less with `-w`, goes from 26.5 to 20.1 ms. The debug build is now 11.1%
  slower than its `-w` compile (base: 14.0%), which is below the default build's 11.7% (base: 11.9%).
- **bodies-N**: base's `check-program` multiplies by 2.8, 2.8 and 3.0 per doubling of N, head's by 2.4, 2.2 and 2.1.
  At N = 8,000 the warnings' own cost (less `bodies-8000-w`) goes from 84.8 to 15.4 ms.
- The default build, every `-w` run, `asserts-N` (linear since #1516) and Lua keep their user instruction counts within
  0.3% (Lua's 34 files: 1,624.6 → 1,624.4 M without the asserts, 2,054.7 → 2,052.5 M with them).
- The objects written in round 1 are byte-identical between the builds (13 of them: every sqlite3.c, bodies and
  asserts workload's). The 17 workloads' diagnostics (stderr without the `time-*`, `worker-budget` and `lowering-nodes`
  lines) are the same; [`ab/out/`](ab/out/) keeps the sqlite3.c ones.

## Where the cycles went

[`scripts/prof.sh`](scripts/prof.sh) records `cycles:u` for 8 compiles under one lock hold, each at a different period
(200003 + 2i), since a fixed period samples a deterministic compile at the same instructions every run.
[`scripts/agg.sh`](scripts/agg.sh) then gives the per-symbol difference between two sets as M cycles per compile.

- [`profiles/diff-dbg.txt`](profiles/diff-dbg.txt): base, debug against debug `-w`, 149.8 M cycles apart.
  [`profiles/diff-ci.txt`](profiles/diff-ci.txt): base, default against `-w`, 78.7 M apart.
  `check_common_body_reached` took 20.6 M of the debug build's difference against 1.9 M of the default build's.
  For every body with a statement expression, it scanned all the unit's statement expressions, and each glibc assert
  is one. `check_common_unselected_roots_indexed` took 5.1 M against 1.4 M: two `__extension__` SELECTs per assert
  (12,099 in the debug unit, 37 in the default one), each sorted as a key.
- [`profiles/h1dbg-lines.txt`](profiles/h1dbg-lines.txt): `head1` (the per-body lists alone) by source line, debug
  build. About 11 M cycles were `check_common_literal_contexts` (`c_check_common_warnings.c:6641`–`6665` at `head1`), the
  `check_common_query_suppressed` test it calls (`:1499`), and its unselected-roots sweep (`:10317`–`:10325`).
  They ran because every assert's `sizeof ((e) ? 1 : 0)` holds an unevaluated candidate, though no literal context
  reaches inside a sizeof's operand.
- [`profiles/diff-hdbg.txt`](profiles/diff-hdbg.txt): `head`, debug against debug `-w`, 112.3 M cycles apart
  (`check_common_graph_warnings` 23.2 → 12.5 M, `check_common_body_reached` 20.6 → 2.7 M,
  `check_common_unselected_roots_indexed` 5.1 → 2.4 M). The debug compile's `-w` run takes 1.77 times the default
  one's cycles, so a warnings cost in proportion would be 139 M. What remains is the per-node common-warning passes that
  every build pays, #1340's: `check_driver_common_warnings`' inlined passes, `check_common_own_reach`, the
  `-Wreturn-type` facts, `-Wunsequenced`, the parents.

[`profiles/main-5-runs.tsv`](profiles/main-5-runs.tsv) holds base's first five-run look at the four sqlite3.c workloads
([`scripts/quick.sh`](scripts/quick.sh)), which agrees with the A/B's base column.

## Limits

- One machine, one CPU, 7 rounds. The A/B's builds come from CI's Clang 23.1.4 without debug info. Code layout differs
  between them, which the instruction counts are immune to and the timings are not: they agree here.
- #1360's criterion, the debug build within a few percent of its `-w` time, is not met: 11.1%. The rest is the warnings'
  per-node cost, which the default build pays at the same rate (#1340), not anything the asserts add.
- `head1` was a working state, not a commit; its profile only locates lines.
