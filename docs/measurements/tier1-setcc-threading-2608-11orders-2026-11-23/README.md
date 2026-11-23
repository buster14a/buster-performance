# Tier 1 threading's setcc form, 11 link orders (buster#2608, buster#3344)

The setcc form's first session ran this independent 9700X measurement. It corroborates
[tier1-setcc-threading-3344-2026-11-23](../tier1-setcc-threading-3344-2026-11-23), the 33-order record of the session
that took #3344 over and merged it. Both records agree that cycles over placements are not resolved.

- **Trees:** base is main `4704727a179ef530eb9a7b61a4276c8b06508166`. Head is `da4b0e87b025c3239c452735716c45e17b766298`,
  #3344's code commit before its merges of main.
- **Builds:** Release compilers (`BUSTER_DEBUG_INFO=0`), built on the 9700X under the lock.
- **Lua:** each tree's `--tier1` compiled Lua 5.4.8's 33 sources once (`-std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX
  -fno-asynchronous-unwind-tables`), then linked them with `-lm -ldl` in 33 orders. Order k is rotation k of the source
  list, which moves `luaV_execute` (`9700x/addresses.tsv`).
- **Timing:** 11 orders were timed, k = 0, 3, ..., 30, because each hold waited about ten minutes in the lock's queue.
  Each order had one hold of its own. In it, both trees ran in alternating order: each of #138's five scripts under
  `perf stat -r 3` (user counters, CPU 2), then one `perf record -e cycles:u -c 100003` over the five scripts for
  `luaV_execute`'s own cycles.
- **Compile cost:** 11 alternating runs per tree, one lane.
- **Scripts:** `scripts/record.sh` built and linked; `scripts/record2.sh` timed and measured the cost; `scripts/tables.py`
  made `9700x/tables.md`. The receipts' digest of `record.sh` is from before its link step was moved inside a hold.
- **Outputs:** every script's output is the same for base and head (`9700x/outputs.txt`).

## The 9700X (`9700x/tables.md`)

Medians over the 11 orders:

| | head/base |
| --- | ---: |
| five scripts' cycles, geometric mean | 1.0001 |
| five scripts' cycles, summed | 0.9951 (head lower at 6 of 11 orders) |
| `luaV_execute`'s own cycles | 1.0146 (head lower at 3 of 11 orders) |
| five scripts' instructions, geometric mean | 0.9962 |

`luaV_execute`'s cycles span 389.9 to 417.7 M (base) and 402.1 to 414.2 M (head) over the orders. That 28 M spread is
wider than the change. As in the 33-order record, the instruction drop does not show up as fewer cycles at this
resolution.

**Compile cost** (medians of 11):

| | cycles | instructions |
| --- | ---: | ---: |
| `lvm.c` | -0.45% | +0.18% |
| `sqlite3.c` `--tier1 -O2` | -0.14% | +0.23% |

## Callgrind (`callgrind/`, `scripts/count.sh`)

Exact counts of order 0's executables (`callgrind/inputs.sha256`), run in a cloud VM through the 9700X's own loader and C
library, joined by #1189's `gap.c` and counted by #138's `patterns.py`, summed over the five scripts:

| | base | head |
| --- | ---: | ---: |
| `setcc` in one block, `test` and branch on it in the next | 7,778,426 | 228 |
| a constant made, then tested and branched on | 1,128,798 | 1,099,299 |
| `luaV_execute`'s instructions | 2,054,257,292 | 2,038,786,045 |
| the program's own instructions | 4,009,794,913 | 3,988,715,127 |

- `luaV_execute`'s moves rise 6.4 M. Most of that is the setcc's zeroing: it is now `mov $0` after the compare, counted
  as a move, instead of `xor` before it, counted as a constant. Its constants fall 5.0 M.
- `calls` alone rises 1.9 M instructions (+0.39%). One hot edge's register permutation, a four-register cycle through
  `%r11`, gained a move: 3.8 M, against the 1.9 M jumps the threading removed there.
