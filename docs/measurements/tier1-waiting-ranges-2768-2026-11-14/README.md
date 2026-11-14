# Tier 1 allocation: ranges that wait in their value's slot (#2768), 2026-11-14

Evidence for [buster#2768](https://github.com/buster14a/buster/issues/2768) and its pull request
[buster#2773](https://github.com/buster14a/buster/pull/2773). By Claude in David's directed session
([the session](https://claude.ai/code/session_01NNmNQvtpz6cx2dH6CBM1z9)).

`luaV_execute`'s `OP_GETTABUP` spills `pc` around `luaH_getshortstr`. At the join of `luaV_fastget`'s two arms, `pc`'s
range was hinted to its anchor's exit, where `pc` is in its slot. Such a range, which has uses, took the lowest free
register at its start. `rbx`, the dispatch's register for `pc`, was still held there by `upval`, so `pc` took `r13`,
the dispatch's register for `i`, and the fetch swapped the two through `r11`.

The pull request makes such a range wait in the slot until its next required use. It applies to a range hinted to its
own value, which is a block's entry range or a split's piece but not a phi's definition. The range doesn't wait where
its value's first register is free at its start; it takes that register there instead. A reload of a value whose hint
is its slot also prefers that register. buster's `docs/tier1-allocation.md`, "Ranges that wait in their slots
(#2768)", has the rule.

## Revisions

| Role | What |
| --- | --- |
| main | buster's main at `5f3c7d48fa330f2146a2af9bad45ccaec4b389e5` |
| head | the pull request's commit `c5949ea1946539859deaec47d5dcaa5c50b863f4`; its next commit, `6a7776b6`, changes only a test's expectation |
| variants | main with `scripts/variants.patch`, whose environment switches select each variant (below) |

## 1. Dynamic instruction counts (callgrind)

**Host.** A cloud container, not the 9700X (`counts/identities.txt`): an Intel Xeon with AVX-512, valgrind 3.22.0, GNU
objdump 2.42, clang 23.1.6. The compilers are `build.sh`'s Develop configuration with `BUSTER_HOST_ARCH=x86-64`, since
valgrind runs only the scalar host's build.

**Inputs.** #1189's and #1217's:
- Lua 5.4.8 (`4f18ddae…`) and the five scripts at buster-performance `818cfbbc`;
- the frozen `sqlite3.c` (`0a409f16…`) and `speedtest1.c` at SQLite `ccc132c5` (`b5eaf4bb…`), as one unit, with
  speedtest1's `--size 5` mix.

Each Lua build has a fixed string-hash seed (`-Dluai_makeseed(L)=0x2768u`), so that a script's count repeats.

**Tools.** `scripts/` holds #2592's scripts with this session's paths:
- `buildlua.sh` builds Lua by `--tier1 -fno-asynchronous-unwind-tables`;
- `luacount.sh` checks each script's output against clang -O0's, runs it under callgrind (`--dump-instr=yes`) and
  joins the counts with the disassembly by #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (`81856ce1…`);
- `st.sh` does the same for speedtest1, with its `--verify` hash;
- `moves.sh` sums `luaV_execute`'s moves, and `fndiff.sh` gives the functions that change by more than 0.05 M;
- `measure.sh NAME [VARIABLE=VALUE...]` runs all of them for one compiler and its switches.

`counts/VARIANT/` keeps each build's checks, totals, moves and per-function differences against main.

| Variant | Switches | speedtest1 | Lua's five scripts |
| --- | --- | ---: | ---: |
| main | | 2,657.78 M | 4,879.4 M |
| v1: the first register for reloads alone | `P2768_NOWAIT=1` | 2,656.99 M | 4,879.5 M |
| v2: waiting alone, every range | `P2768_NOCONV=1` | 2,661.32 M | 4,852.6 M |
| v4: both, every range | none | 2,657.79 M | 4,851.6 M |
| v3: both, but not where the first register is free | `P2768_V3=1` | 2,652.65 M | 4,851.5 M |
| **v5: the same, for a range of its own value only (head)** | `P2768_V3=1 P2768_OWN=1` | **2,633.68 M (−0.91%)** | **4,851.7 M (−0.57%)** |
| v6: v5 without the free first register | `P2768_OWN=1` | 2,638.79 M | 4,851.9 M |

Every script printed clang -O0's output and every speedtest1 gave the hash `1248168 a7fa3957…`. head's compiler builds
the same `lvm.o`, Lua executable and speedtest1 object as the variants' compiler with v5's switches, byte for byte.

- **v4's losses.** `sqlite3ColumnIndex` +5.82 M: waiting at its outer loop's header reloaded `nCol` on every
  iteration, where taking a free register at the header's start had reloaded it once (v3 takes back the loss).
  `sqlite3VdbeExec` +9.78 M: a phi's range that waits needs a slot of its own. At the opcode loop's join, whose phi
  has 95 operands, slot sharing could not join the phi's slot to its operands', so each of those edges copied it slot
  to slot through `r11`: 5.84 M times, two instructions each (v5 takes back the loss).
- **head by function.** `luaV_execute` −24.40 M, `rehash` −2.37 M, `str_gsub` −0.46 M and `str_format` −0.36 M; no
  Lua function runs more. speedtest1: `balance_nonroot` −8.23 M, `sqlite3VdbeExec` −6.08 M, `sqlite3_str_vappendf`
  −1.22 M; its two losses are `sqlite3WhereEnd` +0.42 M and `speedtest1_run` +0.14 M.
- **`luaV_execute`'s moves.** 344.9 M → 339.6 M register moves, 17.7 M → 16.4 M of them through `r11`. The
  `OP_GETTABUP` fetch's two, 0.74 M each, are gone (`counts/main/lua-moves.txt`, `counts/v5/lua-moves.txt`).

**Statically** (`--tier1-report`, the same compilers):

| | main | head |
| --- | ---: | ---: |
| speedtest1's unit: records | 403,045 | 397,490 |
| edge moves | 39,235 | 30,715 |
| spill stores / loads | 12,645 / 13,915 | 11,225 / 11,466 |
| call saves' stores / loads | 19,436 / 24,766 | 19,545 / 24,902 |
| `lvm.c`: records / edge moves | 9,994 / 1,196 | 9,840 / 992 |
| buster's own `main.c`: records / edge moves | 311,898 / 34,484 | 309,024 / 29,601 |

Every unit compiled the same functions as main, with no new fallback: `lvm.c` 17, speedtest1's 1,438, `main.c` 374 of
375.

## 2. Run time on the 9700X

The method is #2592's ([tier1-sink-2592-2026-11-14](../tier1-sink-2592-2026-11-14/README.md), section 2), with its
scripts and this record's paths (`scripts/9700x/`).

- **Machine.** Ryzen 7 9700X, CPU 2. Every build, compile, link, check and timed round took the shared lock.
- **Compilers** (`setup.sh`, `compilers.sh`). Clean clones of main at `5f3c7d48` and of head at `c5949ea`, each built
  by its own `build.sh --config Release` with `BUSTER_HOST_ARCH=znver5` (`9700x/build.log` has their hashes).
- **Inputs.** #2592's on benchpress, checked by their SHA-256 (`9700x/inputs.sha256`); they are section 1's.
- **Objects** (`objects.sh`). Each compiler builds Lua's 33 objects and speedtest1's unit once, by `--tier1
  -fno-asynchronous-unwind-tables --tier1-report` (`9700x/objects-*.sha256`, `9700x/reports-*.txt`). Their reports
  equal the container's for `lvm.c` and speedtest1's unit: the same records, spills and edge moves.
- **Executables** (`link.sh`). Lua is linked by `cc` in 33 orders (`9700x/orders.txt`), and speedtest1 after a padding
  object of 0 to 3,696 bytes, at 8 shifts. All 82 executables passed their checks before any timing
  (`9700x/checks.txt`): each script's output against clang -O0's, and speedtest1's verification hash.
- **Runs** (`time2.sh`, `round.sh`). Every executable runs once untimed. Then come 5 rounds of Lua (each order, each
  script, both revisions) and 7 of speedtest1 (each shift), in #2553's order. Each run is pinned to CPU 2 and counted by
  `perf stat` (task-clock, user cycles and instructions). Each program's round is one hold of the lock.
  `9700x/runs/busy.txt` has the busiest processes and the load at each hold's start and end.
- **Statistics.** `analyze.c` (#1216's) computes `9700x/analysis.txt`.

1,762 timed runs, all exiting 0 with every count (`9700x/runs/runs.txt`), from 17:49 to 18:31 UTC.

| 9700X, CPU 2 | main | head | 100 ln(head / main), 95% interval | head slower at |
| --- | ---: | ---: | ---: | ---: |
| Lua's five scripts, user cycles (median over 33 orders) | 1,009.4 M | 1,009.9 M | −0.04 (−0.52 to +0.44) | 17 of 33 |
| Lua's five scripts, user instructions | 4,920.0 M | 4,892.4 M | −0.56 (−0.58 to −0.55) | 0 of 33 |
| speedtest1, user cycles (median over 8 shifts) | 748.2 M | 747.0 M | −0.39 (−0.77 to −0.01) | 2 of 8 |
| speedtest1, user instructions | 2,605.2 M | 2,581.1 M | −0.93 | 0 of 8 |

By script, Lua's user cycles change by:

| Script | Change (95% interval) | Head slower at |
| --- | ---: | ---: |
| `calls` | −0.15 (−0.59 to +0.28) | 14 of 33 |
| `tables` | −0.54 (−0.96 to −0.12) | 10 of 33 |
| `strings` | −0.08 (−0.51 to +0.35) | 16 of 33 |
| `arithmetic` | +1.44 (−0.34 to +3.22) | 18 of 33 |
| `closures` | −0.50 (−1.76 to +0.77) | 10 of 33 |

As with #2592, Lua's instructions fall at every order and its time doesn't resolve a change. Zen 5 eliminates
register moves at rename, and `arithmetic` and `closures` move with the link order by up to 10% either way. speedtest1,
whose spill stores and loads the change removes as well as moves, runs 0.39% fewer cycles.

## 3. Compile time on the 9700X

`scripts/9700x/compile.sh`: head's `measure-compile`, with main's compiler as its reference, in a Williams order,
pinned to CPU 2, one hold of the lock per input (`9700x/compile/`).

| `--tier1 --lanes 1 -c`, medians | main | head | change |
| --- | ---: | ---: | ---: |
| `sqlite3.c` (21 runs), user cycles | 3,289.9 M | 3,296.8 M | +0.21% |
| `sqlite3.c`, user instructions | 8,169.7 M | 8,193.3 M | +0.29% |
| `sqlite3.c`, wall | 612.5 ms | 613.7 ms | +0.19% |
| `lvm.c` (41 runs), user cycles | 128.3 M | 128.2 M | −0.08% |
| `lvm.c`, user instructions | 371.6 M | 372.3 M | +0.19% |

By callgrind in the container (`lvm.c` alone: under valgrind the compiler can't reserve the address space
`sqlite3.c`'s parse needs), the hinted allocator and the plain problem's verdict run 1.1 M more instructions on
`lvm.c`. That comes from the waiting checks, the first registers and the reloads the scan now places at uses. The
records, the encoder's validation and the moves' resolution run about as many fewer, since the change leaves 1.5% fewer
records and 17% fewer edge moves; the whole compile ran 51 K fewer instructions in the container's Develop build.
