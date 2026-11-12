# The node machine split into one file a sweep, with record accessors: #2524 (2026-11-12)

This is the record of an enabling refactor of [buster#2524](https://github.com/buster14a/buster/issues/2524)'s node
machine, meant to change no behavior. `c_check_node_machine.c` keeps the machine's state and the record accessors
(`node_machine_record_*`). T moves verbatim to `c_check_node_machine_type.c`, C to `c_check_node_machine_contexts.c` and
X to `c_check_node_machine_expand.c`, and C and X read every record field through the accessors. The record checks the
refactor's gate:

- **The shadow still agrees with the pipeline.** `measure-node-machine --shadow --verify` on the frozen `sqlite3.c`,
  Lua 5.4.8's 34 sources and musl's 1,336 units, without and with `-g`, shows 0 differences.
- **The tests pass.** These are `test-checker`, `./build.sh check-call-graph`, `test-baked-tables` and the build
  regression's ownership check.
- **The sweeps' instructions a node don't grow** (`--passes 11`).

Everything ran on the Ryzen 7 9700X (`benchpress`), each run in its own hold of the lock and pinned to CPU 2, by the
scripts in `scripts/`. `time.sh` and `corpora.sh` are [the shadow's record](../node-machine-shadow-2524-2026-11-12/)'s,
with this session's lock identity (`lock.sh`); `tests.sh` and `fncmp.sh` are new.

## Sources and binaries

- **`main`:** buster [`0af27a30`](https://github.com/buster14a/buster/commit/0af27a309), the base. Its build log is
  `logs/build-src.log`.
- **`34748d68`:** the measured commit,
  [`34748d680862b5bb9a750102dd5966cdf363e498`](https://github.com/buster14a/buster/commit/34748d680862b5bb9a750102dd5966cdf363e498)
  on `0af27a30`. It was checked out by its id into a clean worktree, with no local change, and built as
  `logs/build-c34748d6.log` shows.
- **`v1`:** the working tree before that commit, applied as a patch to a worktree of `0af27a30`. The commit differs from
  it in two comments and one statement's line wrapping (`node_machine_child_context`'s ternary).
- **`27ee009a`:** the pull request's head,
  [`27ee009a3959de4d2c533021b289e969eecf91a2`](https://github.com/buster14a/buster/commit/27ee009a3959de4d2c533021b289e969eecf91a2).
  Over `34748d68` it adds a design note and routes the shadow's comparison (`node_shadow_same_value`, untimed) through
  the accessors, with a new `node_machine_record_value`. It was checked out by its id into a clean worktree, and built
  afresh as `logs/build-c27ee009.log` shows. Every run below was repeated on it (`results/27ee009a/`,
  `logs/tests-c27ee009-*.log`).
- **Binary hashes:** each `results/*/commit.txt`.
- **Host** (`results/env.txt`): Linux 6.18.50-2-lts, clang 23.1.1, the performance governor.

The `exclusive.sh: waiting` messages, which name other sessions' holds and quote their commands, were removed from the
logs: each log starts at this session's own holder line.

## The sweeps' cost (`results/*/sqlite3.txt`, `lua.txt`)

Instructions a taken evaluated node, each sweep set the least of 11 passes of one process (`time.sh`):

| | T | T+C | T+C+X | X alone |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c`, main | 368.1 | 557.1 | 669.9 | 112.8 |
| `sqlite3.c`, `v1` | 368.1 | 557.1 | 659.9 | 102.8 |
| `sqlite3.c`, `34748d68` | 368.1 | 557.1 | 659.9 | 102.8 |
| `sqlite3.c`, `27ee009a` | 368.1 | 557.1 | 659.9 | 102.8 |
| Lua 5.4.8, main | 539.8 | 727.9 | 838.6 | 110.7 |
| Lua 5.4.8, `34748d68` | 539.8 | 727.9 | 828.5 | 100.6 |
| Lua 5.4.8, `27ee009a` | 539.8 | 727.9 | 828.5 | 100.6 |

- **T is the same code.** It runs 48,053,559 instructions in each build on `sqlite3.c`, and 13,533,317 on Lua.
- **`27ee009a` runs the sweeps' instructions of `34748d68`** (86,160,066 on `sqlite3.c`, 20,772,285 on Lua; T+C 2 more
  in the whole of `sqlite3.c`): its change is outside the timed sweeps.
- **C is the same to 0.001 instructions a node.** T and C run 123 fewer instructions in the whole of `sqlite3.c`
  (72,738,398 against 72,738,521) and 25 fewer in Lua.
- **X runs 10 fewer instructions a node,** 9% of its own. That is register allocation, not skipped work: the tapes are
  the lowering's entries in both builds (below). See the next section.
- **Cycles** (in the logs) are 168.7 a node for `34748d68`, 178.9 for `v1` and 181.0 for main on `sqlite3.c`. T+C moves
  as much (137.2 against 145.4) with the same instructions, so this is placement and run-to-run noise, not a gain this
  record claims.

## The code (`results/codegen.txt`, `codegen-*.diff`)

`fncmp.sh` compares each node-machine and census function of main's executable with the commit's. It strips addresses
and immediates, then reports each function's instruction count and whether the rest is the same:

- **Byte-for-byte the same:** every function but two. This includes T (`node_machine_type`, its out-of-line rules and
  the action), `node_machine_evaluate`, `node_machine_unsigned_power`, the table's initializer and the census.
- **`node_machine_contexts`** (C, with `node_machine_classify` inlined): 880 instructions in each build, scheduled
  differently (`codegen-contexts.diff`, 36 lines). The comma's and a store-through-address's type are read before their
  operands are evaluated: after the call to `node_machine_evaluate`, an accessor would load its column's pointer again.
- **`node_machine_expand`** (X, with `node_machine_own` and `node_machine_conversion` inlined): 977 instructions
  against 980 (`codegen-expand.diff`). Main's X computed each evaluated record's `CheckValue` address at the top of the
  loop (`lea`, `shl`, `add`) and spilled it with a column pointer, and shuffled a register around the context's flags.
  It did this whatever the record's template was. The accessors compute the address only in the branches that read a
  value field.

## The comparison (`results/*/verify-*.txt`)

`corpora.sh`: `--verify --passes 0` on each corpus, without and with `-g`. Each run exited 0, and each hold's owner line
is in `verify-holds.txt`. The counts of `34748d68` and of `27ee009a`, whose comparison reads the records by the
accessors, are main's:

| | `sqlite3.c` | Lua 5.4.8 | musl, 1,336 units |
| --- | ---: | ---: | ---: |
| machine-taken expressions | 32,676 | 5,612 | 13,488 |
| machine-taken evaluated nodes | 130,559 | 25,073 | 56,144 |
| entries compared | 166,504 | 28,506 | 68,642 |
| T's nodes by a row or a rule, by the action | 75,973, 7,238 | 14,416, 5,098 | 30,299, 4,699 |
| differences: values, entries, twin; with `-g` | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 |

## The tests (`logs/tests-c34748d6-*.log`)

`tests.sh` ran each test on each commit's tree, with the same results on `34748d68` and `27ee009a`:

- `test-checker`: 829,506 checks, 0 failures.
- `./build.sh check-call-graph`: 43 units, 0 cycles beyond the 3 allowed ones, 0 split variables.
- `test-baked-tables`: the same bytes as built, built twice the same, nothing written outside them.
- The build regression's `--ownership-only`: ok. It pins the four machine files to `main_unit_checker.c`.

## Limits

- **One process a figure.** Each is the least of 11 passes, and placement moves cycles by about 3% (the shadow's
  record).
- **The code comparison is static.** It says which functions changed and by how many instructions. The dynamic counts
  above say what that does a node.
