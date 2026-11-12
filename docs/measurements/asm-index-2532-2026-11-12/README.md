# The asm matcher's index, baked: musl's command main against head (2026-11-12)

The measurements of [buster#2532](https://github.com/buster14a/buster/issues/2532)'s fix. `check_asm_matches`
(`c_check_program_asm.c`) made the `X86MatchIndex` that asm templates' instructions are matched against once per
lowering of a unit with asm statements, though the index depends on the form table alone. The fix makes it a static of
the checker's unit, `check_asm_index`, built by `check_asm_index_initialize` and baked into the executable with the
backend's tables (`baked.c`, #590), so that no process makes it; where it isn't baked (a PIE, `BUSTER_BAKE=0`), a
command of several units makes it once before its lanes start, and a unit's planning otherwise at its first asm
statement. The record that found it is [`file-scope-design-672-2026-11-12`](../file-scope-design-672-2026-11-12/README.md),
section 5.

- **Trees:** `main`, buster `0af27a3096f9bd96334f27943dfc50918f58bc17` (main on 12 November), and `head`, buster
  `f48eafededc32b99a5f1f8f8ebdd20fdd3018303` (the fix's commit, on branch `claude/happy-dirac-d6yehj`: main and that one
  commit), each a clone built on the host by `./build.sh` (Release, `-O3 -march=native`, debug information, baked):
  `raw/build-main.log`, `raw/build-head2.log`. The executables' SHA-256 are in `raw/musl/compiler-*.sha256` and
  `env.txt`. A first hold of every measurement (`raw/prelim/`) ran a build of the same change before it was committed
  (`raw/prelim/head.diff`, built by `raw/build-head.log`), whose sources differ from `f48eafed` in one comment's text
  alone (the figures this record replaced); its tables are `tables/prelim/`.
- **Host:** the Ryzen 7 9700X (`benchpress`), Linux 6.18.50, clang 23.1.1, perf 7.2.9; transparent huge pages
  `always`, the address space's randomization on (2). `env.txt` has the CPUs, the governors and every script's hash.
- **Every run** was one hold of the machine's lock (`scripts/lock.sh`, through `scripts/queue.sh`, whose log is
  `raw/queue.log`), pinned to CPU 2, whose SMT sibling is offline and whose governor is `performance`. Each script
  writes the lock's own line for its hold first (`raw/*/holder.txt`). The build logs here have the lock's waiting lines
  removed (they named other sessions' holds).
- **Workloads:**
  - **musl:** the frozen corpus's musl (`/var/lib/buster-9700x/corpora/preprocessor-391e729af658`), the first source
    of each base name, 1,336 units (`raw/musl-units.txt`), as one command on one lane (`-c --lanes 1`), with the
    earlier records' options (`scripts/common.sh`). 537 of the units have an asm statement in their preprocessed text
    (`raw/units-with-asm.txt`, `scripts/units.sh`), most through `syscall_arch.h`'s inline functions.
  - **`sqlite3.c`:** `-c` of the frozen corpus's `sqlite3.c` with the 9700X job's `compile_time` options. It has no
    asm statement.
- **`scripts/tables.sh`** makes `tables/` from `raw/` (`scripts/reduce.c`, the reducer, in C); its stage table's part
  was fixed after the runs (its pattern matched nothing) and that table made from `raw/` by the fixed script.

## 1. musl's command

`scripts/bench.sh 11`: 11 rounds, each way twice a round under `perf stat`, with the address space's randomization off
(`setarch -R`) and as it is, the ways' order alternating from round to round, with `/proc/vmstat`'s huge-page counts
around each run. Every one of the 44 runs is in the first page state of the earlier record's section 13 (311 to 316
huge pages given at a fault, none refused, 343,032 to 343,097 page faults), so the medians compare runs of one state
(`tables/musl.tsv`):

| | page faults | user cycles | kernel cycles | both | user instructions | CPU ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| main, randomization off | 343,092 | 4,791.7 M | 1,101.4 M | 5,893.6 M | 12,789.7 M | 1,064.19 |
| head, randomization off | 343,094 | 4,383.6 M | 1,099.3 M | 5,487.5 M | 11,515.9 M | 991.44 |
| main, randomized | 343,034 | 4,792.6 M | 1,104.5 M | 5,897.1 M | 12,789.5 M | 1,065.01 |
| head, randomized | 343,037 | 4,379.6 M | 1,102.3 M | 5,481.5 M | 11,515.8 M | 989.88 |

With the randomization off, head takes 408 M fewer user cycles (8.5% of main's), 1,274 M fewer user instructions
(10.0%) and 72.8 ms less CPU time: **1.073 times faster** (1.074 by cycles; 1.076 randomized). Kernel cycles and page
faults are unchanged (the index lived on the lowering's scratch arena, whose pages each unit reused). That is 0.76
million user cycles and 2.37 million instructions for each unit with asm statements. Every round is within 0.3% of
its way's median CPU time but three randomized ones: the first of each way (+1.9% and +2.4%, each the hold's first run
of its way with the randomization on) and head's ninth (+1.7%).

`raw/prelim/musl` is the first hold, 7 rounds each way the same two ways (`tables/prelim/musl.tsv`): 1,065.77 against
995.86 ms with the randomization off, 389 M user cycles fewer, 1.070 times; also every run in the first page state.
The two holds' differences agree within 5%.

**All 1,336 objects are the same bytes** both ways (`raw/musl/objects.txt`, the last round's), and every run's
diagnostics (the corpus's warnings) are the same bytes, in both holds: 72 runs, one MD5 (`raw/*/musl/stderr.md5`, one
copy kept).

## 2. Where the cycles went

`scripts/profile.sh`: one `perf record` of the command each way (user cycles, a sample every 100,000, randomization
off). `raw/profile/matcher-*.txt` has the matcher's functions and the C library's string functions it called:

| function | main | head |
| --- | ---: | ---: |
| `x86_match_initialize` (its split part) | 2.54% | none |
| `x86_match_bucket` | 1.87% | 0.00% |
| `__strcmp_evex` | 1.73% | none |
| `__strchr_evex512` | 0.67% | none |
| `x86_match_range`, `x86_match_suffix_width` | 0.34% | none |
| `__memcmp_evex_movbe` | 2.10% | 1.66% |
| samples (cycles) | 49.7 K (4,966 M) | 45.5 K (4,548 M) |

The index's making is gone from head's profile: `x86_match_initialize` has no sample, and `x86_match_bucket` (which the
construction called for every admitted form) is under 0.01% of the samples, the templates' own lookups. The earlier
record measured the same family at `ecaf57b5`: 130 M, 97 M and 99 M cycles for the first three.

`--time-stages` (`scripts/stages.sh`, 3 runs each way, randomization off, `tables/stages.tsv`) reports a command of
several units' run as one stage, `lanes`, so it gives the command's time alone: 1,079.0 and 1,084.6 ms of main's
`lanes` against 1,004.3 to 1,006.7 ms of head's. Main's first run took 1,570.4 ms: its report says the host was busy as
it started (`huge-pages busy`: the process's arenas took base pages, 418,437 minor faults); its CPU time was 1,124 ms.

## 3. `sqlite3.c`

`scripts/sqlite.sh 11`: 11 rounds of `-c sqlite3.c` each way, alternating, randomization off (`tables/sqlite.tsv`):

| | page faults | user cycles | kernel cycles | both | user instructions | CPU ms |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| main | 7,336 | 599.3 M | 84.4 M | 684.0 M | 1,350.95 M | 123.35 |
| head | 7,336 | 600.9 M | 83.9 M | 684.3 M | 1,350.95 M | 123.43 |

Unchanged: the same user instructions (1,350,950,607 to 1,350,950,689 a run, both ways), the same page faults, and CPU
time and all cycles within 0.1%. Head's user cycles are 0.27% more here and 0.25% more in the first hold (`tables/prelim/sqlite.tsv`: 603.0 M
against 601.5 M, and 124.03 against 124.10 ms) with the same instructions, which is the size of a code or data
placement's effect; it wasn't looked into. The object is the same bytes (`raw/sqlite/objects.txt`).

## 4. Tests, and the index where it isn't baked

On head (`raw/tests/`, each test a hold of its own): `test-baked-tables` (the section, 6,564,844 bytes against main's
6,002,412, "baked, the same as built"; the index is 562,432 bytes of it), `test-checker-asm` (1,019 checks),
`test-checker --program-asm` (4,220 checks) and `test-check-units` (2,300 checks), no failure.
`test-checker-driver --asm-definitions-only` has the same 4 failures on main and head, with the same output: clang
23.1.1's objects here reference `__stack_chk_fail` (the harness expects clang 23.1.4, CI's).

`scripts/unbaked.sh` (`raw/unbaked/`) relinked head with `BUSTER_BAKE=0`, whose index is made when it runs: once before
the lanes start in a command of several units. `test-baked-tables` says "not baked (built when it runs)", and
`test-checker-asm` and `test-check-units` pass (2,302 checks). musl's command on eight lanes by it and by main gives all
1,336 objects the same bytes. Its profile on one lane has `x86_match_initialize` at 0.01% of 45,500 samples: made once.
The script then baked head again, the same file as measured (`raw/unbaked/compiler-baked-again.sha256`).

## Limits

- **One host, one day, two revisions.** The tables compare main at `0af27a30` with that commit plus the fix, in one
  hold each; the first hold (`raw/prelim/`) repeats them.
- **main has moved since the earlier record.** At `ecaf57b5` its command took 1,003.1 ms of CPU and 4,457 M user
  cycles (the earlier record's section 1, medians of rounds in the first page state); at `0af27a30`, 1,064.2 ms and
  4,792 M, in the same state. Which of the commits between them added the 6% wasn't looked for. The fix's gain here, 408 M cycles, is a
  little under the earlier record's 441 M (its rounds) and 443 M (its stage counters).
- **The randomization's other state isn't measured:** no run of either way here was given no huge pages, so the table
  says nothing about that state.
- **Profiles are one run each way.**
- No run used more than one lane but `unbaked.sh`'s two eight-lane runs, which compare objects only.
- **The first hold's scripts failed once.** `stages.sh`, `sqlite.sh` and `profile.sh` first ran with `common.sh`
  naming the compilers from the directory a run entered, so nothing ran (status 127, the holds of no time in
  `raw/prelim/queue.log`); `common.sh` was fixed and they ran again, and `raw/prelim/` has those runs. `bench.sh`
  named them before entering it and was unaffected.

## Files

- `env.txt`: the host and the identities (the head tree's commit, the executables' and the scripts' hashes as they
  ran); `raw/prelim/env.txt` is the first hold's.
- `scripts/`: `lock.sh` (the hold), `queue.sh` (holds in turn), `common.sh` (the corpus, the options and the trees),
  `env.sh`, `units.sh`, `bench.sh`, `stages.sh`, `sqlite.sh`, `profile.sh`, `tests.sh`, `unbaked.sh`, `tables.sh` and
  `reduce.c` (the reducer), and `package.sh`, which made this directory from the host's.
- `raw/`: every run's output as written, by measurement, but each command's diagnostics, kept once with every run's MD5
  (`stderr.md5`); a text file over 32 KB is gzipped. `raw/prelim/`: the first hold's.
- `tables/`: the reductions; `tables/prelim/` the first hold's.
