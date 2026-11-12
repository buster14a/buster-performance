# Tier 1's imm8 memory comparisons (#2600) and a block's shared symbol addresses (#2601), 2026-11-12

This is the evidence for [buster#2600](https://github.com/buster14a/buster/issues/2600), [buster#2601](https://github.com/buster14a/buster/issues/2601) and [buster#2605](https://github.com/buster14a/buster/pull/2605). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01Egbxne4JuAewyrnzBukQDH)).

The two changes:
- **#2600.** A word's, doubleword's or quadword's comparison of memory with a constant that fits a signed byte takes the `83 /7 ib` form instead of `81 /7`.
- **#2601.** Within a block, every pattern reads the first of a symbol's repeated `symbol_addr` nodes, and the first of the index's repeated extensions to I64. So a block's accesses of one table share one `lea` and one index register.

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
| head | `0035a7fd255ce952a369452bcc01c02c2e33e561` | buster#2605's head: both changes, tests and documentation |
| first head | `7f7b7ef70438b90162fb765d0ddb0380db5b2167` | the pull request's first head, superseded (below) |

**The first head.** It also shared a block's first sign or zero extension to I32. The pull request's CI found that wrong: SQLite's `autoindex5.test` segfaulted in `--tier1`'s testfixture. In `sqlite3LogEstAdd`'s `a + x[a - b]`, the lowering extends `a` to int once for each use. `tier1_select_storage.c` keeps each I32 sign-extended, zero-extended or neither above its 32 bits according to its own users, so the two extensions differ: the index's is sign-extended and the addition's is not. Reading the addition's for both made the index `0xffffffff` for −1. The head shares only extensions to I64, whose register has one form.

This record measures the head. The first head's 9700X files and analyses are kept in `9700x/first-7f7b7ef7/`, measured the same way. Its numbers were within a few tenths of a percent of the head's, and they are not quoted below.

The callgrind counts in part 1 use `fb049c07`, #2587's head, as main. Between it and `9750b3f0`, no source the `--tier1` code path compiles changed; the only changes are checker tests and the node machine's shadow code.

## Inputs

The inputs are #1189's, the same as #2573's record (`9700x/host.txt` has their hashes):
- the frozen `sqlite3.c` (SHA-256 `0a409f16…`);
- SQLite's `test/speedtest1.c` (`b5eaf4bb…`), with #136's flags and options;
- Lua 5.4.8's release (`4f18ddae…`) and the five scripts.

Tier 1 builds use `--tier1 -fno-asynchronous-unwind-tables` at the default target.

## 1. Counts in the container

**Host.** A cloud container: an Intel Xeon with AVX-512 under KVM, clang 23.1.6, valgrind 3.22.0 and GNU objdump 2.42 (`counts/host-and-identities.txt`, which also has the executables', the head compiler's and the tools' hashes).

### Static: the frozen sqlite3.c

Each compiler was built natively in the container, by `./build.sh` (Release). `counts/static-sqlite3.txt` has the commands, the objects' hashes and the counts, the first head's too. `scripts/cmpclass.py` classifies objdump's memory comparisons by their immediate's value at their width and by opcode.

| | main `9750b3f0` | head `0035a7fd` |
| --- | ---: | ---: |
| `.text` | 1,034,232 B | 1,026,104 B (−8,128 B, −0.79%) |
| instructions | 290,479 | 290,158 |
| rip-relative `lea`s | 2,042 | 2,022 |
| memory comparisons with a constant that fits a signed byte | 2,517 by `81` | 2,517 by `83` |
| memory comparisons with a larger constant | 78 by `81` | 78 by `81` |

### Dynamic: speedtest1

`scripts/count.sh` built speedtest1 by each compiler and ran it once under callgrind. #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (SHA-256 `81856ce1…`) joined the counts with the disassembly, as in #2573's record. `scripts/tally.py` sums the rows, and writes `counts/leas-*.tsv` (rip-relative `lea`s by symbol). Both executables gave speedtest1's verification hash natively.

| | main (`fb049c07`) | head (`0035a7fd`) |
| --- | ---: | ---: |
| speedtest1's own code | 3,060.5 M | 3,051.5 M (−0.30%) |
| whole process | 3,233.3 M | 3,224.2 M |
| every rip-relative `lea` | 46.46 M | 45.29 M |
| `lea` of `sqlite3Stat` | 1.73 M | 0.97 M |
| register-to-register 64-bit `mov`s | 289.81 M | 286.49 M |

`sqlite3StatusUp` goes from five `lea`s of `sqlite3Stat` to two, one per block. Its accesses `nowValue[op]` and `mxValue[op]` are indexed, so they still need the symbol's address in a register. clang -O2 inlines the function with a constant `op` instead.

## 2. Run time on the 9700X

`scripts/run2600.sh` ran on benchpress under its lock, with each step and each run one hold, every run pinned to CPU 2. It is #2573's `run2573.sh` with its paths, lock identity and comment changed. The head's run reused the first run's base tree; `9700x/build-base.log` is its build.

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
| Lua's five scripts, time | 0.9978 | 95% over the layouts: 0.9865 to 1.0092 |
| Lua's five scripts, user cycles | 0.9978 | 0.9859 to 1.0097 |
| Lua's five scripts, user instructions | 1.0000 | 0.9997 to 1.0003 |
| speedtest1, time | 0.9903 | paired rounds: 0.9741 to 1.0149 |
| speedtest1, user cycles | 0.9877 | paired rounds: 0.9817 to 0.9940 |
| speedtest1, user instructions | 0.9972 | paired rounds: 0.9972 |

- **Lua.** Its instructions don't move, and its times stay within the layouts' spread. Its hot paths reach few global tables.
- **speedtest1.** It runs 0.28% fewer instructions and 1.2% fewer user cycles. Every paired round's cycles are lower; one of eleven rounds' times isn't. Its time includes the database's syncs on `/home`; part 4 repeats it in `/tmp`.

## 3. Compile time on the 9700X

`scripts/compile2600.sh` (#2573's `compile2573.sh`, adapted the same way) timed two compiles by both compilers:
- `--tier1 -c` of the frozen `sqlite3.c`, with speedtest1's flags;
- `--tier1` of Lua's 33 sources into an executable.

It ran 11 rounds after one warm-up of each, the builds' order alternating, one lock hold per run, on CPU 2 (`9700x/compile-runs.txt`). Both programs' outputs were the same in every round (`9700x/compile.log`). `scripts/compile_analyze.py` produces `9700x/compile-analysis.md`:

| Compile | base | head | head / base, paired median (range) |
| --- | ---: | ---: | ---: |
| sqlite3.c, time | 390.38 ms | 390.69 ms | 1.0001 (0.9976 to 1.0024) |
| sqlite3.c, user instructions | 4,765.2 M | 4,766.1 M | 1.0002 |
| Lua, time | 166.91 ms | 162.46 ms | 0.9719 (0.9675 to 0.9934) |
| Lua, user instructions | 1,938.2 M | 1,933.8 M | 0.9977 |

On sqlite3.c, the head's compile runs 0.9 M more instructions (0.02%): the leaves' scan and table, and the comparisons' form choice. Its time is unchanged within its spread. Lua's compile ran 2.2% fewer cycles but only 0.23% fewer instructions. That gap is more likely the two compilers' code layout than the change itself: #2573's record saw Lua's compile time move the same way (0.9853) with a comparable instruction change.

## 4. speedtest1 with its files in `/tmp`

`scripts/rerun2600.sh` ran the same two executables after the compile-time runs: one warm-up pair, then 11 pairs, alternating, one lock hold each, on CPU 2. The database and SQLite's temporary files were in `/tmp` (tmpfs). The runs are in `9700x/st-tmp-runs.txt`, analyzed in `9700x/analysis-st-tmp.md`.

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time (task-clock), ms | 184.47 | 182.94 | 0.9917 | 0.9913 (0.9815 to 0.9956) |
| user cycles, M | 930.01 | 919.78 | 0.9890 | 0.9890 (0.9779 to 0.9926) |
| user instructions, M | 3,182.80 | 3,173.75 | 0.9972 | 0.9972 |

The head runs 0.28% fewer instructions and 0.8% less time, and every one of the eleven pairs is faster.

## Limitations

- **Lock receipts.** The scripts log their own steps and the lock's identity, but not the holder line `exclusive.sh` writes when a run takes the lock.
- **Host-run logs.** The scripts' stdout is included as `9700x/run.out`, `compile.out` and `rerun.out`. It holds the lock's waiting lines and `exclusive.sh`'s lists of processes busy as a run took the lock. The head's runs found none busy. In the first head's run, a short-lived `sha256sum` was busy twice in round 8 (`9700x/first-7f7b7ef7/run.out`). Every number above comes from the `perf stat` lines in the scripts' run files.
- **Mixed revisions in part 1.** The callgrind builds are `fb049c07` and `0035a7fd`, not `9750b3f0` and `0035a7fd`. The reasons they count the same code are under "Revisions"; the 9700X's user instructions confirm a comparable difference on the pull request's own revisions (3,182.8 M to 3,173.8 M, against callgrind's 3,233.3 M to 3,224.2 M for the whole process).
- **Host paths.** On main as on the head, the default and `--scalar` host paths give different sqlite3.c objects: in `sqlite3_str_vappendf`, two spilled values swap slots. This record doesn't cause or measure that; it's [buster#2606](https://github.com/buster14a/buster/issues/2606).
