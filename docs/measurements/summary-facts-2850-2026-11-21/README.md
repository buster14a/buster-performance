# A summary node's side facts on the window (buster#2850's step 2), 2026-11-21

The evidence for the piece that makes, on the front's window, what the passes after the reader read below a full
expression's root: an expression's references and its root's return fact, for each expression whose tape X makes
whole, with the two cases listed where the program knows a branch's truth that its condition's value has not.
[Its specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7053609091); the census and the
survey before it, [summary-facts-census-2850-2026-11-20](../summary-facts-census-2850-2026-11-20/); the piece
before, [logical-values-2850-2026-11-20](../logical-values-2850-2026-11-20/). Nothing here is in a compile: every
reading is the shadow's (`measure-node-machine --shadow --passes 0 --window-rows`), which runs the window's sweeps
beside the reference and compares, and after the pipeline compares the side facts with the program's own walks.

The code is buster `4edc9e1cf`'s, which is buster14a/buster#3199's head `0dbba56f8` with
`final/9700x/xs6.patch` (the cloud checks ran on that commit; the pull request's third commit has its sources byte
for byte). It was frozen three times: `ef61e06f3` (`builds/xs4.patch`), `98c84a668` (`builds/xs5.patch`, after two
finds of section 4 and 5) and `4edc9e1cf` (after section 2's experiment).

## 1. The builds (`builds/`, `final/9700x/`)

Each build was read on the 9700X by `builds/job-xs.sh LABEL PATCH REVISION RUNS SUFFIX`: a Release build of PATCH
on REVISION (`build-label.sh`), and in each of RUNS readings the build with the facts, the same executable without
them twice (`--no-window-summaries`, the shadow's switch), and with them again, on `sqlite3.c`, Lua 5.4.8's 34 files
and musl's 1,336 units (`turns.sh`, `corpora.sh`), CPU 2, each run its own hold of the lock (`lock.sh`). A reading's
file is `TAG-CORPUS-SUFFIX-N.txt`, the shadow's own report. `xs-table.py DIRECTORY SUFFIX RUNS [JSON]` makes a
build's table: a line's median over the readings and their least and most, the facts on (the mean of a reading's two
runs) less the facts off. A timed region reads its own two timer reads too (27 ticks a chunk here): the sweep's ticks
are its region's with the facts less the same region's without them.

| build | its patch | readings | its table | its readings |
| --- | --- | --- | --- | --- |
| the first | `builds/xs1.patch` | 3 | `builds/xs1-table.md` | `builds/xs1-readings.tar.xz` |
| the second | `builds/xs2.patch` | 5 | `builds/xs2-table.md` | `builds/xs2-readings.tar.xz` |
| the third | `builds/xs3.patch` | 7 | `builds/xs3-table.md` | `builds/xs3-readings.tar.xz` |
| the code as first frozen | `builds/xs4.patch` | 7, and 15 more (`-b`) | `builds/xs4-table.md`, `builds/xs4-repeat-table.md` | `builds/xs4-readings.tar.xz` |
| the code as frozen a second time | `builds/xs5.patch` | 7, and 8 more | `builds/xs5-table.md`, `builds/xs5-repeat-table.md` | `builds/xs5-readings.tar.xz` |
| **the code** | `final/9700x/xs6.patch` | 7, and 8 more | `final/9700x/table.md`, `final/9700x/table-repeat.md` | `final/9700x/readings/` |

| build | the sweep, a record swept, a chunk's second run | a first run less a second, ticks a chunk | the tests' loop, more | the rows' sweeps with the facts, a second run, more | readings |
| --- | ---: | ---: | ---: | ---: | ---: |
| the masks, the lists and the counts' column; the references' mask by two compares of the kinds and two tests under a mask of the chunk's records; both lists compressed in every block; the reduction for every expression with a call that stops; the tests' loop's mask of plain callees from three columns (the operators, the standings, the lines' bytes) | 0.33, 0.49, 0.49 | 75, 217, 190 | +0.16, +0.16, +0.16 | +0.33, +0.54, +0.60 | 3 |
| the references' mask by a table's shuffle and one test, with no mask of the chunk's records (the tests' sweep writes a block's bytes whole); the calls' list only in a block that has one; the counts' stores aligned; the reduction only where the expression has an `&&`, an `||` or a `?:` | 0.26, 0.35, 0.34 | 109, 192, 219 | +0.09, +0.14, +0.47 | +0.29, +0.40, +0.43 | 5 |
| a line's byte's two bits a plain function's and a noreturn one's (they were a noreturn one's and an unknown name's): the tests' loop's test is one AND of the lines' bytes, with no standing read | 0.28, 0.35, 0.35 | 99, 184, 193 | +0.05, +0.00, +0.07 | +0.30, +0.44, +0.44 | 7 |
| the code as first frozen: the terms the first three fault rounds took out | 0.29, 0.36, 0.37 | 94, 179, 212 | +0.05, +0.08, -0.15 | +0.34, +0.46, +0.41 | 7 |
| a cast's term in C's loop and the value's column's choice, both in a run with the facts and without them alike | 0.27, 0.36, 0.39 | 86, 184, 196 | +0.14, +0.09, +0.05 | +0.31, +0.43, +0.48 | 7 |
| **the code here**: the objects by a gather of eight where a loop wrote them one a step | 0.27, 0.31, 0.31 | 68, 185, 167 | +0.12, +0.06, +0.67 | +0.34, +0.39, +0.36 | 7 |

(`sqlite3.c`, Lua and musl in each cell.)

The code's readings (7; `final/9700x/table.md`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records swept; chunks; records a chunk | 321,434; 611; 526 | 91,252; 241; 379 | 377,187; 2,975; 127 |
| expressions whose facts are kept; their references; the program's (a set an expression) | 49,839; 14,634; 14,502 | 10,246; 4,959; 4,918 | 40,441; 10,247; 9,391 |
| of them with an unknown for a return fact; with a stop | 250; 0 | 15; 112 | 64; 21 |
| records listed for a reference; calls asked a record at a time; expressions reduced | 14,911; 255; 0 | 5,128; 127; 0 | 11,522; 99; 0 |
| **the sweep, a record swept, a chunk's second run** | **0.27 (0.27 to 0.28)** | **0.31 (0.31 to 0.32)** | **0.31 (0.31 to 1.19)** |
| the sweep, a record swept, a first run | 0.41 (0.39 to 0.43) | 0.80 (0.78 to 0.81) | 1.70 (1.57 to 2.28) |
| the tests' records' bytes, a record swept, more with the facts (their one run) | -0.01 (-0.12 to +0.06) | -0.01 (-0.24 to +0.98) | -0.81 (-6.69 to +3.09) |
| the tests' loop, more (its one run) | +0.12 (-0.07 to +0.32) | +0.06 (+0.01 to +1.22) | +0.67 (-1.20 to +4.47) |
| **the three together, the sweep by its second run** | **+0.40 (+0.17 to +0.47)** | **+0.32 (+0.18 to +2.52)** | **+1.01 (-5.70 to +5.54)** |
| the three together, the sweep by its first run | +0.55 (+0.29 to +0.61) | +0.81 (+0.68 to +3.00) | +2.33 (-3.74 to +7.00) |
| **the sweep, a first run less a second, ticks a chunk** | **68 (63 to 80)** | **185 (178 to 186)** | **167 (86 to 249)** |
| the sweep, ticks a chunk: a first run; a second | 215 (207 to 226); 144 (143 to 147) | 304 (295 to 306); 119 (116 to 122) | 216 (199 to 290); 40 (39 to 151) |
| the tests' bytes and loop, ticks a chunk, more | +66 (-60 to +104) | +2 (-46 to +834) | +89 (-763 to +663) |
| **the rows' sweeps, the facts' among them, a record swept, a second run, more** | **+0.34 (+0.31 to +0.38)** | **+0.39 (-0.18 to +0.40)** | **+0.36 (-0.39 to +1.14)** |
| **the rows' sweeps, the facts' among them, a first run less a second, ticks a chunk, more** | **+23 (-44 to +64)** | **+115 (-11 to +372)** | **+232 (-1 to +248)** |
| the rows' other sweeps, a second run, more | +0.06 (+0.03 to +0.10) | +0.07 (-0.49 to +0.07) | +0.03 (-0.70 to +0.26) |
| of them the turns' lists and loops, where the listing is | +0.01 (-0.01 to +0.02) | +0.00 (-0.02 to +0.02) | -0.01 (-0.03 to +0.00) |
| the rows' other sweeps, a first run less a second, ticks a chunk, more | -47 (-117 to +0) | -70 (-189 to +188) | +60 (-156 to +81) |
| C's sweeps, a second run, more; a first run less a second, ticks a chunk, more | +0.01 (-0.03 to +0.06); +20 (-86 to +111) | +0.01 (-0.43 to +0.05); +7 (-37 to +61) | -0.06 (-1.40 to +0.28); +54 (-185 to +229) |
| the kernel in place, more | +0.01 (-0.05 to +0.14) | +0.01 (-0.41 to +0.40) | +0.01 (-0.78 to +0.10) |
| the tests' other parts, more | -0.02 (-0.27 to +0.20) | -0.43 (-2.81 to +0.71) | +2.14 (-1.49 to +2.94) |
| the rows' sweeps without the facts, a record swept: a first run; a second | 8.82 (8.58 to 9.11); 6.27 (6.25 to 6.30) | 12.42 (12.20 to 13.06); 6.71 (6.65 to 7.23) | 24.27 (23.53 to 25.94); 8.14 (8.03 to 8.77) |
| the timed region with no sweep in it, ticks a chunk | 27.0 (26.6 to 30.1) | 26.9 (25.6 to 28.6) | 27.4 (27.1 to 27.8) |

**The tests' sweeps read by the build.** With the facts and without them each of the tests' two sweeps is another
copy of its code (`node_tests_window_bytes_by`'s and `node_tests_window_loop_by`'s forms), so the switch reads one
copy's place in the executable against the other's. Their bytes and loop together, ticks a chunk more with the facts
on `sqlite3.c`: +41 (-84 to +122) and +38 (-85 to +128)
in the first frozen build's two sets, +181 (-94 to +423) and
+140 (+61 to +316) in the second's, +66 (-60 to +104) and
+87 (+21 to +142) in the code's. The first two builds' tests' sweeps differ by one
mask's operation, and the second and the third by nothing.

## 2. The experiments (`experiments/`)

Two builds of the second frozen code with a switch read from the environment (`BUSTER_SUMMARY_EXPERIMENT`), not for
a commit: `xse1.patch` (1: no objects' loop; 2: the objects by a gather of eight quadwords; 3: no call asked) by
`job-xse.sh`, 5 readings, `xse-table.py`; and `xse2.patch` (2: the gather of eight; 4: a gather of sixteen
doublewords) by `job-xse2.sh`, 7 readings, `xse2-table.py`. In a reading each setting runs in turn in one executable,
the code as it was first and last.

`xse1-table.md`:

| | `sqlite3.c` | Lua |
| --- | ---: | ---: |
| records swept; records listed for a reference; calls asked | 321,434; 14,911; 255 | 91,252; 5,128; 127 |
| the sweep as it is, a record swept, a chunk's second run (a region's two timer reads in it) | 0.34 (0.33 to 0.61) | 0.44 (0.43 to 0.44) |
| the same executable and setting twice in a reading, the second less the first | -0.02 (-0.51 to -0.01) | -0.00 (-0.01 to +0.01) |
| **with no objects' loop, more** | **-0.09 (-0.35 to -0.09)** | **-0.11 (-0.12 to -0.11)** |
| **with the objects by a gather of eight, more** | **+0.01 (-0.25 to +0.02)** | **-0.04 (-0.05 to -0.02)** |
| with no call asked, more | -0.02 (-0.29 to -0.01) | -0.04 (-0.05 to -0.03) |
| a first run: with no objects' loop, more; with the gather, more; with no call asked, more | -0.12 (-0.35 to -0.12); -0.05 (-0.26 to -0.03); -0.06 (-0.30 to -0.02) | -0.15 (-0.17 to -0.14); -0.07 (-0.10 to -0.00); -0.13 (-0.22 to -0.08) |

`xse2-table.md`:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| records listed for a reference; a chunk | 14,911; 24.4 | 5,128; 21.3 | 11,522; 3.9 |
| the sweep with the loop, a record swept, a chunk's second run (a region's two timer reads in it) | 0.33 (0.32 to 0.34) | 0.44 (0.44 to 0.45) | 0.68 (0.68 to 0.73) |
| the same executable and setting twice in a reading, the second less the first | +0.01 (-0.01 to +0.02) | -0.00 (-0.01 to +0.02) | -0.01 (-0.09 to +0.01) |
| **with a gather of eight quadwords, more** | **+0.00 (-0.00 to +0.09)** | **-0.07 (-0.08 to -0.05)** | **-0.14 (-0.19 to -0.13)** |
| with a gather of sixteen doublewords, more | +0.06 (+0.04 to +0.08) | -0.06 (-0.07 to -0.05) | -0.15 (-0.20 to -0.14) |
| a first run: with the loop | 0.64 (0.59 to 0.65) | 1.29 (1.27 to 1.32) | 2.71 (2.35 to 3.60) |
| **a first run: with a gather of eight, more** | **-0.04 (-0.07 to +0.02)** | **-0.06 (-0.10 to +0.01)** | **-0.40 (-0.84 to -0.27)** |
| a first run: with a gather of sixteen, more | -0.01 (-0.07 to +0.02) | -0.11 (-0.14 to +0.86) | -0.60 (-1.13 to -0.49) |

The gather of eight became the code. `profile/` is what came before the experiments: a `perf record` of the whole
run, in which the sweep is 0.02% and 0.01% of the samples, too few to split it (`profile-xs4.sh`).

## 3. The cloud container's runs of the code's commit (`final/cloud/`)

`chain.sh` runs, one heavy thing at a time: `checks-rows.sh` (a native Release build; `test-checker`'s eight parts;
the shadow with `--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the
compiler's own source, with the default warnings and with `-Wall -Wextra`; the shadow's other modes; the self-check,
the self-parse, the call graph's two checks, the ownership check; the complete driver's lists and parse), every
probe (section 4), the generator (section 5), the regression programs (section 6), the faults from the list's end
down (section 7) and the sanitizers' native rows (`sanitizers-parts.sh`). `checks/progress.txt` is their record.

- `test-checker`: 8 of 8 parts with status 0, 843,646 checks (210,456 in part 5, the node machine's).
- The shadow: 14 of 14 runs with status 0 (`checks/shadow/`, each run's report less the census's own lines); the other modes 22 of 22.
- The complete driver: its light list ends with status 1 on one of four commands, the preprocessor's comparison with clang, whose differing units differ by where their line markers place a token (this container's clang's resource directory), as on the pieces before; the heavy list and the parse end with status 0.

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions whose facts are kept and compared | 49,842 | 10,246 | 40,441 | 41,890 |
| the piece before's takes on the same inputs; left out by the turns' listing | 49,845; 3 | 10,248; 2 | 40,444; 3 | 41,890; 0 |
| casts listed for a truth their value has not | 0 | 0 | 0 | 0 |
| the program's references of the kept; reader time's (an object once a leaf) | 14,506; 14,638 | 4,918; 4,959 | 9,391; 10,247 | 13,365; 13,559 |
| with an unknown; with a stop | 250; 0 | 15; 112 | 64; 21 | 15; 30 |
| calls asked a record at a time; expressions reduced | 255; 0 | 127; 0 | 99; 0 | 63; 18 |
| branches' conditions asked their truth; with a truth; constants folded | 11,902; 53; 3,028 | 1,536; 0; 550 | 7,204; 237; 1,643 | 8,218; 1; 5,631 |
| differences: references, facts, truths, folds; not kept; second runs | 0, 0, 0, 0; 0; 0 | 0, 0, 0, 0; 0; 0 | 0, 0, 0, 0; 0; 0 | 0, 0, 0, 0; 0; 0 |

The sanitizers' native rows (memory, address and thread: a Release build each, `test-checker`'s part 5, and for
memory and address the shadow with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source):
12 of 12 steps with status 0, 0 reports (`sanitizers/`).

## 4. The one-statement programs (`probes/`)

`probe.py COMPILER CASES` runs each case of a cases' file, a file of its own, through the shadow and prints a line a
case; `run.sh COMPILER OUT` runs every cases' file, the pieces before's (in their records) and this one's
(`cases22.py`: references, calls, stops and truths, and statements at each lane of a block; `cases23.py`: the walks'
other sources of a reference, the builtins that stop, the library's builtins; `cases24.py`: a branch's condition
whose truth may be known through a cast, a conversion or a `!`; `cases25.py`: a `constexpr` object's leaf, with
`-std=c23`). On the code: 7,957 programs, 1,543 of them this piece's,
7,957 that agree (`out/`).

`first-frozen/` is what found the cast: the first frozen build's run of the pieces before's programs
(`summary.txt`: one line that does not agree, `cases11.txt`'s `condition`: `if ((char)(long)&global_outer.inner.second)`),
and `cases24-truths.txt`, the conditions of `cases24.py` on that build (`probe-truth.py`): which forms differ, which
agree and which the window does not keep.

## 5. The generator of programs (`fuzz/`)

`fuzz.py COMPILER SEED COUNT OUT [OPTIONS...]` writes random one-statement programs (integer, pointer and floating
operands of each operator, weighted toward constants, addresses and casts) and runs each through the shadow, whose
exit status is the oracle: a program whose run reports a comparison that is not zero is kept with its signature in
`found.txt`; one the compiler rejects is counted and dropped. In its environment: `FUZZ_SEVERAL` (two to six
statements), `FUZZ_PAD` (0 to 69 statements before, for a block's lanes), `FUZZ_PRAGMA` (`FENV_ACCESS`), and
`FUZZ_SLOPPY=P` (a share P of operands of another kind). `classify.py` reads the compiler's own warnings of the
found programs.

| campaign | the build | programs | rejected | that differ | by what |
| --- | --- | ---: | ---: | ---: | --- |
| `first-frozen/` | the code as first frozen | 18,000 | 891 | 82 | 68 a truth through a cast, 14 a constant's value of an object's record |
| `two-fixes-wrong-kind/` | that code with the two fixes, operands of the wrong kind | 60,000 | 12,687 | 423 | the reader-time tests' takes with a warning (buster#3201): every one |
| `code/` | the code | 90,000 | 11,016 | 212 | buster#3201's, every one: 167 an ordered comparison alone, 44 a cast alone, 1 both |

(`two-fixes/`, `two-fixes-again/` and `second-frozen/` are the campaigns between: their logs and finds.) The code's
campaign is six runs of 15,000: seeds 61 to 64 with operands of the right kind (plain, several statements with
padding, the pragma, `-Wall -Wextra`), which read 1
that differ, and seeds 65 and 66 with a share of the wrong kind, 211.

## 6. The repository's regression programs (`regression-programs/`)

`run.py COMPILER < list` runs each of buster's `tests/**/*.c` through the shadow, a file a run, with no option:
1,229 programs, 821 the compiler rejects so
(they need options or are diagnostics' tests), 408 that run.

| | end with status 1 | which |
| --- | ---: | --- |
| main `549613156` (`main-549613156.txt`) | 13 | 4 by a constant's value of an object's record (`tests/checker/sources/0013.c`, `0014.c`, `0021.c`, `0022.c`: `_Bool b = (_Bool)&s;`), 2 by a `return` under a cleanup (buster#3202), 7 by a multiversioned function's object (buster#3203) |
| the code (`code.txt`) | 9 | buster#3202's 2 and buster#3203's 7 |

## 7. The fault rounds (`faults/`)

A fault is one edit of the piece's code, a term changed alone (`faults-sides.py TREE [N]`: the final list,
142 faults; `faults-sides-round1.py` and `faults-sides-round3.py` are the list
as the first round and the third ran it). A round is, a fault, a Develop build and `test-checker --seed 133 --part
5/8`, run from the list's two ends at once: the 9700X from the first up (`job-faults-values.sh`, each build and each
run its own hold of the lock) and the cloud container from the last down (`local-round.sh`). `faults-tally.py
DIRECTORY ROUNDS` joins the two machines' files by a fault's name and fails where the two disagree (`tally.json`).

| round | the code | faults | caught | survived | did not build | on both machines |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | the third build's, with its comments (`xsf1.patch`) | 126 | 102 | 12 | 12 | 13 |
| 2 (`round2-indices.txt`) | the same with the first round's changes (`xsf2.patch`) | 26 | 22 | 3 | 1 | 3 |
| 3 (`round3-indices.txt`) | `ef61e06f3`, the first freeze (`xsf3.patch`, which is `builds/xs4.patch`) | 13 | 13 | 0 | 0 | 4 |
| 4, the cast's term's and the value's column's | the two fixes, in the cloud container alone | 17 | 15 | 2 | 0 | 0 |
| **5, the whole list** | **the code, `4edc9e1cf`** | **142** | **141** | **1** | 0 | 6 |

- **Round 1's survivors** (`again-no-objects`, `asked-given-an-object`, `asked-literal-symbol`, `asked-object-alone`, `branch-lists-a-not-too`, `call-not-through-a-dereference`, `call-not-through-an-address`, `reduce-any-consumer`, `reduce-joined-not-cleared`, `reduce-second-arm-alone`, `suspect-any-expression`, `suspect-reduction-from-the-second`): five terms
  the window's rules imply, out of the code (`branch-lists-a-not-too`, `call-not-through-a-dereference`,
  `call-not-through-an-address`, `suspect-any-expression`, `reduce-any-consumer`); two entries of the references'
  table no record reaches, simplified away (`asked-literal-symbol`, `asked-object-alone`); three that found a line
  of the fixture or a turn of the control (`reduce-second-arm-alone`, `reduce-joined-not-cleared`,
  `again-no-objects`); and two that change nothing a program reaches (`asked-given-an-object`,
  `suspect-reduction-from-the-second`). `first-round-survivors-on-the-inputs/` is ten of them run on the four
  inputs (`corpus-mutant.sh`): none is separated there.
- **Round 2's** (`compare-no-count`, `suspect-any-number`, `suspect-reduction-from-the-second`): the control kept a
  reference more of an object's number that could be the expression's own, closed for round 3;
  `suspect-any-number` was the list's own rewording of an equal test, dropped.
- **Round 4's** (`passed-unplaced-counted`, `value-no-name-s-object`): both terms are out of
  the code. Its last two faults ran a second time alone (`cloud-round4.txt` has those verdicts): a build of the
  session's in the same tree had spoiled the first run's. Its list was the final one's first seventeen with these
  two among them.
- `cloud-the-gather-s-eight.txt`: the gather's eight faults, run before the third freeze; all are in round 5.
- **Round 5's one survivor**, `suspect-reduction-from-the-second`: the reduction started at its operand's second
  record. An operand's first record is a leaf, which has no fact of its own and joins none to its consumer's.

## 8. The holes filed (`holes/`)

- buster#3201: `3201-table.py COMPILER` makes that issue's table (a statement, the reader-time tests' take, the
  compiler's warning).
- buster#3202: `3202-m1.c` to `3202-m7.c`, the issue's programs.
- buster#3204: `3204-w1.c` to `3204-w11.c`, the issue's conditions.
- `value-of-a-constant-with-an-object.c`: `local = (_Bool)&g;`, the statement this piece fixes.
- buster#3203's programs are buster's own (`tests/checker/sources/0396.c` and six more).

## 9. The write-ups (`generators/`)

Every number in buster's `docs/node-machine.md` and `docs/one-core-path.md` sections, the pull request's and the
result note is from a file here: `values.py KEY=PATH...` reads the tables' JSON files, the checks' directory, the
census's record, the faults' tally, the probes', the generator's and the regression programs' outputs into
`out/all.json`; `fill.py TEMPLATE all.json [KEY=FILE...]` fills a template's expressions (between doubled braces) from it, and
fails where a verdict's own condition (`must(...)`) does not hold; `wrap.py` wraps the result as the documents are
wrapped; `assemble-docs.py` places the two sections in the tree. The templates are the `.md` files here, and
`out/` what they made.
