# Attested declarations in the compile: steps 1 and 2 of buster#2531 (2026-11-13)

[buster#2531](https://github.com/buster14a/buster/issues/2531)'s design (`docs/attested-declarations.md` in buster)
skips the reading of a file-scope declaration that an earlier unit of the same command read silently and purely, and
that nothing of the unit reaches by name. Step 0, the census, is
[`attested-census-2531-2026-11-12`](../attested-census-2531-2026-11-12/). Steps 1 and 2 put its passes in the compile
(buster#2620, `--attested`): each units lane of a command of several source files keeps a memo, and before each unit's
reader the passes decide what its walk passes. `--attested=on` (the default) skips; `--attested=verify` reads everything
and fails a unit where a hit's reading isn't what the memo attests (step 1's shadow); `--attested=off` runs no passes.
The gates, as the design states them:

1. **Step 1:** no failure of `--attested=verify` on the corpora as many-unit commands, with `-g` and with `-Wall -Wextra`,
   on 1 and 8 lanes, with the bodies deferred.
2. **Step 2:** musl's command on one lane at least 1.15 times faster and the glibc units at least 1.4, neither slower on
   8 lanes; every unit's object and diagnostics its own alone and `--scalar`'s; `-c sqlite3.c` and a small unit's
   process within the A/A floor.

- **Source:** base is buster main's `df85213e8f52e71f9b24a402891bdd37b1df500b`; head is the pull request's branch
  `claude/dazzling-noether-ayffn9` at a commit made before its last documentation edits, `3eed27d1` (not on the
  branch), whose `src/` is the same bytes as the branch's `01a8401d` (`git diff 01a8401d 3eed27d1 -- src` is empty;
  the two differ in `docs/attested-declarations.md` and `docs/commands/driver.md`). The branch's later `c4b85bdb`
  factors a repeated initializer into a function (`check_units_lane_functions`) and changes nothing it does.
  `results/env.txt` has each tree's hash (the SHA-256 of every file's SHA-256 outside `build/`, as
  `scripts/run.sh env` takes it): base's is `git archive df85213e`'s, head's `git archive 3eed27d1`'s. Both were built
  on the host by `scripts/build.sh` (`./build.sh`, Release, the host's native target, `BUSTER_DEBUG_INFO=0`):
  `results/build-base.log`, `results/build-head.log`; `results/env.txt` has the executables' SHA-256.
- **Host:** the Ryzen 7 9700X (`benchpress`), `results/env.txt` (kernel, governor and EPP of CPU 2, THP, clang, perf).
  Each step of `scripts/run.sh` ran in a hold of the machine's lock (`exclusive.sh`, through `scripts/bp.sh` from a
  cloud session over Tailscale); `scripts/queue2.sh` grouped a few short steps a hold (each under a minute) while
  eleven other holders waited. One-lane commands are pinned to CPU 2, eight-lane ones to CPUs 0 to 15, and every one
  runs with the address space's randomization off (`setarch -R`: one page state).
  `results/runs.log` is the queue's own lines (the lock's messages, which name other sessions, left out).
- **Workloads** (`scripts/run.sh`, from `../672-rest-claude/common.sh` on the host as the census's record has them):
  - musl: the frozen corpus's first source of each base name, 1,336 units (the list's SHA-256 `1f317509…`, the
    census's), with the one-core record's options, `-c`, one command;
  - the 512 generated units over the host's glibc headers of
    [the design's record](../file-scope-design-672-2026-11-12/) (the concatenation's SHA-256 `bdbee80a…`, the census's),
    `-c`, one command;
  - `sqlite3.c` and `shell.c` of the frozen corpus as one command of two units, `-c sqlite3.c` alone, and a small unit
    (`main` calling `puts` over `<stdio.h>`), `-c`, 50 runs a round under `perf stat -r 50`.

## Results

### Every object and diagnostic (`results/compare.txt`, `results/runs.log`)

`scripts/run.sh compare CORPUS LANES MODE [OPTION...]` compiles the command by head with `--attested=off` and with
`--attested=MODE` and compares each object and the diagnostics; `scalar` compares `--attested=on` with `--scalar`;
the `attested declarations:` lines are `--time-stages`' report of the second command.

| command | against | objects | diagnostics | skipped (tokens outside definitions) | contradictions; unlisted; read again |
| --- | --- | --- | --- | ---: | --- |
| musl, 1 lane, `on` | `off` | 1,336 the same bytes | the same (321 warnings) | 85.72% | 0; 0; 0 |
| musl, 1 lane, `on` | `--scalar` | 1,336 the same | the same | | |
| musl, 1 lane, `verify` | `off` | 1,336 the same | the same | (85.72% would be) | 0; 0; 0 |
| musl, 1 lane, `verify -g` | `off -g` | 1,336 the same | the same | (85.72% would be) | 0; 0; 0 |
| musl, 1 lane, `on -g` (runs as `off`) | `off -g` | 1,336 the same | the same | no passes | |
| musl, 1 lane, `on -Wall -Wextra` | `off` | 1,336 the same | the same (1,867 warnings) | 85.11% | 0; 0; 0 |
| musl, 1 lane, `verify -Wall -Wextra` | `off` | 1,336 the same | the same | (85.11% would be) | 0; 0; 0 |
| musl, 8 lanes, `on` | `off` | 1,336 the same | the same | 80.34% | 0; 0; 0 |
| musl, 8 lanes, `verify` | `off` | 1,336 the same | the same | (80.30% would be) | 0; 0; 0 |
| glibc units, 1 lane, `on` | `off` | 512 the same | the same (none) | 91.35% | 0; 0; 0 |
| glibc units, 1 lane, `on` | `--scalar` | 512 the same | the same | | |
| glibc units, 1 lane, `verify` and `verify -g` | `off` | 512 the same | the same | (91.35% would be) | 0; 0; 0 |
| glibc units, 8 lanes, `on` | `off` | 512 the same | the same | 85.51% | 0; 0; 0 |
| `sqlite3.c` and `shell.c`, 1 lane, `on` | `off` | 2 the same | the same | 13.88% (shell.c's) | 0; 0; 0 |

`results/compare.txt` has the glibc units' `on` comparison twice: a first queue's, stopped after it for the grouped
one, and the grouped queue's. The first `verify -g` comparison in `results/compare.txt` (and `results/different.txt`) found every object different:
the script then compiled the two commands in two directories, and `-g` writes the directory (`DW_AT_comp_dir`). The
script was changed to compile every command in one directory and move it after (`compile` in `scripts/run.sh`), and
the comparisons with `-g` were run again: the rows above.

### Times (`results/stat-*.csv`, `results/wall-*.txt`, `results/medians.txt`)

`scripts/run.sh time CORPUS LANES ROUND` runs base, head with `--attested=off` and head with `--attested=on` in turn
under `perf stat` (user and kernel cycles and instructions, task-clock, page faults), and from eight lanes on records
the command's wall time beside it. Five rounds each; medians (`scripts/stats.py`). "ms" is task-clock, the threads'
CPU time.

| one lane | base (main) | head `off` | head `on` | `on` against base |
| --- | ---: | ---: | ---: | ---: |
| musl: ms; M cycles of both modes | 1,003.9; 5,560.7 | 1,018.2; 5,641.3 | 858.4; 4,754.2 | **1.170** |
| musl: M user instructions | 11,522.7 | 11,522.6 | 9,061.9 | |
| glibc units: ms; M cycles | 824.0; 4,567.3 | 835.8; 4,632.8 | 558.6; 3,095.4 | **1.475** |
| glibc units: M user instructions | 11,181.0 | 11,180.8 | 6,748.4 | |

| eight lanes | base | head `off` | head `on` | `on` against base |
| --- | ---: | ---: | ---: | ---: |
| musl: wall ms; CPU ms | 216.8; 1,576.8 | 224.3; 1,616.2 | 199.2; 1,448.4 | **1.088** (wall) |
| glibc units: wall ms; CPU ms | 179.1; 1,317.9 | 174.6; 1,285.9 | 138.1; 981.2 | **1.297** (wall) |

| A/A (a command of one unit runs no passes) | base | head | |
| --- | ---: | ---: | ---: |
| `-c sqlite3.c`: ms; M user instructions | 124.2; 1,351.3 | 123.2; 1,351.3 | 1.008 |
| a small unit's process: ms; M user instructions | 1.3; 8.5 | 1.3; 8.5 | 1.008 |

- **Step 2's gate holds:** 1.170 on musl (1.15) and 1.475 on the glibc units (1.4), both faster on eight lanes, every
  object and diagnostic `off`'s and `--scalar`'s, and `-c sqlite3.c` and the small unit with base's instruction counts.
- **`off` against base:** on one lane, the same user instructions to 0.2 M in each command, and 1.4% more cycles: the
  executable's layout, not work (on eight lanes it is 3% slower on musl and 3% faster on the glibc units).

### Where the cycles go (`results/profile-musl-*-final.txt`)

`perf record -e cycles:u -c 200003` of musl's command by head on one lane, each way, by symbol. With `--attested=on`
the passes are 5.0% of the user cycles: `check_attested_lists` 1.49%, `check_attested_chain` 0.96%,
`check_attested_hashes` 0.72%, `check_attested_reach` 0.65%, `check_attested_literals` 0.56%, `check_attested_after`
0.33%, `check_attested_levels` 0.28%: about 36 cycles a file-scope declaration token, as the census measured them.
`check_input_declaration` goes from 4.07% of `off`'s user cycles to 1.46% of `on`'s, `check_input_resolve_range` from
3.32% to 1.73%.

### The census's rules (`results-v1/`)

A first build of the branch kept the census's reach (with the lowering's runtime functions' names) and published the
reader's environment for the binding events' test. Two rounds each (`results-v1/medians.txt`): musl 1,033.4 against
897.3 ms, 1.145 times by cycles; the glibc units 841.4 against 583.2 ms, 1.442; 79.31% and 87.00% of the tokens
outside definitions skipped (`results-v1/compare.txt`), every object the same bytes. Dropping the runtime names' rule
(the selection numbers only the objects the selected code references, so a skipped prototype can't change a runtime
call's symbol) and testing the events in the reader gave the rows above.

## Limitations

- The 9700X was shared with eleven other holders of the lock that day; each step ran in its own hold, and the rounds
  alternate base, `off` and `on` within a hold, so a slow period hits all three.
- The `-g` exclusion is the compiler's own (`--attested=on` with `-g` runs as `off`): its DWARF describes every type
  in a unit's table, a skipped declaration's too.
- Deferred bodies (`--deferred-bodies`) are one source file's; a command of several source files reads its bodies in
  source order, so step 1's "with the bodies deferred" has nothing to run.
- The eight-lane rounds' wall time is `EPOCHREALTIME` around `perf stat`, which includes `perf`'s own start and end.
