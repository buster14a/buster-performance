# The tests on the window, second half: the tree's tests by the operator above, and an expression with nothing listed (buster#2850, step 2): 2026-11-18

The second piece of the second half of "the tests on the window"
([its specification](https://github.com/buster14a/buster/issues/2850#issuecomment-6964835276)), after
[the first](../window-tests-second-half-2850-2026-11-17/README.md) (buster14a/buster#2955). Each form is a patch here
against main `aa09d1a04`; a patch holds the first piece's sources too, and the base it is read against is that piece's
build, `f2`.

- 9700X: CPU 2, Release, each run its own hold of the lock, the two builds in turn in each reading
  (`scripts/job-pair.sh`, `scripts/job-pair-built.sh`); the first piece's record's directory, `turns.sh`, `compile.sh`
  and `build-label.sh`.
- TSC ticks a record of the expressions the tests ran on. Medians of seven readings on `sqlite3.c` and Lua, of
  fifteen on musl; with every warning of five, and fifteen on musl. `scripts/tables2.py RESULTS HEAD f2` prints a
  job's table.
- The window's sweeps: `bytes` the records' bytes, `loop` the loop, `part` an expression's part, `rest` the tests that
  read T's records (T's own time taken off them, `again`).

## 1. The tree's tests, counted (`patches/tests-t1-experiment.patch`, `results/cloud/t1`)

Counted in the cloud container on the first piece's sources (counts, not times).

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records listed for the tree's tests (a comparison's token, `!`, `=`) | 27,794 | 4,844 | 17,871 |
| of them whose token's parent's role lets a test fire | 1,890 | 318 | 951 |
| of the others, with a test that fires | 0 | 0 | 0 |
| expressions the tests run on | 50,996 | 10,839 | 43,415 |
| with a listed operator | 20,898 | 6,226 | 15,230 |
| with two writes, or one below the top | 1,017 | 353 | 851 |
| with neither | 29,584 | 4,470 | 27,827 |

Of `sqlite3.c`'s 1,890: 1,182 an `=` under a terminator in a `for`'s head, 708 a comparison under a terminator, none
under a bitwise operator, no `!` under a comparison.

## 2. The list by the parents' roles (`patches/tests-a1-on-main.patch`, `results/9700x/a1`)

The specification's piece A as written: the listed records' tokens compressed in the records' bytes' pass, sixteen a
step; a step gathers their parents and the parents' roles, and for an `=` under a terminator its grandparent's role.
A record stays listed where the role lets its test fire. Exact (`--verify`: every record left out has no test).

| ticks a record | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| | before | `a1` | before | `a1` | before | `a1` |
| the tests on the window | 48.80 | 48.51 | 63.18 | 63.08 | 109.74 | 112.03 |
| bytes | 9.31 | 11.28 | 10.35 | 12.50 | 18.30 | 23.82 |
| loop | 0.84 | 0.66 | 1.09 | 0.99 | 2.50 | 2.27 |
| part | 7.43 | 7.45 | 7.64 | 7.68 | 12.82 | 12.86 |
| rest | 31.18 | 29.09 | 44.14 | 41.88 | 74.95 | 71.08 |
| with every warning | 70.28 | 69.58 | 76.83 | 76.39 | 125.65 | 131.40 |

Its own gate (the tree's tests under 1.0 for a pass under 1.0) is missed: the pass reads 2.0 more in the bytes for 2.1
less on T's records. A chunk of some hundred records has ten listed ones, so a step of sixteen is never full at a
chunk's end, and each listed record costs its two loads, as it did in the scalar test.

## 3. The list by the operator above, and no call for an expression with nothing listed (`patches/tests-a2-on-main.patch`, `results/9700x/a2`)

A tree's test fires only where its record's token's parent is its consumer's token: a bitwise operator over a
comparison, a comparison after `!`, the condition's root the reader puts at a condition's `)` or a `for`'s second
`;` over `=`, the discard it puts at a statement's `;` over a comparison. The loop lists the consumer by three
tables by operator and one more permute a step (`own_tree_marks`, `own_tree_firsts`, `own_tree_sends`), the test runs
on the listed operator's operands, and the role's gather in the bytes' pass, which was for the list alone, is gone.

An expression with nothing listed (no operator in a list, no write out of sequence, no initialization's root, no
statement whose top is no write, no return of an address, no warning of T's actions) has its verdict made in the
sweep of an expression's part, and neither T nor the tests run on it.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| operators listed for the tree's tests (cloud) | 6 | 0 | 34 |
| expressions the tests ran on (9700X) | 50,993 | 10,839 | 43,415 |
| with nothing listed | 21,157 | 3,069 | 21,925 |
| with every warning | 8,793 | 1,302 | 15,146 |

`a2` has the listing with a branch on each condition and a branch in the tests' sweep on which expression is listed.

## 4. The listing's cost (`patches/tests-a3-on-main.patch`, `tests-a5-on-main.patch`, `tests-a6-on-main.patch`; `results/9700x/a3`, `a5`, `a6`)

`sqlite3.c`, ticks a record, each build in turn with `f2` in its own job:

| | the tests | bytes | loop | part | rest | `again` | with every warning |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `f2`, the first piece (six jobs) | 48.50 to 48.91 | 9.26 to 9.33 | 0.80 to 0.86 | 7.31 to 7.41 | 31.04 to 31.33 | 47.4 to 47.7 | 69.86 to 70.31 |
| `a2`: branches | 46.56 | 8.43 | 0.90 | 12.93 | 24.22 | 32.05 | 69.98 |
| `a3`: no branch; the expressions to call as a list | 45.16 | 8.48 | 0.87 | 13.02 | 22.72 | 30.82 | 69.93 |
| `a5`: the part trimmed | 43.45 | 8.52 | 0.88 | 10.00 | 24.08 | 29.94 | 70.17 |
| `a6`: a `for`'s clause asked of the unlisted alone | 42.67 | 8.51 | 0.88 | 9.76 | 23.47 | 30.58 | 67.94 |
| `a10`: section 5's two changes | 42.33 | 8.51 | 0.92 | 9.74 | 23.08 | 30.47 | 67.96 |
| `a14`: a statement's root's token's role not read (section 8); the pull request | 41.98 | 8.53 | 0.87 | 9.49 | 23.19 | 30.61 | 67.29 |

Lua: `a2` 63.00 (before 63.09), `a3` 60.60 (63.15), `a5` 59.54 (63.38), `a6` 59.06 (63.23), `a10` 58.37 (63.05),
`a14` 59.12 (63.30). musl: 105.26 (108.93), 101.45 (110.20), 102.57 (109.59), 101.57 (109.80), 102.35 (109.29),
99.97 (111.34).

- **The listing first cost 5.6 ticks a record, with branches or without** (`part` 12.93 and 13.02 for 7.4).
- **A profile couldn't say where.** `scripts/perf3.sh`: the host caps sampling at 63,300 samples a second
  (`kernel.perf_event_max_sample_rate`), a run kept 22,000 samples at a period of 2,003 cycles as at 20,011, and an
  expression's part is a millisecond of the run. The build's code was read instead (`objdump -dl` of
  `node_facts_reader_flush`, where the tests are inlined): no branch on what an expression is, its values spilled to
  the stack, its counts kept in memory, and the events' words read and masked for every expression.
- **`a5` trims it:** an expression's events are asked only where its span meets the bounds of the unit's events so far
  (two compares); its lists are OR-ed in the loop that makes them; what the report counts is counted after the timed
  sweeps; a statement expression's bit is read only in a unit that has one.
- **`a6`:** under `-Wfor-loop-analysis` a clause's test loads its token's parent and that parent's role. Asked of
  every expression the two loads cost what the piece saved with every warning (`a5`: 70.17 for 69.86); asked of the
  unlisted alone, 67.94 for 70.31.
- **`a14`:** the listing read its root's token's role to tell the reader's discard from an explicit cast. The front
  makes a root with a cast's operator at a terminator alone, and the terms changed no result (section 8): without the
  load `part` reads 9.49 for 9.74.
- **`rest` moves by a tick between builds** that list the same expressions: T's own time is taken off it, and `again`
  moves as much.

## 5. The front's ticks, and what moved them (`results/9700x/*/window-*`, `patches/tests-a6pad-experiment.patch`, `tests-a8-on-main.patch`, `tests-a10-on-main.patch`)

"The window without the tests" (`--front-window`) is not this piece's to change. The front's ticks a record with the
window read higher in every build of the piece, the same front without the window (`plain`) unchanged. Medians of
three readings (`a2` to `a6`) or five, each build in turn with `f2`:

| | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| | before | the build | before | the build | before | the build |
| `a2` | 52.72 | 53.77 | 70.47 | 71.50 | 87.59 | 88.80 |
| `a3` | 52.76 | 53.63 | 70.25 | 71.63 | 88.38 | 91.44 |
| `a5` | 52.83 | 53.42 | 70.49 | 71.40 | 89.08 | 89.90 |
| `a6` | 52.65 | 53.39 | 70.03 | 71.75 | 87.43 | 89.84 |
| `a6pad`: `a6` with an unused byte column where the roles' was | 52.65 | 53.38 | 70.32 | 71.44 | 89.23 | 90.32 |
| `a8`: T's warning a bit of the kernel's reader's byte, no column a root | 52.83 | 53.49 | 70.28 | 70.90 | 87.16 | 88.59 |
| `a10`: `a8` with the events' intake out of line | 52.95 | 52.79 | 70.06 | 72.01 | 89.95 | 88.79 |
| `a14` (three readings) | 52.95 | 52.99 | 70.51 | 70.42 | 87.20 | 89.31 |
| the same front without the window, `a10` | 44.11 | 44.24 | 59.38 | 59.56 | 78.62 | 78.30 |

- **Not the arena's layout:** a column put back where the roles' was read the same (`a6pad`).
- **Not the column a root:** `a6` kept T's actions' warning in a byte a root, stored in the reader's pass; as a bit of
  the byte the kernel's reader keeps an expression it reads the same on `sqlite3.c` (`a8`).
- **The front's own function's code.** `nm -S`: `node_front_acted` is 0x62fd bytes in `f2` and 0x636d in `a6` and
  `a8`. Its disassembly differs by the reader's intake of a chunk's warning events, inlined there, which the piece gave
  two bounds (ten instructions), by the stack slots after it, and by an alignment's padding.
- **Out of line, the front reads as before** on `sqlite3.c` and musl (`a10`: `node_census_reader_chunk` is a
  function of its own). Lua's five readings of `a10` are 72.01, 70.55, 74.60, 74.61 and 70.05, where `f2`'s are 69.89
  to 70.22; `a14`'s three are 70.04, 70.57 and 70.42 for 70.51, 70.56 and 70.41. musl's three of `a14` are 93.11, 89.31
  and 87.96 for 87.20, 87.18 and 90.27.

## 6. The pull request's sources (`patches/tests-a14-on-main.patch`, `results/9700x/a14`)

`a14` is `a10` without the three terms of an expression's listing that section 8's third round found to change nothing
(its root's token's role and the load of it), with comments, and with one more function in a fixture.

| | `sqlite3.c` | | Lua | | musl | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| | before | the piece | before | the piece | before | the piece |
| **the tests on the window** | 48.91 | **41.98** | 63.30 | **59.12** | 111.34 | **99.97** |
| bytes | 9.29 | 8.53 | 10.38 | 9.42 | 18.03 | 18.13 |
| loop | 0.83 | 0.87 | 1.10 | 1.16 | 2.56 | 2.49 |
| part | 7.38 | 9.49 | 7.69 | 9.93 | 13.92 | 16.66 |
| rest | 31.32 | 23.19 | 43.93 | 38.61 | 76.09 | 61.93 |
| `again` | 47.60 | 30.61 | 48.59 | 37.24 | 46.35 | 28.77 |
| with every warning | 70.16 | 67.29 | 76.64 | 74.25 | 128.82 | 122.31 |
| beside `--verify` (one reading) | | 80.22 | | 98.03 | | 170.75 |
| the kernel in place, without the tests | 15.66 | 15.80 | 20.16 | 20.22 | 18.76 | 18.93 |
| the names' pass, ticks a name | 22.74 | 23.27 | 95.16 | 95.72 | 68.98 | 68.74 |

musl's fifteen readings run from 97.60 to 105.20 (`a14`) and from 107.27 to 120.41 (`f2`); with every warning from 119.29
to 130.40 and from 124.11 to 140.32. `a10`'s job read 102.35 for 109.29 there (`results/9700x/a10`).

`-c sqlite3.c` as whole processes (`compile.sh`: 21 runs of each of three copies, twice): wall -0.07% and -0.05%,
user cycles -0.04% and -0.08%; the first piece against itself -0.24% and -0.14%, -0.04% and -0.15%.

Against the specification's gates:

1. **Exact:** section 7.
2. **A, the tree's tests under 1.0 tick a record for a pass of its own under 1.0:** missed by the form specified
   (section 2); by the operator above there is no pass, the loop reads 0.04 more, the bytes 0.76 less, and the tree's
   tests are six calls.
3. **A and B, 40 on `sqlite3.c`, refuted at 44:** 41.98.

## 7. The cloud container's checks (`results/cloud/final`)

The pull request's sources on main `aa09d1a04` (the work branch's `6b04ae35f`; 4 CPUs, native host, Release;
`checks.sh`, `progress.txt`):

- `test-checker`, all eight parts: 842,781 checks, 0 failures (`test-checker-status.txt`).
- The shadow on `sqlite3.c`, Lua, musl and the compiler's own source in 12 modes: 48 runs, each status 0
  (`shadow/status.txt`). `shadow/` has the `--window-tests` runs' outputs: no expression differs. Beside `--verify`:

  | | `sqlite3.c` | Lua | musl | the compiler's own source |
  | --- | ---: | ---: | ---: | ---: |
  | records the tree's tests read that no listed operator has as an operand, checked | 27,788 | 4,844 | 17,837 | 28,189 |
  | of them with a test | 0 | 0 | 0 | 0 |
  | expressions with nothing listed, checked | 21,157 | 3,069 | 21,925 | 18,191 |
  | with every warning | 8,793 | 1,302 | 15,146 | 7,885 |
  | of them with another verdict | 0 | 0 | 0 | 0 |
  | lists' words with a bit past their expression | 0 | 0 | 0 | 0 |
  | operators left out for their constants, checked (the first piece's) | 20,897 | 7,027 | 14,477 | 22,663 |
  | with every warning | 10,152 | 5,718 | 10,597 | 10,989 |
  | of them with a test | 0 | 0 | 0 | 0 |

- The self-check, the self-parse, `test-call-graph` and `check-call-graph`: status 0.
- The complete driver (`-DBUSTER_COMPLETE_DRIVER=1`; `complete-light.log`, `complete-heavy.log`, the workflow's
  parse): one heading fails, as on main in this container: "Test the preprocessor on the repository's translation
  units against clang", 45 of 66 files, each by the container's clang's resource directory's path
  (`/usr/lib/llvm-23/lib/clang/23`) and nothing else. The heavy list's first run was
  killed for memory (exit status 137 at 4.9 GiB, with a sanitizer build and the faults' builds beside it); run again
  alone, both its headings pass (`complete-heavy-again.log`).
- The sanitizer rows a pull request's checks don't run (`sanitizers.sh`, `sanitizers-progress.txt`; native memory,
  address and thread): a build each, `test-checker --part 5/8` (210,334 checks, 0 failures), and for memory and
  address the shadow with `--window-tests --verify` and with `--window-tests --verify -Wall -Wextra` on `sqlite3.c`,
  Lua and the compiler's own source. Every run status 0, no report.

The pull request's head, the same diff on main `6eaf73cfd` (`head-check.sh`, `head/`): a build, `test-checker --part
5/8` (210,334 checks, 0 failures), the self-check, and twenty `--window-tests` runs (the four corpora in five modes),
each status 0 with no difference.

The form before the last change (`a10` with comments) had passed the same checks, on the work branch's `fd19250bb`,
and the three sanitizer rows: memory on `10b4a40eb`, two comments before it, address and thread on `fd19250bb`
(`results/cloud/before`: their progress files).

## 8. Faults (`faults/`)

Faults put into the new code one at a time, each in a copy of the tree: the Debug compiler built, and the node
machine's tests run (`test-checker --seed 133 --part 5/8`). A fault the tests don't fail is a survivor.

| round | sources | faults | fail the tests | don't build | survive |
| --- | --- | ---: | ---: | ---: | ---: |
| `round1.py` | the work branch's `13ba78f5c` (`a4`) | 106 | 81 | 15 | 10 |
| `round2.py` | `27c8d3ebd` (`a7`) | 120 | 113 | 0 | 7 |
| `round3.py` | `fd19250bb` (`a10` with comments) | 122 | 116 | 0 | 6 |
| `round4.py` | `6b04ae35f` (`a14`): the pull request | 119 | 117 | 0 | 2 |

- **What rounds 1 and 2 changed:** lines in the seventh fixture's function `t` (the other operator's mark where an
  operator asks for one: `(a = b) == c`, `if (!a)`; an initializer whose top is listed, in each list; a warning event
  in each word of an expression's span and at its first token; an address taken outside a return), the ninth and
  tenth fixtures, and the verify's check of a list's range (`lists'-words-with-a-bit-past-their-expression`). Round
  1's fifteen texts that didn't build (a variable left unused under `-Werror`) were written again for round 2.
- **Round 3's six survivors:**
  - `s-stores-close-cast`, `s-stores-open-cast`, `s-stores-in-unit`: three terms of an expression's listing, which read
    its root's token's role to tell the reader's discard from an explicit cast, as the census's code does on T's
    records. They had survived rounds 1 and 2 too. The front makes a root with a cast's operator at a terminator alone
    (`CHECK_INPUT_FORM_DISCARD`: c_check_node_machine_front.c's `CHECK_INPUT_CODE_TERMINATOR`), and a probe of nine
    functions with an explicit cast over a write (`faults/probe.c`: statements, a `for`'s clause, a variable array's
    bound, a computed goto, statement expressions, a `case`, `__typeof__`, `sizeof`) read the same with the terms and
    without them (`faults/probe-with.txt`, `probe-without.txt`: ten expressions with nothing listed in each, none with
    another verdict). Removed in `a14`, with the load of the role.
  - `s-marks-bound-low` (`highest >= event_low` as `>`): no fixture had the unit's first warning event at the last
    token of an expression with nothing listed. A statement's last token is its terminator, where no event is; a
    return's is its operand's. The ninth fixture's first function (`return *"a\q";` under
    `-Wno-return-stack-address`) is one, and the fault now fails the tests.
  - `m-some` (the events' words' guard of an empty span) and `b-low-start` (the events' lower bound started at zero):
    no result changes. A span with no token of the unit reads the first word's top bit and its lowest, which no mask
    shares; and a lower bound of zero lets more expressions ask their events, which find the same.
- **Round 4, on the pull request's sources:** 119 faults (round 3's without the four of the line removed, and one of the
  statement's term in their place): 117 fail the tests. The other two are `m-some` and `b-low-start`, which change no
  result.

