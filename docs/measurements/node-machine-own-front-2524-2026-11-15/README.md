# The node machine's own front (buster#2524, step 1b), 2026-11-15

[buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1 timed the machine's sweeps on records made
from the graph the reader's coded walk writes. Step 2 removes that walk for a taken expression, so the machine has to
make its records itself. This record measures what the walk costs by its parts, and a front of the machine's own
(`c_check_node_machine_front.c`, `measure-node-machine --shadow --front|--front-first`) that makes the records from
each chunk's acting tokens and classes, in the shadow, with the walk's nodes as its oracle. The design's section is
"Step 1b: the machine's own front" in `docs/node-machine.md`.

Host: the Ryzen 7 9700X (`benchpress`), under its lock, a hold a run or a short series; Release builds; `taskset -c 2`;
TSC ticks at 3,792.9 MHz. The pull request's sources are build `f4` (checked: `f4.patch`'s source files are the
branch's commit `e08f43ae9` against main `6c59018e4`).

## Findings

1. **The walk is 12.0 ms of `-c sqlite3.c`, and its batch's flushes are 2.6 ms of that.** Reusing the walk's batch as
   the machine's records would skip the flushes alone: 22 of the 99 cycles a body token the design counts for the
   graph's construction.
2. **The front makes every record the walk's node:** 315,966 records on `sqlite3.c`, 90,801 on Lua, 618,853 on musl,
   no difference, with `-g` and run before the walk too. It makes whole 98.50%, 97.43% and 97.22% of the expressions
   the machine takes (97.76%, 96.14% and 94.76% of their evaluated nodes); what it leaves is mostly an operator above
   a `sizeof`.
3. **It costs 55% of what it would replace.** Run before the walk on `sqlite3.c`: 4.97 ms, against the walk's actions
   and visits, 9.05 ms. With the tokens, classes and entries it reads too, the machine's reading is 7.76 ms against
   the walk's 11.85 (65%).
4. **Staggering its columns was worth 30% of its time** (7.11 to 4.97 ms): its arrays were each a multiple of 4 KB
   long, so a record's fields lay in one set of the first-level cache. Keeping its counters in registers was not
   worth anything (68 M instructions where 57 M did).
5. **An operand is within 64 records of its consumer all but always:** 165,574 of `sqlite3.c`'s 165,576, the rest in
   a byte. This is what [buster#2850](https://github.com/buster14a/buster/issues/2850)'s layout asks of the front.
   A root's operand is not (1.4% to 2.9% are a body away): the tree puts a control's closing token after its body.
6. **For step 2:** the machine measured is 140 to 156 cycles a body token (65 its reading, 75 to 91 its sweeps),
   where the design expected 55 and its conservative case 90. The design's own sum then gives 1.23 to 1.25 times on
   `-c sqlite3.c`, over the gate's 1.2 and under the 1.3 expected.

`scripts/tables.py` prints every table below from the result files (`results/tables.txt` is its output).

## Builds

| label | sources | what |
| --- | --- | --- |
| `m8` | main `b9ebe0415` | the walk as it is, for job1 |
| `e1` | `m8` with `patches/e1.patch` | TSC ticks around the coded walk's flushes, and their sizes (`BUSTER_EXPERIMENT_FLUSH=1`) |
| `m9` | main `6c59018e4` | the baseline of the whole-driver comparison |
| `f1` | `m9` with `patches/f1.patch` | the front as first built (commit `eaff15631` on main `6c59018e4`) |
| `f2` | `m9` with `patches/f2.patch` | `f1` with the front's counters as locals and each token's parent read a chunk first |
| `f3` | `m9` with `patches/f3.patch` | `f2` with the front's columns staggered |
| `f4` | `m9` with `patches/f4.patch` | `f1` with the front's columns staggered: the pull request's sources |

## 1. The coded walk by its parts

`-c sqlite3.c --time-stages --lanes 1`, seven runs each of `m8` and `e1` in turn (`scripts/job1.sh`,
`scripts/walk-o.sh`):

| ms (medians) | `m8` | `e1` |
| --- | ---: | ---: |
| the chunks' acting tokens and classes | 0.403 | 0.435 |
| the identifiers' and literals' entries (`prepare`) | 2.316 | 2.356 |
| the classes' actions | 9.034 | 9.018 |
| the visits | 0.212 | 0.185 |
| the walk | 11.971 | 12.058 |
| `e1`: the batch's flushes, inside the actions | | 2.619 |

The flushes write 322,432 nodes in 2,413 batches. Nodes by batch size (1, 2, 4, to 1,024): 113, 226, 510, 1,467,
3,660, 8,943, 15,274, 21,441, 32,138, 63,353, 175,307: 74% in batches of over 256.

## 2. Every record the walk's node

The shadow's one reading (`--passes 0`), `f4`, the same counts in every run and in both orders:

| | acting tokens | left | records | differ | values left waiting | stack resets | machine-taken expressions made whole | their evaluated nodes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 466,925 | 7,069 | 315,966 | 0 | 0 | 0 | 50,276 of 51,042 (98.50%) | 250,549 of 256,292 (97.76%) |
| Lua (34 files) | 282,317 | 3,944 | 90,801 | 0 | 0 | 0 | 10,165 of 10,433 (97.43%) | 55,400 of 57,625 (96.14%) |
| musl (1,336 units) | 2,828,420 | 304,173 | 618,853 | 0 | 0 | 8 | 20,961 of 21,561 (97.22%) | 103,895 of 109,639 (94.76%) |

Tokens left, by class:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| scalar (the walk's own visits) | 2,697 | 1,623 | 208,461 |
| prefix | 971 | 487 | 41,398 |
| of all classes, `sizeof` and `_Alignof` | 945 | 401 | 36,834 |
| binary | 1,356 | 701 | 24,429 |
| ternary | 20 | 54 | 22,232 |
| return | 21 | 5 | 4,780 |
| terminator | 914 | 328 | 928 |
| condition | 108 | 257 | 620 |
| call | 580 | 209 | 391 |
| member | 0 | 0 | 449 |
| cast | 193 | 144 | 101 |
| literal | 99 | 95 | 162 |
| subscript | 23 | 3 | 146 |
| initialize | 87 | 38 | 76 |

In the cloud (Develop build, the same sources) its copies of the corpora give no difference either, with `-g` too
(its `sqlite3.c` is another copy: 315,917 records).

## 3. What the front costs

`scripts/job5.sh` (`front-o.sh`, `front-musl-o.sh`): seven readings of `sqlite3.c` and Lua and three of musl by `f4`
with no option (the walk as it is), `--front` (the front after the walk acted at a chunk) and `--front-first` (before
it), the three in turn. Medians, ms:

| | `sqlite3.c` | Lua | musl |
| --- | ---: | ---: | ---: |
| the walk as it is: tokens and classes | 0.427 | 0.187 | 1.552 |
| its entries | 2.359 | 0.707 | 4.432 |
| its actions, with the flushes | 8.830 | 3.166 | 26.274 |
| its visits | 0.215 | 0.186 | 5.194 |
| the walk | 11.854 | 4.263 | 37.483 |
| the front after the walk | 4.167 | 1.719 | 15.216 |
| the front before the walk | 4.973 | 1.838 | 16.620 |
| the walk's actions where the front ran first | 8.019 | 3.066 | 25.715 |
| the front before the walk, of the walk's actions and visits | 55% | 55% | 53% |
| tokens, classes, entries and the front, of the walk | 65% | 64% | 60% |

The front's ticks are its own pass over the chunks; the comparison is outside them. Where it runs first it takes the
caches' first touches of what both read, and the walk's actions are then 0.8 ms shorter on `sqlite3.c`.

Its function's events in the `--front-first` reading of `sqlite3.c` (`scripts/perf-events.sh`: one process an event,
at periods under the kernel's sampling limit; samples times period, millions; callees apart):

| | cycles | instructions | mispredicted branches | an acting token |
| --- | ---: | ---: | ---: | --- |
| `f1` | 34.6 | 54.4 | 0.263 | 74 cycles, 116 instructions |
| `f2` | 39.8 | 68.4 | 0.279 | |
| `f3` | 28.4 | 67.6 | 0.259 | |
| `f4` | 23.4 | 57.2 | 0.237 | 50 cycles, 122 instructions, 0.5 mispredicted |

## 4. The stagger, and counters in registers

In turn in one hold, five readings each (`scripts/job3.sh`, `scripts/job4.sh`), the front's ms:

| | `sqlite3.c`, before the walk | after | Lua, before | after |
| --- | ---: | ---: | ---: | ---: |
| `f1` (job4's rounds) | 7.114 | 6.672 | 2.499 | 2.391 |
| `f2`: counters as locals, parents read first (job3: `f1` 7.207, 6.672, 2.488, 2.402) | 7.532 | 6.795 | 2.732 | 2.625 |
| `f3`: `f2` staggered | 5.031 | 4.258 | 1.989 | 1.889 |
| `f4`: `f1` staggered | 4.973 | 4.168 | 1.815 | 1.713 |

- `f1`'s hottest instruction was the load of an operand's place in the postorder (`perf-first-1-annotate-front.txt`,
  `sub 0x18028(%rbp,%rdi,4),%r11d`): a field of a record written a few records before. Each of the front's arrays was
  a multiple of 4 KB long in one block, so a record's twenty-odd fields were 4 KB apart.
- `f2`'s locals are stack slots: the function has more live values than registers. Its 14 M more instructions are
  the loop that reads the parents first and the copies in and out.

## 5. Operands as distances

`f4`, the same in every run:

| | operands | within 64 records | 65 to 254 | further | calls' arguments past 64 | taken expressions with an operand past 64 (their nodes) | roots' operands past 64 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 165,576 | 165,574 | 2 | 0 | 0 of 32,581 | 2, 0.004% (176, 0.069%) | 1,623 of 56,681 |
| Lua | 52,751 | 52,746 | 5 | 0 | 0 of 10,425 | 3, 0.029% (225, 0.390%) | 251 of 13,184 |
| musl | 314,578 | 314,573 | 5 | 0 | 12 of 51,040 | 4, 0.019% (314, 0.286%) | 809 of 57,888 |

A root is a discard, a condition, a return's conversion or an initialization, whose operand is its expression's
value. The comparison checks each distance: it must be one more than the front's own records between the walk's two
nodes.

## 6. `-c sqlite3.c` is unchanged

Whole processes in `time-runs`' order, 21 runs a build (`scripts/ab.sh`, `scripts/ab-copies.sh`):

| | wall ms | user cycles, M | instructions, M | peak RSS, KiB |
| --- | ---: | ---: | ---: | ---: |
| `m9` | 123.251 | 598.668 | 1,364.42 | 236,372 |
| `f1` | 122.580 (-0.54%) | 595.326 (-0.56%) | 1,363.12 | 241,100 |
| `m9`, three fresh copies | 123.368 | 597.420 | 1,364.42 | 236,380 |
| `f4`, three fresh copies | 122.801 (-0.46%; over copies -1.12% to +0.03%) | 595.538 (-0.32%; -1.26% to +0.20%) | 1,363.12 | 236,360 |

`f1`'s 4.7 MB more of peak in the first comparison was its executable's file, not the compile: `--time-stages` gave a
start RSS of 5,844 KiB for `f1`'s executable and 1,852 for `m9`'s (`results/9700x/*/stages-rss.txt`), and from fresh
copies the peaks are the same.

## 7. Mutation checks

In the cloud (`scripts/mutate.py`, `scripts/mutations.sh`, `results/cloud/mutations.txt`): one build of the front
with 33 single changes, each selected by an environment variable: an operator, the operands' order, each leaf field,
a member, the arguments' order and count, a cast's type, a return's type, a discard's type and operator, a switch
condition's operator, the omitted conditional's operands, a list's value context, the contexts a left token makes
unknown, an operand's distance, each column a chunk boundary keeps (place, node, use, operator, token), the library
mark, an enumerator's value, the hand-over of a group to a parent that takes it and to one that doesn't, and the full
stack's two paths. Every one shows as differences or as values left waiting in one of `test-checker`'s three
fixtures. 28 show on `sqlite3.c` or Lua too; five (the omitted conditional, the full stack's two, a kept record's
operator and token) show in none of the three corpora (`results/cloud/mutations-musl.txt`).

## Checks

- `test-checker --seed 133` in four parts: 842,196 checks, 0 failures (cloud, Develop).
- `./build.sh check-call-graph --config Release`: 0 cycles (cloud, on `f1`'s sources).
- The self-check (`-fsyntax-only -Wall -Werror` of `main.c`) and the self-parse pass.

## Traps

- **A runner that lost its specs.** `front-o.sh` and `front-musl-o.sh` first looped over `"$@"` inside a loop over the
  runs and reset the positional parameters in it: `job2` made one reading of musl an option and nothing else
  (`job2.log`'s first three lines). `job2b` is the job after the fix.
- **`perf record` above the kernel's sampling limit.** `perf-front.sh`'s period of 40,003 cycles asked for 137,000
  samples a second; the kernel kept about 55% (500 M cycles by the samples, 903 M by `perf stat`). Its files give
  shares, not counts. `perf-events.sh` uses periods under the limit.
- **An executable's page-cache state is in the peak RSS** (section 6): compare from fresh copies.
- **`time-runs --copies` needs its `--directory` to exist** (`ab-copies.sh` makes it).
- **The cloud VM's ticks mislead here:** it showed the front at 28 M to 60 M ticks on `sqlite3.c` from run to run.

## Files

- `scripts/`: `build-label.sh`, `lock.sh`; job1: `job1.sh`, `walk-o.sh`; the front's runs: `front-o.sh`,
  `front-musl-o.sh`, `fronts.py` (a set of files' medians), `job2.sh`, `job2b.sh`, `job3.sh`, `job4.sh`, `job5.sh`;
  `perf-front.sh`, `perf-events.sh`; `ab.sh`, `ab-copies.sh`; `tables.py`; the cloud's `shapes-local.sh`,
  `mutate.py`, `mutations.sh`; `medians.py` (the earlier records').
- `patches/`: `e1.patch`, `f1.patch` to `f4.patch` (each against the main revision of its build).
- `results/9700x/LABEL/`: each build's log, revision and checksum, and its runs: `walk-a-N.txt` (job1),
  `front-{walk,after,first}-{sqlite3,lua,musl}-SUFFIX-N.txt` (suffix `a`: job2b; `f2`: job3; `f34`: job4; `r`: job5),
  `events-first-*.txt`, `perf-*-symbols.txt`, the annotations; `ab-m9-f1/`, `ab-copies-m9-f4/`; the holds and the
  jobs' logs.
- `results/cloud/`: the mutation runs. `results/tables.txt`: `tables.py`'s output.
