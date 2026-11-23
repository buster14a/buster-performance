# Tier 0's passes by cause: what its cycles wait on (buster#2874), 2026-11-23

[buster#2874](https://github.com/buster14a/buster/issues/2874) is step 4 of
[buster#2850](https://github.com/buster14a/buster/issues/2850): Tier 0's row at 10 cycles a token. The records before
this one count Tier 0's cycles and instructions by pass. This one counts, for each pass, what the processor did with
its cycles: uops retired, cycles the front end had no uop to give, cycles the back end stalled, with the cache and
predictor events behind them. No compile changes: an experiment patch stops Tier 0 after a pass and reads hardware
counters in the benchmark's own loop.

## What was measured

- **Revision:** buster main `b7d0b5ed` (2026-11-23, with buster14a/buster#3419) and `scripts/census-experiment.patch`,
  Release, `BUSTER_HOST_ARCH=znver5`, built in a cloud container with CI's staged toolchain (LLVM 23.1.4) and copied to
  the 9700X stripped (`binaries.sha256`).
- **The harness:** `benchmark-backend-source --only vector` on the frozen `sqlite3.c` (`tools/ci/fetch-corpus.sh`'s
  archive `ceb39bf9…`, the options of [the row's record](../tier0-row-main-2874-2026-11-23/README.md)): the unit is
  checked and lowered once, then `tier0_compile` runs over its 2,602 functions' typed streams (371,237 entries), 41 times
  (328 for the first three stops, whose runs are short), and each count is the median of those runs over the entries.
- **A pass's count** is a difference: `BUSTER_TIER0_STOP=k` returns from Tier 0 after pass k, and pass k's count is
  stop k's less stop k - 1's. A difference of two medians can come out slightly negative where a pass's own count is
  near zero.
- **Counters:** five a run (cycles, instructions, the benchmark's throttle counter and two raw events), which is what
  the 9700X has free beside the NMI watchdog's. A first set with seven a run was multiplexed (a 3 ms rotation) and read
  zeros in the short runs; it was thrown away. The event sets are in `scripts/census.sh`.
- **Three populations:** every function (`results/census-all`), those under 64 entries (`census-small`: 1,437
  functions, 38,802 entries) and those of 512 or more (`census-large`: 115 functions, 155,493 entries), by
  `BUSTER_TIER0_MIN` and `BUSTER_TIER0_MAX`.
- **The runs:** the 9700X, CPU 2, each population one hold of the lock (`scripts/run-census.sh`); `busy-*.txt` has the
  busiest processes before and after.
- **Slots:** the 9700X dispatches eight uops a cycle, so a pass has eight slots a cycle. A slot retires a uop, is left
  empty by the front end (`de_no_dispatch_per_slot.no_ops_from_frontend`), is stalled by the back end
  (`de_no_dispatch_per_slot.backend_stalls`), or held a uop that didn't retire (a mispredicted path's).

The benchmark compiles one function after another with nothing between them. A compile runs each body's branch
sizing, encoding and unwind rows between two bodies' Tier 0, and its `tier0` stage reads about 58 cycles an entry where
the benchmark reads 50.

## Every function, an entry (`results/census-all/summary.md`)

| pass | cycles | instructions | uops | retired | front end empty | back end stalled | mispredicted | op cache misses | L1I misses | uops from the decoder | L1D fills | microcoded uops |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| setup | 1.02 | 3.2 | 3.3 | 40% | 4% | 75% | 0.002 | 0.03 | 0.10 | 0% | 0.02 | 0.02 |
| labels | 1.61 | 1.8 | 2.0 | 16% | 6% | 52% | 0.000 | 0.03 | 0.02 | 2% | 0.09 | 0.00 |
| values (P0) | 1.21 | 9.6 | 9.9 | 102% | -2% | 7% | 0.001 | -0.02 | -0.07 | 1% | 0.07 | 0.01 |
| fusion (P1, P2) | 4.84 | 19.0 | 20.6 | 53% | 6% | 33% | 0.011 | 0.07 | 0.04 | 2% | 0.02 | 0.11 |
| depths (P3, P4) | 1.36 | 4.5 | 4.7 | 43% | 1% | 64% | 0.005 | 0.03 | 0.01 | 1% | 0.01 | 0.00 |
| selection | 6.57 | 20.6 | 25.8 | 49% | 13% | 33% | 0.028 | 0.19 | 0.09 | 5% | 0.23 | 4.85 |
| homes, frame | 4.96 | 12.0 | 11.6 | 29% | 73% | -13% | 0.067 | 1.68 | 0.07 | 66% | 0.02 | -0.01 |
| measuring | 8.32 | 22.1 | 24.1 | 36% | 37% | 24% | 0.033 | 1.90 | 1.04 | 37% | 0.13 | 1.88 |
| output room | 0.49 | 1.2 | 1.2 | 30% | 126% | -38% | 0.001 | 0.57 | 0.36 | 232% | 0.00 | -0.00 |
| emission | 14.23 | 42.9 | 50.0 | 44% | 37% | 14% | 0.073 | 2.97 | 2.14 | 35% | 0.49 | 3.20 |
| forms chosen | 1.75 | 2.7 | 2.8 | 20% | 87% | -7% | 0.000 | 1.05 | 0.41 | 285% | 0.09 | -0.00 |
| forms applied | 2.10 | 9.0 | 8.6 | 51% | 27% | 27% | 0.009 | 0.21 | 0.18 | 34% | 0.11 | 0.00 |
| the rest | 1.22 | 2.9 | 3.0 | 30% | 65% | 12% | 0.008 | 0.50 | 0.43 | 76% | -0.02 | 0.12 |
| **Tier 0** | 49.68 | 151.3 | 167.4 | 42% | 34% | 20% | 0.237 | 9.21 | 4.82 | 31% | 1.26 | 10.18 |

- **A third of Tier 0's slots have no uop from the front end** (34%), more than the back end stalls (20%). The passes
  from the homes on are the ones starved: 73% of the homes' slots, 37% of measuring's and of emission's, 87% of the
  forms' choice.
- **The cause is the code's size.** A function's compile misses the first-level instruction cache 4.8 times an entry,
  about 690 times a function of the mean 143 entries: 44 KB of code fetched from the second level for each function,
  where the first level holds 32 KB. It misses the op cache 9.2 times an entry, and 31% of the uops dispatched come from
  the decoder. `tier0_generate` alone is 56 KB in this build, and `x86_encode_16`, which a compile runs between two
  bodies' Tier 0, 23 KB.
- **Mispredicted branches are 0.24 an entry**, most of them in the homes and frame, emission and measuring.

## The functions under 64 entries, a body (`results/census-small/summary.md`)

| pass | cycles | instructions | uops | retired | front end empty | back end stalled | mispredicted | op cache misses | L1I misses | uops from the decoder |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| setup | 131 | 427 | 445 | 43% | 0% | 57% | 0.01 | 3.1 | 13.8 | 0% |
| labels | 92 | 97 | 106 | 14% | 9% | 41% | 0.38 | 1.6 | 1.0 | 1% |
| values (P0) | 49 | 293 | 307 | 78% | 8% | 63% | -0.26 | 1.1 | -7.9 | 4% |
| fusion (P1, P2) | 252 | 992 | 1,067 | 53% | 0% | 45% | 0.14 | 0.7 | 2.0 | 0% |
| depths (P3, P4) | 102 | 239 | 248 | 31% | 3% | 61% | 0.20 | 3.8 | 0.3 | 2% |
| selection | 289 | 1,003 | 1,133 | 49% | 10% | 34% | 0.98 | 5.6 | 13.6 | 0% |
| homes, frame | 259 | 1,127 | 1,063 | 51% | 48% | -7% | 1.34 | 72.7 | -0.1 | 36% |
| measuring | 364 | 989 | 982 | 34% | 67% | -3% | 2.01 | 138.7 | 96.5 | 72% |
| output room | 35 | 178 | 166 | 59% | 2% | 13% | 0.05 | 52.4 | 36.0 | 185% |
| emission | 749 | 1,695 | 1,845 | 31% | 85% | -22% | 3.41 | 339.4 | 233.6 | 130% |
| forms chosen | 180 | 270 | 279 | 19% | 111% | -18% | 1.52 | 97.7 | 48.7 | 432% |
| forms applied | 103 | 241 | 236 | 29% | 37% | 42% | -0.87 | 56.0 | 54.3 | 72% |
| the rest | 94 | 201 | 197 | 26% | 72% | -15% | 0.66 | 53.6 | 52.3 | 229% |
| **Tier 0** | 2,699 | 7,753 | 8,073 | 37% | 50% | 8% | 9.57 | 826 | 544 | 63% |

(A share past 100% or below zero is a difference of two runs' medians on a pass of few cycles.)

- **A body under 64 entries costs 2,699 cycles and 7,753 instructions**, whatever its size: these 1,437 bodies hold
  10% of the entries and take 21% of Tier 0's cycles.
- **Half of it is the front end:** 544 instruction cache misses and 826 op cache misses a body, 63% of its uops from
  the decoder. Emission's 749 cycles are 85% front end.

## The functions of 512 entries or more, an entry (`results/census-large/summary.md`)

| pass | cycles | instructions | uops | retired | front end empty | back end stalled | mispredicted | L1D fills | microcoded uops |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| setup | 0.17 | 0.5 | 0.6 | 43% | 10% | 44% | 0.000 | 0.02 | 0.05 |
| labels | 0.61 | 1.4 | 1.6 | 33% | 6% | 58% | 0.000 | 0.07 | 0.00 |
| values (P0) | 1.68 | 9.3 | 9.5 | 71% | 2% | 27% | 0.001 | 0.06 | 0.00 |
| fusion (P1, P2) | 3.85 | 15.4 | 16.7 | 54% | 2% | 43% | 0.002 | 0.13 | 0.06 |
| depths (P3, P4) | 0.88 | 3.6 | 3.8 | 54% | 2% | 46% | 0.001 | 0.04 | -0.00 |
| selection | 5.73 | 18.0 | 23.2 | 51% | 4% | 44% | 0.004 | 0.29 | 4.76 |
| homes, frame | 1.84 | 5.7 | 5.7 | 39% | 34% | 27% | 0.002 | 0.04 | 0.00 |
| measuring | 6.76 | 19.4 | 23.8 | 44% | 10% | 45% | 0.011 | 0.23 | 4.32 |
| emission | 10.88 | 39.7 | 50.1 | 58% | 8% | 32% | 0.020 | 0.48 | 6.75 |
| forms chosen | 0.63 | 1.4 | 1.4 | 28% | 34% | 30% | 0.000 | 0.04 | 0.00 |
| forms applied | 1.72 | 9.3 | 8.8 | 64% | 6% | 35% | 0.003 | 0.02 | 0.00 |
| the rest | 0.62 | 1.9 | 2.0 | 41% | 13% | 41% | 0.002 | 0.07 | 0.13 |
| **Tier 0** | 35.40 | 125.7 | 147.4 | 52% | 8% | 38% | 0.045 | 1.51 | 16.07 |

- **In a long body Tier 0 takes 35.4 cycles an entry**: its loops stay in the op cache (8% front end), and what is
  left is uops (52%) and the back end (38%).
- **So about 29% of Tier 0's cycles on `sqlite3.c` are a body's fixed part:** 49.7 less 35.4 cycles an entry is 2,040
  cycles a body of the mean size.
- **The three gathers are microcoded:** 16 of the 147 uops an entry (selection's slot words, measuring's
  home-dependent words, emission's homes past 32 locals).
- **The labels' pass is bound by a chain through memory:** 1.6 cycles an entry for 2 uops, its words set a bit at a
  time by a load, an OR and a store.

## Files

- `scripts/census-experiment.patch`: the stop knob (`BUSTER_TIER0_STOP`), the loop count (`BUSTER_TIER0_LOOPS`), the raw
  events (`BUSTER_TIER0_EVENTS`), the sizes kept (`BUSTER_TIER0_MIN`, `BUSTER_TIER0_MAX`) and a dump of the functions
  (`BUSTER_TIER0_DUMP`), on main `b7d0b5ed`. Not for main.
- `scripts/census.sh`: a population's runs, a stop and an event set each; `run-census.sh`: the three holds.
- `scripts/census_table.py CENSUS.txt [--body] [--cumulative]`: every event by pass; `census_summary.py`: the tables
  above.
- `results/census-*/census.txt`: a line a run; `table.txt` and `table-body.txt`: every event by pass, an entry and a
  body; `summary.md`; `busy-before.txt`, `busy-after.txt`.
