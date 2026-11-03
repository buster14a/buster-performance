# `-E`'s printer from #649's start to its close (2026-11-03)

[buster14a/buster#649](https://github.com/buster14a/buster/issues/649) found `-E -P`'s printer taking about 30 cycles an
output token, 28–38% of the run. Four pull requests changed it:
[#685](https://github.com/buster14a/buster/pull/685) (offsets by a prefix sum),
[#1028](https://github.com/buster14a/buster/pull/1028) (spellings a range at a time),
[#1074](https://github.com/buster14a/buster/pull/1074) (line-marker batches) and
[#1184](https://github.com/buster14a/buster/pull/1184) (classes by kind, leaner copies, `-P`'s prefetch). This record
measures the issue's own figure, `benchmark-preprocessor`'s `-E -P` printing, on the 9700X. It compares the commit
the work started from with the merge that closed the issue, in one series of interleaved rounds on one frozen input.

## Trees

| name | commit | what |
|---|---|---|
| `issue` | `bc1b486150850fe00bad1361a19f57d67706bb3b` | main when #649's work started (2026-10-28, the base of #685's branch) |
| `now` | `453c7d24687ccbbec2bfca91b573d0440b10a72f` | main at #1184's merge, which closed #649 (2026-11-03) |

Each tree is `git archive` of its commit, extracted into a new directory on the host and built there with
`BUSTER_DEBUG_INFO=0 ./build.sh` (default `BUSTER_HOST_ARCH=native`, one lock hold per build; `builds/`).
`manifests/` has every file's SHA-256 on the host. They match the commits' archives file for file, except each tree's
`build.log`, which the build script wrote into the tree. The binaries' SHA-256s are in `identity.txt`.

## Inputs

Both trees read the same inputs:

- `main.c`: buster's `src/buster/compiler/main.c` from a frozen `src` tree, `3ce71ec3`'s (`manifests/base.sha256`
  matches `git archive 3ce71ec3 src` file for file), with `-target x86_64-pc-linux-gnu -march=native -I<src>
  -fwrapv -funsigned-char`. 6,859,536 output tokens in both trees.
- `sqlite3.c`: the 9700X's pinned corpus (`preprocessor-391e729af658`), with its gnu17 predefines, `-march=znver5
  -std=gnu17 -nostdinc` and the corpus's headers. 706,237 output tokens in both trees.

The commands are in `scripts/round.sh`. Inputs' SHA-256s are in `identity.txt`.

## Method

`scripts/abr.sh close 7 issue now`: 7 rounds, each one hold of the shared 9700X lock (`exclusive.sh`), running every
configuration for both trees, the trees' order reversed every other round. Each run is
`taskset -c 2 ./build/compiler benchmark-preprocessor --only vectorized [--markers] ARGS`, which reports the median
of 21 passes. CPU 2 runs the `performance` governor and EPP; its sibling, CPU 10, is offline (`identity.txt`). Every
round waited for the lock behind other holders first (`runs/lock-waits.txt`). The waiting messages name other
sessions and CI jobs, so they are left out, and `scripts/keep_own.py` kept only the benchmark's own lines in `runs/`.
`summary.txt` is `scripts/summarize.sh` over `runs/`: each configuration's seven medians, sorted, and their median.

The `issue` tree's benchmark has no `--markers`, so plain `-E`'s printing was measured in `now` alone. Those runs
printed the usage (`runs/mainE.issue.*`, `runs/sqliteE.issue.*`).

## Results

Medians of the 7 rounds, in ms:

| `-E -P` | `issue` printing | `now` printing | change | per output token | share of the run |
|---|---|---|---|---|---|
| `main.c` | 44.522 | 17.992 | −59.6% | 6.491 → 2.623 ns | 35.3% → 17.6% |
| `sqlite3.c` | 4.570 | 1.685 | −63.1% | 6.471 → 2.386 ns | 31.2% → 13.7% |

Each tree's seven printing medians fall within 0.33 ms on `main.c` and 0.06 ms on `sqlite3.c`. The two trees' ranges
don't overlap. The same runs' cycle counts put the core at about 4.64 GHz. There, `main.c`'s printing went from about
30 cycles an output token to about 12.

The whole `-E -P` runs went 126.186 → 102.497 ms on `main.c` and 14.641 → 12.292 ms on `sqlite3.c`. The rest of
preprocessing grew in that time, 81.664 → 84.505 ms and 10.071 → 10.607 ms, through other work merged between the
two commits. So the printing change, not the whole-run change, is the measure of #649.

With line markers, `now` alone: `main.c` printed in 24.883 of 97.820 ms (25.4%), 3.628 ns an output token, and
`sqlite3.c` in 3.310 of 13.556 ms (24.4%), 4.687 ns.

## Limitations

- One host and one series. The binaries were built with the host's clang 23.1.1 (`identity.txt`). The issue's
  first figures came from other inputs: the daily job's `main.c` of its day, and an EPYC 9V45 for `sqlite3.c`.
- Per-PR attributions live in each PR's own record:
  [perf#64](https://github.com/buster14a/buster-performance/pull/64) for #685, #1028's native job, and
  `printer-classes-649-2026-11-02` (perf#224) for #1184. #1074's figures are in its PR. This record measures only the
  sum of all four.
- The `--only vectorized` medians are `benchmark-preprocessor`'s in-process timings, not process wall time.
