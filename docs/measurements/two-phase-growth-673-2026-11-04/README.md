# #673: a growing team lowers every part before any part's code, and the policies' physical traffic

Evidence for [buster#1269](https://github.com/buster14a/buster/pull/1269), which completes
[buster#673](https://github.com/buster14a/buster/issues/673). Two things are measured here:

1. **The cost of a team that never grows.** After [buster#1161](https://github.com/buster14a/buster/pull/1161),
   a team that the jobserver leaves short cuts its bodies into parts for every lane it may take and takes them on
   lane 0 until it grows. #1161's record ([`tail-growth-673-2026-11-02`](../tail-growth-673-2026-11-02/README.md))
   found that a team that never grows took about 0.7% more user cycles than main's one-lane emission, with the same
   instructions, and couldn't say why. This record finds the cause and measures the fix.
2. **Physical traffic.** #673's first bullet asks for every policy's physical traffic; no record had it.
   [buster-performance#49](https://github.com/buster14a/buster-performance/issues/49) rejects the Data Fabric
   bandwidth aliases on this CPU and keeps the memory controllers' CAS counts. Those are counted here for every policy
   of #695's controls.

All timings and counts are from the Ryzen 7 9700X, each run under its shared lock (`exclusive.sh`), taken inside the
hold.

## Sources

| Name | Revision | What |
| --- | --- | --- |
| main | buster `747ab61770728314fce67aa61510e63cd0ce6bd2` | the branch's base, #1161 merged |
| head | buster `09e22269bc1ad0e5c1b94677dc604577b0c41079` | the change: a growing team lowers every part first |
| head-7b930910 | buster `7b930910a3276107b681be91ac633630c590cb24` | `head` plus the PR's test hook (the slow lane's sleep) |
| experiment | main plus [`experiment/variants.diff`](experiment/variants.diff) | one executable, the variants by an environment variable |

`main` and `head` are `git archive`s of those commits; each tree's `COMMIT` file names it.
[`raw/cohorts/receipts.txt`](raw/cohorts/receipts.txt) has the host, the toolchain, the CPUs' governors and the
SHA-256 of both executables and every input. [`raw/executables.txt`](raw/executables.txt) has every executable's
SHA-256: main's and head's, the 12 placements', the experiment's and the harnesses'.

- Linux 6.18.50-2-lts, clang 23.1.1, perf 7.2.9-1, GNU Make 4.4.1, `BUSTER_HOST_ARCH=znver5` builds.
- CPUs 0–7: one at `performance`, seven at `powersave`, as for every run here.

## The cause

`experiment/variants.diff` adds `BUSTER_673_VARIANT` to main's growing team: one executable, so the variants share
their code placement. Each round is one lock hold: a warm-up, then every variant once, the order rotated, each a
SQLite `-c` under `perf stat` with a FIFO jobserver that has no token, so the team starts on one lane and never grows.
The variants:

| Variant | Team | User cycles against 1 | Interquartile range |
| --- | --- | ---: | ---: |
| 1 | doesn't grow: main before #1161, the bodies as one part | 0 | |
| 5 | grows, its bodies cut into 1 part | +0.03% | −0.47% to +0.29% |
| 6 | 2 parts | +0.35% | +0.08% to +0.72% |
| 7 | 4 parts | +0.61% | +0.22% to +0.87% |
| 8 | 8 parts | +0.73% | +0.52% to +0.96% |
| 3 | 16 parts | +0.79% | +0.44% to +1.08% |
| 0 | 128 parts, as merged (16 per lane it may take) | +0.92% | +0.40% to +1.15% |
| 4 | 128 parts in source order | +0.98% | +0.66% to +1.31% |
| 9 | 128 parts, every part's lowering before any part's code | −0.08% | −0.29% to +0.16% |

Medians of 30 rounds ([`experiment/exp3`](experiment/exp3)). Instructions are within 0.02% of variant 1's
throughout, and every variant's object is the same (`experiment/object-digests.txt`). An earlier run of 40 rounds
([`experiment/exp1`](experiment/exp1), variants 0–5 of the diff's first build, without 6–9) gives the same picture,
and shows that the jobserver's reads aren't it: variant 2, which never reads it, took +0.88%.

So the cost is the turns between a part's lowering and its code. A lane takes a part's lowering, then its code, then
the next part's lowering: each turn refills its caches for the other half's code and data. One extra turn (2 parts)
costs about 1.8 million cycles. [`experiment/exp2`](experiment/exp2) counts what moves: with 16 or 128 parts, op-cache
misses rise about 3%, L2 misses 2–3% and cycles stalled on loads 1.6–2.4%. Its two event groups of six were
multiplexed, so treat those counts as estimates. One lane's stage times
([`experiment/stages.txt`](experiment/stages.txt)) give the halves' sizes: the parts' lowering takes 11.0 ms
(`lower.statements`, `lower.bodies`, `lower.validate`) and their code 4.9 ms (`tier0`).

`head` takes variant 9's order. A growing team's items are twice its parts: every part's lowering, then every part's
code, in the same order. A part's code waits until its lowering is done, since another lane may still be at it. The
growth gate weighs the work left as 11/16 of the tokens not lowered yet plus 5/16 of those not coded yet.

## Results

**The paired check.** Main against head, one SQLite `-c` under an empty jobserver, 30 rotated rounds
([`experiment/exp4`](experiment/exp4)): head's user cycles are 1.15% fewer (interquartile range −1.54% to −0.70%),
with the same instructions (+0.002%) and the same object.

**The test hook.** `head-7b930910` against `head`, the same way, 30 rounds ([`experiment/exp5`](experiment/exp5),
`scripts/exp5-run.sh`): +0.09% user cycles (interquartile range −0.18% to +0.35%), the same instructions (+0.001%) and
the same object. The hook's two compares on a growing team's path cost nothing measurable.

**Controls over placements** ([`raw/placements`](raw/placements), `measure8b.sh`, measure7's method):
`time-runs` over six placements of the checker's unit for each build, two copies each, main's placements again as
the floor.

| Control | Build | Wall time | User cycles |
| --- | --- | ---: | ---: |
| Jobserver without a token (never grows) | head | −0.77% (−1.62% to +0.16%) | −0.96% (−1.26% to −0.35%) |
| | main again | −0.04% (−0.76% to +1.00%) | +0.06% (−0.69% to +0.55%) |
| No jobserver | head | −0.05% (−0.81% to +0.78%) | +0.03% (−0.49% to +0.66%) |
| | main again | +0.09% (−0.78% to +1.11%) | −0.21% (−0.88% to +0.37%) |

The ranges are over placements. So the never-grows cost is gone, and the path without a jobserver, which the change
leaves alone, is unchanged.

**Controls at one placement** (`raw/cohorts/timeruns-*.log`, 22 runs a build):

| Jobserver | Wall time | User cycles |
| --- | ---: | ---: |
| no spare token: never grows | −0.75% | −0.71% |
| 3 spare tokens: starts on 4 of 8 lanes | −1.09% | −1.34% |
| 7 spare tokens: every lane at once, no growth | −0.01% | −0.37% |
| none | +0.37% | +0.75% |

The last is one placement's swing; over six placements it is +0.03% (above).

**Cohorts** (`raw/cohorts`, `measure8a.sh`, measure6's method; #695's frozen `policy_balanced` harness, 12 cohorts per
policy and round, `make -j8`). Whole-cohort wall time, medians, from [`summary-cohorts.tsv`](summary-cohorts.tsv):

| Workload | Build | Jobserver (ms) | Cap one (ms) | Free eight (ms) |
| --- | --- | ---: | ---: | ---: |
| Two SQLite and six tiny | main | 126.963, 124.658 | 134.380, 133.329 | 127.799, 127.505 |
| | head | 126.345, 126.092 | 134.623, 133.928 | 128.263, 127.729 |
| Eight SQLite | main | 274.187, 274.347 | 275.256, 275.679 | 294.214, 296.770 |
| | head | 274.684, 274.207 | 274.771, 275.589 | 294.561, 295.137 |
| Eight tiny | main | 5.717 | 5.434 | 5.879 |
| | head | 5.536 | 5.377 | 5.836 |

The change moves no cohort beyond its spread: the uneven jobserver −0.5% and +1.1%, eight SQLite +0.2% and −0.05%,
with the cohorts' user cycles −0.85%, −0.31%, +0.01% and +0.27%. The compile timed alone gains its 1%, but eight at
once don't show it. Their traffic (below) is the same either way, so the lowering held for the code phase doesn't
spill to memory, but the record doesn't explain why the gain doesn't carry over. The jobserver is the fastest
policy on the uneven and eight-SQLite workloads, for both builds. On the tiny workload, whose cohorts take 5–6 ms,
the three policies' ranges overlap (main's jobserver 5.48–6.26 ms, cap one 4.84–6.04, free eight 5.40–6.43). Every
cohort's objects are one lane's: two digests in `raw/cohorts/object-digests.txt`, SQLite's and the tiny unit's.

## Physical traffic

[`traffic.c`](traffic.c) (original C, adapted from #695's frozen `matrix.c` and `policy_balanced.c`) runs 15 cases in
rotated order, six rounds a build, each case its own lock hold:

- an idle case, `sleep 0.4`, for the background's rate;
- #673's matched-affinity controls: eight SQLite compiles on eight workers through #695's `matched_cohort`, pinned one
  lane each or all sharing CPUs 0–7 with one lane, the default, eight lanes, or eight capped to one by
  `--worker-budget=1`;
- #695's real-make cohorts: each workload under `make -j8` by each policy.

Each case runs inside `perf stat -a` of `duration_time` and both controllers' `umc_cas_cmd.rd` and `.wr`
(`amd_umc_0`, `amd_umc_1`), around the commands' own `perf stat`. Objects are compared byte for byte against each
workload's first. [`traffic_stats.c`](traffic_stats.c) reads every sample and prints each case's medians: CAS
commands, those less the same round's idle rate over the case's time, and the commands' counters. Bytes are 64 a CAS
command, which #49 leaves conditional: compare the counts, and the bytes only for scale. The idle rate was 0.015 GB/s
of reads.

Main's, medians of 6 ([`traffic-main-747ab617.tsv`](traffic-main-747ab617.tsv)):

| Case | Wall (ms) | Read CAS (M) | Write CAS (M) | Read (GB) | Written (GB) | CPU (ms) | Switches | Migrations | Faults |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| pinned, one lane | 288.2 | 127.7 | 76.8 | 8.17 | 4.92 | 2145.5 | 32 | 8 | 42,208 |
| shared, one lane | 277.7 | 127.8 | 76.4 | 8.17 | 4.89 | 2167.7 | 21 | 2 | 42,208 |
| shared, eight capped to one | 276.8 | 127.8 | 76.5 | 8.17 | 4.90 | 2156.7 | 33 | 2 | 42,206 |
| shared, default lanes | 295.2 | 132.2 | 81.2 | 8.46 | 5.19 | 2270.5 | 361 | 68 | 59,637 |
| shared, eight lanes | 296.4 | 132.2 | 80.9 | 8.46 | 5.18 | 2276.9 | 388 | 82 | 58,814 |
| make: eight SQLite, jobserver | 278.8 | 127.0 | 77.0 | 8.13 | 4.93 | 2154.7 | 216 | 29 | 45,572 |
| make: eight SQLite, cap one | 280.7 | 128.1 | 76.7 | 8.20 | 4.91 | 2170.8 | 72 | 14 | 45,014 |
| make: eight SQLite, free eight | 300.2 | 132.4 | 81.1 | 8.47 | 5.19 | 2275.2 | 430 | 80 | 62,906 |
| make: uneven, jobserver | 131.0 | 31.5 | 19.6 | 2.02 | 1.26 | 310.8 | 256 | 76 | 21,518 |
| make: uneven, cap one | 139.0 | 29.5 | 17.9 | 1.88 | 1.15 | 280.1 | 66 | 12 | 16,264 |
| make: uneven, free eight | 134.8 | 31.3 | 19.5 | 2.00 | 1.25 | 323.3 | 278 | 62 | 22,113 |

The tiny workload's cases read about 1.4–1.5M CAS in 10–11 ms, near the background's scale. Head's table
([`traffic-head-09e22269.tsv`](traffic-head-09e22269.tsv)) is main's within 0.6% in every case's CAS counts.

- **Uncoordinated lanes.** Eight compiles that each run the default team, or eight lanes, read 3.5% more and write
  6% more than one lane each, with 41% more page faults, 11 to 18 times the context switches, 5% more CPU time and
  6–8% more wall time (free eight against the jobserver under make: 4.2% and 5.3% more, 38% more faults, 7.7% more
  wall time). This is #673's loss, now with its traffic. The extra lanes' arenas and stacks would account for the
  faults and the writes; the record doesn't separate them.
- **Affinity.** Pinned and shared one-lane cohorts match in traffic, faults and CPU time. Main's pinned cases ran
  10 ms slower than its shared ones; head's didn't, so that is the run's spread, not affinity. Affinity isn't the
  cause.
- **The jobserver.** Its eight-SQLite cohorts match the one-lane controls in traffic, faults and time. In the uneven
  cohort, the growing team reads 7% more than cap one, about as much as free eight, for 6% less wall time: lanes cost
  traffic, and the growth spends it where it pays.
- **Scale.** One SQLite compile reads about 1.0 GB and writes about 0.6 GB of memory, against a 282 MB peak RSS:
  eight at once move about 47 GB/s, more than half of the dual-channel DDR5-5200's 83.2 GB/s.

## Reproduce

```sh
xz -dc raw/cohorts.tar.xz | tar -x -C raw/cohorts
cd raw/cohorts
clang -O1 -o growth_stats ../../../tail-growth-673-2026-11-02/growth_stats.c
./growth_stats w2-main-747ab617-r1.log w2-head-09e22269-r1.log w2-main-747ab617-r2.log w2-head-09e22269-r2.log \
    w0-main-747ab617-r1.log w0-head-09e22269-r1.log w0-main-747ab617-r2.log w0-head-09e22269-r2.log \
    w1-main-747ab617-r1.log w1-head-09e22269-r1.log    # summary-cohorts.tsv, byte for byte
cd ../traffic && xz -dc ../traffic.tar.xz | tar -x
clang -std=gnu17 -O2 -o traffic_stats ../../traffic_stats.c
./traffic_stats main-747ab617    # traffic-main-747ab617.tsv, byte for byte; likewise head-09e22269
```

On the 9700X, `scripts/measure8.sh head-09e22269 main-747ab617` ran the cohorts, the controls over placements and the
traffic in turn, from #695's frozen campaign directory. `traffic` there was run as `traffic OUTDIR COMPILER
matched_cohort compile-budget.mk usage_record 6 TAG`. The experiment's scripts are `scripts/exp1.sh` to
`scripts/exp5.sh` (`exp5.sh` is `exp4.sh` pointed at the two heads), and their summaries the `-summary.sh` beside
them.

## Layout

- `experiment/`: the variants' diff; `exp1` to `exp5`, each round's `perf stat` CSV files and the queue's progress;
  `stages.txt`, three one-lane `--time-stages` runs; the variants' object digests.
- `raw/cohorts/`: each group's log and the `time-runs` logs; the receipts, object digests and progress.
  `raw/cohorts.tar.xz` holds the cohort directories (370, primers included): every compile's `--time-stages` output,
  usage record and the cohort's counters and `argv.txt`. Objects are replaced by their digests.
- `raw/placements/`: the controls over placements' `time-runs` logs, build lines and progress.
- `raw/traffic/`: each build's run log and the object digests; `raw/traffic.tar.xz` holds the 180 samples, each with
  its `umc.csv`, `perf.csv`, usage records, `--time-stages` output, `collector.stdout` and `argv.txt`.
- `scripts/`: every script that ran.

**Filtering.** The logs keep only the lines their programs print: `prime`, `sample`, `result` and `pair`; `memory:`,
`run`, `list`, the summaries and `time-runs:`; `run` and `result`; and `--time-stages`' lines. `exclusive.sh`'s lines
while waiting for other holders were dropped. The traffic samples' `collector.stdout` had none.

**Progress files.** The experiment's and the traffic loop's `status` values are their commands' exit codes. Those of
`measure8.sh`, `measure8a.sh` and `measure8b.sh` (copies of #1161's `measure6.sh` and `measure7.sh`) are always 0, as
theirs were: each expands `$(date)` before `$?`. The gates are each group's result lines (`growth_stats`), each
`time-runs` log's last line (all six read `done, 0 failed processes`), the traffic logs' result lines (180 of status
0 with identical objects) and the receipts' digests.

## Limitations

- The traffic counts are system-wide: the idle case's rate is subtracted per round, and was 0.015 GB/s. They are six
  rounds at one placement each.
- The CAS counts' bytes assume 64 a command, which #49 hasn't validated; the counts and their ratios don't depend on
  it.
- The experiment's executable is main with the variants' switch, not main itself.
- `raw/executables.txt` has the 9700X's `traffic_stats` before it sorted the cases by name; the tables here are this
  `traffic_stats.c`'s over the archive, the same values in a fixed order.
- `experiment/exp2`'s event groups were multiplexed: its counts are estimates, and only their direction is used.
- Why the compile timed alone gains 1% and eight at once don't isn't known.
