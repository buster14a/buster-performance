# Calls' own cost in the node machine's T: #2524's step 1 (2026-11-12)

This record is for the pull request that gives the node machine's T two per-unit answers for calls, on
[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1. `docs/node-machine.md`'s "Calls" section
summarizes it.

[buster#2575](https://github.com/buster14a/buster/pull/2575) made calls a code of the machine. Its record
([node-machine-calls-2524-2026-11-12](../node-machine-calls-2524-2026-11-12/)) named two costs of calls in T in its
profiles:

- interning the callee's function-to-pointer type: `type_index_find` and `type_find_or_add`, 2.4% of the run;
- the arguments' conversions: `check_action_convert_plain`, 3.6% of the run against 1.9% before calls.

The change answers both from per-unit state:

- **`NodeMachine.function_pointers`:** a function type's pointer type, by type index. It is filled at the type's first
  designator by `type_pointer`, which stays its twin.
- **`NodeMachine.argument_memo`:** 1,024 direct-mapped entries of 16 bytes, read by `node_machine_argument_memo`.
  - **What it holds:** `node_machine_argument`'s answer, by three keys: the argument record's type, its standing (an
    lvalue, an integer constant, or neither) and the parameter's type. The rule is the twin: it fills a miss and takes
    every argument that isn't a key.
  - **What isn't a key:** an argument the rule reads more of than those three: a floating constant, a null pointer's,
    bit-field's, register array's or volatile part's flag, or an enumeration's lvalue.
  - **What a hit does:** it inherits the record's value as it is. The conversion changes nothing that
    `check_action_inherit` reads for an integer, floating, pointer or enumeration type, nor for an array or a function
    decayed to a pointer. An integer constant's hit answers only where every integer constant of its type converts
    alike: not for a pointer parameter, where a null pointer constant is taken and another isn't.

The work was developed on #2575's head and measured there (below, "The development"). #2575 merged into
[buster#2571](https://github.com/buster14a/buster/pull/2571)'s branch, which merged into main with the machine's `&&`,
`||` and `?:`. The baked C and X tables merged next. The branch then merged main, and the final figures compare it with
that main.

Everything ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the lock, pinned to CPU 2, with the scripts in
`scripts/`. These are #2575's record's scripts, plus `annotate.sh`, `summary.sh`, `medians.py` and the run drivers.
`time.sh` also times Lua with `--repeat 2`.

## Sources and binaries

| label | buster commit | what |
| --- | --- | --- |
| `main` | [`afcb185e01ab0259a77972d5daa3f2079de26ade`](https://github.com/buster14a/buster/commit/afcb185e01ab0259a77972d5daa3f2079de26ade) | main with the split, calls, `&&`, `\|\|`, `?:` and the baked tables: the pull request's parent |
| `head` | [`28e59f90c307d42aca1ee163c83073a9af6a6c76`](https://github.com/buster14a/buster/commit/28e59f90c307d42aca1ee163c83073a9af6a6c76) | the branch with `main` merged: the pull request's code |
| `parent` | [`01801c143e8b142aab6baceed41fa85d67278b19`](https://github.com/buster14a/buster/commit/01801c143e8b142aab6baceed41fa85d67278b19) | #2575's head, the development's baseline (the same code as its record's `4b0e3cb5`) |
| `v1` | [`7d94d5609f8d53cb2c9acb98da27093d648e6dc6`](https://github.com/buster14a/buster/commit/7d94d5609f8d53cb2c9acb98da27093d648e6dc6) | the pointer column, and the memo for arguments with no constant but an address |
| `v2` | [`2853cb9b720a540e65fcdd1de429a202ded0c87c`](https://github.com/buster14a/buster/commit/2853cb9b720a540e65fcdd1de429a202ded0c87c) | integer constants answered by their type's entry |
| `v3` | [`6668ca1b09ab85d7fa32fafc88451c3bce087ed7`](https://github.com/buster14a/buster/commit/6668ca1b09ab85d7fa32fafc88451c3bce087ed7) | an integer constant a key of its own: `head`'s code, on `parent` |

- **Builds:** each commit was checked out by its id in a worktree of a fresh clone and built by its `./build.sh`
  (Release), as `results/LABEL/build.log` shows.
- **Binary hashes:** `results/LABEL/compiler.sha256`. `head`'s executable is 6,440 bytes larger than `main`'s, and
  `v3`'s 5,632 bytes larger than `parent`'s.
- **Host:** `results/env.txt` (Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, the performance governor).
- **Inputs' hashes:** `results/head/corpora-inputs.txt`. The inputs are #2575's record's.

The pull request's other commits change only the fixture and the documentation.

## The comparison (`corpora.sh`)

`measure-node-machine --shadow --verify --passes 0` by `head`'s compiler, each input without and with `-g`:

| | machine-taken evaluated nodes | calls compared | differences (values, entries, twin), `-g` too | memo entries filled | arguments by the rule | taken calls' arguments |
| --- | ---: | ---: | --- | ---: | ---: | ---: |
| `sqlite3.c` | 242,002 (93.03%) | 13,325 | 0, 0, 0 | 1,898 | 690 | 33,320 |
| Lua 5.4.8, 34 files | 53,385 (87.22%) | 3,949 | 0, 0, 0 | 1,341 | 220 | 9,520 |
| musl, 1,336 units | 98,763 (82.08%) | 5,209 | 0, 0, 0 | 5,096 | 113 | 10,855 |

- **The counts are `main`'s.** On `sqlite3.c` and Lua, the timing runs' comparison pass gives the same report lines by
  both compilers: the expressions, nodes, records, entries, calls and labels taken, the refusals, and the nodes typed
  by the action (12,942 on `sqlite3.c`).
- **The twin covers the memo.** `--verify` checks every call T types by its rule against the action, the arguments'
  conversions included. That check runs whether the arguments came from the memo or from the rule.
- **Every run exited 0.** `verify-holds.txt` has each hold's owner line.
- **What the memo columns count.** The fills and the rule's arguments are over every expression T typed, so they
  include expressions refused later. The last column is the taken calls' arguments alone.
- **`v3` on #2575's head** (`results/v3/verify-*.txt`) also shows 0 differences on all six runs, with #2575's counts:
  208,705, 44,848 and 82,535 machine-taken nodes.

## The cost (`time.sh`, `run7.sh`)

Each figure is the least of 11 passes of one process, each sweep set timed on its own, in this thread's user-mode
counters, per taken evaluated node. Each timed sweep set now starts with the unit's call answers forgotten
(`node_machine_forget`), so each pass pays their fills as one compile of the unit would. `main` has no such state.

`main` and `head` ran ten times each, alternating (suffixes `-f1` to `-f10`). `results/medians-main-head.txt`
(`medians.py`) gives each median, with the least and greatest in brackets:

| T a node | `main` | `head` | change |
| --- | ---: | ---: | ---: |
| `sqlite3.c` cycles | 121.1 (119.8 to 122.9) | 109.8 (109.5 to 112.3) | −9.3% |
| `sqlite3.c` instructions | 446.7 | 401.3 | −10.2% |
| `sqlite3.c` `--repeat 2` cycles (both runs) | 219.5 (217.9 to 224.8) | 199.6 (197.4 to 205.3) | −9.1% |
| `sqlite3.c` `--repeat 2` instructions | 891.1 | 795.7 | −10.7% |
| Lua cycles | 126.8 (124.4 to 127.7) | 117.0 (116.3 to 119.4) | −7.7% |
| Lua instructions | 595.2 | 542.8 | −8.8% |
| Lua `--repeat 2` cycles | 247.9 (247.0 to 253.3) | 228.1 (227.5 to 236.4) | −8.0% |
| Lua `--repeat 2` instructions | 1,188.2 | 1,068.5 | −10.1% |

All three sweeps, `sqlite3.c`: 215.1 cycles and 764.1 instructions a node against 200.0 and 718.7. Lua: 196.8 and
909.2 against 186.4 and 856.8. C runs 204.4 instructions a node and X 113.0 in both, to 0.1: the whole change is
T's.

## The profile (`profile.sh`)

`perf record -c 200003 -e cycles:u` of 40 passes on `sqlite3.c` (`perf-symbols.txt`), as shares of the whole run:

| | `main` | `head` |
| --- | ---: | ---: |
| `type_index_find` + `type_find_or_add` | 1.45% + 0.91% | 0.57% + 0.56% |
| `check_action_convert_plain` | 3.51% | 2.63% |
| `node_machine_operand_value` | 5.31% | 4.38% |

What remains of those:

- **The interning:** an array's decay and `&x`, which call `type_pointer` per node, and the column's refill at each
  timed pass.
- **The conversions:** the stores' (`=`, an initialization, a return), the discards' and the rule's arguments. A store's
  converted value is its record's, compared field by field, so it isn't the memo's to answer.

`node_machine_action`'s share rises from 3.24% to 4.80%, though it types the same 12,942 nodes in both. Its share is
of a shorter run, and the samples move between it and the action's callees: `check_action_arithmetic` falls from
1.00% to 0.75%.

## `-c` is unchanged (`ab.sh`)

`-c` of the frozen `sqlite3.c` with the 9700X job's options, in `time-runs`' Williams order, 21 runs each after 2
warm-ups (`results/ab-main-head/time-runs.txt`, `results/ab-parent-v3/time-runs.txt`):

| | wall, median (range) | user cycles, median | instructions |
| --- | ---: | ---: | ---: |
| `main` | 123.826 ms (123.617 to 124.371) | 600.748 M | 1,350,807,741 |
| `head` | 123.679 ms (123.202 to 124.893) | 601.214 M | 1,350,807,601 |
| `parent` | 123.948 ms (123.615 to 124.518) | 601.257 M | 1,350,802,307 |
| `v3` | 124.075 ms (123.484 to 124.999) | 602.838 M | 1,350,802,648 |

That is −0.12% and +0.10% wall time with the same instructions. The machine runs only under
`measure-node-machine --shadow`.

## The development, on #2575's head

`v1`, `v2` and `v3` were built and timed against `parent` before main took the calls (`run1.sh` to `run6.sh`;
`summary.sh` prints each run).

**The steps.** `v1` and `v2` ran three and five times, alternating with each other (`run3.sh`, `run4.sh`):

| T a node | `sqlite3.c` cycles | instructions | Lua cycles | instructions | memo fills, `sqlite3.c` | arguments by the rule |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `parent` | 120.1, 120.4 | 455.3 | 120.8, 120.1 | 589.8 | | |
| `v1` | 111.3, 111.5, 110.3 | 412.3 | 112.5, 114.0, 112.7 | 540.3 | 1,687 | 5,506 |
| `v2` | 109.7 to 111.1 | 406.0 | 114.5 to 115.7 | 532.0 | 1,732 | 777 |
| `v3` | 109.5, 109.4, 115.4 | 405.3 | 112.3, 111.4, 112.3 | 531.3 | 1,873 | 673 |

- **`v1`** takes most of the gain. The integer constants it left to the rule were 2,697 of the 2,772 arguments the rule
  took on `main.c`. That count comes from a temporary build in the session's container, not kept.
- **`v2`** answered an integer constant from its type's entry. It ran fewer instructions on both inputs, but its Lua
  runs took 114.5 to 115.7 cycles a node, against `v1`'s 112.5 to 114.0.
- **`v3`** makes the constant a key of its own. A hit then tests one key and one bit. `v3` runs the fewest instructions
  of the three on both inputs, and the fewest cycles but for one run.
- **`v3`'s third `sqlite3.c` run (115.4)** is out of line with its other runs and with all ten of the A/B's below.

**`parent` against `v3`,** ten runs each, alternating (`run5.sh`, `run6.sh`; `results/medians.txt`):

| T a node | `parent` | `v3` | change |
| --- | ---: | ---: | ---: |
| `sqlite3.c` cycles | 121.2 (119.5 to 125.0) | 109.7 (108.6 to 111.5) | −9.5% |
| `sqlite3.c` instructions | 455.3 | 405.3 | −11.0% |
| `sqlite3.c` `--repeat 2` cycles | 220.1 (219.1 to 229.7) | 197.7 (195.9 to 200.1) | −10.2% |
| Lua cycles | 121.1 (120.2 to 131.5) | 112.4 (111.1 to 116.4) | −7.2% |
| Lua instructions | 589.8 | 531.3 | −9.9% |
| Lua `--repeat 2` cycles | 240.9 (239.8 to 247.0) | 218.1 (216.8 to 236.8) | −9.5% |

- **At the margin.** #2575's record measured the split, before calls, at 368.1 instructions a node in T over 130,559
  nodes. Against that, the 78,146 nodes that calls bring in now cost T 467.5 instructions each, where they cost 601.0.
- **The profiles** (`parent`, `v3`): `type_index_find` + `type_find_or_add` fell from 1.74% + 0.88% to 0.77% + 0.59%,
  and `check_action_convert_plain` from 3.33% to 2.03%.
- **`annotate.sh`** maps `node_machine_type`'s samples (`v3`) to source lines through `addr2line`
  (`v3/annotate-summary.txt`; the lines are `v3`'s tree's). In it, the memo's key compare, slot and eligibility lines
  are about 3.5% of the function's samples, and the walk of a call's argument list about 2.5%.
  `node_machine_callee_refused` isn't among the heavy lines.

## Notes from the session's container

These ran on an Intel Xeon in the session's container, not here. They are counts, not timings.

- **The memo's size.** `sqlite3.c` fills 1,657 entries at 1,024 entries (`v2`'s code), 1,410 at 2,048 and 1,193 at
  65,536, which is about the distinct keys. The 247 fills that 2,048 entries save are worth about 0.2 cycles a node, so
  the table stays at 16 KB.
- **The fixture.** `test-checker`'s shadow fixture has three new lines whose arguments' keys come again. At `head`, its
  taken calls have 42 arguments, and T fills 16 entries and leaves 1 argument to the rule, with 0 differences under
  `--verify`. `test-checker` passes: 829,500 checks, 0 failures.

## Incidents

- **Main moved under the work.** #2575 merged while this was measured, and main then took the split, the calls, `&&`,
  `||`, `?:` and the baked tables. The branch merged main (`head`), and its code was measured again against that main.
  The development's figures are kept as they ran.
- **Waiting messages.** The lock's messages naming other sessions' holds were removed from the logs and build logs (the
  `exclusive.sh: waiting` lines and their command, title and link lines). The logs held nothing else, so none is kept.

## Limits

- **One process a figure.** Placement moves the sweeps' cycles by about 3% between binaries (the earlier records). The
  instructions are exact.
- **The timed passes start without the call answers,** so their fills are in the figures. The comparison's pass fills
  them too, and its counts are the ones reported.
- **The margin mixes binaries.** Its split figure is #2575's record's binary, not one built here.
