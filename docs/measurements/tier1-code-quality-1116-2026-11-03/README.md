# Tier 1's code quality on Lua after #1117 (buster#1116), 2026-11-03

Evidence for buster pull request [#1159](https://github.com/buster14a/buster/pull/1159), "Tier 1: no 32-bit self-moves
around calls, call saves kept across runs of calls, rbp callee-saved (#1116)", after its merge with #1117 (Tier 1's
floats, stack arguments and ABI records). The record of 2026-11-02 (`../tier1-code-quality-1116-2026-11-02`) measured
the pull request before that merge, when `luaV_execute` was still Tier 0's; this one measures the merged head.

## Revisions

- base: buster `b70deb47`, main with #1117.
- head: buster `6e1e6121`, the pull request with `b70deb47` merged in.

## Local: Lua 5.4.8's code by `--tier1 -c` (`local/`)

The compiler's output doesn't depend on the host, so the counts come from the owner's minipc (`local/host.txt`), each
tree built from `git archive` of its commit (`local/compilers.sha256`). The scripts are the earlier record's:

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

The results are in `local/lua-counts/main-b70deb47` and `local/lua-counts/head-6e1e6121`:

| | base | head |
| --- | ---: | ---: |
| `.text` (clang -O0's: 273,461) | 289,580 | 260,789 |
| Instructions | 84,422 | 76,773 |
| `mov r32, same` | 4,656 | 176 |
| … before a call / after a call in `eax` / elsewhere | 3,029 / 1,374 / 253 | 0 / 0 / 176 |
| Reload-then-store pairs | 135 | 14 |
| `call_stores` / `call_loads` | 5,956 / 5,956 | 3,165 / 5,207 |
| Records | 76,475 | 68,406 |
| Tier 1's 1,104 compiled functions, bytes against clang -O0's 265,499 | 281,633 (1.061×) | 252,422 (0.951×) |

Tier 1 compiles all 1,104 functions at both trees, with no refusal. Each tree's objects have their hashes in
`objects.sha256`, the same as an earlier run's.

## 9700X: base against head (`9700x/`)

The host is the Ryzen 7 9700X (benchpress; `9700x/host.txt`: kernel, clang, perf, CPU 2's governor and EPP). Each tree
is `git archive` of its commit (`9700x/commits.txt`), built by `BUSTER_DEBUG_INFO=0 ./build.sh` (`9700x/logs-build/`,
`9700x/compilers.sha256`). Every step held `~/buster-fast-bench/exclusive.sh` once, with owner `1116-claude`, and every
timed run was pinned to CPU 2. The scripts are in `9700x/`:

- `common.sh`, `build.sh`, `lua.sh`, `programs.sh`, `campaign.sh`, `campaign-tally.sh` and `all.sh`, as in the earlier
  record;
- `stages.sh`: 11 alternating `--time-stages` runs of each tree's `--tier1 -c` of `sqlite3.c`, then `perf stat` of 5 runs
  with branch misses and L1 instruction-cache misses, one hold;
- `profile.sh`: `perf record` of cycles over 5 runs of each tree's, one hold.

Logs keep only the lines the scripts and tools write. The lock's waiting messages, which name other sessions, are
removed from `compile-tier1-ab.log` and the campaign's chunk logs.

### Lua 5.4.8's five scripts by `--tier1` (`9700x/lua-6e1e6121/`)

Each prints clang -O0's output at both trees (`compare.txt`, `status.txt`). `times.txt` holds 11 rounds of runs, in
microseconds from before a run's fork to after its wait; the medians below leave out round 0, the warm-up. Instructions
and cycles are in `stat-*.txt`. Both trees compile `luaV_execute` by Tier 1 (`report-lvm-*.txt`).

| Script | base median, ms | head median, ms | Δ | Ranges | Instructions, base → head |
| --- | ---: | ---: | ---: | --- | --- |
| calls | 31.45 | 31.45 | 0.0% | 31.27–32.02 / 31.34–33.41 | 942.7 M → 942.7 M |
| tables | 50.69 | 50.38 | −0.6% | 50.34–51.29 / 49.80–50.72 | 1,511.7 M → 1,466.5 M (−3.0%) |
| strings | 53.82 | 53.15 | −1.3% | 53.54–54.23 / 52.87–53.69 | 1,251.7 M → 1,203.9 M (−3.8%) |
| arithmetic | 57.78 | 58.18 | +0.7% | 57.60–58.12 / 58.02–60.08 | 2,158.3 M → 2,158.0 M |
| closures | 71.67 | 72.12 | +0.6% | 70.82–73.62 / 71.54–73.57 | 1,891.6 M → 1,887.7 M |

The interpreter's loop runs the same instructions at both trees on calls, arithmetic and closures. Their time moves by
less than 1%, in both directions.

### The frozen `sqlite3.c` (`9700x/programs-t-6e1e6121/`)

`compile-tier1-ab.log` holds `ab --rounds 5` of `time-runs --runs 21` of each tree's `--tier1 -c`:

- the rounds' medians are 448.88–449.02 ms at base and 452.17–452.74 ms at head;
- the medians of those are 448.98 and 452.42 ms (+0.77%);
- instructions are 5,895.33 M at base and 5,905.18 M at head (+0.17%); cycles 2,385.9 M and 2,405.1 M (+0.80%).

`compile-stat-*.csv` has three `perf stat -r 11` holds per tree. `reports/` has each tree's `--tier1-report` and
`--tier1-refusals`:

| | base | head |
| --- | ---: | ---: |
| Tier 1's functions | 2,666 of 2,668 | 2,666 of 2,668 |
| Records | 346,741 | 309,187 |
| `call_stores` / `call_loads` | 28,027 / 28,027 | 15,079 / 21,384 |

The two refusals are `sqlite3Multiply128` and `sqlite3Multiply160`, `selection const` (a 128-bit constant) at both
trees. No call is refused, so the call kinds have no count.

### Where the compile's time goes (`9700x/stages-t-6e1e6121/`)

`stages-*.txt` holds each run's `--time-stages`. The medians of 11 runs give 448.17 ms at base and 452.09 ms at head,
and the stage named `tier0`, which holds Tier 1's compile under `--tier1`, takes 3.50 ms of the 3.92 more: 335.80
against 339.30. No other stage moves by more than 0.07 ms.

`stat-*.csv`: branch misses go from 34.58 M to 34.91 M (+0.95%), and L1 instruction-cache misses from 7.51 M to 7.34 M.

`profile-*.txt` holds `perf report` by symbol of `profile.sh`'s samples (60,426 at base, 60,906 at head, +0.79%). The
emitter's own functions grow by 215 samples: `tier1_emit_cfg_records` (+102), `tier1_emit_cfg_function` (+100) and the
new `tier1_emit_owed` (+47), less `tier1_emit_call` (−34). The rest of the growth is spread over the allocator
(`tier1_allocate_hinted` +88, `tier1_cfg_allocate_impl` +85), which now has `rbp` for values live across calls, and
over functions whose work this pull request doesn't change (`ssa_ir_promote_path` +93, `ir_check_dominance` +55),
with others shrinking as much (`tier1_frame_plan_path` −74, `ir_build_uses` −72). A symbol's samples vary by about
their square root between runs, so only the totals and the emitter's three functions are clear of that.

### speedtest1 (`9700x/programs-t-6e1e6121/st/`)

speedtest1 is #136's unity harness on that `sqlite3.c`, run with `--shrink-memory --reprepare --stats --journal wal
--size 5 --heap 40000000 64 --testset mix1`:

- the builds are base's and head's `--tier1` and head's Tier 0;
- each build ran once with `--verify` (`verify-*.txt`), all giving hash `1248168 a7fa3957840af6d608d53fcdd57a125b35385b9d1e813739`;
- 11 rounds ran the three in a rotating order, a round one hold, each from a fresh database on tmpfs (`run.times`: round,
  build, microseconds, exit status, speedtest1's TOTAL); the medians leave out round 0;
- `stat-*.txt` has one `perf stat` each.

| Build | Median | Range | Instructions | Cycles |
| --- | ---: | --- | ---: | ---: |
| base, `--tier1` | 207.73 ms | 207.27–209.00 | 3,865.1 M | 1,055.3 M |
| head, `--tier1` | 205.08 ms (−1.3%) | 204.91–206.57 | 3,743.1 M (−3.2%) | 1,037.0 M (−1.7%) |
| head, Tier 0 | 256.39 ms | 255.37–257.46 | 5,694.2 M | 1,324.4 M |

In speedtest1's build, Tier 1 compiles 2,707 of 2,709 functions at both trees (`build-t1base.txt`, `build-t1.txt`).
Records go from 359,685 to 320,806, and `call_stores` from 28,446 to 15,247.

### #142's campaign at head (`9700x/diff-t-6e1e6121/`)

`campaign.sh t-6e1e6121 6e1e6121 11200 11239` ran `test-differential` with Buster's Tier 0 and
`--tier1 -fno-asynchronous-unwind-tables` against clang -O0 and -O2:

- Csmith `0cdc710`, YARPGen `1adb290`;
- two programs per generator a hold, a 30 s timeout;
- `campaign-tally.sh` wrote `campaign.tsv`, a line per program with each step's status.

80 programs ran and 63 passed at both tiers. The 17 others fail in clang's own steps, none in Buster's:

- 5 Csmith programs time out at run under clang -O0 and both of Buster's tiers.
- 1 Csmith program passes clang's output limit at compile. Buster compiles it, and its run times out at both tiers.
- 11 YARPGen programs overflow clang -O0's relocations at link. Buster refuses 9 of them at both tiers: 7 for the same
  overflow ("the relocation's value does not fit its field") and 2 for a call of more than 239 arguments. It compiles
  and runs the other 2.

The generated programs and each step's output stay on the host.

## The call-save bookkeeping's cost over placements (`9700x/placements/`)

The A/B above times one executable per tree, and a placement of the code moves a compile by more than this change does
(`docs/profiling.md`, "Builds over their code's placements and copies"). So the bookkeeping's cost was measured again,
after a change that makes it cheaper, as the profiling guide says:

- main: buster `703ae9f5`, main when this ran;
- pr: buster `8b07e868`, the pull request with `703ae9f5` merged in;
- new: buster `3b195d57`, the pull request's next commit. It looks a definition's interval up once instead of twice while
  loads are owed, keeps the 16 call-save rows in one vector, compared and blended whole, and walks only the owed
  registers' set bits. It emits the same code: Lua's 34 objects have `6e1e6121`'s hashes.

`shifts.sh` built each tree by `./build.sh shifts` with `main_unit_backend.c`'s code at six shifts over a page (0 to 3,456
bytes; its `.text` is aligned to 64), one hold each (`logs-build/shifts-*.log`; the 18 executables' hashes, all
different, in `placements/shifts.sha256`). `placements.sh` ran `ab --rounds 3` of `time-runs --runs 2 --copies 2` over the
four builds' placements, main twice, `--tier1 -c` of the frozen `sqlite3.c`, a round one hold, CPU 2
(`placements/ab.log`, which keeps only the lines `ab` and `time-runs` write).

| Build | Instructions | User cycles, rounds 1 / 2 / 3, against main | Range over placements |
| --- | ---: | --- | --- |
| main | 5,822.96 M | 2,375.4 / 2,374.7 / 2,373.4 M | |
| pr | 5,832.81 M (+0.169%) | +0.48% / +0.51% / +0.51% | +0.26% to +1.07% |
| new | 5,828.57 M (+0.096%) | +0.30% / +0.30% / +0.36% | +0.13% to +0.64% |
| main again | 5,822.96 M | −0.02% / −0.07% / −0.02% | −0.28% to +0.30% |

Over all 72 runs of each, the user cycles' medians are 2,374.2 M (main), 2,386.1 M (pr, +0.50%), 2,382.0 M (new,
+0.33%) and 2,373.1 M (main again, −0.05%). The single-executable A/B's +0.77% for `6e1e6121` was part placement: over
placements, the pull request cost +0.5% before this change and +0.3% after it.

## What the remaining cost is (`local/probes/`)

Two throwaway builds of `3b195d57` (their diffs in `scan-twice.diff` and `no-rbp.diff`, never committed) price the
pull request's two compile-time costs on the owner's minipc. `stat3.sh` runs 3 rounds of `perf stat -r 5`, pinned to
one CPU, of each build's `--tier1 -c` of the frozen `sqlite3.c` (`sqlite3.sha256`), the builds rotating (`stat-*.csv`).
The instruction counts are exact, and the compiler's output doesn't depend on the host. The cycles are not usable there:
the machine was building at the time, and main ran slower than the head.

| Build | Instructions | Against `3b195d57` |
| --- | ---: | ---: |
| main `703ae9f5` | 5,812.84 M | −5.57 M |
| `3b195d57` | 5,818.41 M | |
| the scan for owed loads run twice at each node | 5,821.50 M | +3.09 M (+0.053%) |
| `rbp` not callee-saved | 5,814.69 M | −3.72 M |

- **The scan for owed loads** (`tier1_emit_owed`) costs 3.09 M instructions in all, 0.053% of the compile. The second
  call's result goes to a volatile variable, so it isn't removed, and it runs with branches the first call has just
  trained. So this prices the scan's instructions, not any branch misses of its own. A bound computed at each call,
  so that nodes before the first that can need a load back skip the scan, would take two binary searches for each of
  the 28,027 registers the calls save. That is most of what it would save, so it isn't worth doing.
- **`rbp` as a sixth callee-saved register** costs 3.72 M instructions, in allocation with one more register.
  `report-*.txt` holds what it buys in `sqlite3.c`: 309,182 records against 314,228, 11,265 spill stores against
  12,900, 13,855 spill loads against 15,385, 15,079 call stores against 16,156 and 21,382 call loads against 22,810.
- Fewer records save some of both back downstream, so the pull request's total is +5.57 M.
