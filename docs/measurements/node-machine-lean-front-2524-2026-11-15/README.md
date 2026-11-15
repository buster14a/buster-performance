# The front's structural bytes and a lean front (buster#2524, step 1b part 2), 2026-11-15

[buster#2857](https://github.com/buster14a/buster/pull/2857) gave the node machine a front of its own in the shadow:
records made from each chunk's acting tokens, with the walk's nodes as their oracle
([its record](../node-machine-own-front-2524-2026-11-15/README.md)).
[buster#2850](https://github.com/buster14a/buster/issues/2850)'s step 0 then ran the machine's sweeps on byte columns
at 16.7 and 20.6 cycles a taken node, on a layout that reads of a record, beside the facts the sweeps make, its
**structure**: the operator, the operand count, the operands' distances back, the parent's distance forward and the
place among the parent's operands.

This record measures the front writing those bytes itself, each checked against the walk's nodes, and a **lean
front** (`measure-node-machine --shadow --front-lean`) that writes only them, the token and a leaf's payload (an
identifier's declaration, a literal's type and integer, a string's type and object). The design's section is "The
structural bytes, and a lean front" in `docs/node-machine.md`.

Host: the Ryzen 7 9700X (`benchpress`), under its lock, a hold a run or a short series; Release builds; `taskset -c 2`;
TSC ticks at 3,792.9 MHz. The pull request's sources are build `g3` (checked: `g3.patch` is the source files' diff of
the branch's commit `456e2f154` against main `dc5820703`).

## Findings

1. **The front's structural bytes are the walk's tree.** Every record on `sqlite3.c`, Lua and musl (315,966, 90,801
   and 618,853) compares equal in all 96 readings by `g3`, whole and lean, before and after the walk: the operator,
   the operand count and each operand's distance back against the walk's node, and from the operand's side its
   consumer's distance forward and its place. The lean front's operands are found by its bytes alone.
2. **What the layout's byte columns cap:** no record has more than 63 operands. A place past 3 is a call's fourth or
   later argument: 5,098 of `sqlite3.c`'s 32,581 arguments (15.6%), 822 of Lua's 10,425 (7.9%), 6,615 of musl's
   51,040 (13.0%).
3. **The lean front reads `sqlite3.c` in 4.39 ms before the walk** where #2857's takes 4.94 (11% less), Lua in 1.41
   against 1.85 (24% less), musl in 13.50 against 17.32 (22% less). The whole front with the bytes is at 4.83, 1.66
   and 15.60.
4. **The record's width was not the front's cost.** The lean front makes about half the stores and was 9% faster than
   the whole one on `sqlite3.c` as first built. Lists, separators and groups are 27% of `sqlite3.c`'s acting tokens
   and 57% to 59% of Lua's and musl's: testing them against the top group of waiting values before the class dispatch
   took 3%, 12% and 10% off.
5. **What the machine reads is 51% of the walk** on `sqlite3.c` (65% with #2857's front), 50% on Lua and 49% on musl:
   about 51 of the 99 cycles a body token the design counts for the walk. The lean front reads none of the walk's
   identifier entries.
6. **For step 2:** the machine is then 126 to 142 cycles a body token (51 its reading, 75 to 91 the shadow's sweeps),
   and the design's sum gives 1.25 to 1.27 times on `-c sqlite3.c` (1.23 to 1.25 with #2857's front; gate 1.2,
   expected 1.3). With #2850's sweeps in place of the shadow's, if they carry into the compiler, about 1.35.
7. **A compile is unchanged once the hooks are out of the walk's function.** With the front's calls, timers and class
   counts inline in the coded walk and never run, `-c sqlite3.c` retired 0.76 M more instructions than main and read
   0.26% slower. As two functions out of line it retires 0.41 M more (0.03%) and reads -0.44%, 0.00%, +0.47% and
   -0.10% in four comparisons.

`scripts/tables.py` prints every table below from the result files (`results/tables.txt` is its output).

## Builds

All on main `dc5820703` (#2857 merged).

| label | sources | what |
| --- | --- | --- |
| `m10` | main `dc5820703` | #2857's front as merged, and the baseline of the whole-driver comparisons |
| `g1` | `m10` with `patches/g1.patch` | the structural bytes, the comparison from both sides, and the lean front |
| `g2` | `m10` with `patches/g2.patch` | `g1` with passing tokens tested before the class dispatch, a valueless terminator's reads skipped, and `--front-warm` |
| `g3` | `m10` with `patches/g3.patch` | `g2` with the front's hooks in the coded walk moved out of line: the pull request's sources |

## 1. Every record the walk's node, with its structure

The shadow's one reading (`--passes 0`) by `g3`; the same counts in every run of a corpus, in both orders, whole and
lean (`results/tables.txt`, sections 7 and 8):

| | acting tokens | left | records | differ | values left waiting | stack resets | records with more than 63 operands | operands at a place past 3 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 466,925 | 7,069 | 315,966 | 0 | 0 | 0 | 0 | 5,098 |
| Lua (34 files) | 282,317 | 3,944 | 90,801 | 0 | 0 | 0 | 0 | 822 |
| musl (1,336 units) | 2,828,420 | 304,173 | 618,853 | 0 | 0 | 8 | 0 | 6,615 |

The comparison checks the structure from both sides. From a consumer: its operand count, and each operand at the
distance its byte says (the lean front has no other way to its operands; a call's arguments are found by their
places). From an operand: its consumer's distance forward and its place must be the consumer's. A record whose
consumer's distance no compared consumer vouched for is a difference, and so is one on a value still waiting. The
machine-taken expressions the front makes whole are #2857's: 98.50%, 97.43% and 97.22%.

Acting tokens by class (the front tests the first three, which pass their values on, before its class dispatch):

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| list | 77,939 | 129,211 | 1,407,930 |
| separator | 25,586 | 7,651 | 84,373 |
| group | 22,171 | 28,427 | 113,125 |
| the three, of all | 26.9% | 58.5% | 56.8% |
| identifier | 97,472 | 25,359 | 198,354 |
| terminator | 55,955 | 31,216 | 330,489 |
| literal | 45,288 | 13,886 | 163,788 |
| binary | 43,828 | 14,875 | 135,073 |
| member | 32,623 | 9,061 | 8,627 |
| call | 13,690 | 4,590 | 36,239 |
| condition | 11,543 | 1,800 | 7,922 |
| cast | 9,125 | 4,054 | 17,079 |
| prefix | 8,669 | 4,517 | 61,964 |
| subscript | 7,130 | 638 | 3,876 |
| return | 4,344 | 1,259 | 17,814 |
| initialize | 4,163 | 1,820 | 8,033 |
| scalar (the walk's own visits) | 2,697 | 1,623 | 208,461 |
| postfix | 2,099 | 620 | 1,629 |
| string | 1,931 | 1,279 | 535 |
| ternary | 672 | 431 | 23,109 |

In the cloud (Develop build of the same sources, its own copies of the three corpora) there is no difference either,
whole and lean, in both orders, and with `-g` on `sqlite3.c` and Lua.

## 2. What the fronts cost

`scripts/job9.sh` (`front-o.sh`, `front-musl-o.sh`): seven readings of `sqlite3.c` and Lua and three of musl by each
of nine specs in turn. Medians, ms:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the walk as it is (`g3`, no front): tokens and classes | 0.432 | 0.179 | 1.592 |
| its entries | 2.368 | 0.680 | 4.429 |
| its actions, with the flushes | 8.867 | 3.182 | 26.631 |
| its visits | 0.218 | 0.183 | 4.913 |
| the walk | 11.907 | 4.235 | 37.587 |
| before the walk: #2857's front (`m10`) | 4.935 | 1.854 | 17.317 |
| the whole front (`g3`) | 4.831 | 1.657 | 15.596 |
| the lean front | 4.387 | 1.405 | 13.500 |
| the whole front, its arrays touched first | 4.812 | 1.646 | 15.533 |
| the lean front, its arrays touched first | 4.403 | 1.402 | 13.261 |
| after the walk: #2857's front | 4.163 | 1.766 | |
| the whole front | 4.022 | 1.613 | |
| the lean front | 3.463 | 1.365 | |
| the walk's entries by their parts, where the whole front ran first: the tokens' compaction | 0.468 | 0.300 | 1.865 |
| the identifiers' entries | 0.976 | 0.158 | 1.309 |
| the literals' entries | 0.857 | 0.234 | 1.401 |
| what the machine reads: #2857's front, the classes and all the entries | 7.714 (64.8%) | 2.741 (64.7%) | 23.383 (62.2%) |
| the lean front, the classes, the compaction and the literals' entries | 6.125 (51.4%) | 2.134 (50.4%) | 18.506 (49.2%) |
| the lean front, of the walk's actions and visits | 48.3% | 41.7% | 42.8% |

- The lean front decides an identifier from its token's own columns (`declared_types`, the declaration's flags), so
  the identifiers' entries are no part of what it reads. It still reads the literals' entries.
- Where the lean front ran, the walk's identifier entries took 0.81 ms on `sqlite3.c`, not 0.98 (0.73 against 0.97
  after the walk). The walk makes them in both; this record does not say why.
- `--front-warm` moves the front's ticks by under 2% here (-0.4% to +1.8%). In a cloud VM without transparent huge
  pages the first touch of the front's arrays, fresh memory in every unit, was half of its ticks on musl.

## 3. The steps

`scripts/job6.sh`: `g1` against `m10`, in turn. The structural bytes cost the whole front 1% to 2%; the lean front is
9%, 14% and 14% under it:

| before the walk, ms | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| `m10` | 4.938 | 1.864 | 17.222 |
| `g1`, whole | 5.037 | 1.903 | 17.374 |
| `g1`, lean | 4.608 | 1.633 | 14.880 |
| after the walk: `g1`, whole | 4.271 | 1.788 | |
| `g1`, lean | 3.725 | 1.591 | |

`scripts/job7.sh`: `g2` against `g1`'s lean front and `m10`, in turn. Passing tokens first took 3.2%, 12.4% and
10.2% off the lean front:

| before the walk, ms | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| `m10` | 4.947 | 1.857 | 16.836 |
| `g1`, lean | 4.556 | 1.642 | 15.005 |
| `g2`, whole | 4.838 | 1.638 | 15.251 |
| `g2`, lean | 4.411 | 1.438 | 13.467 |
| `g2`, whole, arrays touched first | 4.842 | 1.624 | 15.075 |
| `g2`, lean, arrays touched first | 4.402 | 1.427 | 13.354 |

`scripts/job8.sh`, after the walk: `m10` 4.155 and 1.766; `g2` whole 3.986 and 1.541; `g2` lean 3.463 and 1.382.

`m10`'s musl reading moved between jobs (17.22, 16.84, 17.32 ms: three runs each); the specs of a job are in turn,
so compare within a table.

## 4. The front's function's events

The `--front-first` reading of `sqlite3.c`, samples times period by symbol, millions, callees apart
(`scripts/perf-events5.sh`: five processes an event with periods two apart, under the kernel's sampling limit; a
count is about 600 samples, so within 4%):

| | cycles | instructions | mispredicted branches | an acting token |
| --- | ---: | ---: | ---: | --- |
| `m10`, `node_front_chunk` | 24.4 | 57.0 | 0.246 | 52 cycles, 122 instructions, 0.53 mispredicted |
| `g2`, `node_front_chunk` | 24.2 | 57.2 | 0.235 | |
| `g2`, `node_front_chunk_lean` | 21.5 | 49.6 | 0.199 | 46 cycles, 106 instructions, 0.43 mispredicted |
| `g3`, `node_front_chunk` | 24.8 | 54.8 | 0.241 | 53 cycles, 117 instructions, 0.52 mispredicted |
| `g3`, `node_front_chunk_lean` | 22.4 | 51.8 | 0.189 | 48 cycles, 111 instructions, 0.40 mispredicted |

`g2`'s and `g3`'s fronts are the same code; their difference here is the sampling's. The lean front is about a tenth
fewer cycles and instructions than #2857's, and a fifth fewer mispredicted branches: the walk over the acting tokens
is what remains, over a hundred instructions a token.

## 5. `-c sqlite3.c`

Whole processes in `time-runs`' order, 21 runs a build from three fresh copies of each executable
(`scripts/ab-copies.sh`):

| | wall ms, `m10` | head | against `m10` (over copies) | user cycles | instructions, M: `m10`, head |
| --- | ---: | ---: | --- | --- | --- |
| `g1` (job6) | 123.189 | 123.244 | +0.04% (-0.18% to +0.82%) | -0.18% | 1,363.10, 1,363.86 |
| `g2` (job8) | 123.178 | 123.492 | +0.26% (+0.10% to +0.62%) | +0.31% | 1,363.10, 1,363.86 |
| `g3` (job9's first) | 123.337 | 122.800 | -0.44% (-0.89% to -0.20%) | -0.31% | 1,363.10, 1,363.51 |
| `g3` (job9's second) | 123.090 | 123.092 | +0.00% (-0.29% to +0.32%) | -0.08% | 1,363.10, 1,363.51 |
| `g3` (third) | 122.959 | 123.534 | +0.47% (-0.32% to +0.99%) | +0.25% | 1,363.10, 1,363.51 |
| `g3` (fourth) | 123.157 | 123.039 | -0.10% (-0.39% to +0.06%) | -0.22% | 1,363.10, 1,363.51 |

- `g1` and `g2` have the front's hooks inline in `check_input_expressions_coded_range`: the calls of the whole and the
  lean front before and after the walk, three more reads of the TSC a chunk, the class counts' loop and the flush
  before the comparison, all behind tests of a null pointer. The function grew from 20,518 bytes to 23,717 and
  23,960 (`results/9700x/symbols.txt`, `scripts/symdiff.py`), and a compile, which runs none of it, retired 0.76 M
  more instructions.
- `g3` has them in two functions out of line (`node_front_prepared`, 312 bytes; `node_front_acted`, 5,904), called
  where the front runs. The walk's function is 17,402 bytes, under main's, which has #2857's hooks inline. A compile
  retires 0.41 M more instructions than main (0.03%); the four comparisons' times are on both sides of main's.
- Main before #2857 retired 1,364.42 M (the earlier record's `m9`): the count moves by this much with the walk's
  function's code.

## 6. Mutation checks

In the cloud (`scripts/mutate.py`, `scripts/mutations.sh`, `results/cloud/mutations.txt`): one build of the front
with 45 single changes, each selected by an environment variable, run by the whole and by the lean front on
`test-checker`'s three fixtures, `sqlite3.c` and Lua. The 33 of the earlier record, and for this one: an operand
count, a consumer's distance, a place, a call's operand count, an argument's consumer's distance and place, a kept
record's consumer's distance, the lean leaves' payloads (a literal's integer and type, a string's object, an
identifier's declaration), and a lean identifier with no declared type given a value.

- 44 show as differences or as values left waiting in a fixture: 21 in both modes, 19 by the whole front alone (they
  change columns the lean front does not write) and 4 by the lean front alone (its own payloads).
- Six show on neither `sqlite3.c` nor Lua (15, 16, 35, 36, 39, 47): the fixtures are what catches five of them.
- One shows nowhere (47, the lean identifier with no declared type). No fixture or corpus has such a token where
  the walk is coded.

The mutated build was of the sources before the hooks moved out of line; the front's file is the same.

## Checks

- `test-checker --seed 133` in its eight parts: 842,214 checks, 0 failures (cloud, Develop, the native host), and
  844,959 checks, 0 failures on a `BUSTER_HOST_ARCH=x86-64` build, where the reader's walk is the scalar one and the
  front does not run.
- `./build.sh check-call-graph --config Release`: 0 cycles (cloud).
- The self-check (`-fsyntax-only -Wall -Werror` of `main.c`) and the self-parse pass.

## Traps

- **Code that never runs still costs where it sits.** The shadow's hooks were behind a null test in the hottest
  function of the reader, and changed its code for every compile (section 5). Measure `-c` against main after adding
  a hook, and keep the hook out of line.
- **`ab-copies.sh` writes into one directory a pair of builds.** `job9.sh` ran it twice, and the second run's file
  replaced the first's: `results/9700x/ab-copies-m10-g3-first-summary.txt` is the first's summary as it was printed.
- **The cloud VM misleads on the front's ticks:** first touches of fresh pages (no transparent huge pages) and its
  ticks' noise. Conclusions here are the 9700X's.
- **Sampling error.** `perf-events.sh`'s single process an event gave `g2`'s lean front more cycles than its whole
  one (23.8 M against 22.6 M); five processes an event (`perf-events5.sh`) do not.

## Files

- `scripts/`: `build-label.sh`, `lock.sh`; the readings: `front-o.sh`, `front-musl-o.sh`, `fronts.py` (a set of
  files' medians), `job6.sh` to `job9.sh`; `perf-events.sh`, `perf-events5.sh`; `ab-copies.sh`; `symdiff.py` (text
  symbols whose sizes differ between two executables); `tables.py`; the cloud's `shapes-local.sh`, `mutate.py`,
  `mutations.sh`.
- `patches/`: `g1.patch`, `g2.patch`, `g3.patch` (each against main `dc5820703`).
- `results/9700x/LABEL/`: each build's log, revision and checksum, and its runs:
  `front-TAG-{sqlite3,lua,musl}-SUFFIX-N.txt` (suffix `g`: job6; `h`: job7; `i`: job8; `j`: job9; tags `walk`,
  `first`, `after`, `leanfirst`, `leanafter`, `warmfirst`, `leanwarmfirst`), `events-*.txt` and `events5-*.txt`
  (symbols by event), `g1`'s annotations; `ab-copies-m10-*/`; `symbols.txt`; the holds and the jobs' logs.
- `results/cloud/mutations.txt`: the mutation runs. `results/tables.txt`: `tables.py`'s output.
