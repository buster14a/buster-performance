# Tier 1 allocation: loop bodies before their headers, and slots already current (#2784), 2026-11-15

Evidence for [buster#2784](https://github.com/buster14a/buster/issues/2784). By Claude in David's directed session
([the session](https://claude.ai/code/session_01NNmNQvtpz6cx2dH6CBM1z9)).

With #2768's waiting (merged in buster#2773), Lua's `str_gsub` ran 73.0 M instructions on the five scripts instead of
69.9 M. Its loop swapped `r12` and `r13` through `r11` twice on its path for a plain character and stored two values
straight back into the slots it had just reloaded them from. The loop's body is laid out before its header and has no
anchor, so its ranges of the header's phis took their values' last registers or the lowest free ones, which agreed with
the header's places only by chance; the waiting changed which register was free there.

The change, in buster's `docs/tier1-allocation.md`, "Loop bodies before their headers, and slots already current
(#2784)":

- `tier1_cfg_body_hints`: a range laid out before its value's definition that nothing hints follows the definition's
  hint chain back to the first range of another value laid out before it;
- `tier1_allocate_scan_uses`: a range waits in its slot only where its hint names a range of its own value;
- `tier1_emit_phase`: in the CFG consumer, an eviction leaves out its store where the value's slot already holds it,
  stored or reloaded earlier in the same run of blocks (each the only predecessor of the next).

## Revisions

| Role | What |
| --- | --- |
| main | buster's main at `20cd8e54a` (sections 1 and 2) |
| head | the change's commit `c8374bda3` on main `20cd8e54a`, whose compiler builds the same `lstrlib.c`, `lvm.c`, `ldo.c`, `ltable.c`, `lgc.c` and `lparser.c` objects as the variants' with both switches on; the branch then merged main `b5099aa7` (`e2412755`) |
| variants | main with `scripts/variants.patch`, whose environment switches select each part: `P2784=1` the body hints back to another value's range, `P2784=a` back to any earlier range, `P2784S=1` the slot stamps. It also holds the session's interval dump (`BUSTER_DEBUG_2768`, `BUSTER_DEBUG_2768_WINDOW`) and a line naming each body's symbol id |

## 1. Dynamic instruction counts (callgrind)

**Host.** A cloud container, not the 9700X (`counts/identities.txt`): an Intel Xeon with AVX-512, valgrind 3.22.0, GNU
objdump 2.42, clang 23.1.6. The compilers are `build.sh`'s Develop configuration with `BUSTER_HOST_ARCH=x86-64`, since
valgrind runs only the scalar host's build.

**Inputs and tools.** #2768's record's ([section 1](../tier1-waiting-ranges-2768-2026-11-14/README.md)): Lua 5.4.8 and
its five scripts with a fixed string-hash seed, and speedtest1 with the frozen `sqlite3.c` as one unit, `--size 5`; the
scripts in `scripts/` (`measure.sh NAME [VARIABLE=VALUE...]`). `counts/VARIANT/` keeps each build's checks, totals,
`luaV_execute`'s moves and the functions that change by more than 0.05 M against main.

| Variant | `counts/` | speedtest1 | Lua's five scripts |
| --- | --- | ---: | ---: |
| main | `main` | 2,590.34 M | 4,732.8 M |
| body hints, back to any earlier range, the waiting unchanged | `any-earlier` | 2,583.23 M | 4,712.1 M |
| body hints, back to another value's range, waiting only in its own value's slot | `other-value` | 2,578.59 M | 4,712.1 M |
| slot stamps alone | `stamps` | 2,587.92 M | 4,731.7 M |
| **both (head)** | `head` | **2,576.17 M (−0.55%)** | **4,711.0 M (−0.46%)** |

Every script printed clang -O0's output and every speedtest1 gave the hash `1248168 a7fa3957…`.

- **`str_gsub`** runs 69.4 M instead of 73.0 M (69.9 M before #2768), with no move through `r11` and no store back on
  its loop's paths. `luaD_precall` runs 230.8 M instead of 249.1 M; `luaV_execute` runs as on main (2,195.7 M, 313.4 M
  moves, 0.1 M through `r11`).
- **speedtest1**: `sqlite3VdbeExec` −13.00 M, `balance_nonroot` −0.52 M, `sqlite3_str_vappendf` −0.10 M; the one loss
  over 0.05 M is `wherePathSolver` (+0.07 M).
- **A chain back to the value's own range** (`any-earlier`) cost `balance_nonroot` +4.70 M, `sqlite3_str_vappendf`
  +1.20 M and `lookupName` +0.52 M: it named the value's first opening register, where its last one served as well.
  In `balance_nonroot`'s cell loop a live-through value moved into `rbp` and another went to its slot every iteration.
- **The slot stamps** remove `str_gsub`'s two stores back (`mov 0x28(%rsp),%rbx; mov %rbx,0x28(%rsp)` and the same at
  `0x20`), 0.57 M times each; one is in the block after the reload's, whose only predecessor it is.

**Statically** (`--tier1-report`, `counts/static/`):

| | main | head |
| --- | ---: | ---: |
| speedtest1's unit: records | 389,379 | 388,992 |
| edge moves | 26,717 | 26,618 |
| spill stores / loads | 11,179 / 11,712 | 10,932 / 11,756 |
| `lstrlib.c`: records / edge moves | 7,207 / 485 | 7,192 / 472 |
| `lvm.c` | 9,529 / 747 | the same |

Every unit compiled the same functions with no fallback (speedtest1's 1,438, `lvm.c` 17, `lstrlib.c` 36).

## 2. What it leaves: #2834

[buster#2834](https://github.com/buster14a/buster/issues/2834). A loop whose chain ends in a range with no hint of its
own keeps its body's places to chance: buster's `tests/driver/tier1_patterns.c` `patterns_gsub`, whose latch holding
the join's ranges is laid out between the body and the header, swaps `n` and `lastmatch` through `r11` on its path for
a character. `scripts/fallback-2834.patch` (`tier1_cfg.c` against main `20cd8e54a`, with `P2784O=N`) hints a phi's
range left unhinted to an operand's range at the exit of a predecessor of the phi's block, the nearest that ends before
it, for blocks of at most N predecessors; on top of head:

| Prototype | `counts/` | speedtest1 | Lua's five scripts |
| --- | --- | ---: | ---: |
| every phi | `fallback-all` | 2,576.76 M | 4,709.8 M |
| at most 2 predecessors | `fallback-2` | 2,584.68 M | 4,703.2 M |
| at most 4 predecessors | `fallback-4` | 2,576.65 M | 4,703.3 M |

It gains in `luaD_precall`, `sqlite3ColumnIndex` and others but loses 13.3 M or more in `sqlite3VdbeExec` (more stack
stores and loads, a new hot `rbp` spill), and `luaV_execute` 6.5 M without a limit.

## 3. Run time and compile time on the 9700X

Pending: `9700x/` will hold the run (#2768's method, main `b5099aa7` against head `e2412755`).
