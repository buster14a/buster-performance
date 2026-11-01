# Tier 1 register allocation over CFGs (#140), 2026-10-31

Evidence for [buster#140](https://github.com/buster14a/buster/issues/140)'s steps 1 to 3: allocation over a CFG
(`tier1_cfg.c`), its independent checker, and its corpus validity and costs. By Claude, at David's request. Step 4, Tier
1's native edge moves, is in [`step4/`](step4/README.md); step 5, Tier 1 through the C driver's `--tier1` with
correctness by #142's programs and SQLite's speedtest1 and its run time against Tier 0 and clang, in
[`step5/`](step5/README.md); and step 6, the selection's walks that made Tier 1's code faster than Tier 0's
(buster#977), in [`step6/`](step6/README.md).

## Revisions

| Role | Commit | Where |
| --- | --- | --- |
| main | `d779ae9f1a92f47f034470354822b75a68cf7b82` | buster's main when the branch was measured |
| head, first measured | `529444f1b10f23ab26dd9733a912869490b41055` | `claude/140-cfg-allocation`, before the allocator's body was compiled twice |
| head, final | `aee8dbb73682a66bcc8c41b1b8df6067e7fad509` | `claude/140-cfg-allocation`; its later commits change docs and merge main |
| local checks | `b9b8bbeadd1ed8aed56b49a7d2f7cee32094c427` | `claude/140-cfg-allocation`'s pushed head (the final head, docs and main's merge) |

Each 9700X tree came from `git archive` of its commit. `receipts-9700x.txt` gives the SHA-256 of each tree's sorted file
hashes and of its `build/compiler`; the same manifests computed locally from `git archive` of the three commits match:
`d3b2e73e...` (main), `f60441e7...` (529444f1), `c91be26b...` (aee8dbb7). The `-g` tree for the profile is a copy of
`aee8dbb7`'s sources (same manifest), built with debug information.

## Hosts

- **9700X** (`receipts-9700x.txt`): AMD Ryzen 7 9700X, Linux 6.18.50, clang 23.1.1, perf 7.2.9; CPU 2 at governor and EPP
  `performance`. Every build and run took the shared lock (`~/buster-fast-bench/exclusive.sh`) for one step each, and every
  timed run was pinned to CPU 2 (`taskset -c 2`). Builds used `BUSTER_DEBUG_INFO=0` but the profile's.
- **Local** (`local/receipts-local.txt`): AMD Ryzen 9 7940HS, Linux 7.3.1, clang 23.1.4. Only deterministic counts come
  from it: corpus results, test outputs and static frame traffic; no timing.

## Commands

The scripts are in `9700x/` and `local/`, as run.

- `9700x/queue.sh MAIN HEAD`: both builds; `benchmark-tier1-allocation` five rounds, main and head in alternating order
  per round, each round one hold; `benchmark-tier1-cfg-source` on the frozen `sqlite3.c` three times and once with
  `--after-scalar 200`; `benchmark-backend-source` on it three times. Run for `72e15296` (`9700x/logs-72e15296/`) and
  `529444f1` (`9700x/logs-529444f1/`).
- `9700x/queue-alloc.sh MAIN HEAD`: the head's build and the five allocator rounds, for `aee8dbb7`
  (`9700x/logs-alloc-head-aee8dbb7/`).
- `9700x/queue-cfg.sh HEAD`: the SQLite runs for `aee8dbb7` (`9700x/logs-cfg-head-aee8dbb7/`).
- `9700x/profile.sh HEAD`: a `-g` build, then `perf record -e cycles:u -c 200003` of `benchmark-tier1-cfg-source --only cfg`
  on `sqlite3.c`; `perf report --sort symbol` and, within `tier1_cfg_allocate_impl`, `--sort srcline`
  (`9700x/logs-profile-head-aee8dbb7/`; `perf.data` itself is left out).
- `local/corpora.sh TREE LOGS`: `test-tier1-cfg-source` on c-testsuite's subset (commit `5c72756`), the frozen
  `sqlite3.c` and musl's units, with the 9700X job's options (`local/corpora-b9b8bbea/`).
- `local/tier1-tests.sh TREE LOGS`: the Tier 1 group of `tools/ci/correctness.tests`, `test-dataflow` and
  `test-dominators` (`local/tier1-tests-b9b8bbea/`; the selector's manifest is cut to its last lines).
- `local/quality.sh TREE OUT`: static frame traffic of `sqlite3.c`'s code: Tier 0's `-c` object (`72e15296`'s build,
  Tier 0 unchanged from main) and clang 23.1.4's at `-O0` and `-O2` (`local/frame-traffic-72e15296.txt`).

The frozen corpora are the 9700X's `/var/lib/buster-9700x/corpora/preprocessor-391e729af658` (the same files locally).

## Results

### The allocator without hints (`benchmark-tier1-allocation`)

Cycles per interval, medians of five processes (each the benchmark's own 21-pass medians); main `d779ae9f` against
head `aee8dbb7`:

| Case | Path | main | head | Change | main's range | head's range |
| --- | --- | ---: | ---: | ---: | --- | --- |
| tiny-fit | vector | 65.57 | 67.48 | +2.9% | 64.36–66.89 | 66.73–68.35 |
| tiny-fit | scalar | 74.31 | 74.08 | −0.3% | 72.85–76.00 | 73.85–75.66 |
| small-fit | vector | 53.54 | 53.13 | −0.8% | 53.18–54.18 | 52.74–53.42 |
| small-fit | scalar | 62.05 | 60.96 | −1.8% | 61.10–62.57 | 60.88–61.20 |
| large-fit | vector | 53.01 | 52.31 | −1.3% | 52.68–53.13 | 52.10–53.47 |
| large-fit | scalar | 60.87 | 59.61 | −2.1% | 60.34–61.83 | 59.50–60.83 |
| large-pressure | vector | 117.13 | 117.02 | −0.1% | 116.82–117.73 | 116.58–117.59 |
| large-pressure | scalar | 117.14 | 117.56 | +0.4% | 116.79–117.50 | 116.83–118.63 |

History, in the earlier logs: with the hint code in the plain loops (`72e15296`), these ran 4% to 15% slower; with only
the loops specialized (`529444f1`), tiny and small inputs still ran 3% to 20% slower. The final head compiles the whole
body twice, without and with hints. In `72e15296`'s run, `benchmark-tier1-cfg-source` joined no function: it lowered
and promoted into one arena, which `ssa_ir_promote` refuses; `529444f1` fixed the harness.

### Compile time on the frozen `sqlite3.c`

2,600 functions (2 left out: values of types the IR model has no class for), 493,470 IR instructions, 396,862 typed
entries; medians of three processes (`9700x/logs-cfg-head-aee8dbb7/`):

| What | ns per IR instruction | cycles per IR instruction | instructions per IR instruction | cycles per typed entry |
| --- | ---: | ---: | ---: | ---: |
| CFG allocation, vector path | 147.1 | 815 | 2,215 | 1,014 |
| CFG allocation, scalar path | 263.7 | 1,462 | 2,408 | 1,817 |
| its interval allocation alone, vector | 44.1 | 245 | 760 | 304 |
| its interval allocation alone, scalar | 160.3 | 888 | 936 | 1,105 |
| Tier 0's whole compile, vector (`benchmark-backend-source`) | | | | 65.7 |
| Tier 0's whole compile, scalar | | | | 177.0 |

The run after 200 ms of scalar work before each vector pass is within 0.3% of these. Tier 0 has no allocation to time
apart: a value's register is its stack depth.

### Where the vector path's cycles go

`perf report --sort symbol` of the vector path's runs (`symbols.txt`; the corpus's preparation is in the same profile, a
small share): `tier1_cfg_allocate_impl` 44.6% of all samples, `tier1_allocate_hinted` 22.6%, `tier1_cfg_input_valid` 8.3%,
`tier1_allocation_filter_fixed` 4.6%, `tier1_allocation_input_valid` 1.4%, `tier1_resolve_moves_*` 1.6%,
`dataflow.c`'s postorder and solve 1.1%. Within `tier1_cfg_allocate_impl` (`cfg-lines.txt`), the hottest lines are the
binary searches of `tier1_cfg_interval_at` (lines 284 to 296: 10.0% of all samples), `tier1_cfg_block_of` (148 to 151:
6.1%) and `tier1_cfg_location` (310 to 327: 2.4%), by which edge staging and validation find a value's interval,
fragment and block.

### Corpus validity (`test-tier1-cfg-source`, local)

| Corpus | Functions | Left out | IR instructions | Intervals | Left to the scalar path | Spilled values | Stores | Reloads | Recomputed | Moves | Split edges |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| c-testsuite's subset | 430 | 8 | 16,274 | 13,390 | 40.5% | 0 | 0 | 0 | 22 | 187 | 34 |
| frozen `sqlite3.c` | 2,602 | 2 | 493,470 | 541,061 | 93.4% | 4,654 | 20,270 | 23,882 | 12,770 | 70,982 | 2,626 |
| frozen musl | 2,883 | 223 | 228,216 | 228,195 | 88.1% | 1,995 | 5,980 | 7,277 | 3,705 | 22,004 | 982 |

Vector path's counts; every allocated function passes `tier1_cfg_verify` on both paths, with no refusal, and the scalar
path spills the same values with the same stores and reloads (moves within 0.4%).

### Frame traffic on `sqlite3.c` (static, local)

| Code | Instructions | With an rsp/rbp memory operand (not `lea`) | Spill annotations |
| --- | ---: | ---: | --- |
| Tier 0, `-c` | 383,611 | 35,100 | |
| clang -O0 | 236,042 | 100,907 | 2,998 spills, 2,260 reloads |
| clang -O2 | 257,753 | 23,161 | 3,673 + 604 folded spills, 9,944 + 1,111 folded reloads |
| Tier 1's allocation, the IR model's | | 61,994 | 20,270 stores, 23,882 reloads, 17,842 frame objects' accesses |

clang compiled with `-D__NO_INLINE__` at both levels: the frozen headers have no `bits/stdio.h`, which glibc includes for
its extern inlines when optimizing. Tier 1's row is its allocation's stores and reloads and the promoted IR's loads and
stores of the frame objects SSA kept in memory, not emitted code.

## Limitations

- The CFG allocation's corpora are the shared IR's functions through `tier1_cfg_ir.c`'s machine model, not the selector's
  plans: Tier 1's selector doesn't yet take general source functions (#141). The frame traffic row is the model's.
- No run time: Tier 1 doesn't compile these programs end to end yet (#138).
- The local machine is Zen 4; it gives counts only.
- The profile's shares include the benchmark's one-time preparation (both paths' allocation and checking of each function
  once, besides the timed runs).

🤖 Generated with [Claude Code](https://claude.com/claude-code)
