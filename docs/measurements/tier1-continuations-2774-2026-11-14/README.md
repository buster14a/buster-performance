# Tier 1 allocation: evict a value that continues in its slot first (#2774), 2026-11-14

Evidence for [buster#2774](https://github.com/buster14a/buster/issues/2774) and its pull request
[buster#2787](https://github.com/buster14a/buster/pull/2787). By Claude in David's directed session
([the session](https://claude.ai/code/session_01NNmNQuZYbFXgNM7JAQkaF7)).

With #2773 (#2768), Lua's fetch after `OP_GETTABUP`'s call held all six callee-saved registers when `i = *pc` was
defined. No candidate had a use left, so the scan with required uses evicted the one with the fewest uses, `trap`'s phi,
and the edge into the dispatch stored `cl`, moved `i` into `cl`'s `r13` and reloaded `trap`. The change has two parts:

- an interval evicted where it starts opens in its slot: Lua's first handler gave `cl`'s entry range `r13` and lost it
  at once to `i`, and the dispatch's join, which takes that handler's openings, took `r13` for `cl` in turn;
- `tier1_cfg.c` names each live-out range's continuation, the range whose opening is the value's place at its block's
  first successor's entry (or the range that entry takes its opening from, as the dispatch's join takes the first
  handler's), and a victim with no use left whose continuation opened in its slot goes first.

buster's `docs/tier1-allocation.md`, "Victims that continue in their slots (#2774)", has the rule.

## Revisions

| Role | What |
| --- | --- |
| base | `9e4809c07aa8951388b18f72ed6d6b7eb28b3a54`: buster's main `ee74e8e4` with #2773's head `f485812b` merged, the branch's first commit |
| head | `6f31185156b30aeb82536e0fefa47962ac420fde`, the branch's code (its `23d0c3cf` allocates the same, byte for byte); after main moved, `be6bfc783d29f316104b0755bd13aeca89d464bb`, that code merged with #2773's last head and main |
| variants | base with `scripts/variants.patch`, whose environment switches select v1 to v7; v8 is head with `scripts/last-block.patch` |

## 1. Dynamic instruction counts (callgrind)

**Host.** A cloud container, not the 9700X (`counts/identities.txt`): an Intel Xeon with AVX-512, valgrind 3.22.0, GNU
objdump 2.42, clang 23.1.6. The compilers are `build.sh --config Release` with `BUSTER_HOST_ARCH=x86-64` and
`BUSTER_DEBUG_INFO=0`, CI's staged toolchain.

**Inputs.** #1189's and #1217's, by their SHA-256 (`counts/identities.txt`): Lua 5.4.8 and the five scripts of
buster-performance's `tier1-reciprocal-141-2026-11-01/9700x/lua`; `sqlite3.c` built from SQLite `ccc132c5` (its
amalgamation is the frozen one, `0a409f16…`) and that commit's `speedtest1.c`, as one unit, with speedtest1's `--size 5`
mix. Each Lua build has a fixed string-hash seed (`-Dluai_makeseed(L)=0x2768u`).

**Tools.** `scripts/` holds #2768's scripts with this session's paths (`buildlua.sh`, `luacount.sh`, `st.sh`,
`moves.sh`, `fndiff.sh`, `measure.sh`), joined by #1189's
[`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (`81856ce1…`). `counts/VARIANT/` keeps each build's checks,
totals, `luaV_execute`'s moves and the functions that change by more than 0.05 M against the base.

| Variant | Switches | speedtest1 | Lua's five scripts |
| --- | --- | ---: | ---: |
| base | | 2,603.58 M | 4,756.0 M |
| v1: a stored victim as the farthest next use alone | `P2774=1 P2774_OPEN=0` | 2,600.30 M | 4,756.9 M |
| v2: openings of intervals evicted at their start alone | `P2774=0` | 2,588.28 M | 4,701.2 M |
| v3: both | none | 2,583.93 M | 4,686.2 M |
| v4: both, a stored victim before a recipe | `P2774=2` | 2,581.23 M | 4,685.8 M |
| v5: v4, only where the block has one successor | `P2774=2 P2774_SINGLE=1` | 2,583.84 M | 4,685.8 M |
| v6: v4, only for a range that held its register since its start | `P2774=2 P2774_BEGIN=1` | 2,584.07 M | 4,686.5 M |
| v7: v5 and v6 | `P2774=2 P2774_SINGLE=1 P2774_BEGIN=1` | 2,584.44 M | 4,686.5 M |
| v8: head, a range's continuation from its last block alone | `last-block.patch` | 2,587.25 M | 4,684.9 M |
| **head** | | **2,581.25 M (−0.86%)** | **4,685.8 M (−1.48%)** |

Every script printed clang -O0's output and every speedtest1 gave the hash `1248168 a7fa3957…`. A compiler built from the base with `scripts/variants.patch` builds v1's, v4's and v6's Lua executables byte for byte, and head with `scripts/last-block.patch` v8's Lua executable and speedtest1 object. Head's commits `23d0c3cf` and `6f311851` build the same Lua executable and speedtest1 code.

- **v1** finds little: the dispatch's join took the first handler's register for `cl`, so `cl`'s continuation was a
  register. **v2** lets the join's `cl` rest in its slot, and then v4's rule evicts `cl` at the fetch.
- **v4 to head.** v4's producer kept, by accident, the continuation a range's first block gave where the range goes on
  into a merged block and its last block gives none; head keeps it on purpose (and gives none where the merged block is
  the first successor). Taking the last block's alone (v8) gives `sqlite3VdbeExec` 5.3 M more and `str_gsub` 0.9 M less.
- **By function** (`counts/head/`). Lua: `luaV_execute` −70.78 M, `str_gsub` +0.58 M. speedtest1: `sqlite3VdbeExec`
  −11.88 M, `sqlite3RunParser` −5.02 M, `sqlite3ColumnIndex` −2.16 M, `sqlite3FindTable` −0.90 M; losses
  `lookupName` +0.57 M, `sqlite3Update` +0.12 M, `instrFunc` +0.11 M.
- **`luaV_execute`** (`counts/*/lua-moves.txt`): 2,206.3 M → 2,135.5 M instructions; register moves 317.0 M → 303.8 M,
  through `r11` 3.6 M → 23.4 M. The base's fetches that stored, moved and reloaded `trap` (11, 5.28 M runs) are gone.
  The `r11` rise is the first fetch after `returning` (6.37 M runs): it stored `trap` and `cl` around four moves and
  reloaded `trap` (7 instructions), and now stores `cl` and rotates four registers through `r11` (6).

**Statically** (`--tier1-report`, `reports/static.txt`):

| | base | head |
| --- | ---: | ---: |
| speedtest1's unit: records | 393,120 | 390,798 |
| edge moves | 27,296 | 25,287 |
| spill stores / loads | 11,207 / 11,478 | 10,526 / 10,630 |
| call saves' stores / loads | 19,545 / 24,902 | 19,473 / 24,812 |
| `lvm.c`: records / edge moves | 9,493 / 715 | 9,375 / 610 |
| buster's own `main.c`: records / edge moves | 376,561 / 27,878 | 375,737 / 26,971 |

Every unit compiled the same functions as the base, with no new fallback: `lvm.c` 17, speedtest1's 1,438, `main.c` 538
with 1 fallback.

**The compile, by callgrind** (`reports/compile.txt`): `lvm.c`'s `--tier1 --lanes 1 -c` runs 948.41 M instructions on the
base and 948.56 M on head (+0.016%); by `gap.c` over the compiler's disassembly, `tier1_cfg_prepare` +0.21 M and
`tier1_allocate_hinted` +0.21 M, less what fewer records and moves save in emission and encoding. `23d0c3cf`, which
checked every live-out range's successor, ran 949.43 M (+0.11%), `tier1_cfg_prepare` +1.08 M.

### At main `ae3778a2` (#2773 merged)

#2773 merged as `ae3778a2`, whose tree is the one this pull request's second merge (`d533999b`) makes from main
`2ebfe68a` and #2773's last head `bc298522`. The same method, that tree against the pull request's head `be6bfc78`
(`counts/main-2ebfe68-base`, `counts/main-2ebfe68-head`, `reports/static-main2ebfe68.txt`):

| | main `ae3778a2` | head `be6bfc78` | change |
| --- | ---: | ---: | ---: |
| Lua's five scripts | 4,732.8 M | 4,662.4 M | −1.49% |
| `luaV_execute` | 2,195.7 M | 2,124.9 M | |
| its moves (through `r11`) | 313.4 M (0.1 M) | 300.3 M (19.9 M) | |
| speedtest1 | 2,590.34 M | 2,563.32 M | −1.04% |
| speedtest1's unit: records / edge moves | 389,379 / 26,717 | 387,079 / 24,645 | |
| spill stores / loads | 11,179 / 11,712 | 10,524 / 10,903 | |
| `lvm.c`: records / edge moves | 9,529 / 747 | 9,411 / 642 | |
| `main.c`: records / edge moves | 370,754 / 22,829 | 370,033 / 22,034 | |
| `lvm.c`'s compile, callgrind | 949.70 M | 950.20 M | +0.05% |

By function: `luaV_execute` −70.78 M, `str_gsub` +0.34 M; speedtest1's `sqlite3VdbeExec` −16.79 M,
`sqlite3RunParser` −5.22 M, `sqlite3ColumnIndex` −2.16 M; its losses `lookupName` +0.40 M, `instrFunc` +0.11 M. The
base still had 11 fetches that stored, moved and reloaded `trap`; head has none.

## 2. Run time on the 9700X

The method is #2592's and #2768's (`scripts/9700x/`): Release `znver5` compilers, CPU 2, the shared lock held for each
build, compile and link, each check and each program's timed round.

- **Revisions.** base `9e4809c0` and head `6f311851` (`9700x/revisions.txt`, `9700x/build.log`): the pull request's
  code before main moved on. Section 1's counts show its effect at main `ae3778a2` is the same, within 0.2 points.
- **Objects and executables.** Lua's 33 objects and speedtest1's unit by `--tier1 -fno-asynchronous-unwind-tables
  --tier1-report`; Lua linked by `cc` in 33 orders, speedtest1 after a padding object at 8 shifts. All 82 executables
  passed their checks before any timing (`9700x/checks.txt`).
- **Runs.** 5 rounds of Lua and 7 of speedtest1 in #2553's order, each run counted by `perf stat` (`9700x/runs/`); 1,762
  runs, all exiting 0 with every count, 2026-11-14 23:57 to 2026-11-15 02:06 UTC. `analyze.c` gives
  `9700x/analysis.txt`.

| 9700X, CPU 2 | base | head | 100 ln(head / base), 95% interval | head slower at |
| --- | ---: | ---: | ---: | ---: |
| speedtest1, user cycles (median over 8 shifts) | 741.6 M | 739.6 M | **−0.74** (−1.28 to −0.20) | 0 of 8 |
| speedtest1, user instructions | 2,551.0 M | 2,528.7 M | −0.88 | 0 of 8 |
| Lua's five scripts, user cycles (median over 33 orders) | 992.3 M | 994.6 M | +0.05 (−0.24 to +0.34) | 18 of 33 |
| Lua's five scripts, user instructions | 4,797.3 M | 4,727.0 M | −1.49 | 0 of 33 |

By script, Lua's user cycles change by `calls` −0.93 (−1.23 to −0.63), `tables` −0.30 (−0.86 to +0.26), `strings`
+1.08 (+0.58 to +1.58), `arithmetic` +1.98 (+1.22 to +2.75) and `closures` −1.26 (−2.00 to −0.53).

- **`arithmetic`** runs 2.2% fewer instructions, 19 M fewer of them stack accesses in `luaV_execute`, and more cycles;
  its cycles move with the link order from −1.35% to +8.06%, as #2768's record found (up to 10% either way).
- **`strings`** runs as many instructions (−0.04%; `str_gsub` +0.58 M). Order 0's counters (`9700x/counters.txt`,
  multiplexed, five runs each) show its extra cycles as more dispatch slots the front end left empty (about 776 M against
  743 M), with the same branch mispredictions: placement, not the allocation's instructions.
- As with #2592 and #2768, Zen 5 eliminates register moves at rename, so Lua's fewer moves don't show as time; speedtest1,
  whose spill stores and loads the change removes too, runs 0.74% fewer cycles.

## 3. Compile time on the 9700X

`measure-compile`, head against base as its reference, pinned to CPU 2, one hold of the lock per input: 21 runs of
`sqlite3.c`'s `--tier1 --lanes 1 -c`, 41 of `lvm.c`'s.

| Medians | base | head | change |
| --- | ---: | ---: | ---: |
| main `ae3778a2` against `be6bfc78` (`9700x/compile-main/`): `sqlite3.c`, user cycles | 3,285.1 M | 3,291.5 M | +0.19% |
| `sqlite3.c`, user instructions | 8,079.5 M | 8,101.4 M | +0.27% |
| `sqlite3.c`, wall | 611.6 ms | 612.6 ms | +0.17% |
| `lvm.c`, user cycles | 128.9 M | 128.6 M | −0.23% |
| `lvm.c`, user instructions | 370.5 M | 371.0 M | +0.13% |
| `9e4809c0` against `6f311851` (`9700x/compile/`): `sqlite3.c`, user cycles | 3,284.3 M | 3,295.9 M | +0.35% |
| `sqlite3.c`, user instructions | 8,045.3 M | 8,063.9 M | +0.23% |
| `9e4809c0` against `245ad066` (`9700x/compile-245ad06/`), every range checked: `sqlite3.c`, user instructions | 8,045.3 M | 8,092.6 M | +0.59% |

The cycles moved alike (+0.35%) at `245ad066` and `6f311851` for 29 M instructions apart, so the cycle cost doesn't track
the producer's own work. A `perf record` of user instructions over three compiles of each (`profile.sh`) spreads its
differences over front-end functions this change doesn't touch (the two builds inline and place code differently), so
it attributes nothing and isn't kept.


## Tests

`scripts/tests.sh` (the Tier 1 correctness list) passed on head's build in the container, as did
`test-tier1-cfg-source` on the c-testsuite subset and `lvm.c` with no constraint refusal (`reports/tests.txt`), and again
on `be6bfc78`'s (`reports/tests-be6bfc78.txt`). The pull request's CI passed on `be6bfc78`.
