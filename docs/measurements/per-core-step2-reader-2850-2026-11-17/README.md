# buster#2850, step 2's third piece: the fact words' kernel where the machine sits (2026-11-17)

Steps 1 and 2 of buster#2850 made T's records from fact words, in a kernel that ran after the pipeline on windows made
from T's own columns and the walk's nodes. A compile that skips the walk for an expression has neither. This piece runs
the same kernel at reader time, where buster#2524 put the machine, and makes each window's inputs a second time from the
lean front's records and the reader's columns alone (`measure-node-machine --shadow --front-facts`). This is its record:
the 9700X, the checks in a cloud container, the versions of the inputs' making, the fault campaign and the sanitizer
rows. [Its specification](https://github.com/buster14a/buster/issues/2850#issuecomment-6933299446) has the gate.

**Result.**

- **Exact.** Every record the kernel makes at reader time is T's, over poisoned records and over decoys, and every
  input made from the front's records is the one made from T's columns, on `sqlite3.c`, Lua, musl and the compiler's
  own source.
- **The front's records give 98.2%, 97.8% and 98.3% of the expressions whole.** The rest are cut by a chunk's end: the
  lean front keeps a waiting value's place across chunks, not its record. No other reason occurs.
- **The kernel keeps its gain where the machine sits:** 16.4 TSC ticks a record on `sqlite3.c` where T takes 49.2 on
  the same expressions, and 27.9 on its first run where T's first run takes 101.9.
- **Its inputs' making costs more than the kernel:** 28.4 ticks a record with a batch's expressions in one loop, 46.7
  as the expressions come. T by the kernel is 44.8 ticks a record, and 77.9 by first runs. **The gate's 35 is missed,**
  and the first runs are over its refutation line of 53.
- **By passes over a batch it is no faster** than a record at a time with a branch on the operator: 33.6 against 30.5
  ticks a record on `sqlite3.c`, after four versions.
- **A compile is unchanged:** no compile runs the kernel.

## 1. The tree

- The commit is `patches/0001-…patch`, on buster#2895's head (main `c7caeb56b` with buster#2890's commit).
- **The 9700X built `patches/final2.patch`:** the commit's sources (`src` and `tools`) against main `178c9e2`, which
  is that main with buster#2894's, buster#2890's and this piece's sources, but for one comment's line in the tests,
  corrected after it was built. `patches/base.patch` is the same without the piece: the base of the compile's
  comparison.
- **The versions** of the inputs' making are `patches/facts-a.patch` to `facts-q.patch` and `final.patch`, each
  against main `178c9e2` as `final2.patch` is (section 3). `results/9700x/LABEL/revision.txt` has each one's SHA-256
  as it was built.
- The cloud container's checks ran on the commit's sources (`results/cloud/revision.txt`: the work-in-progress commit
  they were run at, whose `src` is the commit's).

## 2. The 9700X

Release builds, CPU 2, under the lock, a hold a run (`scripts/job.sh`, `scripts/final2.sh`;
`results/9700x/tables.txt` by `scripts/tables.py`). Medians of five readings in turn. TSC ticks at 3,792.9 MHz (1.45
cycles each at the core's 5.49 GHz), a record of the windows. `final2`:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions T takes at reader time; their records; windows | 50,993; 289,838; 1,157 | 10,839; 76,304; 317 | 43,415; 224,326; 3,056 |
| literals' leaves, each from a line | 39,033 | 11,339 | 25,988 |
| records that are no literal, and those the kernel makes | 250,805, 98.84% | 64,965, 96.75% | 198,338, 96.57% |
| … by a short path or a class's loop | 96.09% | 84.90% | 93.49% |
| … in the expressions the whole machine takes there (`--front-tests`) | 243,928, 99.39% | 59,894, 97.25% | 182,939, 98.03% |
| … after the pipeline (buster#2850's step 2, first piece) | 99.34% | 97.13% | 98.08% |
| records that differ from T's; over decoys; lists that differ | 0; 0; 0 | 0; 0; 0 | 0; 0; 0 |
| expressions whose inputs the front's records give | 50,094, 98.24% | 10,605, 97.84% | 42,685, 98.32% |
| their records; those whose inputs differ from the twin's | 283,416; 0 | 73,175; 0 | 214,921; 0 |
| not given: a chunk's end cut it; out of reach; a literal; a call of 255 operands | 899; 0; 0; 0 | 234; 0; 0; 0 | 730; 0; 0; 0 |
| words made: rows; declarations' lines (made again); member slots; pair slots | 4,705; 18,295 (0); 2,317; 321 | 16,023; 6,687 (0); 1,192; 189 | 265,765; 36,782 (0); 3,271; 530 |
| **T's first run:** T alone on the lean front; beside the kernel | 100.4; 101.9 | 118.3; 122.2 | 184.9; 185.7 |
| **T again** on the batch's expressions | 49.24 | 52.02 | 52.61 |
| **the kernel:** its first run; a later run | 27.90; 16.39 | 125.55; 20.59 | 337.64; 19.56 |
| **the inputs from the front's records:** as each expression came; again, a batch in one loop | 46.69; 28.39 | 57.93; 27.91 | 78.89; 34.15 |
| the kernel's later run and the inputs' second making | 44.78 | 48.50 | 53.71 |
| the rows' making; the lines' | 0.85; 2.47 | 8.83; 15.85 | 44.86; 23.11 |
| the twin's making, from T's columns | 68.1 | 116.1 | 355.0 |

- **Two earlier builds of nearly these sources** read the same within a tick (section 3's table has their inputs'
  making). `facts-q`: the kernel's later run 16.42, 21.14 and 20.37; T again 49.73, 53.13 and 53.52. `final`: 15.82,
  20.31 and 19.32; 49.71, 52.28 and 52.53.
- **Lua's and musl's first runs are their units' starts.** Lua is 34 units and musl 1,336, and the shadow starts each
  unit's kernel on fresh memory. What of the first runs there is page faults was not counted.
- **T's first run on the lean front** reads 100 to 102 ticks a record on `sqlite3.c`. The record of buster#2887 has
  71.2 on the whole front (`--front-types` alone), and T, C and X together read 156.8 on the lean front in buster#2890's
  record and 134.1 on the whole one in buster#2887's. What of the lean front's chunk makes T's first run dearer was
  not measured.
- **What the kernel leaves to T** on `sqlite3.c`, of 2,919 records: 1,090 casts, 275 `=`, 265 `->`, 241 `.`, 240 `==`,
  179 `?:`, 114 `-`, 99 conditions, 78 `!=`, 75 unary plus (each run's `left op=` lines have them all).

`-c sqlite3.c` as whole processes, `base` against `final2`, 21 runs a build from three fresh copies, twice
(`results/9700x/final2/compile-1.txt`, `compile-2.txt`):

| | base | final2 |
| --- | ---: | ---: |
| instructions, the median of 21 | 1,362,107,703; 1,362,107,702 | 1,362,107,840; 1,362,107,847 |
| wall time | 122.158 ms; 122.089 ms | -0.12%; +0.01% |
| base against itself in the same runs | | -0.11%; +0.06% |
| user cycles; base against itself | | -0.10%; +0.14%; and +0.02%; +0.06% |

No compile calls the piece. `final`, the build before, whose code in a compile's path is the same, retired the base's
instructions to within 13 and read -0.16% and +0.07% in wall time (`results/9700x/final/compile-*.txt`).

Each run's file starts and ends with the host's busiest processes and its load, inside its hold.

## 3. The versions of the inputs' making

Each is a build of main `178c9e2` with its patch, measured as section 2's (`scripts/job.sh LABEL PATCH READINGS`):
three readings, five from `m` on. Ticks a record, the batch's expressions in one loop:

| | the inputs' making | `sqlite3.c` | Lua | musl |
| --- | --- | ---: | ---: | ---: |
| `a` | a record at a time, a branch on its operator | 32.36 | 31.45 | 42.03 |
| `h` | by passes over the batch: every record's columns, seven lists by their counters, a pass a list, the classes last | 51.23 | 54.95 | 72.75 |
| `l` | every load made and every choice a mask; a tag a record and a vector compress to the lists; the outputs' places in locals | 34.30 | 39.92 | 55.85 |
| `m` | the sparse columns cleared a batch; the class of the record before kept at hand; what an operand's class asks from a table | 33.56 | 37.95 | 53.68 |
| `n` | a record at a time again, without the tests the front's own check has made | 30.54 | 29.25 | 35.89 |
| `p` | an enumerator's leaf from the reader's column, a value past 64 bits marked on its line | 30.40 | 29.62 | 36.39 |
| `q` | without the test that an identifier's leaf is a name's use, which the front's own check has made | 29.40 | 28.90 | 34.68 |
| `final` | `q` with a test more (16,500 literals in one body) | 29.53 | 28.71 | 34.51 |
| `final2` | the commit: without a taking back that its caller makes anyway, and with the fixture's last lines | 28.39 | 27.91 | 34.15 |

The passes of `h`, `l` and `m`, ticks a record (each run's `inputs by passes, ticks` line):

| pass | `h`: `sqlite3.c`, Lua, musl | `l` | `m` |
| --- | ---: | ---: | ---: |
| every record: its operator, distances, position, kind, code and tag | 24.06, 24.22, 26.41 | 12.77, 13.59, 15.68 | 13.64, 14.45, 18.57 |
| the identifiers' leaves, a line each | 2.18, 2.25, 3.65 | 2.16, 2.25, 4.31 | 2.22, 2.29, 4.39 |
| the other leaves | 2.72, 3.28, 6.20 | 2.70, 3.36, 6.90 | 2.78, 3.37, 6.42 |
| the members, the casts and the returns | 2.19, 3.14, 4.83 | 2.43, 4.23, 6.15 | 2.37, 3.60, 5.56 |
| the calls and the conditions | 2.88, 3.62, 5.57 | 2.92, 3.69, 5.62 | 2.92, 3.70, 5.85 |
| the made operators' classes | 17.07, 18.26, 25.31 | 11.18, 12.57, 16.06 | 9.47, 10.43, 11.92 |
| all | 51.23, 54.95, 72.75 | 34.30, 39.92, 55.85 | 33.56, 37.95, 53.68 |

- **What the first pass lost in `h`:** clang compiles `condition ? value : load` and `a && load` as a branch, on a
  record's operator, which the predictor can't guess; and seven lists' lengths with a dozen columns' pointers in one
  loop spilled, 25 loads and stores of the stack a record (read in the build's own code).
- **What the classes' pass lost:** an operand's class read back from the column just stored, the operand being most
  often the record before.
- **`m` under `perf record`** (`results/9700x/facts-m/perf-symbols.txt`, `perf-batch.txt`; `scripts/perf.sh`): no hot
  spot in the passes, about 125 instructions a record.
- **The kernel's share made rose from `n` to `p`** on Lua and musl (96.12% to 96.75%, 96.51% to 96.57%): an
  enumerator's leaf was left to T at reader time until its value was read from the reader's own column.

## 4. In the cloud container

A Release build of the commit's sources with CI's toolchain (4 CPUs, an Intel Xeon with AVX-512;
`scripts/cloud-checks.sh`).

| what | result |
| --- | --- |
| `test-checker --seed 133`, the eight parts | 842,766 checks, 0 failures |
| the shadow in 10 modes on `sqlite3.c`, Lua, musl and `main.c` | exit 0 in the 40 runs, no difference |
| … `--front-facts` on `main.c`: expressions; those the front's records give; input differences; the kernel's share | 38,161; 37,134 (97.31%); 0; 96.96% |
| the compiler checks and parses its own source; `test-call-graph`; `check-call-graph` | no diagnostic; 37 cases, 0 failed; 0 cycles |

- **The 10 modes:** `--passes 0 --front-facts --list 20`; the same with `--front-tests`; with `--front-own-tests -Wall
  -Wextra`; `--verify --passes 1 --front-facts`; `-g --passes 0 --front-facts`; and, for what the piece's changes to
  the shared code touch, `--passes 1 --facts --facts-operators`, `--passes 1`, `--passes 1 --front-sweeps`, `--passes 1
  --front-flat` and `--passes 1 --facts-reads`. `results/cloud/shadow` has the 80 outputs and `status.txt`.
- **The probes** (`results/cloud/probes`): `late.c`, a declaration read before and after its type is completed, and an
  array completed by a later declaration (one line each use's declaration, none made again); `ring.c`, an array named
  in its own initializer (T types none of a braced initializer's values); `deref.c`, three dereferences of an address
  whose pointer type T derives there, as the commit runs it (`deref.txt`: no difference) and with the rows' settling
  skipped (`deref-rows-not-made.txt`: the three records differ), which is section 5's second fault.

## 5. The fault campaign

`scripts/mutants.py`: each fault is one text of the new code replaced by a faulty one, in a copy of the tree, the Debug
compiler built and the node machine's tests run (`test-checker`'s part 5 of 8). Three runs, the tree changed between
them by what the faults that passed showed.

| run | the tree | faults | fail the tests | pass | not built |
| --- | --- | ---: | ---: | ---: | ---: |
| `results/cloud/campaign-first.txt` | as first written (`scripts/mutants-first.py`) | 53 | 47 | 3 | 3 |
| `campaign-second.txt` | with the literals' test; the three unbuilt faults written again | 53 | 48 | 4 | 1 |
| `campaign.txt` | the commit | 52 | 50 | 2 | 0 |

| the fault that passed | why | what changed |
| --- | --- | --- |
| a batch's literals' lines kept for the next batch (run 1) | no test had more literals than a batch's lines hold | a third generated text, 16,500 statements in one body, a line a literal (`node_facts_test_reader_lines`); the count of the literals' lines is pinned in every run of the kernel's tests |
| the rows of the types made since the last expression never made (run 2; unbuilt in run 1) | the fixture had no type first made in a later body whose row a record needs. Lua has one, and the fault makes two of its records differ: `*(&n)` in `lua_numbertointeger`, a dereference of an address whose pointer type T derives there (`results/cloud/probes/deref.c`) | the fixture's last body has `*&narrow` twice |
| what an expression that is not given took of the batch's argument places not taken back (run 2; unbuilt in run 1) | redundant: the caller takes the other making's counts for such an expression | the taking back is removed, of the literals' lines too |
| a line at hand taken without its type compared (runs 1 to 3) | no text found in which one declaration is read with two types: a later declaration of the name is another declaration, and a type completed in place keeps its identity (`results/cloud/probes/late.c`, `ring.c`). The corpora make no line again | kept as it is: the line's type is the one field a use states |
| a return's type read from its token's query type (runs 1 to 3) | the same value there: the walk's action at a return copies the function's return type into it, and the kernel runs after the walk acted | kept: without the walk only the reader's return column has it |

- **The second run found a fault of the report too:** the listing of the differences (`--list N`) shared its count with
  the expressions not given, which are many and came first, so Lua's two differing records were not listed. The
  differences are now listed first, on a count of their own.
- **The fault that did not build in the second run** (an enumerator past 64 bits taken as any other: the first two
  texts of it left a variable unused, then a tautology) is a wrong bit tested in the third.

## 6. The sanitizer rows

`scripts/sanitizers.sh`, on the commit's sources: for each row a Release build as CI's rows build it (`-O3`),
`test-checker`'s part 5, and for memory and address the shadow in three modes (`--passes 0 --front-facts`, the same
with `--front-tests`, and `--passes 1 --facts --facts-operators`) on `sqlite3.c`, Lua and the compiler's own source.
`results/cloud/sanitizers/progress.txt` has each step's status as it finished.

| row | `test-checker`'s part 5 | the nine shadow runs | reports |
| --- | --- | --- | ---: |
| memory, `x86-64` host | 210,283 checks, 0 failures | exit 0 | 0 |
| address, `x86-64` host | 210,283 checks, 0 failures | exit 0 | 0 |
| thread, `x86-64` host | 210,283 checks, 0 failures | not run | 0 |
| memory, native host | 210,319 checks, 0 failures | exit 0 | 0 |
| address, native host | 210,319 checks, 0 failures | exit 0 | 0 |
| thread, native host | 210,319 checks, 0 failures | not run | 0 |

The 48 steps (six builds, six runs of part 5, 36 shadow runs) all end with status 0, and no sanitizer wrote a report.
On the `x86-64` host no front runs, so `--front-facts` runs nothing there: those rows' shadow runs are the pipeline's
and the kernel's after it.

## Files

- `patches/0001-…patch`: the commit. `patches/final2.patch`, `base.patch`: what the 9700X built, against main
  `178c9e2`. `patches/facts-*.patch`, `final.patch`: the versions.
- `scripts`: the 9700X's `job.sh` and what it calls (`setup.sh`, `corpora.sh`, `lock.sh`, `build-label.sh`, `turns.sh`,
  `tables.py`), `final.sh`, `final2.sh`, `compile.sh` and `perf.sh`; the cloud container's `cloud-checks.sh`,
  `shadow-limited.sh`,
  `checker.sh`, `sanitizers.sh` (with this container's paths; `corpora-cloud.sh` is their inputs' file); the
  campaign's `mutants.py`, and `mutants-first.py` as its first run had it.
- `results/9700x`: a directory a label (`facts`: the kernel at reader time; `facts-tests`: with the tests and C and X
  there; `types-lean`: T alone on the lean front; `final2/compile-*` and `final/compile-*`: the compile's
  comparisons), `tables.txt`, and the jobs' logs.
- `results/cloud`: `test-checker`, `shadow`, `sanitizers`, the campaign's three runs, the probes, and the
  self-check's, the self-parse's and the call graph's outputs.
