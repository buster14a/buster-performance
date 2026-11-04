# Tier 1's code quality on Lua (buster#1116), 2026-11-02

Evidence for buster pull request [#1159](https://github.com/buster14a/buster/pull/1159), "Tier 1: no 32-bit self-moves
around calls, call saves kept across runs of calls, rbp callee-saved (#1116)". It takes
[#1116](https://github.com/buster14a/buster/issues/1116)'s two patterns on Lua 5.4.8:

- the 32-bit self-moves around calls: an `I32`'s upper half is now unspecified in Tier 1's registers;
- the values live across calls, which were saved and reloaded call by call: a call's loads are now owed until something
  needs them, a row isn't stored again while it holds its value, and rbp is a sixth callee-saved register.

## Revisions

- base: buster `3ce71ec3` (main when the work started).
- head: buster `844c2914`, the pull request's second commit; `8728dac7` is its first. The third, `ce6cd296`, the
  reviews' tests, comments and refusal report, changes no code: Lua 5.4.8's 34 objects by `--tier1 -c` have the same
  `sha256sum` at `ce6cd296` and `844c2914` (checked on the minipc), so the 9700X numbers measure the pull request's code.
- Main later moved to `dac5b770` (#1092, #1136 and #1139: the `-g` path's source metadata and CI), which the branch
  doesn't hold. None of it is on `--tier1 -c`'s path without `-g`.

## Local: Lua 5.4.8's code by `--tier1 -c` (`local/`)

The compiler's output doesn't depend on the host, so the counts come from the owner's minipc (`local/host.txt`), each
tree built from `git archive` of its commit (`local/compilers.sha256`).

- `measure.sh COMPILER DIR` compiles each of Lua 5.4.8's 34 sources (`local/lua-5.4.8-sources.sha256`) with `--tier1
  --tier1-report --tier1-refusals -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c`. It sums `.text` and objdumps the
  objects, counting instructions, `mov r32, same` and a reload of an `(%rsp)` or `(%rbp)` slot followed at once by a
  store of the same register back to it.
- `classify.sh DIR` splits the self-moves by position (before a call, after a call in `eax`, elsewhere) and sums the
  reports' counters.
- `compare.sh DIR` sums the bytes (`nm -S`) of the functions Tier 1 compiled (not in `--tier1-refusals`) that clang
  23.1.4 -O0 also emits, against clang's (`local/lua-counts/clang0-objects.sha256`).
- `lua-run.sh COMPILER DIR` links the `--tier1 -c` objects with clang and runs `local/lua-scripts/*.lua`, comparing each
  output and status with clang -O0's build.

The results are in `local/lua-counts/m-base` and `local/lua-counts/m-head3` (head `844c2914`):

| | base | head |
| --- | ---: | ---: |
| `.text` | 289,595 | 265,526 |
| Instructions | 86,089 | 79,736 |
| `mov r32, same` | 3,872 | 187 |
| Reload-then-store pairs (Tier 0's fallbacks among them) | 116 (13) | 21 (12) |
| `call_stores` / `call_loads` | 4,940 / 4,940 | 2,575 / 4,289 |
| Tier 1's 988 compiled functions, bytes against clang -O0's 192,242 | 200,518 | 176,082 |

Each tree's objects have their hashes in `objects.sha256`; a second run of `measure.sh` gave the same code.

## 9700X: base against head (`9700x/`)

The host is the Ryzen 7 9700X (benchpress; `9700x/host.txt`: kernel, clang, perf, CPU 2's governor and EPP). Each tree
is `git archive` of its commit (`9700x/commits.txt`), built by `BUSTER_DEBUG_INFO=0 ./build.sh` (`9700x/logs-build/`,
`9700x/compilers.sha256`). Every step held `~/buster-fast-bench/exclusive.sh` once, with owner `1116-claude`, and every
timed run was pinned to CPU 2. The scripts are in `9700x/`:

- `common.sh`: paths, options and lock metadata;
- `build.sh`;
- `lua.sh`, the #141 takeover's: Lua 5.4.8's interpreter by each tree's `--tier1`, the outputs against clang -O0's,
  then 11 rounds in a rotating order, a round one hold, and `perf stat` of each script;
- `programs.sh`: `sqlite3.c`'s reports, `ab` of its `--tier1 -c`, `perf stat`, and speedtest1, a round one hold.
  `programs.sh.orig` is the earlier version, a run one hold, which the contended lock made too slow; it never ran;
- `campaign.sh` and `campaign-tally.sh`.

Logs keep only the lines the scripts and tools write. The lock's waiting messages, which name other sessions, are
removed from `compile-tier1-ab.log` and the campaign's chunk logs.

### Lua 5.4.8's five scripts by `--tier1` (`9700x/lua-844c2914/`)

Each prints clang -O0's output at both trees (`compare.txt`, `status.txt`). `times.txt` holds the runs, in
microseconds from before a run's fork to after its wait; instructions and cycles are in `stat-*.txt`.

| Script | base median, ms | head median, ms | Δ | Ranges | Instructions, base → head |
| --- | ---: | ---: | ---: | --- | --- |
| calls | 31.61 | 31.61 | 0.0% | 31.37–33.95 / 31.36–36.81 | 1,083.9 M → 1,078.1 M |
| tables | 56.24 | 56.12 | −0.2% | 55.91–57.09 / 55.66–56.85 | 1,709.5 M → 1,661.1 M |
| strings | 53.71 | 51.97 | −3.2% | 53.00–54.58 / 51.78–52.66 | 1,261.3 M → 1,216.6 M |
| arithmetic | 67.60 | 67.86 | +0.4% | 67.53–69.08 / 67.70–70.64 | 2,450.4 M → 2,450.4 M |
| closures | 75.61 | 76.15 | +0.7% | 74.99–78.51 / 75.41–78.51 | 2,054.9 M → 2,035.6 M |

On base, `luaV_execute` is Tier 0's (refused for a floating call), so the interpreter loop is unchanged by this pull
request.

### The frozen `sqlite3.c` (`9700x/programs-t-844c2914/`)

`compile-tier1-ab.log` holds `ab --rounds 5` of `time-runs --runs 21` of each tree's `--tier1 -c`:

- the rounds' medians are 368.00–368.85 ms at base and 368.81–369.21 ms at head;
- the medians of those are 368.09 and 368.93 ms (+0.23%);
- instructions are 4,748.98 M at base and 4,753.87 M at head (+0.10%).

`compile-stat-*.csv` has three `perf stat -r 11` holds per tree. `reports/` has each tree's `--tier1-report`:

| | base | head |
| --- | ---: | ---: |
| Tier 1's functions | 2,409 | 2,409 |
| Records | 204,528 | 187,250 |
| `call_stores` / `call_loads` | 13,929 / 13,929 | 8,370 / 11,954 |

### speedtest1 (`9700x/programs-t-844c2914/st/`)

speedtest1 is #136's unity harness on that `sqlite3.c`, run with `--shrink-memory --reprepare --stats --journal wal
--size 5 --heap 40000000 64 --testset mix1`:

- the builds are base's and head's `--tier1` and head's Tier 0;
- each build ran once with `--verify` (`verify-*.txt`), all giving hash `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`;
- 11 rounds ran the three in a rotating order, a round one hold, each from a fresh database on tmpfs (`run.times`: round,
  build, microseconds, exit status, speedtest1's TOTAL);
- `stat-*.txt` has one `perf stat` each.

| Build | Median | Range | Instructions | Cycles |
| --- | ---: | --- | ---: | ---: |
| base, `--tier1` | 216.19 ms | 214.76–220.78 | 4,049.8 M | 1,092.7 M |
| head, `--tier1` | 213.66 ms | 212.46–217.00 | 3,968.4 M | 1,077.8 M |
| head, Tier 0 | 256.93 ms | 255.84–259.09 | 5,694.2 M | 1,319.8 M |

In speedtest1's build, Tier 1 compiles 2,444 functions at both trees (`build-t1base.txt`, `build-t1.txt`). Records
go from 209,449 to 191,632 and `call_stores` from 14,093 to 8,469.

### #142's campaign at head (`9700x/diff-t-844c2914/`)

`campaign.sh t-844c2914 844c2914 11160 11199` ran `test-differential` with Buster's Tier 0 and
`--tier1 -fno-asynchronous-unwind-tables` against clang -O0 and -O2:

- Csmith `0cdc710`, YARPGen `1adb290`;
- two programs per generator a hold, a 30 s timeout;
- `campaign-tally.sh` wrote `campaign.tsv`, a line per program with each step's status.

80 programs ran and 64 passed at both tiers. The 16 others fail in clang's own steps, none in Buster's:

- 6 Csmith programs time out at run under all four builds.
- 9 YARPGen programs overflow clang -O0's relocations at link. Buster refuses 6 of them at both tiers: 5 for the same
  overflow ("the relocation's value does not fit its field") and 1 for a call of more than 239 arguments. It compiles
  and runs the other 3.
- 1 Csmith program passes clang's output limit at compile; Buster compiles and runs it.

The generated programs and each step's output stay on the host.
