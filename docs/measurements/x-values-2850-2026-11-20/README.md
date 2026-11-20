# The entries' values on the window (buster#2850's step 2), 2026-11-20

The evidence for the piece that makes, on the front's window, the value of each entry the node machine's X sweep
writes (`node_machine_expand`'s third column: an entry is a kind, a class and a value). The pieces before it made the
kinds and the classes: [x-rows-on-the-window-2850-2026-11-19](../x-rows-on-the-window-2850-2026-11-19/),
[x-update-rows-2850-2026-11-20](../x-update-rows-2850-2026-11-20/) and
[x-branch-rows-2850-2026-11-20](../x-branch-rows-2850-2026-11-20/). The census of X's rows that counted each
value's source by X's code is [x-rows-census-2850-2026-11-19](../x-rows-census-2850-2026-11-19/).

## 1. Before the specification: a census of the values (`before/`)

**What was run.** An experiment's patch (`before/census-values.patch`, on
[buster14a/buster#3191](https://github.com/buster14a/buster/pull/3191)'s head `5ee22d6a5`, the branches' rows' code)
prints, with `BUSTER_CENSUS_V=1`, a line for each record of each expression the rows take on the window
(`measure-node-machine --shadow --passes 0 --window-rows`): what the window has of the record (its operator, its
template, its two shapes, its operands' distances, its subtree's records, its line's object, payload, standing,
exponent and member's offset, its classes and facts, its first operand's conversion's type's stride and its own
type's) and its row's entries as the reference's tape has them at reader time, a kind, a class and a value each
(`xv` lines; one `xh` line has the operators' and the templates' numbers). On the 9700X (`before/census-run.sh`: the
working tree's incremental Develop build and `test-checker --seed 133 --part 5/8`, `dev-census.log`; then the shadow
on `sqlite3.c`, Lua and musl, CPU 2, each run its own hold of the lock, `census-corpora.log` and
`corpus-CORPUS.txt`, the runs' outputs without the census's lines). Counts, no times. The lines are
`CORPUS.tsv.xz` (`lines.txt`: 268,942, 61,509 and 188,250 records' lines and a header each).

**The simulation** (`before/simulate-values.py`, its outputs `sim-CORPUS.txt` and `sim-three.txt`): a candidate rule
for each entry's value, a function of the window's fields alone, run over the lines and compared with the
reference's value. Every rule gives every entry's value on the three corpora but a floating constant's, which the
simulation does not compute (its significand and exponent, converted to its class's bits): 540,534 entries, none
wrong. `before/census-table.py` makes the table:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions the rows take; their records | 49,073; 268,942 | 9,888; 61,509 | 39,495; 188,250 |
| their entries; those whose value is not zero | 302,047; 152,808 (50.59%) | 54,341; 29,859 (54.95%) | 184,146; 96,945 (52.65%) |
| values that are not zero, a record | 0.568 | 0.485 | 0.515 |
| **by its source: entries; of them not zero** | | | |
| its record's object: a name's read, an address constant's, an update's read by name | 67,111; 67,111 | 14,532; 14,532 | 58,111; 58,111 |
| its destination's record's object: a store or an update by name | 10,881; 10,881 | 1,649; 1,649 | 9,641; 9,641 |
| an integer constant's bits, by its class | 22,277; 10,553 | 4,324; 3,030 | 11,755; 9,123 |
| a folded constant's, by its target's class | 10,889; 4,838 | 1,194; 845 | 6,481; 4,853 |
| a member's offset in bytes | 21,511; 21,511 | 3,431; 3,431 | 2,822; 2,822 |
| the 1 of an offset's sum (a member's, an address constant's) | 22,272; 22,272 | 3,485; 3,485 | 3,167; 3,167 |
| an address constant's offset | 959; 761 | 525; 54 | 719; 345 |
| a pointer's stride (a sum's, a subscript's) | 6,184; 6,184 | 923; 923 | 3,546; 3,546 |
| a pointer's update's stride; its step's 1 | 768; 768 | 588; 588 | 1,070; 1,070 |
| an update's step: one, of the class it is computed in | 1,633; 1,633 | 251; 251 | 932; 932 |
| a floating constant's bits | 83; 46 | 10; 9 | 956; 898 |
| a branch's label: the control's | 3,969; 3,969 | 352; 352 | 1,434; 1,434 |
| a branch's label: an operator's own | 891; 58 | 76; 5 | 380; 12 |
| a call's row | 12,501; 398 | 3,710; 180 | 6,957; 611 |
| a temporary's number | 1,825; 1,825 | 525; 525 | 380; 380 |
| an access's value (a vector's bytes, else 0) | 29,526; 0 | 4,850; 0 | 10,090; 0 |
| a test's zero | 15,077; 0 | 1,820; 0 | 8,681; 0 |
| none: an operation's, a conversion's, a discard's | 73,690; 0 | 12,096; 0 | 57,024; 0 |
| **expressions with two or more of an evaluated call, a labeled operator and a postfix update through an address** | 474 (0.97%) | 163 (1.65%) | 635 (1.61%) |

What the rules are, as the simulation has them:

- **A record's object** is its line's (`NodeFactsRecord.object`). At reader time a global's entry holds its object,
  which stands for its symbol (the machine's `object_symbols` has the object there): no record of the three corpora
  has another symbol than its object.
- **A store or an update by name** has its destination's record's object, its first operand's; the store's own
  record has it too for 3,022 of the 22,171.
- **An integer constant's CONST** is its payload masked to its class's width and extended from it by the class's
  signedness; a folded one's the same by its target's class, and whether it is not zero for a bool's.
- **A member's offset** is its line's, in bits, over eight; an address constant's offset is its payload.
- **A stride** is its first operand's conversion's type's (`check_action_pointer_stride`): a pointer's update's own
  type's is the same for every one of the 1,388 (`before/check-strides.py`, `check-strides.txt`).
- **An update's step** is 1, or one's bits of a floating class (four of the 3,854 are a double's).
- **A branch's label** is the control's own (`BUSTER_NODE_MACHINE_CONTROL_LABEL`) or the label of the operator that
  owns the tested value (an `&&` branched where true, an `||` where false: its first operand's), which is its
  preorder number among the expression's labeled operators: zero for 1,272 of the 1,347.
- **A call's row** is its preorder number among the expression's evaluated calls: zero for 21,979 of the 23,168.
- **A temporary's number** is the pair 0 and 1 in every postfix update through an address: no expression of the
  three corpora has two such updates (`check-strides.txt`'s `kept` lines have each row's pattern).
- **An access's value** is zero for every LOAD, STORE and SET: none is a vector's.

So an expression's values are fields of its records' lines and fixed numbers, but for the expressions with two or
more of an evaluated call, a labeled operator and a postfix update through an address, 0.97%, 1.65% and 1.61% of
them, whose rows, labels and temporaries are numbered.
