# A summary node's side facts on the window (buster#2850's step 2), 2026-11-21

The evidence for the piece that makes, on the front's window, what the passes after the reader read below a full
expression's root: an expression's references and its root's return fact, for each expression whose tape X makes
whole, with the two cases listed where the program knows a branch's truth that its condition's value has not.
[Its specification](https://github.com/buster14a/buster/issues/2850#issuecomment-7053609091); the census and the
survey before it, [summary-facts-census-2850-2026-11-20](../summary-facts-census-2850-2026-11-20/); the piece
before, [logical-values-2850-2026-11-20](../logical-values-2850-2026-11-20/). Nothing here is in a compile: every
reading is the shadow's (`measure-node-machine --shadow --passes 0 --window-rows`), which runs the window's sweeps
beside the reference and compares, and after the pipeline compares the side facts with the program's own walks.

The code is buster `{{=v['checks']['revision']}}`'s, which is buster14a/buster#3199's head `0dbba56f8` with
`final/9700x/xs6.patch` (the cloud checks ran on that commit; the pull request's third commit has its sources byte
for byte). It was frozen three times: `ef61e06f3` (`builds/xs4.patch`), `98c84a668` (`builds/xs5.patch`, after two
finds of section 4 and 5) and `{{=v['checks']['revision']}}` (after section 2's experiment).

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

{{file:builds}}

The code's readings ({{=v['final']['sqlite3']['runs']}}; `final/9700x/table.md`):

{{file:table}}

**The tests' sweeps read by the build.** With the facts and without them each of the tests' two sweeps is another
copy of its code (`node_tests_window_bytes_by`'s and `node_tests_window_loop_by`'s forms), so the switch reads one
copy's place in the executable against the other's. Their bytes and loop together, ticks a chunk more with the facts
on `sqlite3.c`: {{=srng('sqlite3', 'tests_two_chunk', 0, 'xs4')}} and {{=srng('sqlite3', 'tests_two_chunk', 0, 'xs4b')}}
in the first frozen build's two sets, {{=srng('sqlite3', 'tests_two_chunk', 0, 'xs5')}} and
{{=srng('sqlite3', 'tests_two_chunk', 0, 'xs5b')}} in the second's, {{=srng('sqlite3', 'tests_two_chunk', 0)}} and
{{=srng('sqlite3', 'tests_two_chunk', 0, 'repeat')}} in the code's. The first two builds' tests' sweeps differ by one
mask's operation, and the second and the third by nothing.

## 2. The experiments (`experiments/`)

Two builds of the second frozen code with a switch read from the environment (`BUSTER_SUMMARY_EXPERIMENT`), not for
a commit: `xse1.patch` (1: no objects' loop; 2: the objects by a gather of eight quadwords; 3: no call asked) by
`job-xse.sh`, 5 readings, `xse-table.py`; and `xse2.patch` (2: the gather of eight; 4: a gather of sixteen
doublewords) by `job-xse2.sh`, 7 readings, `xse2-table.py`. In a reading each setting runs in turn in one executable,
the code as it was first and last.

`xse1-table.md`:

{{file:experiment1}}

`xse2-table.md`:

{{file:experiment}}

The gather of eight became the code. `profile/` is what came before the experiments: a `perf record` of the whole
run, in which the sweep is 0.02% and 0.01% of the samples, too few to split it (`profile-xs4.sh`).

## 3. The cloud container's runs of the code's commit (`final/cloud/`)

`chain.sh` runs, one heavy thing at a time: `checks-rows.sh` (a native Release build; `test-checker`'s eight parts;
the shadow with `--window-rows` and `--window-contexts` on `sqlite3.c`, Lua and musl and with `--window-rows` on the
compiler's own source, with the default warnings and with `-Wall -Wextra`; the shadow's other modes; the self-check,
the self-parse, the call graph's two checks, the ownership check; the complete driver's lists and parse), every
probe (section 4), the generator (section 5), the regression programs (section 6), the faults from the list's end
down (section 7) and the sanitizers' native rows (`sanitizers-parts.sh`). `checks/progress.txt` is their record.

- `test-checker`: {{=v['checks']['parts_ok']}} of {{=v['checks']['parts']}} parts with status 0, {{=n(v['checks']['checks'])}} checks ({{=n(v['checks']['part5'])}} in part 5, the node machine's).
- The shadow: {{=v['checks']['shadow_ok']}} of {{=v['checks']['shadow_runs']}} runs with status 0 (`checks/shadow/`, each run's report less the census's own lines); the other modes {{=v['checks']['mode_ok']}} of {{=v['checks']['mode_runs']}}.
- The complete driver: its light list ends with status 1 on one of four commands, the preprocessor's comparison with clang, whose differing units differ by where their line markers place a token (this container's clang's resource directory), as on the pieces before; the heavy list and the parse end with status 0.

| | `sqlite3.c` | Lua | musl | the compiler's own source |
| --- | ---: | ---: | ---: | ---: |
| expressions whose facts are kept and compared | {{=cloud('sqlite', 'kept')}} | {{=cloud('lua', 'kept')}} | {{=cloud('musl', 'kept')}} | {{=cloud('main', 'kept')}} |
| the piece before's takes on the same inputs; left out by the turns' listing | {{=cloud('sqlite', 'before_taken')}}; {{=cloud('sqlite', 'left_out')}} | {{=cloud('lua', 'before_taken')}}; {{=cloud('lua', 'left_out')}} | {{=cloud('musl', 'before_taken')}}; {{=cloud('musl', 'left_out')}} | {{=cloud('main', 'before_taken')}}; {{=cloud('main', 'left_out')}} |
| casts listed for a truth their value has not | {{=cloud('sqlite', 'passed')}} | {{=cloud('lua', 'passed')}} | {{=cloud('musl', 'passed')}} | {{=cloud('main', 'passed')}} |
| the program's references of the kept; reader time's (an object once a leaf) | {{=cloud('sqlite', 'program_references')}}; {{=cloud('sqlite', 'kept_references')}} | {{=cloud('lua', 'program_references')}}; {{=cloud('lua', 'kept_references')}} | {{=cloud('musl', 'program_references')}}; {{=cloud('musl', 'kept_references')}} | {{=cloud('main', 'program_references')}}; {{=cloud('main', 'kept_references')}} |
| with an unknown; with a stop | {{=cloud('sqlite', 'unknown')}}; {{=cloud('sqlite', 'stop')}} | {{=cloud('lua', 'unknown')}}; {{=cloud('lua', 'stop')}} | {{=cloud('musl', 'unknown')}}; {{=cloud('musl', 'stop')}} | {{=cloud('main', 'unknown')}}; {{=cloud('main', 'stop')}} |
| calls asked a record at a time; expressions reduced | {{=cloud('sqlite', 'suspects')}}; {{=cloud('sqlite', 'reduced')}} | {{=cloud('lua', 'suspects')}}; {{=cloud('lua', 'reduced')}} | {{=cloud('musl', 'suspects')}}; {{=cloud('musl', 'reduced')}} | {{=cloud('main', 'suspects')}}; {{=cloud('main', 'reduced')}} |
| branches' conditions asked their truth; with a truth; constants folded | {{=cloud('sqlite', 'conditions')}}; {{=cloud('sqlite', 'truths')}}; {{=cloud('sqlite', 'folds')}} | {{=cloud('lua', 'conditions')}}; {{=cloud('lua', 'truths')}}; {{=cloud('lua', 'folds')}} | {{=cloud('musl', 'conditions')}}; {{=cloud('musl', 'truths')}}; {{=cloud('musl', 'folds')}} | {{=cloud('main', 'conditions')}}; {{=cloud('main', 'truths')}}; {{=cloud('main', 'folds')}} |
| differences: references, facts, truths, folds; not kept; second runs | {{=join([str(x) for x in v['cloud']['sqlite']['differences']], ', ')}}; {{=cloud('sqlite', 'unkept')}}; {{=cloud('sqlite', 'again')}} | {{=join([str(x) for x in v['cloud']['lua']['differences']], ', ')}}; {{=cloud('lua', 'unkept')}}; {{=cloud('lua', 'again')}} | {{=join([str(x) for x in v['cloud']['musl']['differences']], ', ')}}; {{=cloud('musl', 'unkept')}}; {{=cloud('musl', 'again')}} | {{=join([str(x) for x in v['cloud']['main']['differences']], ', ')}}; {{=cloud('main', 'unkept')}}; {{=cloud('main', 'again')}} |

The sanitizers' native rows (memory, address and thread: a Release build each, `test-checker`'s part 5, and for
memory and address the shadow with `--window-rows` on `sqlite3.c`, Lua and the compiler's own source):
{{file:sanitizers}} (`sanitizers/`).

## 4. The one-statement programs (`probes/`)

`probe.py COMPILER CASES` runs each case of a cases' file, a file of its own, through the shadow and prints a line a
case; `run.sh COMPILER OUT` runs every cases' file, the pieces before's (in their records) and this one's
(`cases22.py`: references, calls, stops and truths, and statements at each lane of a block; `cases23.py`: the walks'
other sources of a reference, the builtins that stop, the library's builtins; `cases24.py`: a branch's condition
whose truth may be known through a cast, a conversion or a `!`; `cases25.py`: a `constexpr` object's leaf, with
`-std=c23`). On the code: {{=n(v['probes']['cases'])}} programs, {{=n(v['probes']['piece'])}} of them this piece's,
{{=n(v['probes']['agree'])}} that agree (`out/`).

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
| `first-frozen/` | the code as first frozen | {{=n(v['fuzz']['first']['programs'])}} | {{=n(v['fuzz']['first']['rejected'])}} | {{=n(v['fuzz']['first']['found'])}} | {{=n(v['fuzz']['first']['truth'])}} a truth through a cast, {{=n(v['fuzz']['first']['value'])}} a constant's value of an object's record |
| `two-fixes-wrong-kind/` | that code with the two fixes, operands of the wrong kind | {{=n(v['fuzz']['sloppy']['programs'])}} | {{=n(v['fuzz']['sloppy']['rejected'])}} | {{=n(v['fuzz']['sloppy']['found'])}} | the reader-time tests' takes with a warning (buster#3201): every one |
| `code/` | the code | {{=n(v['fuzz']['final']['programs'])}} | {{=n(v['fuzz']['final']['rejected'])}} | {{=n(v['fuzz']['final']['found'])}} | buster#3201's, every one: {{=n(v['fuzz']['final']['classes']['ordered'])}} an ordered comparison alone, {{=n(v['fuzz']['final']['classes']['cast'])}} a cast alone, {{=n(v['fuzz']['final']['classes']['both'])}} both |

(`two-fixes/`, `two-fixes-again/` and `second-frozen/` are the campaigns between: their logs and finds.) The code's
campaign is six runs of 15,000: seeds 61 to 64 with operands of the right kind (plain, several statements with
padding, the pragma, `-Wall -Wextra`), which read {{=n(sum(v['fuzz']['final']['variants'][s]['found'] for s in ('61', '62', '63', '64')))}}
that differ, and seeds 65 and 66 with a share of the wrong kind, {{=n(sum(v['fuzz']['final']['variants'][s]['found'] for s in ('65', '66')))}}.

## 6. The repository's regression programs (`regression-programs/`)

`run.py COMPILER < list` runs each of buster's `tests/**/*.c` through the shadow, a file a run, with no option:
{{=n(v['tests']['final']['programs'])}} programs, {{=n(v['tests']['final']['rejected'])}} the compiler rejects so
(they need options or are diagnostics' tests), {{=n(v['tests']['final']['ran'])}} that run.

| | end with status 1 | which |
| --- | ---: | --- |
| main `549613156` (`main-549613156.txt`) | {{=n(v['tests']['main']['found'])}} | {{=n(v['tests']['main']['rows'])}} by a constant's value of an object's record (`tests/checker/sources/0013.c`, `0014.c`, `0021.c`, `0022.c`: `_Bool b = (_Bool)&s;`), {{=n(v['tests']['main']['cleanup'])}} by a `return` under a cleanup (buster#3202), {{=n(v['tests']['main']['objects'])}} by a multiversioned function's object (buster#3203) |
| the code (`code.txt`) | {{=n(v['tests']['final']['found'])}} | buster#3202's {{=n(v['tests']['final']['cleanup'])}} and buster#3203's {{=n(v['tests']['final']['objects'])}} |

## 7. The fault rounds (`faults/`)

A fault is one edit of the piece's code, a term changed alone (`faults-sides.py TREE [N]`: the final list,
{{=n(v['faults']['round5']['faults'])}} faults; `faults-sides-round1.py` and `faults-sides-round3.py` are the list
as the first round and the third ran it). A round is, a fault, a Develop build and `test-checker --seed 133 --part
5/8`, run from the list's two ends at once: the 9700X from the first up (`job-faults-values.sh`, each build and each
run its own hold of the lock) and the cloud container from the last down (`local-round.sh`). `faults-tally.py
DIRECTORY ROUNDS` joins the two machines' files by a fault's name and fails where the two disagree (`tally.json`).

| round | the code | faults | caught | survived | did not build | on both machines |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| 1 | the third build's, with its comments (`xsf1.patch`) | {{=v['faults']['round1']['faults']}} | {{=v['faults']['round1']['caught']}} | {{=v['faults']['round1']['survived']}} | {{=v['faults']['round1']['not_built']}} | {{=v['faults']['round1']['on_both']}} |
| 2 (`round2-indices.txt`) | the same with the first round's changes (`xsf2.patch`) | {{=v['faults']['round2']['faults']}} | {{=v['faults']['round2']['caught']}} | {{=v['faults']['round2']['survived']}} | {{=v['faults']['round2']['not_built']}} | {{=v['faults']['round2']['on_both']}} |
| 3 (`round3-indices.txt`) | `ef61e06f3`, the first freeze (`xsf3.patch`, which is `builds/xs4.patch`) | {{=v['faults']['round3']['faults']}} | {{=v['faults']['round3']['caught']}} | {{=v['faults']['round3']['survived']}} | {{=v['faults']['round3']['not_built']}} | {{=v['faults']['round3']['on_both']}} |
| 4, the cast's term's and the value's column's | the two fixes, in the cloud container alone | {{=v['faults']['round4']['faults']}} | {{=v['faults']['round4']['caught']}} | {{=v['faults']['round4']['survived']}} | {{=v['faults']['round4']['not_built']}} | {{=v['faults']['round4']['on_both']}} |
| **5, the whole list** | **the code, `{{=v['checks']['revision']}}`** | **{{=v['faults']['round5']['faults']}}** | **{{=v['faults']['round5']['caught']}}** | **{{=v['faults']['round5']['survived']}}** | {{=v['faults']['round5']['not_built']}} | {{=v['faults']['round5']['on_both']}} |

- **Round 1's survivors** ({{=', '.join('`' + x + '`' for x in v['faults']['round1']['survivors'])}}): five terms
  the window's rules imply, out of the code (`branch-lists-a-not-too`, `call-not-through-a-dereference`,
  `call-not-through-an-address`, `suspect-any-expression`, `reduce-any-consumer`); two entries of the references'
  table no record reaches, simplified away (`asked-literal-symbol`, `asked-object-alone`); three that found a line
  of the fixture or a turn of the control (`reduce-second-arm-alone`, `reduce-joined-not-cleared`,
  `again-no-objects`); and two that change nothing a program reaches (`asked-given-an-object`,
  `suspect-reduction-from-the-second`). `first-round-survivors-on-the-inputs/` is ten of them run on the four
  inputs (`corpus-mutant.sh`): none is separated there.
- **Round 2's** ({{=', '.join('`' + x + '`' for x in v['faults']['round2']['survivors'])}}): the control kept a
  reference more of an object's number that could be the expression's own, closed for round 3;
  `suspect-any-number` was the list's own rewording of an equal test, dropped.
- **Round 4's** ({{=', '.join('`' + x + '`' for x in v['faults']['round4']['survivors'])}}): both terms are out of
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
`out/` what they made. `out/result-note.out.md` is the result note as posted on buster#2850 and
`out/pr-comment.md` the pull request's comment for this piece, cut from `out/pr-section.out.md` (its summary, what
the piece is, the fixes, what else was found, the tests and the checks): the pull request kept the description of
the piece it opened with.
