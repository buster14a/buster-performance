# A null pointer constant that is no literal, and a constant read from a storage that isn't its own (buster#3012, #3014, #3017): 2026-11-19

Three defects in the node machine's tests (buster14a/buster#2850's step 2), found by running statements one at a time
for [the call piece](../a-call-on-the-window-2850-2026-11-19) and fixed in one pull request, buster14a/buster#3023. Each was in
the shadow alone (`measure-node-machine --shadow`): no compile takes the tests' verdicts. No corpus has a case of any
of them, and no fixture had one. [The plan](https://github.com/buster14a/buster/issues/3012#issuecomment-7006306087)
was on #3012 before the code.

- **#3012:** the reader-time tests took a zero that is no literal `0` as a null pointer constant
  (`-Wnon-literal-null-conversion`, on by default): an enumerator and every cast in `=` and `return`, and every form as
  a scalar's initializer and as a call's argument.
- **#3017:** the reference took some of them too. The compiler puts the warning at its source's first token, which is
  no node's where it is a parenthesis, `_Generic` or `__builtin_choose_expr`, and a scalar's initializer's root is the
  bare expression: the census after the pipeline missed the event of 24 of the 42 initializer forms that warn.
- **#3014:** the fold of a floating constant to an integer leaves the floating storage, and T's record kept the one
  storage that is not zero: `(int)0.5` was an integer constant whose payload and exponent were the floating value's.
  The tests' sweep read that exponent as the value, and the kernel's operand made a value anew from it where T's
  action carries the storage on.

The code: main `bc66290c5` with `patches/contexts-null2.patch` is what the 9700X built (`null2`); the pull request's
head `dbd7335e9` is the same sources on main `a847fd0e6`. `call8` is the call piece's code on main `bc66290c5`, the
build before.

## 1. One statement at a time (`probes/`)

`probe4.py COMPILER LIST` puts each line's statement alone in a function and runs it through the shadow with
`--window-contexts --verify`; `warns.py COMPILER LIST` asks the compiler and clang 23.1.6 whether each warns.
`count.py` and `count2.py` make the counts below from the outputs. `*-before.txt` is buster14a/buster#3016's head
`1106f2dad`, `*-after.txt` the pull request's code.

**`null2.txt`:** 59 sources of a zero in five places (`ip = X;`, `int* np = X;`, `fp(X);`, `f2(a, X);`, `return X;`
of a function that returns `char*`): 295 statements, of which the checker rejects 42. The compiler and clang agree on
every one (`null2-warns.txt`): 210 warn (the same 42 sources in each place), 42 are rejected, 43 neither.

| of the 253 accepted | before | after |
| --- | ---: | ---: |
| end with a take the census refuses | 136 | 0 |
| end with a said value that is not its payload's | 2 | 0 |
| warned initializers whose event the reference has | 18 of 42 | 42 |
| warned statements the reader-time tests refuse | 32 | 190 |
| refused without the compiler's warning | 0 | 0 |

Before, the tests refused the 16 sources that are neither a leaf nor a cast, under `=` and `return` alone
(`count2.py` lists them). After, the same 38 sources in each place. The other four are no expression the reader
reads: its front leaves a character constant (`'\0'`) and a `sizeof`, and the set has no `_Generic` and no
`__builtin_choose_expr`.

**`null3.txt`:** 72 statements with a constant folded from a floating one (`(int)0.5`, `(int)1e-4900L`,
`(long)0.5`) under each operator: an operand of the arithmetic, shift, bitwise, comparison, logical and conditional
operators and of their compound forms, a pointer's addend and index, a cast's operand, an argument, and a null
pointer assigned, compared and passed on. The checker rejects one. The compiler and clang agree on the null
conversion's warning on every one (`null3-warns.txt`).

| of the 71 accepted | before | after |
| --- | ---: | ---: |
| end with a status: a said value that is not its payload's | 71 | 0 |
| of them, a record the kernel made otherwise than T | 8 | 0 |
| of them, an operator the sweep left out where the census has a test | 2 | 0 |
| of them, a take the census refuses | 9 | 0 |

`null3-warns.txt` has one line where the compiler's warnings are not clang's, in neither build's reach:
`a /= (int)1e-4900L;`, of which clang says a division by zero and the compiler nothing. The compiler has the warning
for `/` and `%` and not for `/=` and `%=`: buster14a/buster#3020.

**`null4.txt`:** 13 statements that try for an integer constant with an offset's storage and no integer
(`(long)&((struct pair*)0)->second - 8` and the like). None ends with a status: the reader-time tests refuse 11 of
them, and of the other two one has a `sizeof`, which the reader's front leaves, and one a value the columns don't
hold whole, which C lists.

`null1.txt` is a first, shorter list.

## 2. The counts on the corpora (`cloud/`)

`cloud/final` is the checks' run on the pull request's sources (on main `9fb0ef02d`, `checks-call.sh`) in the cloud
container: the eight parts of `test-checker`; C on the window on `sqlite3.c`, Lua, musl and the compiler's own source
with the default warnings and with `-Wall -Wextra`; the shadow's eleven other modes on `sqlite3.c` and Lua; the
self-check, the self-parse and the call graph; the build's ownership check; and the complete driver's lists. Its one
failure, `complete-light`, is the cloud container's alone and the same in every run before the piece: the
preprocessor's comparison against clang there spells the compiler's include directory another way. `cloud/rebased` is
the build, the node machine's tests' part, the ownership check and C on the window on `sqlite3.c`, Lua and musl
again after the rebase on main `a847fd0e6`, which changed none of the piece's files.

`compare-counts.py DIR_A DIR_B` compares every `key=number` of two builds' outputs, a file a corpus and mode, and
leaves the tick figures out. `same-text-shadow` has the eight runs of C on the window to compare: `sqlite3.c`, Lua
and musl from the checks, and the compiler's own source at the call piece's text (main's has other pull requests'
changes since, so the checks' own two runs of it count another program). Against the call piece's eight and its 22
runs of the other modes (`before-modes` has those; the eight are in its own record),
`counts-against-the-call-piece.txt`:

- the `own tests` line has one key more, `initializers-asked-for-a-null-constant`;
- the arguments' rule's answers are 1,726, 1,393, 8,250 and 2,827 on `sqlite3.c`, Lua, musl and the compiler's own
  source for 1,669, 1,393, 8,209 and 2,664 (58, 6, 16 and 60 of them in the timed run for 52, 6, 10 and 40): the
  answers' key has the literal's flag;
- no other count differs: no call lost its quiet bit, no constant its said value, no initializer an event, no
  expression its verdict.

## 3. The faults (`faults/`)

One at a time in copies of the tree: a text of the new code replaced by a faulty one, the Debug compiler built, the
node machine's tests' part run, and for a fault the tests don't catch the statements of `null2.txt` and `null3.txt`
again, each line against the base's (`faultsN.py`, `runN.sh`; `roundN-all.txt` has each round's lines).

| round | on | faults | caught | survived | not built |
| --- | --- | ---: | ---: | ---: | ---: |
| 1 | the first complete form | 76 | 43 | 20 | 13 |
| 2 | with round 1's dead terms out and its lines added | 38 | 31 | 7 | 0 |
| 3 | the initializers' roots asked, counted | 6 | 6 | 0 | 0 |
| 4 | **the pull request's sources**, every earlier fault whose text is still there and the writer's rule's | 43 | 37 | 6 | 0 |

Round 4's six (`final-verdicts-4.txt`):

| fault | class | what makes it so |
| --- | --- | --- |
| `tests-store-own-type` | no statement separates it | an assignment's own type is its source's conversion's type on every statement, an atomic destination's too (`ap = A0;` is in the fixture) |
| `tests-no-initialize-node` | no statement separates it | no initialization's node is in an expression the tests read: the reader's root for one is its operand, and its conversion is in the initializer's plan (which the root's own test asks) |
| `line-old-rule` | no statement separates it | the front's line of a leaf's value asks the columns' rule of a literal's value or a static object's address (`node_facts_value_line`'s two callers), which has its own storage alone |
| `low-from-the-name`, `low-two-past-the-name` | the same answer | the initializer's span's low end a token either way: no kept event is at an object's name or at its `=` |
| `kernel-warned-rvalues-constant` | a program the checker rejects | the raw standing's kind for the operand's: they differ for an lvalue's constant that is no integer constant expression, and `const int z = 0; np(z);` to a pointer's parameter is an error |

With the writer's rule taken out (`whole-old-rule`), the default warnings' fixture shows what #3014 found: the tests
on the window differ from the census's code on 2 expressions, 2 operators left out for their constants have a test,
and 14 of the 267 said values are not their payloads'.

What the rounds changed: five terms out as dead, each a guard the compiler's own test has or one no record reaches;
the count of the initializers' roots asked, pinned, which made two pre-filters' faults caught; the warning of the
event that refuses an expression, in the census's record, so that a fixture's `// refuse: warning-event` line asks
for an event; lines for an atomic pointer, a pointer's first parameter and a for statement's clauses; and, after
section 4's switch, the writer's rule in place of the two readers' terms.

## 4. The 9700X (`9700x/`)

CPU 2, Release, each run its own hold of the lock, the two builds in turn in each reading, each from a fresh copy of
its compiler a reading (`job-call-final.sh`, `turns.sh`, `build-label.sh` and `compile.sh` are [the call
piece's](../a-call-on-the-window-2850-2026-11-19/9700x/scripts) and the tests on the window's). TSC ticks a record,
medians of 7 readings on `sqlite3.c` and Lua and 15 on musl.

### The first form: two readers' terms (`null1`, `docgen-null1.txt`)

For #3014 the first form kept T's record as it was and gave its two readers a term each: a mask in the tests' sweep
over the records whose payload is a floating value's, and a test of each operand in the kernel's rule and in its
updates' loop (`patches/contexts-null1.patch`).

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the kernel in place: before, with | 17.48, 17.47 | 22.45, 22.61 | 20.35, 20.59 |
| the tests on the window, C off: before, with | 31.1, 31.5 | 49.1, 50.1 | 95.3, 95.8 |
| the tests' bytes alone: before, with | 9.19, 9.27 | 10.83, 10.90 | 19.62, 20.30 |

### One executable, the terms on and off (`null1x`, `docgen-null1x.txt`)

Two builds' figures differ by their code's place too (the call piece's record has two controls of it), so the terms
were given a switch: `patches/knob-only.patch` on `null1`, an experiment's build that reads `BUSTER_TESTS_SKIP` once
(1 the tests' own form's asks, 2 the sweep's mask, 4 the kernel's terms). `scripts/job-null-knob.sh` runs the one
executable with 0 and with 7 in an on, off, off, on order inside each of seven readings; `scripts/docgen-knob.py`
makes the table. The outputs with the terms off are exact too, as no corpus has a case.

| the terms on, off | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the tests on the window, C off | 31.45, 31.36 | 50.14, 50.03 | 96.87, 100.97 |
| each reading's own difference | +0.11 (-0.09 to +0.33) | +0.34 (-1.71 to +1.96) | -2.98 (-8.44 to +3.18) |
| the tests' bytes alone | 9.30, 9.27 | 10.99, 10.98 | 19.16, 19.19 |
| each reading's own difference | +0.02 (-0.06 to +0.09) | +0.01 (-1.05 to +0.10) | +0.02 (-0.30 to +0.69) |
| the kernel in place | 17.51, 17.50 | 22.70, 22.45 | 20.45, 20.46 |
| each reading's own difference | +0.02 (-0.08 to +0.07) | **+0.27 (+0.06 to +3.15)** | +0.03 (-2.38 to +0.24) |
| C's three sweeps, a record of the decided | 8.11, 8.14 | 11.52, 11.55 | 27.80, 27.49 |

- The tests on the window's 0.4 and 1.0 between the two builds are not the terms': in one executable they read 0.11
  and 0.34, with readings on both sides of zero.
- **The kernel's term costs on Lua:** 0.27 ticks a record in every one of seven readings. The operand's test compiles
  to no branch but to some eight instructions an operand (`shr`, `and`, `cmp`, `setne`, `test`, `sete`, `or`, `and`),
  in the rule and in the updates' loop: in the cloud container's builds `node_facts_slow` grew by 691 bytes and
  `node_facts_updates` by 140 against the call piece's, and the short paths' functions (`node_facts_window`,
  `node_facts_stores`, `node_facts_casts`, `node_facts_converts`) by none. The rule makes 12.2% of the records the
  kernel makes on Lua (7,700 of 62,855), 2.8% on `sqlite3.c` (6,882 of 247,906) and 3.2% on musl (6,101 of 191,502).

### The pull request's code: the writer's rule (`null2`, `docgen-null2.txt`)

So the rule went to where the record is written: T writes a value into its columns where they hold it whole, and an
integer constant's storage must be its integer (`node_machine_whole`). One folded from a floating constant is a wide
value, which says none, whose consumers the kernel leaves to the rule and whose expression C on the window lists.
The sweep's and the kernel's operand's code are the call piece's again: `node_facts_slow`, `node_facts_updates`,
`node_facts_window` and `node_facts_stores` have its sizes to the byte in the cloud container's builds, and what grew
is the calls' second pass (`node_facts_argument_fill` by 147 bytes, `node_facts_calls` by 16, `node_facts_calls_lean`
by 8), which has #3012's bit.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| **the kernel in place: before, with** | **17.39, 17.38** | **22.35, 22.41** | **20.49, 20.38** |
| each reading's own difference | -0.02 (-0.15 to 0.16) | 0.03 (-0.24 to 0.18) | 0.02 (-1.80 to 3.54) |
| the same two with C off | 17.52, 17.54 | 22.34, 22.43 | 20.37, 20.39 |
| C's three sweeps, a record of the decided: before, with | 8.27, 8.07 | 11.62, 11.62 | 25.77, 25.96 |
| the reference's C on the same expressions: before, with | 38.1, 38.7 | 36.9, 37.3 | 40.8, 41.8 |
| the records' bytes with C's columns: before, with | 9.97, 9.94 | 12.01, 12.03 | 22.09, 22.20 |
| the tests' bytes alone: before, with | 9.16, 9.25 | 10.82, 10.88 | 20.42, 19.17 |
| the tests on the window, C off: before, with | 31.3, 31.3 | 50.1, 49.8 | 99.9, 100.3 |
| the front with the window: before, with | 53.2, 53.1 | 71.7, 70.7 | 89.6, 91.5 |
| the arguments' rule's answers, of them in the timed run | 1723, 58 | 1378, 6 | 8250, 16 |

`-c sqlite3.c`, which runs none of it, as whole processes: wall +0.16% (the base again -0.08%) and user cycles +0.23%
(-0.01%) in one comparison, +0.09% (+0.05%) and +0.04% (+0.11%) in the other.

The fixtures' counts say what moved: six expressions of the default warnings' fixture and three of C on the window's
with such a constant are listed as a value the columns don't hold whole where the first form decided them, and
three calls with one as an argument are listed for it and no longer left for an argument.

## 5. The storages a fold leaves (`experiments/census`), and other warnings at an initializer's parenthesis (`experiments/span`)

`census/apply.py TREE` puts counters into `node_machine_put_value` (an experiment's, never merged; `census.patch` is
what it makes of the pull request's code): how often T's writer is given a value of each constant kind with each of
its three storages no zero. With `measure-node-machine --shadow --passes 0` (`sqlite.txt`, `lua.txt`, `musl.txt`; a
kind is 0 none, 1 an integer, 2 a floating value, 3 an address):

| | `sqlite3.c` | Lua | musl (1,336 units) |
| --- | ---: | ---: | ---: |
| values T's writer is given | 7,153 | 3,306 | 9,042 |
| an address with a leftover integer | 66 | 0 | 82 |
| a floating constant with a leftover integer | 11 | 9 | 10 |
| no constant, an integer beside an offset or a floating value | 9, 3 | 0, 0 | 9, 3 |
| **an integer constant with a floating value or an offset** (#3014's) | **0** | **0** | **0** |

`forms.txt` is 22 one-line functions and `forms-results.txt` what each gives: `(double)5`, a `return 3;` of a
function that returns `float` and `(double)(1 << 4)` are floating constants with a leftover integer; `(char*)5` an
address with one; `(int)1.5` and `x + (int)2.5` integer constants with their integer and a leftover floating value
(two storages: wide before and after); and `(int)0.5` the integer constant with the leftover alone, which the pull
request's rule makes wide. buster14a/buster#3022 is the fold's own issue.

`span/w1.c` is ten scalar initializers that start with a parenthesis and have another warning than the null
constant's (a shift's count, a division by zero, a mix of enumerations, a pointer made an integer, a comma's left
operand, a pointer compared with an integer, two of precedence; two of the ten give none by default). The eight that
warn are refused at both times (`w1-final.txt`: 8 refused by the reader-time tests, 8 by the census, none taken
there that the census refuses): seven by tests of their own, one by its event, which is at a node's token. The one
place found that puts a warning at its source's first token is `check_warning_null_event` (a search of the checker's
sources for its `original_first`).

## 6. The sanitizers (`cloud/sanitizers`)

The rows a pull request's checks skip, on the pull request's sources (`sanitizers-native.sh`): memory, address and
thread, native. Each: a Release build as CI's rows build it and the node machine's tests' part; under memory and
address, C on the window on `sqlite3.c`, Lua and the compiler's own source. No report (`progress.txt`).
