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

The method is #2768's ([its record](../tier1-waiting-ranges-2768-2026-11-14/README.md), section 2) with this record's
paths (`scripts/9700x/`, run by `chain.sh` under `systemd-run`, every build, compile, link, check and round one hold of
the shared lock).

- **Compilers.** Clean clones of main at `b5099aa7` (base) and of head at `e2412755`, each built by its own `build.sh
  --config Release` with `BUSTER_HOST_ARCH=znver5` (`9700x/build.log`, `9700x/revisions.txt`).
- **Objects.** Lua's 33 objects and speedtest1's unit by `--tier1 -fno-asynchronous-unwind-tables --tier1-report`
  (`9700x/reports-*.txt`): speedtest1's unit 386,003 records instead of 386,388, 10,914 spill stores instead of 11,159,
  26,575 edge moves instead of 26,674; `lstrlib.c` 472 edge moves instead of 485; `lvm.c` the same. The differences
  equal the container's (section 1).
- **Executables.** Lua linked in 33 orders, speedtest1 after 8 padding objects; all 82 passed their checks
  (`9700x/checks.txt`).
- **Runs.** 5 rounds of Lua and 7 of speedtest1, 1,762 timed runs, all exiting 0 with every count (`9700x/runs/`);
  `9700x/analysis.txt` is `analyze.c`'s.

| 9700X, CPU 2 | base | head | 100 ln(head / base), 95% interval | head slower at |
| --- | ---: | ---: | ---: | ---: |
| Lua's five scripts, user cycles (median over 33 orders) | 992.1 M | 989.3 M | −0.37 (−0.64 to −0.10) | 11 of 33 |
| Lua's five scripts, user instructions | 4,767.3 M | 4,746.3 M | −0.46 (−0.47 to −0.44) | 0 of 33 |
| speedtest1, user cycles (median over 8 shifts) | 730.8 M | 734.6 M | +0.41 (−0.03 to +0.85) | 7 of 8 |
| speedtest1, user instructions | 2,525.4 M | 2,511.2 M | −0.56 | 0 of 8 |

By script, Lua's user cycles change by −0.29 (`calls`), −0.38 (`tables`), −0.43 (`strings`, −0.81 to −0.04), −0.16
(`arithmetic`) and −0.47 (`closures`).

**speedtest1's parts.** `var.sh` built head again with two switches (`var2784.patch`): `X2784_NOHINTS` leaves out the
body hints, so that only the slot stamps act (`nohints`), and `X2784_NOSTAMPS` the stamps (`nostamps`). Without either
switch it builds head's object byte for byte. 7 rounds of speedtest1 over the 8 shifts and the four builds
(`9700x/runs-var/`, `9700x/variants-analysis.txt`, `scripts/9700x/variants.py`), against base:

| Build | user cycles, 100 ln, 95% interval | slower at | instructions |
| --- | ---: | ---: | ---: |
| head | +0.47 (+0.04 to +0.90) | 7 of 8 | −0.56 |
| the slot stamps alone | +0.66 (+0.32 to +0.99) | 8 of 8 | −0.10 |
| the body hints alone | +0.45 (−0.17 to +1.07) | 6 of 8 | −0.47 |

The stamps alone remove stores in a few functions only (`sqlite3VdbeExec` −1.15 M instructions, `balance_nonroot`
−0.50 M, the rest under 0.1 M each), yet cost 0.66% of the cycles. Sampled by function (`prof2.sh`: ten runs of each at
shifts 0, 1,584 and 3,696, 25 kHz; `9700x/prof2/by-function.txt`), base takes 112,846 samples and the stamps 113,426
(+0.51%). The differences are spread over functions whose code the stamps don't change: `pcache1FetchStage2` +14%,
`sqlite3GetToken` +6%, `sqlite3VdbeMakeReady` +15%, against `releaseMemArray` −15%, `memsys5Size` −9% and
`jsonTranslateBlobToText` −9%; `sqlite3VdbeExec` −0.6% and `balance_nonroot` +10.5%. The shifts move the whole unit and
leave the distances between its functions as they are, which a change of size in one function moves for every function
after it; buster refuses `-ffunction-sections`, so no link could reorder them. The run doesn't separate that layout
from the change's own effect: speedtest1's cycles don't follow its 0.56% fewer instructions on the 9700X.
`9700x/prof3/` annotates `balance_nonroot` at shift 0 (315 and 334 samples, too few to place).

**Compile time** (`compile.sh`: head's `measure-compile` with base as the reference, pinned to CPU 2,
`9700x/compile/`):

| `--tier1 --lanes 1 -c`, medians | base | head | change |
| --- | ---: | ---: | ---: |
| `sqlite3.c` (21 runs), user cycles | 3,276.8 M | 3,282.6 M | +0.18% |
| `sqlite3.c`, user instructions | 8,051.1 M | 8,057.9 M | +0.08% |
| `sqlite3.c`, wall | 609.8 ms | 610.9 ms | +0.18% |
| `lvm.c` (41 runs), user cycles | 128.5 M | 128.4 M | −0.08% |
| `lvm.c`, user instructions | 368.0 M | 368.3 M | +0.08% |
