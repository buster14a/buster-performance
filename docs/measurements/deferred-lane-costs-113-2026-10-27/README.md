# The deferred reader's lane costs, 2026-10-26 to 2026-10-28

The 9700X's measurements for the Buster PR that closes issue [#113](https://github.com/buster14a/buster/issues/113)
with the two lane-cost follow-ups PR [#448](https://github.com/buster14a/buster/pull/448) left ("Not done here"), done
together so that the lane rule is fitted once:

- **The first lane reads the costliest part.** `lane_parts_by_cost` puts the costliest part first, exactly, and the
  deferred reader's first lane, the calling thread, reads it itself. Before, the last lane to reach the partition's
  sync, a woken one, took it, and a woken lane walks a body at about half the first lane's speed on this host.
- **No lane waits for another.** `parts_by_cost` makes `lane_parts_by_cost`'s parts and order on one thread, so the
  reader cuts its bodies before `lane_run` and the first lane starts its part at once.
- **A lane's arenas are reserved before the lanes and kept across readings.** Each lane's five arenas are one mapping
  of base pages, which the calling thread reserves the first time the state runs that lane; before, each lane mapped
  and advised its five arenas inside the lane at every reading.
- **The rule.** One lane, and one more per `lane_tokens` of the bodies' tokens beyond their critical path, the larger
  of the largest body (the first lane's) and twice the second largest (a woken lane's); `lane_tokens` is 1,024 and a
  quarter of the top level's tokens, since a lane's copy of the reader grows with the top level. #448's rule was one
  lane, and one more per 12,288 tokens beyond twice the largest body's.

Three sessions made these runs: the hand-off of 2026-10-26 (campaign 1, the ways to take the parts), the hand-off of
2026-10-27 (campaigns A, B and CT, on the branch's code on main `43030b89`), and the session that merged that code
with main and opened the PR, on 2026-10-28 (campaigns A2, B2 and CT2, the same comparisons on the merged tree against
main `cd9c5c9b`, with the merged tree's tests and mutants). Cited by Buster's `docs/c-deferred-bodies.md` ("How many
lanes").

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `before` | `0d8349d3`: #448's head, its rule and the race for the costliest part (built for a setup check the 2026-10-26 hand-off reports, whose runs aren't in `logs/first.txt`) | 469 | `e785f739d114549a3859f2e93fe9025ccc9b01a845ce74aa1b4acfc56eccc6a1` |
| `variants` | `1113b556`: `before` with the costliest part first (`c8c6f5f8`), the first lane's take (`06eb8a17`) and `benchmark-checker-deferred --take race\|ends` for these runs alone (`1113b556`) | 469 | `02a48b74c7f4003ff97ae3d0c578eff17eee48aa89318bb68417327fa99a39d4` |
| `main` (2026-10-27) | `43030b89`: main at the 2026-10-27 hand-off's base, with #448, #469 and #498: #448's rule, arenas reserved inside the lanes | 488 | `7dc730d95302f18ba2324aeadd896ec464b40f75abda75789cdc4d0893d80b3b` |
| `head` | `bbdbb4f1`: `main` with the costliest part first, the first lane's take, the state's memory kept and the parts cut before the lanes; #448's rule | 488 | `f755c11f92f514b1c3f277ca9b2ea861376a9a014e14c113dcc5def22b353b7a` |
| `final` | `5238b4db`: `head` with the tests' commit and the rule | 488 | `c3ed806826a3e27c4a82dcd8967f9031810e3110eff4b1fe07d0891b474a9eae` |
| `main` (2026-10-28) | `cd9c5c9b`: main when the branch was merged with it | 504 | `8b98f7e6f01cce975d2e41575bcf5040e0c7386f4a80dd5cd79b22096a7c0c38` |
| `branch` | `54a3b6da`: `final` merged with `cd9c5c9b` (the PR's code; its later commits change documentation and a comment alone) | 504 | `0518a39a88d41dcddeac8afbb11e1651fb8cc56473fce888f76611bb4d35933c` |

Each manifest (`source-*.sha256`) lists the SHA-256 of `build.sh` and of every file under `src/` of the tree (what the
build reads), in the order `sha256sum build.sh; find src -type f | LC_ALL=C sort | xargs sha256sum` writes them, and
each matches `git archive` of its commit. Each tree was built on the host by Buster's `./build.sh` with
`BUSTER_DEBUG_INFO=0`, as the 9700X job builds it (`build-*.txt`). `-every` after a tree's name is its binary with
`--every-lane` (every lane the bodies can take), and `-warm` with `--warm` (the state kept from one reading to the
next, as a process's readings after its first); without `-warm`, every deferred reading releases its state first, as
a process's one reading does.

The inputs, as in [#448's record](../deferred-lane-rule-113-2026-10-25/README.md):

- six of c-testsuite's single-exec programs at commit `5c7275656d751de0e68b2d340a95b5681858ed07` (`inputs.sha256`,
  #448's record's; these runs read four of them) and the frozen `sqlite3.c` of
  [#113's record](../deferred-bodies-113-2026-10-25/README.md);
- 38 synthetic units (`synthetic.sha256`, with their generator): #448's 28 from `gen.c`, the same bytes as there, and
  ten from `scripts/first-gen2.c`, which is `gen.c` with a second body's size: `gen2 B S [bare|heavy|-] [F] [S2]`
  writes `B` bodies of `S` blocks of 52 tokens each, the first of `F` blocks and the second of `S2`, after `stdio.h`,
  `stdlib.h` and `string.h` (`-`), no header (`bare`) or thirty of the C library's headers (`heavy`). Each unit but
  the bare ones also has glibc's six small `static inline` bodies. The names are `h` (three headers), `b` (bare), `x`
  (heavy), `l` (a first body of its own, `fF`) and `d` (two of their own, `fF` and `sS2`), then `BxS`: one large body
  beside smaller ones (`l16x5f384` to `l4x38f384`) and two large bodies of different sizes (`d2x1f384s288` to
  `d16x19f384s192`) are the new ones;
- for the c-testsuite sweeps, the 220 programs of Buster's `tests/c-testsuite/subset.txt` at the same commit.

Every file is read with the frozen corpus's pinned predefines and headers, as in the earlier records (`runs.sh`'s
options). `SOURCE_DATE_EPOCH=1792454400`; `CPATH` and `C_INCLUDE_PATH` are unset. Host: AMD Ryzen 7 9700X, clang
23.1.1. CPU 2 has the performance governor and energy preference; CPUs 0, 1 and 3 to 7 have powersave and
`balance_performance` (#448's record). The command is

```sh
./build/compiler benchmark-checker-deferred --passes 24 --lanes L --cpus 2,0,1,3,4,5,6,7 [--every-lane] [--warm] [the options] FILE
```

with `--passes 12` for `sqlite3.c`, each unit and lane count in a process of its own (`scripts/runs.sh`). Each pass
parses the unit and checks it by source order's `check_input` and by the deferred reader on one lane and on `L`, in
the six orders of the three readings in turn; a figure is the median of the passes, in nanoseconds per token. A unit's
change on `L` lanes is its reading on `L` against its reading on one lane in the same process. A lock hold covered one
batch of jobs (`batch.sh`), the order of the units and of each job's runs rotating by round.

## The runs

| Log | Scripts | Trees and runs | Units | Rounds | Lock holds |
| --- | --- | --- | --- | ---: | --- |
| `logs/first.txt` (2026-10-26) | `first-queue1.sh`, `first-batch.sh`, `first-runs.sh`, `first-jobs1.txt` | `variants-every` on 2, 3, 4 and 8 lanes (the first lane's take, the default); `variants-every-race` (the race, as #448) and `variants-every-ends` (the first lane takes from the costliest end of the order and the others from the cheapest) on 2 and 8 | 43; the race and the ends on 18 of them: three of c-testsuite's programs, `sqlite3.c` and the 14 of one large body or two | 3 | 12 of about 11 jobs |
| `logs/A.txt` (2026-10-27) | `chainA.sh`, `queue.sh`, `batch.sh`, `runs.sh`, `jobsA.txt` | `head-every` on 2, 3, 4 and 8 lanes, `head-every-warm` on 2 and 8, `main-every` on 2 and 8; and `benchmark-lanes` by `main` and `head` | 43 | 3 | 24 of 6 jobs |
| `logs/B.txt` (2026-10-27) | `chainB.sh`, `chainB2.sh`, `chainB3.sh`, `queue.sh`, `queue2.sh`, `batch.sh`, `jobsB.txt` | `main` and `final` on 8 lanes, each by its own rule | 43 | 3 | round 1 and round 2's first batch in batches of 15 jobs, then the rest of round 2 and round 3 in a hold each |
| `logs/CT.txt` (2026-10-27) | `chainB3.sh`, `batchCT2.sh` | `final` on 8 lanes, by its rule | c-testsuite's 220 | 1 | 1 |
| `logs/A2.txt` (2026-10-28) | `2-master.sh`, `2-chain.sh`, `2-queue.sh`; `2-master2.sh`, `2-queue-resume.sh`; `2-batch.sh`, `2-runs.sh`, `2-jobsA.txt` | as `logs/A.txt`, with `branch` for `head` and the 2026-10-28 `main` | 43 | 3 | 5 of 6 jobs, then 10 of up to 11 (37 s at the most) |
| `logs/B2.txt` (2026-10-28) | `2-master2.sh`, `2-queue-resume.sh`, `2-batch.sh`, `2-runs.sh`, `2-jobsB.txt` | the 2026-10-28 `main` and `branch` on 8 lanes, each by its own rule | 43 | 5 | a round each (20 s at the most) |
| `logs/CT2.txt` (2026-10-28) | `2-master2.sh`, `2-batchCT.sh` | the 2026-10-28 `main` and `branch` on 8 lanes, by their rules, their order alternating by program and round | c-testsuite's 220 | 3 | a round each (6 s at the most) |

Campaign B was planned for five rounds; with a dozen sessions waiting for the lock (about 20 minutes an acquisition),
it was cut to three: `chainB3.sh` ran the rest of round 2 and round 3, a hold each, and the c-testsuite sweep, after
`chainB.sh`'s batches of 15 jobs stopped (`chainB2.sh`, written to run round 3 in two holds, ran none). The sweep of
c-testsuite by both rules (`queueCT.sh`, `batchCT.sh`), which `chainB.sh` and `chainB2.sh` would have run last,
isn't in the log: `chainB3.sh` started it afresh with the branch's rule alone. The campaigns' lock-waiting messages
went to files of their own, which aren't published; the builds' and the 2026-10-28 tests' logs have them inline. The
logs are as the runs wrote them, each run's heading, its output and its exit status. The one run that exits with status 1,
c-testsuite's `00078.c` in each sweep, is a unit the deferred reader leaves to source order (a body declares something
with linkage), for which the benchmark fails having said why.

`scripts/grid.py` reads the logs into rows, a process each, and summarizes them by run, unit and lane count over the
rounds (`tables/summary*.tsv`); `rule.py` and `rule2.py` evaluate rules on a grid's summary; `compare.py` and
`compare2.py` make the before and after tables. The tables below come from them.

## The ways to take the parts (campaign 1)

On `variants`, each unit's reading with `--lanes` 2 and 8 (every lane its bodies can take, up to that) against one
lane, the medians of three rounds, and the passes in which the first lane read the largest body (`largest_first`), of 72 (36 for
`sqlite3.c`):

| Unit | Bodies | Largest | Second | `--lanes` | The race | The first lane's take | Ends | The race's first lane read the largest | The take's |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `00200.c` | 2 | 20420 | 30 | 8 | +19.8% | +1.5% | +3.4% | 3 of 72 | 72 of 72 |
| `00200.c` | 2 | 20420 | 30 | 2 | +19.8% | +2.3% | +2.6% | 5 of 72 | 72 of 72 |
| `00204.c` | 108 | 566 | 482 | 8 | +16.2% | +16.1% | +11.6% | 13 of 72 | 72 of 72 |
| `00204.c` | 108 | 566 | 482 | 2 | -3.2% | -2.3% | -3.0% | 4 of 72 | 72 of 72 |
| `00182.c` | 11 | 197 | 131 | 8 | +23.5% | +22.6% | +22.9% | 1 of 72 | 72 of 72 |
| `00182.c` | 11 | 197 | 131 | 2 | +2.5% | +1.5% | +1.6% | 0 of 72 | 72 of 72 |
| `sqlite3.c` | 2608 | 28603 | 15706 | 8 | -12.8% | -12.6% | -12.5% | 36 of 36 | 36 of 36 |
| `sqlite3.c` | 2608 | 28603 | 15706 | 2 | -7.7% | -7.7% | -7.9% | 36 of 36 | 36 of 36 |
| `l16x19f192.c` | 22 | 9989 | 993 | 8 | +6.3% | -0.2% | -0.5% | 17 of 72 | 72 of 72 |
| `l16x19f192.c` | 22 | 9989 | 993 | 2 | +0.4% | -2.1% | -2.4% | 17 of 72 | 72 of 72 |
| `l16x38f192.c` | 22 | 9989 | 1981 | 8 | -0.9% | -4.9% | -4.4% | 4 of 72 | 72 of 72 |
| `l16x38f192.c` | 22 | 9989 | 1981 | 2 | -3.3% | -3.6% | -3.3% | 18 of 72 | 72 of 72 |
| `l16x38f384.c` | 22 | 19973 | 1981 | 8 | +0.9% | -5.0% | -4.9% | 9 of 72 | 72 of 72 |
| `l16x38f384.c` | 22 | 19973 | 1981 | 2 | -2.4% | -4.5% | -3.9% | 16 of 72 | 72 of 72 |
| `l16x77f384.c` | 22 | 19973 | 4009 | 8 | -5.4% | -9.2% | -8.6% | 8 of 72 | 72 of 72 |
| `l16x77f384.c` | 22 | 19973 | 4009 | 2 | -5.9% | -5.4% | -5.2% | 12 of 72 | 72 of 72 |
| `l16x5f384.c` | 22 | 19973 | 265 | 8 | +18.0% | +6.2% | +5.6% | 5 of 72 | 72 of 72 |
| `l16x5f384.c` | 22 | 19973 | 265 | 2 | +11.0% | -1.1% | -0.0% | 12 of 72 | 72 of 72 |
| `l16x10f384.c` | 22 | 19973 | 525 | 8 | +15.0% | +3.5% | +3.2% | 4 of 72 | 72 of 72 |
| `l16x10f384.c` | 22 | 19973 | 525 | 2 | +7.9% | -2.1% | -2.8% | 8 of 72 | 72 of 72 |
| `l16x19f384.c` | 22 | 19973 | 993 | 8 | +8.6% | -0.4% | -0.6% | 10 of 72 | 72 of 72 |
| `l16x19f384.c` | 22 | 19973 | 993 | 2 | +3.9% | -2.5% | -3.1% | 8 of 72 | 72 of 72 |
| `l16x10f192.c` | 22 | 9989 | 525 | 8 | +13.8% | +4.3% | +5.4% | 10 of 72 | 72 of 72 |
| `l16x10f192.c` | 22 | 9989 | 525 | 2 | +6.6% | -1.8% | -1.1% | 7 of 72 | 72 of 72 |
| `l8x38f384.c` | 14 | 19973 | 1981 | 8 | +9.2% | +0.6% | +0.2% | 4 of 72 | 72 of 72 |
| `l8x38f384.c` | 14 | 19973 | 1981 | 2 | +4.4% | -2.9% | -3.4% | 3 of 72 | 72 of 72 |
| `l4x38f384.c` | 10 | 19973 | 1981 | 8 | +15.6% | +4.8% | +4.7% | 4 of 72 | 72 of 72 |
| `l4x38f384.c` | 10 | 19973 | 1981 | 2 | +9.9% | -1.5% | -2.0% | 14 of 72 | 72 of 72 |
| `d2x1f384s288.c` | 8 | 19973 | 14981 | 8 | +9.5% | +4.4% | +4.7% | 9 of 72 | 72 of 72 |
| `d2x1f384s288.c` | 8 | 19973 | 14981 | 2 | +3.8% | +0.5% | -0.1% | 24 of 72 | 72 of 72 |
| `d2x1f480s240.c` | 8 | 24965 | 12485 | 8 | +11.5% | +2.1% | +2.4% | 2 of 72 | 72 of 72 |
| `d2x1f480s240.c` | 8 | 24965 | 12485 | 2 | +3.8% | -2.6% | -2.6% | 13 of 72 | 72 of 72 |
| `d16x19f384s288.c` | 22 | 19973 | 14981 | 8 | +1.6% | -0.7% | -0.5% | 6 of 72 | 72 of 72 |
| `d16x19f384s288.c` | 22 | 19973 | 14981 | 2 | -1.5% | -4.0% | -3.6% | 4 of 72 | 72 of 72 |
| `d16x19f384s192.c` | 22 | 19973 | 9989 | 8 | +3.7% | -2.7% | -2.3% | 8 of 72 | 72 of 72 |
| `d16x19f384s192.c` | 22 | 19973 | 9989 | 2 | +0.4% | -3.8% | -3.7% | 8 of 72 | 72 of 72 |

With the race, the last lane to reach the partition's sync took the costliest part; the first lane read the largest
body in 0 to 24 of 72 passes (2 to 24 on the 14 of one large body or two), and two lanes read a large body beside small ones
up to 11.0% slower than one (`l16x5f384`). With the first lane's take, it read it in all of them. Taking from both
ends (the first lane from the costliest end of the order, the others from the cheapest) read within 1.1 points of the
first lane's take but with `--lanes 8` on `00200.c` (two lanes, its bodies: +3.4% against +1.5%) and on `00204.c`
(eight: +11.6% against +16.1%), which the rule reads on one lane and on two; the first lane's take is the simpler,
and was chosen.

## What a lane costs (campaign A)

A lane's copy of the reader (`copy=`, the mean over the lanes that copied it) on `main`, which reserved each lane's
arenas inside the lane, and on `head`, which reserves them before the lanes start, at a process's first reading and at
its later ones (`-warm`); the arenas' reservation on the calling thread (`arenas=`); and the wake-up, from the first
lane's arrival to the last one's (`wake=`), which no lane waits for on `head`. The medians over three rounds, in
microseconds:

| Unit | Top level's tokens | `main`, 2 lanes | 8 lanes | `head`, 2 lanes | 8 lanes | `head-warm`, 2 lanes | 8 lanes | The arenas, 2 lanes | 8 lanes | The wake-up, 2 lanes | 8 lanes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `b16x19.c` | 197 | 50 | 186 | 34 | 58 | 2 | 1 | 2.1 | 6.1 | 1.8 | 12.8 |
| `h16x1.c` | 9038 | 51 | 185 | 32 | 52 | 3 | 3 | 4.2 | 16.2 | 1.7 | 2.9 |
| `h16x19.c` | 9038 | 93 | 257 | 61 | 92 | 6 | 8 | 3.4 | 7.6 | 14.8 | 14.2 |
| `h16x154.c` | 9038 | 118 | 276 | 76 | 112 | 13 | 34 | 5.9 | 10.7 | 22.1 | 19.3 |
| `x16x19.c` | 32044 | 155 | 352 | 121 | 191 | 18 | 37 | 9.7 | 18.2 | 18.4 | 15.6 |
| `l16x38f384.c` | 9038 | 109 | 281 | 73 | 112 | 9 | 23 | 4.1 | 8.7 | 18.8 | 17.3 |
| `00204.c` | 4407 | 61 | 179 | 40 | 76 | 3 | 3 | 2.2 | 6.4 | 1.7 | 3.2 |
| `sqlite3.c` | 151114 | 457 | 868 | 420 | 697 | 137 | 466 | 13.5 | 18.9 | 21.8 | 20.8 |

Over the 42 units but `sqlite3.c`, the medians are 101 and 264 µs on `main` on two and eight lanes, 69 and 102 µs on
`head`, and 6 and 9 µs on `head`'s later readings; on `sqlite3.c`, 457 and 868, 420 and 697, and 137 and 466 µs. The
arenas take 2.0 to 13.5 µs on two lanes and 4.3 to 19.6 µs on eight; the wake-up's medians are 16.8 µs on two lanes
and 15.3 on eight. A cold copy grows with the top level, whose columns it copies, and with the room for the largest
body: sixteen bodies of 993 tokens take 34 µs on two lanes with no headers before them, 61 µs after three and 121 µs
after thirty. `laptop/` has a probe of a cold copy's parts on the laptop (a 7940HS, not the 9700X; `probe-output.txt`
says how it was made): on `sqlite3.c`, 545 page faults, of which the binding events took 248, the table 137 and the
per-name columns 108; none warm.

`benchmark-lanes` (the log's first job, `lanes`), whose balance table takes parts cut by `lane_parts_by_cost`, doesn't
move: in each round, its parts balance 8 lanes to 97 to 99% of the best, in 505 to 515 µs at full speed and 679 to
688 µs with half the lanes at half speed, on `main` and on `head` alike. Its syncs, broadcasts and wake-ups, which the
change doesn't touch, vary as much between rounds as between the trees.

## The rule (campaign A's grid)

`rule.py` and `rule2.py` on `head-every`'s grid (`tables/summaryA.tsv`), the median change of each unit's reading
against one lane, lane counts between 4 and 8 interpolated:

| Rule: one lane, and one more per | Worst unit against one lane | Units within 1% of their best | Gains forgone, summed |
| --- | ---: | ---: | ---: |
| 12,288 tokens beyond twice the largest body's (#448's) | +0.0% | 20 of 43 | 99.0 points |
| 8,192 tokens beyond twice the largest body's | +0.0% | 24 | 78.8 |
| 8,192 tokens beyond the largest body's | +5.5% | 25 | 59.0 |
| 8,192 tokens beyond the larger of the largest's and twice the second's | +0.0% | 29 | 48.4 |
| the same, 6,144 tokens | +0.9% | 35 | 29.0 |
| 1,536 tokens and a fifth of the top level's, beyond the same | +0.0% | 41 | 13.0 |
| 1,024 tokens and three tenths of the top level's, beyond the same | +0.0% | 40 | 13.1 |
| 1,024 tokens and a quarter of the top level's, beyond the same (the rule) | +0.0% | 42 | 9.2 |

`tables/fit-final.txt` has each unit's lanes and change by the rule against the grid's best. On `head-every-warm`'s
grid (2 and 8 lanes alone), 256 tokens a lane beyond the same path, whatever the top level, reads every unit within
+0.0% of one lane and forgoes 14.9 points, where the rule forgoes 45.0: a rule for a state's later readings could
count far fewer tokens.

## Before and after on the hand-off's base (campaigns B and CT)

`compare.py` on `logs/B.txt`, three rounds (`tables/compareB.txt`): `final`'s rule reads every unit within +0.7% of
its one-lane reading on eight lanes (`00200.c`, which both rules read on one lane), where `main`'s reads one up to
+2.5% (`l16x5f384`, on one lane: a round of +12.8%). `final` gives 28 units more lanes than `main`, and none fewer: on
them, eight lanes against one read −13.0 to +0.6% by `final`'s rule and −9.4 to +2.5% by `main`'s. On c-testsuite (one
round, `final` alone), it reads every program on one lane but `00204.c` (two, −2.1%); its two readings of the others,
the same work, come within −2.1 to +1.1% of each other on the 62 programs of 1,000 tokens or more (a standard
deviation of 0.53%), −1.8 to +2.3% on the 27 of 100 to 999 (1.11%) and −4.0 to +3.8% on the 131 under 100 (1.41%).

## On the merged tree (2026-10-28)

The hand-off's code was merged with main `cd9c5c9b` (`branch`, `54a3b6da`), 170 commits (28 merges) past its base, and these runs
repeat its comparisons there, against that main, with the same inputs, scripts (with this work directory's paths, and
`2-` before their names) and options. `scripts/2-master.sh` ran the tests, then `2-chain.sh` the campaigns; after 234
runs of A2's first round (jobs 0 to 29), the session stopped it in a pause between lock holds and `2-master2.sh` ran B2
and CT2 first, then the rest of A2 from its first round's job 30 (`2-queue-resume.sh`, 11 jobs a hold), then the
mutants. Every run's heading and output are in its log, as written.

### The tests

On the host, each command in a lock hold of its own (`scripts/2-tests.sh`, `logs/tests2.txt`):

| Command | Result |
| --- | --- |
| `test-lanes` | every check passes (52 arena checks, 268 team operations, 432 part ranges; on 1, 2, 3 and 8 lanes, 8,008 ranges, 10,000 rounds, 9 exchanges and 13 parts inputs, none wrong) |
| `test-checker-deferred` | 72 fixtures, 1,299 checks, 708 merged, 6,480 bodies read apart, 0 failures |
| `test-call-graph`, `./build.sh check-call-graph` | 37 cases, 0 failed; 41 units, 25,137 functions, 0 cycles (3 allowed), 0 split variables |
| `test-checker-corpus --clang /usr/bin/clang --deferred 8` on c-testsuite | 219 units read apart on 8 lanes, 1 left to source order (a body declares something with linkage), 0 differences; all 220 programs as clang has them |
| the same on the frozen `sqlite3.c`, with `--symbols` | 2,608 bodies, 0 differences; its functions and objects clang's (0 unexplained) |
| `test-checker --seed 133` | 387,962 checks, 0 failures |

### Before and after (campaigns B2 and CT2)

`compare2.py main branch logs/B2.txt logs/CT2.txt` (`tables/compareB2.txt`), five rounds of each unit by each tree's
rule on eight lanes against one lane in the same process:

| Unit | Bodies | main's lanes | main, 8 against 1 | branch's lanes | branch, 8 against 1 | main on 8 | branch on 8 | branch against main on 8 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 00200.c | 2 | 1 | +0.3% (-0.3 to +0.9) | 1 | +0.5% (-1.1 to +1.2) | 55.07 | 54.81 | -0.5% |
| 00204.c | 108 | 1 | +0.4% (-0.4 to +0.5) | 2 | -3.3% (-4.6 to -2.5) | 72.94 | 70.35 | -3.6% |
| 00182.c | 11 | 1 | -0.2% (-0.5 to +0.3) | 1 | +0.2% (-0.6 to +0.8) | 69.33 | 67.87 | -2.1% |
| sqlite | 2608 | 8 | -14.0% (-14.2 to -13.9) | 8 | -15.0% (-15.3 to -14.6) | 82.74 | 81.51 | -1.5% |
| l16x19f192.c | 22 | 1 | +0.6% (+0.4 to +1.0) | 5 | -6.2% (-7.4 to -5.6) | 56.94 | 52.87 | -7.1% |
| l16x38f192.c | 22 | 2 | -3.7% (-5.4 to -3.6) | 8 | -9.2% (-9.7 to -8.5) | 57.92 | 55.04 | -5.0% |
| l16x38f384.c | 22 | 1 | +0.3% (-0.5 to +1.3) | 8 | -8.1% (-9.1 to -7.4) | 60.77 | 55.48 | -8.7% |
| l16x77f384.c | 22 | 4 | -7.5% (-8.7 to -6.7) | 8 | -11.6% (-13.6 to -10.5) | 56.39 | 54.70 | -3.0% |
| l16x5f384.c | 22 | 1 | +0.8% (+0.3 to +3.4) | 2 | -1.4% (-2.0 to -0.0) | 57.52 | 55.94 | -2.7% |
| l16x10f384.c | 22 | 1 | -0.1% (-1.4 to +0.2) | 3 | -3.8% (-4.4 to -3.4) | 57.62 | 54.84 | -4.8% |
| l16x19f384.c | 22 | 1 | +0.6% (-0.4 to +1.1) | 5 | -6.3% (-6.8 to -5.6) | 59.08 | 55.21 | -6.6% |
| l16x10f192.c | 22 | 1 | +1.2% (-0.3 to +1.6) | 3 | -4.7% (-4.9 to -3.9) | 56.86 | 54.38 | -4.4% |
| l8x38f384.c | 14 | 1 | -0.4% (-1.0 to +0.7) | 5 | -5.8% (-6.5 to -5.1) | 56.84 | 53.50 | -5.9% |
| l4x38f384.c | 10 | 1 | +0.2% (+0.1 to +0.9) | 2 | -3.3% (-4.1 to -1.7) | 56.73 | 54.46 | -4.0% |
| d2x1f384s288.c | 8 | 1 | +0.5% (-1.0 to +0.6) | 2 | +0.4% (-0.8 to +1.1) | 58.20 | 57.87 | -0.6% |
| d2x1f480s240.c | 8 | 1 | -0.1% (-0.8 to +1.3) | 4 | -2.9% (-3.9 to -2.7) | 58.29 | 56.53 | -3.0% |
| d16x19f384s288.c | 22 | 1 | +0.8% (+0.1 to +1.6) | 6 | -4.3% (-4.6 to -3.3) | 59.08 | 56.59 | -4.2% |
| d16x19f384s192.c | 22 | 1 | +0.8% (+0.7 to +2.3) | 8 | -5.7% (-7.5 to -5.3) | 58.74 | 54.96 | -6.4% |
| 00213.c | 5 | 1 | +0.0% (-3.4 to +3.5) | 1 | +0.1% (-1.8 to +0.3) | 206.15 | 204.01 | -1.0% |
| h16x1.c | 22 | 1 | +0.0% (-0.8 to +0.2) | 1 | +0.1% (-0.1 to +0.7) | 66.32 | 65.81 | -0.8% |
| h16x2.c | 22 | 1 | -0.2% (-0.3 to +0.2) | 1 | +0.2% (-0.1 to +0.7) | 65.49 | 64.33 | -1.8% |
| h16x5.c | 22 | 1 | +0.1% (+0.0 to +0.2) | 2 | +0.9% (+0.7 to +1.7) | 62.90 | 63.21 | +0.5% |
| h16x10.c | 22 | 1 | +0.0% (-0.2 to +0.4) | 3 | -0.7% (-1.6 to -0.4) | 58.92 | 57.98 | -1.6% |
| h16x19.c | 22 | 2 | -0.4% (-2.5 to +1.1) | 5 | -3.9% (-4.4 to -3.2) | 57.06 | 54.96 | -3.7% |
| h16x38.c | 22 | 3 | -3.6% (-4.1 to -3.3) | 8 | -8.1% (-8.4 to -6.8) | 54.70 | 52.85 | -3.4% |
| h16x77.c | 22 | 5 | -7.7% (-8.3 to -7.2) | 8 | -10.9% (-11.5 to -10.5) | 54.50 | 52.47 | -3.7% |
| h16x154.c | 22 | 8 | -12.3% (-13.3 to -11.3) | 8 | -12.5% (-13.7 to -12.3) | 57.42 | 57.74 | +0.6% |
| h2x40.c | 8 | 1 | -0.1% (-0.3 to +0.2) | 1 | +0.0% (-0.3 to +0.6) | 62.98 | 62.07 | -1.4% |
| h2x80.c | 8 | 1 | -0.1% (-0.2 to +0.3) | 1 | +0.4% (-0.2 to +0.5) | 58.59 | 57.75 | -1.4% |
| h2x160.c | 8 | 1 | +0.8% (-0.2 to +1.4) | 1 | -0.6% (-1.8 to +1.2) | 57.01 | 56.34 | -1.2% |
| h2x240.c | 8 | 1 | +0.5% (-0.6 to +0.7) | 1 | +0.3% (-0.3 to +0.8) | 56.75 | 56.26 | -0.9% |
| h2x320.c | 8 | 1 | +0.5% (-0.1 to +0.6) | 1 | +0.1% (-0.1 to +1.0) | 59.10 | 58.88 | -0.4% |
| h2x480.c | 8 | 1 | +0.1% (-0.2 to +1.1) | 1 | -0.1% (-0.6 to +1.1) | 58.87 | 58.73 | -0.2% |
| h64x1.c | 70 | 1 | +0.0% (-0.5 to +0.5) | 2 | +0.3% (-1.2 to +0.7) | 63.74 | 63.18 | -0.9% |
| h64x3.c | 70 | 1 | -0.0% (-0.1 to +0.2) | 3 | -3.4% (-5.8 to -2.7) | 57.31 | 55.10 | -3.9% |
| h64x10.c | 70 | 3 | -5.3% (-9.0 to -4.0) | 8 | -9.6% (-10.1 to -8.5) | 54.51 | 51.89 | -4.8% |
| b16x5.c | 16 | 1 | +0.1% (-1.1 to +0.8) | 4 | -9.9% (-10.6 to -8.7) | 60.12 | 54.50 | -9.3% |
| b16x19.c | 16 | 2 | -9.5% (-10.3 to -6.8) | 8 | -12.7% (-17.0 to -12.2) | 43.10 | 41.38 | -4.0% |
| b16x77.c | 16 | 5 | -10.5% (-12.7 to -9.4) | 8 | -14.1% (-15.4 to -13.3) | 48.80 | 46.48 | -4.8% |
| x16x10.c | 22 | 1 | +0.2% (+0.1 to +1.6) | 1 | +0.1% (-0.4 to +0.5) | 67.78 | 67.45 | -0.5% |
| x16x19.c | 22 | 2 | -0.2% (-0.8 to +0.7) | 2 | -0.1% (-1.7 to +0.5) | 68.16 | 67.36 | -1.2% |
| x16x38.c | 22 | 3 | -1.2% (-2.3 to -0.7) | 4 | -3.2% (-3.4 to -2.5) | 65.43 | 63.94 | -2.3% |
| x16x77.c | 22 | 5 | -5.1% (-5.7 to -4.4) | 7 | -6.8% (-7.3 to -6.1) | 62.54 | 61.75 | -1.3% |

Of the 43 units, `branch` gives 28 more lanes than `main` and none fewer: on them, its eight lanes read −14.1 to +0.9%
against one lane, where `main`'s read them −10.5 to +1.2%, and 3.9% faster than `main`'s eight lanes (the median;
−9.3 to +0.5%). On the 15 units both trees give the same lanes, `branch`'s eight lanes read −2.1 to +0.6% against
`main`'s (the median −1.0%). The three that `branch` reads slower on two lanes than on one, by +0.3 to +0.9%
(`d2x1f384s288`, `h64x1`, `h16x5`), are within what the same work reads apart: on the 12 units both trees read on one
lane, the two readings, the same work, came within −0.6 to +0.8% of each other over five rounds and −3.4 to +3.5% in a
round. Campaign B gives every unit the same lanes as B2, its medians within 1.7 points of B2's.

On c-testsuite's 220 programs, three rounds (`logs/CT2.txt`), `main`'s rule reads every program on one lane and
`branch`'s every one but `00204.c` (two lanes, −2.8%, −4.1 to −2.1). The other programs' two readings by each tree, the
same work, came within:

| Programs | `main` | `branch` |
| --- | --- | --- |
| 61 of 1,000 tokens or more (62 for `main`) | −0.4 to +0.7% (a standard deviation of 0.25%) | −0.7 to +0.6% (0.24%) |
| 27 of 100 to 999 | −1.0 to +1.2% (0.48%) | −0.8 to +3.0% (0.72%) |
| 131 under 100 | −1.5 to +2.2% (0.70%) | −2.0 to +2.6% (0.84%) |

The programs under 100 tokens take 39 to 69 µs to read on one lane. On them `branch`'s two readings differ by +0.38% on average,
`main`'s by +0.08%, within their standard deviations; the programs above 2% vary as much from round to round as the
two trees (`00058.c`: `branch` +4.0, −0.1 and +3.0% in its three rounds, `main` −4.8, −1.0 and −0.0%). `branch` reads
the programs on one lane in less time than `main`: 4.1% less (the median) where `main` takes under 50 µs, 2.4% from 50
to 100 µs and 1.4% from 200 µs to 1 ms, as a lane's arenas are one mapping, one `mmap` and one `madvise`, where
`main`'s lane made five `mmap`s and ten `madvise`s; two builds also differ by about 2% for their code's placement
alone (Buster's `docs/profiling.md`).

### What a lane costs, and the rule (campaign A2)

`logs/A2.txt`, as campaign A on `branch` and the 2026-10-28 `main`: a lane's copy, the arenas and the wake-up (the
medians over three rounds, in microseconds; `tables/costs-A2.txt`):

| Unit | Top level's tokens | `main-every`, 2 lanes | 8 lanes | `branch-every`, 2 lanes | 8 lanes | `branch-every-warm`, 2 lanes | 8 lanes | The arenas, 2 lanes | 8 lanes | The wake-up, 2 lanes | 8 lanes |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `b16x19.c` | 197 | 53 | 145 | 34 | 53 | 1 | 1 | 2.1 | 6.3 | 1.9 | 12.9 |
| `h16x1.c` | 9038 | 50 | 179 | 32 | 60 | 3 | 3 | 4.4 | 15.9 | 1.7 | 3.2 |
| `h16x19.c` | 9038 | 95 | 258 | 64 | 95 | 6 | 8 | 3.6 | 7.8 | 14.9 | 14.1 |
| `h16x154.c` | 9038 | 116 | 287 | 78 | 119 | 13 | 35 | 6.8 | 11.2 | 21.6 | 19.3 |
| `x16x19.c` | 32044 | 154 | 352 | 121 | 190 | 18 | 39 | 8.5 | 17.5 | 17.0 | 15.9 |
| `l16x38f384.c` | 9038 | 112 | 274 | 73 | 104 | 9 | 23 | 4.7 | 9.0 | 18.9 | 17.7 |
| `00204.c` | 4407 | 58 | 153 | 39 | 70 | 3 | 3 | 2.2 | 6.4 | 1.7 | 2.3 |
| `sqlite3.c` | 151114 | 454 | 863 | 401 | 663 | 140 | 457 | 12.7 | 18.0 | 23.3 | 22.4 |

Over the 42 units but `sqlite3.c`, the medians are 103 and 261 µs on `main` on two and eight lanes, 69 and 100 µs on
`branch`, and 6 and 9 µs on `branch`'s later readings; on `sqlite3.c`, 454 and 863, 401 and 663, and 140 and 457 µs.
The arenas take 2.1 to 12.7 µs on two lanes and 4.2 to 18.8 µs on eight; the wake-up's medians are 16.7 µs on two lanes
and 15.3 on eight. `benchmark-lanes` gives the same balance as in campaign A on both trees: parts within 98 to 99% of
the best, in 506 to 515 µs at full speed and 679 to 687 µs with half the lanes at half speed.

`rule.py` and `rule2.py` on `branch-every`'s grid (`tables/summaryA2.tsv`, `tables/fitA2.txt`):

| Rule: one lane, and one more per | Worst unit against one lane | Units within 1% of their best | Gains forgone, summed |
| --- | ---: | ---: | ---: |
| 12,288 tokens beyond twice the largest body's (#448's) | +0.0% | 19 of 43 | 107.5 points |
| 8,192 tokens beyond twice the largest body's | +0.0% | 23 | 89.0 |
| 8,192 tokens beyond the largest body's | +4.8% | 23 | 68.6 |
| 8,192 tokens beyond the larger of the largest's and twice the second's | +0.0% | 27 | 57.2 |
| the same, 6,144 tokens | +0.5% | 31 | 36.8 |
| 1,536 tokens and a fifth of the top level's, beyond the same | +0.0% | 38 | 16.0 |
| 1,024 tokens and three tenths of the top level's, beyond the same | +0.0% | 39 | 14.4 |
| 1,024 tokens and a quarter of the top level's, beyond the same (the rule) | +0.0% | 39 | 10.8 |

The rule still forgoes the least and reads no unit slower than one lane; the four units it leaves more than a point
from their best gain 3.0 to 13.4% where their best is 4.3 to 15.3% (`d16x19f384s288` on six lanes, `h64x3` on three,
`b16x19` on eight, `x16x38` on four). On `branch-every-warm`'s grid, 256 tokens a lane beyond the same path reads every
unit within +0.0% of one lane and forgoes 13.0 points, where the rule forgoes 46.9.

### Mutants (2026-10-28)

`scripts/2-mutants-chain.sh` built each of `mutants.py`'s mutants of `branch` at `-O1` (`make_mutant.py`, which checks
that each replacement matches once) and ran the suites it names, `test-lanes` under a timeout of 60 s and
`test-checker-deferred` of 120 s, each mutant in a lock hold of its own (`scripts/2-run_mutant.sh`; `logs/mutants2/`
has each one's result, build and suites' output). Every one fails:

| Mutant | What it changes | `test-lanes` | `test-checker-deferred` |
| --- | --- | --- | --- |
| `m1-order-first-part` | the parts' order with its first part first, not its costliest | parts' checks wrong: 55, 71, 71 and 69 on 1, 2, 3 and 8 lanes | |
| `m2-parts-lane-count` | `parts_by_cost` cutting for one lane more than it is given | 45, 39, 39 and 39 | 168 failures |
| `m2b-parts-unbounded` | `parts_by_cost` without its bound at the most lanes a group has | aborted at 257 lanes: stack smashing detected | |
| `m3-first-lane-races` | every lane taking from the counter, the first lane too | | 9 |
| `m4-parts-for-every-lane` | the parts cut for every lane the reader is given, not the rule's | | 18 |
| `m5-no-reservation` | the lanes' arenas not reserved before the lanes | | 974 (no unit merged) |
| `m6-release-keeps-mapping` | a release that doesn't unmap the lanes' mappings | | 723 |
| `m7-memory-not-kept` | a state that doesn't keep the lanes' memory across readings | | 554 |
| `m8-stamps-not-cleared` | the lane's name stamps not cleared | | 8 |
| `m9-mask-not-cleared` | the deferral mask not cleared | | hangs, killed after 120 s |
| `r1-largest-twice` | the rule's path the largest body twice, as #448's | | 27 |
| `r2-largest-alone` | the rule's path the largest body alone | | 24 |
| `r3-no-top-share` | the rule's count without the top level's share | | 708 |
| `r4-ceiling` | the rule's division rounded up | | 60 |
| `r5-every-lane-ignored` | `CheckDeferred.every_lane` not read | | 473 |

The hand-off's mutants (`scripts/mutants.py` and `run_mutant.sh`, on the laptop) failed alike, with counts a little
apart (`m2` 159, `m3` 11, `m5` 931, `m6` 680, `m7` 538, `m8` 11, `r3` 696, `r4` 59, `r5` 461): its lanes' mutants
ran on its code before the rule's commit, and the merged tree has a fixture more (main's `vla-header-spans`).

## Limitations

The synthetic units are of one statement shape; the rule's count holds for them and for c-testsuite's programs and
`sqlite3.c`, on this host, whose CPUs other than 2 run the powersave governor: a woken lane's half speed is that host's,
and a machine whose cores all run at the first lane's speed would pay for lanes sooner. The reader alone is timed
(`check_input`'s work), not the checked graph after it. The units and programs of a few dozen tokens take tens of
microseconds to read, so their changes are noise of a few percent either way. Readings compared across two builds
(`main` against `branch` on eight lanes, or on one) also carry their code's placement, which moves a build by about 2%
on this host (Buster's `docs/profiling.md`, "Comparing two versions"); the comparisons that decide are each unit's
eight lanes against one lane in the same process. A2's first round ran in two parts (jobs 0 to 29, then 30 to 43 an
hour later, after B2 and CT2); each of its rounds still has every job once. The laptop probe is the shape of a cold
copy on a busy 7940HS, not a measurement of the 9700X.
