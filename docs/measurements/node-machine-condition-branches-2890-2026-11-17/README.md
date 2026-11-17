# buster#2890: the node machine writes a condition's `&&`, `||` and `!` as the lowering's branches (2026-11-17)

buster#2889 and buster#2893 made the lowering write a condition's logical operators as branches to the condition's own
targets. The node machine had no code for the shape and left those expressions to the tasks: 9 points of its evaluated
nodes on each corpus. buster#2890 is the machine's side. C gives such an operator a target and a sense, the two things a
`CHECK_LOWER_BRANCH` task carries, and X writes the lowering's entries. This is its pull request's record: the 9700X, the
checks in a cloud container, and the fault campaign.

**Result.**

- **The machine takes what it took before buster#2889:** 98.84%, 94.29% and 91.07% of the census-taken evaluated nodes
  of `sqlite3.c`, Lua and musl. Main takes 89.76%, 86.29% and 82.73%, and before buster#2889 it took 98.85%, 94.32% and
  91.13%: the issue's gate is within 0.1 point.
- **Exact:** no difference in values, entries or the twin in any of 13 shadow modes on the three corpora and the
  compiler's own source, C and X at reader time and the one sweep among them.
- **The nodes it takes back cost more than the others:** 261 cycles each on `sqlite3.c`, where the average is 176. They
  write 1.89 entries each where the others write 1.24, a test and a branch an operand. The three sweeps' cycles a node
  rise by 4.4%, 0.6% and 1.1%.
- **A compile is unchanged:** no compile runs the machine.
- **The fault campaign found four faults the tests passed.** One was a hole in the shadow's comparison of the one sweep,
  which this fixes. With the fixes, each of 50 faults fails the tests.

## 1. The tree

- The commit is `patches/0001-…patch`, on main `c7caeb56b` (buster#2894's merge; its tree is main `178c9e2` with
  buster#2894's two commits).
- **The 9700X built the sources as they were before the campaign's fixes:** `patches/cond-9700x.patch`, against main
  `178c9e2`, beside a base of the same main with buster#2894
  ([that record's `patches/flat.patch`](../node-machine-flat-front-pull-2524-2026-11-16/patches/flat.patch)). The fixes
  are in the shadow's comparison of the one sweep (two `memset`s before it runs), in the reader's rule for a do
  statement's condition (two redundant tests removed), and in the fixture (two conditions in later bodies). None is in
  a sweep.
- The cloud container's checks ran on the commit itself.

## 2. The 9700X

Release builds, CPU 2, under the lock, a hold a run (`scripts/job.sh`; `results/9700x/tables.txt` by
`scripts/tables.py`). `base` is main `178c9e2` with buster#2894, `cond` the same with buster#2890. Medians of three
readings in turn; a reading's sweeps are the least of five passes.

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| machine-taken expressions: base; cond | 48,872; 51,042 | 10,128; 10,433 | 20,626; 21,561 |
| their evaluated nodes, of the census-taken | 89.75%; 98.84% | 86.29%; 94.29% | 82.73%; 91.07% |
| their entries | 284,028; 327,862 | 59,748; 67,430 | 118,822; 136,868 |
| refused by C's template: expressions, base; cond | 2,461; 291 | 700; 395 | 2,349; 1,414 |
| T, cycles a node | 89.4; 90.6 | 80.4; 81.8 | 71.5; 72.5 |
| T and C | 138.6; 142.8 | 126.8; 125.2 | 115.2; 115.3 |
| **T, C and X** | **176.0; 183.8** | **154.2; 155.2** | **140.1; 141.6** |
| their instructions a node | 603.6; 606.4 | 688.1; 691.2 | 655.8; 661.6 |
| a unit's three sweeps, M cycles | 40.44; 46.51 | 8.07; 8.88 | 13.73; 15.28 |
| differences: values, entries, twin | 0, 0, 0 | 0, 0, 0 | 0, 0, 0 |

- **What the nodes taken back cost.** `sqlite3.c`'s 23,251 nodes take 6.07 M cycles, 261 each: T 103, C 82 and X 77,
  where a node of the base's takes 89, 49 and 37. They write 43,834 entries, 1.89 each, where the base's nodes write
  1.24.
- **The one sweep** (`--fused`, `cond`): 51,333, 10,828 and 22,998 expressions, no difference.
- **The census's own reports** are the base's line for line on the three corpora, with both sets of warnings.

T, C and X at reader time on the lean front (`--front-sweeps --front-lean`), TSC ticks at 3,792.9 MHz:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions T takes there | 50,993 | 10,839 | 43,415 |
| of them C and X take: base; cond | 48,066; 50,159 | 10,082; 10,366 | 40,205; 41,068 |
| their entries | 277,562; 319,525 | 58,825; 66,089 | 193,941; 209,223 |
| ticks a record of T's (291,368; 76,759; 226,864 records) | 156.8; 168.6 | 180.8; 189.0 | 275.6; 290.5 |
| compared with the shadow's own after the pipeline; differences | 50,370; 0 | 10,524; 0 | 22,258; 0 |

`-c sqlite3.c` as whole processes, 21 runs a build from three fresh copies, twice:

| | base | cond |
| --- | ---: | ---: |
| instructions | 1,362,107,606 | 1,362,107,753; 1,362,107,761 |
| wall time | 122.150 ms; 121.976 ms | +0.14%; -0.00% |
| base against itself in the same runs | | -0.04%; +0.09% |
| user cycles; base against itself | | +0.05%; +0.07%; and -0.06%; +0.12% |

Each run's file starts and ends with the host's busiest processes and its load, inside its hold.

## 3. In the cloud container

A Release build of the commit with CI's toolchain (4 CPUs, an Intel Xeon with AVX-512).

| what | result |
| --- | --- |
| `test-checker --seed 133`, the eight parts | 842,761 checks, 0 failures |
| the shadow in 13 modes on `sqlite3.c`, Lua, musl and `main.c` | exit 0 in the 52 runs, no difference |
| … machine-taken expressions; evaluated nodes | 51,047; 98.84% and 10,433; 94.29% and 21,561; 91.07% and 18,033; 73.86% |
| … the one sweep's expressions; differences | 51,338; 0 and 10,828; 0 and 22,998; 0 and 20,441; 0 |
| … C and X at reader time compared; differences | 50,558; 0 and 10,544; 0 and 22,324; 0 and 13,845; 0 |
| the compiler checks and parses its own source; `test-call-graph` | no diagnostic; 37 cases, 0 failed |

- **The 13 modes** (each with `--passes 1`): none, `-g`, `--fused`, `--front-sweeps`, `--verify`, `--front-types`,
  `--facts --facts-operators`, `--front-flat`, `--front-tests`, `--front-own-tests`, each of the last two with
  `-Wall -Wextra` too, and `--facts-reads`. `results/cloud/shadow` has the 52 outputs and `status.txt`.
- **The sanitizer rows** (memory, address and thread, on the `x86-64` host and the native one), which a pull request's
  checks don't run: `results/cloud/sanitizers`, section 5.

## 4. The fault campaign

`scripts/mutants.py`: each fault is one text of the new code replaced by a faulty one, in a copy of the tree, the Debug
compiler built and the node machine's tests run (`test-checker`'s part 5 of 8). `results/cloud/campaign-first.txt` is
the first run, of 52 faults on the code as first written: 48 failed the tests and four passed.

| the fault that passed | why | what changed |
| --- | --- | --- |
| the one sweep never writes a two-label record's second label's entry | the shadow compared the one sweep's labels and calls in the arrays the three sweeps had just written: an entry it left unwritten read as theirs | `node_shadow_fused` poisons the labels' entries and the calls' records before the one sweep runs. With it, the three corpora still show no difference |
| at reader time, any token's role counts as a condition's | the test was redundant: of the roots that are conditions, only a do statement's token is a child of a terminator. Probed with a do statement around each other control, and each control around a for statement (`results/cloud/probes`) | the test is removed |
| at reader time, any root's operator counts as a condition | redundant too: `node_machine_root` reads the sense of a `CONDITION` alone | the test is removed |
| the comparison finds the control's label's entry without the body's first label | every condition of the fixture that is branches was in the unit's first body, whose first label is 0 | the fixture has such a condition in each of its two later bodies |

`results/cloud/campaign.txt` is the second run, on the commit: 50 faults (the two removed tests' faults are gone), and
each fails the tests.

## 5. The sanitizer rows

`scripts/sanitizers.sh`, on the commit: for each row a Release build as CI's rows build it (`-O3`), `test-checker`'s
part 5, and for memory and address the shadow with `--fused` and with `--front-sweeps` on `sqlite3.c`, Lua and the
compiler's own source. `results/cloud/sanitizers/progress.txt` has each step's status as it finished.

| row | `test-checker`'s part 5 | the six shadow runs | reports |
| --- | --- | --- | ---: |
| memory, `x86-64` host | 210,278 checks, 0 failures | exit 0 | 0 |
| address, `x86-64` host | 210,278 checks, 0 failures | exit 0 | 0 |
| thread, `x86-64` host | 210,278 checks, 0 failures | not run | 0 |
| memory, native host | 210,314 checks, 0 failures | exit 0 | 0 |
| address, native host | 210,314 checks, 0 failures | exit 0 | 0 |
| thread, native host | 210,314 checks, 0 failures | not run | 0 |

The 36 steps (six builds, six runs of part 5, 24 shadow runs) all end with status 0, and no sanitizer wrote a report.

## Files

- `patches/0001-…patch`: the commit. `patches/cond-9700x.patch`: what the 9700X built, against main `178c9e2`.
- `scripts`: the 9700X's `job.sh` and what it calls (`setup.sh`, `corpora.sh`, `lock.sh`, `build-label.sh`, `turns.sh`,
  `compile.sh`, `tables.py`); the cloud container's `shadow-limited.sh`, `checker.sh`, `sanitizers.sh` (with this
  container's paths; `corpora-cloud.sh` is their inputs' file); the campaign's `mutants.py` and `probe.py`.
- `results/9700x`: `base` and `cond` (`shadow`: the sweeps after the pipeline; `sweeps-lean`: reader time; `fused`;
  `census`, `census-wall`; `compile`), `tables.txt` and `job.log`.
- `results/cloud`: `shadow`, `test-checker`, `sanitizers`, the campaign's two runs, the probes, and the self-check's,
  the self-parse's and the call graph test's outputs.
