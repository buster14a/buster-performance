# How many lanes the deferred reader runs, 2026-10-25

The 9700X's measurements for Buster PR [#448](https://github.com/buster14a/buster/pull/448), from branch
`claude/sad-jennings-4b8631` (issue [#113](https://github.com/buster14a/buster/issues/113)), the follow-up to PR
[#432](https://github.com/buster14a/buster/pull/432)'s review, which asked that the deferred reader cap its lanes "to the
amount of body work". #432 ran min(`--lanes`, bodies) lanes, and a lane copies the top level's reader when it takes its
first part ([the earlier record](../deferred-lanes-432-2026-10-25/README.md)). Units of a few small bodies still read
slower on eight lanes than on one. The PR runs one lane, and one more per `BUSTER_CHECK_DEFERRED_LANE_TOKENS` (12,288)
of the bodies' tokens beyond twice the largest body's, no more than bodies. These runs measure what a lane costs (the
grid), choose the rule and its count from it, and compare the rule with main's on eight lanes against one (before and
after). On the way they found the benchmark's order of its three readings favouring the reading on more lanes by up
to 3%, which the PR also fixes; the comparisons that decide are made with the fix. Cited by Buster's
`docs/c-deferred-bodies.md` ("How many lanes").

## Sources and inputs

| Tree | Buster commit | Files | Source manifest's SHA-256 |
| --- | --- | ---: | --- |
| `probe` | `14d59dad`: main at `2cb92998` (#432 merged) with the lane costs reported (`copy=`, `wake=`, `body_tokens=`); main's rule, min(`--lanes`, bodies) | 469 | `3771d03cb4673287d9e392a80c9a1bc1dec37330a216f0db0c0c67613d35481c` |
| `rule` | `c0f78d10`: `probe` with the rule, `CheckDeferred.every_lane`, `--every-lane`, `active=` and `largest_body=` | 469 | `6d7d6c279b9eea7f1c5296445052f66aa2f130ff6f9f7d4cabd24efe440d3b28` |
| `balanced` | `8c538df3`: `rule` with the benchmark's passes in all six orders of its three readings | 469 | `e785f739d114549a3859f2e93fe9025ccc9b01a845ce74aa1b4acfc56eccc6a1` |

Each manifest (`source-*.sha256`) lists the SHA-256 of `build.sh` and of every file under `src/` of the tree (what the
build reads), and the host's trees, apart from `build/`, match them. Each was built on the host by Buster's
`./build.sh` with `BUSTER_DEBUG_INFO=0` and `LC_NUMERIC=C`. `rule-every` and `balanced-every` are `rule`'s and
`balanced`'s binaries with `--every-lane`: every lane the bodies can take, as main runs them.

The inputs:

- six of c-testsuite's single-exec programs at commit `5c7275656d751de0e68b2d340a95b5681858ed07` (`inputs.sha256`, the
  earlier record's) and the frozen `sqlite3.c` of [#113's record](../deferred-bodies-113-2026-10-25/README.md);
- 28 synthetic units from `scripts/gen.c` (`synthetic.sha256`, which lists `gen.c` too): `gen B S` writes `B` function
  bodies of `S` blocks of 52 tokens each (a local from a call, a struct from it, an if-else), after `stdio.h`,
  `stdlib.h` and `string.h`; `gen B S bare` after no header; `gen B S heavy` after thirty of the C library's headers;
  and `gen B S - F` with a first body of `F` blocks. Each unit but the bare ones also has glibc's six small
  `static inline` bodies. The names are `h` (three headers), `b` (bare), `x` (heavy) and `l` (a first body of its own), `BxS`, and
  `fF`;
- for the c-testsuite sweep, the 220 programs of Buster's `tests/c-testsuite/subset.txt` at the same commit.

Every file is read with the frozen corpus's pinned predefines and headers, as in the earlier records.
`SOURCE_DATE_EPOCH=1792454400`; `CPATH` and `C_INCLUDE_PATH` are unset. Host: AMD Ryzen 7 9700X, clang 23.1.1. CPU 2
has the performance governor and energy preference; CPUs 0, 1 and 3 to 7 have powersave and `balance_performance`
(read from sysfs during the runs). The command is

```sh
./build/compiler benchmark-checker-deferred --passes 21 --lanes L --cpus 2,0,1,3,4,5,6,7 [--every-lane] [the options] FILE
```

with `--passes 9` for `sqlite3.c` (24 and 12 with `balanced`, multiples of its six orders), each unit and lane count in a
process of its own (`scripts/runs.sh`). Each pass parses the unit and checks it by source order's `check_input` and by
the deferred reader on one lane and on `L`, in three orders that rotate (`probe`, `rule`) or six (`balanced`); a figure
is the median of the passes, in nanoseconds per token. A lock hold covered one round of every unit (`round*.sh` and
`batch*.sh`, which the queue scripts write), 40 to 70 s, the order of units and lane counts rotating by round.

- `logs/log1.txt` (`scripts/queue1.sh`): the grid, `probe` on the six programs, `sqlite3.c` and 17 synthetic units, on
  2, 3, 4, 6 and 8 lanes (2 and 8 for some), three rounds.
- `logs/log4.txt` (`scripts/queue4.sh`): `probe` on two equal bodies of 12,485, 16,645 and 24,965 tokens and the
  heavy units, three rounds.
- `logs/log5.txt` (`scripts/queue5.sh`): `probe` on one large body beside fifteen smaller ones, three rounds.
- `logs/log2.txt` (`scripts/queue2.sh`): before and after, `probe`, `rule` and `rule-every` on eight lanes on all 35
  units, five rounds.
- `logs/log3.txt` (`scripts/queue3.sh`, started by `chain3.sh`): `probe` and `rule` on eight lanes on c-testsuite's
  220 programs, one round.
- `logs/log6.txt` (`scripts/queue6.sh`): `balanced-every` on 2, 3, 4 and 8 lanes on the 22 units around the rule's
  steps, three rounds.
- `logs/log7.txt` (`scripts/queue7.sh`): before and after, `balanced` and `balanced-every` on eight lanes on all 35
  units, five rounds.
- `logs/log8.txt` (`scripts/queue8.sh`): `balanced` and `balanced-every` on eight lanes on c-testsuite's 220 programs,
  one round.

`scripts/rows.awk`, `summary.awk`, `rule.awk` and `compare.awk` make the tables below from the logs. The lock's waiting
messages went to files of their own, which aren't published; the logs are as the runs wrote them. Two earlier starts
of the grid with a lock hold per run (11 and 10 runs) were stopped for taking too long against CI's jobs and aren't
published either. `queue4.sh` waited for `queue1.sh` by its PID, `queue5.sh` was started once `queue4.sh` was done,
`chain3.sh` started `queue3.sh` once `queue2.sh` was done, and `queue6.sh` starts `queue7.sh`, which starts
`queue8.sh`. The runs before `rule` was built used the same `runs.sh` with a third field for `--lane-tokens` that none
of them passed.

## Results

`tables/` has every figure below and the rest, made from the logs: `rows*.tsv` (`rows.awk`, a row per process),
`grid*.tsv` (`summary.awk`: each unit and lane count over the rounds), `rule-grid*.tsv` (`rule.awk`: the rule's lanes
and change against the grid's best, with `largest.tsv`, each unit's largest body as `rule` reports it) and
`compare*.tsv` (`compare.awk`: before and after).

### What a lane costs (the grid, logs 1, 4 and 5)

Medians over three rounds of each process's medians:

| Unit | A copy alone (µs) | On average, 2 lanes | 8 lanes | The first lane's wait at the partition, 8 lanes (µs) | A body token's walk, 1 lane (ns) | On 8, the lanes' mean |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `h16x1` | 31 | 50 | 176 | 13 | 17.6 | 45.4 |
| `h16x19` | 50 | 99 | 251 | 14 | 14.7 | 28.2 |
| `h16x154` | 72 | 119 | 296 | 18 | 15.3 | 29.8 |
| `x16x19` (thirty headers) | 94 | 162 | 376 | 15 | 14.7 | 28.1 |
| `b16x19` (none) | 33 | 50 | 209 | 14 | 14.3 | 25.8 |
| `sqlite3.c` | 345 | 451 | 845 | 26 | 22.0 | 35.1 |

A copy alone and the walks on one lane are the 8-lane processes' one-lane readings; the averages on 2 lanes are the
2-lane processes'. The wait is 13 to 28 µs in most runs and 2 to 3 µs in the rest. On two lanes, the woken lane's walk of a body token
takes 1.8 to 2.05 times the first lane's: two equal bodies of 24,965 tokens average 22.2 ns over the two lanes, where
the first lane alone takes 14.9 (`h2x480`), so the woken lane takes about 29.5.

### The rule's count (the grids, logs 1, 4, 5 and 6)

Log 6 measures the units around the rule's steps again, with the benchmark's six orders (`balanced`, `--every-lane`),
three rounds; the medians of each lane count's reading against one lane's:

| Unit | Bodies' tokens beyond twice the largest body's | 2 lanes | 3 | 4 | 8 |
| --- | ---: | ---: | ---: | ---: | ---: |
| `h16x10` | 7,553 | +1.5% | +1.9% | +3.1% | +11.2% |
| `x16x10` | 7,553 | +1.1% | +1.9% | +2.3% | +7.1% |
| `h64x3` | 10,185 | +0.3% | +0.7% | +0.6% | +5.3% |
| `b16x19` | 13,902 | −3.7% | −3.4% | −3.9% | +5.4% |
| `h16x19` | 14,105 | −0.8% | −0.4% | +0.7% | +5.3% |
| `x16x19` | 14,105 | +0.2% | +0.6% | +0.3% | +3.9% |
| `h2x240` | 203 | +3.1% | +4.2% | +6.1% | +10.5% |
| `h2x480` | 203 | +1.6% | +2.3% | +1.9% | +4.3% |
| `h16x38` | 27,937 | −2.2% | −3.6% | −4.9% | −2.0% |
| `h16x154` | 112,385 | −6.9% | −7.7% | −7.9% | −10.7% |
| `sqlite3.c` | 497,917 | −8.0% | −10.3% | −11.4% | −12.5% |

So a second lane lost on 7,553 and 10,185 tokens beyond twice the largest body's and paid on 13,902 and 14,105 (but
for `x16x19`, neutral), and two equal bodies lose on two lanes at every size measured. 12,288 sits between.
`rule-grid6.tsv` has the rule's lanes on each unit against the grid's best: within 1% but on six units, four whose
two lanes were faster than one (`00204.c` −3.5%, `b16x5` −3.8%, `l16x38f384` −3.3%, `l16x19f192` −1.3%) and two
that it gives fewer lanes than the best (`h16x38`: 3 lanes −3.6% against 4 lanes −4.9%; `l16x38f192`: 2 lanes
−3.8% against 3 lanes −4.9%). The first grid (logs 1, 4 and 5, with the three rotating orders) puts every unit on the
same side of the rule's steps but `x16x19`, whose two lanes read 0.3% faster there.

### Before and after (logs 7 and 8; logs 2 and 3)

Log 7: the rule and main's rule (`balanced-every`) on 8 lanes against 1 lane, five rounds of 24 passes (12 for
`sqlite3.c`): the medians over the rounds and the lowest and highest, and the 8 lanes' readings in nanoseconds per token.

| Unit | Beyond twice the largest | The rule's lanes | Main's rule, 8 against 1 (range) | The rule, 8 against 1 (range) | Main's on 8 | The rule's on 8 | The rule's against main's on 8 |
| --- | ---: | ---: | --- | --- | ---: | ---: | ---: |
| `00001.c` | 0 | 1 | +2.4% (−5.8 to +7.9) | −3.2% (−5.8 to +9.0) | 4988.22 | 4960.44 | −0.6% |
| `00169.c` | 0 | 1 | +0.4% (−0.3 to +1.0) | −0.1% (−1.4 to +0.7) | 87.69 | 86.74 | −1.1% |
| `00213.c` | 0 | 1 | +51.8% (+50.7 to +58.7) | +0.3% (−1.3 to +0.5) | 346.00 | 219.52 | −36.6% |
| `00200.c` | 0 | 1 | +18.7% (+17.4 to +20.1) | +0.0% (−1.5 to +0.9) | 80.80 | 66.94 | −17.2% |
| `00182.c` | 346 | 1 | +23.2% (+21.8 to +26.0) | −0.0% (−0.5 to +0.6) | 109.44 | 86.08 | −21.3% |
| `00204.c` | 2,114 | 1 | +9.7% (+5.9 to +13.2) | +0.1% (−0.6 to +0.5) | 103.60 | 91.91 | −11.3% |
| `sqlite3.c` | 497,917 | 8 | −12.5% (−13.0 to −12.4) | −12.8% (−12.9 to −12.6) | 105.62 | 105.24 | −0.4% |
| `h16x1` | 913 | 1 | +23.2% (+22.7 to +25.6) | +0.0% (−0.3 to +0.3) | 101.79 | 81.39 | −20.0% |
| `h16x2` | 1,729 | 1 | +22.1% (+17.1 to +24.8) | +0.3% (−0.2 to +0.5) | 99.60 | 80.18 | −19.5% |
| `h16x5` | 3,913 | 1 | +16.4% (+13.6 to +18.1) | +0.1% (−0.1 to +0.3) | 91.62 | 77.13 | −15.8% |
| `h16x10` | 7,553 | 1 | +11.4% (+11.2 to +13.3) | +0.2% (−0.4 to +0.3) | 83.60 | 72.71 | −13.0% |
| `h16x19` | 14,105 | 2 | +4.4% (+3.8 to +5.8) | −0.3% (−0.7 to +0.2) | 76.09 | 71.64 | −5.8% |
| `h16x38` | 27,937 | 3 | −1.8% (−3.2 to −1.6) | −3.9% (−4.5 to −2.7) | 69.98 | 67.89 | −3.0% |
| `h16x77` | 56,329 | 5 | −7.8% (−9.6 to −7.0) | −7.6% (−8.5 to −7.5) | 67.33 | 67.15 | −0.3% |
| `h16x154` | 112,385 | 8 | −10.8% (−11.0 to −10.1) | −10.7% (−11.0 to −8.8) | 69.35 | 69.45 | +0.1% |
| `h2x40` | 203 | 1 | +24.4% (+22.3 to +25.2) | −0.1% (−0.1 to +0.3) | 98.39 | 77.40 | −21.3% |
| `h2x80` | 203 | 1 | +19.3% (+17.8 to +20.3) | +0.1% (−0.0 to +0.3) | 88.86 | 72.81 | −18.1% |
| `h2x160` | 203 | 1 | +14.3% (+13.6 to +15.4) | +0.3% (−0.4 to +1.0) | 82.89 | 71.42 | −13.8% |
| `h64x1` | 3,649 | 1 | +14.7% (+14.4 to +15.4) | −0.1% (−0.3 to +0.6) | 91.19 | 77.80 | −14.7% |
| `h64x3` | 10,185 | 1 | +5.9% (+5.6 to +6.9) | +0.2% (−0.3 to +0.3) | 77.31 | 71.22 | −7.9% |
| `h64x10` | 32,753 | 3 | −3.5% (−4.3 to −2.7) | −4.9% (−5.1 to −3.7) | 69.40 | 67.56 | −2.7% |
| `b16x5` | 3,710 | 1 | +14.0% (+11.9 to +16.8) | +0.2% (−0.6 to +0.5) | 85.77 | 73.57 | −14.2% |
| `b16x19` | 13,902 | 2 | −3.1% (−5.7 to −2.3) | −8.3% (−8.4 to −3.6) | 60.39 | 55.53 | −8.0% |
| `b16x77` | 56,126 | 5 | −9.7% (−9.9 to −9.2) | −9.5% (−9.9 to −8.9) | 61.56 | 61.58 | +0.0% |
| `h2x240` | 203 | 1 | +10.7% (+10.0 to +11.3) | +0.6% (−0.3 to +1.0) | 80.69 | 71.70 | −11.1% |
| `h2x320` | 203 | 1 | +8.5% (+7.6 to +10.3) | +0.3% (−0.4 to +1.0) | 80.00 | 72.27 | −9.7% |
| `h2x480` | 203 | 1 | +3.2% (+2.4 to +4.8) | +0.7% (+0.5 to +1.4) | 76.14 | 73.37 | −3.6% |
| `x16x10` | 7,553 | 1 | +7.2% (+7.0 to +7.5) | −0.0% (−0.9 to +1.3) | 87.99 | 80.22 | −8.8% |
| `x16x19` | 14,105 | 2 | +3.8% (+3.5 to +4.1) | −0.0% (−1.0 to +0.9) | 85.09 | 80.93 | −4.9% |
| `x16x38` | 27,937 | 3 | −0.6% (−0.8 to −0.2) | −1.2% (−1.6 to −0.6) | 79.68 | 77.84 | −2.3% |
| `x16x77` | 56,329 | 5 | −4.9% (−5.4 to −4.3) | −4.9% (−5.6 to −4.4) | 75.96 | 75.53 | −0.6% |
| `l16x19f192` | 5,109 | 1 | +6.7% (+5.4 to +7.7) | −0.1% (−0.7 to +1.2) | 77.79 | 72.12 | −7.3% |
| `l16x38f192` | 19,929 | 2 | −2.0% (−2.2 to −0.2) | −3.3% (−3.8 to −3.2) | 74.15 | 71.88 | −3.1% |
| `l16x38f384` | 9,945 | 1 | +0.9% (−0.1 to +2.6) | +0.4% (−0.1 to +0.4) | 76.42 | 74.30 | −2.8% |
| `l16x77f384` | 40,365 | 4 | −6.2% (−6.6 to −5.8) | −7.9% (−9.3 to −7.6) | 70.83 | 69.01 | −2.6% |

On c-testsuite's 220 programs (log 8, one round of 24 passes), main's rule read 71 programs more than 2% slower on 8
lanes than on 1 and 50 more than 5% (mean +6.5%, `00215.c` +79.7%); the rule reads all 220 on one lane, and its two
readings, the same work, came within −0.8 to +0.9% on the 62 programs of 1,000 tokens or more (standard deviation
0.35%), −2.8 to +3.8% on the 27 of 100 to 999 (1.40%) and −10.7 to +7.3% on the 131 under 100 (2.87%). `00078.c`
goes to source order (a body declares something with linkage), and its runs exit with status 1, as the benchmark's do
for such a unit.

Logs 2 and 3 are the same comparisons made before the benchmark's orders were balanced, against `probe` (main's code
with the lane costs reported) and with `rule-every` too. They agree in every lane count and sign, but the three
rotating orders gave the reading on 8 lanes the advantage of following the deferred reader's own run in two passes
of three. On the 21 units the rule reads on one lane both times (but `00001.c`, whose nine tokens' readings vary by
±6%), the medians of "8 lanes" against one were −3.2 to +0.4% in log 2, seven of them below −1%, and −0.1 to +0.7%
in log 7. `compare2.tsv` and `compare3.tsv` have them.

## Limitations

The synthetic units are of one statement shape; the rule's count holds for them and for c-testsuite's programs and
`sqlite3.c`, on this host, whose CPUs other than 2 run the powersave governor: a woken lane's half speed is that
host's, and a machine whose cores all run at the first lane's speed would pay for lanes sooner. The reader alone is
timed (`check_input`'s work), not the checked graph after it. The units of a few dozen tokens take tens of
microseconds to read, so their changes are noise of a few percent either way.

