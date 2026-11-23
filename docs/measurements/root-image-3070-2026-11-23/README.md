# The root image: a lane's units start from its preprocessor's state after the prelude (2026-11-23)

Evidence for [buster#3070](https://github.com/buster14a/buster/issues/3070)'s step 1 (items 4 and 5: "a unit starts
from a root image", "lanes stay warm"), after the first piece
([pool-discard-3070-2026-11-22](../pool-discard-3070-2026-11-22)). The pull request keeps a units lane's preprocessor
between its units: its state after the predefines and the command line is captured once (`PPRoot`,
`c_preprocessor.c`), each later unit starts as a copy of it, and each unit's release restores it in arenas that stay
the lane's, instead of giving their pages back to the kernel and running the predefines again.

- **Source:** buster main `b7d0b5edff73852852f0664c07fab61b00cad378` (the merge of #3419), and the pull request on it.
  Built `./build.sh --config Release` on the 9700X under the lock (`scripts/build9700.sh`): `bin/base` (main),
  `bin/root1` (the pull request's first version) and `bin/root2` (the pull request as opened: with the history's
  first tables in the image, so that `-g`'s units start from it too, the items' peak, and the scratch spellings'
  chunk cleared rather than copied back).
- **Hosts:**
  - The 9700X (Linux 6.18.50, transparent huge pages `always`): every figure of sections 2 to 4. Each round of
    `scripts/measure.sh` is one hold of the lock, the configurations in an order that rotates by round; `perf stat`
    user and kernel cycles and instructions, page faults. The machine was busy with other sessions' builds between
    the holds (a load average of 5 as a hold began, `results/*/host-*.txt`); nothing else ran during one.
  - The cloud container (Xeon, 4 vCPUs under KVM, Linux 6.18.44): the census of section 1, the correctness checks and
    the fault round.
- **Workloads,** from `scripts/measure.sh`, on CPU 2 for one lane and CPUs 2 to 5 for four:
  - `empty`: 1,336 empty files with musl's options, one `-c --lanes 1` command (#3070's step-1 gate: 135 M cycles).
  - `musl1`, `musl4`: musl's 1,336 units (the frozen corpus `preprocessor-391e729af658`, one source per base name, the
    one-core record's options), one command, one lane and four.
  - `lua1`: Lua 5.4.8's 34 `src/*.c`, `-std=gnu99 -O2 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX`, one lane.
- **Configurations:** `base` is main; `on` the pull request; `off` the pull request with `--root-image=off`, which
  runs a command without root images.

## In short

- **An empty unit was mostly its preprocessor's start and release.** Of main's 322 thousand cycles a unit, the
  predefines' text, lexed and run again for each unit, took 28%; and of a unit's 46 page faults and 17 `madvise`
  calls, 33 and 7 were the preprocessor's arenas', its 9.6 GB of tables' among them (section 1).
- **With the root image the 1,336 empty units take 166 M cycles where main takes 445 M** (−62.7%, lower in each of 7
  rounds; section 3): user 196 → 76 M, kernel 249 → 90 M, faults 61,783 → 15,112, user instructions 527 → 124 M. The
  gate is 135 M.
- **musl's command takes 12.9% fewer cycles on one lane and 14.7% fewer on four** (7 of 7 each), a third of the
  kernel's: 3,630 → 3,162 M and 4,612 → 3,932 M; Lua's 4.0% fewer.
- **Every object and diagnostic of every run is main's,** and `--root-image=off` reads as main does on musl's and
  Lua's commands (section 3 has the empty units').
- **What is left of the gate** (section 4): ten `madvise` calls and eleven faults a unit, from the parser's, the type
  table's, the checker's and the object's arenas, which each unit still reserves and releases; the two files; and
  the image's own restore, about 150 KB copied a unit.

## 1. What a unit releases (container, an experiment patch printing each release)

`scripts/census.patch`, on main: for each arena a units lane's unit releases into its pool, its peak, the pages of its
writable prefix the kernel has (`mincore`) and the last byte among them that isn't zero. `results/census/` has the
lines (the caller is `arena_release`'s return address in that build) and these tables.

An empty unit (17 releases, 44 resident pages):

| arena released | peak | last byte written | resident pages |
| --- | ---: | ---: | ---: |
| the preprocessor's tables (9.6 GB) | pushed whole | 8.06 GB in | 22 |
| the preprocessor's arena | 20,307 | 20,306 | 5 |
| the preprocessor's three arenas of columns | 13,678; 54,712; 54,712 | 2,369; 7,629; 7,709 | 1; 2; 2 |
| the preprocessor's two arenas of scratch spellings | 0; 65,536 | none; 5 | 0; 1 |
| the preprocessor's output (tables), released before the backend | pushed whole | none | 0 |
| the parser's token columns and tree columns (tables) | pushed whole | 393,979; none | 5; 2 |
| the parser's scratch | 0 | none | 0 |
| the type table's arena and index | 5,888; 4,096 | 2,993; none | 2; 1 |
| `check_input_run`'s arena, `check_program_finish`'s | 13,249; 896 | none | 0; 0 |
| the object's two arenas | 0; 1,794 | none | 0; 1 |

The preprocessor's are 33 of the 44 pages and 7 of the 17 releases (8 with its output's). On musl's 1,336 units
(`results/census/census-musl.md`), 25,940 releases hold 245,541 pages: the preprocessor's tables 81,996,
`check_input_run`'s arena 43,507, the type table's 34,750, the parser's columns 32,326, the preprocessor's other arenas
and its output 31,264.

**An arena's peak covers what was written.** Of the 19,388 releases of arenas that aren't tables on musl, none had a
byte written past its peak: no copy of an arena pushed past the arena's own record there. The one place a copy of the
preprocessor is made, with its arenas, is the checker's repair of a malformed statement in a `do`'s body
(`check_repair_preprocessor`), which the pull request marks: such a unit gives the root nothing back.

## 2. The lanes' workloads (9700X, `results/root1`, 5 rounds)

Medians of the rounds, M cycles (`scripts/table.py results/root1 base`):

| workload | configuration | user | kernel | all | user instructions | kernel instructions | faults |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| empty | base | 198.8 | 253.5 | 451.7 | 526.6 | 684.9 | 61,783 |
| empty | off | 198.8 | 252.2 | 451.0 | 526.7 | 683.1 | 61,780 |
| empty | on | 86.0 | 90.0 | 176.0 | 128.2 | 190.2 | 15,130 |
| musl, one lane | base | 2,767.3 | 877.0 | 3,639.9 | 6,808.6 | 1,957.0 | 266,408 |
| musl, one lane | off | 2,762.9 | 873.1 | 3,631.2 | 6,809.0 | 1,954.3 | 266,401 |
| musl, one lane | on | 2,600.8 | 587.3 | 3,188.0 | 6,414.0 | 1,123.3 | 177,455 |
| musl, four lanes | base | 3,136.7 | 1,480.5 | 4,617.9 | 6,938.1 | 2,108.9 | 273,223 |
| musl, four lanes | off | 3,132.5 | 1,479.6 | 4,609.2 | 6,935.9 | 2,109.6 | 273,048 |
| musl, four lanes | on | 2,942.2 | 1,039.0 | 3,979.9 | 6,546.5 | 1,256.6 | 185,716 |
| Lua, one lane | base | 319.1 | 60.4 | 379.9 | 785.5 | 90.3 | 16,084 |
| Lua, one lane | off | 318.3 | 59.6 | 378.3 | 785.5 | 89.3 | 16,078 |
| Lua, one lane | on | 315.8 | 51.3 | 367.1 | 776.2 | 64.4 | 13,101 |

Against main, paired by round:

| workload | configuration | all cycles | lower in | kernel cycles | user cycles |
| --- | --- | ---: | ---: | ---: | ---: |
| empty | off | +0.4% | 2 of 5 | −0.4% | +0.1% |
| empty | on | −60.9% | 5 of 5 | −64.5% | −56.8% |
| musl, one lane | off | +0.2% | 2 of 5 | −0.4% | +0.3% |
| musl, one lane | on | −12.6% | 5 of 5 | −32.9% | −5.9% |
| musl, four lanes | off | −0.2% | 3 of 5 | −0.4% | −0.2% |
| musl, four lanes | on | −13.8% | 5 of 5 | −30.0% | −6.2% |
| Lua, one lane | off | −0.6% | 4 of 5 | −1.2% | −0.4% |
| Lua, one lane | on | −3.2% | 5 of 5 | −14.3% | −1.3% |

In every round the objects of a workload are the same bytes under the three configurations (`sum-*.txt`: one checksum
a workload over 15 runs, musl's the same on one lane and on four), and so are the diagnostics (musl's 248,068 bytes).

## 3. The pull request as opened (9700X, `results/root2`, 7 rounds)

`bin/root2` is `scripts/root2.patch` on main `b7d0b5ed`: section 2's build with the history's first tables in the image
(`-g`), the items' peak, and the scratch spellings' chunk cleared rather than copied back. The pull request's head adds
to it a test's fault hook and MemorySanitizer's marks in the check, neither in a compile's own path, and is rebased
onto a later main.

| workload | configuration | user | kernel | all | user instructions | kernel instructions | faults |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| empty | base | 195.5 | 248.6 | 445.1 | 526.6 | 658.6 | 61,783 |
| empty | off | 198.6 | 248.7 | 447.4 | 526.8 | 680.0 | 61,777 |
| empty | on | 75.7 | 90.1 | 165.9 | 124.2 | 193.1 | 15,112 |
| musl, one lane | base | 2,756.0 | 868.8 | 3,629.7 | 6,808.6 | 1,934.5 | 266,409 |
| musl, one lane | off | 2,761.4 | 876.0 | 3,637.0 | 6,809.1 | 1,954.1 | 266,359 |
| musl, one lane | on | 2,580.1 | 581.6 | 3,161.5 | 6,410.3 | 1,119.3 | 177,396 |
| musl, four lanes | base | 3,132.0 | 1,474.3 | 4,612.0 | 6,938.5 | 2,113.5 | 273,021 |
| musl, four lanes | off | 3,131.5 | 1,478.2 | 4,609.7 | 6,939.2 | 2,108.8 | 273,044 |
| musl, four lanes | on | 2,910.5 | 1,022.0 | 3,932.4 | 6,542.9 | 1,256.1 | 185,668 |
| Lua, one lane | base | 319.0 | 59.6 | 379.1 | 785.5 | 89.0 | 16,086 |
| Lua, one lane | off | 319.1 | 59.3 | 378.7 | 785.6 | 89.0 | 16,049 |
| Lua, one lane | on | 313.7 | 50.2 | 363.9 | 776.1 | 63.7 | 13,056 |

| workload | configuration | all cycles against main, paired | lower in | kernel cycles | user cycles |
| --- | --- | ---: | ---: | ---: | ---: |
| empty | off | +1.1% | 1 of 7 | +1.2% | +1.4% |
| empty | on | −62.7% | 7 of 7 | −63.8% | −61.7% |
| musl, one lane | off | +0.0% | 1 of 7 | +0.1% | +0.2% |
| musl, one lane | on | −12.9% | 7 of 7 | −33.0% | −6.5% |
| musl, four lanes | off | −0.0% | 4 of 7 | +0.3% | −0.1% |
| musl, four lanes | on | −14.7% | 7 of 7 | −30.6% | −7.2% |
| Lua, one lane | off | −0.0% | 4 of 7 | −0.3% | −0.1% |
| Lua, one lane | on | −4.0% | 7 of 7 | −15.9% | −1.8% |

The objects and the diagnostics of each workload are the same bytes under the three configurations in every round
(`sum-*.txt`). Clearing the scratch spellings' chunk where section 2's build copied it back took the empty units' user
cycles from 86.0 to 75.7 M.

`off` on the empty units reads 1.1% over main, in 6 of 7 rounds, where section 2's read +0.4%. The rounds don't
balance the order: of the 7, `off` ran first in a hold of the lock in 3, and `base` and `on` in 2 each, and the empty
units are 80 ms.

## 4. Where an empty unit's cycles go (9700X, `scripts/profile.sh`, `results/profile-*`)

`perf record -g` of the 1,336 empty units, the callers' shares (`empty-children.txt`), and `strace -c`'s calls:

| | main | with the root image |
| --- | ---: | ---: |
| page faults (`asm_exc_page_fault`) | 27.5% | 17.6% |
| `madvise` | 25.7% | 20.5% |
| the predefines: `pp_prepared_directive`, the lexer, the refine, `pp_prepare_data` | 12.2%, 6.4%, 3.4%, 4.0% | none |
| the pool's `PROCMAP_QUERY` (`ioctl`) | 3.5% | 5.8% |
| `openat` | 2.3% | 6.0% |
| `memset`, `memmove` | 5.9%, 1.5% | 16.1%, 8.8% |
| `madvise` calls; `ioctl` calls; faults | 22,725; 22,712; 61,779 | 13,373; 13,360; 15,131 |

The shares on the right are of 2.6 times fewer cycles. With the image a unit makes 10 `madvise` calls and takes 11
faults where it made 17 and took 46. What remains above the gate's 101 thousand cycles a unit:

- **the arenas a unit still reserves and releases** (section 1's rows that aren't the preprocessor's): the parser's
  columns and scratch, the type table's two arenas, `check_input_run`'s, `check_program_finish`'s, the object's two and
  the preprocessor's output, a `madvise` and a `PROCMAP_QUERY` each, and the faults of the pages they touch again;
- **`memset`,** 16% with the faults it takes: the parser's and the type table's columns cleared in fresh pages;
- **the restore,** `memmove`'s 8.8%: about 150 KB a unit copied back (64 KB of them the scratch spellings' chunk, which
  the pull request as opened clears instead: section 3);
- **the two files:** the source's `openat`, `fstat` and `close` and the object's `openat`, `pwrite` and `close`.

## 5. Correctness

- **Objects and diagnostics, with root images, without them and checked** (`--poison-arenas`: after each unit's
  release every byte the root keeps is compared with the image, by the pages the kernel has, and the preprocessor's
  stacks are filled with a pattern), on one lane: musl's 1,336 units, plainly and with `-g`; Lua's 34 with `-Wall
  -Wextra`, plainly and with `-g`; `sqlite3.c` with `shell.c` twice, plainly and with `-Wall -Wextra -g`: the same
  bytes in each of the three, and no difference from the image after any of the units.
- **`test-check-units`,** 2,032 checks: its own section (eleven commands' units against each alone, what their lanes
  captured, dropped and started from, and each kind of byte a fault leaves in a root reported by the check), and the
  suite's other sections, all with root images on, their poisoned runs checked. `test-check-units --corpus` on
  c-testsuite's 220 programs and on `tests/units/root-image` (thirteen units that each leave the preprocessor's state
  another way, and three with syntax errors), plainly and checked.
- **The fault round** (`scripts/faults/`, `results/faults.tsv`): each mutant of the capture, the resume, the restore
  and the two arena helpers built and run against those tests.

36 of the 41 mutants fail a test. The five that pass change no output:

| mutant | why nothing fails |
| --- | --- |
| `restore-scratch-skip`: the scratch spellings' chunk is copied back as well as cleared | the same bytes; it costs the copy the pull request saves |
| `capture-output`: the image keeps the capturing unit's output record | every start reserves an output and overwrites it |
| `initialize-live`: a second preprocessor may bind a root a unit is bound to | a replay's options name no root (`replay-root`) |
| `replay-root`: a replay's options name the unit's root | a bound root isn't bound again (`initialize-live`) |
| `resume-options`: a unit that starts from the image keeps the capturing unit's options | the units' options differ in their diagnostics' stream alone, and the C library gives the next unit's stream the address the last one's had |

The last is the one a test can't see: the stream is the only thing a lane's units' options differ in that an output
depends on, and its address repeats.

## Reproducing

```sh
# On the 9700X, in ~/buster-fast-bench/3070-claude-euler: scripts/setup.sh COMMIT makes base/ (main) and copies the
# empty units and Lua's sources; head/ is a clone of base/ with the pull request applied.
scripts/build9700.sh base base; scripts/build9700.sh head root2        # each takes the lock
scripts/measure.sh 7 $PWD/results/root2 base=$PWD/bin/base off=$PWD/bin/root2,--root-image=off on=$PWD/bin/root2
scripts/single.sh 5 $PWD/results/single base=$PWD/bin/base head=$PWD/bin/root2
scripts/profile.sh $PWD/bin/root2 $PWD/results/profile-root2
python3 -I scripts/table.py results/root2 base
# The fault round, in a checkout with the pull request built (Develop): python3 scripts/faults/run.py, and
# python3 scripts/faults/harness.py for lane.c's mutants.
```
