# The preprocessor's and parser's clang oracles through a clang server (buster#2071), 2026-11-11

These are the measurements behind the buster pull request that serves `test-preprocessor --clang`'s and
`test-parser --clang`'s oracle clang runs: the oracle cache's `OracleRun`s of `clang` go to `tools/clang-server`
(`--clang-server PATH`), and `--differential` runs each also as before and compares. It follows
`in-process-tests-general-2071-2026-11-10`, which served `test-checker-driver`'s. `trees.txt` names the sources, the
executables' hashes, the machine and the hosted runs.

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
Platinum 8370C), so a before/after comparison holds only between jobs on the same CPU model. The hosted rows have no
clang server yet (the official release's static LLVM, #2071's other task), so the after numbers wait for one.

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
- No hosted after numbers yet: the hosted rows build no server until the official release's static libraries can
  hold one copy of LLVM. Until then the inventory's `${BUSTER_CLANG_SERVER:+...}` leaves these commands as before.
- The container's clang is 23.1.6 (Ubuntu's, shared LLVM), not CI's official 23.1.4; the differential runs compare
  that clang with a server built against the same libraries.
- Reproducing: set `SCRATCH` to a scratch directory and `BUSTER` to the checkout, with the before executable at
  `build/base/compiler` and the after executable and server at `build/served2/`.
