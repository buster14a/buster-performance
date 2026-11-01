# The undefined-internal facts over candidate tokens (buster#1039), 2026-11-01

Evidence for [buster#1039](https://github.com/buster14a/buster/issues/1039):
`check_warning_undefined_internal` takes its tokens from the reader's 64-token
scans instead of visiting every token three times, and skips the uses' scan when
every collected function is supplied. By a Factory Droid session (Anthropic /
Claude Opus 5.5), at David's request.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `9a511a6a87bf1ead8498da9131cce4f600e13605` | main, the merge of buster#1024 |
| head | `f5d31a1ecba7f459fde71b27a66c61e580c0a14c` | the PR's one commit on that base |

Each tree on the host is the same files as `git archive` of its commit, file by
file by sha256 (`tree-base.txt`, `tree-head.txt`; the build directory and the
host's `COMMIT` note left out).

- **Host:** `benchpress`, an AMD Ryzen 7 9700X, Linux 6.18.50-2-lts, the
  `performance` governor (`host.txt`). Every build, test and timed run held the
  host's shared lock once; timed runs were pinned to CPU 2.
- **Compilers:** each tree built with `BUSTER_DEBUG_INFO=0 ./build.sh` by the
  host's staged clang 23.1.4 (`compilers.txt` has every binary's sha256),
  and again at six placements of `main_unit_checker.c`'s code
  (`./build.sh shifts`, 0, 704, 1344, 2048, 2688 and 3392 bytes).
- **Source:** `sqlite/sqlite3.c` of the frozen corpus
  `preprocessor-391e729af658`, with the CI options:

```sh
-c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE -I"$sqlite" "$sqlite/sqlite3.c"
```

## Commands

`scripts/chain-wip2.sh` ran, in order: the head's build (`build.sh`), its six
placements (`shifts.sh`; the base's were built the same way before), the
validation (`validate.sh head-wip2 base-9a511a6a`), the placement A/B
(`abshifts.sh ab-wip2 3`) and the head's profile (`prof.sh`); `prof.sh` had
profiled the base the same way. `run.log` has each step's exit status.

- **Validation** (`validation/`, each command its own hold): `test-checker --seed
  133`; `test-c-testsuite --cross-check` and `--tier1` of the 220-program subset;
  `test-checker-driver --executable`; `test-checker-corpus` of `sqlite3.c`
  against clang; the object of `-c sqlite3.c` by both builds and both paths; and
  `-fsyntax-only` of `undefined.c`, a unit with two used, undefined internal
  functions, by both builds and both paths.
- **A/B** (`ab.txt`): `ab --rounds 3 --cpu 2` of `time-runs --runs 3 --copies 3`
  over base, head and base-again at the six placements each, the lock taken per
  process: 54 compiles per role.
- **Profiles** (`profile-base/`, `profile-head/`, one hold each): three
  `--time-stages` reports and one with `--lanes 1`, `perf stat -r 11` by default
  and with `--lanes 1`, and `perf record -F 20000` over five compiles with
  `--lanes 1` (`symbol.txt`, `dso.txt`).

## Results

Correctness (`validation/status.txt`): every suite exited 0. `test-checker`
718,776 checks, 0 failures; c-testsuite 220 of 220 both ways;
`test-checker-driver` 48,000 checks, 0 failures; the corpus check of
`sqlite3.c` 0 differences. The four objects (base and head, vector and scalar)
are the same bytes, and so are the four `-Wundefined-internal` reports
(`validation/objects.txt`).

Timing, `ab.txt`'s medians over the 54 compiles of each role:

| | base | head | change | base-again |
| --- | ---: | ---: | ---: | ---: |
| wall | 134.708 ms | 132.297 ms | -1.79% (placements -2.34% to -1.43%) | +0.06% |
| user cycles | 631.795 M | 618.761 M | -2.06% (placements -2.54% to -1.73%) | +0.11% |
| user instructions | 1,399.62 M | 1,376.14 M | -1.68% | 0 |

Over placements and copies, the wall change ranged from -2.79% to -0.64% and the
cycles' from -3.16% to -1.00%; base-again stayed within -0.91% to +0.90%.

Profiles (`perf stat -r 11` and the median of three `--time-stages`):

| | base | head |
| --- | ---: | ---: |
| cycles:u | 632.24 M | 618.54 M |
| instructions:u | 1,399.62 M | 1,376.14 M |
| branch-misses:u | 3.556 M | 3.282 M |
| `check-program` stage | 13.913 ms | 11.666 ms |
| `check_warning_undefined_internal` | 1.34% of samples | under the report's 0.2% limit |

`sqlite3.c` has internal functions that aren't defined, so its uses' scan still
runs; the gain there is the scans' candidates alone.

## Files

- `scripts/`: the harness (`env.sh`, `build.sh`, `shifts.sh`, `validate.sh`,
  `abshifts.sh`, `prof.sh`, `chain-wip2.sh`).
- `validation/`: each suite's output, `status.txt`, the objects' sha256 and the
  warnings' md5 (`objects.txt`), `undefined.c` and its reports.
- `ab.txt`: every timed process and the summaries.
- `profile-base/`, `profile-head/`: `inner.sh`, the stage reports, perf stat's
  and perf report's output, the object's sha256.
- `compilers.txt`, `host.txt`, `tree-base.txt`, `tree-head.txt`: the identities.
- `run.log`: the scripts' own lines.

exclusive.sh's messages about other holders of the lock are left out of every
file: they name other sessions' commands and links.
