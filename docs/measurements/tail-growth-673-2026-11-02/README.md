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
- `measure1.sh` is the first exploratory queue.
- `measure2.sh` is the `fb1ba1e2` qualification, stopped after three runs when the review changed
  the code.
- `measure3.sh`, `measure3b.sh` and `measure4.sh` are the variant comparisons.

**Filtering.** The logs keep only the lines the harness and `time-runs` print: `prime`, `sample`,
`result` and `pair`; `memory:`, `run`, `list`, the summaries and `time-runs:`. `exclusive.sh`'s
lines while waiting for other holders were dropped. Objects are replaced by their digests.

**Layout.** `raw/final/` holds `head`'s qualification and `raw/exploratory/` the earlier runs:

- each group's log and its `time-runs` logs;
- the receipts and the object digests;
- the queues' progress files.

Each group's cohort directories are in `raw/cohorts-final.tar.xz` and `raw/cohorts-exploratory.tar.xz`
(370 and 407 cohorts, primers included). Each cohort keeps every compile's `--time-stages` output,
its usage record and `perf stat` counters, and the cohort's `argv.txt`. To reproduce
`summary-final.tsv` byte for byte:

```sh
cd raw/final && xz -dc ../cohorts-final.tar.xz | tar x
clang -O1 -o growth_stats ../../growth_stats.c
./growth_stats w2-main-3ce71ec3-r1.log w2-head-e7416f30-r1.log w2-main-3ce71ec3-r2.log w2-head-e7416f30-r2.log \
    w0-main-3ce71ec3-r1.log w0-head-e7416f30-r1.log w0-main-3ce71ec3-r2.log w0-head-e7416f30-r2.log \
    w1-main-3ce71ec3-r1.log w1-head-e7416f30-r1.log
```

`summary-exploratory.tsv` is the same over `raw/exploratory`'s eleven group logs.

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

- Each build has one code placement. `time-runs` compares two copies of each executable, not other
  placements.
- Physical DRAM traffic was not measured: the 9700X's DF counters await validation
  ([buster-performance#49](https://github.com/buster14a/buster-performance/issues/49)).
- The tail cost shows only where a file is short of lanes as others finish. These three workloads
  bound that from both sides, but they are not a whole real build.
- The cohorts' make, `perf stat` and resource collection are #695's. Their limitations, given in
  its report, apply here.
