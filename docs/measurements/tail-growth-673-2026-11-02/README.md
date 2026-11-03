# #673's tail: a team the jobserver leaves short grows as tokens come back

Evidence for [buster#1161](https://github.com/buster14a/buster/pull/1161), part of
[buster#673](https://github.com/buster14a/buster/issues/673). Under GNU make's jobserver, an
emission took its extra lanes' tokens once, as it started
([buster#695](https://github.com/buster14a/buster/pull/695)). In an uneven build, one large file
got the spare tokens and the other none, and the second ran on one lane while the first's tokens,
returned milliseconds later, sat idle. #695's record measured that as 4.80% against uncoordinated
teams ([its report](../unclaimed-perf-2026-10-28/issue-673-spawn/REPORT.md)). In #1161 a team the
jobserver leaves short grows while it runs: lane 0 reads the jobserver's spare tokens between its
parts and admits more lanes under leases of their own.

All timings are from the Ryzen 7 9700X, each run under its shared lock (`exclusive.sh`), taken
inside the hold.

## Sources

| Name | Revision | What |
| --- | --- | --- |
| main | buster `3ce71ec312efb45fbcab4d66775e069e30d7e513` | the branch's base |
| head | buster `e7416f30c76dbc95681d6982b51f79a2808d551a` | the qualified head |
| main-a4a2182a | buster `a4a2182ad770bd22f25f843b934ba690bac9b1c8` | main after 290 more commits |
| head-132ffd0f | buster `132ffd0f66cf68a60c7575f3d5b97d2b4349150c` | the PR's head with that main merged |
| head-wip1 | tree `2443b0684fd62b7bd6b4ee134dd83c08df14b45f` | exploratory: `fb1ba1e2`'s code before its report and test changes |
| fb1ba1e2 | buster `fb1ba1e23a868dc3ec9ce8b7ca9af3b819a6b390` | exploratory: the PR's first head |
| var1, var2, var5, var6 | `fb1ba1e2` plus [`variants/`](variants/) | exploratory: a growing team's part order and count |

`main` and `head` are `git archive`s of those commits; each tree's `COMMIT` file names it. The PR's
later head, `5e777176`, adds two merges of main by the maintainer and one commit that changes only
`c_check_lanes_test.c` and a guide. Its emission code is `head`'s, but for main's unrelated changes.
`head-e7416f30-receipts.txt` in `raw/final/` has the host, the toolchain, the CPUs' governors and
the SHA-256 of both executables and every input:

- Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, GNU Make 4.4.1.
- `BUSTER_HOST_ARCH=znver5` builds.
- CPUs 0–7: one at `performance`, seven at `powersave`, as for every run here.

The variants:

- `var1`: source order.
- `var2`: the costliest part first, then source order.
- `var5`: `var2` with 16 parts per lane.
- `var6`: `var2` with 32 parts per lane.

## Method

**Cohorts.** These use #695's frozen harness: `policy_balanced`, `compile-budget.mk`, the frozen
SQLite amalgamation and its tiny unit. Their SHA-256 digests in the receipts equal the copies at
buster-performance `426ebe71c`, `docs/measurements/unclaimed-perf-2026-10-28/issue-673-spawn/`, and
`sqlite3.c`'s equals #695's report's.

- One lock hold runs one workload: real `make -j8 --jobserver-style=pipe`, under `taskset -c 0-7`.
- A full-size primer comes first, then four cycles of nine edges, so every predecessor/policy pair
  occurs four times: 12 cohorts per policy.
- The three policies all ask for `--lanes=8`. `jobserver` has `--worker-budget=8` and make's
  jobserver. `cap1` has `--worker-budget=1`. `free8` runs each compiler without `MAKEFLAGS`.
- The workloads are eight SQLite units (w0), eight tiny units (w1), and two SQLite units with six
  tiny ones (w2, the uneven tail).
- The harness compares every cohort's objects byte for byte, inside the hold.

`growth_stats.c` (original C, compile with `clang -O1 -o growth_stats growth_stats.c`) reads each
group's log and cohorts. It prints each policy's medians and the `--time-stages` `worker-budget`
line of every compile, counted by value. It fails unless:

- every sample's result is status 0 with identical objects;
- the nine pairs balance;
- every usage and counter file parses, and each counter covers its whole interval.

**Controls.** `time-runs` (buster's `profile.c`) times one SQLite `-c` compile under `taskset -c
0-7`: 11 runs and a warm-up per copy, two fresh copies of each executable, rotated. It runs four
ways:

- under a FIFO jobserver with no token, where a team starts on one lane and never grows;
- with 3 tokens, where 4 of 8 lanes are granted and the team never grows;
- with 7 tokens, the full grant;
- without `MAKEFLAGS`.

The scripts in [`scripts/`](scripts/) ran it all:

- `measure5.sh head-e7416f30` is the final qualification.
- `measure6.sh head-132ffd0f main-a4a2182a` reruns it on the integrated tree, building main too.
- `measure7.sh head-132ffd0f main-a4a2182a` times two controls over six placements of each build.
- `measure1.sh` is the first exploratory queue.
- `measure2.sh` is the `fb1ba1e2` qualification, stopped after three runs when the review changed
  the code.
- `measure3.sh`, `measure3b.sh` and `measure4.sh` are the variant comparisons.

**Filtering.** The logs keep only the lines the harness and `time-runs` print: `prime`, `sample`,
`result` and `pair`; `memory:`, `run`, `list`, the summaries and `time-runs:`. `exclusive.sh`'s
lines while waiting for other holders were dropped. Objects are replaced by their digests.

**Progress files.** Their `status=` values are always 0: each script expanded `$(date)` before `$?`. The
gates are elsewhere: each group's result lines (`growth_stats`), each `time-runs` log's last line (all 15
read `done, 0 failed processes`), and for the builds, the receipts' digests.

**Layout.** `raw/final/` holds `head`'s qualification, `raw/requalified/` the integrated tree's,
`raw/placements/` its controls over placements and `raw/exploratory/` the earlier runs:

- each group's log and its `time-runs` logs;
- the receipts and the object digests;
- the queues' progress files.

Each group's cohort directories are in `raw/cohorts-final.tar.xz`, `raw/cohorts-requalified.tar.xz` and
`raw/cohorts-exploratory.tar.xz` (370, 370 and 407 cohorts, primers included). Each cohort keeps every compile's `--time-stages` output,
its usage record and `perf stat` counters, and the cohort's `argv.txt`. To reproduce
`summary-final.tsv` byte for byte:

```sh
cd raw/final && xz -dc ../cohorts-final.tar.xz | tar x
clang -O1 -o growth_stats ../../growth_stats.c
./growth_stats w2-main-3ce71ec3-r1.log w2-head-e7416f30-r1.log w2-main-3ce71ec3-r2.log w2-head-e7416f30-r2.log \
    w0-main-3ce71ec3-r1.log w0-head-e7416f30-r1.log w0-main-3ce71ec3-r2.log w0-head-e7416f30-r2.log \
    w1-main-3ce71ec3-r1.log w1-head-e7416f30-r1.log
```

`summary-requalified.tsv` is the same over `raw/requalified`'s ten group logs, in the same order, and
`summary-exploratory.tsv` over `raw/exploratory`'s eleven.

## Results: `head` (`e7416f30`) against `main`

Whole-cohort wall time, median of 12 (ms), from [`summary-final.tsv`](summary-final.tsv):

| Workload | Build | Jobserver | Cap one | Free eight |
| --- | --- | ---: | ---: | ---: |
| Two SQLite + six tiny, round 1 | main | 147.099 | 145.331 | 139.306 |
| | head | **137.855** | 144.940 | 140.783 |
| Two SQLite + six tiny, round 2 | main | 146.914 | 144.990 | 139.926 |
| | head | **137.309** | 144.687 | 140.460 |
| Eight SQLite, round 1 | main | 301.304 | 302.414 | 321.145 |
| | head | **299.902** | 302.465 | 319.443 |
| Eight SQLite, round 2 | main | 301.201 | 303.212 | 320.512 |
| | head | **300.995** | 302.687 | 320.413 |
| Eight tiny | main | 7.225 | 7.287 | 7.223 |
| | head | 7.175 | 7.156 | 7.192 |

- **Uneven.** The jobserver policy takes 6.3% and 6.5% less wall time than main's. It is now the
  fastest of the three: 2.1–2.2% under free eight and 4.9–5.1% under cap one. In all 24 cohorts
  the file the jobserver started on one lane grew to 7 (`granted=1 active=7 grown=6 worked=7`).
- **Eight SQLite.** The jobserver moves −0.5% and −0.1%. Cap one and free eight, whose paths the
  change leaves alone, move −0.2% to +0.0% and −0.5% to −0.0%. A few files grow at the tail (to 2,
  6 and 7 lanes, round 2).
- **Eight tiny.** Ranges overlap; tiny files ask for one lane.
- **Objects.** The 2,961 objects are two digests, SQLite's and tiny's, whatever the policy or build
  ([`raw/final/head-e7416f30-object-digests.txt`](raw/final/head-e7416f30-object-digests.txt)).
- **Lanes that took a part.** One-lane compiles report `worked=1`. No compile reports more lanes
  that took a part than its team.

`time-runs` controls, SQLite `-c`, 22 runs of each build over two copies, head against main:

| Jobserver | Wall | User cycles |
| --- | ---: | ---: |
| No token: starts on one lane, never grows | +0.17% (copies −0.53% to +0.98%) | −0.03% |
| 3 tokens: 4 of 8 granted, never grows | −0.08% (−0.76% to +0.74%) | −0.04% |
| 7 tokens: full grant | +0.20% (−0.15% to +0.89%) | +0.20% |
| None | −0.38% (−0.59% to +0.10%) | −0.03% |

## Requalified on the integrated tree: `132ffd0f` against main `a4a2182a`

The PR's head after merging main `a4a2182a`, which also has `0a87cb5e`'s loop locals, rerun by
`measure6.sh` with `measure5.sh`'s method ([`raw/requalified/`](raw/requalified/)). Whole-cohort wall time,
median of 12 (ms), from [`summary-requalified.tsv`](summary-requalified.tsv):

| Workload | Build | Jobserver | Cap one | Free eight |
| --- | --- | ---: | ---: | ---: |
| Two SQLite + six tiny, round 1 | main | 138.138 | 136.267 | 130.194 |
| | head | **128.668** | 136.143 | 130.266 |
| Two SQLite + six tiny, round 2 | main | 139.665 | 135.952 | 129.558 |
| | head | **128.661** | 135.826 | 131.369 |
| Eight SQLite, round 1 | main | 282.925 | 284.608 | 300.919 |
| | head | 282.696 | 283.755 | 302.756 |
| Eight SQLite, round 2 | main | 282.742 | 283.966 | 302.206 |
| | head | 282.992 | 284.230 | 301.947 |
| Eight tiny | main | 6.631 | 6.033 | 6.508 |
| | head | 6.572 | 6.161 | 6.635 |

- **Uneven.** The jobserver policy takes 6.9% and 7.9% less wall time than main's, and is the
  fastest of the three: 1.2–2.1% under free eight and 5.3–5.5% under cap one. In all 24 cohorts the
  file started on one lane grew to 7 (`granted=1 active=7 grown=6`); in 22, all 7 lanes took a part,
  in 2, six did.
- **Eight SQLite.** The jobserver moves −0.1% and +0.1%. Main's own cohorts take 6% less than
  `3ce71ec3`'s (283 against 301 ms), and the jobserver now ties cap one. A few files grow at the
  tail (to 2 lanes, once to 6).
- **The other policies**, whose paths the change leaves alone, move −0.3% to +1.4% on the SQLite
  workloads.
- **Eight tiny.** Ranges overlap.
- **Objects.** The 2,961 objects are two digests.

`time-runs`, SQLite `-c`, 22 runs of each build over two copies, head against main:

| Jobserver | Wall | User cycles |
| --- | ---: | ---: |
| No token: starts on one lane, never grows | +0.57% (copies +0.52% to +0.62%) | +0.90% (+0.58% to +1.05%) |
| 3 tokens: 4 of 8 granted, never grows | −0.35% (−1.81% to −0.17%) | −0.19% (−1.06% to −0.03%) |
| 7 tokens: full grant | +0.17% (−0.63% to +0.79%) | +0.01% (−0.32% to +0.41%) |
| None | −0.23% (−0.30% to −0.21%) | +0.24% (−0.21% to +0.42%) |

**Over placements.** One executable per build measures one placement of its code, so `measure7.sh`
reran the first and the last rows over six placements of each build (`./build.sh shifts`, the
checker's unit 0 to 3,456 bytes later, in steps that are multiples of its 64-byte alignment) and two
fresh copies of each, 60 runs per build, with main's placements a second time as the comparison's
floor ([`raw/placements/`](raw/placements/)). An earlier attempt with shifts that aren't multiples of
64 built two placements and timed nothing.

| Jobserver | Build | Wall (over placements) | User cycles (over placements) |
| --- | --- | ---: | ---: |
| No token: never grows | head | +0.63% (−0.13% to +1.59%) | +0.73% (+0.47% to +1.14%) |
| | main again | −0.08% (−1.20% to +1.24%) | −0.12% (−0.46% to +0.40%) |
| None | head | −0.01% (−0.66% to +0.31%) | +0.31% (−0.45% to +0.83%) |
| | main again | −0.02% (−0.64% to +1.17%) | −0.13% (−0.91% to +0.60%) |

A compile whose team starts on one lane and never grows, timed alone, takes about 0.7% more user
cycles than main's one-lane emission at every placement. It executes 0.02% more instructions: the same
work at a lower rate. Its wall time, +0.6%, stays within main's own spread. `e7416f30`'s single
placement read −0.03% cycles, and `var5`'s +0.68% (Exploratory). In the cohorts it doesn't show:
in eight SQLite, where 89 and 93 of 96 compiles started on one lane and never grew, the jobserver
policy took 0.1–0.2% fewer user cycles than main's. Without a jobserver, the head is within main's
own spread.

## Exploratory

These runs came before the qualified head, and their summaries are in
[`summary-exploratory.tsv`](summary-exploratory.tsv):

- **`head-wip1`.** The uneven jobserver cohort took 136.906–136.920 ms in two rounds, against main's
  146.394–147.009 ms. Eight SQLite moved +0.4%, as did cap one (+0.3%), whose path is unchanged.
- **`fb1ba1e2`.** The uneven jobserver cohort took 136.638 ms against main's 146.960 ms.
- **Never grows.** `time-runs`, no token, against main's one-lane emission, in three runs of their own:

  | Build | Wall | User cycles |
  | --- | ---: | ---: |
  | `head-wip1` and `fb1ba1e2` (cost order, 64 parts per lane) | +1.05%, +1.36% | +1.52%, +1.38% |
  | `var1` (source order, 64) | +0.59% | +1.20% |
  | `var2` (costliest first, then source order, 64) | +0.71%, +0.83% | +0.86%, +1.24% |
  | `var6` (32 per lane) | +0.70% | +1.14% |
  | `var5` (16 per lane) | +0.20% | +0.68% |

  `head` adopted `var5`'s order and part count. Its own control above reads +0.17% and −0.03%.
- **Partial grant.** `time-runs` with 3 tokens: `fb1ba1e2` +0.16% wall and +0.62% cycles; `var2`
  +0.09% and +0.61%; `var5` −0.22% and +0.00%.

## Limitations

- The cohorts and `measure5.sh`'s and `measure6.sh`'s `time-runs` controls measure one code placement
  per build, and `time-runs` there compares two copies of each executable. Only `measure7.sh`'s
  controls are compared over placements.
- Physical DRAM traffic was not measured: the 9700X's DF counters await validation
  ([buster-performance#49](https://github.com/buster14a/buster-performance/issues/49)).
- The tail cost shows only where a file is short of lanes as others finish. These three workloads
  bound that from both sides, but they are not a whole real build.
- The cohorts' make, `perf stat` and resource collection are #695's. Their limitations, given in
  its report, apply here.
