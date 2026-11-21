# The tests' holes and the objects' side (buster#2850's step 2), 2026-11-21

The evidence for the piece that runs the node machine's shadow over the compiler's own tests' programs and closes
what they show in the pieces before: [buster#3201](https://github.com/buster14a/buster/issues/3201),
[#3202](https://github.com/buster14a/buster/issues/3202), [#3203](https://github.com/buster14a/buster/issues/3203),
[#3205](https://github.com/buster14a/buster/issues/3205), [#3206](https://github.com/buster14a/buster/issues/3206)
and [#3207](https://github.com/buster14a/buster/issues/3207).
[The tests' specification](https://github.com/buster14a/buster/issues/3201#issuecomment-7058791784),
[the objects'](https://github.com/buster14a/buster/issues/3203#issuecomment-7059489314); the piece before,
[summary-facts-2850-2026-11-21](../summary-facts-2850-2026-11-21/). Nothing here is in a compile: every reading is
the shadow's (`measure-node-machine --shadow --passes 0 --window-rows`), whose status is 1 where reader time's answers
are not the pipeline's.

The code before is buster main `e77b3eba4`; the code here is `17a63b055`
(buster14a/buster#3213's first commit, on main).

## 1. The sweep (`sweep/`)

- `extract.py OUT_DIR TEST_FILE...` writes every C string literal of the test files that is a program as a file of
  its own (`inline/FILE-LINE-NUMBER.c`, listed in `inline-index.tsv`): 13,866 programs of
  `src/buster/compiler/*_test.c`, of which the compiler accepts 6,620 with no
  option. `tests.list` is `tests/`'s 1,229 files (408
  accepted).
- `sweep.py COMPILER OUT.tsv JOBS [OPTION...] < FILES` runs each file through the shadow: a line a file, `rejected`
  (the compiler does not accept it with these options), `clean` (status 0) or `found` (status 1).
  `run-sweep.sh TAG COMPILER` runs both lists under the three warning sets: none, `-Wall -Wextra`, and
  `-Weverything -Wno-c++-compat` (`-Wc++-compat` is a warning no test stands for, which refuses every expression).
  The three sets took 75 s on four cores with a Develop build.
- `classify.py COMPILER SWEEP.tsv... [-- OPTION...]` runs each found file again with `--list` and names its kinds
  from the report's difference lines.
- `fixture-lines.py COMPILER TEST_FILE NAME [OPTION...]` writes a fixture's text out of the test file and prints
  each annotated line with what the census did there.

| | the code before (`sweep/before/`) | the code here (`sweep/after/`) |
| --- | ---: | ---: |
| the tables' programs: rejected; clean; found, with no option | 7,246; 6,479; 141 | 7,246; 6,620; 0 |
| found with `-Wall -Wextra`; with `-Weverything -Wno-c++-compat` | 141; 141 | 0; 0 |
| `tests/`: rejected; clean; found, with no option | 821; 399; 9 | 821; 408; 0 |
| found with `-Wall -Wextra`; with `-Weverything -Wno-c++-compat` | 9; 9 | 0; 0 |

The kinds of the code before's 150 programs (`sweep/before/classes-*.txt`; the same under
each set; a program can have several):
74 object-declaration, 26 interrupt-call, 18 cleanup-return, 7 label-kept, 6 tape-entries, 5 callee-taken, 5 fact-words, 5 summaries, 4 noderef, 4 ordered-comparison, 3 declarator-event, 1 brace-kind, 1 diagnose-if, 1 label-missed and 1 window-tests.

`programs/programs.tar.xz` has the small programs the issues name and those written while reading each kind.

## 2. A trigger a warning (`triggers/`)

`triggers.py COMPILER OUT_DIR [PILE.tsv...]`: a program for each warning the census's table marks as tested, written
to warn (it must, with the piece of the compiler's message its entry names), or the first program of the sweep's
that shows the warning's event in an expression; each run through the shadow with its own options, with
`-Wall -Wextra` and with `-Weverything -Wno-c++-compat`. `before.txt` and `after.txt` are its lines:
93 warnings, 60 written and
32 from the sweep's programs on the code here (32
on the code before, where fewer events reach an expression's tokens), 1 with none
(`-Wavailability`: the compiler has x86_64-linux-gnu's predefines alone). Runs that differ:
2 warnings' before, 0 here.

## 3. The corpora (`corpora/`)

`sqlite3.c`, Lua 5.4.8, musl and the compiler's own source through the shadow, with no option and with
`-Wall -Wextra` (`sweep/run-corpora.sh`; `cloud/corpora.sh` has the units and their options): each run's report
(without the census's per-test lines) in `before/` and `after/`, and `compare-corpora.py BEFORE_DIR AFTER_DIR`'s
lines and table in `table.md`. Every count of what is taken is the code before's; what differs is the new lines'
counts and musl's expressions with nothing listed.

## 4. The generator's programs (`fuzz/`)

`fuzz-campaign.sh COMPILER OUT [COUNT]`: the side facts' record's generator (`../summary-facts-2850-2026-11-21/fuzz/fuzz.py`),
its six runs of 15,000 programs (seeds 61 to 66). On the code here 90,000 programs,
16,797 rejected, 73,203 clean, none found
(`run-6*.log`); on the code before 212 found
(`../summary-facts-2850-2026-11-21/fuzz/code/`).

## 5. The one-statement programs (`probes/`)

`probe.py COMPILER CASES` (a file a case, a line a case). `cases26.py` is the objects' side's
52 units; the earlier pieces' cases are the earlier records'. `before/` and `after/`
have every case's line: 8,009 lines, 33 that do not agree
before (all of `cases26`) and 0 here.

## 6. The faults (`faults/`)

`faults-holes.py TREE [N]` is the list as the last round ran it: with no N it checks that every fault applies once,
with N it applies fault N in place and prints its name. A fault is one term changed alone. `local-round.sh` (the
cloud container's mutation tree) and `job-faults-holes.sh` (the 9700X, each build and each run its own hold of the
lock) apply each fault, build Develop and run `test-checker --seed 133 --part 5/8`; `tally.py ROUND.txt...` joins
the two machines' verdicts by fault.

| round | the code (`code.patch` on main `e77b3eba4`) | faults | caught | survived | did not build |
| --- | --- | ---: | ---: | ---: | ---: |
| `round1/` | the two parts as first written | 104 | 67 | 30 | 7 |
| `round2/` | with the first round's lines and tests | 117 | 103 | 11 | 3 |
| `round3/` | **the code here** | 24 | 21 | 3 | 0 |

The first two rounds ran from the list's two ends at once (`cloud.txt`, `9700x.txt`), the third on the 9700X
alone. A mutant that did not build was a text the build refuses (a variable left unused, `x && !x`), written again
for the next round. Each round's list is its `faults.py`. The last round's survivors:
`ordered-any-other-operand`, `ordered-two-pointers-too` and `segment-unextended-asked`.

## 7. The 9700X (`9700x/`)

**Not read.** `job-xh.sh BEFORE AFTER PATCH REVISION RUNS SUFFIX` is the job written for it: two Release builds
(`build-label.sh`: main `e77b3eba4` as it is, and `final.patch` on it), and in each of seven readings
the build before, the build here twice, and the build before again, on `sqlite3.c`, Lua and musl, CPU 2, each run
its own hold of the lock; `xh-table.py BEFORE_DIR AFTER_DIR SUFFIX RUNS [JSON]` makes its table. It was queued behind
the third fault round and cancelled when the work was handed off; the 9700X's directory
`~/buster-fast-bench/2850-values-claude` has the build before (`results/xh0`) and the scripts.

## 8. The cloud container's checks (`cloud/`)

`h29-checker-summary.txt`: `test-checker --seed 133`, its eight parts, on a Develop build of the code's sources (each
with 0 failures). The checks' chain (`checks-rows.sh`: a Release build, the shadow's other modes, the complete
driver; `sanitizers-parts.sh`) was started on the code's commit and stopped when the work was handed off: the pull
request's CI is the check of record.

## 9. The write-ups' numbers (`generators/`)

`values.py` gathers every number above into `all.json`, and `fill.py TEMPLATE all.json [KEY=FILE...]` fills a
template's expressions from it: the design's section, the pull request's body and this file are made so, and a
`must(...)` beside a verdict fails the run where its numbers do not hold.
