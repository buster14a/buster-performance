# The node machine in shadow: #2524's step 1 (2026-11-12)

The record of [buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1. `docs/node-machine.md`'s "Step 1:
the shadow" summarizes it. Step 1 is the node machine, `src/buster/compiler/c_check_node_machine.c`, run by
`measure-node-machine --shadow` (`c_check_node_census.c`) after the pipeline on every full expression the census takes.
Every record it makes is compared with the stream's node, its tape with the lowering's entries, and its three sweeps,
T, C and X, are timed.

Everything here ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the 9700X's lock (`scripts/lock.sh`
wraps `~/buster-fast-bench/exclusive.sh`), pinned to CPU 2.

## Sources and binaries

- **The measured commit:** buster
  [`c3494a5fad340271e7864b02a9e2b52dacddccc9`](https://github.com/buster14a/buster/commit/c3494a5fad340271e7864b02a9e2b52dacddccc9),
  on main [`2db047f3`](https://github.com/buster14a/buster/commit/2db047f350d42c9c5428058a135ec0e1d7e164da). It was
  checked out by its id on the host after `git checkout -- . && git clean -fd`, with no local change left (`git status
  --short` printed nothing), and built as `logs/build-c3494a5f.log` shows. Its compiler's SHA-256 is `f1e7723a…dc7f`
  (`results/ab/compilers.txt`).
- **The A/B's main:** `2db047f3` itself, built in a worktree of the same clone. SHA-256 `2b2b4c0f…5ebd`.
- **The series v1 to v6 and "final"** are the step's working tree as it was built up. They were not commits: each was
  the tree's changed files sent by tar onto the host's checkout of main `eedbdece` (v1 to v6) or `2db047f3` ("final").
  Their compilers' hashes are in `results/env.txt`. "final" differs from `c3494a5f` only by an unused parameter
  removed and two comments, and both run the same 90,484,400 instructions in the timed sweeps. Treat the series as
  the history of the machine's cost, and `c3494a5f` as the result.
- **The environment** (`results/env.txt`): Linux 6.18.50-2-lts, AMD Ryzen 7 9700X, the performance governor on CPU 2,
  clang 23.1.1, perf 7.2.9-1.
- **The inputs:**
  - the frozen corpus's `sqlite3.c` with the 9700X job's `compile_time` options;
  - Lua 5.4.8's 34 sources;
  - musl's 1,336 units, the first source of each base name, with the census record's options.

  Their hashes are in `results/c3494a5f/corpora-inputs.txt`.

## Commands

- `scripts/profile.sh LABEL` builds `src` in one hold (`logs/build-LABEL.log`), runs `scripts/time.sh LABEL` and then
  `perf record -c 200003 -e cycles:u` of 40 timing passes on `sqlite3.c` in another hold (`results/LABEL/perf-symbols.txt`
  holds the report by symbol; `perf.data` isn't kept).
- `scripts/time.sh LABEL` runs `measure-node-machine --shadow --passes 11` on `sqlite3.c` and on Lua's sources, both in
  one hold (`results/LABEL/sqlite3.txt` and `lua.txt`; `holder.txt` is the hold's owner line).

  A pass is each sweep set, T alone, T and C, and T, C and X, over every taken expression of a file, interleaved. Each
  set's least cycles, instructions and TSC ticks over the 11 passes are kept, read from this thread's user-mode
  counters, and divided by the taken evaluated nodes. C's and X's own costs are the differences of the sets.
- `scripts/corpora.sh LABEL` runs `measure-node-machine --shadow --verify --passes 0` on the three corpora, each
  without and with `-g`, one hold a run (`results/LABEL/verify-*.txt`). For `c3494a5f` each hold's owner line was
  appended to `verify-holds.txt` first; the earlier labels' script didn't write them. `--verify` types every node
  that a table row or a direct rule types by the action too, and counts the nodes where the two differ (`twin`).
- `scripts/ab.sh` runs `time-runs --runs 21 --warmups 2` of `-c -o /dev/null sqlite3.c` by main's compiler and
  `c3494a5f`'s in one hold, whole processes in a Williams design's order (`results/ab/time-runs.txt`).

The lock's messages naming other sessions' holds were removed from the logs and from the earlier labels' `verify-*`
files, which caught them. They were the `exclusive.sh: waiting` lines, which carry their command on one line. The
files hold nothing else of other sessions'. The Lua sources' path is another session's folder of inputs, as in the
census's record.

## Results at `c3494a5f`

| | `sqlite3.c` | Lua 5.4.8 | musl, 1,336 units |
| --- | ---: | ---: | ---: |
| census-taken expressions, evaluated nodes | 51,448, 260,139 | 10,841, 61,207 | 23,037, 120,332 |
| machine-taken expressions | 32,676 (63.51%) | 5,612 (51.77%) | 13,488 (58.55%) |
| machine-taken evaluated nodes | 130,559 (50.19%) | 25,073 (40.96%) | 56,144 (46.66%) |
| entries compared | 166,504 | 28,506 | 68,642 |
| differences: values, entries, twin | 0, 0, 0 | 0, 0, 0 | 0, 0, 0 |
| the same with `-g` | 0, 0, 0 | 0, 0, 0 | 0, 0, 0 |
| T's nodes by a row or a rule, by the action | 75,973, 7,238 | 14,416, 5,098 | 30,299, 4,699 |
| cycles a taken evaluated node: T, C, X, all | 96.5, 39.7, 30.4, 166.6 | 116.4, 40.3, 26.2, 182.9 | not timed |
| instructions a taken evaluated node, all | 693.1 | 867.7 | |

Every run exited 0. The command exits 1 on any difference.

What the machine refuses of the census-taken nodes is its codes. On `sqlite3.c`, 49.34% of the nodes are in 18,651
expressions with an operator it has no code for, and the first such operator is a call in 12,836 of them. Another 0.47%
are in 121 expressions with a node the templates don't take. Lua's figures are 55.90% and 3.14%.

## The machine's cost as it was built (`sqlite3.c`)

| label | what changed | T | C | X | all | instructions |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| v1 | the rows, and the action for every other node | 116.0 | 52.3 | 35.4 | 203.7 | 932.7 |
| v2 | a discard by the graph run's own steps | 111.8 | 48.6 | 33.6 | 194.0 | 841.2 |
| v3 | member, truth and store rules; each record's class and facts kept | 100.2 | 47.5 | 34.0 | 181.7 | 746.9 |
| v4 | address, dereference and pointer rules; the records' operators and operands kept | 99.7 | 39.5 | 32.4 | 171.6 | 699.9 |
| v5 | one word a type | 99.4 | 39.6 | 31.1 | 170.1 | 695.7 |
| v6 | each record's value written as two halves | 96.1 | 42.9 | 31.9 | 170.9 | 693.1 |
| final | v6 at main `2db047f3` | 95.7 | 43.7 | 31.9 | 171.3 | 693.1 |
| `c3494a5f` | the pushed commit | 96.5 | 39.7 | 30.4 | 166.6 | 693.1 |

"final" and `c3494a5f` run the same instructions and differ by 2.8% in cycles: that is about how far the placement
alone moves this figure. v2's first run didn't rebuild: tar had kept the files' older modification times. Its
directory holds the run after a fresh copy.

The profiles (`perf-symbols.txt`, shares of the whole process of 40 timing passes, which the sweeps are most of) show
where T goes:

- the type table's kind column, read at random by each record's type, was the largest single line at v4
  (`c_types.c:1439`, 8.4%);
- `check_action_source_complete` grew to 7.3% once the member and pointer rules called it in place of the action;
- the 96-byte values copied between records failed store forwarding where they were written field by field (v5's
  hottest line, `check_value_copy`'s 64-byte load). `node_machine_operand_value` fell from 9.5% to 4.0% with v6, while
  T fell only from 99 to 96 cycles.

## `-c` is unchanged

`results/ab/time-runs.txt`, 21 runs of each executable after 2 warm-ups, in a Williams order:

| `-c sqlite3.c` | main `2db047f3` | `c3494a5f` | change |
| --- | ---: | ---: | ---: |
| median wall | 123.908 ms (123.321 to 125.851) | 123.913 ms (122.744 to 124.983) | +0.00% |
| median user cycles | 602.04 M | 600.07 M | -0.33% |
| median instructions | 1,349,584,973 | 1,349,584,990 | the same |
| median peak RSS | 236,616 KiB | 236,684 KiB | +68 KiB |
| executable | 172,480,640 bytes | 172,938,936 bytes | +458,296 |

No compile calls the machine. The executable carries its code and the baked transition table (`buster_baked`).

## Limits

- **One host, one day.** Each timing is the least of 11 passes of one process. A second process wasn't run, and the
  placement moves the figure by about 3% (above).
- **The sweeps' time is in the shadow's position.** They run after the pipeline, over the finished graph's leaf
  records and the type table, not in the reader's position, where step 2 puts them.
- **musl isn't timed:** its 1,336 units ran for the comparison only.
- **The series' trees aren't commits** (above). Only `c3494a5f` is a named revision.
- **The earlier labels' verification holds have no owner lines.** `c3494a5f`'s do.
