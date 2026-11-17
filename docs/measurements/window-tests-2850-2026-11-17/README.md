# The tests on the window (buster#2850, step 2): 2026-11-17

The set's and the silence tests of [the node machine](https://github.com/buster14a/buster/blob/main/docs/node-machine.md),
made from the window the front writes once the kernel has made a chunk's records in place:
`measure-node-machine --shadow --window-tests`. The first half of
[the piece's specification](https://github.com/buster14a/buster/issues/2850#issuecomment-6951406678): the inputs
where the record is made, and the loop 64 records a step. In the shadow: no compile takes it.

- Base: buster main `9a1422eab` (`results/9700x/base2-o`: its readings in the job's turns). The piece:
  `patches/tests-o.patch` against it (`results/9700x/o`), which is the pull request's sources.
- Three earlier jobs of the piece: `k` against main `0e8342dd7` (`results/9700x/base`), and `m` and `n` against
  `9a1422eab` (`base2-m`, `base2-n`: the base's readings in their turns). Section 2 has the four side by side.
- 9700X: CPU 2, Release, each run its own hold of the lock (`scripts/lock.sh`), readings in turn
  (`scripts/turns.sh`). TSC ticks, a record of the expressions the tests ran on.
- Tables: `python3 scripts/tables.py results/9700x o base2-o` (`n base2-n`; `m base2-m`; `k base`).

## 1. The result (`BASE=9a1422eab... BASE_LABEL=base2 scripts/job-tests.sh o tests-o.patch 7`)

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the tests as a pass over T's columns, at the base, in the same turns | 83.0 | 112.4 | 158.4 |
| **the tests on the window** | **54.1** | **69.5** | **111.8** |
| of which the records' bytes | 8.9 | 9.8 | 16.6 |
| the loop | 0.7 | 0.9 | 1.9 |
| an expression's part | 7.2 | 7.7 | 13.6 |
| the tests that read T's records still | 37.2 | 51.1 | 78.8 |
| T again for them, not counted | 48.0 | 48.7 | 46.2 |
| with every warning (one reading) | 72.6 | 81.1 | 136.4 |
| beside `--verify` (one reading) | 61.3 | 78.8 | 136.2 |

Medians of seven readings in turn, musl's of three. Every reading:

- `sqlite3.c`, all: 53.77, 54.74, 53.94, 54.10, 54.19, 54.18, 54.00; the records' bytes 8.85 to 8.96; the loop
  0.69 to 0.91; an expression's part 7.17 to 7.28; the tests on T's records 36.94 to 37.84.
- Lua, all: 69.45, 69.54, 69.47, 69.63, 69.24, 69.26, 69.47.
- musl, all: 109.95, 111.82, 112.23.

The base's own form is read as before, by its sets (`--front-sweeps`: T, C and X; `--front-own-tests`: with the own
form; ticks a record T typed): 138.5 and 221.5 on `sqlite3.c`, 164.0 and 276.4 on Lua, 267.4 and 425.8 on musl.

**How the window's ticks are read.** Four sweeps a chunk, a `rdtsc` pair each: the records' bytes; the loop; each
expression's part; then the tests that read T's records, each expression's after T has made its records again. A
fifth sweep runs T alone on the same expressions, and its ticks are taken off the fourth's. T runs back to back in
the fifth and between other code in the fourth, so what is left for the tests is, if anything, high.

Counts (the same in every reading, and in the four jobs):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| expressions the tests ran on | 50,993 | 10,839 | 43,415 |
| their records | 289,838 | 76,304 | 224,326 |
| records the bytes and the loop ran over | 321,434 | 91,252 | 377,187 |
| operands further back than the block before | 970 | 129 | 386 |
| declarations' lines whose byte was made | 18,295 | 6,687 | 36,782 |
| roots whose record is apart from their operand's | 10,812 | 1,609 | 6,413 |
| records listed for the tree's tests | 27,791 | 4,844 | 17,871 |
| operators listed for tests of their own | 48,645 | 16,513 | 36,260 |
| records sent to the census's code | 901 | 903 | 1,796 |
| expressions walked | 1,049 | 446 | 1,306 |
| expressions whose bits, root's kind or span differ from the census's code's | 0 | 0 | 0 |

With every warning the operators listed are 62,602, 19,138 and 45,924 and the records sent 14,964, 2,976 and
10,529; no expression differs.

## 2. The piece's four jobs

The sources changed between them only in what the fault campaign found (section 6): `k` to `m`, fixture lines;
`m` to `n`, a root's record has no tree's test and is no write, and a root's bytes stay where they are put; `n` to
`o`, one test read a second time (test code alone).

| ticks a record | `k` (base `0e8342dd7`) | `m` (base `9a1422eab`) | `n` (the same) | `o` (the same): the pull request |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c`: the base's own form | 87.1 | 83.8 | 82.3 | 83.0 |
| the tests on the window | 55.3 | 54.6 | 54.1 | 54.1 |
| the records' bytes | 8.9 | 8.9 | 8.9 | 8.9 |
| the loop | 0.7 | 0.7 | 0.7 | 0.7 |
| an expression's part | 7.7 | 7.6 | 7.2 | 7.2 |
| the tests that read T's records still | 38.0 | 37.5 | 37.3 | 37.2 |
| T again, not counted | 47.5 | 47.8 | 51.9 | 48.0 |
| Lua: the base's own form | 111.9 | 110.6 | 109.6 | 112.4 |
| the tests on the window | 71.6 | 70.2 | 69.6 | 69.5 |
| T again, not counted | 48.8 | 48.6 | 52.9 | 48.7 |
| musl: the base's own form | 166.2 | 145.9 | 162.9 | 158.4 |
| the tests on the window | 118.4 | 117.6 | 114.5 | 111.8 |
| T again, not counted | 46.4 | 46.0 | 47.9 | 46.2 |

- **The base's own form** is a difference of two sets' medians: 82 to 87 on `sqlite3.c` over the four jobs, and
  146 to 166 on musl, whose readings are three. The base's executable is the same in `m`'s, `n`'s and `o`'s turns.
- **`n`'s executable reads T again 4 ticks a record more.** Read again in turn on `sqlite3.c`
  (`results/9700x/{n,o,m}/again-sqlite3-N.txt`): `n` 51.61, 51.68, 51.82; `o` 47.92, 48.06, 47.83; `m` 47.62,
  47.82, 48.09. The fourth sweep rises with it, and what is left for the tests is the same in the three: 37.14 to
  37.45, 37.05 to 37.82, 37.36 to 37.79.
- **Its code is the same.** `node_machine_type`, `node_facts_reader_flush` (with the window's passes inlined) and
  `node_census_reader_expression` are the same instructions at the same addresses in `n`'s and `o`'s executables
  (`results/9700x/code-same-n-o.txt`, `placements.txt`), which differ in one test function and what follows it.
  Not explained beyond that.

## 3. Against the specification's gate

1. **Exact: met.** No expression differs on the three corpora here, nor in the cloud container on them and the
   compiler's own source, with the default warnings, with every warning and beside `--verify` (section 7).
2. **No walk for the loop: met.** The walks are 2.06%, 4.11% and 3.01% of the expressions, the own form's.
3. **40 ticks a record on `sqlite3.c`: not met.** 54.1. Refuted at 65: no.

## 4. What moved it, and what didn't

Each variant is a patch against main `0e8342dd7`, built and read by `scripts/job-short.sh` (three readings on
`sqlite3.c` and Lua, one on musl). `sqlite3.c`, ticks a record:

| variant | what | the records' bytes | an expression's part | the tests on T's records | all |
| --- | --- | ---: | ---: | ---: | ---: |
| `a` | six gathers a step of sixteen; the lists compressed | 9.4 | 9.1 | 36.8 | 56.0 |
| `b` | a loop a record for the bytes, its choices `?:` and `&&` | 22.4 | 8.9 | 37.2 | 69.2 |
| `c` | `b`, with the lists as bit words | 22.8 | 7.3 | 37.7 | 68.5 |
| `d` | `c`, the loop written without branches (clang made one mask a branch) | 21.1 | 7.5 | 37.5 | 66.9 |
| `e` | `a`'s gathers with `c`'s bit words | 9.4 | 7.4 | 38.9 | 56.5 |
| `f` | `e`, the bytes' pass run twice and the second timed | 5.5 | 7.6 | 37.6 | 51.4 |
| `g` | `e` with comments and an unused class removed | 9.4 | 7.4 | 37.6 | 55.1 |
| `h` | `g` with the loop a record, its mask opaque to the compiler | 14.2 | 7.5 | 37.6 | 60.2 |
| `i` | `g` with the three passes out of line | 9.3 | 7.5 | 37.4 | 55.1 |
| `j` | `h` with the three passes out of line | 15.9 | 7.5 | 37.6 | 61.8 |
| `k` | `g` with a leaf told by its kind, not its operator | 8.9 | 7.7 | 38.0 | 55.3 |

- **The gathers stay.** A loop a record is slower in every form tried: 22.4 with branches, 21.0 where the source
  has none and the binary has one, 14.2 with none in the binary, 15.9 out of line.
- **The branch clang made.** In `d` the name's line's number is `entries[x] & (0u - (leaf & (kind ==
  BUSTER_NODE_FACTS_IDENTIFIER)))`. Clang loads `entries[x]` only where the mask is set, by a branch on whether the
  record is a placed leaf (`results/9700x/d/perf2-annotate-flush.txt`, at `1f65a41`). `h` passes the mask and the
  entry through an empty `asm` so that the `and` stays one.
- **A second run of the gathers is 5.5** (`f`). The other 3.9 of a first run are each declaration's line's byte made
  by the census's code at the line's first leaf, and the records' lines read where the kernel left them.
- **Lists as bit words cost what compressed lists cost** (`a` against `e`): the part falls by 1.6 and the tests that
  read the bits rise by 2.2. The words are less code and no store a listed record.
- **Out of line changes nothing** (`i`, `j`), though inlined the passes sit in one function of 2,500 instructions
  and keep eleven values on its stack.

The profiles (`scripts/perf.sh`, `scripts/perf2.sh`; `results/9700x/a`, `d`): by symbol the window's passes are
inlined into `node_facts_reader_flush`; `d`'s annotated listing has the loop a record at `1f659f0` to `1f65b77`.

## 5. Not this piece's to change (`job-tests.sh`'s steps 3 and 4)

- **The window without the tests** (`--front-window`, three readings in turn, the base against the piece). The same
  records are made and left. Ticks a record of the windows:

  | | the kernel in place | the front | the names' pass, a name |
  | --- | ---: | ---: | ---: |
  | `sqlite3.c`, `base2` | 15.70 | 52.38 | 22.74 |
  | `sqlite3.c`, `o` | 15.71 | 53.26 | 22.37 |
  | Lua, `base2` | 20.17 | 69.57 | 93.82 |
  | Lua, `o` | 20.24 | 71.33 | 93.57 |
  | musl, `base2` | 18.67 | 87.53 | 69.67 |
  | musl, `o` | 18.97 | 93.14 | 70.16 |

  musl's front's readings: 87.53, 87.16, 89.68 at the base; 93.14, 88.77, 93.35 in `o`.
- **The front reads more with the piece in every job, with the same instructions.** On `sqlite3.c` +2.6%, +1.2%,
  +1.7% and +1.7% (`k`, `m`, `n`, `o`); on Lua +4.2%, +3.2%, +2.8% and +2.5%; on musl -0.7%, +1.4%, +0.4% and
  +6.4%. `node_front_chunk_window` is the same 1,705 instructions in the base's and the piece's executables,
  `node_front_chunk_lean` the same 1,168 and `node_front_keep` the same 582: not a line of their disassembly
  differs once addresses are taken out (`scripts/code-same.sh`, `results/9700x/code-same-base2-o.txt`). The four
  builds of the piece have them at one place (`scripts/placements.sh`, `results/9700x/placements.txt`), 6,064
  bytes before the base's and 16 bytes further into a 64-byte line: one placement, read four times. No counter
  was read on it beyond that.
- **The kernel in place** read 15.63 and 16.01, 20.20 and 20.58, 18.72 and 19.48 in `k`'s turns against its base;
  15.60 and 15.70, 20.24 and 20.23, 18.76 and 18.87 in `m`'s; 15.60 and 15.69, 20.22 and 20.26, 18.66 and 18.81
  in `n`'s.
- **`-c sqlite3.c` as whole processes** (`scripts/compile.sh`: 7 runs of each of 3 copies of base, head and base
  again, twice): wall +0.12% and -0.02% (the base again +0.08% and +0.14%); user cycles 0.00% and +0.02% (-0.10%
  and +0.30%); instructions 1,362.10 M in both (+32); the peak 241,792 KiB against 241,520, with 3 more minor
  faults. In `n`'s turns: wall -0.18% and -0.16%, user cycles -0.11% and -0.07%.

## 6. Faults (`scripts/mutants.py`, `results/cloud/campaign/`)

Each fault is a text of the new code replaced by a faulty one, in a copy of the tree: a Debug build, then the node
machine's tests (`test-checker --seed 133 --part 5/8`). A fault the tests don't fail survives. Three passes:

| pass | the code | faults | fail the tests | survive | not built |
| --- | --- | ---: | ---: | ---: | ---: |
| 1 | before the fixture's new lines | 63 | 30 | 16 | 17 |
| 2 | job `k`'s | 92 | 79 | 10 | 3 |
| 3 | job `n`'s | 87 | 84 | 3 | 0 |

A fault that was not built left a variable unused; each was written again for the next pass.

**After pass 3: 85 of 87 fail the tests.** Its third survivor took every expression for one the window holds
whole. The window's test of values without room at a chunk's end is now read again with the tests on the window
(8,259 expressions run there, none of the 64 cut), and the fault fails it (`campaign/pass3-after.txt`). The two
that stay change no bit a test can read:

- `b-every-record-placed`: every record's bytes made, a tested expression's or not. No test reads the bytes of a
  record that is not a tested expression's.
- `e-span-any-token`: a token past the unit's count taken into an expression's span. The front gives every record a
  token of the unit's. The bound is on an index into the events' prefix, and is kept.

What the earlier passes' survivors gave:

- **Fixture lines** (the seventh fixture's `w` and `r`): a name's leaf without a line (`b-stray-*`), a register
  object's member (`b-register-at-any-record`), an ordering under a bitwise operator (`l-tree-no-relational`), an
  address constant the record doesn't hold whole (`b-constant-*`), expressions of some 140 records whose constant
  operand is further back than the block before and whose tests are in their last words (`l-no-far-*`,
  `l-far-*`, `e-word-*`, `e-set-first-block-only`), an initializer of as many (`e-span-first-sixteen`), and an
  aggregate only a root's record copies (`e-set-without-root`). The fixtures' counts of what the loop lists and
  sends are pinned.
- **Removed, with no difference on the four corpora:** a leaf's test of its operator (`b-leaf-any-operator`); a
  root's record's bits for the tree's tests and the writes (`e-root-no-tree`, `e-root-no-write`,
  `e-root-write-not-last`); the undoing of a root's bytes after its tests (`t-stand-in-not-undone`).
- **Dropped from the list:** `c-bits-not-compared`, a fault in the comparison itself, which no correct build
  shows.

## 7. In the cloud container

The piece's sources on main `9a1422eab` (`scripts/checks.sh`, `results/cloud/checks/`; 4 CPUs, native host,
Release):

- `test-checker`, all eight parts: 842,775 checks, 0 failures (`test-checker/status.txt`).
- The shadow on `sqlite3.c`, Lua, musl and the compiler's own source in 11 modes: 44 runs, every one exits 0
  (`shadow/status.txt`). With `--window-tests` (default warnings, `-Wall -Wextra`, `--verify`, `-g`) no expression
  differs: 50,996, 10,839, 43,415 and 38,225 expressions.
- The self-check, the self-parse, `test-call-graph` and `check-call-graph`: status 0.
- The complete driver (`-DBUSTER_COMPLETE_DRIVER=1`): the heavy list and the workflow's parse pass. Of the light
  list's five headings one fails, as on main in this container: "Test the preprocessor on the repository's
  translation units against clang". The container's clang names its resource directory
  `/usr/lib/llvm-23/lib/clang/23`; the 45 differences are that path and nothing else (`complete-light.log`).
- The sanitizer rows a pull request's checks don't run (`scripts/sanitizers.sh`, `results/cloud/sanitizers/`):
  native memory, address and thread, a build each, `test-checker --part 5/8` (210,328 checks, 0 failures), and for
  memory and address the shadow with `--window-tests` and with `--window-tests -Wall -Wextra --verify` on
  `sqlite3.c`, Lua and the compiler's own source. No report.
- An earlier round of the rows (`results/cloud/sanitizers-earlier/`), before the fixture's last lines and the two
  removals: memory and address clean; thread was stopped for the new round.

The pull request's head is the same diff on main `8bd7f27ec`, which moved by one merge that touches none of its
files (`results/cloud/head/`): a build, `test-checker --part 5/8` (210,328 checks, 0 failures) and the sixteen
`--window-tests` runs, with no difference (the compiler's own source: 38,112 expressions there).

## Files

- `patches/tests-a.patch` to `tests-k.patch`: the variants of section 4, each against main `0e8342dd7`.
  `tests-m.patch`, `tests-n.patch` and `tests-o.patch`: against main `9a1422eab`; `o` is the pull request's sources.
- `scripts/`: the 9700X's (`setup.sh`, `build-label.sh`, `turns.sh`, `corpora.sh`, `lock.sh`, `job-tests.sh`,
  `job-short.sh`, `compile.sh`, `perf.sh`, `perf2.sh`, `code-same.sh`, `placements.sh`), `tables.py`, and the cloud
  container's
  (`checks.sh`, `sanitizers.sh`, `shadow-limited.sh`, `checker.sh`, `corpora-cloud.sh`, `mutants.py`).
- `results/9700x/<variant>/`: each reading's whole report (`window-tests-<corpus>-N.txt`), the build's log and
  revision; `base/`, `base2-m/`, `base2-n/` and `base2-o/` the bases' sets in `k`'s, `m`'s, `n`'s and `o`'s turns;
  the jobs' logs.
- `results/cloud/`: the checks', the sanitizer rows' and the campaign's outputs. Their `revision.txt` name the
  worktree's own commits: `74d1bfe69` is `tests-o.patch` on main `9a1422eab`, and `973af36fc` the same diff on main
  `8bd7f27ec`, the pull request's commit's tree.
