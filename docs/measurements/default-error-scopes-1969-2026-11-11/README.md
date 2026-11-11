# Default-error warnings' scopes, Buster #1969

Compiler issue: [#1969](https://github.com/buster14a/buster/issues/1969). Compiler PR:
[#2146](https://github.com/buster14a/buster/pull/2146). Package C5 of
[#1447](https://github.com/buster14a/buster/issues/1447).

Frozen sources:

- Base: main `d43c37e5192d7e5d62df822aa2ce5c1f3facb5ca`.
- Head: `4023c4eaee572e77e91f084d5b466fbd242ab906` (the PR's only commit).

The change runs on rejected units alone. Valid units meet only `CheckDriverDiagnostic`'s two new fields, 8 bytes per driver
diagnostic, and the binary's new code. This measures that their compile time is unchanged.

## Host and method

The Ryzen 7 9700X (`benchpress`), CPU 2, clang 23.1.1, kernel 6.18.50-2-lts (`identities.txt`, with the
inputs' and executables' SHA-256). Each tree was built with `BUSTER_HOST_ARCH=znver5 ./build.sh`, one lock
invocation per build. The input is the frozen `sqlite3.c` amalgamation of `frontend-baseline-claude`, and
main.c of the head tree with its options (`run.sh`).

**Non-qualifying: one lock hold around a series.** `time-runs.log` comes from `run.sh`: one `time-runs`
comparison, 3 warm-ups and 21 runs per build and list in a Williams order, under **one** hold of the 9700X lock
(about 90 s). That is a series of runs under one hold, which AGENTS.md's per-run lock rule forbids. Treat
these numbers as an observation. The per-run-lock repeat is below.

## Results (time-runs.log, non-qualifying)

| list | metric | base | head | head vs base |
| --- | --- | --- | --- | --- |
| `-fsyntax-only sqlite3.c` | wall median | 96.120 ms (95.606–98.797) | 96.322 ms (95.301–99.259) | +0.21% |
| | user cycles median | 449.587 M | 450.260 M | +0.15% |
| | instructions | 987,243,7xx | 987,243,7xx | equal to within 60 instructions |
| | wait4 peak | 241,808 KiB | 246,264 KiB | +4,456 KiB |
| | minor faults | 6,943 | 6,922 | −21 |
| `-fsyntax-only main.c` | wall median | 579.362 ms | 581.535 ms | +0.38% |
| | user cycles median | 2,898.113 M | 2,907.789 M | +0.33% |
| | instructions | 8,770.5 M | 8,769.6 M | −0.01% |
| | wait4 peak | ~1,156,100 KiB | ~1,163,000 KiB | +0.6% |

- The wall-time ranges overlap, and the instruction counts are the same: valid units run no new code.
- The peak resident set is a constant 4.4 MiB higher on sqlite3.c in every run, with fewer minor faults.
  With base pages (`BUSTER_HUGE_PAGES=0`, `rss.sh`, `rss.log`, 3 runs each, also under one hold), it is still 3.0 MiB
  higher (187,392 → 190,432 KiB), with equal faults (58,614 → 58,601) and equal instructions.
- So the step isn't the arenas' huge pages. It comes with the binary's layout: text +9.3 KB, data and bss equal.
  This record doesn't identify it further.

## Per-run-lock repeat (ab2.log, qualifying lock use)

`ab.sh` ran `ab` with plain `-fsyntax-only` and the 9700X lock taken per run (`ab.log`). It printed no timings:
`ab` only runs each command, and plain `-fsyntax-only` prints nothing. `ab2.sh` repeats it with `--time-stages`,
whose `time-stage total` line is each run's own wall time (6 rounds, Williams order, CPU 2, one lock hold per run;
`ab2-totals.tsv` lists them by round).

| input | base runs (ms) | head runs (ms) | median base | median head |
| --- | --- | --- | --- | --- |
| sqlite3.c | 96.4 96.4 97.0 97.7 113.3 116.5 | 95.9 96.7 101.2 112.5 113.1 117.4 | 97.3 | 106.8 |
| main.c | 577.9 585.4 587.3 683.1 695.7 713.3 | 681.9 691.7 694.7 697.4 704.0 749.8 | 635.2 | 696.1 |

The runs fall into two modes, about 96 and 113 ms on sqlite3.c and about 580 and 690 ms on main.c, in both trees.
Each run takes the lock separately, between other sessions' work, so the mode follows the host's state at the run,
not the tree. Within a round where both trees fell in the same mode they agree to about 2% or better: sqlite3.c's
rounds 1, 2, 4 and 5, main.c's rounds 3, 4 and 5. The medians differ only because main.c's base runs fell in the fast
mode three times and its head runs none (rounds 1, 2 and 6). Six rounds can't separate that from the change. With the
time-runs comparison's equal instruction counts (above), this repeat finds no difference, but its medians aren't
evidence of one either way.

## Files

- `run.sh`, `time-runs.log`: the time-runs comparison.
- `rss.sh`, `rss.log`: the base-page peak comparison.
- `ab.sh`, `ab.log`: the per-run-lock repeat without timings (plain `-fsyntax-only` prints none).
- `ab2.sh`, `ab2.log`, `ab2-totals.tsv`: the per-run-lock repeat with `--time-stages`.
- `identities.txt`: SHA-256 of the input and both executables, clang, kernel and CPU.
