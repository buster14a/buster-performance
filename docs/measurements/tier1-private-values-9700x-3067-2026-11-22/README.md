# Tier 1 private values (#3067) on the Ryzen 7 9700X

The 9700X check of [buster#3067](https://github.com/buster14a/buster/pull/3067) ("Construct private values and place
live SSA joins in Tier 1"), taken on 2026-11-22 after main was merged into the PR. Its body reported, from a Ryzen 9
7940HS (Zen 4), that one-core musl compiled 2.19% slower with the build-time opt-in
(`-DBUSTER_TIER1_PRIVATE_VALUES=1`) and the [Zen 4 record](../tier1-private-values-zen4-pr3067-2026-11-19/) left the 9700X
unused. This record repeats the Zen 4 record's source-to-object shape on the 9700X under its lock, runs the Tier 1, SSA and
IR blocks of the CI inventory on the merged tree with and without the define, and checks object identity with main.

## Commits

| Tree | Commit | What it is |
| --- | --- | --- |
| main | `e20c6ff98e3af23012ef36d7e9578e87bb4249a4` | buster main, the merge's first parent |
| pr, pron | `a3c7c1b434655b65e1a70cb291139f302cfcbaf5` | `codex/tier1-private-values-zen4` (`5cdd3c91`) with that main merged in, no conflict |

`pr` was built without `BUSTER_BUILD_DEFINES`, `pron` with `BUSTER_BUILD_DEFINES=-DBUSTER_TIER1_PRIVATE_VALUES=1`
(its `CMakeCache.txt` holds it). Develop builds by `./build.sh`; Release builds by `BUSTER_HOST_ARCH=znver5
BUSTER_DEBUG_INFO=0 ./build.sh --config Release`, each under the lock (`build-one.sh`), with the 9700X's staged Clang
23.1.4. A nonempty `BUSTER_BUILD_DEFINES` keeps the single compile of the units (no parallel code generation), so the A/B's
main was built with the same define, which main's source never reads, as the Zen 4 record did. `main-release` is the
[#3130/#3143 record](../tier1-inliner-9700x-3130-3143-2026-11-22/)'s build of the same main commit, copied and checked by its
SHA-256.

```text
18eaf1192a4c878c34575ed58630c0ee2912e54bdaa584d324448fc8cb0e8c82  off-develop      pr,   Develop
6d33417464922d97646a0e75968b19ce3d5695c1a767178cd1ad625e449b7630  on-develop       pron, Develop, define
c93bcd592d80f14f96ce57a1ba62b23e60a984a74d652fc0aa28ebeb2f179964  off-release      pr,   Release
2a6fe48fff9708a683fb2598d7e6d25044a1bce1a96cadc615c5d66c49c191bd  on-release       pron, Release, define
9957d587b7975c5c72418d30f78c295113d53de5b72496a5674792b5b2bfa3e2  main-on-release  main, Release, define
49902798fde7941661006057c6841bb624bf787084ce784dea413a6906c8fea3  main-release     main, Release (#3130/#3143 record)
```

## A/B: source-to-object on one core and on six (`logs/ab-*.log.xz`, `logs/ab-summary.txt`)

`ab.sh`: `ab --rounds 6 --lock lockwrap.sh` running `time-runs --copies 2` over three builds, main-on-release (`main`),
on-release (`pr`) and main-on-release again (`main-again`, the floor), each `time-runs` process one hold of the lock. The
workloads are the Zen 4 record's (`scripts/run.sh` there): one compiler process writing every object of an input set,
`--lanes N --lane-cpus CPUS --tier1 -c` with its flags, on the same files, checked against that record's
`inputs/*.inputs.tsv` SHA-256 by `setup.sh` (SQLite's amalgamation, Lua 5.4.8's 34 units, musl's 1,336 units from the
frozen corpus), with its environment (`LC_ALL=C SOURCE_DATE_EPOCH=1700000000 BUSTER_EXIT_HELPER=0 BUSTER_HUGE_PAGES=1
BUSTER_TEST_HOST_BUSY=0`), objects in `/dev/shm`. One core: `ab --cpu 2`, `--lanes 1 --lane-cpus 2`. Six cores:
`lockwrap6.sh` runs each hold under `taskset -c 2-7` (one thread of each of six physical cores), `--lanes 6 --lane-cpus
2,3,4,5,6,7`. A hold runs 3 timed processes a copy (6 for Lua) after one warm-up a slot, so 36 processes a build (72 for
Lua) over 6 holds. `analyze.py` takes each build's median per hold, then the per-hold change against main (median, range,
holds below zero) and the change of the pooled medians.

| Corpus | Cores | main ms | PR ms | Wall, pooled | Wall per hold: median [range] | Holds lower | User cycles | Instructions | Floor wall per hold [range] |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| SQLite | 1 | 606.92 | 586.84 | −3.308% | −3.275% [−3.372%, −3.169%] | 6/6 | −3.374% | −4.842% | +0.067% [−0.135%, +0.153%] |
| Lua | 1 | 174.44 | 169.90 | −2.601% | −2.632% [−2.676%, −2.411%] | 6/6 | −2.736% | −2.867% | −0.119% [−0.234%, −0.023%] |
| musl | 1 | 985.24 | 978.17 | −0.717% | −0.785% [−0.942%, −0.625%] | 6/6 | −0.828% | −1.061% | +0.056% [−0.126%, +0.156%] |
| SQLite | 6 | 208.40 | 204.28 | −1.976% | −2.028% [−2.182%, −1.853%] | 6/6 | −3.451% | −4.842% | −0.011% [−0.193%, +0.066%] |
| Lua | 6 | 46.69 | 45.87 | −1.741% | −1.795% [−2.408%, −1.235%] | 6/6 | −2.397% | −2.692% | −0.208% [−0.508%, +0.550%] |
| musl | 6 | 240.57 | 239.04 | −0.634% | −0.665% [−1.119%, −0.567%] | 6/6 | −0.857% | −1.036% | +0.020% [−0.501%, +0.181%] |

The ms columns are pooled medians of wall time; the cycle and instruction columns are pooled changes against main. On the
9700X the opt-in is faster in every hold of every case. One-core musl, which the Zen 4 record measured at +2.19% wall and
+2.03% user cycles, reads −0.72% wall and −0.83% user cycles here, with its range clear of the floor's. The instruction
changes match the Zen 4 record's sign and size (SQLite −4.79%, Lua −2.74%, musl −1.07% there).

Each of the 36 holds first waited for the lock (`exclusive.sh: waiting` in the logs), behind another session's
runs (`claude-2925`) taken in turn with these; timings start inside each hold.
`logs/held.txt` has the load and the busiest processes before and after each hold: only kernel workers at 0.1% CPU, and
`exclusive.sh` reported no other busy process. All 1,371 objects (1 + 34 + 1,336) were in the output directory after
each series.

## Correctness on the merged tree (`tests.sh`, `logs/tests-*`, `logs/list-*.txt`)

The blocks of the merged tree's `tools/ci/correctness.tests` matching `[Tt]ier ?1|tier1|SSA|ssa|test-ir|IR|ownership-only`,
less the call-graph check (a Release check, left to CI) and the static executables (matched by `IRELATIVE` only): 38
blocks, including the PR's strict native fixture in the lifetimes block, both SQLite blocks, c-testsuite with Tier 1's
code and the frozen SQLite and musl promotion and lowering blocks. Run through each tree's published Develop build's own
`parallel --jobs 8` in two `--shard`s by `tools/ci/costs/native-none-O3.costs` (two holds), with CI's Clang 23.1.4 and
Ninja 1.13.2 first on PATH, `BUSTER_CORPUS` the 9700X's frozen corpus, c-testsuite (`5c7275656d75`) and SQLite fetched by
the CI scripts from the 9700X's cache.

- Without the define (`off-develop`): 28 of 28 and 10 of 10 passed.
- With the define (`on-develop`): 28 of 28 and 10 of 10 passed.

Both builds printed the same counts: `test-ssa-ir: 3854 checks, 0 failed`; `test-ir-lowering: 1480784 checks, 0 failed`
with digest `0xfa8a6114710fa332`; c-testsuite with Tier 1's code 220 of 220, Tier 1 compiled 430 of 430 functions; the
frozen SQLite promotion 2,602 functions, `phis=6665/6665`; the PR's fixture `functions=4 ... phis=11/11 ...
native_functions=4/4`; SQLite's testfixture subset 1,215 scripts, 45,614 tests, Tier 0's and `--tier1`'s the same as
clang's.

## Object identity (`identity.py`, `identity.sh`, `logs/identity/`)

Each Release build compiled, 8 at a time under one hold: the frozen corpus's 1,336 musl units by `--tier1 -O2 --lanes 1
-march=znver5` (the #3130/#3143 record's files and flags) by default and with `--tier1-passes=+all`, and Lua 5.4.8's 34
units and `sqlite3.c` at `-O2`, `-O2 -g`, `-O0 -g` and `-O2 --tier1-passes=+all`, all by `--tier1` on one lane: 2,812
units, each with status 0 for every build.

| Against main-release | musl | musl +all | apps -O2 | apps -O2 -g | apps -O0 -g | apps -O2 +all |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| off-release (no define) | 1,336 of 1,336 | 1,336 of 1,336 | 35 of 35 | 35 of 35 | 35 of 35 | 35 of 35 |
| on-release (define) | 1,336 of 1,336 | 1,336 of 1,336 | 35 of 35 | 35 of 35 | 35 of 35 | 35 of 35 |
| main-on-release | 1,336 of 1,336 | 1,336 of 1,336 | 35 of 35 | 35 of 35 | 35 of 35 | 35 of 35 |

Every object byte-identical to main's.

## The PR body's other checks (`extra.sh`, `logs/extra.log`)

Under one hold, with the Release builds:

- The strict fixture (`tests/ir-source/private-values.c -DBUSTER_TEST_INLINE_VECTOR=1 --tier1 --tier1-strict --verify`)
  compiled by main-release, main-on-release, off-release and on-release under default, `--tier1-passes=+all` and `-g`
  flags: each configuration's four objects have one SHA-256. main's and the opt-in's executables returned 0 in all three.
- The opt-in's `test-ssa-source --tier1 --typed --lifetimes --generate 64 --seed 48915 --clang clang`: 64 of 64 programs
  and 384 of 384 native functions passed, the Zen 4 record's totals line for line.
- The Zen 4 record's frontier stress generator (`native/scripts/make-frontier-stress.py` there) at 64 and 2,200 joins,
  compiled by the opt-in with `--lanes 1 --tier1 --tier1-strict --verify`: both compiled and returned 0. This build has no
  census counters, so it doesn't show which constructor the 2,200-join function took.

## Files

`queue.sh` ran `build-one.sh`, `tests.sh`, `identity.sh` and `ab.sh` in turn, each build, test shard and timed process
its own hold of the lock; `setup.sh` (run first) cloned the repository, fetched the merge from a bundle of the lane's
branch and checked the inputs; `extra.sh` ran after it. `env.sh` holds the lock's owner, title and link; `held.sh`,
`lockwrap.sh` and `lockwrap6.sh` take the lock and record the machine inside each A/B hold; `blocks.awk` selects the
inventory's blocks. Taken in `~/buster-fast-bench/3067-claude/` on benchpress. The A/B logs are xz-compressed (each lists
the 1,336 musl paths in every hold's header).
