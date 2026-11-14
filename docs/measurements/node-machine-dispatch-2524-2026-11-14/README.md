# The node machine's C and X: one case an operator, one a template (#2524's step 1, 2026-11-14)

This record is for [buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1: the pull request that
gives C one case an operator and X one case a template. `docs/node-machine.md`'s "C's and X's dispatch: one case an
operator, one a template" section summarizes it.

At main `ca1ede6a` the three sweeps cost 183.8 cycles a taken node on `sqlite3.c`, against the step's gate of 120: T
90.2, C 57.6 and X 35.9. C chose each record's template through one chain of tests for every operator, and called an
out-of-line function for each operand it evaluated, after storing the record it classified into the machine. X wrote each
record's row through another chain. The change ends both chains in one `switch` each. C's common cases name their
operands, and its loop evaluates them inline. X counts a call's row from the calls it has written, not from a store at
every record.

Against main, in six runs of each taken in turn: on `sqlite3.c`, C from 57.6 to 44.7 cycles a taken node and from 209.9
to 169.3 instructions; X from 104.0 to 78.6 instructions, its cycles 35.9 and 35.1; the three sweeps from 183.8 to 170.2
cycles (7.4% fewer) and 288.2 against 320.4 in two runs. On Lua, the three from 157.1 to 144.9 (7.8%). The machine's
results are the same: `--verify` finds no difference on the corpora, with and without `-g`.

Everything timed ran on the Ryzen 7 9700X (`benchpress`), each run in its own hold of the lock, pinned to CPU 2, with the
scripts in `scripts/`. `time.sh`, `corpora.sh`, `ab.sh` and `medians.py` are
[the front-end record](../node-machine-front-end-2524-2026-11-13/)'s, with Lua 5.4.8's sources taken from this
workspace's own copy (`inputs/lua-5.4.8`, the release tarball, every file's SHA-256 checked against an earlier
workspace's list): the earlier records' copy had been removed from the host. `results/env.txt` has the kernel, clang, perf
and the CPU's governor.

## Versions

Every patch applies to main `ca1ede6a` and holds the version its row names under "on" as well as its own change.

| label | what | on | source |
| --- | --- | --- | --- |
| `main` | main | | [`ca1ede6a`](https://github.com/buster14a/buster/commit/ca1ede6a29cbf43d1f3fc2fd0b8cc3d41e3ad2a3) |
| `e1` | `restrict` on the machine in every C and X function (a diagnostic of the reloads) | main | `patches/e1.patch` |
| `e1c`, `e1x` | `e1` in C alone, in X alone | main | `patches/e1c.patch`, `patches/e1x.patch` |
| `c2a` | C's common cases name their operands (`NodeMachineUse`), C's loop evaluates them inline; no `classified`, `stopped` stored once; `node_machine_power` asked for `/` and `%` alone | main | `patches/c2a.patch` |
| `c2ar` | `c2a` and `e1c` | `c2a` | `patches/c2ar.patch` |
| `c2ax1` | `c2a` and X's tape in a local struct, passed by address to its updates' rows through a copy | `c2a` | `patches/c2ax1.patch` |
| `c2b` | `c2a` and C's classification as one `switch` on the operator | `c2a` | `patches/c2b.patch` |
| `c2bx2` | `c2b` and X's `node_machine_own` as one `switch` on the template, a call's row from the calls written | `c2b` | `patches/c2bx2.patch` |
| `c3` | `c2bx2` and a path for a leaf's read ahead of C's shared refusals | `c2bx2` | `patches/c3.patch` |
| `x3` | `c2bx2` and X's tape in a local struct, passed by value to its updates' rows | `c2bx2` | `patches/x3.patch` |
| **`pr`** | the pull request's code: `c2bx2` with its comments reworded and X's load test renamed (`node_machine_loads`) | | [`eb8fef1b`](https://github.com/buster14a/buster/commit/eb8fef1bc79902552ce386a46bfd642793784964) |

`main` and `pr` were built in fresh worktrees (`build-label.sh`), the others incrementally in one worktree reset to main
and patched (`build-inc.sh`), all by `./build.sh --config Release`. Each build's log is `results/LABEL/build.log`, its
binary's hash `results/LABEL/compiler.sha256`, its revision and patch hash `results/LABEL/revision.txt`, and its node
machine's functions with their sizes `results/LABEL/nm-node-machine.txt`.

## The final comparison (`time.sh`, rounds `g1` to `g6`)

`main` and `pr` in turn, six rounds, each run its own hold of the lock (`scripts/sweeps.py results g main pr`; every run's
file is `results/LABEL/time-*-gN.txt`, and `time-holder-gN.txt` the lock's holder line). Cycles and instructions a taken
evaluated node, medians; C and X are differences of the sets' medians:

| | T | C | X | T, C and X (range) | the three, two runs |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c`, `main` | 90.2, 350.9 | 57.6, 209.9 | 35.9, 104.0 | 183.8, 664.8 (183.3-184.5) | 320.4, 1,322.8 |
| `sqlite3.c`, `pr` | 90.4, 350.9 | **44.7, 169.3** | 35.1, 78.6 | **170.2, 598.8** (169.6-171.2) | **288.2**, 1,190.9 |
| Lua, `main` | 83.2, 444.5 | 49.6, 208.9 | 24.2, 101.4 | 157.1, 754.8 (156.5-157.3) | 297.2, 1,492.6 |
| Lua, `pr` | 83.2, 444.5 | **37.1, 171.2** | 24.6, 76.1 | **144.9, 691.8** (144.6-149.6) | **271.3**, 1,366.4 |

- C: 22.4% fewer cycles on `sqlite3.c` and 25.2% fewer on Lua; 40.6 and 37.7 fewer instructions a node.
- X: 24.4% and 25.0% fewer instructions; cycles 35.9 against 35.1 and 24.2 against 24.6.
- T is the same code (`nm`: `node_machine_type` 11,759 bytes in both) and runs the same instructions.
- `nm` (`results/LABEL/nm-node-machine.txt`, and sizes by `nm -S`): `node_machine_contexts` 7,681 bytes to 5,945,
  `node_machine_expand` 5,879 to 5,714, `node_machine_classify_update` (213) new; every other function of the machine the
  same size, and `node_machine_evaluate` and `node_machine_power` out of line in both.

## The exploration (`time.sh`, rounds `fN`; `scripts/sweeps.py results f LABEL...`)

`time.sh` runs `measure-node-machine --shadow --passes 11` on `sqlite3.c` and on Lua's 34 sources, then with `--repeat 2`.
The shadow's own counters (this thread's user-mode cycles and instructions) time each sweep set, T alone, T and C, and all
three, keeping each set's least over the passes, per machine-taken evaluated node (257,229 on `sqlite3.c`, 57,779 on Lua,
on the 9700X).
C is the second set less the first and X the third less the second, each a difference of the sets' medians over the runs.
The runs of a round were taken in turn with main's, so placement and the host's state spread over all of them.

Cycles and instructions a taken evaluated node on `sqlite3.c`, medians over the rounds each version ran (n), C and X as
above; `results/sweeps-f.txt` has every version on both inputs, with and without `--repeat 2`:

| version | n | T | C | X | three |
| --- | ---: | ---: | ---: | ---: | ---: |
| `main` | 9 | 90.6, 350.9 | 56.9, 209.9 | 36.5, 104.0 | 184.0, 664.8 |
| `e1` | 3 | 89.5, 350.9 | 50.7, 193.6 | 37.1, 102.6 | 177.3, 647.1 |
| `e1c` | 2 | 89.7, 350.9 | 51.3, 193.6 | 36.7, 103.9 | 177.6, 648.4 |
| `e1x` | 2 | 90.8, 350.9 | 56.2, 209.9 | 38.4, 102.6 | 185.4, 663.4 |
| `c2a` | 12 | 90.5, 350.9 | 53.6, 210.7 | 36.8, 103.9 | 180.9, 665.5 |
| `c2ar` | 3 | 90.4, 350.9 | 52.6, 212.6 | 38.3, 104.0 | 181.3, 667.5 |
| `c2ax1` | 3 | 90.7, 350.9 | 53.6, 210.7 | 38.0, 110.5 | 182.3, 672.1 |
| `c2b` | 6 | 90.5, 350.9 | 46.5, 169.3 | 36.4, 104.0 | 173.5, 624.2 |
| `c2bx2` | 6 | 91.1, 350.9 | 44.5, 169.3 | 34.9, 78.6 | 170.5, 598.8 |
| `c3` | 3 | 89.9, 350.9 | 46.1, 183.5 | 36.8, 78.7 | 172.8, 613.1 |
| `x3` | 1 | 90.6, 350.9 | 44.0, 169.3 | 34.7, 84.7 | 169.3, 604.9 |

`x3`'s rounds were stopped after the first, once its instructions had shown it; `c3`'s second round on `sqlite3.c` ran
while the host was busier (its three ranges 172.8 to 182.1), and its instructions alone decided it.

- **The reloads were C's, and the operands in one place remove them.** `restrict` on the machine (`e1`, a diagnostic,
  not a change) took C from 209.9 to 193.6 instructions and 56.9 to 51.3 cycles, and changed nothing in X, whose reloads
  stayed (`e1x`: 153 of main's 182 loads, in `node_machine_expand`'s `objdump -d`, at the machine's offsets of the
  columns' block, `0x2b0`, and of the tape's pointers and count, `0x340` to `0x360`). C's reloads were those after its
  out-of-line call for each operand and its store of the record it classified. `c2a` removes both, for 3.3 fewer cycles on
  the same instructions, and `restrict` on top of it (`c2ar`) gains nothing more.
- **C's chain was its instructions.** One case an operator (`c2b`) takes C from 210.7 to 169.3 instructions and from
  53.6 to 46.5 cycles. Its order of tests had every operator fail the cases before its own. A division's power-of-two test,
  `node_machine_power`, which since #2679 (#1386) had been a call of its own for every binary operator
  (`results/main/nm-node-machine.txt` lists it; the front-end record's builds don't), is asked for `/` and `%` alone (from
  `c2a` on).
- **X's chain was its instructions, not its cycles.** One case a template and the call rows from the calls written
  (`c2bx2`) take X from 104.0 to 78.6 instructions, but only from 36.4 to 34.9 cycles: X runs at about 2.2 instructions a
  cycle. Its tape's count, which each entry reads and writes in the machine, isn't what holds it: `x3` keeps it in a local
  and leaves X's cycles where they were.
- **Three levers didn't pay:**
  - X's tape in a local struct passed by address (`c2ax1`): 6.6 more instructions and 1.2 more cycles in X. The copies the
    updates' rows took kept it on the stack.
  - The same passed by value to the updates' rows (`x3`, one round): 6.1 more instructions, cycles within the noise.
  - A path for a leaf's read ahead of C's shared refusals (`c3`): 14.2 more instructions and no fewer cycles.

## What C classifies (`patches/histogram-on-c2a.patch`, `results/histogram-sqlite3.txt`)

A local patch to `c2a`'s C loop counted the records it classified by operator and template, printing the counts every
250,000 records, with `CX_HISTOGRAM=1`, on the shadow of `sqlite3.c` with `--passes 0` in the cloud container. Over the
first 250,000 records: a leaf read as a local 24.6%, a cast passing its operand 15.3%, a leaf constant 14.3%, `->` and `.`
11.5%, a call 5.2%, a condition's test 4.7%, a store to a named object 3.7% and through an address 2.6%. The last lines
(`op=255`) count the records' targets: 52.4% convert to their own type (2.4% of all of them in an address's context),
24.2% to none and 23.4% to another.

## The checks

- **`--verify`** on the frozen `sqlite3.c`, Lua 5.4.8 and musl's 1,336 units, with and without `-g`, by `pr` on the 9700X
  (`corpora.sh`, `results/pr/verify-*.txt`, and main's `results/main/verify-*.txt`): 0 differences in values, entries and
  the twin, and every report the same as main's but its times: `sqlite3.c` 51,130 expressions and 257,229 evaluated
  nodes taken, Lua 10,444 and 57,779, musl 21,604 and 110,119. The same in the cloud container by its Develop build
  (`scripts/cloud-verify.sh`, `results/cloud-verify/`): 0 differences, and each report the same as main's but its times.
- **`-c sqlite3.c`** (`ab.sh`, `time-runs`, 21 runs each after 2 warm-ups, in one hold; `results/ab-main-pr/`): 122.808 ms
  against main's 122.900 (-0.07%), user cycles 595.4 M against 596.3 M (-0.16%), 1,359,823,352 instructions against
  1,359,823,581. The shadow isn't part of a compile.
- In the cloud container: `test-checker` 837,950 checks, 0 failures; `./build.sh check-call-graph` 0 cycles; the
  `-fsyntax-only -Wall -Werror` self-compile of `main.c` clean.

## Files

- `scripts/`: `lock.sh`, `build-label.sh`, `build-inc.sh`, `time.sh`, `corpora.sh`, `ab.sh`, `medians.py`, `sweeps.py`,
  `annotate-cx.sh` (C's and X's samples by source line), `cloud-verify.sh`.
- `results/LABEL/`: each version's build and timings; `results/main/annotate-*` and `results/c2bx2/annotate-*`: C's and
  X's profiles by source line (`annotate-cx.sh`), cycles and instructions; `results/ab-main-pr/`: the `-c` comparison.
