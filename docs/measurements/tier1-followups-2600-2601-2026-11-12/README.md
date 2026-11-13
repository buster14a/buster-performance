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
| base | `85b832ecf536547dffa209483b8264738362292d` | buster's main with #2574 (hoisted symbol addresses) and #2554 merged |
| head | `7e24f8be667929217583342a3e3f83e76e59f3d7` | buster#2605's head: both changes, tests and documentation, with that main merged |

Two earlier comparisons are kept, measured the same way, and not quoted below:

- **`0035a7fd` against `9750b3f0`** (`9700x/vs-9750b3f0/`, `counts/vs-9750b3f0/`). This is the PR's head before main's merge, against main when the work began. Main's #2574 then hoisted symbol addresses across blocks itself, so this record measures again on top of it.
- **The first head, `7f7b7ef7`** (`9700x/first-7f7b7ef7/`). It also shared a block's first extension to I32. The PR's CI found that wrong: SQLite's `autoindex5.test` segfaulted in `--tier1`'s testfixture. `tier1_select_storage.c` keeps each I32 sign-extended, zero-extended or neither above its 32 bits according to its own users. In `sqlite3LogEstAdd`'s `a + x[a - b]`, the index read the addition's zero-extended `a` as sign-extended, so −1 became `0xffffffff`. The head shares only extensions to I64, whose register has one form.

## Inputs

The inputs are #1189's, the same as #2573's record (`9700x/host.txt` has their hashes):
- the frozen `sqlite3.c` (SHA-256 `0a409f16…`);
- SQLite's `test/speedtest1.c` (`b5eaf4bb…`), with #136's flags and options;
- Lua 5.4.8's release (`4f18ddae…`) and the five scripts.

Tier 1 builds use `--tier1 -fno-asynchronous-unwind-tables` at the default target.

## 1. Counts in the container

**Host.** A cloud container: an Intel Xeon with AVX-512 under KVM, clang 23.1.6, valgrind 3.22.0 and GNU objdump 2.42. `counts/host-and-identities.txt` also has the executables', the compilers' and the tools' hashes. Each compiler was built natively there by `./build.sh` (Release).

### Static: the frozen sqlite3.c

`counts/static-sqlite3.txt` has the commands, the objects' hashes and the counts. `scripts/cmpclass.py` classifies objdump's memory comparisons by their immediate's value at their width and by opcode.

| | main `85b832ec` | head `7e24f8be` |
| --- | ---: | ---: |
| `.text` | 1,003,592 B | 995,560 B (−8,032 B, −0.80%) |
| instructions | 274,591 | 274,495 |
| rip-relative `lea`s | 2,094 | 2,087 |
| memory comparisons with a constant that fits a signed byte | 2,519 by `81` | 2,519 by `83` |
| memory comparisons with a larger constant | 78 by `81` | 78 by `81` |

### Dynamic: speedtest1

`scripts/count.sh` built speedtest1 by each compiler and ran it once under callgrind. #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (SHA-256 `81856ce1…`) joined the counts with the disassembly, as in #2573's record. Both executables gave speedtest1's verification hash natively. Two scripts sum the rows:
- `scripts/tally.py` writes `counts/leas-*.tsv`, the rip-relative `lea`s by symbol.
- `scripts/mnemonics.py` writes `counts/mnemonics.tsv`, the change by mnemonic.

| | main | head |
| --- | ---: | ---: |
| speedtest1's own code | 2,867.5 M | 2,859.5 M (−0.28%) |
| whole process | 3,040.3 M | 3,032.2 M |
| every rip-relative `lea` | 46.65 M | 46.65 M |
| `lea` of `sqlite3Stat` | 0.96 M | 0.96 M |
| `mov` | 1,076.5 M | 1,069.3 M (−7.2 M) |
| `movslq` | 60.6 M | 59.5 M (−1.1 M) |
| `lea` (all) | 168.03 M | 168.39 M (+0.35 M) |

On this main, #2574's hoist already keeps `sqlite3StatusUp`'s `sqlite3Stat` address in a register for both of its blocks (0.96 M, down from 1.73 M before it). So the head's shared symbol addresses add no further rip-relative `lea`s. What remains of #2601 is the shared index extensions: 1.1 M fewer `movslq`s. There are also 7.2 M fewer `mov`s; this record doesn't attribute them further.

## 2. Run time on the 9700X

`scripts/run2600.sh` ran on benchpress under its lock, each step and each run one hold, every run pinned to CPU 2. It is #2573's `run2573.sh` with its paths, lock identity and comment changed.

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
| Lua's five scripts, time | 0.9941 | 95% over the layouts: 0.9842 to 1.0042 |
| Lua's five scripts, user cycles | 0.9938 | 0.9838 to 1.0038 |
| Lua's five scripts, user instructions | 0.9999 | 0.9997 to 1.0001 |
| speedtest1, time | 0.9938 | paired rounds: 0.9844 to 1.0207 |
| speedtest1, user cycles | 0.9931 | paired rounds: 0.9876 to 1.0023 |
| speedtest1, user instructions | 0.9973 | paired rounds: 0.9973 to 0.9974 |

- **Lua.** Its instructions don't move, and its times stay within the layouts' spread.
- **speedtest1.** It runs 0.27% fewer instructions and 0.7% fewer user cycles. Ten of the eleven paired rounds' cycles are lower; three rounds' times aren't. Its time includes the database's syncs on `/home`; part 4 repeats it in `/tmp`.

## 3. Compile time on the 9700X

`scripts/compile2600.sh` (#2573's `compile2573.sh`, adapted the same way) timed two compiles by both compilers:
- `--tier1 -c` of the frozen `sqlite3.c`, with speedtest1's flags;
- `--tier1` of Lua's 33 sources into an executable.

It ran 11 rounds after one warm-up of each, the builds' order alternating, one lock hold per run, on CPU 2 (`9700x/compile-runs.txt`). Both programs' outputs were the same in every round (`9700x/compile.log`). `scripts/compile_analyze.py` produces `9700x/compile-analysis.md`:

| Compile | base | head | head / base, paired median (range) |
| --- | ---: | ---: | ---: |
| sqlite3.c, time | 394.91 ms | 396.03 ms | 1.0026 (0.9994 to 1.0060) |
| sqlite3.c, user instructions | 4,683.46 M | 4,683.38 M | 1.0000 |
| Lua, time | 165.38 ms | 164.20 ms | 0.9911 (0.9880 to 1.0145) |
| Lua, user instructions | 1,933.7 M | 1,929.1 M | 0.9976 |

On sqlite3.c the head runs the same number of instructions, but 0.27% more cycles, slower in ten of the eleven rounds. The scan and table add their instructions, and the smaller output saves about as many. A cycle cost without an instruction cost points to the compilers' code layout, which this record doesn't measure. Lua's compile runs 0.24% fewer instructions and its time moves within its spread.

## 4. speedtest1 with its files in `/tmp`

`scripts/rerun2600.sh` ran the same two executables after the compile-time runs: one warm-up pair, then 11 pairs, alternating, one lock hold each, on CPU 2. The database and SQLite's temporary files were in `/tmp` (tmpfs). The runs are in `9700x/st-tmp-runs.txt`, analyzed in `9700x/analysis-st-tmp.md`.

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time (task-clock), ms | 178.42 | 176.78 | 0.9908 | 0.9908 (0.9866 to 1.0015) |
| user cycles, M | 893.84 | 884.46 | 0.9895 | 0.9885 (0.9848 to 0.9988) |
| user instructions, M | 2,989.78 | 2,981.74 | 0.9973 | 0.9973 |

The head runs 0.27% fewer instructions and 0.9% less time. Every pair's cycles are lower; one pair's time isn't.

## Limitations

- **Lock receipts.** The scripts log their own steps and the lock's identity, but not the holder line `exclusive.sh` writes when a run takes the lock.
- **Host-run logs.** The scripts' stdout is included as `9700x/run.out`, `compile.out` and `rerun.out`. It holds the lock's waiting lines and `exclusive.sh`'s lists of processes busy as a run took the lock. This run found none busy. In the first head's run, a short-lived `sha256sum` was busy twice in round 8 (`9700x/first-7f7b7ef7/run.out`). Every number above comes from the `perf stat` lines in the scripts' run files.
- **The compile's cycles.** sqlite3.c's compile cycles rose 0.27% with no instruction change. Neither earlier comparison saw that (1.0014 and 1.0001), so it more likely tracks the two compilers' layouts than the change itself; no counter here separates the two.
- **Host paths.** On main as on the head, the default and `--scalar` host paths give different sqlite3.c objects: in `sqlite3_str_vappendf`, two spilled values swap slots. This record doesn't cause or measure that; it's [buster#2606](https://github.com/buster14a/buster/issues/2606).
