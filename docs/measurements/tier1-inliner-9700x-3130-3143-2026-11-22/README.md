# Tier 1 inliner PRs #3130 and #3143 on the Ryzen 7 9700X

The direct 9700X comparison that [buster#3130](https://github.com/buster14a/buster/pull/3130) ("Reuse each finished
callee's inline shape across Tier 1 callers") and [buster#3143](https://github.com/buster14a/buster/pull/3143)
("Filter direct calls and skip constant radix digits in Tier 1 inliner offers") left pending, taken on 2026-11-22 after
main was merged into both, with their correctness blocks and object identity on the same host.

## Commits

| Build | Commit | What it is |
| --- | --- | --- |
| main | `e20c6ff98e3af23012ef36d7e9578e87bb4249a4` | buster main, the merge base of both |
| pr3130 | `2adc636725643ead540a8ccbbf7037c0f8d5f26f` | `codex/reuse-inline-callee-shapes` (`802ad721`) with main merged in |
| pr3143 | `294e2fc643f282e526792580633a9a0f9eeee2f6` | `codex/tier1-inline-direct-offers` (`5004d012`) with pr3130 merged in |

#3130's branch carries `f45ddd83b` ("Find and replay recorded call sites when rewriting inline blocks"). That is #3126's
commit: #3126 merged into #3119's branch after #3119 had already merged into main, so main never received it. The
pr3130-against-main figures below therefore measure #3126's and #3130's changes together. pr3143 against pr3130 is
#3143's change alone.

Builds: `./build.sh` (Develop) for the tests and `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config
Release` for object identity and timing, each under the 9700X's lock (`build-one.sh`), with the 9700X's staged Clang
23.1.4. Executables' SHA-256:

```text
49902798fde7941661006057c6841bb624bf787084ce784dea413a6906c8fea3  main-release
c741a88c51a38b7ae2ed6f8db8d8e7a30eed203147e40ec7af8ebb0a856c7c83  3130-release
b998f9d869a002dea2cd8b889ec61ed2c1d749147b0e8e59efa71e226729a78d  3143-release
09c28a7cdb21af14094c13fbaba1581a9901fd8bed767b09217ca8575ffdfb73  3130-develop
4356b70fdf5b831f41e8aaad6a6e522ae2dc1c8e8f5bd5d1cc6ed0039b93b5bd  3143-develop
```

## A/B (`logs/ab-145620.log`, `logs/ab-summary.txt`)

`ab.sh`: `ab --rounds 6 --cpu 2 --lock lockwrap.sh` running `time-runs --copies 2` over four builds (main, pr3130, pr3143
and main again as the floor) in a Williams order, each `time-runs` process one hold of the lock. The workloads are the
PRs' own local pairs' commands, on the frozen corpus's `sqlite3.c` (SQLite 3.53.2) and Lua 5.4.8 (CI's cached archive,
`setup.sh`):

```sh
compiler -O2 -march=znver5 --lanes 1 -w --tier1 -DSQLITE_THREADSAFE=0 -DSQLITE_OMIT_LOAD_EXTENSION inputs/sqlite3.c -c -o /dev/shm/claude3130-out/sqlite.o
compiler -O2 -march=znver5 --lanes 1 -w --tier1 -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX inputs/lua/lparser.c -c -o /dev/shm/claude3130-out/lparser.o
```

SQLite: 3 runs a hold, 36 processes a build; Lua's parser: 15 runs a hold, 180 processes a build. `analyze.py` takes each
build's median per hold, then the paired per-hold change (median and range over the 6 holds) and the pooled medians.

| SQLite release compile | instructions | user cycles, pooled | user cycles, per hold: median [range] |
| --- | ---: | ---: | ---: |
| main | 7,820,721,271 | 3,148,417,888 | |
| pr3130 against main | −1.046% | −0.618% | −0.664% [−0.882%, −0.494%], 6 of 6 below 0 |
| pr3143 against pr3130 | −0.115% | −0.140% | −0.117% [−0.271%, −0.054%], 6 of 6 below 0 |
| pr3143 against main | −1.160% | −0.758% | −0.766% [−1.041%, −0.732%], 6 of 6 below 0 |
| main again against main (floor) | −0.000% | +0.007% | −0.002% [−0.343%, +0.096%] |

| Lua parser compile | instructions | user cycles, pooled | user cycles, per hold: median [range] |
| --- | ---: | ---: | ---: |
| main | 150,550,980 | 66,817,748 | |
| pr3130 against main | −1.177% | −0.350% | −0.327% [−0.431%, −0.266%], 6 of 6 below 0 |
| pr3143 against pr3130 | −0.205% | −0.088% | −0.131% [−0.185%, +0.041%], 5 of 6 below 0 |
| pr3143 against main | −1.379% | −0.437% | −0.454% [−0.497%, −0.376%], 6 of 6 below 0 |
| main again against main (floor) | −0.000% | +0.023% | +0.001% [−0.082%, +0.085%] |

Instructions are exact to a few thousand per process (each build's minimum and maximum are in `ab-summary.txt`).
#3130's cycle gains clear the floor's range on both workloads. #3143's cycle changes are all but one below zero, but
they lie inside the floor's per-hold range on SQLite (−0.343% to +0.096%) and partly inside it on Lua's parser: what
#3143 is shown to save is instructions (−0.115% and −0.205%, as its body's local pairs found), not cycles.

`logs/held.txt` has the load and the busiest processes before and after each hold: only kernel workers at 0.1% CPU.

## Object identity (`identity.py`, `identity.sh`, `logs/identity/`, `logs/identity-summary.txt`)

Each Release build compiled, 8 at a time under one hold: the frozen corpus's 1,336 musl units with #3126's record's
`compare-musl.py` choice of files and flags (`--tier1 -O2 --lanes 1 -march=znver5 ...`), and Lua 5.4.8's 34 `.c` files
and `sqlite3.c` at `-O2`, `-O2 -g` and `-O0 -g` by `--tier1` on one lane (`SOURCE_DATE_EPOCH=1792454400`). All 1,441
units compiled with status 0 by each build. main against pr3130 and pr3130 against pr3143: 1,336 of 1,336 musl objects and
35 of 35 objects in each of the three application sets byte-identical.

## Correctness (`logs/tests-*`)

The blocks of the merged tree's `tools/ci/correctness.tests` matching
`test-ir-inline|test-tier0-inline|test-tier1-pipeline|test-check-debug|c-testsuite --tier1|by Tier 1 on one lane|ownership-only`
(`logs/list-*-develop.txt`, 7 blocks), through each tree's published Develop build's own `parallel --jobs 8`, with CI's
Clang 23.1.4 and Ninja 1.13.2 first on PATH. For both PRs:

- `tests-*-develop-rerun.log`: 6 passed (fixture ownership, Tier 0's inlining, the driver's rows and DWARF, Tier 1
  selection and native fragments, the lexer unit on one and four lanes, and the verified optimization passes, whose
  `test-ir-inline` printed `checks=125265 failures=0 independent-executions=22432`); the c-testsuite block failed on the
  harness (no c-testsuite checkout yet).
- `tests-*-develop-ctest.log`: after `tools/ci/fetch-c-testsuite.sh` (`5c7275656d751de0e68b2d340a95b5681858ed07`), the
  c-testsuite block with Tier 1's code passed: 220 of 220, Tier 1 compiled 430 of 430 functions.

The first test run (`tests N-develop exit 1` in `queue.log`; `rerun.sh` overwrote its logs) passed the same 5 other
blocks but ran them through a copy of the executable, which the ownership block refuses ("a detached compiler copy"),
and failed to check out c-testsuite; `rerun.sh` and `ctest.sh` ran them again as above, and `tests.sh` is the corrected
script.

## Files

`queue.sh` ran `build-one.sh`, `tests.sh`, `identity.sh` and `ab.sh` in turn, each step its own hold(s) of the lock;
`env.sh` holds the lock's owner, title and link; `held.sh` and `lockwrap.sh` record the machine inside each A/B hold;
`blocks.awk` selects the inventory's blocks. Taken in `~/buster-fast-bench/3130-claude/` on benchpress.
