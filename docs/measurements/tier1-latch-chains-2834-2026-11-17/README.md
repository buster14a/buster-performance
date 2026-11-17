# Tier 1 allocation: loop bodies whose chain reaches no range before them (#2834), 2026-11-17

Evidence for [buster#2834](https://github.com/buster14a/buster/issues/2834). By Claude in David's directed session
([the session](https://claude.ai/code/session_01NNmNQwPmXVt6532DQyR86y)).

#2784's body hints follow a header phi's hint chain back to a range of another value laid out before the loop's body.
buster's `tests/driver/tier1_patterns.c` `patterns_gsub` has none to reach: the latch that joins `n` and `lastmatch` is
laid out between the body and the header, and the chain led back to the body's own ranges, which took the lowest free
registers and swapped the two through `r11`. #2784's record ([section 2](../tier1-body-hints-2784-2026-11-15/README.md))
measured a prototype that hinted such a phi's range to an operand's exit before it; it gained on Lua but lost 13.3 M in
`sqlite3VdbeExec`.

The change, in buster's `docs/tier1-allocation.md`, "Loop bodies whose chain reaches no range before them (#2834)":

- `tier1_cfg_body_hints`: a phi's **first** range in layout, before its definition, that the chain leaves unhinted takes
  an operand's register at the exit of a predecessor of the phi's block, the nearest in layout that ends before it;
- `tier1_allocation_value_hint`: an interval hinted to its own value that names another value's recipe takes the
  recipe's register only; a recipe without one there was recomputed, and the interval follows its own value instead.

## Revisions

| Role | What |
| --- | --- |
| main | buster's main at `d876a5e0f0252407e467e95dc602b3ad26895f9d` |
| head | the pull request's commit `0e1d14d7c684d71a16fcebd598419e8352018bff` on that main; its later commits change tests and documentation only |
| variants | the session's tree with `scripts/variants.patch` (against main), whose environment switches select each variant (section 1); it also holds a local interval dump (`BUSTER_DEBUG_2834=BODY`, `BUSTER_DEBUG_2834_WINDOW=LO:HI`, a `== name BODY SYMBOL` line per body) and the latch fixture's first form |

## 1. Dynamic instruction counts (callgrind)

**Host.** A cloud container, not the 9700X: an Intel Xeon with AVX-512, valgrind 3.22.0, GNU objdump 2.42, clang 23.1.6
(Lua's reference outputs by clang -O0). The compilers are `build.sh`'s Develop configuration with
`BUSTER_HOST_ARCH=x86-64`, since valgrind runs only the scalar host's build.

**Inputs and tools.** #2768's and #2784's ([#2768's record, section 1](../tier1-waiting-ranges-2768-2026-11-14/README.md)):
Lua 5.4.8 (`4f18ddae…`) and the five scripts of `tier1-reciprocal-141-2026-11-01/9700x/lua` (`calls.lua` `a0d485c9…`),
with a fixed string-hash seed; speedtest1 (`b5eaf4bb…`) with the frozen `sqlite3.c` (`0a409f16…`) as one unit,
`--size 5`; #1189's [`gap.c`](../tier1-gap-1189-2026-11-03/tools/gap.c) (`81856ce1…`). `scripts/` holds #2784's scripts
with this session's paths (`measure.sh NAME [VARIABLE=VALUE...]`). `counts/VARIANT/` keeps each build's checks, totals,
`luaV_execute`'s moves and the functions that change by more than 0.05 M against main.

| Variant | Switches | `counts/` | speedtest1 | Lua's five scripts |
| --- | --- | --- | ---: | ---: |
| main | | `main` | 2,529.77 M | 4,595.8 M |
| #2784's prototype: every unhinted phi range before its definition, blocks of at most 4 predecessors | `P2834=4` | `p4` | 2,536.16 M | 4,588.2 M |
| the first range only, at most 4 predecessors | `P2834=4 P2834F=1` | `pf4` | 2,518.11 M | 4,587.9 M |
| the first range only | `P2834=100000 P2834F=1` | `pfall` | 2,518.09 M | 4,587.9 M |
| and an own value's interval named to another value's takes only a register | `… P2834R=1` | `pfr` | 2,519.57 M | 4,586.9 M |
| and named to another value's recipe, only a register (head) | `… P2834R=2` | `pr2`, `head` | **2,517.04 M (−0.50%)** | **4,586.6 M (−0.20%)** |
| as `pr2`, on every interval named to another value's recipe | `… P2834R=3` | `pr3` | 2,544.41 M | 4,586.7 M |
| `P2834R=1` alone | `P2834R=1` | `r0` | 2,530.67 M | 4,596.2 M |
| `P2834R=2` alone | `P2834R=2` | `r2only` | 2,529.77 M | 4,595.8 M |

Every script printed clang -O0's output and every speedtest1 gave the hash `1248168 a7fa3957…`. head's compiler builds the
same speedtest1 unit and Lua objects as the variants' compiler with `pr2`'s switches, byte for byte; `head` is its own
callgrind run of them (speedtest1 2,517.05 M).

- **The prototype's loss** (`p4`, `sqlite3VdbeExec` +17.69 M). It hinted every unhinted range of a phi before its
  definition. In `sqlite3VdbeExec`'s opcode loop, ranges of the header's phis that had rested in their slots in the
  handlers laid out before it (their values' own last place, memory) took their entry operand's register instead, in
  each handler: 137 unused ranges went from a slot to a register, 24 the other way, of 1,069 newly hinted. With more
  values in registers through the loop, the dispatch's jump-table address evicted the step counter it had just
  incremented in `r15`, and stored it on every opcode: `mov %r15,0xd0(%rsp)` 5.89 M times, a store main doesn't make.
- **The first range only** (`pf4`) keeps the gains (`luaD_precall` −3.66 M, `sqlite3ColumnIndex` −4.60 M) and turns
  `sqlite3VdbeExec` into −3.57 M. Its losses: `sqlite3RunParser` +2.68 M and `str_format` +1.36 M. In both, the phi's
  first range named a constant (a recipe) that the scan had evicted for recomputation before the predecessor's exit;
  the range followed that "memory" and rested in its slot, so each iteration stored the phi there and reloaded it
  (`sqlite3RunParser`'s back edge `mov %ebx,0x504(%rsp)`).
- **Register only** for every interval of its own value named to another value's (`pfr`) removes those losses but
  gives back `sqlite3VdbeExec`'s gain; alone (`r0`) it costs `sqlite3VdbeExec` +1.04 M and `str_gsub` +0.34 M through
  #2784's chains. Only for a named **recipe** (`pr2`) it keeps both, and alone (`r2only`) changes no function by 0.05 M.
  On every interval named to another value's recipe (`pr3`), a phi's to its operand's among them, `sqlite3VdbeExec`
  runs +24.51 M.
- **The predecessor limit** changes nothing with the first range alone: `pf4` and `pfall` differ in no function by 0.05 M.

**head by function** (`counts/head/`): `luaD_precall` −3.66 M, `luaD_pretailcall` −1.40 M, `luaV_finishset` −1.30 M,
`luaO_ceillog2` −1.20 M, `str_gsub` −0.69 M; no Lua function runs more. speedtest1: `sqlite3ColumnIndex` −4.60 M,
`sqlite3VdbeExec` −2.36 M, `sqlite3VdbeRecordCompareWithSkip` −1.70 M, `sqlite3FindTable` −0.56 M; its losses are
`pageFindSlot` +0.22 M, `pageInsertArray` +0.12 M and `rebuildPage` +0.07 M. `luaV_execute` runs as on main.

**`patterns_gsub`** (buster's `tests/driver/tier1_patterns.c`, `--tier1 --lanes 1`): 124 instructions on main, 6 of them
naming `r11` (its paths for a character and for a failed match swapped `n` and `lastmatch`), 105 with head, none naming
it. The file's edge moves: 40 on main, 14 with head.

**Statically** (`--tier1-report`, the same compilers; the 9700X's `9700x/reports-*.txt` give the same counts):

| | main | head |
| --- | ---: | ---: |
| speedtest1's unit: records | 382,540 | 381,556 |
| edge moves | 25,056 | 24,119 |
| spill stores / loads | 10,229 / 11,076 | 10,273 / 11,085 |
| `lstrlib.c`: records / edge moves | 6,961 / 434 | 6,949 / 424 |
| `ldo.c` | 2,453 / 39 | 2,436 / 27 |
| `lvm.c` | 9,242 / 644 | 9,244 / 641 |

Every unit compiled the same functions (speedtest1's 1,421 with no fallback; `ldo.c`'s one fallback is main's too).

## 2. Run time and compile time on the 9700X

The method is #2784's ([its record](../tier1-body-hints-2784-2026-11-15/README.md), section 3) with this record's paths
(`scripts/9700x/`, run by `chain.sh` under `systemd-run`; every build, compile, link, check and round one hold of the
shared lock).

- **Compilers.** Clean clones of main at `d876a5e0` (base) and of head at `0e1d14d7`, each built by its own `build.sh
  --config Release` with `BUSTER_HOST_ARCH=znver5` (`9700x/build.log`, `9700x/revisions.txt`).
- **Objects.** Lua's 33 objects and speedtest1's unit by `--tier1 -fno-asynchronous-unwind-tables --tier1-report`
  (`9700x/reports-*.txt`).
- **Executables.** Lua linked in 33 orders, speedtest1 after 8 padding objects; all 82 passed their checks
  (`9700x/checks.txt`).
- **Runs.** 5 rounds of Lua and 7 of speedtest1, 1,762 timed runs, all exiting 0 with every count (`9700x/runs/`);
  `9700x/analysis.txt` is `analyze.c`'s.

| 9700X, CPU 2 | base | head | 100 ln(head / base), 95% interval | head slower at |
| --- | ---: | ---: | ---: | ---: |
| speedtest1, user cycles (median over 8 shifts) | 729.7 M | 726.8 M | −0.41 (−0.81 to −0.01) | 1 of 8 |
| speedtest1, user instructions | 2,477.2 M | 2,464.5 M | −0.51 | 0 of 8 |
| Lua's five scripts, user cycles (median over 33 orders) | 981.2 M | 982.8 M | +0.18 (−0.27 to +0.62) | 18 of 33 |
| Lua's five scripts, user instructions | 4,637.0 M | 4,627.0 M | −0.20 (−0.22 to −0.18) | 0 of 33 |

By script, Lua's user cycles change by +0.25 (`calls`), +0.37 (`tables`), +0.18 (`strings`), +0.26 (`arithmetic`) and
−0.05 (`closures`), none outside its interval; two orders read +5.31 (order 23) and +2.41 (order 31), and the median
over the orders is +0.09. Every instruction Lua's scripts lose by callgrind is a register move (`luaD_precall` 26.60 M
moves to 22.93 M, its other types unchanged; `luaD_pretailcall`, `luaV_finishset` and `luaO_ceillog2` the same), which
Zen 5 eliminates at rename, and the spread over the link orders (sd 1.26) is larger than what they cost. speedtest1's
are stack traffic: `sqlite3ColumnIndex` runs 1.48 M stack loads and 1.61 M stack stores instead of 4.32 M and 4.45 M,
`sqlite3VdbeExec` 53.54 M and 53.57 M instead of 54.94 M and 54.89 M.

**Compile time** (`compile.sh`: head's `measure-compile` with base as the reference, pinned to CPU 2, `9700x/compile/`):

| `--tier1 --lanes 1 -c`, medians | base | head | change |
| --- | ---: | ---: | ---: |
| `sqlite3.c` (21 runs), user cycles | 3,248.8 M | 3,251.7 M | +0.09% |
| `sqlite3.c`, user instructions | 8,046.5 M | 8,055.6 M | +0.11% |
| `sqlite3.c`, wall | 605.41 ms | 605.59 ms | +0.03% |
| `lvm.c` (41 runs), user cycles | 126.3 M | 126.6 M | +0.24% |
| `lvm.c`, user instructions | 364.6 M | 365.0 M | +0.11% |
