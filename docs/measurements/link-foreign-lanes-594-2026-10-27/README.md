# link-foreign's default lanes by its objects' bytes: #594 on the 9700X

2026-10-27. [buster14a/buster#594](https://github.com/buster14a/buster/issues/594)
found `link-foreign` with its threads (`--lanes=8`, what `benchmark-link` ran as
its threads) 13% to 71% slower than one lane on `benchmark-link`'s programs of
up to 2,000 workers, and asked that its default never be slower than one lane.
Its branch (`claude/github-issue-594-3a1300`) makes the default (no `--lanes`)
take the lanes the link's objects pay for: one, and one more per 3 MB of the
objects (and of archives under `--whole-archive`), at most 8 and one per CPU,
decided by the calling thread from the command line's first inputs before any
lane runs; `--lanes N` still runs N.

This record holds the sweep the threshold comes from (complete) and a first
confirmation of the head (one pass); a redesigned confirmation is written but
not run (see "Not run yet").

**October 28 continuation:** the redesigned confirmation is now complete in
[confirmation2](confirmation2/README.md): 7,750 successful processes, all 28
output families identical, and the final benchmark row qualified by exact-head
hardware CI. The original handoff description below is retained as history.

## Executables and inputs

- **v0**, main [`d8805cb7`](https://github.com/buster14a/buster/tree/d8805cb7436542f16e1015c29f66feb15dac7c81),
  its tree file for file (`manifests/manifest-v0.sha256`).
- **v1**, the head's first build: the sources of
  [`5b52f096`](https://github.com/buster14a/buster/tree/5b52f09673ff6e4619c8610df523c3bac35a6322)
  file for file, but `AGENTS.md`, whose wording of benchmark-link's rows came
  later (`manifests/manifest-v1.sha256`). The branch's later commits change
  `benchmark-link` (a row more) and the documentation, not `link-foreign`.
- Both built on the 9700X as its CI job builds them (`BUSTER_DEBUG_INFO=0
  ./build.sh`), each under its own hold of the shared lock; sha256s in
  `manifests/builds594.sha256` (with procbench's).
- The inputs: `benchmark-link`'s programs that call libc, written as objects by
  v0's `benchmark-link --functions N --filler F --only linkers --linkers
  link-foreign --runs 1 --keep`: 1 worker (filler 8, 4 units, 14,392 bytes),
  2,000 (filler 8: 1,338,960 bytes; filler 64: 1,682,168), 5,000 (4,325,928),
  10,000 (8,763,360), 20,000 (17,959,696), 40,000 (36,748,304) and 102,400
  (96,187,488), filler 64 past 2,000, 200 workers a unit. `benchmark-link`
  writes a program's objects again for each kind, and a shared library's
  differ (exported, position-independent), so `--keep` keeps only the last
  kind's: `setup594.sh` kept the shared library's (`links/N-F`,
  `logs/links/N-F.log`) and `setup594b.sh` the executables'
  (`--kinds dynamic`, `links/N-F-exec`, `logs/links/N-F-exec.log`).
- AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, clang 23.1.1, GCC 16's crt objects
  and libgcc, glibc 2.44. Objects and outputs on btrfs (`/home`). CPU 2 has the
  performance governor and both NVMe drives' third queues' interrupts; the
  other online CPUs (0-9, 11-15) powersave.

## The harness

`procbench.c` is #501's harness with room for 256 commands and lines of 128 KB,
and a list it can't hold is an error: #501's took 64 and read the first 64 of a
longer list silently, which cut this sweep's first pass (`sweep/old594/`, left
out of the analysis). Each list holds one command per case and way, run once
per round, 20 ms before each run (200 ms from 10,000 workers, `benchmark-link`'s
pauses), and procbench's rotation starts each round one command later. Each
procbench call's first round is left out as its warm-up.

## The sweep

`sweep594.sh v0 4` (after `restart594.sh`): four passes, each under one hold of
the lock (about 110 s), of `sweep-small-v0.list` (1 to 5,000 workers, 10 rounds)
and `sweep-big-v0.list` (10,000 to 102,400 workers, 3 rounds), every kind (d,
s, p, l: dynamic PIE, static executable, static PIE, shared library), by v0
with `--time` and its report kept: `--lanes=1` pinned to CPU 2 (`1p`,
`benchmark-link`'s one thread), `--lanes=1` unpinned (`1`), and `--lanes=2`, 3,
4, 6 and 8 unpinned (`benchmark-link`'s threads). 36 runs kept per command of
the small list, 8 of the big. `analyze594.py v0` gives
`sweep/analysis594-sweep.txt`: each kind's medians by way, faults, context
switches, CPU time and peak RSS, and each case's `--time` stages; the reports
are `sweep/out594-reports.tar.xz` (`ROUND-LABEL-RUN.err`).

The dynamic PIEs' medians in µs (the default's lanes last, the rule at 3 MB):

| Workers | Objects | 1 lane, CPU 2 | 1, unpinned | 2 | 3 | 4 | 6 | 8 | Default |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | 14 KB | 1,024 | 1,144 | 1,345 | 1,409 | 1,504 | 1,567 | 1,692 | 1 |
| 2,000 | 1.34 MB | 1,716 | 1,751 | 1,826 | 1,801 | 1,873 | 2,005 | 2,211 | 1 |
| 2,000 | 1.68 MB | 1,887 | 1,953 | 1,827 | 1,918 | 1,965 | 2,117 | 2,256 | 1 |
| 5,000 | 4.33 MB | 3,149 | 3,029 | 2,693 | 2,597 | 2,714 | 3,099 | 3,389 | 2 |
| 10,000 | 8.76 MB | 5,728 | 5,700 | 4,826 | 4,303 | 4,422 | 4,775 | 4,928 | 3 |
| 20,000 | 18.0 MB | 10,946 | 10,900 | 8,618 | 7,584 | 7,477 | 7,128 | 7,410 | 6 |
| 40,000 | 36.7 MB | 22,562 | 22,171 | 16,257 | 14,321 | 13,822 | 13,051 | 13,513 | 8 |
| 102,400 | 96.2 MB | 60,391 | 59,847 | 42,106 | 36,064 | 33,221 | 31,733 | 32,046 | 8 |

Against the fastest count (of CPU 2's one lane and 2 to 8 unpinned), the
default's lanes are 0 to +3.7% from 4.3 MB of objects in every kind but the
static executable of 8.8 MB (+4.9% against 4 lanes). Below 1.7 MB, one lane is
the fastest count, or within 0.1% of it, for the dynamic PIEs and the shared
libraries of 1 and 2,000 workers and the 1-worker static PIE; 2.7% to 7.7%
over it for the other dynamic PIEs, static PIEs and shared libraries; and the
static executables 5.4% to 10.6% over 2 lanes' (their runtime's members of
`libc.a`, about as much work as 2.5 MB of objects, which the rule doesn't
count). Every run exited 0.

## The first confirmation

`chain594e.sh` ran one hold of `confirm594.sh 3` before it was stopped: the
lists of `lists594c.py` (`confirm1/`), 41 rounds of `confirm-small` (1 and 2,000
workers) and 6 of `confirm-big` (102,400), by v0 and v1: `m1` and `h1`
(`--lanes=1` pinned to CPU 2), `mu` (v0's default, unpinned), `m8` and `h8`
(`--lanes=8`), `hd` (v1's default, unpinned) and `hp` (v1's default pinned to
CPU 2). `analyze594c.py confirm1` gives `confirm1/analysis594c.txt`.

- **Placement.** Main's own default, one lane, took 24% to 59% longer
  unpinned than pinned to CPU 2 (`mu/m1`, paired medians), on every kind of 1
  and 2,000 workers. So `benchmark-link`'s "its threads" (unpinned) against
  "1 thread" (CPU 2) shows the head's default, which runs one lane there,
  13% to 53% slower (`hd/h1`), by placement alone.
- **At one placement the default is one lane's link:** pinned, `hp/h1` −8.6%
  to +6.3%; unpinned, `hd/mu` −2.8% to +5.0%; every interquartile range of
  `hd/mu` across 0, and all of `hp/h1`'s but the 1-worker static executable's
  (−14.9% to −5.6%, the default faster).
- **102,400 workers:** the default took 37% to 46% off `h1`, every kind, and
  was `h8`'s median within 1.5% (5 rounds).
- **Why stopped:** the lists ran each variant's eight cases as a block, and
  mixed one-lane and eight-lane variants in one list, so a variant's runs
  follow a fixed other variant's (`h1` always after `m8`'s eight lanes, `hp`
  after `hd`): `hp/h1` and `h1/m1`, the same code on one lane, differed by up
  to 9% and 22%. Its comparisons across placements are larger than that, those
  within one are not yet resolved.

## Not run yet

`lists594d.py`, `confirm594d.sh`, `analyze594d.py` and `chain594f.sh` are the
confirmation redesigned for that: one lane's variants in lists of their own,
pinned and unpinned in turn (`m1 mu h1 hd hp hu`, `hu` v1's `--lanes=1`
unpinned), and the lanes' in theirs (`m8 h8`; `m8 hd h8` for 102,400 workers),
the mid programs (5,000 to 40,000) by `hu h1 hd h8`, and `--time` of `hd` and
`hu`; two passes of two holds. `chain594f.sh` first rebuilds v1 from the
branch's head (its later `benchmark-link` row), then runs them,
`linkbench594.sh v1 1` (`benchmark-link --only linkers --linkers link-foreign`
as the CI job runs it) and `outputs594.sh` (every variant's last output of a
case by sha256). To run it on the 9700X: copy the branch's tree to
`~/buster-fast-bench/perf-594-claude/v1` and these scripts beside it, then
`(setsid nohup ./chain594f.sh > chain594f.out 2>&1 < /dev/null &)`.

## Tests

On the 9700X, v1's `test-foreign --cross-check` passed
(`logs/v1-test-foreign_--cross-check.log`). The lock had up to 80 waiters
then, so `test-foreign-corpus` (364 checks), `test-check-debug --cross-check`
(2,534 checks), `test-call-graph` and `./build.sh check-call-graph` ran on the
laptop (Ryzen 9 7940HS) instead, on the commit after v1's (`88497ca3`, its
`benchmark-link` row), and passed.

## Limitations

- The lock's waiting messages and their title, link and pull request lines
  (other sessions') were removed from the logs (`keep594.py`); the scripts'
  standard error files (`*.out`), which held only those, are left out.
- The sweep measures main; the head's default runs those lane counts, but its
  first inputs' opening on the calling thread costs a large link a little more
  than the lanes' open (the 102,400-worker links' `h8`-to-`hd` gap above is
  within 1.5% in 5 rounds; not resolved further).
- The pinned runs share CPU 2 with two NVMe queues' interrupts; static links,
  which write more, ran slower pinned than unpinned on one lane in the sweep
  (2,273 against 2,176 µs for 1 worker), dynamic ones faster.
