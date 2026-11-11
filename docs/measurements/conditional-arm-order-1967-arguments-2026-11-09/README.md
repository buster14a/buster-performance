# Conversions in a conditional's arms, arguments included, error-free units (#1895, PR #1967 at `bbe9acc`)

A second A/B for [buster14a/buster#1967](https://github.com/buster14a/buster/pull/1967), after its review fix. The first
covered `77064cb`: [conditional-arm-order-1967-2026-11-09](../conditional-arm-order-1967-2026-11-09/README.md).
`bbe9acc` adds two things:
- a call argument's conditional takes the same arm frames, with one more test per argument;
- the enumeration candidate looks through a selection.

## Identity

- **Date:** 2026-11-09, by an agent session (Claude Code), under `~/buster-fast-bench/exclusive.sh`, in one lock hold.
- **Host:** `benchpress`, AMD Ryzen 7 9700X.
- **Base:** buster `main` `9404cf0`, the `main` that `bbe9acc` merges.
- **Head:** `bbe9acc`, branch `claude/implicit-enum-enum-cast`.
- **Builds:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`, made in the agent's container and copied over.
- **Inputs:**
  - SQLite's `sqlite3.c`, `~/buster-fast-bench/refine-claude/inputs/sqlite3.c`, with no options;
  - the base tree's `src/buster/compiler/main.c` with `-march=native -Isrc -fwrapv -funsigned-char`.
  - Both builds compile `main.c` without a diagnostic (the `check` lines in `ab.txt`).

## Commands

`ab.sh` runs 3 interleaved rounds of `taskset -c 2 perf stat -x, -e instructions:u,cycles:u`, user mode. SQLite is run
with `-r 5`, `main.c` with `-r 3`. The output is in `ab.txt`.

## Results (means per round)

| build | SQLite instructions | SQLite cycles | main.c instructions | main.c cycles |
| --- | --- | --- | --- | --- |
| base `9404cf0` | 972,438,537–972,438,542 | 444.1M–445.0M | 26,805,289,363–26,805,301,920 | 10.474G–10.511G |
| head `bbe9acc` | 973,268,586–973,268,592 | 441.9M–443.7M | 26,857,851,087–26,857,858,182 | 10.495G–10.524G |

- **Instructions:** +830K (+0.085%) on SQLite, +52.6M (+0.20%) on `main.c`.
- **Cycles:** within the run-to-run spread on both inputs. SQLite's head is the lower; `main.c`'s ranges overlap.
