# Vector sanitizer configurations, one product each (buster#2033, buster#2032)

The record behind buster's branch `claude/vector-sanitizers-2033` (commits `4c2106888`..`e945d43ba`): the first full
run of the pooled vector row, [43027989712](https://github.com/buster14a/buster/actions/runs/43027989712) (#6301, at
`4c2106888`, purpose `full`).

- `jobs-43027989712/`: the run's jobs pages (`GET /repos/buster14a/buster/actions/runs/43027989712/jobs`, two pages),
  from which the items' CPUs, step timings, waits and runner-minutes are read.
- `logs-43027989712/`: the 16 vector items' job logs (`jobs.txt` lists the job IDs), which `costs collect` read to
  produce the branch's `tools/ci/costs/vector-{memory,thread,address}-O3.costs` (commit `fde07e111`).
- `scripts/`: the analysis as run, with the session's scratch paths left in. `jobs.sh RUN FILTER` saves and filters the
  jobs pages; `collect.sh RUN` downloads the logs and runs `costs collect`; `items.py DIR ASSIGNMENT` gives each item's
  CPU and timings; `rows.py` compares rows' wall time and runner-minutes; `excess.py` gives each waiting item's wait
  plus install minus its builder's build; `analyze.py` reads the draw.

## Results

- **Draw:** 48 candidates, 39 qualified (81%); the 9 unqualified were EPYC 7763s. One draw assigned all 16 items in
  12 s: m1x1 m2x3 m3x4 m4x5 t1x6 t2x7 t3x8 t4x9 a1x11 a2x12 a3x13 a4x15 n1x17 n2x18 n3x19 n4x20. Redraws: 32 candidates,
  8.7 runner-minutes, plus the collector (18 s) and the verdict (6 s).
- **Rows (wall time, runner-minutes):**

| Configuration | vector (4 items) | native | x86-64 |
| --- | --- | --- | --- |
| memory | 20.4 min, 77.8 | 27.4 min, 112.8 (5 shards) | 30.5 min, 96.8 |
| address | 20.6 min, 77.3 | 18.6 min, 63.9 | 18.5 min, 46.3 |
| thread | 18.5 min, 63.4 (t1 failed) | 23.9 min, 73.6 | 19.0 min, 76.9 |
| none | 9.6 min, 36.0 | 9.8 min, 34.7 | 8.8 min, 23.2 |

- **Products:** 80, 101, 124 and 155 MB archives (plain, thread, address, memory); item 1 built in 153, 204, 618 and
  506 s. Waiting items waited 170–644 s, downloaded in 1–7 s and installed in 2–4 s. A waiting item spends 13–38 s
  (mean 24.5 s, 4.9 runner-minutes per run) more than building its own.
- **Failure:** t1 (the thread builder) failed "Check unity fixture ownership without rebuilding": the pack's identity
  runs `./build.sh configure`, leaving the tree's build out of date. Fixed in `b5ae9b821`; not yet run on CI.

The confirming run of the fixed branch was dispatched as
[43032895653](https://github.com/buster14a/buster/actions/runs/43032895653), which failed on every job's toolchain
install during a hosted DNS outage (`Temporary failure resolving 'security.ubuntu.com'`) and tested nothing.
