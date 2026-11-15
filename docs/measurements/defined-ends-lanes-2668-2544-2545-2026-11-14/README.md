# #2668, #2544, #2545: `defined`'s snprintf, -g's statement ends, lanes short of a CPU

The 9700X, 2026-11-14/15, Linux 6.18.50, under the lock. `base` is buster14a/buster main `2ebfe68a`; `head` is the
same with `scripts/head.patch`, the pull request's diff (`env.txt` has both commits and the diff's SHA-256). Both are
Release builds (`./build.sh --config Release`).

- **#2668**: `pp_number_token` spelled every numeric token with `snprintf("%lu")`, including the 0 and 1 of every
  `defined` in a `#if`. 0 and 1 now use their ready-made spellings; other values a direct decimal conversion.
- **#2544**: `-g` derived the whole unit's statement ends again (`check_program_statement_ends`), file scope included.
  `check_debug_body_ends` derives a body's ends at its first lexical block, once for both DWARF passes.
- **#2545**: a lane whose wait runs out its 1 ms `mwaitx` budget while the machine has more runnable threads than the
  process's CPUs (`/proc/loadavg`) sleeps at once for its next waits, with an exponential backoff; and the driver's mixed
  link takes the lanes its objects pay for (`foreign_driver_lanes`), as `link-foreign` does, where it took every lane.

## How

`scripts/` holds everything; `lock.sh` takes the lock per run. `prepare.sh` builds the tools, the 1,336-unit musl list
(the whole-build record's selection) and the shell's objects (`shell.o`, `sq.o`, by base's compiler) that the link lines
link. `lists.sh` writes `lists/ab.list` and `lists/busy.list`; `run.sh` runs a list with `tools/procbench` (rotated
rounds, one warm-up per line, each run's counters split by privilege), `busy` adding `tools/spin` on CPU 7.
`profile.sh` samples musl's command's user instructions with `perf record` per tree.

Inputs and options are the whole-build record's (`docs/measurements/whole-build-672-2026-11-12`).

## 1. musl's 1,336 units and sqlite3.c, CPU 2 (`results/ab`)

11 rounds in two holds (6 and 5). Medians:

| line | wall ms base | head | user instructions M base | head | user cycles M base | head |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| musl `-c --lanes 1` | 693.9 | **677.5** (−2.4%) | 7,177.4 | **6,794.4** (−383.0) | 2,897.0 | 2,807.9 (−3.1%) |
| musl `-c -g --lanes 1` | 722.9 | **700.7** (−3.1%) | 7,294.4 | **6,904.4** (−390.0) | 3,080.0 | 2,959.5 (−3.9%) |
| sqlite3.c `-c` | 123.2 | 123.3 | 1,362.8 | 1,361.9 | 597.3 | 597.5 |
| sqlite3.c `-c -g` | 158.6 | **156.4** (−1.4%) | 1,767.3 | 1,770.3 (+3.0) | 787.0 | 775.2 (−1.5%) |

- musl's command retires 383 M fewer user instructions (the issue's ~300 M, and more: `__snprintf` and `__vsnprintf`'s
  own frames come off too).
- What `-g` adds to musl's command, in user cycles: 183 M at base, 152 M at head (−17%). In sqlite3.c's compile, whose
  tokens are mostly in bodies, the per-body derivation retires 3 M more instructions (a `memset` and two passes per body
  with a block, where one pass covered the unit) but 11.8 M fewer cycles: the per-body queue stays in cache.

## 2. Profiles (`results/profile`)

`perf record -e instructions:u -c 200003`, musl's command per tree, symbols by share of user instructions
(`*-grep.txt` for the functions in question):

| | base `-c` | head `-c` | base `-c -g` | head `-c -g` |
| --- | ---: | ---: | ---: | ---: |
| glibc's printf functions | 4.72% | 0.08% | 3.88% | 0.08% |
| `check_program_statement_ends` | — | — | 1.14% | — |

The printf left (0.08%) comes from other callers; #2668's callgrind table had the predefines' text (10 calls a unit) as
the largest, a smaller, separate saving not taken here. `check_debug_body_ends` doesn't appear above the report's precision.

## 3. Lanes short of a CPU (`results/busy`, `results/busy-busy`)

CPUs 1 to 7, seven cores (the session's seven lanes); `busy-busy` with `tools/spin` computing on CPU 7 all the while.
11 rounds each, one hold each, one warm-up per line. Median wall ms (user ms):

| line | free base | free head | busy base | busy head |
| --- | ---: | ---: | ---: | ---: |
| driver link, dynamic (`shell.o sq.o -lm`) | 2.14 (9.6) | 1.98 (3.2) | 62.73 (343.5) | **2.04** (3.4) |
| driver link, static | 4.02 (21.3) | 3.60 (6.6) | 128.40 (689.1) | **3.65** (3.3) |
| `link-foreign --lanes 7`, dynamic | 2.00 (10.6) | 2.01 (10.6) | 62.75 (342.7) | **21.17** (74.1) |
| the shell from sources, dynamic | 146.9 | 147.6 | 180.4 | **166.9** |
| the shell from sources, static | 149.9 | 150.4 | 274.3 | **152.7** |
| the same, `--lanes 1` | 193.3 | 194.0 | 196.4 | 196.2 |

- The driver's link with a CPU short takes what it does with every lane a CPU (2.04 against 1.98 ms), as #2545 asked:
  it now takes the lanes its objects pay for, here as `link-foreign` sizes it.
- The static build from sources is no longer slower on seven lanes than on one (152.7 against 196.2 ms; it was 274.3).
- `link-foreign --lanes 7`, which forces the lanes, is where the wait alone shows: 62.7 to 21.2 ms. Each try of `mwaitx`
  after the backoff still costs its 1 ms budget, and a link of 2 ms has only some tens of syncs to spread them over.
- With every lane a CPU nothing got slower: the wait's check (`/proc/loadavg`) runs only after a wait has spent its
  whole millisecond.

## Correctness

Local (cloud container, Develop build): `test-lanes`, `test-check-debug --cross-check`, `test-checker-driver --executable
build/compiler` (all four parts), `test-preprocessor --tables src`, `test-preprocessor-fuzz --std c17`, `test-parallel`:
no failures. For #2544, a temporary check compared the per-body ends with the whole unit's derivation on every body with
a block: 336,096 tokens of `src/buster/compiler/main.c -g` and all 220 c-testsuite programs, 0 differences.
