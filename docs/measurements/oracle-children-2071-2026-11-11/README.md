# test-preprocessor's own clang children and forked parts' servers (buster#2071), 2026-11-11

These are the local measurements behind buster's branch `claude/oracle-children-2071` (118111fd8), which does the two
follow-ups that [buster#2071's #2081 comment](https://github.com/buster14a/buster/issues/2071#issuecomment-6792678236)
left:

- **Forked parts' servers:** a part that `test-preprocessor` forks (`test_process_start`) starts a clang server of its
  own. Nothing stopped it when the part ended: it ended later, at its socket's end, an orphan outside the command's
  processes, so the runner's CPU time (`wait4`'s rusage) missed its work. `test_process_exit` now stops it, killed and
  waited for (`oracle_serve_exit`).
- **The checks' own clang children:** the history's and system warnings' diagnostics and the directives' commands
  started clang themselves, outside the cache and the server. They now go through `oracle_serve_child`: served where
  the server takes the run, else a child of the same contract, both ways under `--differential`.
- **Two findings on the way:**
  - LLVM's statistics (`-Xclang -print-stats`, which the guard counts read) are the process's counters, so a server's
    runs add them up. `oracle_server_fits` now refuses them, and the guard counts stay children
    (`results/print-stats/`).
  - A forked part whose parent had served nothing ran `clang -dumpversion` for its own release check: 33 of part 3's
    45 clang processes. `oracle_serve` now finds the release once, before the test forks.

`trees.txt` names the sources, the executables' hashes and the machine. Hosted results are not here: the pull request's
runs give the afters, and `results/hosted/` holds the befores (below).

## What starts clang (`scripts/children.sh`, `scripts/classify.py`, `results/children/`)

`strace -f` of each part with the server, check mode, 1 CPU. `classify.py` sorts the clang processes by their arguments
and by the program that started them:

| Part | Before | After | Served before → after |
|---|---:|---:|---:|
| 1 | 224 | **74** | 1,488 → 1,641 |
| 2 | 97 | 97 | 1,754 → 1,754 |
| 3 | 45 | **13** | 961 → 961 |
| 4 | 63 | **38** | 1,428 → 1,453 |
| all | 429 | **222** | 5,631 → 5,809 |

Now served (178 runs):
- part 1: the directives' diagnostics (82, `-E ... -o /dev/null`), the history's diagnostics (51), and the guards' text
  (20, `-E -P`);
- part 4: the system warnings' diagnostics (20) and the history's (5).

No longer run: 32 of part 3's 33 `clang -dumpversion` release checks, one per forked part.

Still children (222):
- **Guard counts, 142** (41, 90 and 11 in parts 1 to 3): `-E -o /dev/null -Xclang -print-stats` reads HeaderSearch's
  "#includes skipped due to the multi-include optimization". It is a process-wide LLVM statistic, which a server's
  runs add up: three requests for one file gave 1, 2 and 3 (`results/print-stats/served-vs-spawned.txt`, made with
  `scripts/serve_once.py` and `scripts/guard.c`, `g.h`). `llvm::ResetStatistics` would not undo it: a statistic first
  incremented while statistics are off is never registered, and so is never reset. They don't fit the server now.
- **The location option's nested runs, 30** (part 1): `/proc/self/exe` commands of the test's own executable, whose
  clang runs are theirs. They include `benchmark-preprocessor --clang`'s 21 `-E -P -o` runs, which write files.
- **A run that writes a file, 1** (part 1): `pp_test_clang_command`'s `-E -P -o` with 300 `-D` options.
- **Through other programs, 39:**
  - the release fixture's wrapper script (part 4): 18, and 18 more that its fake clang starts;
  - the predefines' shell commands (part 2): 3 through `sh` and `env`, with both streams in one pipe.
- **Runs that don't fit, 2** (part 2): a `-fproc-stat-report` run and the cache's epoch probe (`-E -P -x c -`).
- **One per part, 8:** `clang --version` (the reference report, both streams in one pipe) and the client's
  `clang -dumpversion`.

Part 1's guard counts are 38 before and 41 after, with the same checks: a few `execve` lines that strace split around
other processes' calls fall outside a classification. The counts are within a few runs.

## Equivalence (`scripts/differential.sh`, `results/differential/`, `results/tests/`)

`--differential` with an empty check-mode cache, at the inventory's CPUs (1, 2 for the units):

| Command | Run both ways | Differ | Not served | Exit |
|---|---:|---:|---:|---:|
| part 1 | 1,641 | **0** | 0 | 0 |
| part 2 | 1,754 | **0** | 0 | 1 |
| part 3 | 961 | **0** | 0 | 0 |
| part 4 | 1,453 | **0** | 0 | 0 |
| the repository's units, `-march=native` | 88 | **0** | 0 | 1 |
| the repository's units, `-march=x86-64` | 88 | **0** | 0 | 1 |

- **Part 2 fails on this container** with or without this change: 41 option sets whose line markers place token 0
  differently from Ubuntu's clang 23.1.6 (`results/children/before-part2.log` has the same 41).
- **The units fail on this container** as in served-oracles-remaining-2071-2026-11-11: buster spells the distribution
  clang's resource directory differently, 45 of 66 units differ, and 88 of the 133 runs are made.
- `test-oracle-cache`: 216 checks, 0 failures (213 before). The new checks:
  - served children: each stream, `/dev/null` input and the run's environment; another tool's run as a child; a
    server that ends in a run; `--differential` with a difference on purpose;
  - LLVM's statistics options, not served;
  - a forked child's server, gone (`ESRCH`) after `oracle_serve_exit`;
  - the release found before any run.
- `./build.sh check-call-graph`: 0 cycles, 3 allowed, 0 split variables.

## CPU accounting (`scripts/accounting.sh`, `scripts/reap.c`, `results/accounting/`)

Each command once per side, under `reap`, a child subreaper. It prints the command's CPU time as its wait gives it,
which is what the parallel runner counts, and then the CPU time with the orphans it adopted and waited for:

| Command | Side | Wall | Runner's CPU | With orphans | Orphans |
|---|---|---:|---:|---:|---:|
| part 1 | before | 24.54 s | 16.52 s | 23.97 s | 36 |
| part 1 | after | 19.44 s | 18.80 s | 18.80 s | 0 |
| part 2 | before | 11.98 s | 11.48 s | 11.48 s | 0 |
| part 2 | after | 12.02 s | 11.63 s | 11.63 s | 0 |
| part 3 | before | 27.27 s | 24.15 s | 26.04 s | 32 |
| part 3 | after | 28.41 s | 27.14 s | 27.14 s | 0 |
| part 4 | before | 17.34 s | 16.29 s | 16.29 s | 0 |
| part 4 | after | 16.07 s | 15.10 s | 15.10 s | 0 |
| units, 2 CPUs | before | 15.61 s | 15.32 s | 20.31 s | 64 |
| units, 2 CPUs | after | 15.71 s | 20.41 s | 20.41 s | 0 |

- **Before, the runner missed 31% of part 1's CPU time (7.45 s), 7% of part 3's and 25% of the units'.** Those are the
  orphaned servers: 36, 32 and 64 of them.
- **After, there are no orphans**, and the runner's CPU time is the whole. Hosted "s of CPU" for parts 1 and 3 and the
  units will therefore rise where the work didn't change.
- **Walls are single runs** on a container shared with three other agents' builds, so they are indications only:
  - part 1 -21% (153 runs served instead of started);
  - part 4 -7% (25 served);
  - part 3 +4%, within noise.

## Hosted befores (`scripts/hosted-times.sh`, `scripts/pairs.sh`, `results/hosted/`)

`hosted-times.sh` is #386's, unchanged. It was run over the 32 successful pushes to main from 43006441307 to
43022202365 (`before-runs.txt`), with the converted commands' wall and CPU times. `befores-by-cpu.txt` gives their means
by command, row and CPU model.

To pair the pull request's runs, run `hosted-times.sh RUN DIRECTORY > results/hosted/after-RUN.tsv` over each run's
unzipped logs, then `pairs.sh results/hosted`.

## Hosted afters (`results/hosted/after-43076616781.tsv`, `results/hosted/pairs.txt`)

The pull request's run 43076616781 (buster head `f855d736`, which also merges main up to 6f8f41b9, so it includes
#2263's server time limits that the befores don't) is the after. Its logs were each shard job's log, saved under the
archive's names. A pull request's run has only the x86-64 row, so this is one sample per command, on two CPU models.
The native plain row, which runs these commands both ways, runs on main pushes only; its `differential … 0 differ`
check comes from the first push to main after the merge.

| command | CPU | runs served, before → after | wall, after (befores: mean, range, count) | wall | CPU s, after (before mean) | CPU |
| --- | --- | --- | --- | --- | --- | --- |
| part 1 | EPYC 7763 | 1488 → 1641 (+153) | 34.3 s (35.8, 34.9–37.1, 15) | -4.1% | 29.6 (25.0) | +18.6% |
| part 2 | EPYC 7763 | 1754 → 1756 (+2) | 22.6 s (21.3, 20.4–22.5, 15) | +6.0% | 18.8 (19.1) | -1.8% |
| part 3 | EPYC 7763 | 961 → 961 | 105.3 s (93.5, 88.1–105.5, 15) | +12.6% | 102.4 (90.4) | +13.3% |
| part 4 | EPYC 9V74 | 1475 → 1500 (+25) | 18.1 s (18.9, 16.8–21.4, 9) | -4.5% | 17.7 (17.0) | +3.9% |
| units, 2 CPUs | EPYC 9V74 | 133 → 133 | 41.2 s (38.6, 36.8–40.2, 8) | +6.8% | 51.3 (43.4) | +18.1% |

- **Served counts** rose by 153 in part 1 and 25 in part 4, as the local measurement predicted. Part 2's +2 is main's
  (its befores range over 1749 and 1754 with main's cases).
- **"s of CPU"** rose for parts 1 and 3 and the units, as predicted: the servers' CPU time is now counted.
- **Wall** fell slightly for parts 1 and 4. It rose for part 3 (at the top of its befores' range) and the units (1.0 s
  above it). With one sample each, these are indications, not effects.
- **No request ran past its time limit** (#2263's new count): 0 in every command.
