# The all-core path's step 1, the back half by windows, against its gate (buster#2536, 2026-11-14)

Step 1 of [buster's all-core path](https://github.com/buster14a/buster/blob/ca1ede6a27c1b2e726f2b54e873fd013d03a1fad/docs/all-core-path.md)
([buster#2536](https://github.com/buster14a/buster/issues/2536)) makes one lane's emission take its bodies in windows of
W tokens: each window's lowering and its code before the next window's, its typed streams and Tier 0's code in memory
the next window reuses. It is buster's `--emit-window=N` (`check_program_emit_windows`, branch
`claude/magical-dijkstra-6klwmr`), with `W = ∞` (0) as the default and the twin. The design's gate, on `sqlite3.c` at
eight workers: `lower` and the emission at most 1.25 times their one-worker user cycles; instructions a token within 2%
of `W = ∞`; objects the same bytes on every corpus; one worker not slower. Step 1 is also the premise's test: if the
stages wait as much when the typed stream is consumed hot, the waiting isn't the boundaries'.

**In short.** At W = 2,048, eight workers compile `sqlite3.c` at 292.9 MB/s against 289.3 at `W = ∞` (the same
executable) and 287.6 on main, with 1.6% fewer user cycles and 2.6% fewer kernel cycles a compile. One worker is the
same (76.51 against 76.56 MB/s, 596.6 against 597.2 M user cycles). Instructions rise 0.14%. The emission meets its
gate: 1.15 times its one-worker user cycles (1.33 at `W = ∞`). The lowering doesn't: 1.49 (1.60). Objects are the same
bytes on every corpus at W of 1, 2,048 and ∞, with and without `-g`, by both paths and with poisoned windows. The
premise holds where the record was the boundary: Tier 0's reading of the typed stream went from 6.1 times its
one-worker cycles to 1.05. What the lowering still waits for is its own input, the program's rows that `check_program`
writes for the whole unit before the lowering starts, which is step 2's boundary.

## What was run

- **The executables** (`raw/env.txt` has their SHA-256), each a Release build under the lock in its own worktree of
  `~/buster-fast-bench/2536-step1-claude` on the 9700X:
  - `main`: buster `ca1ede6a27c1b2e726f2b54e873fd013d03a1fad`, the branch's base.
  - `head1`: `0064e7ca97c948604492570b5dab2c4a4ed7ee01`, the windows (first gauge and the corpora's first check).
  - `head2`: `53ccda2e49378430aad63edb877901e09e3b9f94`, with `--poison-arenas` poisoning each popped window (the
    corpora and the profiles).
  - `head3`: `88270a604e487cfadce6291f29d05e2613422938`, with a window short of room sent again as one part: the code
    the pull request has (its later commits are documents). Every table below is `head3`'s but where it says.
- **The gauge** is step 0's, `tools/allcore/allcore.c` at `ca1ede6a` (`scripts/allcore.c`), run by
  `scripts/gauge.sh`: `counted`, then `sampled`, one hold of the lock each, then `table`, with buster's options for the
  9700X job's `compile_time` and `--emit-window=N` (`GAUGE_OPTIONS`). `scripts/gauges.sh` and `scripts/sweep.sh` ran
  `head3` at W of 0, 512, 1,024, 2,048, 4,096 and 8,192, one after another, each in its own two holds.
- **The corpora** (`scripts/corpora.sh`, `scripts/corpus-run.sh`, by `head2`): each source to an object by itself at
  `--lanes 1`, ten ways (W of 0, 1 and 2,048; 1 with `--poison-arenas`; each again with `-g`; and by `--scalar` at 0 and
  1), one hold of the lock a corpus and way: `sqlite3.c`, Lua 5.4.8's 34 sources, c-testsuite's 220 programs of
  `tests/c-testsuite/subset.txt` at `5c727565`, buster's own `main.c` at `head2`, and musl's 1,336 units (the design
  record's list, `raw/corpora/musl.files`). Each way's objects, or its failures' diagnostics, are compared with W = 0's
  of the same `-g`.
- **The profiles** (`scripts/profile.sh`, `scripts/compare.sh`, by `head2`, one hold each): `perf record -e cycles:u
  -c 50021` of six compiles on CPU 2 alone, then of six more on CPU 2 while seven workers compile the same in a loop on
  CPUs 0, 1 and 3 to 7, at W of 0 and 2,048; cycles by symbol (`raw/profile-*/compare.txt`, millions a compile).
- **musl's command** (`scripts/musl.sh`, by `head3`, one hold): the 1,336 units as one command on one lane (CPU 2),
  W of 0 and 2,048 interleaved, five rounds, each counted by `perf stat`.
- **Clean:** every cohort's strays file is empty and every sampled run had its anchors, no sample lost, no ring full, no
  group multiplexed (`raw/gauge-*/whole.tsv`, `*.log`). The host was shared with other sessions' runs between holds,
  never during one (the lock).
- **The page state:** every one-worker compile took huge pages and every eight-worker compile base pages (#1561's busy
  test), in every gauge (`whole.tsv`'s `huge_pages`).
- **The host as found** (`raw/env.txt`): Linux 6.18.50, CPU 2 `performance`, the others `powersave` with
  `balance_performance`, CPU 10 offline, transparent huge pages `always`. Nothing was changed.

## The whole compile

`raw/gauge-*/whole.tsv`; medians per compile, MB/s the median of the rounds' rates:

| `sqlite3.c` | main | `W = ∞` | W = 2,048 |
| --- | ---: | ---: | ---: |
| one worker: MB/s | 76.54 | 76.56 | 76.51 |
| user cycles | 597.3 M | 597.2 M | 596.6 M |
| kernel cycles | 84.3 M | 84.2 M | 84.3 M |
| user instructions | 1,361.4 M | 1,361.4 M | 1,363.3 M |
| eight workers: MB/s | 287.56 | 289.25 | **292.87** |
| wall ms | 260.4 | 258.9 | 254.7 |
| user cycles | 1,076.8 M | 1,070.7 M | 1,053.8 M |
| kernel cycles | 277.4 M | 274.0 M | 266.9 M |
| faults | 62,624 | 62,627 | 61,362 |
| peak RSS | 191.0 MB | 191.0 MB | 193.5 MB |
| GHz (one, eight) | 5.547, 5.268 | 5.545, 5.255 | 5.546, 5.260 |

`W = ∞` is the branch's default and matches main within the runs' noise. The peaks differ by the executable's own
file pages (4.5 MB a copy, as the design record found): `head1`'s W = 2,048 gauge had 190,968 KB at eight workers.

### The window's size

`head3`, the same afternoon, one gauge each:

| W | eight workers, MB/s | user cycles | kernel cycles | one worker, MB/s | user cycles | instructions |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| ∞ | 289.25 | 1,070.7 M | 274.0 M | 76.56 | 597.2 M | 1,361.4 M |
| 512 | 295.98 | 1,056.1 M | 262.3 M | 76.30 | 600.1 M | 1,363.8 M |
| 1,024 | 291.84 | 1,056.6 M | 270.3 M | 76.53 | 599.5 M | 1,363.5 M |
| 2,048 | 292.87 | 1,053.8 M | 266.9 M | 76.51 | 596.6 M | 1,363.3 M |
| 4,096 | 292.84 | 1,057.8 M | 266.7 M | 76.69 | 595.2 M | 1,363.2 M |
| 8,192 | 293.76 | 1,053.3 M | 269.1 M | 76.54 | 597.1 M | 1,363.1 M |

Every finite W takes 1.2 to 1.6% of the user cycles at eight workers. Below 2,048 a window's own cost shows at one
worker (512: 0.5% more user cycles, in the lowering's statements, 8.46 ms against 7.84). `head1`'s W = 2,048 gauge,
hours earlier, gave 293.17 MB/s and 1,054.9 M.

## By stage

The gauge's sampled split puts each stage's samples in its time, the stages laid end to end. By windows the lowering
and the emission alternate window by window, so their sampled split is not each one's: their sum is, and each one's
time from the reports' laps is. Sampled (`raw/gauge-*/table.tsv`), user cycles a compile, one worker against eight:

| stage | main | `W = ∞` | W = 2,048 |
| --- | ---: | ---: | ---: |
| `select` | 5.0 → 12.3 | 5.1 → 12.5 | 4.9 → 11.6 |
| `lower` | 61.8 → 98.5 | 62.4 → 99.9 | 62.7 → 93.2 |
| the emission | 44.8 → 59.2 | 44.5 → 59.3 | 44.1 → 50.7 |
| the object | 4.6 → 4.6 | 4.5 → 4.5 | 5.0 → 6.7 |
| the four, `select` to the object | 116.2 → 174.6, 1.50 | 116.5 → 176.2, 1.51 | 116.7 → 162.2, **1.39** |

Laps (`raw/substages.txt`, medians of the counted runs' reports, ms), and each stage's inflation in cycles, its time's
ratio times the frequencies' (5.260/5.546 at W = 2,048, 5.255/5.545 at `W = ∞`):

| stage | `W = ∞`: one, eight | cycles' ratio | W = 2,048: one, eight | cycles' ratio |
| --- | --- | ---: | --- | ---: |
| `lower` | 11.66, 19.87 | 1.62 | 11.76, 18.31 | **1.48** |
| `lower.prepare` | 1.00, 3.21 | 3.04 | 1.03, 3.22 | 2.97 |
| `lower.statements` | 7.84, 11.62 | 1.40 | 8.09, 11.59 | 1.36 |
| `lower.bodies` | 1.43, 2.47 | 1.64 | 1.31, 1.81 | 1.31 |
| `lower.validate` | 1.28, 2.26 | 1.68 | 1.21, 1.44 | 1.13 |
| the emission (`tier0` to `code-atoms`) | 8.33, 12.09 | 1.38 | 8.08, 10.26 | **1.20** |
| `tier0` | 5.32, 6.67 | 1.19 | 5.40, 5.88 | 1.03 |
| `emit-setup` | 1.06, 1.88 | 1.69 | 0.90, 1.78 | 1.88 |
| `code-atoms` | 0.54, 1.63 | 2.84 | 0.38, 0.83 | 2.06 |

- **The emission meets the gate** by either measure (1.15 sampled, 1.20 by laps). What is left of its inflation is
  `emit-setup`, the arrays for every body made before the windows, and the merge's `code-atoms`; Tier 0's own
  functions are at 1.03.
- **The lowering doesn't** (1.49 sampled, 1.48 by laps). Its bodies' validation and its writes now cost what a window
  does (`lower.validate` 1.68 to 1.13, `lower.bodies` 1.64 to 1.31), but `lower.prepare` is still three times its
  one-worker time and `lower.statements` 1.36.

## By function

`raw/profile-w0/compare.txt` and `raw/profile-w2048/compare.txt` (`head2`), sampled user cycles a compile, millions,
alone and beside seven workers:

| function | `W = ∞` | W = 2,048 |
| --- | --- | --- |
| `tier0_validate_accepts` (reads the typed stream) | 0.98 → 5.98, 6.13 | 3.03 → 3.17, **1.05** |
| `tier0_compile_entries` | 3.13 → 6.59, 2.10 | 3.61 → 4.27, 1.18 |
| `tier0_generate` | 10.48 → 13.04, 1.24 | 10.97 → 11.27, 1.03 |
| `check_lower_drain` (the lowering's statements) | 12.79 → 29.12, 2.28 | 14.01 → 28.34, 2.02 |
| `check_lower_prepare` | 3.93 → 7.34, 1.86 | 0.79 → 6.46 |
| `check_lower_part` | 3.80 → 7.34, 1.93 | 3.90 → 6.37, 1.63 |
| `__memset_avx512_unaligned_erms` (the whole compile's) | 11.20 → 16.72 | 10.69 → 19.05 |

A sample's function is where the cycle was spent, inlined callees included, so these attribute less exactly than the
stages; six compiles a side. Tier 0 consumes the stream a window after the lowering wrote it and stops waiting for it.
`check_lower_drain` reads the program's statements and values, which `check_program` and the checker wrote for the
whole unit: windows don't change that. `check_lower_prepare` is unit-wide work before any window: tables of one entry
a token for all 716,136 tokens (`local_map`'s `memset` among them) and passes over the graph, which the stages' laps
put at three times its one-worker time. Its one-worker samples differ between the two profiles (0.79 against 3.93 M)
where the laps don't (1.03 and 1.00 ms): a placement or attribution effect this record doesn't resolve.

## The corpora

`raw/corpora/summary.txt` (`head2`): every way's objects the same bytes as W = 0's, or its failures' diagnostics the
same; `raw/corpora/differences.txt` is empty.

| corpus | sources | ways | the same |
| --- | ---: | ---: | ---: |
| `sqlite3.c` | 1 | 10 | 10 |
| Lua 5.4.8 | 34 | 10 | 340 |
| c-testsuite | 220 | 10 | 2,200 |
| `main.c` | 1 | 10 | 10 |
| musl | 1,336 | 10 | 13,360 |

## musl's command

`raw/musl/` (`head3`): the 1,336 units as one command on one lane, five rounds, W of 0 and 2,048 interleaved. A unit is
one window or a few: nothing to gain, and nothing lost.

| | W = 0 | W = 2,048 |
| --- | ---: | ---: |
| wall ms, rounds 2 to 5 | 739.0, 738.6, 739.2, 737.3 | 738.1, 740.6, 737.0, 739.7 |
| user cycles, median | 3,004.9 M | 3,010.1 M |
| kernel cycles, median | 1,037.8 M | 1,031.2 M |
| user instructions | 7,426.4 M | 7,428.0 M |

Round 1's W = 0 (768.8 ms) read the executable's file cold. The objects of both are the same bytes.

## Against the gate

| gate | result |
| --- | --- |
| the emission at most 1.25 times its one-worker user cycles | **holds**: 1.15 sampled, 1.20 by laps (1.33 and 1.38 at `W = ∞`) |
| `lower` at most 1.25 times | **misses**: 1.49 sampled, 1.48 by laps (1.60 and 1.62) |
| instructions a token within 2% of `W = ∞` | holds: +0.14% at 2,048, +0.17% at 512 |
| objects the same bytes on every corpus | holds: 15,920 objects, 0 differences |
| one worker not slower | holds at 2,048 and above; 512 costs 0.5% of its user cycles |

The design's rule is that no step becomes the default unless its gate holds, so `W = ∞` stays buster's default. The
expected gain was 298 MB/s (1.03 times); measured, 292.9 (1.013 times `W = ∞` on the same executable, 1.018 times
main).

## Files

- `raw/gauge-NAME/`: each gauge's `whole.tsv` and `table.tsv`, its logs, every cohort's rows and strays, the sampled
  buckets, and every run's `--time-stages` report (`counted/stages.tar.gz`, `sampled/stages.tar.gz`). `gauge-main` is
  main; `gauge-head1-w0` and `gauge-head1-w2048` are `head1`; `gauge-head3-wN` the sweep.
- `raw/substages.txt`: the laps' medians by cohort (`scripts/substages.sh`).
- `raw/profile-w0/`, `raw/profile-w2048/`: `perf report` by symbol, alone and beside seven, and their comparison.
- `raw/corpora/`: the summary, the lists of sources, and every way's exit statuses.
- `raw/musl/`: the runs' times and `perf stat` outputs.
- `raw/env.txt`, `raw/build-*.log`: the host, the commits and executables' hashes, and each build's end.
- `scripts/`: every script as run, and the gauge's source.
- `SHA256SUMS`: every file's hash, from the host.

The objects, the perf data and the work trees stay on the host, in `~/buster-fast-bench/2536-step1-claude`.
