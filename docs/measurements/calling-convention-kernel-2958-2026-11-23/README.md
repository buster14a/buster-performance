# Calling-convention per-call kernel A/B (#2958, buster#3364), 2026-11-23

`benchmark-calling-convention --only assignment` on the Ryzen 7 9700X
(`benchpress`), Release builds with the host's staged clang 23.1.4, pinned with
`taskset -c 2`, each run under `~/buster-fast-bench/exclusive.sh` (owner
`claude-2958`), with `/proc/loadavg` and the busiest processes before and after
each run in its log.

- **base:** main `1b9821afe` with buster#3364's `calling_convention_benchmark.c`
  copied in (the PR's new rows `assign-alone`, `simple-alone`,
  `deferred-alone`; the benchmark only calls `abi_assign`).
- **head:** buster#3364 after merging main: `84bacda19` (`ab.sh`,
  `run-*.log`), then `4bf5599ab` (`ab2.sh`, `run2-*.log`).
- 6 rounds, alternating which build goes first; each run reports 21 passes'
  medians. The tables give the median of the 6 runs and their range.
- `exp.sh` with `exp1.patch`, `exp2.patch`, `exp3.patch` (each a diff against
  `84bacda19`): single runs of the intermediate fixes, `bench-exp*.log`.

## 84bacda19 (the merge) against main

| Row | main ns/arg | head ns/arg | change |
| --- | --- | --- | --- |
| assign | 3.38 (3.37–3.39) | 4.23 (4.21–4.24) | +25.0% |
| assign-alone | 14.65 (14.64–14.82) | 18.38 (18.35–18.55) | +25.5% |
| deferred-alone | 11.80 (11.78–11.85) | 55.39 (55.25–55.80) | +369% |
| assign-simple | 2.88 (2.88–2.91) | 3.66 (3.65–3.67) | +27.1% |
| simple-alone | 14.15 (14.14–14.31) | 15.67 (15.66–15.68) | +10.7% |

## Fixes measured (single runs, ns/arg)

| Row | exp1: compress in registers | exp2: totals after each window, marks cleared as far as used | exp3: unnamed marks without a branch |
| --- | --- | --- | --- |
| assign | 4.01 | 3.77 | 3.42 |
| assign-alone | 17.91 | 16.13 | 16.00 |
| deferred-alone | 55.18 | 54.37 | 54.32 |
| assign-simple | 3.45 | 3.17 | 2.86 |
| simple-alone | 15.29 | 13.50 | 13.37 |

## 4bf5599ab against main

| Row | main ns/arg | head ns/arg | change | cycles/arg | instructions/arg | mispredicts/arg |
| --- | --- | --- | --- | --- | --- | --- |
| assign | 3.37 (3.36–3.40) | 3.42 (3.41–3.42) | +1.5% | 18.7 → 18.9 | 47.9 → 48.2 | 0.013 → 0.005 |
| assign-alone | 14.67 (14.63–14.86) | 16.01 (15.96–16.03) | +9.1% | 81.2 → 88.8 | 186.6 → 154.0 | 0.042 → 0.076 |
| deferred-alone | 11.79 (11.74–11.97) | 54.39 (54.33–54.66) | +361.5% | 65.4 → 301.6 | 233.1 → 585.2 | 0.125 → 0.080 |
| assign-simple | 2.88 (2.88–2.91) | 2.85 (2.85–2.86) | −1.2% | 16.0 → 15.8 | 39.2 → 43.1 | 0.010 → 0.004 |
| simple-alone | 14.16 (14.14–14.36) | 13.32 (13.28–13.40) | −5.9% | 78.5 → 73.9 | 177.6 → 126.0 | 0.030 → 0.066 |

## Cause of what remains

`deferred-alone` assigns only the 567 calls (7,979 arguments) the prefix sums
leave, each alone, so `abi_assign_lanes` runs one lane of its eight. A step costs
it about 585 instructions per argument at 1.9 IPC (three dependent gathers, then
the rules' masks over the loop-carried register and stack counts), against
main's per-call code's 233 instructions and 65 cycles. Main's cycles at this
instruction count would need about 9 instructions per cycle, so this kernel
can't reach it by tuning. `assign-alone` carries the same cost on its 5.2%
deferred arguments: about 236 extra cycles each, about 12 cycles per argument
over all of them, against the +7.6 measured. Batched (`assign`), the kernel has
up to 8 calls per step and the row is within 1.5% of main.

`ab-84bacda1.tsv` and `ab-4bf5599a.tsv` are each run's rows (build, row, ns,
cycles, instructions, and for the second, mispredicts per argument).
