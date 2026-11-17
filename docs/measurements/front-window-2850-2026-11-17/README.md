# buster#2850: the front writes the window (2026-11-17)

The piece before this one (buster#2850's step 2, third piece) made the fact words' kernel's window as a copy of the lean
front's records, and the copy cost more than the kernel. Here the lean front writes each record's inputs as it makes the
record, and the kernel reads them where they are written (`measure-node-machine --shadow --front-window`). This is its
record: the 9700X, the versions on the way, the checks in a cloud container, the fault campaign and the sanitizer rows.
[Its specification](https://github.com/buster14a/buster/issues/2850#issuecomment-6939344308) has the gate.

**Result.**

- **Exact.** Every input the front wrote is the one made from T's columns and, where the copy gives the expression,
  the copy's; every record the kernel makes in place is T's, over poisoned records and over decoys; on `sqlite3.c`,
  Lua, musl and the compiler's own source.
- **Every expression T takes at reader time is read in place** on the four inputs. A chunk's end keeps a waiting
  value's records whole, in a row, where the lean front kept its place alone.
- **The gate's 35 ticks a record is met on `sqlite3.c`: 29.9.** The kernel in place 15.6, the names' pass 4.6 and the
  front's rise 9.7. The inputs are 14.4 where the copy took 30.4 in the same build.
- **Lua reads 38.4 and musl 61.5.** On musl the inputs cost more than the copy (42.9 against 35.6): the front writes the
  window for every record it makes, 2.76 for each one T takes there, and a third of musl's names are their
  declaration's first use in their unit.
- **Nothing is appended.** The specification's append by blocks was built and measured first (versions `a` and `b`):
  43.6 and 42.5 ticks a record. An append costs by the expression, and runs of expressions barely merge.
- **A compile is unchanged:** no compile runs any of it.
- **The fault campaign found a bound that did not hold:** the list of the calls' arguments could pass its array at a
  chunk's end where many cut calls wait. A cut value's arguments are no longer kept (section 5).

## 1. The tree

- The commit is `patches/0001-…patch`, on main `d876a5e0f` (buster#2895's merge, whose tree is its head `eb0a76e21`'s)
  with buster#2903's eight commits before it on the session's branch; those touch none of its files.
- **The 9700X built `patches/window-h.patch`:** the commit's `src` against `eb0a76e21`, but for one statement of the
  census's report (the most the arguments' list held, taken over a command's files), written as an `if` after it was
  built. The campaign's third run had the same sources. `results/9700x/base` is `eb0a76e21` itself, the base of the
  compile's comparison.
- **The versions** are `patches/window-a.patch` to `window-g.patch`, each against `eb0a76e21` too (section 3).
  `results/9700x/window-LABEL/revision.txt` has each one's SHA-256 as it was built.
- The cloud container's checks ran on the commit's sources (`results/cloud/revision.txt`).

## 2. The 9700X

Release builds, CPU 2, under the lock, a hold a run (`scripts/job-final.sh`; `results/9700x/tables.txt` by
`scripts/tables.py`). Medians of five readings in turn. TSC ticks at 3,792.9 MHz (1.45 cycles each at the core's 5.49
GHz), a record of the expressions T takes at reader time. `window-h`, the commit:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions T takes at reader time; their records | 50,993; 289,838 | 10,839; 76,304 | 43,415; 224,326 |
| expressions the kernel reads in place; not there in a row | 50,993; 0 | 10,839; 0 | 43,415; 0 |
| inputs that differ from either twin's | 0 | 0 | 0 |
| records to make in place; made; of the batch | 250,805; 247,886; 247,886 | 64,965; 62,855; 62,855 | 198,338; 191,527; 191,527 |
| records that differ from T's, over poison or decoys; lists that differ | 0; 0 | 0; 0 | 0; 0 |
| chunks in which the front without the window made other records | 0 | 0 | 0 |
| the names' pass: names; leaves its scalar path gives otherwise | 97,472; 0 | 25,359; 0 | 198,354; 0 |
| declarations' lines the pass made | 18,748 | 7,302 | 66,227 |
| chunks' ends: waiting values kept whole; their records; cut | 4,226; 10,258; 0 | 653; 5,859; 0 | 58,118; 71,085; 0 |
| **the kernel in place,** a later run | **15.58** | 20.14 | 18.62 |
| **the names' pass,** less the lines it made | **4.64** | 5.89 | 17.48 |
| **the front's rise** with the window | **9.73** | 12.37 | 25.40 |
| **their sum** | **29.94** | 38.40 | 61.50 |
| the five readings of the sum | 30.02, 29.85, 30.20, 30.28, 29.00 | 40.92, 38.07, 38.27, 38.89, 40.32 | 59.02, 55.44, 61.66, 66.61, 63.42 |
| with the front's arrays touched beforehand (`--front-warm`) | 29.85 | 38.06 | 63.44 |
| the lines the names' pass made; the rows | 2.74; 0.86 | 25.03; 8.89 | 42.43; 45.35 |
| the batch's kernel in the same runs: a later run; its first | 15.95; 26.82 | 20.48; 47.13 | 19.47; 77.09 |
| T again on the same expressions; T's first run | 49.75; 101.7 | 51.78; 123.8 | 52.39; 186.7 |
| the front, ticks a record of its own: with the window; without | 52.99; 44.23 | 70.48; 60.18 | 87.39; 78.12 |
| the piece before in the same build (`--front-facts`): the kernel's later run; the copy again; their sum | 16.00; 30.43; 46.43 | 20.48; 29.25; 49.73 | 19.56; 35.60; 55.16 |
| with the census's tests and C and X there (one reading): the sum; the share made in the whole machine's expressions | 29.61; 99.39% | 41.45; 97.25% | 71.69; 98.03% |

- **musl's readings spread.** The sum reads 55.4 to 66.6 in this build and 63.3 to 78.6 in `window-g`, whose code in
  the front's pass differs by one test of a literal's leaf. The front's rise is the part that moves (25.4 and 31.5 by
  the medians): the difference of two passes over 1,336 units' chunks, each on memory the other has just touched or
  not.
- **The front's rise by the front's own records** is 8.8, 10.3 and 9.3 ticks a record (with the window less
  without). It makes 1.09, 1.19 and 2.76 records for each one T takes at reader time: musl's units' tables are the
  front's and not T's.
- **A name in the names' pass** costs 13.8, 17.7 and 19.8 ticks. musl makes a line for a third of its names (66,227
  of 198,354): each unit starts with no line made.
- **Under `perf record`** (`results/9700x/window-h/perf-*.txt`; `scripts/perf.sh`, three runs of the window on
  `sqlite3.c`): the window's front is 1.43% of the run's cycles where the lean front beside it is 1.17%.

`-c sqlite3.c` as whole processes, `base` against `window-h`, 21 runs a build from three fresh copies, twice
(`results/9700x/window-h/compile-1.txt`, `compile-2.txt`):

| | base | `window-h` |
| --- | ---: | ---: |
| instructions, the three copies' medians | 1,362,107,843 to 1,362,107,854 | 1,362,107,787 to 1,362,107,812 |
| wall time | 122.157 ms; 121.733 ms | -0.14%; -0.09% |
| base against itself in the same runs | | +0.06%; +0.07% |
| user cycles; base against itself | | +0.04%; +0.02%; and +0.15%; +0.17% |

No compile calls the piece.

## 3. The versions

Each is a build of `eb0a76e21` with its patch (`scripts/job.sh`, `job-short.sh` for `b` and `c`, `job-final.sh` for `g`
and `h`): five readings, three for `b` and `c`. Ticks a record:

| | the window | `sqlite3.c`: the kernel + the window's making + the front's rise = sum | Lua | musl |
| --- | --- | ---: | ---: | ---: |
| `a` | the front writes the columns; an expression's are appended to the batch as blocks, its leaves' lines and its calls' arguments made over the copy | 16.00 + 16.85 + 10.71 = 43.56 | 49.29 | 71.06 |
| `b` | … consecutive expressions appended as one run | 16.05 + 16.49 + 9.93 = 42.47 | 48.95 | 74.60 |
| `c` | … the leaves' lines found and made in the front's own pass | 15.96 + 8.75 + 23.82 = 48.53 | 49.47 | 72.21 |
| `d` | no append: the kernel reads the front's columns where they are; the names' lines by a pass after the front's | 16.14 + 10.23 + 13.16 = 39.53 | 46.17 | 76.77 |
| `e` | … the pass by three sweeps (the places, a prefetch of each line, the read), the line's number asked for where the leaf is made | 15.68 + 4.87 + 12.42 = 32.97 | 40.84 | 67.81 |
| `g` | … without a test of each operator's operands' rows, which no text can fail | 15.68 + 4.94 + 9.33 = 29.94 | 39.28 | 68.22 |
| `h` | the commit: … a cut value's calls' arguments not kept at a chunk's end; a literal's leaf written without two tests no text can fail | 15.58 + 4.64 + 9.73 = 29.94 | 38.40 | 61.50 |

(`f`, with one test of the first operand's row where `e` had three, was not measured on the 9700X.)

- **`a` and `b`: an append costs by the expression.** `a`'s append retires about 55 instructions a record
  (`results/9700x/window-a/perf-*.txt`), and `sqlite3.c`'s expressions are 5.7 records each. In `b`, runs of
  consecutive expressions barely merge: a control's condition is in the front's arrays before its body and in the
  batch after it, so every `if` breaks a run twice.
- **`c`: a load that misses is dear in the front's own pass.** With the names' lines found there the rise went from
  10.7 to 23.8 ticks a record, 39 ticks a name, where the same loads in the append's loop were part of 24.
- **`d` to `e`: asking for a load before reading it.** `d`'s pass spends its samples on the load of the line's number
  by the declaration (`results/9700x/window-d/perf-annotate-*.txt`). With the number asked for where the leaf is made
  and each line asked for in a sweep before the one that reads it, a name went from 30 ticks to 15.
- **`e` to `g`: a test no input can fail** was a third of the rise. Each operator tested that its operands' records lie
  in a row before it. They do by the front's own order: the walk acts at no token within an expression whose value
  nothing takes (three probes, with variable-length casts and `__typeof__`, made no such record).

## 4. In the cloud container

A Release build of the commit with CI's toolchain (4 CPUs, an Intel Xeon with AVX-512; `scripts/cloud-checks.sh`), on
buster#2903's head, as it is on the session's branch. `results/cloud/revision.txt` is the commit as these ran; the
commit as pushed differs from it by one number in `docs/one-core-path.md`.

| what | result |
| --- | --- |
| `test-checker --seed 133`, the eight parts | 842,775 checks, 0 failures |
| the shadow in 12 modes on `sqlite3.c`, Lua, musl and `main.c` | exit 0 in the 48 runs, no difference |
| … `--front-window`: expressions read in place; not there; inputs that differ; records made in place that differ | `sqlite3.c` 50,996; 0; 0; 0. Lua 10,839; 0; 0; 0. musl 43,415; 0; 0; 0. `main.c` 38,243; 0; 0; 0 |
| … waiting values cut at the chunks' ends | 0; 0; 0; `main.c` 1,151, none in an expression T takes there |
| … the most the calls' arguments' list held (room 4,096) | 227; 212; 92; 0 (the lean front leaves every call of `main.c`) |
| the compiler checks and parses its own source; `test-call-graph`; `check-call-graph` | no diagnostic; 37 cases, 0 failed; 0 cycles |

- **The 12 modes:** `--passes 0 --front-window --list 20`; the same with `--front-tests`; with `--front-own-tests -Wall
  -Wextra`; `--verify --passes 1 --front-window`; `-g --passes 0 --front-window`; `--passes 0 --front-window
  --front-warm`; `--passes 0 --front-window --front-flat`; and, for what the piece's changes to the shared code touch,
  `--passes 0 --front-facts --list 20`, `--passes 1 --facts --facts-operators`, `--passes 1`, `--passes 1
  --front-sweeps` and `--passes 1 --front-flat`. `results/cloud/shadow` has the 96 outputs and `status.txt`.
- **`sqlite3.c` here** is this container's copy, three expressions more than the 9700X's.
- **The probes** (`results/cloud/probes`): `gen.py` and `gen5.py` make the room test's text with operands of three
  and of nine records; `keep7.txt` and `keep9.txt` are each chunk's end's last waiting values on them, printed by a
  build with a line added to `node_front_keep` (the operator, the subtree's size and the class: `fe` is cut); `im.c`,
  `ext.c` and `fn.c` are the three lines the campaign's second run asked for.


## 5. The fault campaign

`scripts/mutants.py`: each fault is one text of the new code replaced by a faulty one, in a copy of the tree, the Debug
compiler built and the node machine's tests run (`test-checker`'s part 5 of 8). Three runs, the tree changed between
them by what the faults that passed showed.

| run | the tree | faults | fail the tests | pass | not built |
| --- | --- | ---: | ---: | ---: | ---: |
| `results/cloud/campaign-run1.txt` | version `g`, as the 9700X first measured it (`scripts/mutants-run1.py`) | 122 | 96 | 11 | 15 |
| `campaign-run2.txt` | with the chunk's end's fix and the first new tests; the unbuilt faults written again (`mutants-run2.py`) | 124 | 117 | 6 | 1 |
| `campaign.txt` | the commit | 122 | 122 | 0 | 0 |

**A bound that did not hold.** Reading for one of run 1's faults (the list's count not reset where the waiting values
are forgotten) showed that a chunk's end kept the arguments of a cut call: a call that waits without room keeps its
place alone, and its arguments stayed in the front's list. The list has room for as many arguments as the arrays hold
records, 4,096. With 1,366 cut calls of three arguments waiting it passes that, and the writer has no test. No corpus
has such a text: the list held 218, 212 and 92 at most on `sqlite3.c`, Lua and musl. A cut value's arguments are no
longer kept: the list then holds an argument for a record the arrays hold, each a value taken
once. The most the list held at a chunk's end is counted, the command fails past its room, and
`node_facts_test_window_calls` (2,000 waiting calls of three arguments, 2,133 at most) reads it.

| the fault that passed | why | what changed |
| --- | --- | --- |
| an operator's first operand's cut not taken; its third's; a call's operand's (runs 1 and 2) | the room test's first form had some 25 chunk ends in its statements, and its second had ends at 19 of its group's 76 places: I had made the group's *acting* tokens an odd count, and a chunk is 1,024 tree tokens. And where an end fell, the rows often had room for a sum of three records: the room left depends on how many of the statement's values wait (`results/cloud/probes/keep7.txt`, each end's last waiting values) | the room test's operands are sums of nine records, cut at every end that finds them waiting, and its seven statements are 115 tokens, so 115 ends fall at each place in turn (`probes/keep9.txt`: 22 whole sums waiting, each cut) |
| a kept leaf's type not moved (runs 1 and 2) | the record it was moved over was no literal of another integer type, and the copy then decodes the literal again. Run 2's line for it was one record off | the wait test's condition is moved over twelve long's literals |
| a kept call's arguments not moved; its place in the list not updated (run 1) | no call was made before the kept ones in their chunk, so they were moved onto themselves | three calls before the condition |
| a kept literal's entry left at its old number (run 1) | nothing wrote that line again while the value waited | the body writes sixty literals' lines in a row, over it |
| a call's round taken from its last operand (run 1) | no call had an earlier operand that asks a later round than its last | `h2(y += 1, a)` |
| a literal the columns don't hold whole given a line (run 2; unbuilt in run 1) | no windowed test had one | `zc + 2.0i`: an imaginary literal's leaf is T's (`probes/im.c`) |
| an operator the kernel makes no record of given a class (run 2; unbuilt in run 1) | none stood over a made record in a windowed test | `__extension__ (a + a)` (`probes/ext.c`) |
| the list's count not reset where the waiting values are forgotten (run 1) | redundant once a cut value's arguments are not kept: the values are forgotten only where none kept a row | the reset is removed |
| a string taken for an integer's literal by its type's row (run 1) | redundant: a string's type is an array's | the test of the leaf's category is removed |
| a late type's words not taken again before a literal's or a string's line is made (runs 1 and 2); its row read without the rows' bound (run 2) | unreachable: a literal's type is a basic one, and every string's array is made when the unit's names are resolved, before the walk. Of the rare leaves of `sqlite3.c`, Lua, musl and the tests (2,046, 1,292, 4,460 and 2,215) none has a type past the machine's (`probes/fn.c` for a function's name) | both are removed |

- **The 15 faults that did not build in run 1** left a variable unused or a function uncalled, which the build
  refuses. Each is written again with the name still used; the one left in run 2 was a tautology.
- **The tests' counts are pinned:** each of the four generated texts pins its values kept whole, their records and the
  values cut, and two pin the most the calls' arguments' list held.


## 6. The sanitizer rows

`scripts/sanitizers.sh`, on the commit: for each row a Release build as CI's rows build it (`-O3`), `test-checker`'s
part 5, and for memory and address the shadow in three modes (`--passes 0 --front-window`, the same with
`--front-tests`, and `--passes 0 --front-facts`) on `sqlite3.c`, Lua and the compiler's own source.

**Running when this record was first pushed:** this section has the rows' results once they finish.


## Files

- `patches/0001-…patch`: the commit. `patches/window-h.patch`: what the 9700X built, against `eb0a76e21`.
  `patches/window-a.patch` to `window-g.patch`: the versions.
- `scripts`: the 9700X's `job.sh`, `job-short.sh` and `job-final.sh` and what they call (`setup.sh`, `corpora.sh`,
  `lock.sh`, `build-label.sh`, `turns.sh`, `compile.sh`, `perf.sh`, `tables.py`); the cloud container's
  `cloud-checks.sh`, `shadow-limited.sh`, `checker.sh`, `sanitizers.sh` (with this container's paths;
  `corpora-cloud.sh` is their inputs' file); the campaign's `mutants.py`, and `mutants-run1.py` and `mutants-run2.py`
  as its first two runs had it.
- `results/9700x`: a directory a version (`window-LABEL-CORPUS-N.txt`: the window; `window-warm-…`: with the arrays
  touched; `window-tests-…`: with the tests and C and X there; `facts-…`: the piece before in the same build;
  `perf-*`; `compile-*`), `base`, `tables.txt`, and the jobs' logs.
- `results/cloud`: `test-checker`, `shadow`, `sanitizers`, the campaign's three runs, the probes, and the
  self-check's, the self-parse's and the call graph's outputs.
