# Conversions in a conditional's arms in clang's order, error-free units (#1895, PR #1967)

Raw evidence for [buster14a/buster#1967](https://github.com/buster14a/buster/pull/1967), "Checker: give conversions
in a conditional's arms clang's order" ([#1895](https://github.com/buster14a/buster/issues/1895)). It moves the arms'
leaf reports of a conversion whose source is a conditional into new walk frames. This checks what error-free
`-fsyntax-only` pays for that.

## Identity

- **Date:** 2026-11-09, by an agent session (Claude Code), under `~/buster-fast-bench/exclusive.sh`, in one lock hold.
- **Host:** `benchpress`, AMD Ryzen 7 9700X.
- **Base:** buster `main` `48c0839`, with #1960's two-line build fix applied, since `main` didn't build without it.
- **Head:** `77064cb`, with the same fix.
- **Builds:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`, made in the agent's container and copied over.
- **Inputs:**
  - SQLite's `sqlite3.c`, `~/buster-fast-bench/refine-claude/inputs/sqlite3.c`, with no options;
  - the base tree's `src/buster/compiler/main.c` (fixed as above), with `-march=native -Isrc -fwrapv -funsigned-char`.
  - Both builds compile `main.c` without a diagnostic (the `check` lines in `ab.txt`).

## Commands

`ab.sh` runs 3 interleaved rounds of `taskset -c 2 perf stat -x, -e instructions:u,cycles:u`, user mode. SQLite is run
with `-r 5`, `main.c` with `-r 3`. The output is in `ab.txt`.

## Results (means per round)

| build | SQLite instructions | SQLite cycles | main.c instructions | main.c cycles |
| --- | --- | --- | --- | --- |
| base | 972,590,280–972,590,350 | 443.2M–445.2M | 26,790,816,610–26,790,846,855 | 10.610G–10.621G |
| head | 973,221,686–973,221,688 | 441.3M–443.3M | 26,831,750,384–26,831,768,021 | 10.601G–10.610G |

- **Instructions:** +631K (+0.065%) on SQLite, +40.9M (+0.15%) on `main.c`. This is the arm frames and their tests on
  conversions whose source is a conditional.
- **Cycles:** within the run-to-run spread on both inputs; head is the lower on each.
