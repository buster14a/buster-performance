# The node machine's X: one state test after a record's row, #2524 (2026-11-12)

This is the record of the change to `node_machine_expand` (`src/buster/compiler/c_check_node_machine_expand.c`) in
[buster](https://github.com/buster14a/buster) commit
[`52894ac1eb2a561e9d4cae30eaa51178fd395d0d`](https://github.com/buster14a/buster/commit/52894ac1eb2a561e9d4cae30eaa51178fd395d0d),
part of [buster#2524](https://github.com/buster14a/buster/issues/2524). It takes the lever that
[the updates' record](../node-machine-updates-2524-2026-11-12/README.md) left: X's tests for an update's destination.

**Before the change,** X's loop tested each record's state three times beyond whether it's evaluated:
- after an evaluated record's row, its consumer's segment (the hook);
- an update's first row (the split);
- at a record that isn't evaluated, an update's destination read by name.

**After it,** one test of a state past `EVALUATED` stands for all three (`node_machine_after_row`). The loop also adds
1 to its record every time, where it added the refusal's bool, and sets `machine->stopped` once, after the loop, to the
record before the last it reached. That is the same record as before.

Everything here ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the 9700X's lock (`scripts/lock.sh`
wraps `~/buster-fast-bench/exclusive.sh`), pinned to CPU 2. `results/env.txt` has the host.

## Sources and binaries

- **Main** is [`f006224e`](https://github.com/buster14a/buster/commit/f006224ef99a3340ebdaa1c7b0d67af0c8b118bc), the
  merge of buster#2577 (the updates). It was built in a worktree checked out at that id with no local change.
- **`v1` and `v2`** are main with a diff applied, in a second worktree (`scripts/apply.sh` resets it to `f006224e` by
  its id, with no change left, and stops if the diff doesn't apply):
  - `v1`, `diffs/fold-v1.diff`: the one test alone;
  - `v2`, `diffs/fold-v2.diff`: the one test and the loop's increment. This is the commit's change: its diff and
    `results/v2/tree.diff` are the same lines.
- Each `results/LABEL/` has the build's log, its commit, the tree's diff and the compiler's SHA-256 (`commit.txt`). The
  compilers aren't kept.
- `scripts/run-all.sh` ran everything, from the work directory's root (`main/`, `src/`, `results/` and the scripts sat
  side by side on the host).

What each step measures:
- **The comparison** (`scripts/corpora.sh LABEL`, the updates' record's own) runs
  `measure-node-machine --shadow --verify --passes 0` on the frozen `sqlite3.c`, Lua 5.4.8's 34 sources and musl's
  1,336 units, each without and with `-g`, one hold a run (`results/LABEL/verify-*.txt`).
- **The timing** (`scripts/time.sh LABEL COMPILER`) runs `measure-node-machine --shadow --passes 11` on `sqlite3.c`
  and on Lua's sources in one hold. For each sweep set (T; T and C; T, C and X) the least cycles and instructions over
  11 passes are kept and divided by the taken evaluated nodes. X's cost is the third set's less the second's. The
  three compilers were timed three times each, in turn: main, `v1`, `v2`, then again (`results/LABEL-timeN/`).

No hold waited for another session's, so the logs have no lock messages to remove.

## The comparison

`v2` reports exactly what main does, line for line, in all six runs. Both have **no difference**, with `-g` too:

| | `sqlite3.c` | Lua 5.4.8 | musl, 1,336 units |
| --- | ---: | ---: | ---: |
| machine-taken evaluated nodes | 258,466 (99.36%) | 57,954 (94.69%) | 110,248 (91.62%) |
| records in taken expressions | 293,554 | 74,442 | 130,969 |
| entries compared, calls compared | 353,246, 13,473 | 70,723, 4,064 | 149,651, 5,357 |
| differences: values, entries, twin; with `-g` | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 | 0, 0, 0; 0, 0, 0 |

## The timing

Per taken evaluated node. T's and C's instructions are the same in every build (453.3 and 208.9 on `sqlite3.c`; 601.0
and 208.4 on Lua).

| `sqlite3.c` | X's instructions | X's cycles, rounds 1, 2, 3 | T, C and X: instructions | T, C and X: cycles |
| --- | ---: | ---: | ---: | ---: |
| main | 117.3 | 40.3, 40.3, 40.2 | 779.5 | 218.6, 219.5, 217.5 |
| `v1`, the one test | 115.6 | 38.7, 38.8, 38.7 | 777.8 | 216.1, 217.4, 215.4 |
| `v2`, and the increment | **110.6** | **37.8, 38.0, 38.0** | **772.8** | 216.3, 216.2, 216.6 |

| Lua 5.4.8 | X's instructions | X's cycles, rounds 1, 2, 3 | T, C and X: instructions | T, C and X: cycles |
| --- | ---: | ---: | ---: | ---: |
| main | 115.1 | 28.9, 28.4, 28.6 | 924.5 | 201.0, 205.4, 201.8 |
| `v1` | 113.5 | 27.4, 27.3, 27.2 | 922.9 | 198.6, 199.4, 199.3 |
| `v2` | **108.2** | **25.8, 25.6, 25.8** | **917.6** | 198.8, 198.4, 198.8 |

- **X runs 6.7 fewer instructions a node on `sqlite3.c` (5.7%) and 6.9 on Lua (6.0%).** Its cycles fall 5.8% and
  10%, in each of the three rounds.
- **The one test alone saves 1.7.** The updates' record put the tests at 2.0 instructions a node. In the local count
  (below) its paths are shorter, but X makes more register copies and stack accesses elsewhere, which take most of it.
- **The increment saves 5.0 more.** With `r += refusal == NODE_MACHINE_TAKEN` in the loop, clang turned the refusal
  into a byte and added it at the end of every record. With `r += 1` it tests the refusal and steps the record, and
  it moves two of the records' column pointers with it, so the rows address those columns without the index.
- The whole three sweeps' cycles move less than one binary's do between processes (about 4%, the updates' record
  found), so X's own cycles, taken within one process, are the figure to read.

## Where the instructions went: callgrind, locally

Valgrind can't run the AVX-512 host build, so this was measured in the session's container, not on the 9700X, on
baseline `BUSTER_HOST_ARCH=x86-64` builds of the same three trees (`local-callgrind/compilers.txt`). Each ran
`measure-node-machine --shadow --passes 1` on c-testsuite's 220-program subset under
`valgrind --tool=callgrind --dump-instr=yes --toggle-collect=node_machine_expand`, with `ulimit -v 67108864`, so the
arenas reserve what Valgrind allows. Its X calls visit 24,546 records: 11,416 evaluated and 13,130 not.

| build | X's instructions, with its callees | an evaluated record's fixed path | a record not evaluated |
| --- | ---: | ---: | ---: |
| main | 1,641,148 | 32 | 19 |
| `v1` | 1,638,478 | 26 | 20 |
| `v2` | **1,532,410** (-6.6%) | **24** | **18** |

- `local-callgrind/LABEL-expand.counts` is `objdump -d` of `node_machine_expand` with each instruction's count from
  `LABEL.callgrind`.
- **`v1`'s fixed paths are shorter, but the total hardly moves.** Every record runs `mov eax, 0`, `cmp bpl, 0x2` and
  `jb` where main ran its tests' `setcc`, `or` and branches. Elsewhere in X, `v1` runs more register-to-register
  `mov`s (97,490 against main's 70,972), more instructions that address the stack (74,396 against 58,818) and a
  constant rematerialized in the rows (8,832).
- **`v2` runs fewer register copies (60,096) but more stack accesses (91,384), and fewer instructions in all.** Each
  record ends in `test eax, eax`, `jne`, `lea`, `add r12, 2`, `add r13, 0x60`, `cmp` and `jb`: the two `add`s step
  pointers into two record columns, which the rows then read without scaling the index.
- The paths' counts are the instructions from the record's state load to the next record's, outside the template's and
  the conversion's own code.
