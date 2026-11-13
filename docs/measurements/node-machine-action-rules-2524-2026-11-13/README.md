# The node machine's T: direct rules for the nodes it sent to the action (#2524's step 1, 2026-11-13)

This record is for [buster#2619](https://github.com/buster14a/buster/pull/2619), on
[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1 (the shadow). `docs/node-machine.md`'s "T's rules
for the action's nodes" section summarizes it.

T, the node machine's typing sweep, typed most nodes by its transition table's rows and by direct rules, and the rest by
the action itself, `check_action_compute`, on whole values: 13,987 of `sqlite3.c`'s evaluated nodes and 9,370 of Lua's
at main `df85213e`. The pull request gives the largest groups direct rules of their own, each its action's own steps
behind a guard, with the action as the twin `--verify` checks them against:

- integer constant folds of builtin types of at most 64 bits;
- casts to void, an integer or a pointer, of an integer or a pointer;
- a static object's member and its array's subscripts (address constants);
- a pointer's equality with a null pointer constant;
- `sizeof` and `_Alignof`;
- the comma;
- `?:` of arithmetic or void arms;
- stores of a null pointer constant and of a pointer to another pointee.

It also generalizes the per-unit pointer-type column to every type (unqualified and const), writes a call's value onto
the columns without making it whole, and fixes the store rule's conversion of a plain `char` constant under
`-funsigned-char` (it took the bake's signedness).

Everything timed ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the lock, pinned to CPU 2, with the
scripts in `scripts/`. They are [the call-cost record](../node-machine-call-cost-2524-2026-11-12/)'s, with `medians.py`
taking every run there is, and the run drivers `run-main.sh`, `run-v1.sh`, `run-v3.sh` and `run-v45.sh`.

## Sources and binaries

| label | buster commit | what |
| --- | --- | --- |
| `main` | [`df85213e8`](https://github.com/buster14a/buster/commit/df85213e8) | main, the pull request's base |
| `v1` | [`bfd49a6ee7da44722443cbe3d083961ab36faf39`](https://github.com/buster14a/buster/commit/bfd49a6ee7da44722443cbe3d083961ab36faf39) | the rules but `?:`: folds, casts, members, null comparisons, `sizeof`, comma, subscripts, stores |
| `v3` | [`3b1ac926024915e76bb59cb54e893562c14ab69f`](https://github.com/buster14a/buster/commit/3b1ac926024915e76bb59cb54e893562c14ab69f) | with the pointer column for every type, the char fix, `?:` and a call's value on the columns |
| `v4` | [`3fdd8396d13f56c4061a5f55c8e2597c4b8fa316`](https://github.com/buster14a/buster/commit/3fdd8396d13f56c4061a5f55c8e2597c4b8fa316) | the const types' pointer column moved last of the machine's arrays (and a comments-only commit) |
| `v5` | [`86ad90f737cd00d7021f12752357456030731ff3`](https://github.com/buster14a/buster/commit/86ad90f737cd00d7021f12752357456030731ff3) | the member, truth and logic rules always inlined into T's loop again: the pull request's code |

The pull request's later commits change documentation only. `v2` (`80227843`, the pointer column and the char fix) was
built in no measurement: `v3` replaced it in the queue.

- **Builds:** each commit was checked out by its id in a worktree of a fresh clone and built by its `./build.sh`
  (Release), `results/LABEL/build.log` (the lock's waiting lines removed: they name other sessions).
- **Binary hashes:** `results/LABEL/compiler.sha256`.
- **Inputs:** `results/v3/corpora-inputs.txt`: the frozen `sqlite3.c`, Lua 5.4.8's 34 sources and musl's 1,336 units,
  as the earlier node-machine records have them.

## The comparison (`corpora.sh`)

`measure-node-machine --shadow --verify --passes 0` on each input, without and with `-g`, by `main`'s, `v1`'s, `v3`'s and
`v5`'s compilers (`results/LABEL/verify-*.txt`): all 24 runs show 0 differences in values, entries and the twin, with
status 0. `--verify` checks every node a row or a rule types against the action, so each new rule is checked at every
node it takes. The machine-taken counts are main's on every input; what changes is how T types them:

| | main: by a row or a rule, by the action | `v5` | `v1` |
| --- | ---: | ---: | ---: |
| `sqlite3.c` (258,466 machine-taken evaluated nodes) | 145,701, 13,983 | 158,968, **716** | 158,491, 1,193 |
| Lua 5.4.8, 34 files (57,954) | 32,050, 9,370 | 40,794, **626** | 40,492, 928 |
| musl, 1,336 units (110,248) | 59,899, 10,568 | 69,580, **887** | 68,962, 1,505 |

What the action still types on `sqlite3.c` (`results/v5/verify-sqlite3.txt`'s `action-typed` lines): `?:` whose arms
aren't builtin arithmetic or void (163), pointers' comparisons and differences (`==` 158, `-` 110, `!=` 74, `<` 57),
casts (110: nearly all from or to a floating type, by `results/breakdown/v1-sqlite3-shapes.txt`), and unary `+` of a
variable (99).

## What went to the action (`scripts/diag.c`, `decode.py`, `groups.py`)

A diagnostic in T's action branch, at main `df85213e` and on the cloud container's build (an Intel Xeon with AVX-512, so
its predefines give `sqlite3.c` 5 expressions more than the 9700X's), printed each action-typed node's operator, its
cast's target kind, and its result's and operands' kinds, constants and categories. `results/breakdown/` has the shapes,
at main and at `v1`, and main's nodes grouped by the rule that now takes them:

| | `sqlite3.c` | Lua 5.4.8 |
| --- | ---: | ---: |
| integer constant folds | 3,417 | 4,947 |
| casts | 3,325 | 2,800 |
| a static object's member | 2,144 | 213 |
| stores | 1,276 | 417 |
| a pointer and a null pointer constant | 1,266 | 187 |
| `sizeof`, `_Alignof` | 928 | 373 |
| `?:` | 641 | 376 |
| a static array's subscripts | 471 | 61 |
| the comma | 361 | 576 |
| other | 524 | 370 |

The diagnostic counts some nodes twice (14,353 lines on `sqlite3.c`, where the shadow counts 13,987 action-typed nodes
there), so the groups are shares, not exact counts.

## The sweeps' cost (`time.sh`, `run-*.sh`)

Each label's sweeps timed by `time.sh` (11 passes, each sweep set's least; then `--repeat 2`, two runs of each
expression's sweeps in a row, the second's inputs in the caches), CPU 2, each in a hold of its own, the labels in turn:
main 16 times, `v1` 5, `v3` 9, `v4` and `v5` 4. `results/medians.txt` has every median, least and greatest. In cycles and
instructions a taken evaluated node:

| `sqlite3.c` | T | T, C and X | T, C and X, two runs (`--repeat 2`) |
| --- | ---: | ---: | ---: |
| main | 107.2, 391.2 | 203.1, 694.8 | 351.6, 1,382.9 |
| `v1` | 102.0, 376.4 | 198.9, 680.1 | 346.3, 1,353.2 |
| `v3` | 99.7, 365.3 | 198.8, 668.9 | 347.1, 1,331.0 |
| `v4` | 100.2, 365.4 | 198.6, 669.1 | 344.1, 1,331.3 |
| **`v5`** | **102.0, 369.2** | **196.5, 672.8** | **340.8, 1,338.8** |

| Lua 5.4.8 | T | T, C and X | T, C and X, two runs |
| --- | ---: | ---: | ---: |
| main | 116.9, 555.1 | 191.4, 855.6 | 363.2, 1,694.5 |
| `v1` | 98.5, 476.0 | 174.8, 776.6 | 329.5, 1,536.1 |
| `v3` | 94.4, 461.5 | 171.7, 762.0 | 324.9, 1,507.0 |
| `v4` | 94.9, 461.6 | 171.8, 762.2 | 323.1, 1,507.3 |
| **`v5`** | **96.3, 464.4** | **170.1, 765.0** | **318.8, 1,512.9** |

- **The rules take 26 instructions off T on `sqlite3.c` and 94 on Lua** (`v3`), whose typed operators went to the action
  a quarter of the time against `sqlite3.c`'s twentieth: its constant shifts, `+`, `~` and casts. C runs the same
  instructions on every label, and so does X.
- **X's cycles moved without its instructions.** At `v3`, X (T, C and X less T and C) ran 43.0 cycles a node on
  `sqlite3.c` against main's 39.5, with the same 103.9 instructions. `v4` tested whether it was the pointer column's
  size moving the machine's other arrays: it measures as `v3` does, so it wasn't. At `v1` the new rules had made clang
  take `node_machine_truth`, `node_machine_logic` and `node_machine_pointer_assignable` out of T's loop, and at `v3`
  `node_machine_member` and `node_machine_pointer` too (the member rule alone was 6% of `v3`'s profile). `v5` inlines
  the member, truth and logic rules again, as main had them: T runs 4 instructions a node more than `v3`, but X is back
  at main's 39.4 cycles, and all three sweeps are the least of every label. The executables' symbols
  (`nm | grep node_machine_`) differ from main's only by the new rules and `node_machine_operand_whole`,
  `node_machine_pointer` and `node_machine_pointer_assignable`.
- **Against main, `v5` is 3.2% faster on `sqlite3.c` for one run (3.1% for two) and 11.1% on Lua (12.2%).** Step 1's gate
  asks for 120 cycles a node for all three sweeps; this is 196.5.

## The profiles (`profile.sh`, `annotate.sh`)

`perf record` of 40 passes on `sqlite3.c` (`results/LABEL/perf-symbols.txt`), and T's samples by source line
(`annotate-summary.txt`):

- **The action leaves the profile.** `node_machine_action` and the `check_action_*` functions were 9.5% of main's run
  (`node_machine_action` 5.2%); at `v5` they are 1.9%, `node_machine_action` 0.3%. Most of the rest is
  `check_action_convert_plain` (0.8%), which the rules' whole conversions, the stores' and the calls' call themselves.
  The new rules are each under 0.7% (`node_machine_fold` 0.6%, `node_machine_cast` 0.5%, `node_machine_null_compare`
  and `node_machine_conditional` 0.3%).
- **The type table's interning** (`type_index_find`, `type_find_or_add`) falls from 1.2% of the run at main and `v1` to
  0.6% at `v3` and 0.5% at `v5`, with the pointer column for every type: what's left is the types the columns don't
  hold (pointers to volatile ones, say) and `type_pointer`'s first fill of each.
- **What T has left is its inputs.** T's heaviest lines at every label are the leaves' records, the graph's op, context
  and operand columns, and the type words, as #2580's record found; step 2's parser tree replaces them.

## `-c sqlite3.c` is unchanged (`ab.sh`)

The machine runs only under `measure-node-machine --shadow`. `time-runs` of `-c` of the frozen `sqlite3.c`, 21 runs each
after 2 warm-ups in Williams order, in one hold of the lock (`results/ab-main-v3/`, `results/ab-main-v5/`):

| | wall | user cycles | instructions |
| --- | ---: | ---: | ---: |
| main | 123.887 ms | 601.5 M | 1,351.3 M |
| `v5` | 123.631 ms | 600.7 M | 1,351.3 M |

## Limitations

- The breakdown comes from the cloud container's build, not the 9700X's, and its sources and inputs are those listed;
  the 9700X's own counts by operator are the `verify-*.txt` files' `action-typed` lines.
- Each label's timings are its own processes, interleaved with the others'; cycles move by a few percent between
  processes of one executable, so compare instructions first.
- `v4` was built twice: a stopped driver's build of it finished first, and the new driver built it again in its own
  hold (`results/v4/build.log` is the second's).
