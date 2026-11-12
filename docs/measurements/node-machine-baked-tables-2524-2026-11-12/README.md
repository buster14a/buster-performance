# Baked context and template tables for C and X: #2524's step 1, a lever measured (2026-11-12)

[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1, the shadow, costs about 172 cycles a taken
node on `sqlite3.c` against its gate of 120 ([the cost record](../node-machine-shadow-cost-2524-2026-11-12/)). That
record left two levers: the design's 28-byte records, and **C's and X's per-node branches replaced by baked tables and
fixed-width row stores** (`docs/node-machine.md`, "C and X: contexts and expansion" and "The tables"). This record
measures the second lever on today's records, a whole 96-byte `CheckValue` each.

**The finding: with today's records, neither table beats the branches it replaces.**

- **C by baked tables** runs 436 to 648 instructions a node against the branches' 189. Computing its table's key from
  a record costs more than the branches it replaces.
- **X by baked rows**, each written by three fixed-width stores, runs 124 to 138 against the branches' 103 when X
  chooses its own rows. It ran 55 to 65 only where C had already chosen them, inside C's 436 to 648.

Every variant is exact: its entries are the lowering's, and `--verify` compares it with the branches, its twin, on every
expression. No variant is proposed for merge. The tables become worth trying once a record carries the facts C keys on
(below).

Everything ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the lock, pinned to CPU 2, with the scripts in
`scripts/` (the earlier records' `time.sh`, `repeat.sh` and `corpora.sh`, a `build.sh` and `profile.sh`, and `lock.sh`
with this session's owner). `TREE=DIR` names the checkout that `build.sh` builds and `time.sh` copies the compiler from.

## Sources and binaries

- **`main`:** buster [`0af27a30`](https://github.com/buster14a/buster/commit/0af27a3096f9bd96334f27943dfc50918f58bc17),
  the branches as they are (C's `node_machine_classify`, X's `node_machine_own` and `node_machine_conversion`).
- **`proto1`, `proto3`, `proto4`, `proto5`:** `main` with `variants/c-*.diff` applied: C and X by tables, C's rows
  choosing X's.
- **`split`:** [buster#2571](https://github.com/buster14a/buster/pull/2571)'s head
  [`27ee009a`](https://github.com/buster14a/buster/commit/27ee009a3959de4d2c533021b289e969eecf91a2), the machine split
  into one file a sweep with record accessors, on main `0af27a30`. Its C and X are `main`'s.
- **`xrows1`, `xrows2`, `xrows3`:** `split` with `variants/x-*.diff` applied: X by rows, C's branches unchanged.
- Each checkout was a worktree at its commit with its diff applied by `git apply` and nothing else changed (each
  `logs/build-*.log` starts with `git status --short`). Binary hashes: `results/compilers.txt`. Host as the earlier
  records list it (Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, the performance governor).

## The variants

All of them keep the branches as the twin: `--scalar` runs the twin, `--verify` runs both on every expression and counts
the expressions whose records' templates, contexts and targets, or tape, or refusal differ (`templates=` in the
`c-*` variants, `rows=` in the `x-*` ones, both 0 everywhere below).

| label | diff | what |
| --- | --- | --- |
| `proto1` | `c-facts-walk.diff` | C's walk reads every fact the templates' rules ask of a record into a word (22 bits) with no branch on its operator; a per-operator mask's `pext` indexes a baked table of rows (template, operands' rules, X's own-row group); a second word of variant bits picks X's own row; a conversion table baked by running the twin's `node_machine_conversion` at every key. X writes each row by three stores (kinds; classes by `vpshufb`; values by `vpermt2q`). |
| `proto3` | `c-standing.diff` | The record-only facts moved to a pass over the records before the walk (its "standing", two words a record, for a value's and an address's context), so the walk reads one word. |
| `proto4` | `c-standing-locals.diff` | The columns copied into locals before each loop, against `-fno-strict-aliasing`'s reloads. |
| `proto5` | `c-standing-families.diff` | The object's and the constant's facts read only for a `VALUE` or a constant, the operands' by a family branch; the conversion key's halves precomputed. |
| `xrows1` | `x-rows.diff` | On the split, C unchanged. X chooses each record's own row by one branch on its template, reading only that row's facts, takes its conversion's row from the baked table, and writes the row by the three stores. |
| `xrows2` | `x-rows-copy.diff` | X reads the records through a local copy of the machine's columns (`node_machine_records_copy`), so the tape's stores don't reload them. |
| `xrows3` | `x-rows-copy-conversion.diff` | The conversion's key computed only where the record converts. |

## Results

Cycles and instructions a taken evaluated node, the least of 11 passes, each sweep set timed on its own (`time.sh`;
C is T+C less T, X all three less T+C):

| `sqlite3.c` | C: cycles | C: instructions | X: cycles | X: instructions | all three: cycles | all three: instructions |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `main` | 46.2 | 189.0 | 33.3 | 112.8 | 175.8 | 669.9 |
| `proto1` | 157.3 | 647.7 | 19.8 | 59.2 | 273.6 | 1,074.7 |
| `proto3` | 113.7 | 507.9 | 21.5 | 65.4 | 229.8 | 940.9 |
| `proto4` | 107.2 | 508.6 | 21.1 | 54.8 | 224.6 | 931.2 |
| `proto5` | 100.9 | 436.4 | 20.4 | 54.8 | 217.2 | 859.0 |
| `split` | 49.1 | 189.0 | 35.1 | 102.8 | 180.5 | 659.9 |
| `xrows1` | 41.1 | 189.1 | 41.6 | 138.4 | 178.2 | 695.3 |
| `xrows2` | 48.9 | 189.1 | 42.6 | 136.3 | 187.5 | 693.2 |
| `xrows3` | 42.4 | 189.1 | 41.4 | 124.2 | 185.2 | 681.1 |

| Lua 5.4.8 | C: cycles | C: instructions | X: cycles | X: instructions | all three: cycles | all three: instructions |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `main` | 39.2 | 188.1 | 26.6 | 110.7 | 178.0 | 838.6 |
| `proto5` | 97.8 | 485.5 | 20.0 | 61.5 | 230.1 | 1,086.5 |
| `split` | 40.1 | 188.1 | 25.0 | 100.6 | 178.3 | 828.5 |
| `xrows3` | 39.6 | 188.2 | 34.4 | 122.2 | 187.2 | 849.9 |

(The other variants' Lua figures are in `results/*/lua.txt`, in the same order.)

The warm cost, the second of two runs in a row (`repeat.sh`, `--repeat 2`, less one run), on `sqlite3.c`:

| | C: cycles | C: instructions | X: cycles | X: instructions | all three: cycles |
| --- | ---: | ---: | ---: | ---: | ---: |
| `main` | 37.8 | 189.2 | 29.6 | 112.7 | 148.2 |
| `proto1` | 149.5 | 647.7 | 23.5 | 58.2 | 257.5 |
| `proto5` | 83.7 | 436.4 | 21.4 | 54.3 | 194.1 |
| `split` | 35.4 | 189.2 | 25.5 | 102.8 | 139.5 |
| `xrows1` | 47.1 | 189.1 | 31.9 | 137.7 | 169.2 |
| `xrows2` | 46.3 | 189.1 | 35.3 | 135.5 | 158.7 |
| `xrows3` | 41.0 | 189.1 | 36.4 | 123.4 | 150.6 |

C's cycles in the variants that leave it unchanged (`xrows*` against `split`) move by up to 8 with the same
instructions: the placement's, as the earlier records found.

### Where C's cost goes

- **The key, not the lookup.** `proto4`'s C, sampled by instructions retired (`results/proto4/ann-ins.txt`, `perf record
  -c 20011 -e instructions:u` of 40 passes on `sqlite3.c`, annotated), spends 49% of its instructions in the standing pass
  (addresses `0x19c5eb0` to `0x19c68b6`), 43% in the walk (`0x19c6aa0` to `0x19c6dc7`) and 8% around them: about 250 and
  220 instructions a node. The walk's loop is about 190 instructions, nearly all of them run for every record: the row's
  lookup is 5 of them, the rest the operands' writes, the conversion's key and the columns' loads.
- **The branches it replaces are cheap.** The branches' C mispredicts 0.19 times a node (`results/main/perf-misses.txt`:
  11.4% of the run's 17.7 M sampled misses over 80 C-runs of 130,559 nodes). On a 1,200-node fixture, the branches'
  classification (`node_machine_classify`) is about 83 instructions a node of their C's 197, by callgrind on a
  baseline-ISA build on the session's container: the only figure here not from the 9700X. Computing the ~25 bits the
  table reads, each a load or two and a compare, costs more than those branches. Fewer bits a record (`proto5`) and
  locals for the columns (`proto4`) don't close the gap.
- **`proto1`'s mask-register code:** clang packed the fact bits through AVX-512 mask registers (`kshift`, `kor`) with
  heavy spills, a loop body of about 900 instructions. `proto3` onwards avoid it.

### Why X's rows don't pay alone

X's rows cost 55 to 65 instructions where C chose them (`proto*`), and 124 to 138 where X chooses them itself
(`xrows*`). Choosing a record's own row reads what the branches read and branches on the template once, and costs
about what `node_machine_own`'s and `node_machine_conversion`'s branches cost. The three fixed-width stores save little
over the twin's stores at 1.28 entries a node (166,504 entries for 130,559 nodes). Reading through a local copy of the
columns (`xrows2`) moved X by 2 instructions, and computing the conversion's key only where the record converts
(`xrows3`) by 12.

## What would make the tables pay

The key has to be a few byte loads, not ~25 computed bits. The design's 28-byte record has the bytes for that: its
`class`, its `standing` read once from a declaration, its `type`. C's rows read these facts of a record, context-free:

- its category (lvalue, rvalue, function designator);
- its constant (none, integer, floating, address), counted only when pure (no fault, no side effect, no floating-point
  environment);
- its object (none, a local, a global's symbol, past the unit's objects, a compound literal's that isn't static);
- an overload set, a nonzero offset, the type exactly `void`;
- its class and its type's facts (aggregate, address, pointer, `_Bool`, atomic, `_BitInt`, complex).

That is about 11 bits beside the class and the facts. With them in the record, C's row is one lookup on (code, context,
standing, class), and X's row can be C's choice at no extra cost. This record is the baseline that version should beat.

## Correctness

- **Against the pipeline:** every timing run compares each taken expression's records with the stream and its tape
  with the lowering's entries (`values=0 entries=0` in every `results/*/sqlite3.txt` and `lua.txt`).
- **Against the twin, on the corpora:** `corpora.sh` (`--verify`, `--passes 0`) on `sqlite3.c`, Lua 5.4.8's 34
  sources and musl's 1,336 units, each without and with `-g`, for the last variant of each kind, `proto5` and `xrows3`
  (`results/proto5/verify-*.txt`, `results/xrows3/verify-*.txt`; each hold's owner line in `verify-holds.txt`, the
  inputs' hashes in `corpora-inputs.txt`). Values, entries, T's twin and the tables' twin show 0 differences in all 12
  runs, the taken counts are main's, and every run exited 0.
- **Locally,** on a session container (not the 9700X): `test-checker` (829,500 checks, 0 failures),
  `test-baked-tables` (the same bytes), `./build.sh check-call-graph` (0 cycles) and a baseline-ISA build
  (`BUSTER_HOST_ARCH=x86-64`, the scalar row stores) whose `--verify` on `main.c` differs in nothing, for `xrows1`'s
  code.

## Limits

- **One process a figure,** each the least of 11 passes; placement moves C's and X's cycles by several, as above.
- **The `proto*` variants are on main, the `xrows*` on the split.** Their C and X are compared each with its own base
  (`main`, `split`), whose C is the same code and whose X differs by the accessors' 10 instructions.
- **Not every variant has every run:** `proto3` and `proto4` lack `--repeat 2`, and only `proto5` and `xrows3` ran on
  the corpora with `--verify`. A fifth C variant (the facts read by an operator family inside the walk, without the
  standing pass) was measured only by callgrind on the container, and isn't recorded.
- **Other sessions' lock messages** were removed from the build logs; the holds' owner lines are this session's.
