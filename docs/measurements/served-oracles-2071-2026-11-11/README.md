# The preprocessor's and parser's clang oracles through a clang server (buster#2071), 2026-11-11

These are the measurements behind the buster pull request that serves `test-preprocessor --clang`'s and
`test-parser --clang`'s oracle clang runs: the oracle cache's `OracleRun`s of `clang` go to `tools/clang-server`
(`--clang-server PATH`), and `--differential` runs each also as before and compares. It follows
`in-process-tests-general-2071-2026-11-10`, which served `test-checker-driver`'s. `trees.txt` names the sources, the
executables' hashes, the machine and the hosted runs. The hosted results are pull request #2076's run 42937861448 at
`911ebc38f` (the branch merged with main after #2073, whose hosted rows build a static clang server), against seven
earlier runs without these suites served.

A served run doesn't enter the cache: the server isn't traced, so its result can't be an entry. In `check` mode, which
the hosted rows run, a served run is compared with the entry it would have taken and writes none; the hosted cache
starts empty in every job, so nothing it would have taken is lost.

## Before: hosted plain rows (`scripts/hosted-times.sh`, `results/hosted/`)

The parallel runner's report of each command ("passed in WALL s, CPU s of CPU") on the hosted plain rows of two recent
pushes to main, with each job's runner CPU. Each command runs on its shard's 4-CPU runner beside others, at 1 CPU.

| Command | Run 42924838447 (1fe4110) native | x86-64 | Run 42917279019 (d9f1135) native | x86-64 |
|---|---:|---:|---:|---:|
| preprocessor part 1 | 62.9 s (EPYC 9V74) | 79.7 s (EPYC 7763) | 62.3 s (EPYC 9V74) | 84.1 s (EPYC 7763) |
| preprocessor part 2 | 64.7 s (EPYC 9V45) | 58.7 s (EPYC 9V45) | 169.9 s (Xeon 8370C) | 93.7 s (EPYC 7763) |
| preprocessor part 3 | 190.3 s (EPYC 7763) | 113.4 s (EPYC 9V45) | 181.5 s (EPYC 7763) | 227.2 s (EPYC 9V74) |
| preprocessor part 4 | 57.5 s (EPYC 7763) | 35.6 s (EPYC 9V45) | 57.2 s (EPYC 7763) | 63.0 s (EPYC 9V74) |
| parser snippets | 237.5 s (EPYC 7763) | 156.0 s (EPYC 9V45) | 234.3 s (EPYC 7763) | 261.6 s (EPYC 9V74) |

The same command varies by up to 2.9 times between runner CPUs (part 2: 58.7 s on an EPYC 9V45, 169.9 s on a Xeon
Platinum 8370C), so a before/after comparison holds only between jobs on the same CPU model. Five more runs without
these suites served add to the befores (`results/hosted/before-*.tsv`): #2073's pull request run 42930784417, which
served test-checker-driver's runs alone, and the pushes to main 42928339578, 42934265950, 42935887552 and 42936084981.

## After: hosted plain rows, run 42937861448 (`scripts/hosted-served.sh`, `results/hosted/`)

Every one of the 8 plain shards' build steps printed the static server's smoke line ("clang 23.1.4, static link, smoke
request as a spawned clang: status 0, 181 bytes of warnings"). Every converted command served its clang runs: the
x86-64 row served them alone, and the native row, under `BUSTER_DRIVER_DIFFERENTIAL`, ran each both ways with
**0 differences**:

| Command | x86-64: served | native: run both ways, differ | Not served |
|---|---:|---:|---:|
| preprocessor part 1 | 1,488 | 1,488, 0 | 0 |
| preprocessor part 2 | 1,745 | 1,745, 0 | 0 |
| preprocessor part 3 | 961 | 961, 0 | 0 |
| preprocessor part 4 | 562 | 562, 0 | 0 |
| parser snippets | 543 | 543, 0 | 0 |
| parser `--files-only` | 1 | 1, 0 | 0 |

The commands' times, each paired with the befores on the same row and CPU model where there are any (all befores per
row and model: mean, and the runs' count):

| Command | Row | After | CPU | Before, same CPU | Change | Befores on other CPUs (row's) |
|---|---|---:|---|---:|---:|---|
| part 1 | x86-64 | 36.6 s | Xeon 8370C | none | | 84.0 s (7763, 5), 73.8 s (9V74, 2) |
| part 2 | x86-64 | 14.2 s | EPYC 9V45 | 58.7 s (1) | -76% | 97.4 s (7763, 4), 78.3 s (9V74, 2) |
| part 3 | x86-64 | 65.7 s | Xeon 8573C | none | | 117.2 s (9V45, 2), 197.6 s (7763, 4), 227.2 s (9V74, 1) |
| part 4 | x86-64 | 29.4 s | Xeon 8573C | none | | 38.9 s (9V45, 2), 56.0 s (7763, 4), 63.0 s (9V74, 1) |
| parser | x86-64 | 165.8 s | Xeon 8573C | none | | 159.6 s (9V45, 2), 236.2 s (7763, 4), 261.6 s (9V74, 1) |
| part 1 | native, both ways | 62.6 s | EPYC 9V45 | 55.1 s (1) | +14% | 63.4 s (9V74, 4), 82.5 s (7763, 2) |
| part 2 | native, both ways | 76.7 s | EPYC 9V74 | 68.7 s (3) | +12% | 64.7 s (9V45), 85.1 s (7763), 51.4 s (Xeon 6973P-C), 169.9 s (Xeon 8370C) |
| part 3 | native, both ways | 188.1 s | EPYC 7763 | 188.0 s (4) | 0% | 86.4 s (9V45, 1), 116.8 s (9V74, 2) |
| part 4 | native, both ways | 58.5 s | EPYC 7763 | 56.6 s (4) | +3% | 38.9 s (9V45, 1), 43.7 s (9V74, 2) |
| parser | native, both ways | 235.1 s | EPYC 7763 | 235.5 s (4) | 0% | 166.4 s (9V45, 1), 178.0 s (9V74, 2) |

- **Served, same CPU:** part 2 on the x86-64 row's EPYC 9V45 went from 58.7 s to 14.2 s (-76%), as on this container
  (-87%).
- **Served, other CPUs:** the x86-64 row's other commands ran on CPUs no before ran these suites on. Part 1 on a Xeon
  8370C took 36.6 s against 68.1 to 90.2 s on EPYC 9V74 and 7763 runners; the Xeon 8370C was the slowest model among
  the befores (part 2: 169.9 s against 51.4 to 101.9 s). Part 3 and part 4 on a Xeon 8573C took 65.7 s and 29.4 s
  against 113.4 s and 35.6 s at best (EPYC 9V45). The parser on the same Xeon 8573C took 165.8 s against 156.0 and
  163.2 s on EPYC 9V45: its own checks dominate, as on this container (-16%), so the parser says the Xeon 8573C runs
  these suites at about an EPYC 9V45's speed, which would make part 3 and part 4 about 44% and 24% faster. That is an
  inference across CPUs, not a measurement.
- **Both ways, same CPU:** the native row's differential costs 0 to 14% over the befores' children alone: a served
  run is a small addition to the traced child it is compared with.

test-checker-driver's commands, with the shared client (`OracleServer`), served on both rows and showed 0 differences
in all 12 of its run-mode lines (`results/hosted/served-42937861448.tsv`): 2,848, 4,944, 4,237 and 3,703 served runs
in parts 1 to 4 (3,701 in part 4 on the native row), 124 for `--sign-compare-only` and 62 for `--lazy-system-headers`,
both ways on the native row.
`test-oracle-cache` passed on both rows (209 checks: the runners aren't root, so the check of an owner's change,
which takes root's chown, is left out of this container's 210). `results/hosted/excerpts-42937861448/` holds each shard's raw lines: its CPU, the server's smoke line,
the commands' reports and their cache, server and run-mode lines.

## Equivalence (`scripts/differential.sh`, `results/differential/`)

Every converted command ran with `--clang-server --differential` in `check` mode with an empty cache, at 1 CPU: each
served run also ran as before (traced and kept) and the two were compared byte for byte, status and both streams.

| Command | Runs both ways | Differ | Not served |
|---|---:|---:|---:|
| preprocessor part 1 | 1,488 | 0 | 0 |
| preprocessor part 2 | 1,745 | 0 | 0 |
| preprocessor part 3 | 961 | 0 | 0 |
| preprocessor part 4 | 562 | 0 | 0 |
| parser snippets | 543 | 0 | 0 |
| parser `--files-only` (pragma-heavy.c) | 1 | 0 | 0 |
| preprocessor on the repository's units | 88 | 0 | 0 |

Two earlier passes found a difference each, and a probe outside the suites a third; the pull request's server and
client changes handle them:

- `clang -dM -E -ffreestanding -gmodules -g0 -x c -` aborted the server: its cc1 job lacked the object-file module
  container that `cc1_main` registers (`-gmodules`' "obj" format, a fatal error without it).
- The server gave the driver argument 0's PATH path rather than the real path clang's main gives it: through
  `/usr/local/bin/clang`, a link to `/usr/lib/llvm-23/bin/clang`, its resource directory was
  `/usr/local/lib/clang/23` (`-print-resource-dir`), which a probe outside the suites showed.
- `clang -fproc-stat-report -E` reports its process's time and memory, which differ between any two runs (12.9 ms
  against 12.3 ms); the client doesn't serve it, nor `-ftime-report` and `-ftime-trace`.

Part 2 and the repository's units fail on this container with main's executable too: its clang is Ubuntu's 23.1.6, not
CI's 23.1.4 (line markers' places, and 45 of 66 units). Their failures are the same with the served executable:
`pp-units-main.log` and `pp-units.log` are the same but for the cache's and server's lines, and part 2's 82 failure
lines, sorted, are the same in `timing/pp-part2-base-1.log`, `timing/pp-part2-served-1.log` and
`differential/pp-part2.log`.

`test-checker-driver`'s client is now the oracle cache's `OracleServer`; with it, `--sign-compare-only`,
`--lazy-system-headers` and `--part 1/4` ran with `--in-process --clang-server --differential`: 124, 62 and 2,809
served runs, 0 differences, 0 failures (`results/checker-driver/`). `test-oracle-cache` (`results/oracle-cache/`): 210
checks, 0 failures, among them the served path's with a server of the test's own.

## Timing on this container (`scripts/timing.sh`, `results/timing/`)

Each command with main's executable (oracle clang as traced children) and with the branch's (served), interleaved, two
rounds, `check` mode with an empty cache each, `BUSTER_PARALLEL_CPUS=1` and `--jobs 1` as CI's parts have. Wall seconds;
`times.txt` has the user and system times and the load averages.

| Command | Main, rounds 1 and 2 | Served, rounds 1 and 2 | Change | Served runs |
|---|---:|---:|---:|---:|
| preprocessor part 1 | 47.1, 44.8 | 14.8, 14.6 | -68% | 1,488 |
| preprocessor part 2 | 66.9, 62.1 | 7.9, 8.3 | -87% | 1,745 (1 run: `-fproc-stat-report`) |
| preprocessor part 3 | 46.3, 45.9 | 26.6, 26.3 | -43% | 961 |
| preprocessor part 4 | 32.8, 32.6 | 21.7, 22.0 | -33% | 562 (17 runs: another tool) |
| parser snippets | 71.4, 70.9 | 60.9, 59.3 | -16% | 543 |
| sum | 260.4 (mean) | 131.2 (mean) | -50% | |

What stays: part 3's own checks (the windows and the determinism lanes, about 13 s), part 4's fuzz batches, whose
clang processes (64 cases each, `preprocessor_fuzz_clang.c`) don't go through the cache, and the 17 runs of
`pp_test_builtin_release`'s wrapper script, another tool; the parser's own checks (its 34,624 alignment inputs above
all): without `--clang`, main's `test-parser` took 63.1 s here against 68.7 s with it, the cache off.

The user and system times count a served run's server only where the test's own process started it: a forked part's
server, which the part leaves to end at the end of its input, is reparented and not reaped by the test, so its time is
in no total. Wall time is the comparison.

## Limitations

- One container, shared with other agents' work; the interleaved rounds agree within 4%.
- One hosted after run: its x86-64 row served the commands alone, on CPUs that match a before only for part 2; its
  native row ran them both ways, which measures the differential's cost, not serving's gain.
- The repository's units command (`test-preprocessor --clang` on main.c and the benchmarks, 2 CPUs) isn't converted:
  its 133 runs on the hosted rows still run as children.
- The container's clang is 23.1.6 (Ubuntu's, shared LLVM), not CI's official 23.1.4; the differential runs compare
  that clang with a server built against the same libraries.
- Reproducing: set `SCRATCH` to a scratch directory and `BUSTER` to the checkout, with the before executable at
  `build/base/compiler` and the after executable and server at `build/served2/`.
