# The one-core path's step 2, second piece: what reads T's record (buster#2850), and the fact words' two passes (buster#2872), 2026-11-16

The second piece of step 2 of
[buster#2850](https://github.com/buster14a/buster/issues/2850), under
[its claim](https://github.com/buster14a/buster/issues/2850#issuecomment-6911651414),
and [buster#2872](https://github.com/buster14a/buster/issues/2872), under
[its claim](https://github.com/buster14a/buster/issues/2872#issuecomment-6911655856).
[The first piece](../per-core-step2-operators-2850-2026-11-16) made T's whole
record of every operator a loop a class and found it too dear: 56 cycles an
operator that is no lookup, where step 0's lanes made its fact bytes for 12.
This piece counts what else of a record has to exist: which of its wide
fields (its type's identity, its object, its payload, a member's offset, its
operands' conversions' types) a later reader reads, how, and where the
field's value comes from. It is a count in the shadow. Nothing of the census
is timed, and no compile takes it.

**Result.** The census is exact: of 694,192 runs with nothing changed on
`sqlite3.c`, Lua and musl, none differs. Of the operators that are no lookup,
**84.0%, 59.5% and 82.4% have no wide field that anybody reads**: their bytes
are the whole record. 0.9%, 1.4% and 1.8% have a builtin type read, which a
code names; 9.8%, 14.9% and 9.7% a copy a selector could name. **5.4%, 24.2%
and 6.1% need a value made at the record**, where the claim's line was 15%
and its refutation line 30%: met on `sqlite3.c` and musl, missed on Lua. Every
one of them is a payload, a constant computed at the record; no type is new
at an operator. **C and X decide on a type's or an object's identity for 14,
42 and 206 records** by the census's count (0.005%, 0.06% and 0.16%, where
the line was 2%). **That count understates the one read it is of**: each is
a call's callee, whose type C asks one question of (are all its parameters
plain scalars), and C asks it at every call it takes, 4.1% to 5.5% of the
records.
It is a bit a function type's row can hold, not a wide value a lane would
carry.

For #2872 the command prints the two passes apart. The first pass's own
figure reads 20.11 and 19.93 cycles a record on musl in the two builds the
issue names, rebuilt with the line (0.9% apart), and 20.31 and 20.58 (1.3%
apart) in main with the line and this piece's branch.

The code is buster's `c_check_node_machine_reads.c`
(`measure-node-machine --shadow --facts-reads`), in
[buster#2875](https://github.com/buster14a/buster/pull/2875) (commits
`9dfe7c391` and `b64fbdd7b` on main `3d0d56ed7`); the design's page is
buster's `docs/one-core-path.md` ("Step 2's second piece: what reads T's
record" and "The figures are a difference of two passes"). The results
against the gates are on the issues:
[buster#2850's](https://github.com/buster14a/buster/issues/2850#issuecomment-6915223401)
and
[buster#2872's](https://github.com/buster14a/buster/issues/2872#issuecomment-6915227560).

## What was built

`measure-node-machine --shadow --facts-reads` (it implies `--facts
--facts-operators` with whole records; `--passes 0` skips the kernel's timed
passes). After the fact words' passes it runs, for each unit:

- **A later rule of T** (`node_reads_consumers`): each window is made by the
  kernel, whose records are then T's. Each consumer the kernel made is made
  again by its rule (`node_facts_slow`) with one field of one operand
  changed, and what it makes is compared with what it made. A call's rule is
  the machine's own (`node_machine_call_rule` on the expression's columns,
  `node_reads_call`): the kernel's leaves each argument's conversion to T,
  and that conversion reads the argument's type.
- **C and X** (`node_reads_sweeps`): each machine-taken expression is typed
  again by T, C's columns and X's tape are kept, and for each change of each
  field of each record X runs on C's kept columns, then C, each compared with
  what was kept.
- **The changes** (`node_reads_changes`): the record's type to another of the
  unit with the same word and the same row's facts, and to a type of another
  word; each of 25 flags' bits flipped; its object to another of its kind (a
  local, a global) and to one of the other kind; its payload to the values
  its type holds of its own with the low bit flipped, 0, 3, 8, 70,000 and
  2^40 + 5; a member's offset to two values. For C and X also each operand's
  conversion's type, the same two ways, and its flags' 12 bits (a call's
  arguments' conversions too).
- **A type's other self** is, of the types with its word and row's facts, one
  whose element and whose size or stride differ from its own where there is
  one: `int*` becomes `long*` before it becomes `volatile int*`, which no
  reader of a pointee's size tells from it.
- **Decides, or carried.** A byte-level answer changed (a consumer's
  standing, flags, type's word, conversions' flags or types' words, or
  whether its rule takes it; C's states, contexts, templates, call depths,
  hooks, labels, targets' words, or a refusal; the tape's length, kinds,
  classes, labels, calls or temporaries): the field decides. Only a wide
  value changed: it is carried.
- **A carried value is a read only where it arrives** (`node_reads_classify`,
  from the last record to the first). What a rule carries is an edge from the
  operand's field to the consumer's fields that changed, and counts where one
  of those is itself read. Where C alone carries a value, X runs on C's
  changed columns and the tape says. A flag a consumer only hands on (the
  same bit of its own flags, nothing else) is no read.
- **Where a read field comes from** (`node_reads_sources`): none; a leaf's
  line; a builtin type; an operand's same field; a type the row of an
  operand's type or of the node's type name gives (its value type, promotion,
  element, decayed pointer, return type, the pointer to it), or that type's
  size or alignment; the node's own type name; or new at the record.
- **A payload's source is by what its rule does**, not by its value. Over the
  changes of an operand's payload that leave the rule's byte-level answer as
  it was: it follows that operand's exactly (a copy); it follows for some
  values and not for others (a conversion to a type that doesn't hold them
  all: a copy where the value fits); it changes otherwise (computed); or no
  change left the answer as it was (the value chose the rule's path, as a
  null pointer constant's zero does). A payload that equals an operand's is
  that operand's in the first and the last case, and new in the others and
  where its rule didn't run again.
- **A record's class**: nothing wide is read; what is read a code names (a
  builtin type); what is read is a copy; or something read is new at the
  record.
- **The census checks itself.** Before a consumer's or an expression's
  changes, and after they are all taken back, the reader runs with nothing
  changed and has to make what it made (`differences`); each record's place
  in the windows has to be its place in the machine's expressions
  (`misplaced`). The command exits 1 on either.

For #2872, `node-facts: the two passes, a record of the windows` prints each
timed pass's own cycles, instructions and TSC ticks: the given records put in
place and the kernel, and the given records alone. The kernel's figures stay
their difference.

## How it was run

The 9700X (`benchpress`), each run its own hold of the lock, CPU 2, Release
(`./build.sh --config Release`), main `3d0d56ed7` with the pull request's
`src` and `tools` (`patches/final.patch`, build `final`). The corpora are the
other records': `sqlite3.c` and musl of
`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`, and Lua 5.4.8,
with the node machine's records' options (`scripts/corpora.sh`).

- `scripts/reads.sh final`: the census on the three corpora, `--passes 0
  --list 400`, the census's and the fact words' lines kept
  (`results/final/reads-*.txt`).
- `scripts/two-run.sh LABEL`: the fact words' kernels' timed passes, whole
  and with the operators, three runs each on musl and `sqlite3.c`
  (`results/LABEL/passes-*.txt`), for `two` (main with the two passes' line
  alone, `patches/two-passes.patch`) and `final`.
- `scripts/named.sh`: the two builds #2872 names, main `be6515fba` with
  [C and X where they sit](../node-machine-reader-sweeps-2524-2026-11-16)'s
  `w2.patch` and with
  [the tests where they sit](../node-machine-reader-tests-2524-2026-11-16)'s
  `z3.patch`, each with the two passes' line (`patches/w2t.patch`,
  `z3t.patch`), three runs each on musl in turn.
- `scripts/summary.py results/final` prints the tables below from the
  census's files (`results/final/summary.txt`).

## The result

`results/final/reads-*.txt`; the tables are `results/final/summary.txt`'s.
The counts are the same on every run.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions the machine takes | 51,042 | 10,433 | 21,561 |
| records of the windows | 291,021 | 73,998 | 130,291 |
| measured: every reader run again | 288,697, 99.20% | 71,719, 96.92% | 126,899, 97.40% |
| consumers left to T, whose operands are not | 1,621 | 1,805 | 2,171 |
| expressions past 256 records | 0 | 0 | 0 |
| runs with a field changed: a rule; the sweeps | 8,183,391; 15,004,862 | 2,117,273; 3,846,710 | 3,637,340; 6,744,633 |
| runs with nothing changed; those that differ | 415,598; 0 | 99,580; 0 | 179,014; 0 |
| records misplaced | 0 | 0 | 0 |
| the fact words' records that differ from T's; over decoys | 0; 0 | 0; 0 | 0; 0 |
| wall time of the command, ms | 1,991 | 725 | 2,729 |

By kind, what has to be made at a record (records, and their share of the
kind's measured ones):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| **the operators that are no lookup**, measured | 69,205 | 20,988 | 41,675 |
| nothing wide is read | 58,123, 83.99% | 12,478, 59.45% | 34,325, 82.36% |
| what is read a code names | 585, 0.85% | 293, 1.40% | 754, 1.81% |
| what is read is a copy | 6,751, 9.76% | 3,129, 14.91% | 4,045, 9.71% |
| **something read is new at the record** | **3,746, 5.41%** | **5,088, 24.24%** | **2,551, 6.12%** |
| C or X decide on an identity | 0 | 0 | 1 |
| of a type with no other of its word | 0 | 0 | 55 |
| **the lookups**, measured | 88,250 | 19,421 | 26,724 |
| nothing wide is read | 52,286, 59.25% | 11,663, 60.05% | 17,953, 67.18% |
| what is read a code names | 168, 0.19% | 36, 0.19% | 213, 0.80% |
| what is read is a copy | 8,741, 9.90% | 1,004, 5.17% | 4,255, 15.92% |
| something read is new at the record | 27,055, 30.66% | 6,718, 34.59% | 4,303, 16.10% |
| C or X decide on an identity | 3 | 0 | 3 |
| of a type with no other of its word | 0 | 0 | 171 |
| **the leaves**, measured | 131,242 | 31,310 | 58,500 |
| nothing wide is read | 439, 0.33% | 152, 0.49% | 617, 1.05% |
| what is read is a copy (its line's) | 130,803, 99.67% | 31,158, 99.51% | 57,883, 98.95% |
| C or X decide on an identity | 11 | 42 | 202 |
| of a type with no other of its word | 0 | 0 | 309 |

The operators that are no lookup: which wide field is read (and of those
records, those where it is new at the record), and by whom:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| its type's identity; new | 5,538; 0 | 2,806; 0 | 3,706; 0 |
| its object; new | 107; 0 | 39; 0 | 258; 0 |
| its payload; new | 6,191; 3,746 | 5,746; 5,088 | 4,178; 2,551 |
| … of the new: an operand's where it fits; an operand's, its rule not run again | 93; 515 | 0; 505 | 239; 295 |
| a member's offset | 0 | 0 | 0 |
| its operands' conversions' types; new | 269; 0 | 586; 0 | 469; 0 |
| a wide field read by a later rule of T | 6,320, 9.13% | 5,871, 27.97% | 4,239, 10.17% |
| … by C | 295, 0.43% | 587, 2.80% | 477, 1.14% |
| … by X | 5,228, 7.55% | 3,158, 15.05% | 3,885, 9.32% |

Where those operators' read fields come from (reads of a field, not records):

| field, source | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| type: a type an operand's type's row gives (the pointer to it, mostly) | 2,794 | 1,216 | 996 |
| type: a builtin | 1,331 | 505 | 1,521 |
| type: the node's own type name | 881 | 425 | 468 |
| type: an operand's | 532 | 660 | 721 |
| payload: new | 3,746 | 5,088 | 2,551 |
| payload: an operand's | 1,703 | 401 | 951 |
| payload: a type's size or alignment | 742 | 257 | 676 |
| object: an operand's | 107 | 39 | 258 |
| conversions: an operand's type and a builtin | 269 | 586 | 469 |

The operators with a value new at the record (`results/final/summary.txt`
has them all):

| | `sqlite3.c` | Lua | musl |
| --- | --- | --- | --- |
| most | `-x` 1,261 (96% of its records) | `<<` 1,574 (94%) | `-x` 945 (78%) |
| | `\|` 736 (70%) | `+` 1,038 (59%) | a cast 288 (10%) |
| | a cast 532 (18%) | `~` 711 (99%) | a condition 239 (4%) |
| | `<<` 279 (44%) | `\|` 527 (84%) | `-` 234 (15%) |
| | `~` 263 (87%) | a cast 453 (19%) | `+` 181 (8%) |
| | `-` 211 (17%) | `-x` 380 (93%) | `\|` 122 (28%) |
| | `+` 136 (5%) | `-` 204 (33%) | `<<` 121 (29%) |
| | `*` 115 (17%) | a conversion 47 (4%) | `/` 113 (29%) |

On the compiler's own source (`src/buster/compiler/main.c`, in the cloud
container, `results/local/local-checks.txt`; not the 9700X, and counts
don't need it): 104,757 records, 97.53% measured, no run with nothing
changed differs of 136,108. Of its 28,874 measured operators that are no
lookup, 77.49% have nothing wide read, 3.76% a builtin type, 13.07% a copy,
and 5.68% something new; C decides on an identity for 190 records, all
identifiers (the list was not printed there).

## Against the gate

The claim's gate: the census exact; at most 15% of the records of the
operators that are no lookup need a wide step; C and X decide by a type's or
an object's identity for no more than 2% of the records. Refuted above 30%
wide steps, or above 2% identities.

- **Exact: met.** 0 of 694,192 runs with nothing changed differ; 0 records
  misplaced; and the fact words' records the census starts from are T's
  (their own check, 0 differences, also over decoys).
- **15%: met on `sqlite3.c` (5.41%) and musl (6.12%), missed on Lua
  (24.24%).** Lua's operators are a quarter constant arithmetic. Without the
  payloads that are an operand's where it fits and those whose rule the
  census can't run again, the folds are 4.5%, 21.8% and 4.8%.
- **The refutation line of 30%: not crossed.** With every operator the
  census left counted as needing a value (382 of Lua's 21,370), Lua is at
  25.6%.
- **Identities: met by the census's count, crossed by what the count is
  of.** 14, 42 and 206 records: 0.005%, 0.06% and 0.16% of the measured ones.
  Every one is the callee of a call (`results/final/reads-*.txt`, the lines
  `an identity decides`, each with `consumer=call`): 11 identifiers and 3
  members on `sqlite3.c`; 42 identifiers on Lua, 41 of them one macro's call
  (`zgetc`'s `luaZ_fill`, `lzio.h:20`); 202 identifiers, 2 members, a
  dereference and a cast on musl, 17 of them at `libm.h:163`. None is of a
  builtin type. C asks whether every parameter of the callee's function type
  is a plain scalar before it takes the call (`node_machine_classify_call`):
  a fact of the type that neither its word nor its row's facts hold. The
  census sees it only where the callee's other type differs in it. C asks it
  of every call it takes (`node_machine_classify_call` is its one path for a
  call): the windows have 13,323, 4,047 and 5,348 calls, 4.6%, 5.5% and 4.1%
  of their records, over the 2% line. The consequence the claim gave that
  line (the lanes would have to carry wide values) does not follow: it is
  one bit of a function type, and a call is a lookup that loads its callee's
  type's row.

## What the counts can't say

- **The records it left.** A consumer the kernel left to T, and a call T
  types by its action, leave their operands' reads unknown: 2,324, 2,279 and
  3,392 records are not measured. No expression was past the 256 records C
  and X are run again on.
- **One other type.** A type's identity is changed to one type of its word.
  Two types that give a reader the same answer hide the read (two records
  with the same member at the same offset, as the fixture's first form had;
  two function types whose parameters are all plain scalars, as nearly every
  callee's other type is). musl's units are small: 535 of its measured
  records have a type with no other of its word in the unit, whose identity
  can't be changed. For C and X the readers' own code bounds what this
  hides: they query the type table by a type's identity at nine places, for
  four things. A pointer's stride (`check_action_pointer_stride`, three
  places): the census sees it as a carried value. The kind of a member
  access's record (`type_kind`, two places): the row's facts already hold
  it, so no other type of the word differs in it. A segment override
  (`check_lower_segment_override`): no corpus has one. And a callee's
  parameters (`type_parameters`): the 262 records above.
- **Upper bounds.** A change that takes a record out of its rule's reach
  counts as a decision. A wide value that only a type of another word changes
  counts as the type's identity's read. A byte-level answer of a consumer's
  record counts whether or not anybody reads that byte.
- **The tests are a fourth reader**, which the census doesn't run:
  [buster#2524's note](https://github.com/buster14a/buster/issues/2850#issuecomment-6912816238)
  has what they read of T's record. Nor does it run a statement's own checks
  of its expression's value.
- **These windows.** The counts are of the expressions the machine takes
  (98.9%, 94.3% and 91.1% of the evaluated nodes), with the default warnings.

## The fact words' two passes (buster#2872)

The kernel's figure is a timed pass over a unit's windows (each window's
given records put in place, then the kernel) less a second pass that only
puts the given records in place.
[buster#2872](https://github.com/buster14a/buster/issues/2872) found the
second pass 10% dearer in one build (`z3`) than in another (`w2`) with the
same kernel on musl, and the figure 13% to 30% lower. The command now prints
both passes apart.

Cycles a record of the windows on musl (1,336 units, 97 records a unit's
pass), the fact words' kernel whole, a body a window; three runs each, the
least of five passes a run:

| build | the first pass | its ticks | the second pass | the figure, a taken leaf or lookup |
| --- | ---: | ---: | ---: | ---: |
| `w2t`: main `be6515fba`, `w2`'s patch and the line | 20.15, 20.11, 20.11 | 12.26, 12.16, 12.16 | 11.42, 11.41, 11.41 | 16.19, 16.13, 16.15 |
| `z3t`: the same main, `z3`'s patch and the line | 20.03, 19.92, 19.93 | 12.04, 12.06, 12.04 | 11.56, 11.46, 11.44 | 15.71, 15.70, 15.74 |
| `two`: main `3d0d56ed7` and the line | 20.31, 20.32, 20.29 | 12.37, 12.31, 12.29 | 11.43, 11.43, 11.43 | 16.46, 16.48, 16.44 |
| `final`: the same main, the pull request | 20.44, 20.69, 20.58 | 12.41, 12.59, 12.50 | 11.45, 11.46, 11.46 | 16.67, 17.11, 16.92 |

- **The first pass's figure is within 2% in two builds of one kernel:**
  20.11 and 19.93 in `w2t` and `z3t` (0.9%), 20.31 and 20.58 in `two` and
  `final` (1.3%). With the operators' kernel `two` and `final` read 39.30 and
  39.32.
- **The nine added lines moved the constant again.** The issue's `z3` read
  12.57 cycles a record in the second pass against `w2`'s 11.41; rebuilt
  with the line, `z3t` reads 11.46. So these four builds don't show the
  second pass 10% apart, and the check that it can be is the issue's own:
  both passes' sum within 0.3% in `w2` and `z3` while the figure moved 13%.
- **The figure still moves more than the first pass**: 2.8% between `w2t`
  and `z3t` (16.15 and 15.71), where the first pass moves 0.9%.
- **On `sqlite3.c`**, one unit, the second pass moves from run to run (9.42
  to 10.33 cycles a record in `two`'s and `final`'s twelve runs, 9%) and the
  first pass less (23.76 to 24.45 for the kernel whole, 3%; 43.08 to 43.94
  with the operators, 2%): `results/*/passes-sqlite3-*.txt`.

What the 120 cycles a unit's pass are was not looked for: it is the issue's
open question.

## The whole compile, and the kernels

Nothing here is in a compile. `-c sqlite3.c` as whole processes, main
`3d0d56ed7` (`main`) against the pull request (`final`), in a Williams order
(`scripts/compile.sh`; `results/final/compile-1.txt`, `compile-2.txt`; 21
runs a build, twice): the same instructions but for 862 of 1,363.6 M fewer
in `final` (medians 1,363,597,471 and 1,363,596,609); wall time -0.03% and
+0.31%, where `main` against itself reads +0.13% and +0.08%; user cycles
+0.16% and +0.39%, against +0.20% and +0.18%. The second comparison ran
while another session's jobs were waiting for the lock between its runs.

The fact words' kernels' own figures on `final` are in the table of "The
fact words' two passes" (musl) and `results/final/passes-*.txt`: T whole from
the fact words is 38.26 and 33.13 cycles an evaluated node on `sqlite3.c`
and musl (medians of three; 38.18 and 33.13 in `two`), where the first
piece's record has 37.7 to 38.6 and 32.6 to 33.8.

## The versions the 9700X ran

The census changed three times after its first run there. Each build's
census is kept, since the differences are the record of what was wrong:

| build | patch against main `3d0d56ed7` | what its census did |
| --- | --- | --- |
| `reads` | `patches/reads.patch` | a payload's source by what its rule does, a change counted as computed where it decided; payloads changed to any value. It read 7.75%, 26.02% and 8.70% of the operators as new: a conversion of an `int` constant counted as computed, because the rule takes an `int` operand's 2^40 + 5 as an `int`. |
| `reads3` | `patches/reads3.patch` | payloads changed to values their type holds; the changes that decide left out of the copy's test; a conversion that copies where the value fits told from a fold; a type's other self the one of its word that differs most; `&x` of a volatile object's type found in the pointer type's own row. 5.41%, 24.24%, 6.12%. |
| `final` | `patches/final.patch` | `reads3`'s census with the list's lines extended (the presumed file, the consumer's operator, the types' indexes) and the tests' fixture's last lines. The same counts as `reads3` (`scripts/summary.py`'s tables are the same line for line). It is the pull request's `src` and `tools` but for two pinned counts of the tests' fixture and their comment, added after it: test data. |

Before the 9700X, in the cloud container on `sqlite3.c`, the first form read
4.4% of the operators as new: it took a payload that equals an operand's for
a copy, which a fold's can be by its value alone (`1 << 0`).

## The check, and its mutants

`test-checker` runs the fixture `node_reads_test_text` by the census at two
window settings (the kernel's own cut, and 16 records a window) and pins the
records by kind and class, by field read and new, and by reader; the reads
the fixture is there for; each read field's source; and the records the
census leaves. `mutations/` has each single change of
`c_check_node_machine_reads.c` built (Debug) and run on the fixture as a file
and by the tests (`scripts/mutate5.py`, `scripts/reads_mutations.py`;
`mutations/mutate5.txt`), in the cloud container:

- **48 single changes; 44 fail the tests or the census's own check.**
- **Run 1** (`mutations/run-1.txt`): 47 of them, on the census as the pull
  request has it and the fixture as it then was. 39 fail the tests, at both
  window settings. One of them (an operand's record not put back after a
  change) also trips the census's own check on the fixture: 189 runs with
  nothing changed differ.
- **Eight didn't show. Four were the fixture's or its pins' gaps**, closed
  since:
  - a type of another word never tried: no count of a type's word's reads
    was pinned;
  - a conversion's flags never changed: nor one of a conversion's flags;
  - an identity C decides on not counted: the fixture had none. It now
    declares a function whose parameter is a struct, which nothing calls: it
    is the other type of the called function's type, and the two calls'
    callees are the records C decides on an identity of. That is the read
    the corpora show for 262 records;
  - a row's type counted as new: the fixture's one subscript's conversion's
    type was also the pointer to its index's type. A subscript of an array
    of long is not.
- **Run 2** (`run-2.txt`): the eight again with the new pins, and one more
  mutant (a record's payload not put back after a change in the sweeps),
  which trips the census's own check for C and X (15 runs differ). **Run 3**
  (`run-3.txt`): the row's type's mutant after the subscript was added.
  **Run 4** (`run-4.txt`): the stale word's mutant after two more pins.
- **Four don't show**, each for a reason:
  - *a consumer's record not put back after a change*: the rule writes its
    whole record at the next change, and the run after the last change puts
    the kept one back. The line is redundant.
  - *a record's word left stale when its type changes*: every rule the
    fixture runs that reads its operand's word also reads the type's row,
    which changes with the type. The line keeps a changed record consistent.
  - *the sweeps with nothing changed not compared*: it removes a check
    that nothing trips while the census is right. The two "not put back"
    mutants show that the checks trip when it isn't.
  - *a payload's change that decides counted in the copy's test*: no line of
    the fixture has a payload whose change decides for a consumer whose own
    payload is read. On `sqlite3.c` it moves one record (a `&&`'s payload
    from a copy to new) and three between a fold and a copy where it fits;
    on Lua none.
- The runner leaves the last mutant's build as `build/compiler`: every run
  above was followed by a rebuild.

## Files

- `results/final`: the pull request's build (`build.log`, `revision.txt`,
  `compiler.sha256`), the census on the three corpora (`reads-*.txt`,
  `summary.txt`), the two passes' runs (`passes-*.txt`) and the whole
  compile's comparison (`compile-*.txt`).
- `results/main`: main `3d0d56ed7` as it is, the whole compile's base.
- `results/two`: main with the two passes' line alone, and its runs.
- `results/w2t`, `results/z3t`: the two builds buster#2872 names, with the
  line, and their runs on musl.
- `results/reads`, `results/reads3`: the earlier censuses, with their
  patches.
- `patches`: each build's patch, and `pull-request.patch`, the pull
  request's `src` and `tools` against main `3d0d56ed7` (`final.patch` and
  two pinned counts of the tests' fixture).
- `scripts`: the 9700X's scripts (`setup.sh`, `lock.sh`, `corpora.sh`,
  `build-label.sh`, `reads.sh`, `passes.sh`, `two-run.sh`, `named.sh`,
  `branch.sh`, `compile.sh`, `final.sh`), `summary.py`, the cloud
  container's `local-checks.sh`, and the mutants' runner and list.
- `results/local`: the cloud container's checks of the pull request's
  build (the kernels' variants and the census on the compiler's own source,
  `sqlite3.c` and Lua; its copies of the corpora are not the 9700X's, and
  `sqlite3.c`'s counts differ by 42 records).
- `mutations`: the mutants' runs.
