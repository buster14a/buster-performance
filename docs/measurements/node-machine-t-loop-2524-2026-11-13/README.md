# The node machine's T: its loop's column stores and operands, and two levers that didn't pay (#2524's step 1, 2026-11-13)

This record is for [buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1, the pull request that takes two
of T's own costs out of its loop: its column stores through `machine->columns`, and its operands' search. `docs/node-machine.md`'s
"T's loop: its column stores and its operands, and two levers that didn't pay" section summarizes it.

At main `26f0bb0e` (after [buster#2619](https://github.com/buster14a/buster/pull/2619), T's rules for the action's nodes),
T's profile by retired instructions and by cycles (`annotate2.sh`, `results/m2/annotate2-*`) puts its loop's own
bookkeeping high: the node index recomputed for each operand (`node_machine_node`, 6% of T's instructions), the operands'
search (`node_machine_operand`, 6%), and the column stores, each through `machine->columns`, which under
`-fno-strict-aliasing` every store could change, so it was loaded again after each. The two profiles' shares match line
for line: T is instruction-bound.

Everything timed ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the lock, pinned to CPU 2, with the scripts in
`scripts/`. They are [the action rules' record](../node-machine-action-rules-2524-2026-11-13/)'s, plus `annotate2.sh` (a
profile by `instructions:u` or `cycles:u`, by source line, of `node_machine_type`, `node_machine_call_rule` and
`node_machine_store_rule`), `build-patch.sh` (a revision with a patch applied) and the run drivers.

## Versions

| label | what | source |
| --- | --- | --- |
| `m2` | main | [`26f0bb0e1`](https://github.com/buster14a/buster/commit/26f0bb0e1) |
| `v6` | T's loop's inputs all in locals: the graph's columns, the type words, the node, `first`, `root`, `count` | `f3374df6`, `patches/v6.patch` |
| `v7` | `v6` and each of T's functions' column base in a local | `36451eca`, `patches/v7.patch` |
| `v8a` | main and the operands from the node alone (`node_machine_record_of`) | `patches/v8a.patch` on `m2` |
| `v8b` | main and each of T's functions' column base in a local alone | `patches/v8b.patch` on `m2` |
| `v9` | main and a memo of the callee's type's answers and of a direct callee's returning twice | `52de8687`, `patches/v9.patch` |
| `v10` | `v9`, `v8b` and `v8a` | `176e9f99`, `patches/v10.patch` |
| **`v11`** | `v8b` and `v8a`, with a fixture line (a direct callee that returns twice): the pull request's code | [`e412d48e`](https://github.com/buster14a/buster/commit/e412d48e958f2ab52eda638b2ed7816041ec46f3) |

`v6`, `v7`, `v9` and `v10` were pushed to the branch and replaced there; `patches/` has each as its diff against `m2`, which
is the code each build had. `v8a` and `v8b` were built by `build-patch.sh` from `m2` and their patch
(`results/LABEL/revision.txt` has the patch's hash). Each build is `results/LABEL/build.log`, the lock's waiting lines
removed; its binary's hash is `results/LABEL/compiler.sha256`.

## The sweeps' cost (`time.sh`)

11 passes, each sweep set's least, and again with `--repeat 2`; the versions in turn, each run in a hold of its own: `m2`
22 times, `v6` 8, `v10` 9, `v11` 5, the others 4. `results/medians.txt` has every median, least and greatest. In cycles and
instructions a taken evaluated node:

| `sqlite3.c` | T | T, C and X | T, C and X, two runs |
| --- | ---: | ---: | ---: |
| `m2` | 101.7, 369.2 | 196.7, 672.8 | 339.2, 1,338.8 |
| `v6` | 109.7, 350.3 | 203.0, 653.9 | 350.2, 1,301.0 |
| `v7` | 106.7, 345.5 | 199.8, 649.2 | 345.8, 1,291.4 |
| `v8a` | 100.3, 360.1 | 195.6, 663.7 | 337.3, 1,320.5 |
| `v8b` | 100.5, 358.3 | 193.1, 661.9 | 333.5, 1,317.0 |
| `v9` | 103.3, 370.2 | 196.7, 673.9 | 340.1, 1,339.6 |
| `v10` | 100.8, 349.9 | 194.1, 653.5 | 332.3, 1,298.9 |
| **`v11`** | **99.4, 345.9** | **193.0, 649.6** | **331.4, 1,292.2** |

| Lua 5.4.8 | T | T, C and X | T, C and X, two runs |
| --- | ---: | ---: | ---: |
| `m2` | 96.3, 464.4 | 171.1, 765.0 | 319.7, 1,512.9 |
| `v6` | 100.5, 441.6 | 173.7, 742.2 | 327.2, 1,467.3 |
| `v8a` | 93.7, 454.1 | 168.6, 754.7 | 316.1, 1,492.3 |
| `v8b` | 94.9, 452.1 | 167.6, 752.7 | 313.6, 1,488.2 |
| `v9` | 97.3, 467.6 | 170.2, 768.2 | 319.2, 1,516.1 |
| `v10` | 93.9, 444.0 | 167.0, 744.5 | 312.9, 1,468.8 |
| **`v11`** | **92.3, 437.7** | **164.9, 738.3** | **310.1, 1,459.4** |

- **`v11` against main:** T 2.3% fewer cycles and 6.3% fewer instructions a node on `sqlite3.c`, the three sweeps 1.9% and
  3.4% (2.3% for two runs); on Lua, T 4.2% and 5.7%, the three sweeps 3.6% and 3.5%. C and X run the same instructions on
  every version.
- **`v6`: fewer instructions, more cycles.** Holding the loop's inputs in locals took 19 instructions a node off T on
  `sqlite3.c` and added 8 cycles. In its profile (`results/v6/annotate2-instructions-node_machine_type.txt`) the
  instructions without a source line, the spills and their reloads, are 23% of T's, against 7% at main: the loop inlines
  most rules, and about fifteen live pointers overflowed the registers.
- **`v9`: the callee memo doesn't pay.** In `m2`'s profile the callee's checks and the arguments' gathering were 4% of T's
  loop's instructions and 6.8% of its cycles. With the memo T ran 1.6 cycles slower, and `v10`, the memo with both changes,
  measured as `v8b` and `v8a` do without it. Its 1,024 entries filled 2,161 times for `sqlite3.c`'s 13,478 calls
  (`callee-memo filled=` in the cloud container's runs; 1,632 at 4,096 entries, the unit's distinct callee types). Under
  `--verify` the memo was checked against the type table at every call: corrupting either answer on its fill gave 84 twin
  differences on the shadow's fixture.

## The comparison (`corpora.sh`)

`measure-node-machine --shadow --verify --passes 0` by `v11`'s compiler on the frozen `sqlite3.c`, Lua 5.4.8's 34 sources
and musl's 1,336 units, each without and with `-g` (`results/v11/verify-*.txt`): 0 differences in values, entries and the
twin on all six, status 0, with main's counts (`sqlite3.c`: 258,466 machine-taken nodes, 716 typed by the action).

## Symbols

`nm | grep " t node_machine_"` of `v11`'s executable and `m2`'s list the same functions (`results/symbols-m2-v11.txt`): no
function of the machine is taken out of line or into it by the change.

## `-c sqlite3.c` is unchanged (`ab.sh`)

`time-runs`, 21 runs each after 2 warm-ups in Williams order, one hold of the lock (`results/ab-m2-v11/`): 123.722 ms
against main's 123.932 ms wall, 600.5 M against 602.2 M user cycles, the same instructions. The machine runs only under
`measure-node-machine --shadow`.

## Limitations

- Each version's timings are its own processes, interleaved with the others'; cycles move by a few percent between processes
  of one executable, so the instructions are the firmer figure.
- The memo's fill counts come from the cloud container's builds (an Intel Xeon with AVX-512), whose predefines give
  `sqlite3.c` 5 expressions more than the 9700X's.
- `v6` and `v7` were measured before `v8a` and `v8b` existed; `m2` was timed in every round.
