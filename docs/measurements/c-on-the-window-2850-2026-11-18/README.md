# C on the window, first piece (buster#2850): 2026-11-18

buster14a/buster#2850's step 2: C's answers (each evaluated record's template, its context and its target, and
whether C refuses its expression) made on the window, 64 records a step, for the expressions with no call, no `&&`,
`||` or `?:`, no update and no comma. In the shadow alone (`measure-node-machine --shadow --window-contexts`): no
compile takes it. C on T's columns at reader time is its reference. [Its
specification](https://github.com/buster14a/buster/issues/2850#issuecomment-6983596165) was posted before its code,
and [the census](../c-answers-census-2850-2026-11-18) before that.

- 9700X: CPU 2, Release, each run its own hold of the lock, the two builds in turn in each reading, each from a fresh
  copy of its compiler a reading (`9700x/scripts/job-contexts.sh`; `turns.sh`, `build-label.sh` and `compile.sh` are
  [the tests on the window's](../window-tests-calls-2850-2026-11-18/scripts)).
- The base is main `521d5b63d` (`m6`). `cw1` to `cw10` are the piece on it, patches of `src` and `tools` against that
  commit (`patches/`). `cw10` is the pull request's code.
- `9700x/scripts/docgen.py RESULTS LABEL` makes each build's table from its readings.

## 1. The counts (`cloud/final`)

`cw10` in the cloud container on `sqlite3.c`, Lua, musl and the compiler's own source
(`--shadow --passes 0 --window-contexts --list 20`, and with `-Wall -Wextra`). Both give:

| | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| expressions the kernel placed and C ran on | 50,996 | 10,839 | 43,415 | 52,015 |
| decided on the window | 32,300 (63.34%) | 5,644 (52.07%) | 30,863 (71.09%) | 24,659 (47.41%) |
| their records | 138,609 | 32,054 | 111,599 | 98,719 |
| of them, refused for a template, as C refuses them | 124 | 144 | 1,631 | 817 |
| expressions that differ from C's, and records | 0, 0 | 0, 0 | 0, 0 | 0, 0 |
| listed: a call | 12,179 | 3,741 | 7,288 | 12,841 |
| `&&`, `\|\|` or `?:` | 2,267 | 334 | 1,034 | 8,866 |
| an update | 3,415 | 758 | 3,873 | 5,191 |
| a comma or a selection | 149 | 320 | 39 | 0 |
| a division by a constant | 160 | 38 | 243 | 405 |
| a value the columns don't hold whole | 526 | 4 | 75 | 53 |
| strides read (asked of the type table) | 6,965 (0) | 1,074 (0) | 3,850 (5) | 12,897 (0) |
| rules that read T's two conversions | 0 | 0 | 128 | 140 |
| consumers and first operands read by loads | 1,356 | 192 | 351 | 2,485 |

(The 9700X's `sqlite3.c` is another copy of the amalgamation: 50,993 expressions there, 32,300 decided.)

`cloud/final/checks-progress.txt` is the last run of the checks on the pushed sources: the eight parts of
`test-checker`, these eight shadow runs, the self-check, the self-parse, the call graph and the complete driver's
lists. Its one failure, `complete-light`, is the cloud container's alone and the same in every run before the piece:
the preprocessor's comparison against clang there spells the compiler's include directory another way.
`checks-before-the-last-edits-progress.txt` is the whole list (56 shadow runs, fourteen modes on four corpora) on
`cw9`'s sources.

## 2. The 9700X (`9700x/cw1` to `cw10`, `9700x/m6`)

Each job: seven readings on `sqlite3.c` and Lua and fifteen on musl of `m6 --window-tests`, the build
`--window-tests` and the build `--window-contexts` in turn; seven of `--front-window` for both; `-c sqlite3.c` as
whole processes, twice (`compile-1.txt`, `compile-2.txt`). TSC ticks, medians. The gate's figure is C's three sweeps
a record of the decided expressions, plus what the bytes' sweep costs with C's five columns over the same build
with C off, a record of the decided, each reading's own.

| build | what changed | C's sweeps, a record swept | the gate's figure on `sqlite3.c` | Lua | musl |
| --- | --- | ---: | ---: | ---: | ---: |
| `cw1` | the first | 6.77, 8.37, 14.06 | 17.24 (16.85 to 17.44) | 26.37 | 48.88 |
| `cw2` | the forward distance one store an operand in the front; the template's number as four masks | 6.19, 7.63, 12.05 | 15.96 (15.57 to 16.04) | 24.60 | 46.23 |
| `cw3` | the loop a function of its own, its frame aligned to 64 bytes | 5.96, 7.26, 11.07 | 15.25 (14.64 to 15.66) | 23.45 | 42.47 |
| `cw4` | `node_facts_window` at a cache line's first byte | 5.88, 7.32, 11.35 | 15.22 (14.65 to 15.97) | 23.58 | 45.56 |
| `cw5` | the bytes' sweep as two | 5.95, 7.22, 11.36 | 15.43 (14.76 to 15.85) | 23.38 | 44.62 |
| `cw6` | the terms the first fault round's survivors read as dead, removed | 5.51, 6.70, 10.28 | 13.66 (13.25 to 14.05) | 21.38 | 40.03 |
| `cw7` | each of C's terms; a rule on T's conversions; the vector's element's flag | 5.44, 6.83, 11.10 | 14.15 (13.69 to 14.65) | 21.89 | 41.36 |
| `cw8` | the rows' table 64 bytes read as one register; a name's template one mask less | 5.49, 6.85, 10.72 | 14.15 (13.92 to 14.71) | 22.04 | 40.89 |
| `cw9` | the conversions' rule without two arguments that were always true; the comparison's control | 5.54, 6.84, 11.47 | 14.24 (13.78 to 15.37) | 22.15 | 43.50 |
| `cw10` | the conversions' rule for the arithmetic conversions alone; a range's reset that did nothing, removed | 5.44, 6.77, 10.96 | 13.90 (13.78 to 14.53) | 22.00 | 43.88 |

`cw6` is not C's rule (section 4): its figure is of code that differs from C on programs none of the corpora has.

`cw10`, by part:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| C on the window, a record its sweeps ran over | 5.44 | 6.77 | 10.96 |
| of which the loop | 2.44 | 3.82 | 6.75 |
| the targets | 1.24 | 1.43 | 2.20 |
| an expression's part | 1.75 | 1.51 | 2.05 |
| the same three sweeps again over the chunk | 4.60 | 4.52 | 5.09 |
| of which the loop | 1.83 | 2.06 | 2.12 |
| the records' bytes with C's five columns, a record of the tests' | 9.95 | 11.86 | 21.81 |
| the tests' bytes alone: main | 9.30 | 10.79 | 19.03 |
| with the piece, C off | 9.19 | 10.81 | 19.97 |
| C's three sweeps, a record of the decided expressions | 12.6 | 19.3 | 37.0 |
| the reference's C on the same expressions | 40.2 | 36.2 | 43.0 |
| the tests on the window: main | 31.1 | 49.8 | 93.8 |
| with the piece, C off | 31.2 | 49.5 | 97.7 |
| the kernel in place: main | 16.0 | 20.6 | 18.9 |
| with the piece, C off | 16.0 | 20.6 | 19.0 |
| with C on | 16.3 | 20.6 | 18.9 |
| the front with the window: main | 53.2 | 70.7 | 89.4 |
| with the piece | 53.6 | 70.6 | 90.3 |

`-c sqlite3.c`, 21 processes a build a run: wall -0.03% (the base again -0.04%) and -0.01% (-0.08%); user cycles
+0.04% (+0.03%) and +0.05% (-0.05%).

musl's readings scatter from job to job: the tests on the window with the piece and C off, for main's, read 95.3 for
93.9 (`cw7`), 91.9 for 95.3 (`cw8`), 94.2 for 95.8 (`cw9`) and 97.7 for 93.8 (`cw10`).

## 3. What the builds found (`9700x/cw2`, `cw3`: `perf15-*.txt`)

- **`cw2`'s profile** (`perf15.sh`, cycles and cache misses by instruction inside `node_facts_reader_flush`, which
  the loop was part of): twenty 512-bit registers kept in a frame aligned to 16 bytes; 78 of the loop's 427 samples
  on those moves and 112 right after one. `cw3` made the loop a function with its frame aligned to 64 bytes: the
  loop 3.15 to 2.86 ticks a record swept on `sqlite3.c`. A tenth: the spills were not most of its cost.
- **`cw3` moved the fact words' kernel:** `node_facts_window` started 48 bytes into a cache line, and the kernel in
  place read 16.4 ticks a record with C off where main reads 16.0, with the same 736 instructions. `cw4` aligns
  the function to 64 bytes: 16.0.
- **`cw2` to `cw4` had one bytes' sweep with a test a step for C's columns:** the tests' bytes with C off read 9.57,
  9.48 and 9.47 on `sqlite3.c` for main's 9.34, 9.32 and 9.29 (11.53, 11.35, 11.35 for 10.80, 10.78, 10.77 on Lua;
  22.37, 20.85, 20.78 for 19.62, 19.07, 18.78 on musl). `cw5` makes two sweeps from one inlined body: 9.14 to 9.20
  for 9.25 to 9.33 on `sqlite3.c` in `cw5` to `cw10`; musl 0.1 to 1.1 over main's, whose own readings are 0.9 apart
  from job to job.
- **The kernel in place with C on** reads 16.3 to 16.8 on `sqlite3.c` in `cw2` to `cw10`, where the same executable
  with C off reads 16.0 to 16.4; Lua and musl read the same either way.

## 4. What exactness took (`fixture/`)

The first fault round (section 5) read its survivors as dead terms, and `cw6` removed them. `cw6` is exact on the
three corpora, the compiler's own source and the fixture it was built with (`9700x/cw6`: every reading's
`differences=0`). Reading C's rule (`node_machine_classify`) against the code that makes each record, with one
statement at a time through the shadow (`fixture/lines.py COMPILER - STATEMENTS`), found what no corpus has:

| statement | `cw6`'s rules | C |
| --- | --- | --- |
| `a = (int)(_Float16)d;` | a wrapper passes whatever its class | a half-precision class has no template: refused |
| `b = (_Atomic long)a + 1;` `(void)(_Atomic long)a;` | an atomic type's value has no template: refused | the rule is an lvalue's read alone; the cast's operand's target is the cast's own type, not T's conversion |
| `d = (__int128)b + d;` `a = d < (__int128)b;` and three more | an operand of a 128-bit class: no template | the operand is converted to the double: taken |

`fixture/mismatch-statements.txt` has them, `mismatch-sixth-build.out` the build with `cw6`'s rules
(`differences=1` on eight of nine) and `mismatch-seventh-build.out` `cw7` (none). A first correction then failed the
fixture the other way: with the wrapper's class's test alone, `return *o` of a struct differed, because T's record
of an aggregate has an address's class where its type's word has none.

The final rules: each of C's terms, but where what makes the records implies one, named in the file's comments.
An operand's own type stands for T's conversion of it wherever a value is converted as a value alone (an lvalue to
its value, an array or a function to a pointer: a type's class and facts are its value's already); where the usual
arithmetic conversions apply and the operands' own classes are not both a number's, the record's rule reads T's
two conversions (`node_contexts_converted`).

`fixture/every-statement.txt` is every statement probed, 282; `every-final.out` is `cw10` on them: 266 run, no
difference; 16 are files the checker rejects or the lowering can't lower, with or without the piece (a vector's
member, a cast to an atomic type assigned to a plain one, a stride of no size).

## 5. The faults (`faults/`)

One fault at a time in a copy of the tree: a text of the piece replaced, the Debug compiler built, `test-checker`'s
part with the node machine's tests run; for a fault the tests pass, the shadow on Lua, `sqlite3.c` and musl says
whether a corpus tells it from the code.

| round | on | faults | caught | survived | not built |
| --- | --- | ---: | ---: | ---: | ---: |
| 1 (`round1-faults.py`, `round1-results-*.txt`) | the first form | 93 | 42 | 35 | 16 |
| 2 (`faults2.py`, `results2-*.txt`) | `cw6`'s rules | 250 of 344, when the code was replaced | 217 | 31 | 2 |
| 3 (`faults3.py`, `results3a-*.txt`, `results3-*.txt`) | `cw7` | 251, and 140 caught in the second round on the same text (`round3-carried.txt`) | 167 | 77 | 7 |
| 4 (`faults4.py`, `results4-*.txt`) | `cw9` | 159: what the third left open, in forms that build, and what changed | 101 | 58 | 0 |
| 5 (`faults5.py`, `results5-*.txt`) | `cw9` and the fixture's next lines | 28 of 58, when the code changed once more | 3 | 25 | 0 |
| 6 (`faults6.py`, `results6-*.txt`) | `cw10`, the pushed sources | 49: what was open, and the conversions' rule as it is | 16 | 33 | 0 |
| 7 (`faults7.py`, `results7-*.txt`) | `cw10` | 6 whose text the last edits changed | 6 | 0 | 0 |

`final-tally.txt`: of the 380 faults of all rounds whose text is in the pushed sources, 347 were caught in the last
round that ran them on that text (22 in the sixth and seventh, 3 in the fifth, 89 in the fourth, 112 in the third,
121 in the second) and 33 survive. A corpus tells none of the 33 from the code.

**What the rounds changed.**

- The first round's survivors were read as dead terms and removed (`cw6`); they were not (section 4).
- Cases the fixture lacked, each now a line of it: a long double read for its address through a subscript, a
  dereference and a member, and for its value under a cast to void; a complex object's name and a constant of a
  `_BitInt`'s type under one; a long double's negation; a union's name; a shift, whose two conversions differ, and
  one by a 128-bit count; a pointer's sum with a 128-bit index; a condition whose root alone has no template; a
  folded comparison of constants no template takes, short and over more than two blocks; and 128 statements of
  seven and of five records, which put a block's end between every two of a statement's records in turn (the
  corpora told `next-classes-stale`, `next-codes-stale`, `target-first-conversion-only`, `part-root-refused-not`,
  `constant-shared`, `member-any` and `named-value-any-class` from the code where the fixture did not).
- The comparison itself was untested: a fault in it passed every test. The fixture now runs again with one of the
  reference's answers changed for each expression C takes (`BUSTER_NODE_READER_WINDOW_CONTEXTS_FAULT`), and the
  comparison has to count every one.
- Generality no test reached, removed: the rows' third and fourth places (the table is 64 bytes, one register); a
  local's template's own mask (a global's number is a local's and one bit); the conversions' rule's arguments and
  its branches for a truth and a subscript (their operands are converted as values alone, and a type's class is its
  value's already); a range's reset that did nothing.

**The 33 that survive,** by what they are:

| what | faults |
| --- | --- |
| how many records are read by loads, and no answer: `far-counts.txt` (`far-counts.py`) has four of them on the corpora: the same answers, and 1% to 123% more loads (`placed-all` 29%, 30% and 123% on Lua, `sqlite3.c` and musl) | `placed-all`, `far-up-unplaced-too`, `far-left-unplaced-too`, `consumers-room`, `asked-unplaced-too` |
| either reading is right, and the code's is the cheaper | `dead-ranges-of-leaves` (a leaf has no range), `row-none-second-dead` (the operands of a consumer with no template are read by no one) |
| the guard that lists a leaf C's rules give a template the loop doesn't make (void's, an address's that is no constant, one with an effect): no source reaches it | `void-type-none`, `odd-leaf-none`, `odd-leaf-void-not`, `odd-leaf-place-not`, `odd-leaf-effects-not`, `listed-odd-leaf-not`, `named-value-placed` |
| a term of C's own that what makes the records never separates: a name's leaf is an lvalue with an object | `named-value-rvalue-too`, `named-value-objectless` |
| no rvalue constant is read for its address, and a constant read for its address is an address's | `folds-rvalue-in-a-place`, `folds-any-placed` |
| a constant of float's or double's class has the floating kind | `floating-constant-all`, `takes-any-number` |
| two numbers' operator and a truth have a number's type | `binary-any-class`, `truth-any-class` |
| a truth's operand of void's type or of an aggregate's has no template itself, which refuses the expression either way | `testable-void-too`, `testable-aggregates-too` |
| T takes no expression of a unit with `FENV_ACCESS` on at reader time, so no record has the environment's flag | `bytes-effects-side-only` |
| the lowering refuses the file, and the shadow with it: a vector's member, a stride of no size | `member-vector-too`, `stride-row-always` |
| T's conversion of a unary operator's operand and of a stored value is the node's own type: either source gives the target | `row-unary-node`, `row-store-given`, `row-store-local-given`, `row-store-global-given` |
| a binary operator whose first conversion is of no number's class has no number's type, so its record is not asked | `converted-right-alone`, `converted-second-twice` |

## 6. The sanitizer rows, and the rebase (`cloud/final/sanitizers-progress.txt`, `cloud/rebased`)

The rows a pull request's checks skip, on the pushed sources (native host; memory, address, thread): the node
machine's tests' part of `test-checker`, and under memory and address C on the window on `sqlite3.c`, Lua and the
compiler's own source. Every status 0, no report.

The pull request's commit is `cw10`'s sources and the documents, rebased from `521d5b63d` onto main `0c113feb1`
(108 files of other work, one line of them in a file the piece touches). `cloud/rebased` is the rebased build on the
four corpora: the same counts, no difference. The 9700X's readings are of `cw10` on `521d5b63d`.
