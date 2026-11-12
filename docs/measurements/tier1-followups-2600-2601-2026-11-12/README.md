# Tier 1's imm8 memory comparisons (#2600) and a block's shared symbol addresses (#2601), 2026-11-12

This is the evidence for [buster#2600](https://github.com/buster14a/buster/issues/2600), [buster#2601](https://github.com/buster14a/buster/issues/2601) and [buster#2605](https://github.com/buster14a/buster/pull/2605). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01Egbxne4JuAewyrnzBukQDH)).

The two changes:
- **#2600.** A word's, doubleword's or quadword's comparison of memory with a constant that fits a signed byte takes the `83 /7 ib` form instead of `81 /7`.
- **#2601.** Within a block, every pattern reads the first of a symbol's repeated `symbol_addr` nodes, and the first of the index's repeated `sext` and `zext` nodes. So a block's accesses of one table share one `lea` and one index register.

The record follows [`tier1-symbols-2573-2026-11-12`](../tier1-symbols-2573-2026-11-12/README.md)'s method and scripts. It has four parts:
- counts in a cloud container, static on sqlite3.c and dynamic on speedtest1 by callgrind;
- run time on the Ryzen 7 9700X;
- compile time on the 9700X;
- speedtest1's run time on the 9700X again, with its files in `/tmp`.

[buster#2602](https://github.com/buster14a/buster/issues/2602), the third follow-up, priced an addition's memory form. It was measured, gained nothing and was left out, so it isn't part of this record ([its comment](https://github.com/buster14a/buster/issues/2602#issuecomment-6836512802)).

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `9750b3f03067f113533a8ae0cf847e9cf41412ea` | buster's main when the work began |
| head | `7f7b7ef70438b90162fb765d0ddb0380db5b2167` | buster#2605's head: both changes, the vector scan, tests and documentation |

The callgrind counts in part 1 used two other builds:
- **main:** `fb049c07`, #2587's head. Between it and `9750b3f0`, no source the `--tier1` code path compiles changed; the only changes are checker tests and the node machine's shadow code.
- **head:** `66907a38`, both changes before the head's vector scan. The scan leaves the code unchanged: each host path's sqlite3.c object is byte-identical before and after it.

## Inputs

The inputs are #1189's, the same as #2573's record (`9700x/host.txt` has their hashes):
- the frozen `sqlite3.c` (SHA-256 `0a409f16…`);
- SQLite's `test/speedtest1.c` (`b5eaf4bb…`), with #136's flags and options;
- Lua 5.4.8's release (`4f18ddae…`) and the five scripts.

Tier 1 builds use `--tier1 -fno-asynchronous-unwind-tables` at the default target.

## 1. Counts in the container

**Host.** A cloud container: an Intel Xeon with AVX-512 under KVM, clang 23.1.6, valgrind 3.22.0 and GNU objdump 2.42 (`counts/host-and-identities.txt`, which also has the executables' and tools' hashes).

### Static: the frozen sqlite3.c

Each compiler was built natively in the container, by `./build.sh` (Release). `counts/static-sqlite3.txt` has the commands, the objects' hashes and the counts. `scripts/cmpclass.py` classifies objdump's memory comparisons by their immediate's value at their width and by opcode.

| | main `9750b3f0` | head `7f7b7ef7` |
| --- | ---: | ---: |
| `.text` | 1,034,232 B | 1,026,152 B (−8,080 B, −0.78%) |
| instructions | 290,479 | 290,175 |
| rip-relative `lea`s | 2,042 | 2,022 |
| memory comparisons with a constant that fits a signed byte | 2,517 by `81` | 2,517 by `83` |
| memory comparisons with a larger constant | 78 by `81` | 78 by `81` |

### Dynamic: speedtest1

`scripts/count.sh` built speedtest1 by each compiler and ran it once under callgrind. #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (SHA-256 `81856ce1…`) joined the counts with the disassembly, as in #2573's record. `scripts/tally.py` sums the rows, and writes `counts/leas-*.tsv` (rip-relative `lea`s by symbol). Both executables gave speedtest1's verification hash natively.

| | main (`fb049c07`) | head (`66907a38`) |
| --- | ---: | ---: |
| speedtest1's own code | 3,060.5 M | 3,050.2 M (−0.34%) |
| whole process | 3,233.3 M | 3,223.0 M |
| every rip-relative `lea` | 46.46 M | 45.29 M |
| `lea` of `sqlite3Stat` | 1.73 M | 0.97 M |
| register-to-register 64-bit `mov`s | 289.81 M | 286.60 M |

`sqlite3StatusUp` goes from five `lea`s of `sqlite3Stat` to two, one per block. Its accesses `nowValue[op]` and `mxValue[op]` are indexed, so they still need the symbol's address in a register. clang -O2 inlines the function with a constant `op` instead.

## 2. Run time on the 9700X

`scripts/run2600.sh` ran on benchpress under its lock, with each step and each run one hold, every run pinned to CPU 2. It is #2573's `run2573.sh` with its paths, lock identity and comment changed. Another session's runs took turns with these under the same lock.

**Host.** `9700x/host.txt`: Linux 6.18.50, clang 23.1.1, perf 7.2.9, CPU 2's governor `performance`, `/home` 75% full.

**Builds.**
- Each compiler is built in a tree of its own at its commit, by `./build.sh` with `BUSTER_DEBUG_INFO=0`, at the host's native target (znver5).
- `9700x/compilers.sha256` and `9700x/executables.sha256` have the hashes, and `9700x/build-*.log` the builds' logs.
- Lua's objects are linked in six orders (`9700x/orders.txt`), the same for both builds.

**Checks before any timing** (`9700x/run.log`, `checks status 0`):
- every Lua executable printed clang -O0's output for every script;
- both speedtest1 builds gave the verification hash (`9700x/verify-*.txt`).

**Timing.** Eleven rounds. Each run is one `perf stat` of task-clock, user cycles and user instructions (`9700x/runs.txt`). `scripts/analyze.py` produces `9700x/analysis.md`.

| | head / base | interval or range |
| --- | ---: | --- |
| Lua's five scripts, time | 0.9971 | 95% over the layouts: 0.9862 to 1.0082 |
| Lua's five scripts, user cycles | 0.9970 | 0.9855 to 1.0087 |
| Lua's five scripts, user instructions | 1.0000 | 0.9995 to 1.0005 |
| speedtest1, time | 0.9917 | paired rounds: 0.9762 to 1.0072 |
| speedtest1, user cycles | 0.9888 | paired rounds: 0.9761 to 0.9938 |
| speedtest1, user instructions | 0.9967 | paired rounds: 0.9967 to 0.9968 |

- **Lua.** Its instructions don't move, and its times stay within the layouts' spread. Its hot paths reach few global tables.
- **speedtest1.** It runs 0.33% fewer instructions and 1.1% fewer user cycles, and every paired round's cycle ratio is below 1. Its time includes the database's syncs on `/home`; part 4 repeats it in `/tmp`.

## 3. Compile time on the 9700X

`scripts/compile2600.sh` (#2573's `compile2573.sh`, adapted the same way) timed two compiles by both compilers:
- `--tier1 -c` of the frozen `sqlite3.c`, with speedtest1's flags;
- `--tier1` of Lua's 33 sources into an executable.

It ran 11 rounds after one warm-up of each, the builds' order alternating, one lock hold per run, on CPU 2 (`9700x/compile-runs.txt`). Both programs' outputs were the same in every round (`9700x/compile.log`). `scripts/compile_analyze.py` produces `9700x/compile-analysis.md`:

| Compile | base | head | head / base, paired median (range) |
| --- | ---: | ---: | ---: |
| sqlite3.c, time | 390.33 ms | 391.04 ms | 1.0014 (0.9979 to 1.0048) |
| sqlite3.c, user instructions | 4,765.2 M | 4,766.7 M | 1.0003 |
| Lua, time | 167.02 ms | 162.54 ms | 0.9720 (0.9679 to 0.9947) |
| Lua, user instructions | 1,938.2 M | 1,933.9 M | 0.9978 |

On sqlite3.c the head's compile runs 1.4 M more instructions (0.03%): the leaves' scan and table, and the comparisons' form choice. Its time is unchanged within its spread. Lua's compile ran 2.2% fewer cycles but only 0.22% fewer instructions. Most of that difference is more likely the two compilers' code layout than the change: #2573's record saw Lua's compile time move the same way (0.9853) with a comparable instruction change.

## 4. speedtest1 with its files in `/tmp`

`scripts/rerun2600.sh` ran the same two executables after the compile-time runs: one warm-up pair, then 11 pairs, alternating, one lock hold each, on CPU 2. The database and SQLite's temporary files were in `/tmp` (tmpfs). The runs are in `9700x/st-tmp-runs.txt`, analyzed in `9700x/analysis-st-tmp.md`.

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time (task-clock), ms | 184.25 | 183.21 | 0.9944 | 0.9938 (0.9907 to 1.0049) |
| user cycles, M | 927.03 | 919.89 | 0.9923 | 0.9925 (0.9881 to 1.0061) |
| user instructions, M | 3,182.80 | 3,172.46 | 0.9967 | 0.9967 |

The head runs 0.33% fewer instructions and about 0.6% less time. The median round agrees with part 2's sign, but one pair of the eleven goes the other way. In part 2, two of the eleven pairs' times and none of their cycles go the other way.

## Limitations

- **Lock receipts.** The scripts log their own steps and the lock's identity, but not the holder line `exclusive.sh` writes when a run takes the lock.
- **Host-run logs.** The scripts' stdout is included as `9700x/run.out`, `compile.out` and `rerun.out`. It holds the lock's waiting lines (another session's runs, for buster#2553, took turns with these) and `exclusive.sh`'s lists of processes busy as a run took the lock. Every number above comes from the `perf stat` lines in the scripts' run files.
- **Busy processes.** Twice, at 21:48:55 during round 8 of part 2, the lock was taken while a short-lived `sha256sum` ran, once on CPU 8 and once on CPU 2, the runs' CPU (`9700x/run.out`, lines 1555 and 1560). Its parent had exited by the time it was checked; this script runs nothing between its locked runs. That affects at most two Lua runs of the 660; the tables use medians over the 11 rounds. Parts 3 and 4 saw no busy process.
- **Mixed revisions in part 1.** The callgrind builds are `fb049c07` and `66907a38`, not `9750b3f0` and `7f7b7ef7`. The reasons they count the same code are under "Revisions"; the 9700X's user instructions confirm the same 10.3 M difference on the PR's own revisions (3,182.8 M to 3,172.5 M).
- **Host paths.** On main as on the head, the default and `--scalar` host paths give different sqlite3.c objects: in `sqlite3_str_vappendf`, two spilled values swap slots. This record doesn't cause or measure that; it's [buster#2606](https://github.com/buster14a/buster/issues/2606).
