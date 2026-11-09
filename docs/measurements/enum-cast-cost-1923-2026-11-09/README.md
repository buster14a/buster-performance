# -Wimplicit-enum-enum-cast's cost on error-free units (#1447, PRs #1827 and #1923)

Raw evidence for [buster14a/buster#1923](https://github.com/buster14a/buster/pull/1923), "Checker: render
-Wimplicit-enum-enum-cast's target only when it warns" ([#1447](https://github.com/buster14a/buster/issues/1447)).

[#1827](https://github.com/buster14a/buster/pull/1827) added the warning and measured only SQLite, where its gate stays
shut. On `src/buster/compiler/main.c` the gate opens. There the check rendered each candidate's target spelling first,
and a `return`'s spelling scans the unit's bodies from token 0. #1923 renders it only at a leaf that warns.

## Identity

- **Date:** 2026-11-09, by an agent session (Claude Code), each run under `~/buster-fast-bench/exclusive.sh`.
- **Host:** `benchpress`, AMD Ryzen 7 9700X.
- **Builds:** `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh`.
  - `first-run`: the builds were made on benchpress.
  - `ab`: the builds were made in the agent's container and copied over. The coordinating session asked the #1447
    sessions to cut their load on the host.
- **Trees:**
  - `pre`: main before #1827, `cb608c1f616f8fe26234bcaaa869caccc571de63`.
  - `main`: `4842317`, the #1827 merge (`first-run`'s head, `6daeee98`, differs from it only by later `main` commits).
  - `fix`: `627079e`, branch `claude/implicit-enum-enum-cast` (#1923). `55f1bab` adds only a test fixture.
- **Inputs:**
  - SQLite's `sqlite3.c`, `~/buster-fast-bench/refine-claude/inputs/sqlite3.c`, with no options;
  - the `pre` tree's `src/buster/compiler/main.c` with `-march=native -Isrc -fwrapv -funsigned-char`.

## Commands

All use `taskset -c 2 perf stat -x, -e instructions:u,cycles:u`, user mode.

- `ab.sh`: one lock hold, 3 interleaved rounds of `pre`, `main` and `fix`. SQLite is run with `-r 5`, `main.c` with
  `-r 3`. The output is in `ab.txt`.
- `first-run.sh`: `-r 5` per lock hold, base `pre` against head `6daeee98`. It was stopped in its second round, once the
  regression was clear. The output, with the lock's waiting lines, is in `first-run.txt`.

## Results (`ab.txt`, means per round)

| tree | SQLite instructions | SQLite cycles | main.c instructions | main.c cycles |
| --- | --- | --- | --- | --- |
| pre `cb608c1f` | 972,617,685–972,617,691 | 441.6M–442.6M | 26,566,352,596–26,566,372,556 | 10.370G–10.395G |
| main `4842317` | 972,862,260–972,862,315 | 442.3M–443.3M | 58,529,482,898–58,529,504,612 | 15.404G–15.425G |
| fix `627079e` | 972,864,852–972,864,928 | 442.4M–444.0M | 26,608,624,948–26,608,653,597 | 10.375G–10.399G |

- **`main.c`:**
  - `main` cost +31.96G instructions (+120%) and +5.04G cycles (+49%) over `pre`.
  - `fix` is +42.3M instructions (+0.16%) over `pre`, with cycles within the spread.
- **SQLite:** `main` and `fix` are both +245K instructions (+0.025%) over `pre`, the gate's own cost, with cycles
  within the spread.

`first-run.txt` agrees: `pre` gives 975.50M on SQLite and 26.61G on `main.c`, and `6daeee98` gives 975.74M and
58.57G. That run used a SQLite input built and timed the same way, but its absolute counts differ from `ab.txt`'s by
about 3M, which is consistent across trees.
