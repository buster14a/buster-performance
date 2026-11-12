# What Tier 1 costs a compile, and where the stage 1 build's time goes (2026-11-12)

Two measurements taken to size candidate work, not to qualify a change: what `--tier1` adds to a compile of the
frozen `sqlite3.c`, and how the build of the compiler by clang (the stage 1 build) spends its time. They follow
[the one-core record](../one-core-design-672-2026-11-12/) of the same day and use its tree on the host.

- **Source:** buster `d96b2e731e42a4a4740fa78e494578f90eaff5a5`, the one-core record's clone, built by `./build.sh`
  (Release). The tree carries that record's `inventory-dump.patch`, which touches `measure-lowering-templates` alone:
  the executable's SHA-256 is `adb46192…` (`raw/tier1cost/identity.txt`), not the unpatched build's `7c5d15c6…`.
- **Host:** the Ryzen 7 9700X (`benchpress`), clang 23.1.1. Every run was one hold of the lock (`scripts/lock.sh`;
  each wrote the lock's line, `raw/*/*holder.txt`), pinned to CPU 2.

## 1. What `--tier1` costs a compile

`scripts/tier1cost.sh`: `measure-compile --runs 7 --variant --tier1` on `-c sqlite3.c` with the 9700X job's options
(`raw/tier1cost/measure-compile.txt`), then one `--tier1 --tier1-report` compile (`raw/tier1cost/tier1-report.txt`).

| | wall, ms | user cycles | user instructions | peak |
| --- | ---: | ---: | ---: | ---: |
| default (Tier 0) | 123.599 (122.768 to 124.181) | 594.0 M | 1,338.8 M | 236.4 MB |
| `--tier1` | 424.718 (423.486 to 425.107) | 2,250.2 M | 5,256.6 M | 298.5 MB |

3.44 times the time and 3.93 times the instructions. Every one of the 2,668 functions is Tier 1's (`compiled=2668`,
no refusal, no fallback), in 271,136 records. So the tier's own pipeline adds 301.1 ms, 1,656 M user cycles and
3,918 M instructions to a compile whose front end is the same: 2.8 times a whole default compile's cycles.

## 2. The stage 1 build

**The whole build** (`tables/build-edges.txt`, by `scripts/tools/ninja_edges.py` from ninja's own log,
`raw/buildcost/ninja_log.txt`). The clean build of this tree that morning took 83.0 s for 43 units, and an edit of
one file of the checker's unit 72.1 s (the one-core record's `raw/build.log` and `raw/sweeps/dump-build.log`). The
log holds each output's last run, so the checker's unit's row is the rebuild's and the others' the clean build's:

| 69 edges | time |
| --- | ---: |
| the ten unity units, front end and `-O3` to bitcode | 233.5 s |
| their backend parts (the checker's and the backend's bitcode, split, one job a part) | 115.8 s |
| 33 other objects: `main.c` and the benchmark and tool objects | 160.2 s |
| the split tool, the link and the bake | 2.0 s |
| all | 511.5 s |

On the build's eight jobs that work is at least 64 s, so a clean build is bound by its total work as well as by its
longest chain. The longest edges: `main_unit_checker.c` 56.4 s (then its backend parts, at most 10.4 s each, at
once), `main_unit_backend.c` 44.6 s, `main_unit_frontend.c` 38.1 s, `main_unit_executable.c` 23.0 s,
`c_parser_benchmark.c` 17.7 s, `tier1_select_benchmark.c` 17.0 s, `main.c` 15.0 s.

**The longest edge, by clang's own trace** (`scripts/buildcost.sh trace`: the build's command for
`main_unit_checker.c` with `-ftime-trace`, written to scratch; `raw/buildcost/checker-trace.json.gz`,
`tables/checker-trace-summary.txt`). 57.6 s:

| | time |
| --- | ---: |
| the front end (parsing 3.1 s, IR generation 2.9 s) | 6.6 s |
| LLVM's optimizer | 50.9 s |
| … the inliner's pipeline over the call graph (each function's simplification as it is visited) | 31.5 s |
| … the function passes run outside the inliner's pipeline | 12.5 s |
| … writing the bitcode | 2.7 s |

By pass, over the whole pipeline: InstCombine 9.2 s, the loop passes 7.8 s, GVN 4.6 s, the inliner itself 3.2 s,
JumpThreading 2.4 s, SimplifyCFG 2.4 s, SLP 2.0 s. The unit has 9,899 functions.

**The same compile at other settings** (`scripts/buildcost.sh nodebug`, `o2`, `o1`, `o0`; one run each,
`raw/buildcost/*.time.txt`):

| the checker's unit to bitcode | wall |
| --- | ---: |
| `-g -O3`, the build's (with the trace) | 57.6 s |
| `-O3` without `-g` | 50.1 s |
| `-g -O2` | 52.2 s |
| `-g -O1` | 36.1 s |
| `-g -O0` | 7.4 s |

**What the units read** (`tables/unit-lines.tsv`, by `scripts/tools/unit_lines.py`: clang's `-MM` with the build's
definitions, whole files counted; it is not a timing and ran off the host, on a checkout of the same revision):

| unit | lines | of them in test files |
| --- | ---: | ---: |
| checker | 686,811 | 219,306 (31.9%) |
| backend | 446,088 | 155,446 (34.8%) |
| frontend | 236,227 | 58,133 (24.6%) |
| executable | 223,760 | 71,259 (31.8%) |
| the other six | 179,581 to 209,282 each | 19.4% to 25.5% |
| the ten together | 2,730,091 | 752,909 |
| `src/buster/compiler`, each file once | 980,356 | 422,044 (43.1%) |

Each unit reaches at least 142,148 lines that aren't tests, benchmarks or headers: the files every unit includes.

## Limits

- **One run a figure in section 2**, on one day; the trace adds its own overhead to the 57.6 s (ninja's row for the
  same command is 56.4 s).
- **Lines are not compile time.** `unit_lines.py` counts whole files a unit reaches; what a unit compiles after its
  own conditionals is at most that, and how the optimizer's 50.9 s divides between test and product functions
  wasn't measured (the trace's granularity kept no per-function rows).
- **Section 1 is `sqlite3.c` alone**, one lane, and says nothing of where in Tier 1's pipeline the time goes.
- The measured executable is the patched build described above; the compile path's source is main's.

## Files

- `scripts/`: `lock.sh` (the hold), `tier1cost.sh`, `buildcost.sh`; `scripts/tools/` the reducers.
  `raw/buildcost/scripts-hashes.txt` has the hashes of the scripts as they ran.
- `raw/`: every run's output as written. `tables/`: the reductions.
