# #2850's take-over: where `-c sqlite3.c` stands at `d541430bf`, and #3270's reading

Raw results of [buster14a/buster#2850](https://github.com/buster14a/buster/issues/2850)'s take-over of
2026-11-22 ([the claim](https://github.com/buster14a/buster/issues/2850#issuecomment-7077096460)). The Ryzen 7
9700X (`benchpress`), CPU 2, one lane, Release, every run under the lock. The input is the frozen `sqlite3.c`
(9,507,037 bytes, 716,136 preprocessed tokens) with the 9700X job's options:
`--lanes 1 -c -DSQLITE_OMIT_LOAD_EXTENSION -DSQLITE_THREADSAFE=0 -DSQLITE_ENABLE_MEMSYS5 -DSQLITE_ENABLE_RTREE`.
`scripts/` has what ran: `setup.sh` (an independent clone and a Release build a revision), `stages.sh`,
`profile.sh`, `pair.sh` and its reducer `reduce.py`, and `agg.py`, which sums the profiles.

## The stage table at main `d541430bf`

`stages-d541430bf/`: seven fresh processes with `--time-stages`. Medians, in milliseconds (the lowest and the highest
in the files):

| stage | ms |
| --- | ---: |
| setup | 0.21 |
| preprocess (read 0.58, lex 2.45, refine 1.85, directives 0.36, the main loop 4.35) | 9.57 |
| parse | 6.82 |
| check-input | 42.08 |
| check-expressions | 10.57 |
| check-declarations and static data | 2.54 |
| check-program | 18.85 |
| select | 0.98 |
| lower (prepare 0.97, statements 8.11, bodies 1.28, validate 1.15) | 11.61 |
| Tier 0 | 4.91 |
| the emission's setup, branch sizing, the encoder, unwinding, the code's atoms | 2.43 |
| the data's publication, the object's build and write | 1.31 |
| **total** | **111.94** |

The process: 98.7 ms user, 16.3 ms system, 5,643 minor faults, 238.6 MB peak. One of the seven ran on base pages
(56,408 faults, 179 MB peak, 143.0 ms): the arenas' page policy read the host as busy when it started
(`huge-pages busy`). The medians leave it out of sight; a comparison of two builds has to look for it.

## The profile at main `d541430bf`

`profile-d541430bf/`: eight runs under `perf record -e cycles -c 100003` (user and kernel), reported by symbol
(`report-N.txt`), and five under `perf stat` (`stat.csv`): 545.3 M user cycles, 74.2 M kernel cycles, 1,235.2 M user
instructions, 3.15 M mispredicted branches and 17.2 M first-level data misses a compile, 110.9 ms.
`by-function.txt` is `agg.py`'s sum: the forty functions with the most cycles, then the families. Cycles a token and
milliseconds at 5.49 GHz:

| family | share | cycles a token | ms |
| --- | ---: | ---: | ---: |
| the reader but its expressions (`check_input_*`) | 17.4% | 155.3 | 20.3 |
| the kernel (`clear_page_erms` alone 8.4%, 75 cycles a token) | 13.1% | 117.0 | 15.3 |
| the graph's construction (`check_input_expression*`, the literals) | 9.3% | 82.9 | 10.8 |
| the lowering (`check_lower*`) | 9.0% | 80.4 | 10.5 |
| the program and its controls | 8.6% | 76.7 | 10.0 |
| the warnings | 8.3% | 74.1 | 9.7 |
| Tier 0, the encoder, the emission | 6.1% | 54.7 | 7.1 |
| the parser | 4.7% | 42.3 | 5.5 |
| the graph run (`check_graph*`) | 4.6% | 40.8 | 5.3 |
| other `check_*` | 4.4% | 39.1 | 5.1 |
| the preprocessor and the lexer | 4.0% | 36.0 | 4.7 |
| the C rules for a node (`check_action*`) | 2.6% | 23.0 | 3.0 |
| libc's `memset`, `memmove`, `memcmp` | 2.5% | 22.3 | 2.9 |
| the types, the bindings, the node machine, the rest | 5.6% | 49.8 | 6.5 |

The families are name prefixes (`agg.py`'s rules), so a function inlined into another family's is counted there.

## #3270 on the 9700X: the selected operands' storage on demand

`pair-d541430bf-afde6c1c9/`: main `d541430bf` against buster14a/buster#3270's head merged with it (`afde6c1c9`).
Seven rounds, each parent, candidate, candidate, parent or the reverse; each position takes the lock once and runs a
warm-up, a wall-clock run and a counters run, all fresh processes. `summary.txt` is `reduce.py`'s: a round's value is
the mean of its two runs of an arm, the columns are the medians of the rounds and of the rounds' differences.

| | main | #3270 | paired | lowest | highest | rounds lower |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| wall, ms | 112.720 | 112.662 | -0.058 | -0.286 | +25.247 | 4 of 7 |
| user cycles a token | 757.156 | 753.479 | -1.269 | -4.954 | -0.282 | 7 of 7 |
| kernel cycles a token | 108.753 | 108.559 | -0.133 | -1.281 | +1.365 | 4 of 7 |
| user instructions, M | 1,235.184 | 1,235.084 | -0.101 | -0.101 | -0.101 | 7 of 7 |
| page faults | 5,469 | 5,469.5 | 0 | -1.5 | +1.5 | 3 of 7 |

All 56 objects are one object and the diagnostics one stream. The +25.2 ms round holds one wall run of 165.7 ms (the
candidate's, round 1, position 1), a run on base pages as in the stage table's seventh; the other 27 wall runs are
111.8 to 115.7 ms. On this host, with its 2 MB pages, the faults don't move (the 902 fewer of the pull request's
description are the 7940HS's); what the change saves here is the column's clearing, 1.3 user cycles a token in every
round, and the wall clock doesn't resolve it.

A load average of 4.1 at the first rounds is this session's own build of the candidate, just before (`*.load`); the
lock's `busy` lines, if any, are in `lock.log`.
