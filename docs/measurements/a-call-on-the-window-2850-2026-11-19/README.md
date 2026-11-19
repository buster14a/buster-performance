# A call on the window (buster#2850): 2026-11-19

buster14a/buster#2850's step 2, the piece after [C on the window](../c-on-the-window-2850-2026-11-18): the kernel's
call rule makes each argument's conversion, and C's answers for a call (its template, its callee's and its arguments'
contexts and targets) are made on the window from them. In the shadow alone
(`measure-node-machine --shadow --window-contexts`): no compile takes it. T's records and conversions and C on T's
columns are its references. [Its first
specification](https://github.com/buster14a/buster/issues/2850#issuecomment-6994133464) rested on a sentence that was
wrong (the kernel's call rule made no argument's conversion); [the correction and the piece
respecified](https://github.com/buster14a/buster/issues/2850#issuecomment-6995139458), with its seven gates, were
posted before its code.

- 9700X: CPU 2, Release, each run its own hold of the lock, the two builds in turn in each reading, each from a fresh
  copy of its compiler a reading (`9700x/scripts/job-call.sh` and `job-call-final.sh`; `turns.sh`, `build-label.sh`
  and `compile.sh` are [the tests on the window's](../window-tests-calls-2850-2026-11-18/scripts)).
- `call1` to `call5` are the piece on `cw10`, C on the window's first piece on main `521d5b63d` (buster#3011 before it
  merged): patches of `src` against that commit (`patches/`). **`call8` is the pull request's code**, a patch on main
  `bc66290c5`, which has #3011, read against `m7`, that main (`job-call-final2.sh` built `m7`; its own job, on an
  earlier patch, was stopped while it waited for the lock and is not kept).
- `9700x/scripts/docgen-call.py RESULTS HEAD BASE` makes a build's table from its readings, and
  `counts-call.py SHADOW_DIR [record]` the counts' tables from the cloud's runs.

## 1. The arguments' census (`census/`)

Before any code: a line an argument of every call T types at reader time (`census-hook.patch`, an experiment's hook in
T's loop on main `521d5b63d`; `classify.py` makes `*-classified.txt` and `coverage.py` `*-coverage.txt`).

| | `sqlite3.c` | Lua | musl | own source |
| --- | ---: | ---: | ---: | ---: |
| calls | 16,016 | 4,213 | 7,967 | 16,985 |
| arguments | 42,623 | 10,017 | 21,027 | 43,628 |
| already the parameter's type, no constant | 66.4% | 67.7% | 63.6% | 59.6% |
| an integer constant of the parameter's type | 11.9% | 12.6% | 8.2% | 2.7% |
| an integer constant converted (a null pointer constant among them) | 4.8% | 2.4% | 7.1% | 12.5% |
| a pointer to another pointer type | 7.7% | 3.5% | 5.8% | 6.3% |
| an array or a function, to a pointer | 3.2% | 7.3% | 3.0% | 11.5% |
| an arithmetic conversion, no constant | 2.8% | 1.9% | 11.1% | 3.1% |
| past the parameters (the default promotions) | 3.0% | 4.6% | 0.8% | 4.2% |
| a floating constant | 5 | 3 | 41 | 6 |
| a value the columns don't hold whole | 77 | 0 | 5 | 1 |
| calls with every argument in the kernel's assignment cases (the estimate) | 99.3% | 96.0% | 98.5% | 81.2% |

## 2. The counts (`cloud/final`)

The pull request's code in the cloud container on `sqlite3.c`, Lua, musl and the compiler's own source
(`--shadow --passes 0 --window-contexts --list 20`, and with `-Wall -Wextra`). Both give:

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| calls the kernel in place is to make | 12,921 | 4,182 | 8,586 | 16,877 |
| made | 12,883 | 4,182 | 8,556 | 16,876 |
| **with every argument's conversion** | **12,865 (99.57%)** | **4,131 (98.78%)** | **8,415 (98.01%)** | **14,150 (83.84%)** |
| of them plain | 12,865 | 4,131 | 8,179 | 12,815 |
| left to T for an argument | 0 | 0 | 25 | 0 |
| records and conversions that differ from T's | 0 | 0 | 0 | 0 |
| records the kernel in place is to make, and made | 250,825, 247,906 | 64,965, 62,855 | 198,338, 191,502 | 319,834, 310,953 |
| expressions the kernel placed and C ran on | 50,996 | 10,839 | 43,415 | 52,015 |
| **expressions decided on the window** | **43,876 (86.04%)** | **9,135 (84.28%)** | **37,304 (85.92%)** | **32,853 (63.16%)** |
| their records | 227,936 | 55,780 | 172,677 | 159,397 |
| of them refused, as C refuses them | 147 | 165 | 1,899 | 1,213 |
| expressions that differ from C's, and records | 0, 0 | 0, 0 | 0, 0 | 0, 0 |
| listed: a call | 18 | 47 | 157 | 2,107 |
| `&&`, `\|\|` or `?:` | 2,721 | 446 | 1,689 | 11,242 |
| an update | 3,535 | 795 | 3,902 | 5,325 |
| a comma or a selection | 150 | 370 | 42 | 0 |
| a division by a constant | 167 | 40 | 244 | 423 |
| a value the columns don't hold whole | 529 | 6 | 77 | 65 |
| another operator | 0 | 0 | 0 | 0 |
| strides read (asked of the type table) | 6,965 (0) | 1,074 (0) | 3,850 (5) | 12,897 (0) |
| rules that read T's two conversions | 0 | 0 | 128 | 140 |
| consumers and first operands read by loads | 1,356 | 192 | 351 | 2,481 |
| records swept | 321,488 | 91,270 | 377,187 | 557,944 |

(The 9700X's `sqlite3.c` is another copy of the amalgamation: 289,838 records of the window there for 289,863 here, 12,918 calls to make for 12,921.)

`cloud/final/progress.txt` is the run of the checks on the pushed sources: the eight parts of `test-checker`, these
eight shadow runs, the shadow's eleven other modes on `sqlite3.c` and Lua, the self-check, the self-parse, the call
graph, the build's ownership check and the complete driver's lists. Its one failure, `complete-light`, is the cloud container's alone and the same in every run before the piece: the preprocessor's comparison against clang there spells the compiler's include directory another way. `cloud/sanitizers` is the rows a
pull request's checks skip (memory, address and thread, native): the node machine's tests' part in each, and under
memory and address C on the window on `sqlite3.c`, Lua and the compiler's own source, with no report
(`cloud/sanitizers/progress.txt`). The checks and the sanitizers ran on the piece on main `bc66290c5`
(`487ce3ced`); `cloud/rebased` is the build, the node machine's tests' part and the four corpora again after the
rebase on main `041cfd9ed`, which changed none of the piece's files.

## 3. The 9700X (`9700x/`)

Each job: seven readings on `sqlite3.c` and Lua and fifteen on musl of the base and the build with C on the window
(`--window-contexts`) and with the tests on the window alone (`--window-tests`), in turn; seven of `--front-window` for
both; `-c sqlite3.c` as whole processes, twice. TSC ticks, medians. The gate's figure is C's three sweeps a record of
the decided expressions, plus what the bytes' sweep costs with C's columns over the same build with C off, a record
of the decided, each reading's own.

| build | what it is | the kernel in place on `sqlite3.c`: the base, the build | C's sweeps, a record of the decided |
| --- | --- | ---: | ---: |
| `call1` | four arguments' slots read in the call's short path, unrolled; a miss sends the call to the rule | 15.96, 18.19 (C off) | 8.08 |
| `call2` | the slots read in a second pass over the batch's calls | 16.29, 17.36 | 7.94 |
| `call3` | the same with one multiply for the key's hash | 16.26, 17.56 | 7.99 |
| `call4` | the second pass, the rule as words of 0 or 1 that asks the type table nothing, a miss answered in the loop | 16.33, 17.32 | 8.07 |
| `call5` | `call4` with the first fault round's dead terms out, the mark of a left call among them: **not exact** on a call the loop leaves inside another (section 5) | 16.37, 17.56 | 8.11 |
| **`call8`** | **the pull request's code,** on main `bc66290c5`: the mark back, the later rounds' dead terms out | **16.31, 17.52** | **8.17** |

The pull request's build against main, whole (`9700x/call8`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| **the kernel in place: before** | **16.31** | **20.69** | **18.89** |
| **with the piece** | **17.52** | **22.36** | **20.36** |
| the same two with C off | 15.94, 17.63 | 20.63, 22.36 | 19.00, 20.36 |
| **C's three sweeps, a record of the decided: before** | **12.47** | **18.88** | **34.09** |
| **with the piece** | **8.17** | **11.68** | **26.55** |
| the reference's C on the same expressions: before, with | 37.7, 38.5 | 34.2, 36.6 | 41.2, 40.6 |
| C's sweeps, a record they ran over: before | 5.38 | 6.63 | 10.09 |
| with the piece | 5.79 | 7.14 | 12.16 |
| of which the loop: before, with | 2.42, 2.60 | 3.69, 4.03 | 5.89, 7.78 |
| the targets: before, with | 1.23, 1.38 | 1.42, 1.58 | 1.99, 2.54 |
| an expression's part: before, with | 1.73, 1.73 | 1.52, 1.50 | 1.95, 2.02 |
| the records' bytes with C's columns: before, with | 9.94, 9.97 | 11.94, 12.03 | 20.78, 22.62 |
| the tests' bytes alone: before, with | 9.17, 9.20 | 10.82, 10.78 | 18.69, 20.07 |
| the tests on the window, C off: before, with | 31.4, 31.1 | 49.7, 49.0 | 91.6, 96.6 |
| the front with the window: before, with | 53.1, 53.4 | 70.8, 70.9 | 90.9, 89.9 |
| the arguments' rule's answers, of them in the timed run | 1735, 58 | 1378, 6 | 8209, 10 |
| ticks an answer | 102 | 103 | 128 |

- `sqlite3.c`: the kernel in place before 16.31 (16.25 to 16.58), with 17.52 (17.32 to 17.66)
- Lua: the kernel in place before 20.69 (20.61 to 20.74), with 22.36 (22.26 to 22.92)
- musl: the kernel in place before 18.89 (18.86 to 26.14), with 20.36 (20.32 to 21.52)
- `sqlite3.c`: 7 readings; the three sweeps 8.17 a record of the decided; the bytes' columns 1.00; together 9.18 (8.94 to 9.32); the kernel in place over the build before, each reading's own: 1.12 (0.96 to 1.27)
- Lua: 7 readings; the three sweeps 11.68 a record of the decided; the bytes' columns 1.58; together 13.42 (12.93 to 21.34); the kernel in place over the build before, each reading's own: 1.67 (1.55 to 2.28)
- musl: 15 readings; the three sweeps 26.55 a record of the decided; the bytes' columns 4.41; together 31.20 (26.89 to 37.34); the kernel in place over the build before, each reading's own: 1.46 (-5.79 to 2.63)
- -c sqlite3.c, run 1: wall +0.05% (the base again -0.02%); user cycles +0.01% (the base again -0.10%)
- -c sqlite3.c, run 2: wall -0.30% (the base again -0.45%); user cycles -0.09% (the base again -0.18%)

### The tests on the window on musl: two controls (`9700x/order`, `9700x/x9`)

`call8`'s job read the tests on the window, with C off, 91.6 ticks a record for main and 96.6 with the piece on musl
(13 of 15 readings above main's own), and the same for both on `sqlite3.c` and Lua (31.4 and 31.1, 49.7 and 49.0).
Every part of them reads more on musl, the census's code on T's records among them, which is main's source.

| control | | the tests on the window, musl |
| --- | --- | --- |
| `order`: main, the piece, the piece, main in each of nine readings | is it the build or its place in the turn? | 91.9, 97.4, 98.3, 90.3: **the build** |
| `x9`: one executable, the piece with a switch (`BUSTER_TESTS_SKIP`; `patches/x9-experiment-on-bc66290c.patch.gz`, `job-x9.sh`), each setting in turn in each of nine readings | is it what the piece runs? | as pushed 98.8, and again 94.9; the arguments' pass off 95.8; its two tables' clearing off too 97.5; the types' answers with their rows off too 96.4: **no** |

So the rise is the piece's executable's and not its work: with all of the piece's work off the same executable reads
the tests no lower than with it on, and the two readings of one setting are 3.9 apart. What in the executable is not
established. (The kernel in place in `x9`: 20.56 and 20.59 as pushed, 19.63, 19.49 and 19.51 with the pass off, where
main reads 18.9.)

`9700x/perf16` is the mispredicted branches' samples of the calls' loop on `call3` and `cw10` (`perf16.sh`): 0.13 a
call more with the piece.

## 4. The experiments (`experiments/`)

- `slots.txt`: the rule's calls in the timed run by the key's hash (one multiply of the two words folded, a CRC of
  the two, a multiply each) and the slots' count (2^11 to 2^14), on the build whose miss sent the call to the rule.
- `cold-rule-answers.txt`: that rule's answers and their ticks with a clock read around each, two runs a corpus: 1,257,
  1,337 and 8,022 answers at 244 to 309 ticks an answer in the cloud container.
- `keys-sqlite3.txt`: `sqlite3.c`'s arguments' 1,146 keys by what the argument is.

## 5. The probes (`probes/`)

Calls one statement at a time through the shadow with C on the window and `--verify`: what the kernel in place makes
of the statement's calls (made, with every argument's conversion, plain, left for an argument), whether a record or a
conversion differs from T's, and what C on the window makes of it.

- `probe.py`, `probe2.py`: a statement alone in a function with the declarations the script has (`calls1.txt` to
  `calls7.txt`). `probe3.py`: after the fixture's own declarations and locals (`fixture-head.c`; `calls8.txt` and
  `calls10.txt` to `calls14.txt`). `own/`: statements that need other declarations, and four files with
  `#pragma STDC FENV_ACCESS ON`.
- `final/` and `own/own-e17.out`: every statement on the pull request's code. **608 statements; the checker rejects
  44; in the other 564 no record, no argument's conversion and none of C's answers differs.**
- **Twelve end with a status for a reason that is main's**, with no difference of this piece's: a zero that is no
  literal as a null pointer constant (`fp(1 - 1)`, `fp((char)0)`, `fp(!1)` and five more:
  [buster#3012](https://github.com/buster14a/buster/issues/3012)), and an integer constant made of a floating one
  (`fl((int)0.5)` and three more: [buster#3014](https://github.com/buster14a/buster/issues/3014), which these probes
  found).

What they found, in order:

1. **Two calls main's kernel made otherwise than T** (`calls1.txt`, on main `521d5b63d`): `fi(1e100)`, whose
   constant saturates with two inherited flags, and a vector argument with a modification, whose conversion drops
   the flag. The kernel's call rules gathered the arguments' own flags.
2. **A call the loop leaves, inside another** (`calls5.txt`, on `call5`'s code): `fi(two(1e100, b));` differed in
   four records. The two calls are in one batch, and the outer one was made from the kernel's record of the inner,
   which the loop had left to T. The mark of a left call, which a fault round had removed as dead, is what makes
   the outer one follow it to the rule.
3. **Statements for the faults' survivors** (`calls6.txt` to `calls14.txt`): the fixture's third and fourth
   batches, the rejected programs behind 13 of the 37 that survive, and the statement that tells the two passes'
   order (`calls13.txt`: a call with one argument the first pass leaves and one the second pass leaves).

## 6. The faults (`faults/`)

One fault at a time in a copy of the tree: a text of the piece's code replaced by a faulty one, the Debug compiler
built, the node machine's tests run (`test-checker --seed 133 --part 5/8`). For a fault the tests don't fail, the shadow
with C on the window on Lua, `sqlite3.c` and musl too: whether a corpus's status or counts tell it from the code.
`faults.py` is the list (each round's changes are a block at its end; `faults-round1.py` is the first round's),
`run.sh` a worker, `roundN-all.txt` each round's verdicts and `final-verdicts.txt` each fault's last one.

| round | the sources | faults run | caught | survived | not built |
| --- | --- | ---: | ---: | ---: | ---: |
| 1 | the first exact build | 302 | 161 | 109 | 32 |
| 2 | its dead terms out, the fixture's first two batches in, an unwritten conversion poisoned | 278 | 217 | 55 | 6 |
| 3 | a left call's mark back, the fixture's third batch, one dead term out: the second round's survivors, the mark's faults, those that had not built | 69 | 17 | 52 | 0 |
| 4 | the fixture's fourth batch, two dead terms out: the third's survivors and the changed lines' | 55 | 13 | 42 | 0 |
| 5 | a line for the two passes' order that did not tell it | 2 | 0 | 2 | 0 |
| 6 | a line that does; the guards for no type out: those two and the changed lines' | 9 | 7 | 2 | 0 |
| 7 | the types' answers asked of the type as it is (the two were its stripping's): the changed lines' | 5 | 5 | 0 | 0 |

**Of the 278 faults whose text is in the pushed sources, 241 are caught.** A fault's verdict is its last round's: 204
are the second round's, on sources that differ from the pushed ones in what the later rounds changed (the mark, six
dead terms, the fixture's lines), and the others the third to seventh rounds'.

**What the rounds changed.**

- **Dead terms out, each with what makes it dead** (the code that makes the value, named in the comment that
  replaced it): after the first round a guard for no type, a vector's test inside the arithmetic one, three of a
  type's answers no rule read, a prototype's parameters' plain bit, an order's shortcut, a conditional write of a
  conversion, a valid type's test of a made conversion; after the second the record's own word's validity (the
  value's type's answer implies it); after the third a flagged value that is no pointer, and an untaken promotion's
  plain bit; after the fourth the guards for no type in a type's answers (the type table's tests say no of a kind
  that is none); after the sixth those answers' stripping of a qualifier and a wrapper (the type given has neither
  where the answer is read).
- **One removal was wrong.** The first round's survivors included the mark of a call the loop leaves and the rule's
  tests of it. I removed them as dead: calls of one batch looked independent. They are not (a call's code is not after
  a call's, so `f(g(x))` has both in one batch), and the build without them made `fi(two(1e100, b));` from the
  kernel's record of a call it had left. `sqlite3.c`, Lua, musl and the fixture passed that build (the compiler's
  own source was not run on it); a nested call run alone did not. The mark is back, with four nested statements in the fixture and its faults caught in round 3.
- **Fixture lines for what the survivors showed untested:** a const object's value past the parameters, a pointer to
  a const volatile void parameter, calls five deep (the rule's own), a const struct's member array past the
  parameters, a callee with an offset, a vector with a GNU constant's flag, an enumeration's rvalue past the
  parameters, a floating constant of a type that is not float, double or long double, and a call with one argument the
  first pass leaves and one the second pass leaves (the two lists' order).
- **A stale build read as a bug.** Round 3's first base failed 24 checks in a Debug build where Release passed. The
  trees had been refreshed with `git archive | tar -x`, which gives each file its commit's time, and the unit that
  holds the node machine had been built later than that, from round 2's last fault: it stayed as it was. Extracted
  with `tar -xm`, the base passes.

**The 37 that survive, by what makes each so.**

*A guard for a program the checker rejects (13).* The kernel has to leave such a call to T, whose diagnostic it is;
no accepted program reaches the term, and the shadow compares none that is rejected. The statements are in
`probes/` (`calls6.txt`, `calls7.txt`, `calls11.txt`, `own/`), each rejected.

| fault | the program |
| --- | --- |
| `argued-aggregate-no-struct` | a value of another type to a struct's parameter: `fst(un)`, `fun(v)`, `fsp(v)` |
| `key-flags-no-register-name`, `made-array-register-too` | a register array as an argument: `register int ra[2]; fip(ra);` |
| `key-zero-any-payload`, `made-null-any-value` | an integer constant that is not zero to a pointer: `fv(1)`, `fp(2)` |
| `key-flags-no-gnu-ice-form`, `made-null-any-form`, `made-forms-any` | a zero in no constant expression's form to a pointer: `fp((0, 0))`, `fp((long)(void*)0)` |
| `made-arithmetic-any-value` | a value that is not arithmetic to an arithmetic parameter: `fi(ip)`, `fd(ip)`, `fl(vp)`, `fi(v)`, `fi(vec)`, `fd(ev)`, `fl(arr)`, `fi(none)` |
| `made-bool-any-value` | a value that is no scalar to bool: `fb(v)`, `fb(vec)`, `fb(un)`, `fb(ev)` |
| `made-atomic-never`, `made-ruled-atomic-too`, `made-other-ruled-atomic` | an atomic type's rvalue as an argument: `fi((_Atomic int)a)`, `fi(geta())`, `fi(getsa().m)`, `vf(a, geta())` |

*A term of T's rule, or of C's, that no record separates (19).*

| fault | what makes the records so |
| --- | --- |
| `key-flags-no-ice`, `made-constant-lvalue-kept`, `made-constant-lvalue-none`, `made-null-any-constant` | an lvalue with a constant's standing: none arises (`static const int sf = 3; fbi(sf);` is made as no constant; a `constexpr` object is rejected). The flag's other reader is a null pointer constant's form, above |
| `key-flags-no-volatile-part`, `made-read-volatile-part-too` | a scalar lvalue with a volatile part has a volatile type (`fi(vsp.first)`) |
| `key-zero-field-too` | a record whose field is not the integer's has a payload that is not zero (`node_machine_put_value`) |
| `made-integer-any-constant`, `made-floating-any-constant` | an integer type's value's constant is an integer's, an address's or none; a real type's a floating one or none |
| `made-real-qualified-too`, `made-sized-qualified-too` | no constant's rvalue has a qualified type: a cast's and a call's results have none (`fd((const double)1.5)`, `fl((const int)5)`, `fd(getcd())` are made) |
| `made-pointer-value-functions-as-arrays` | a function's type has no qualifier (`type_qualify`) and its name is no register's, so the array's choice gives its pointer |
| `made-dropped-fp-environment-too` | under `#pragma STDC FENV_ACCESS ON` the reader makes none of a block's calls (`own/q1.c` to `q3.c`) |
| `made-pointed-any-constant` | a pointer's constant is an address's or none: an integer made a pointer is an address's (`check_action_convert_plain`) |
| `made-valid-value-any`, `made-neutral-invalid-too` | a record whose type is none: no statement of the probes has one that the record holds whole (a fault's is wide) |
| `window-called-effects-too` | an address constant with an effect has a comma, which lists its expression |
| `window-direct-no-symbol` | a called leaf that is an address constant with an object is a function's name, which has a symbol |
| `window-made-call-in-a-place` | a plain call's value is no lvalue, so it is no operand of `&` |

*The same answer without it (4).*

| fault | |
| --- | --- |
| `made-other-same-too` | the pair's slot of a type with itself says assignable: the test spares the probe |
| `made-pair-unruled-too` | the probe's answer is read of a ruled argument alone: the test spares the probe |
| `made-taken-no-pointer-too` | an array whose pointer type is not made has a value's type that is none, which no case takes: the test keeps that type out of the pairs' slots |
| `given-no-poison` | the tests' tripwire for a conversion read and not written: nothing reads one |

*Waits for another issue (1).*

| fault | |
| --- | --- |
| `made-integer-fields-too` | `fl((int)0.5);` tells it (left with the term, made without). That constant fails the reader's own check today ([buster#3014](https://github.com/buster14a/buster/issues/3014)), so the fixture can't hold it yet |
