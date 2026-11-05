# Tier 1: floating values, ABI records, unsigned 64-bit conversions and the dynamic stack (buster#141), 2026-11-02

Evidence for the four commits after the stack arguments in #141's remaining work
([the handoff](https://github.com/buster14a/buster/issues/141#issuecomment-6566362293)). Each commit is measured
against the commit before it, starting from the stack arguments
([`tier1-stack-arguments-141-2026-11-01`](../tier1-stack-arguments-141-2026-11-01)):

| Measured as | On main | Commit |
| --- | --- | --- |
| `14801fa` on `3146ff1` | `6c23dd3` | Tier 1: floating values |
| `6d1f101` on `14801fa` | `4f8ecf6` | Tier 1: by-value aggregates' ABI records (#789) |
| `4143ea7` on `6d1f101` | `4ca61e7` | Tier 1: conversions of unsigned 64-bit integers |
| `8ef99de` on `4143ea7` | `0659328` | Tier 1: the dynamic stack |

## Setup

- The commits are `claude-141-rebased10.bundle`'s `stack-1086` on buster#1086's head `9b9e43a`. The same commits on main
  `e3a9c49` are the second column, which rebased without conflicts.
- The setup is the stack-arguments record's: the same host, lock, CPU 2, inputs and scripts. `9700x/queue15.sh` built
  each head (`9700x/logs-build/`), ran `tests7.sh`, `programs.sh` against the commit before and `campaign.sh` at seeds
  of its own. Its output is `9700x/queue-15.log`, with lock-wait lines removed.

## Correctness

Every suite of `tests7.sh` passed on each head (`9700x/head-*-tests/`, every log ending `exit 0`). The suites are:

- the IR's, SSA's and the interpreters', on c-testsuite and `sqlite3.c` too;
- Tier 1's with the masks';
- the frame's;
- `test-check-debug --cross-check`;
- `test-checker-driver`;
- c-testsuite's subset by `--tier1` and by `--cross-check`;
- the call graph check.

#142's campaign (`9700x/diff-head-*/campaign.tsv`, 80 programs each), where every failure's first failing step is
clang's:

| Head | Seeds | Pass | clang -O0 compile exits | clang compile output limit | Runs past 30 s |
| --- | --- | ---: | ---: | ---: | ---: |
| `14801fa` | 5200 to 5239 | 63 | 8 | 1 | 8 |
| `6d1f101` | 5300 to 5339 | 67 | 12 | 0 | 1 |
| `4143ea7` | 5400 to 5439 | 67 | 8 | 0 | 5 |
| `8ef99de` | 5500 to 5539 | 72 | 5 | 0 | 3 |

## Coverage

`--tier1-report --tier1-refusals` (`9700x/programs-head-*/reports/`), Tier 1 functions:

| Input | `3146ff1` | `14801fa` | `6d1f101` | `4143ea7` | `8ef99de` |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` (2,668) | 2,558 | 2,657 | 2,664 | 2,666 | 2,666 |
| Lua 5.4.8 (1,088) | 991 | 1,088 | 1,088 | 1,088 | 1,088 |

The ABI records take `sqlite3.c`'s 6 function-level refusals to 0. The dynamic stack changes neither count, since
neither program allocates on the stack dynamically.

## Generated code

speedtest1 (11 rotating rounds per pair, all `--verify` hashes `1248168 a7fa3957...`), base to head:

| Head | Median wall | Ranges | Instructions | Cycles |
| --- | --- | --- | --- | --- |
| `14801fa` | 213.55 to 214.50 ms | 212.64–214.41 against 214.10–215.32 | 4,050.2 M to 4,001.4 M (−1.2%) | 1,083.0 M to 1,088.9 M |
| `6d1f101` | 215.21 to 210.13 ms (−2.4%) | 214.72–215.85 against 208.92–211.05 | 4,001.4 M to 3,932.9 M (−1.7%) | 1,092.4 M to 1,064.1 M (−2.6%) |
| `4143ea7` | 209.34 to 210.33 ms | 208.62–210.61 against 209.67–211.25 | equal (3,932.9 M) | 1,060.0 M to 1,067.9 M |
| `8ef99de` | 209.00 to 209.42 ms | 208.08–209.69 against 208.44–210.02 | equal (3,932.9 M) | 1,058.1 M to 1,059.1 M |

The ABI records make speedtest1 faster, with ranges that don't overlap. The others' ranges overlap.

**Lua under the floating values commit is a regression.** With it, Tier 1 compiles all of Lua, `lvm.c`'s interpreter
loop among it, and every script's output still matches clang -O0's. But the scripts run slower than when Tier 0
compiled the loop:

| Script | `3146ff1` | `14801fa` | Change | Instructions |
| --- | ---: | ---: | ---: | --- |
| calls | 31.80 ms | 50.66 ms | +59% | 1,083.9 M to 1,575.8 M (+45%) |
| tables | 57.22 ms | 57.81 ms | +1.0% | 1,709.3 M to 1,818.9 M (+6.4%) |
| strings | 51.96 ms | 56.04 ms | +7.9% | 1,262.0 M to 1,277.0 M (+1.2%) |
| arithmetic | 67.54 ms | 74.27 ms | +10% | 2,450.4 M to 2,990.0 M (+22%) |
| closures | 73.16 ms | 93.84 ms | +28% | 2,056.6 M to 2,496.4 M (+21%) |

In `lvm.c` (the report's per-file rows):

- Tier 1's functions go from 17 of 32 to all 32, and its records from 1,465 to 19,441.
- Spill stores go from 0 to 969, spill loads from 0 to 1,059, and edge moves from 50 to 4,819.

The CFG allocation of the interpreter's loop is where to look before the floating values commit can merge. The later
commits don't change the Lua figures (equal instruction counts, overlapping ranges).

## Compile time: `--tier1 -c sqlite3.c`

`ab` of `time-runs`, 5 rounds of 21 runs per tree (`9700x/programs-head-*/compile-tier1-ab.log`), median rounds:

| Head | Base | Head | Change | Instructions |
| --- | ---: | ---: | ---: | --- |
| `14801fa` | 438.54 ms | 473.81 ms | +8.0% | 5,806.5 M to 6,388.5 M (+10.0%) |
| `6d1f101` | 473.11 ms | 476.78 ms | +0.8% | 6,388.5 M to 6,450.3 M (+1.0%) |
| `4143ea7` | 477.04 ms | 477.30 ms | +0.05% | 6,450.3 M to 6,456.0 M (+0.09%) |
| `8ef99de` | 476.99 ms | 477.15 ms | +0.03% | 6,456.0 M to 6,458.5 M (+0.04%) |

As in the earlier records, the increases follow the code that moves from Tier 0 to Tier 1.

## Limitations

- One `perf stat` run per Lua script and speedtest1 build.
- Compile time was measured on `sqlite3.c` alone.
- The campaign's clang failures weren't classified further here.
- The measured commits are on `9b9e43a`; their copies on main differ only by main's changes since.
