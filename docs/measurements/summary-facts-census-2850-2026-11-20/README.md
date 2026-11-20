# A census of a summary node's side facts (buster#2850, the flip's first piece), 2026-11-20

The node machine's step 2 ([buster#2524](https://github.com/buster14a/buster/issues/2524), under
[buster#2850](https://github.com/buster14a/buster/issues/2850)'s claim) puts one summary node in the graph where a
taken expression's nodes were. Every pass that reads below a full expression's root then needs its answer from the
summary's side record, or must be shown not to read there. This is the count before that piece's specification: which
passes read below a root in today's code, and, for every expression the window takes whole, what the program's own
walks say of its root beside what the window's bytes say. Counts, no timing. Nothing here is in a compile.

- **The tree:** buster `0dbba56f8` (pull request buster14a/buster#3199's head) with `census-f.patch`, an experiment's
  patch that is not for a commit. A Develop build in the cloud container.
- **The run** (`run.sh`): `BUSTER_CENSUS_F=1 build/compiler measure-node-machine --shadow --passes 0 --window-rows
  --list 20` on `sqlite3.c`, Lua 5.4.8's 34 files, musl's 1,336 units and the compiler's own source (`main.c` of the
  same tree). `out/shadow-*.txt` are the runs' own reports, which the patch does not change: no difference.
- **The lines** (`lines/*.tsv.xz`), tab-separated:
  - `fw`, an expression whose tape the window makes whole, at reader time: its root's node, its root's and its
    operand's records, its records' count and its root's token;
  - `fr`, a record of it: its place in the expression and in the window, its operator, its flags' byte (4 an object,
    8 a name's symbol), its value (its object's number where it has one), whether it is evaluated, its template, its
    standing, its class, its two operands' distances, its subtree's records, its token, its consumer's distance and
    its place there, a call's callee's facts (1 declared noreturn, 2 a library name the return flow leaves unknown, 4
    a declared function's name) and its line's value flags (0x80 a static object);
  - `fu`, the unit, after its expressions and before its answers;
  - `fo`, the program's answers for a root after the pipeline ran: its control's kind (255 none), its operator, its
    return fact (`check_program_return_facts`: 1 a stop, 2 an unknown), whether `check_program_branch_truth` knows its
    truth and the truth, its value's constant's kind, whether it is of an integer type, its flags, whether
    `check_action_truth` knows its truth and the truth, its operand's operator and type's kind, whether a control
    names it, and its references: `check_program_references` run on the root alone.
- **The counts:** `python3 census-f.py lines/sqlite.tsv.xz lines/lua.tsv.xz lines/musl.tsv.xz lines/main.tsv.xz`
  (`out/census.txt`), and `python3 census-f-table.py out/census.txt` (`out/table.md`).

## The readers of an expression's inside (`readers-survey.md`)

A survey of today's code (buster `0dbba56f8`) by a subagent of the session, with a file and a line for each claim: the
passes that read graph nodes below a body's full expression's root after the reader, when each runs, what it reads
there and who reads its output. The session read these itself, against the code: `check_program_references`,
`check_program_return_facts` and its reduction, `check_program_branch_truth`, `check_program_runtime_truth`,
`check_control_fold_truth` and `check_control_foldable`. The rest is the survey's, as it reports it.

What it says a summary node has to answer in a compile with the default warnings:

| reader | when | what it reads below a root | code generation |
| --- | --- | --- | --- |
| `check_program_references` | every body | the static objects its leaves name; a sorted set, no order | yes |
| the controls' fold (`check_control_fold_truth`, `check_control_foldable`) | every `if` and `switch` | the root's constant value; the subtree only where it is one (a comma's left operand that is no constant says no) | yes |
| the initializer planner (`check_initializers_run_events`) | every unit | the source's node, the greatest of its tokens' | yes |
| the lowering (`check_lower_expression`) and its rooms | every lowered body | everything; the rooms are counted by the graph's nodes | yes |
| the return flow (`check_program_return_facts`) | `-Wreturn-type`, on by default | each call's callee, joined up the tree | no |
| `check_program_branch_truth` | the return flow and the warnings' reach | a condition's known truth, through `!`, conversions and `&&` and `\|\|` | no |
| `-Wswitch` | on by default | the selector's type, by its first token's node | no |
| the default-on warning passes (unsequenced, ignored results, the warning graph, parentheses, formats and others) | every unit | subtrees; a taken expression has none of their warnings by its silence tests | no |

And only with an option or a construct a taken expression's unit may have: the uninitialized scan and
`-Wunused-but-set-parameter` (`-Wall`, `-Wextra`), `-Wfor-loop-analysis` (`-Wall`), the target features' check (a
target attribute, an x86 builtin or a vector wider than 16 bytes in the unit), the symbol pragmas' walk
(`redefine_extname` after a use, a late weak declaration), the candidates' scan (three flags), `musttail`, and `-g`'s
rows (an entry's token).

## What the program says of a taken root, and what the window's bytes say (`out/table.md`)

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions the window takes whole; their records | 49,845; 278,892 | 10,248; 70,873 | 40,444; 204,846 | 41,890; 238,831 |
| by their control: a statement's; a condition's; a return's; an initialization's; a switch's; none | 30,180; 11,905; 3,832; 3,807; 70; 51 | 5,765; 1,537; 1,182; 1,666; 85; 13 | 14,690; 7,206; 12,206; 5,329; 115; 898 | 18,062; 8,218; 1,940; 13,625; 27; 18 |
| **the references the program's walk makes of them** | **14,506** | **4,920** | **9,396** | **13,365** |
| expressions with none; one; two; three or more | 36,878; 11,618; 1,204; 145 | 6,365; 3,044; 717; 122 | 32,311; 7,231; 750; 152 | 31,897; 7,532; 1,812; 649 |
| leaves with an object; of them with a static object or a name's symbol; of those not evaluated | 91,365; 14,638; 12,775 | 21,452; 4,961; 4,052 | 76,316; 10,254; 8,425 | 85,842; 13,559; 10,027 |
| **expressions whose references are those leaves' objects; references missing; extra** | **49,845**; 0; 0 | **10,248**; 0; 0 | **40,444**; 0; 0 | **41,890**; 0; 0 |
| the same by a name's symbol alone: missing (a string literal's object) | 1,115 | 761 | 292 | 2,545 |
| the same by the static flag alone: missing | 0 | 0 | 0 | 124 |
| calls; through a value (no declared function's name) | 12,724; 252 | 4,022; 15 | 7,943; 65 | 9,637; 9 |
| expressions with a call of a function declared noreturn | 0 | 112 | 21 | 30 |
| the root's return fact: none; a stop; an unknown; both | 49,595; 0; 250; 0 | 10,121; 112; 15; 0 | 40,362; 18; 61; 3 | 41,845; 30; 15; 0 |
| **expressions whose fact the flow's rule gives on the window's records** | **49,845** | **10,248** | **40,444** | **41,890** |
| the same by "an unknown where a call is through a value" alone | 49,845 | 10,136 | 40,422 | 41,854 |
| conditions; with a known truth; of them by a constant value; by one operand of an `&&` or an `\|\|` alone | 11,905; 53; 53; 0 | 1,537; 0; 0; 0 | 7,206; 239; 237; 2 | 8,218; 1; 1; 0 |
| roots with a constant integer value and no effect; of them with a comma | 3,028; 0 | 550; 0 | 1,643; 0 | 5,631; 0 |
| switch selectors; of them of an enumeration's type | 70; 0 | 85; 20 | 115; 3 | 27; 6 |

What the counts say:

- **The references are a mask.** The program's walk makes a taken expression's references of exactly its leaves
  with an object that is static (the value's flag) or has a name's symbol, evaluated or not: on the four inputs no
  reference is missing and none is extra. Most such leaves are not evaluated (a direct call's callee, a folded
  address's name), so the mask is no evaluated record's. A name's symbol alone misses the string literals; the static
  flag alone misses 124 names of the compiler's own source.
- **The return fact is the flow's rule on the window's records.** A call's own fact is its callee's leaf's: none for
  a declared function's name, a stop where that function is declared noreturn, an unknown for a call through a value.
  The facts join up the tree, and an `&&`, an `||` or a `?:` keeps its condition's, an unknown of either arm and a
  stop of both arms. Simulated over the records with each record's consumer and place, it gives every taken
  expression's fact. No call of these expressions is of a library name the flow leaves unknown by its name.
- **A condition's truth is its value's, but for two expressions.** The warnings' reach and the return flow ask a
  condition's truth through `!`, conversions and the operands of `&&` and `||`; for a taken condition it is known
  exactly where the root's value is a constant, except two of musl's (`prlimit.c`), where one operand of an `&&`
  decides it.
- **A constant root always folds.** The controls drop an arm where a condition's value is an integer constant with
  no effect and nothing in it keeps the evaluator from folding; for a taken expression that is a comma whose left
  operand is no constant, and no taken constant root has a comma (the window lists a folded comma).
- **`-Wswitch` needs a selector's own type** where it is an enumeration's: 0, 20, 3 and 6 taken selectors.
