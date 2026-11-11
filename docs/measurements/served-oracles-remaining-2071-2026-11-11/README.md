# The remaining preprocessor oracle runs through a clang server (buster#2071), 2026-11-11

These are the measurements behind buster pull request #2081. It follows `served-oracles-2071-2026-11-11` (buster#2076),
which sent the oracle cache's clang runs of `test-preprocessor --clang` and `test-parser --clang` to
`tools/clang-server`. This step serves what #2076 left as children:

- **The repository's units:** the inventory line that runs `test-preprocessor --clang` on `main.c` and the
  `*_benchmark.c` units gets `--clang-server`, and `--differential` under `BUSTER_DRIVER_DIFFERENTIAL`.
- **Part 4's fuzz batches:** they start clang themselves (`preprocessor_fuzz_clang_process`), outside the cache. They now
  go through the same client, with their 30 s limit kept by the client.

The 17 runs through the library-builtin release fixture's wrapper script stay children (the pull request says why).
`trees.txt` names the sources, the executables' hashes, the machine and the hosted runs.

## Equivalence

### Hosted (`scripts/hosted-times.sh`, `scripts/hosted-excerpts.sh`, `results/hosted/`)

Both runs of the pull request passed. Each converted command served every run that fits on the x86-64 row. On the
native row, under `BUSTER_DRIVER_DIFFERENTIAL`, each also ran as a child, with **0 differences**:

| Run | Command | x86-64: served | native: run both ways, differ | Not served |
|---|---|---:|---:|---:|
| 42993144864 | preprocessor part 4 | 1,475 | 1,475, 0 | 0 |
| 42993144864 | the repository's units | 133 | 133, 0 | 0 |
| 42996041112 | preprocessor part 4 | 1,475 | 1,475, 0 | 0 |
| 42996041112 | the repository's units | 133 | 133, 0 | 0 |

- **Part 4:** 562 of its runs were #2076's cache runs, so the fuzz batches gave 913 runs on CI's official clang 23.1.4.
- **The release fixture's runs:** part 4's oracle cache line still shows "17 run". These are the runs through the
  fixture's wrapper script, which stay children.
- **The other commands:** parts 1 to 3 and the parser served as with #2076, with 0 differences on the native row. Their
  lines are in the excerpts.

### Local (`results/differential/`)

`--differential` in check mode with an empty cache, at 1 CPU:

| Command | Runs both ways | Differ | Not served |
|---|---:|---:|---:|
| preprocessor part 4 | 1,428 (562 + 866 fuzz) | 0 | 0 |
| the repository's units, `-march=native` | 88 | 0 | 0 |
| the repository's units, `-march=x86-64` | 88 | 0 | 0 |
| `test-checker-driver --sign-compare-only` (the changed `oracle_server_run`) | 124 | 0 | 0 |

- **The fuzz lines are the same** as without the server: 1,500 cases per mode, 628 and 631 accepted, 64 read alone, 30
  and 41 confirmed by clang's tokens, 0 differ (`part4.log`).
- **The units fail on this container** with or without the server, as #2076's record found. Its clang is Ubuntu's
  23.1.6, whose resource directory `/usr/lib/llvm-23/lib/clang/23` buster spells `/usr/lib/clang/23`: 45 of 66 units
  differ, and the command makes 88 of its 133 runs. `units-x86-64-before-no-server.log` (#2076's executable, no
  server) and `units-x86-64.log` are the same but for the cache's and server's lines.
- **Tests:** `test-oracle-cache` gave 213 checks, 0 failures. Among them are the new API's: a served run, a server past
  the run's limit stopped and replaced, and `--differential`'s counting. `test-preprocessor-fuzz` gave 1,486 checks and
  0 failures per mode (`results/tests/`).

## Speed

### Hosted (`scripts/pairs.sh`, `results/hosted/pairs.txt`)

The parallel runner's report of each command ("passed in WALL s, CPU s of CPU"), on each run's 4-CPU runner, beside
the inventory's other commands.

**Befores:** nine runs where #2076's runs were served and these weren't:
- #2076's three pull request runs;
- the six pushes to main since #2076's merge.

**Pairing:** befores are means per command, row and CPU model. Shard placement is stable: part 4 runs on shard 3 and
the units on shard 4.

| Command | Row | After | CPU | Before, same CPU (runs) | Wall change | CPU-time change |
|---|---|---:|---|---:|---:|---:|
| part 4 | x86-64, served | 22.9 s | EPYC 9V45 | 29.1 s (2: 26.3, 32.0) | **-21%** | -30% |
| part 4 | x86-64, served | 28.4 s | Xeon 8370C | none | | |
| units | x86-64, served | 19.3 s | EPYC 9V45 | 21.6 s (3: 20.4 to 23.7) | **-11%** | (-21%) |
| units | x86-64, served | 29.8 s | Xeon 8370C | 31.8 s (1) | **-6%** | (-16%) |
| part 4 | native, both ways | 63.7 s | EPYC 7763 | 59.1 s (6: 56.3 to 61.4) | +8% | +9% |
| part 4 | native, both ways | 66.0 s | EPYC 7763 | 59.1 s (6) | +12% | +11% |
| units | native, both ways | 29.9 s | EPYC 7763 | 27.2 s (9: 26.5 to 27.8) | +10% | (-1%) |
| units | native, both ways | 35.4 s | EPYC 9V74 | none | | |

- **Served:** part 4 on the x86-64 row's EPYC 9V45 went from 29.1 s to 22.9 s. Its CPU time went from 25.1 s to 17.7 s.
  The units went from 21.6 s to 19.3 s on an EPYC 9V45 and from 31.8 s to 29.8 s on a Xeon 8370C.
- **The unpaired Xeon 8370C part 4** (28.4 s) is faster than every x86-64 before but the EPYC 9V45's, though the
  8370C was the slowest model among #2076's befores. That is an inference across CPUs, not a measurement.
- **Smaller than on this container:** CI's clang is the official release, linked statically, so a child's start costs
  less than this container's clang, which loads the shared `libLLVM` and `libclang-cpp`. Serving saves less per run
  there.
- **Both ways:** the native row's differential now also runs each fuzz and unit run through the server, which costs
  8–12% over the befores' children alone on the EPYC 7763.
- **The units' CPU times** (in parentheses) leave out work. The command forks a part per range of files, and each part
  starts its own server, which outlives the part (`test_process_exit` doesn't stop it). The parallel runner, not a
  subreaper, never waits for those servers, so their clang work isn't in its CPU time. The units' wall times are the
  measure. Part 4 forks no parts; its server is stopped and waited for in the command (`oracle_serve_end`), so its CPU
  times are whole.

### Local (`scripts/timing.sh`, `results/timing/`)

Three interleaved rounds: #2076's executable against this step's, each run with an empty check-mode cache. Part 4 is
pinned to 1 CPU and the units to 2, as the inventory gives them:

| Command | Before | After | Change |
|---|---:|---:|---:|
| part 4 | 22.81 s (22.58, 22.10, 23.75) | 10.80 s (11.15, 10.26, 11.00) | **-53%** |
| the repository's units, `x86-64` | 10.99 s (11.12, 11.56, 10.28) | 9.53 s (9.70, 9.22, 9.66) | -13% |

The units make 88 of their 133 runs here (see above).

## What still starts clang (`scripts/children.sh`, `results/children/`)

`strace -f` of each part with the server, on this container. It used an executable of this step's source before a
comment-only reflow.

- **Part 4:** 45 clang processes. With #2076's executable it started 911: these plus the 866 fuzz runs.
  - **The wrapper:** 18 of them come through the wrapper's 19 starts. The 19th is a `--version`, which the script
    answers itself.
  - **The rest:** 25 come from checks that start clang themselves, the history's and system warnings' diagnostics.
    The other two are the reference report's `clang --version` and the client's `clang -dumpversion` release check.
- **Parts 1 to 3:** 227, 97 and 45 clang processes; part 2 also starts a `-cc1` child of one of them. They come from
  checks that start clang outside the cache:
  - the diagnostics checks;
  - the directive tables' commands;
  - the predefines' shell commands;
  - `-E -o` runs, which write files and so don't fit the server.
