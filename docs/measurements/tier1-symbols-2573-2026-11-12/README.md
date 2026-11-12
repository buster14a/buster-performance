# Tier 1's rip-relative symbols (#2573), 2026-11-12

This is the evidence for [buster#2573](https://github.com/buster14a/buster/issues/2573) and [buster#2587](https://github.com/buster14a/buster/pull/2587). By Claude, in David's directed session ([the session](https://claude.ai/code/session_01Egbxne4JuAewyrnzBukQDH)).

The change folds a direct symbol's address into its accesses' memory operands, rip-relative, where Tier 1 had made a `lea sym(%rip)` and accessed memory through its register.

The record has four parts:
- dynamic instruction counts by callgrind, in a cloud container;
- run time on the Ryzen 7 9700X;
- compile time on the 9700X;
- speedtest1's run time on the 9700X again, with its files in `/tmp`.

It follows [`tier1-address-1217-2026-11-12`](../tier1-address-1217-2026-11-12/README.md)'s method and scripts.

## Revisions

| Role | Commit | What |
| --- | --- | --- |
| base | `9399e73665e80352822a6004b4f7d8448b164f7d` | buster's main when the work began |
| head | `fb049c07fc545799655f91cb0d8f7bf5dba87f93` | buster#2587's head: the fold, its tests and documentation, and the walk's leaf past its bound |

## Inputs

These are #1189's inputs, the same as #1217's record (`9700x/host.txt` has their hashes):
- the frozen `sqlite3.c` (SHA-256 `0a409f16…`), from `ci-corpora-preprocessor-391e729af658` by `tools/ci/fetch-corpus.sh`;
- SQLite's `test/speedtest1.c` at `ccc132c5` (`b5eaf4bb…`), with #136's flags and options;
- Lua 5.4.8's release (`4f18ddae…`) and the `cc3387f` record's five scripts.

Tier 1 builds use `--tier1 -fno-asynchronous-unwind-tables` at the default target. speedtest1 is one unity translation unit; Lua is 33 objects linked by `cc`.

## 1. Dynamic instruction counts

**Host.** A cloud container: an Intel Xeon with AVX-512 under KVM, Ubuntu, clang 23.1.6, valgrind 3.22.0 and GNU objdump 2.42 (`counts/host-and-identities.txt`). Each compiler was built there natively, by `./build.sh` (Release).

**Identities.** `counts/host-and-identities.txt` has the SHA-256 of both compilers, both speedtest1 executables, `gap.c` and the inputs.

**Counting.** `scripts/count.sh` builds speedtest1 by each compiler and runs it once under callgrind (`--dump-instr=yes`), from a fresh database directory. #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (SHA-256 `81856ce1…`) then joins the counts with `objdump -d --no-show-raw-insn`'s disassembly, as `GAP_INSTRUCTIONS=1 gap count DIS CG '???' 0x108000`. `#check unmatched` was 4,456 instructions in both runs.

**Classifying.** `scripts/tally.sh` sums gap's per-instruction rows. A rip-relative `lea` is attributed to the symbol objdump names in its comment.

**Retained.**
- `counts.tar.zst` holds gap's per-function rows, and its instruction rows for `lea`s and rip-relative operands only.
- `counts/leas-*.tsv` has the rip-relative `lea`s by symbol.
- `counts/instructions-*.txt` has each whole process's count.

### Results: speedtest1

| | main | head | clang -O2 (#2573's table) |
| --- | ---: | ---: | ---: |
| `lea` of `mem5` | 9.92 M | 1.45 M | 0.38 M |
| `lea` of `sqlite3Config` | 1.94 M | 0 | 0 |
| `lea` of `sqlite3Stat` | 1.73 M | 1.73 M | 0 |
| `lea` of `g` | 1.34 M | 0.10 M | 0 |
| `lea` of `mem0` | 0.23 M | 0 | 0 |
| every rip-relative `lea` | 59.13 M | 46.46 M | |
| every rip-relative operand, `lea`s included | 66.46 M | 66.88 M | |
| speedtest1's own code | 3,077.1 M | 3,060.5 M | |
| whole process | 3,249.8 M | 3,233.3 M | |

- The executables have 3,455 and 2,587 rip-relative `lea`s.
- `sqlite3Config` keeps one `lea` of 1 dynamic instruction.

**What remains is indexed.**
- `mem5`'s `lea`s address `aiFreelist[i]` and `aCtrl[i]`.
- `sqlite3Stat`'s address `nowValue[op]` and `mxValue[op]` in `sqlite3StatusUp` and its siblings. clang -O2 inlines those into their callers with a constant `op`, so its index is a constant and its operand rip-relative (checked in clang -O2's `sqlite3.o`: no out-of-line `sqlite3StatusUp`).

A rip-relative operand has no index register, so such a table keeps its base in a register.

## 2. Run time on the 9700X

`scripts/run2573.sh` ran on benchpress under its lock: each step and each run is one hold, and every run is pinned to CPU 2. It is #1217's `run1217.sh` with its paths, lock identity and session link changed, and its final long-hold `measure-tier1-programs` step removed: the pull request's 9700X CI job runs that step.

**Host.** `9700x/host.txt`: Linux 6.18.50, clang 23.1.1, perf 7.2.9, CPU 2's governor `performance`.

**Builds.**
- Each compiler is built in a tree of its own at its commit, by `./build.sh` with `BUSTER_DEBUG_INFO=0`, at the host's native target (znver5).
- `9700x/compilers.sha256` and `9700x/executables.sha256` have their hashes, and `9700x/build-*.log` the builds.
- Lua's objects are linked in six orders (`9700x/orders.txt`), the same for both builds.

**Checks before any timing** (`9700x/run.log`, `checks status 0`):
- Every Lua executable printed clang -O0's output for every script.
- Both speedtest1 builds gave the verification hash (`9700x/verify-*.txt`).

**Timing.** Eleven rounds. In each, every order's two Lua builds ran all five scripts and speedtest1's two builds ran once, the builds' order rotating. Each run is one `perf stat` of task-clock, user cycles and user instructions (`9700x/runs.txt`); `scripts/analyze.py` (#1217's, its first line's comment updated) makes `9700x/analysis.md`.

| | head / base | interval or range |
| --- | ---: | --- |
| Lua's five scripts, time | 0.9956 | 95% over the layouts 0.9809 to 1.0106 |
| Lua's five scripts, user cycles | 0.9957 | 0.9802 to 1.0115 |
| Lua's five scripts, user instructions | 0.9981 | 0.9980 to 0.9982 |
| speedtest1, time | 0.9963 | paired rounds 0.9833 to 1.0094 |
| speedtest1, user cycles | 0.9993 | 0.9876 to 1.0046 |
| speedtest1, user instructions | 0.9948 | |

Lua's globals are few, and its instruction count moves by 0.19%, most of it in `strings.lua`. Neither program's time moves by more than its run-to-run spread. This run kept speedtest1's database on `/home`, whose syncs are in its wall time but not its task-clock.

## 3. Compile time on the 9700X

`scripts/compile2573.sh` (#1217's `compile1217.sh`, adapted the same way) timed `--tier1 -c` of the frozen `sqlite3.c` with speedtest1's flags, and `--tier1` of Lua's 33 sources into an executable, by both compilers. It used 11 rounds after one warm-up of each, the builds' order alternating, one hold per run, CPU 2 (`9700x/compile-runs.txt`). Both programs' outputs were the same in every round (`9700x/compile.log`). `/home` was 73% full; none of the run's writes failed.

`scripts/compile_analyze.py` makes `9700x/compile-analysis.md`:

| Compile | base | head | head / base, paired median (range) |
| --- | ---: | ---: | ---: |
| sqlite3.c, time | 391.48 ms | 391.00 ms | 0.9986 (0.9947 to 1.0026) |
| sqlite3.c, user instructions | 4,768.5 M | 4,764.7 M | 0.9992 |
| Lua, time | 165.36 ms | 163.18 ms | 0.9853 (0.9818 to 1.0101) |
| Lua, user instructions | 1,940.1 M | 1,933.1 M | 0.9964 |

The head emits fewer records, so it spends slightly less time compiling, not more.

## 4. speedtest1 with its files in `/tmp`

`scripts/rerun2573.sh` (#1217's `rerun1217.sh` without its `measure-tier1-programs` step) ran the same two executables after the compile-time runs. It used one warm-up pair, then 11 pairs, alternating, one lock hold each, CPU 2, with the database and SQLite's temporary files in `/tmp` (tmpfs). The data is in `9700x/st-tmp-runs.txt`, analyzed in `9700x/analysis-st-tmp.md`.

| Metric | base | head | head / base | paired rounds' ratio, median (range) |
| --- | ---: | ---: | ---: | ---: |
| time (task-clock), ms | 184.53 | 184.90 | 1.0020 | 1.0013 (0.9967 to 1.0062) |
| user cycles, M | 928.85 | 931.23 | 1.0026 | 1.0024 (0.9981 to 1.0073) |
| user instructions, M | 3,199.34 | 3,182.80 | 0.9948 | 0.9948 |

The head runs 0.52% fewer instructions. The time is the same within the pairs' spread: the two runs disagree in sign by less than it.

## Limitations

- **Lock receipts.** The scripts log their own steps and the lock's identity, but not the holder line `exclusive.sh` writes when a run takes the lock.
- **Host-run logs.** The ssh sessions' and the scripts' stdout (`run.out`, `compile.out`, `rerun.out`) are not included. Every number above comes from the `perf stat` lines in the scripts' run files.
- **A first attempt.** A first run at head `4fe44059` was stopped during its setup, before any timing, when the walk's bound change followed. Its head tree was removed, and its base tree kept and reused.
