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

## The confirming run

[43065872321](https://github.com/buster14a/buster/actions/runs/43065872321) (purpose `full`, at `9c5133fe6`).

- `jobs-43065872321/`: its first attempt's jobs pages (`.../runs/43065872321/attempts/1/jobs`, two pages).
- `logs-43065872321/`: the 16 vector items' job logs (`jobs.txt` lists the job IDs).

The scripts above ran unchanged over these, with the assignment
`m1x1-m2x4-m3x5-m4x6-a1x8-a2x9-a3x10-a4x11-t1x12-t2x16-t3x17-t4x18-n1x19-n2x20-n3x21-n4x22`.

- **Verdict:** all 16 items passed in draw 1, attempt 1. Each configuration's items installed one product, built
  by its item 1: memory `6e275a2baf97`, address `da40d0ac9efa`, thread `e8ed9523be36`, none `eb03030ed96a` (the
  first 12 hex digits of each SHA-256). t1, the thread builder, passed "Check unity fixture ownership without
  rebuilding", which confirms `b5ae9b821`.
- **Draw:** 48 candidates, 31 qualified (65%). The 17 that didn't qualify were 14 EPYC 7763s and 3 EPYC 9V74s.
  The collector took 28 s and assigned the items in the measured order: memory, address, thread, none. Redraws:
  32 candidates, 12.8 runner-minutes, a mean of 24 s each.
- **Rows (wall time, runner-minutes):**

| Configuration | vector (4 items) | native | x86-64 |
| --- | --- | --- | --- |
| memory | 23.4 min, 85.3 | 30.1 min, 121.8 (5 shards) | 30.6 min, 89.2 |
| address | 19.5 min, 72.4 | 21.2 min, 73.5 | 18.0 min, 45.5 |
| thread | 19.1 min, 72.3 | 27.1 min, 94.5 | 22.3 min, 82.2 |
| none | 9.8 min, 37.1 | 12.0 min, 43.0 | 48.6 min, 68.4 (with SQLite's full Tcl suite's job) |

- **Products:** item 1 built in 492, 493, 200 and 122 s (memory, address, thread, none). Waiting items waited
  125–597 s, downloaded in 1–5 s and installed in 3–4 s. A waiting item spent −10 to 111 s (mean 32.1 s,
  6.4 runner-minutes per run) more than building its own. That is more than run 1's mean of 24.5 s, because
  items now poll for their product every 30 s rather than every 10 s (buster#2309).

- **9700X:** "Native tests and benchmarks on Benchpress" ran, and failed before its benchmarks in both attempts on
  one command: `test-checker-deferred: the sparse arena's page policy, demand-zero storage or release differs`
  (138 of 139 passed). Main's nightly run [42972886068](https://github.com/buster14a/buster/actions/runs/42972886068)
  (at `a1aecd773`) fails the same check on the same host. It came to main with `check_deferred_test_sparse_pages`
  (#1984's merge, 2026-11-10). benchpress has transparent huge pages `enabled=always` (`defrag=madvise`), and the
  hosted runners pass it. So "Build and execute on Ryzen 7 9700X" fails on its qualification.

## Runs between

- [43032895653](https://github.com/buster14a/buster/actions/runs/43032895653) (at `e945d43ba`). Attempt 1 failed
  every job's toolchain install during a hosted DNS outage (`Temporary failure resolving 'security.ubuntu.com'`).
  Attempt 2 ("re-run all jobs") lost about 40 jobs, 15 of them vector candidates, to the outage's return, and was
  cancelled.
- [43048773801](https://github.com/buster14a/buster/actions/runs/43048773801) (at `17939415`, with main's
  DNS-over-HTTPS mirror pin). t1's builder passed fixture ownership. UBSan stopped items a3 and a4, and the native
  address row's shard 3, at `c_check_wide.c:265` (`shift exponent 65 is too large for 32-bit type 'uint32_t'` in
  `check_wide_add_vector`, from buster#1447's wide `_BitInt` folding); buster `2d33f5f4f` fixes it. The verdict
  could not list the run's artifacts, `API rate limit exceeded for installation` (buster#2309).
- Run 43027989712's attempt 2 ("re-run failed jobs", on the old code) exercised the rerun path. t1's holder,
  candidate 6, drew an EPYC 7763 that does not qualify, so it did not retake t1 and published no attempt-2
  product. The verdict failed again on t1 alone.
