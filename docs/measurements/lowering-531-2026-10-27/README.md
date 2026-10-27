# The lowering's cost on the 9700X: #570 and #578 (#531), 2026-10-27

[#531](https://github.com/buster14a/buster/issues/531) asked for the single-thread cost of lowering to the typed
stream: on `-c` of `sqlite3.c`, the `lower` stage took 25.7 ms, five times Tier 0's compile of the stream.
[#570](https://github.com/buster14a/buster/pull/570) took it to 17.5 ms. [#578](https://github.com/buster14a/buster/pull/578)
followed up #570's review: it reserves lane 0's writer's columns for exactly their room instead of 64 GiB, measured on
an arena of no memory, with the caller's scratch as the fallback. This record holds the 9700X logs and reports behind
both pull requests' numbers:

- `570/`: four rounds, each a tree of #570 against main `ad408cf2`, with `perf stat` rounds of the whole compile and
  #520's stage clock (`measure-compile`);
- `578/`: two comparisons over code placements and fresh copies (`time-runs` under `ab`), the first version of #578
  against main `fe1e928f` (#570's merge) and the reviewed code against main `8e1fbb2b`.

Every run compiled the preprocessor oracle's frozen `sqlite3.c` (`inputs.sha256`) with #520's step's options:
`-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I<corpus>`.
Every tree wrote main's object byte for byte (`570/measure*.log`, `578/run5.log`, `578/run6.log`; #578's with `-g`
too).

## #570 (`570/`)

The final round (`out4/`), main `ad408cf2` against #570's code (`0a8a34ea`):

| `-c` of `sqlite3.c` | main | #570 |
| --- | ---: | ---: |
| `lower` stage, median of 11 (`measure-compile`) | 25.577 ms (25.456 to 25.781) | 17.487 ms (17.243 to 17.659) |
| its system time | 2.940 ms | 0.000 ms |
| its peak RSS added | 56,044 KB | 9,824 KB |
| `tier0` stage | 5.163 ms | 5.033 ms |
| wall, median of 11 (`measure-compile`) | 190.263 ms | 182.493 ms |
| peak RSS (`measure-compile`) | 674,216 KB | 627,200 KB |
| task-clock, medians of 10 rounds of `perf stat -r 3` | 190.5 ms (189.9 to 191.4) | 181.8 ms (181.5 to 182.6) |
| user cycles | 902M | 864M |
| user instructions | 2,227.2M | 2,132.6M |
| one-lane emission, warm (`benchmark-check-lanes --lanes 1`), two runs | 37.5 and 36.7 ms | 30.0 and 30.0 ms |

The stage figures are `measure-compile`'s reports both ways: `mc-final-vs-main.txt` measures #570's tree with main's
as its reference, and `mc-main-vs-final.txt` the other way round, each with its own stage table.

The earlier rounds measured #570's commits one step at a time, each against main in a round of its own:

| round | trees (`trees` below) | task-clock, medians | `lower` stage |
| --- | --- | --- | --- |
| `out/` | main, `v1` (commits 1 and 2) | 190.4, 183.8 ms | 25.595, 19.016 ms |
| `out2/` | main, `v1`, `v2` (commits 1 to 3) | 190.5, 183.9, 183.1 ms | 25.705, `v2` 19.007 ms |
| `out3/` | main, `v2`, `v4` (`v2` with a prefetch experiment) | 190.6, 183.1, 181.8 ms | |
| `out4/` | main, `final` (commits 1 to 4) | 190.5, 181.8 ms | 25.577, 17.487 ms |

## #578 (`578/`)

Each comparison ran three rounds of `time-runs`, the compile of each build's six placements from three fresh copies
each, with main's executables a second time (`main-again`) as the comparison's floor. The rounds' comparisons are
the summaries at the end of each round in `ab5.log` and `ab6.log`; the medians over all 162 processes of each build:

| `-c` of `sqlite3.c` | main | #578 | main again |
| --- | ---: | ---: | ---: |
| `ab5.log`: wall, this PR against main, by round | | +0.09%, +0.07%, +0.05% | +0.00%, −0.05%, +0.17% |
| `ab5.log`: user cycles, by round | | +0.12%, −0.01%, +0.01% | +0.13%, −0.09%, +0.17% |
| `ab5.log`: peak RSS, minor faults | 627,112 KB, 1,715 | 627,116 KB, 1,715 | 627,120 KB, 1,715 |
| `ab5.log`: user instructions | 1,999,562,024 | 1,999,659,362 (+97,338) | 1,999,562,024 |
| `ab6.log`: wall, this PR against main, by round | | +0.09%, +0.01%, −0.21% | +0.17%, +0.08%, −0.06% |
| `ab6.log`: user cycles, by round | | +0.11%, +0.10%, −0.34% | +0.28%, +0.07%, −0.09% |
| `ab6.log`: peak RSS, minor faults | 627,200 KB, 1,717 | 627,164 KB, 1,715 | 627,218 KB, 1,717 |
| `ab6.log`: user instructions | 1,751,152,853 | 1,751,001,817 (−151,036) | 1,751,152,853 |

`ab-medians.sh` reads the processes' lines for the medians (its awk prints an even count's middle mean in exponent
form for `ab5.log`'s instructions; the table's are exact).

## Trees

| Name | Tree | What it is |
| --- | --- | --- |
| `main` | [`ad408cf2`](https://github.com/buster14a/buster/tree/ad408cf2ec956860833db81e4333c5faa78390fe) | main, #570's base |
| `v1` | `ad408cf2` with `v1.patch`, [`4b5283f2`](https://github.com/buster14a/buster/tree/4b5283f2)'s `src` | #570's commits 1 and 2: the types' table, lane 0's columns in base pages |
| `v2` | [`f23dda8a`](https://github.com/buster14a/buster/tree/f23dda8a)'s `src` | also commit 3: the append, the empty conversions |
| `v4` | `v2` with `v4-prefetch-experiment.py` | an experiment build of commit 4's prefetch |
| `final` | [`0a8a34ea`](https://github.com/buster14a/buster/tree/0a8a34ea) | commits 1 to 4, #570's code |
| `main520` | [`ea673e4b`](https://github.com/buster14a/buster/tree/ea673e4b) | #520's head then, main with the stage clock and `measure-compile` |
| `v1-520`, `v2-520`, `final-520` | `ea673e4b` with `v1.patch`, `v2.patch`, `final.patch` | each tree with #520's clock, for `measure-compile` |
| `main570` | [`fe1e928f`](https://github.com/buster14a/buster/tree/fe1e928f) | main, #570's merge |
| `columns` | [`24cbf7fc`](https://github.com/buster14a/buster/tree/24cbf7fc)'s `src` | #578's first version |
| `main8e1` | [`8e1fbb2b`](https://github.com/buster14a/buster/tree/8e1fbb2b) | main, merged into #578 |
| `head578` | [`52e90957`](https://github.com/buster14a/buster/tree/52e90957) | #578's code after its first review |

`git archive` of its commit, sent by tar, made `main`, `main520`, `final`, `main570`, `main8e1` and `head578` (the last
three of `src` and `build.sh` alone), and `v2` from a work-in-progress commit with `f23dda8a`'s `src`. The patches
are `git diff ad408cf2 <commit> -- src` of the commits named (`v2.patch` and `final.patch` are the diffs the `-520`
trees took), and apply to `ea673e4b` with `patch -p1`. Each tree was built with `BUSTER_DEBUG_INFO=0 ./build.sh`
(`build-*.log`), and #578's placements with
`./build.sh shifts DIRECTORY main_unit_checker.c 0 688 1376 2064 2752 3440` (`build5-*.log`, `build6-*.log`).

Host: AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, wild 0.10.0 (`build.sh`'s linker), perf 7.2.9, CPU 2 at
the performance governor.

## Method

**#570's rounds.** `run.sh` to `run4.sh` built each tree under the 9700X's lock, a hold per build, then ran
`measure.sh` to `measure4.sh` under one hold each, pinned to CPU 2:

- each tree's `-c` once, the objects compared with main's;
- rounds of `perf stat -r 3 -x, -e task-clock,page-faults,cycles:u,instructions:u,cycles:k,instructions:k` of `-c`
  (`out*/stat-TREE-ROUND.txt`), the trees in an order that alternates or rotates by round, each after a warm-up run
  of its own executable;
- `measure-compile --runs 11 --reference` of each `-520` tree against `main520` and the other way round
  (`out*/mc-*.txt`), whose `--time-stages` report gives the stages;
- `benchmark-check-lanes --passes 11 --lanes 1` of each tree twice, in turn (`out*/lanes.txt`).

`/usr/bin/time` isn't installed on the host (`out*/time.txt`), so the peak RSS is `measure-compile`'s.

**#578's comparisons.** `run5.sh` and `run6.sh` built each tree at six placements of the checker's unit, a hold per
build, compiled `-c` and `-c -g` with each tree's unshifted build and compared the objects, then ran
`compiler ab --rounds 3 --cpu 2 --lock ~/buster-fast-bench/exclusive.sh` of
`time-runs --runs 3 --copies 3 --build NAME PATH... --list <options> -o /dev/null`, which took the lock for each
round's `time-runs` process.

**The logs.** `exclusive.sh`'s waiting messages name other sessions' runs, and their holders' commands span many
lines: every `*.log` here keeps only the lines this record's own tools print (`keep_own_lines.py`), every process
line and summary of the comparisons among them. The `out*/` reports are as they were written.

## Limitations

- #570's measurement scripts each held the lock for their whole run, against the host's rule of a hold per run;
  #578's comparisons took it per process of `time-runs`.
- The trees and executables were removed from the host before this record was made: the trees are named by commit
  and patch, and neither their files' hashes nor the executables' were compared with what ran.
- `v1` was the working tree before #570's commits were cut from it: commit 1 took its `c_check_program_lower.c` and
  `c_check_program_test.c`, and its `c_check_program_emit.c` was compared with commit 2's at the time. `v2` was a
  work-in-progress commit whose `src` equals `f23dda8a`'s. `columns` was a tar of the working tree whose code became
  `24cbf7fc`; the SHA-256 of its four changed files was compared with the commit's at the time.
- `v4-prefetch-experiment.py` is the experiment's edit as the session ran it, recovered from its transcript; #570's
  commit 4 writes the same rule in another form.
- #578's description also has figures from the laptop, an AMD Ryzen 9 7940HS (the instructions' attribution, the
  address space reserved): those are not in this record.
