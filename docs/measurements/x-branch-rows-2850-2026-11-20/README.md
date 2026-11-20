# The branches' rows on the window (buster#2850's step 2), 2026-11-20

The evidence for the piece that makes, on the front's window, what the node machine's X sweep writes for a statement's
condition evaluated as branches (`node_machine_classify_branches`'s states and `node_machine_branch_hook`'s entries):
a tested value's test and its branch. The piece before it is
[x-update-rows-2850-2026-11-20](../x-update-rows-2850-2026-11-20/), and the census its specification reads again is
[x-rows-census-2850-2026-11-19](../x-rows-census-2850-2026-11-19/).

## 1. Before the specification (`before/`)

**What the piece before left listed** (`before/before-counts.py` on that piece's final runs on the 9700X,
`../x-update-rows-2850-2026-11-20/final/9700x/xu8/rows-on1-CORPUS-1.txt`):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions C takes on the window | 49,155 | 9,909 | 39,712 |
| their tapes made today | 47,027 (95.67%) | 9,689 (97.78%) | 38,705 (97.46%) |
| **listed for X, first for an operator evaluated as branches** | 2,046 | 200 | 790 |
| the records C's loop evaluates as branches | 5,613 (1.75% of the records swept) | 570 (0.62% of the records swept) | 2,364 (0.63% of the records swept) |
| of them a statement's CONDITION | 2,198 | 230 | 877 |
| listed first for an update; a refused conversion; a constant to a floating class | 73; 1; 8 | 10; 0; 10 | 4; 20; 193 |

**One count, on the piece before's code** (`before/count.patch` on main `903bf7ef4`: that piece's source and, in its
shadow's loop over the listed expressions, a line of counts at exit). Of the expressions the rows list first for a
record evaluated as branches: those another record lists for another reason; and of the others, their records
evaluated as branches, the values those test (an operand of such a record that is none itself), and of those values
how many have a conversion's part of their own, a narrow class, each number of own entries and a row over eight
entries with the test's three or four. A Develop build on the 9700X (`before/dev-xr-develop.sh`), then
`measure-node-machine --shadow --passes 0 --window-rows` on `sqlite3.c`, Lua and musl, CPU 2, each run its own hold of
the lock (`before/dev-xr-corpora.sh`): `before/corpus-CORPUS.txt` are the runs' outputs and `before/9700x-count.txt`
their lines of counts, in the corpora's order. The compiler's own source's line is the cloud container's
(`before/cloud-own-count.txt`; `before/count-own.patch` has one count more, the expressions with a row over eight).
`before/count-table.py` makes the table; its rows after the second are of the expressions no other record lists:

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| **listed for X, first for a record evaluated as branches** | 2,046 | 200 | 790 | 3,217 |
| of them with another record that lists them | 0 | 1 | 0 | 0 |
| their records evaluated as branches; of them roots | 5,126; 2,046 | 465; 199 | 2,102; 790 | 8,668; 3,217 |
| the values those test | 4,860 | 428 | 1,814 | 7,941 |
| with a conversion's part of their own | 0 | 0 | 0 | 759 |
| of a narrow class (the test has four entries, and three otherwise) | 227 | 5 | 122 | 2,296 |
| own entries: none; one; two; three; four | 0; 4,509; 39; 312; 0 | 0; 419; 0; 9; 0 | 0; 1,651; 107; 56; 0 | 0; 7,645; 16; 280; 0 |
| a row over eight entries with the test; the expressions with one | 0; 0 | 0; 0 | 0; 0 | 759; 559 |

**The values with a conversion's part of their own** are a `const` bool's reads, which the lowering converts to bool
by four entries (a CONVERT to I32, a CONST, NE and a CONVERT to U8) before the test's four. One-statement programs
through the count's build (`before/probes/p1.c` to `p5.c`, `before/const-bool-probes.txt`): a `const _Bool`
parameter's and a `_Bool` member's through a pointer to const have the part, and a `_Bool`'s, a `char`'s and a
comparison's do not.

**The census's lines again** (`before/tested-values.py` on `../x-rows-census-2850-2026-11-19/second/census-*.tsv`: X
on T's columns, every expression it takes, where the count above is of those C takes on the window):

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| values an operator evaluated as branches tests | 4,970 | 607 | 1,994 | 9,367 |
| with a conversion before the test | 0 | 0 | 0 | 1,009 |
| the test and the branch: three entries | 4,740 | 600 | 1,867 | 6,629 |
| four (a narrow class's) | 230 | 7 | 127 | 2,738 |
| another number | 0 | 0 | 0 | 0 |
| own entries: 0 | 3 | 36 | 19 | 6 |
| own entries: 1 | 4,611 | 560 | 1,805 | 9,012 |
| own entries: 2 | 41 | 0 | 109 | 21 |
| own entries: 3 | 315 | 11 | 61 | 328 |
| own entries: 4 | 0 | 0 | 0 | 0 |
| rows over eight entries | 0 | 0 | 0 | 1,009 |
| a branch of kind 37 | 1,059 | 114 | 549 | 1,768 |
| a branch of kind 36 | 3,911 | 493 | 1,445 | 7,599 |
| operators evaluated as branches | 5,223 | 621 | 2,260 | 9,646 |

`before/gen-spec.py` made [the specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7037879405)'s
text of these lines (`before/spec-template.md`; `before/specification.md` is the text as posted). What the counts
found of a `const` bool's read is [buster14a/buster#3185](https://github.com/buster14a/buster/issues/3185).

## 2. The state at the hand-off (2026-11-20, 14:40 UTC)

The session that did this work handed it off here, at its user's request, before the final readings. The pull
request is [buster14a/buster#3190](https://github.com/buster14a/buster/pull/3190) (one signed commit,
`49acc5cf9`, on main `8a1b1a036`). Done, with its files below: the five builds and their readings, three fault rounds
to the end, the probes, the cloud container's checks and a sanitizer pass. **Left:** the seven final readings (a job
started on the 9700X at 14:34 UTC, below), the design's two sections in the docs, this README's sections from the
readings on, the pull request's body's numbers and the result note on #2850.

### The builds (`builds/`)

Five builds (`builds/9700x/xbN/`: each run's output, the executable's hash and its patch, `xbNx.patch`, the piece's
source at that point over main `00faef7dd`'s lineage with an experiment's switch, `BUSTER_TESTS_SKIP=1`, with which the
branches' template lists its expression and the sweep makes no second list, as the piece before had it).
`builds/job-xb.sh` builds one and reads it: in each reading that executable with the branches' rows on, off, the piece
before's executable (`xu8`, the record before this one; its runs in `builds/9700x/xu8/`) twice, then off and on, on
`sqlite3.c`, Lua and musl, CPU 2, each run its own hold of the lock. `builds/xb-table.py` makes a build's table
(`builds/xbN-table.txt`); `builds/functions.sh` read the rows' functions' sizes (`builds/functions.txt`). TSC ticks a
record swept: with the branches' rows, the median of the build's six runs with them on; more, the median of the
three readings' differences and their range:

| build | `sqlite3.c`, with the branches' rows | more than the piece before's | Lua, with them | more | the lists' and loops' code, bytes |
| --- | ---: | ---: | ---: | ---: | ---: |
| first: the second list in every chunk, a statement's CONDITION a turn of its own, the loop a function of its own | 5.40 | +0.60 (+0.59 to +0.63) | 6.83 | +0.70 (+0.70 to +0.81) | 2,648 |
| one timed region; the bit that lists written where it is set; the second list in a chunk that branches | 5.41 | +0.58 (+0.50 to +0.85) | 6.85 | +0.71 (+0.62 to +0.79) | 2,623 |
| a CONDITION takes no turn (the reader writes its sense at its operand); an operand's entries counted once | 5.40 | +0.59 (+0.54 to +0.73) | 7.02 | +0.94 (+0.75 to +1.08) | 2,662 |
| the lists' sweep's step in one copy, where the compiler had unrolled it by four | 5.29 | +0.47 (+0.46 to +0.53) | 6.58 | +0.51 (+0.42 to +0.55) | 1,740 |
| the branches' loop in the lists' function, its mask in a chunk that branches alone | 5.36 | +0.53 (+0.46 to +0.67) | 6.41 | +0.35 (+0.33 to +0.37) | 1,806 |

The fifth is the code before the fault rounds' changes, which touched the operand's rule (one mask for its shape and
its length), the narrow test (its upper bound alone), the chunk's guard (the operators with a turn) and the listed
expression's reason (the shadow's count alone). Its three readings put the cost within the specification's gate B3
(0.6 asked on `sqlite3.c`, 0.4 on Lua) on both; the final readings decide it for the code as it is. musl read -0.62
(-1.38 to +0.66).

### The faults (`faults/`)

Each term of an operand's rule and of an operator's turn, each of their stores, the second list's sweep, the chunk's
guard, the reader's sense, each new row of the tables and the listed expression's reason, changed alone
(`faults/make-faults-round1.py`, then `faults/make-faults.py`, which has a line for each fault that left the list and
why; `faults/faults-branch-roundN.py` are the rounds' lists). Each fault compiled first with `-fsyntax-only`
(`faults/syntax-check.sh`; `faults/syntax-round1/`, `syntax-round2/`). A round ran from the list's two ends at once:
on the 9700X (`faults/job-faults-branch.sh`, a tree of its own with `faults/xbfN.patch`, the tree as it is first, which
must pass, then a Develop build and `test-checker --seed 133 --part 5/8` a fault, each its own hold of the lock) and in
the cloud container (`faults/local-round.sh`). `faults/roundN.txt` is a line a fault with the machine that ran it
(where both ran one, they agree); `faults/raw/` has each machine's lines.

| round | faults | caught | survived | on the 9700X; in the cloud container |
| --- | ---: | ---: | --- | --- |
| 1 | 160 | 153 | `list-branching-with-two`, `list-count-not-ended`, `operand-narrow-with-void`, `turn-second-before-first`, `loop-before-the-updates`, `reason-a-root-tested`, `window-branches-count-of-roots` | 117; 43 |
| 2 | 159 | 157 | `reason-mark-of-its-conversion`, `reason-mark-other-way` | 111; 48 |
| 3 | 158 | 158 | none | 158; 0 |

- Round 1. Four change nothing a program reaches and left the list: `list-count-not-ended` (a count set to the lesser
  of itself and its block's end, which the turns' loop leaves no less), `loop-before-the-updates` (an update that is a
  tested value takes its own part from the one loop and its conversion's from the other, and each adds to the row's
  length: the two orders write the same), `turn-second-before-first` (two records, but a `!`'s one operand, whose two
  senses are the same) and `operand-narrow-with-void` (no tested value has void's class: the narrow test is by its
  upper bound alone now). Three changed code. `list-branching-with-two` and `window-branches-count-of-roots` passed
  because the chunk's guard counted the CONDITIONs, which take no turn: it counts the operators with a turn now, and
  the unit of one chunk with one condition fails the first fault (`faults/mutants/list-branching-with-two-on-the-turns-count.err`).
  `reason-a-root-tested` removed, from the listed expression's reason, the test that its record has a consumer
  before the read of that consumer's template: a build with a line for each listed record with no consumer
  (`faults/reason-probe/`) printed none on the three corpora and the fixture. The reason reads no consumer now.
- Round 2, both in the rewritten reason. `reason-mark-of-its-conversion` changes nothing (the tables give a
  destination with no room the mark in both parts) and left the list. `reason-mark-other-way` swapped the two
  reasons a record with the bit alone can have, and the fixture hid it: it listed 67 expressions for each, so the
  counts swapped were the same. The fixture got one more `const` bool condition, and the fault's build fails on it
  (`faults/mutants/reason-mark-other-way-with-the-line.err`), run before round 3.
- Round 3, on the pull request's code: every fault caught.

### The probes (`probes/`)

One-statement programs, each a file of its own (`probes/probe-again.py`, which also asks that no chunk's second run
differ from its first), on the cloud container's checks' build of the pull request's code: 286 conditions
(`probes/cases13.py`), 230 tested values that might have a conversion of their own (`probes/cases14.py`), and the
pieces' before, 618 (`probes/earlier.txt`, `cases9` to `cases12`). Lines that do not read as X on T's columns: 0.

### The cloud container's checks (`final/cloud-checks/`)

`checks-rows.sh` on the commit in `revision.txt` (the pull request's tree): a native Release build; `test-checker`'s
eight parts; the shadow with `--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with
`--window-rows` on the compiler's own source, with the default warnings and with `-Wall -Wextra`; the shadow's other
modes on `sqlite3.c` and Lua; the self-check, the self-parse, the call graph's two; the ownership check; the complete
driver's lists and parse. All pass (`progress.txt`) but the preprocessor's comparison with clang in the complete
driver's light list, which fails in this container on main too (its system clang is 23.1.6). With `--window-rows`
(`rows-counts.txt`):

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions C takes on the window | 49,158 | 9,909 | 39,712 | 40,193 |
| their tapes made | 49,076 (99.83%) | 9,888 (99.79%) | 39,495 (99.45%) | 39,451 (98.15%) |
| tapes that differ; not kept by the reference; chunks whose second run differs | 0; 0; 0 | 0; 0; 0 | 0; 0; 0 | 0; 0; 0 |
| listed for an update; for branches; a refused conversion; a constant to a floating class | 73; 0; 1; 8 | 10; 0; 0; 11 | 4; 0; 20; 193 | 129; 560; 22; 31 |

### The sanitizers (`final/cloud-sanitizers/`)

`sanitizers-parts.sh` on `9eb233772` (`revision.txt`), whose code is the pull request's but for three comments:
native memory, address and thread builds, `test-checker` part 5 under each, and under memory and address the shadow
with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source (`progress-9eb233772.txt`): no report. A second
pass on the pull request's commit was started and cut by the container's restart; it has no line.

### To finish (`final/generators/`)

1. **The final readings.** On the 9700X, `~/buster-fast-bench/2850-tests-claude/job-xb6.log` and
   `results/xb6/`, `results/xu8/xb6-base*` (`job-xb.sh xb6 xb6x.patch 00faef7dd 7`: `xb6x.patch`, here too, is the
   pull request's rows code over main `00faef7dd`'s lineage with the switch). When it prints `job finished`, fetch
   the two (tar over ssh) and run `builds/xb-table.py RESULTS xb6 > xb6-table.txt`.
2. **The docs.** `gen-docs.py FETCH xb6 ROUNDS CHECKS OUT` (FETCH has `xb1..xb6-table.txt`, the runs' folders and
   `functions.txt` with a line for xb6; ROUNDS is `faults/`; CHECKS is `final/cloud-checks` with the probes beside it)
   makes the two sections from `node-machine-section.md` and `one-core-path-section.md`; `apply-docs.py TREE OUT`
   puts them in `docs/node-machine.md` and `docs/one-core-path.md`, before "What it says of step 2" and "Step 4's
   first piece". Read each sentence against its numbers: the templates were written against the fifth build's.
3. **This README** from its third section on: `gen-readme.py RECORD TREE` (it expects the final readings in
   `final/9700x/xb6/`); `record-assemble.sh xb6` copies the files.
4. **The pull request's body and the note on #2850:** `gen-body.py VALUES CHECKS SAN TREE OUT` with
   `body-template.md`, `result-note-template.md` and `tests.md`; a second commit for the docs on the same branch.
