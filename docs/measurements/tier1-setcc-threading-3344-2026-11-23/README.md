# Tier 1 threading of Lua's setcc joins over link orders (buster#3344, #2608)

[buster#3344](https://github.com/buster14a/buster/pull/3344) extends `ir_thread.c`'s SSA repair to the setcc joins
that [#3198](https://github.com/buster14a/buster/pull/3198) left: `op_orderI`'s compare with the `k` bit,
`lua_geti` and `lua_seti`. This record is the 9700X measurement that the pull request's body promised. It covers
Lua's cycles over 33 link orders, `luaV_execute`'s own cycles, and the compile cost.

- **base:** main `1b9821afe448258d08f47f6110922478aa0e4121`.
- **head:** `87fe352744830144219530706541b8d00ecccfc1`, the pull request merged with that main.
- **Compilers:** both are `BUSTER_DEBUG_INFO=0 ./build.sh --config Release` on benchpress (`9700x/receipts.txt`:
  hashes, kernel, governor `performance`, perf version).

## Method (`scripts/record.sh`; each step is one hold of the lock, listed in `9700x/holds.txt`)

This follows `docs/commands/profiling.md`'s relative-layout protocol (#1450).

1. **Objects.** Each tree's `--tier1 -fno-asynchronous-unwind-tables -std=gnu99 -DLUA_COMPAT_5_3 -DLUA_USE_LINUX -c`
   compiled Lua 5.4.8's 33 units once.
2. **Links.** clang linked those fixed objects with `-lm -ldl` in 33 orders (`9700x/orders.txt`), the same orders
   for both trees. The orders were recorded before any timing: order 0 is the Makefile's, and orders 1 to 32 come
   from Python's `random.Random(2608)` shuffles.
3. **Outputs.** All 66 executables' outputs for #138's five scripts equal clang -O0's build of the same sources
   (`9700x/outputs.txt`: 330 same, 0 differ; the references are `9700x/ref-*.txt`).
4. **Timing.** Three rounds ran each (order, tree, script) under `perf stat -r 3 -e cycles:u,instructions:u,task-clock`,
   pinned to CPU 2 (`9700x/runs.tsv`). Within an order, the trees' order alternates by order and by round.
   `9700x/busy.txt` has the busiest other processes at each hold; none used a measurable CPU share.
5. **Profile.** For each executable, `perf record -e cycles:u -c 100003` ran the five scripts in one process
   sequence on CPU 2. `luaV_execute`'s samples and the total are in `9700x/profile.tsv`. Each (order, tree) has one
   profile.
6. **Compile cost.** 11 alternating runs per tree, on CPU 2, with one lane, of `--tier1 ... -c lvm.c` and of
   `--tier1 -O2 -c sqlite3.c` (`9700x/cost.tsv`). The `sqlite3.c` is #2608's earlier record's.

The analysis is `scripts/analyze.py` and its output is `analysis.txt`. For each order, it takes the median over the
three rounds of each tree's user cycles. It then takes the paired log ratio head/base and reports that ratio's mean
over the 33 orders, with a t interval over the orders as the independent layouts.

## Results

| Lua, user cycles, head vs base over 33 orders | mean | 95% interval | orders head faster |
| --- | ---: | ---: | ---: |
| arithmetic | +0.20% | -0.90% .. +1.32% | 19/33 |
| calls | -0.92% | -1.54% .. -0.29% | 24/33 |
| closures | -0.67% | -1.46% .. +0.12% | 21/33 |
| strings | -0.33% | -1.89% .. +1.26% | 15/33 |
| tables | +0.05% | -0.59% .. +0.69% | 15/33 |
| **all five** | **-0.34%** | **-0.86% .. +0.18%** | 17/33 |
| `luaV_execute`'s own cycles (perf record) | +0.51% | -0.47% .. +1.50% | 16/33 |

- **Instructions.** User instructions over the five scripts fall from 4.551 G to 4.531 G, or -0.45%; every order
  agrees to within 0.15%. This matches the pull request's callgrind count, -0.71%.
- **Cycles.** The change in cycles is not resolved over placements. The five scripts' interval covers zero, and so
  does `luaV_execute`'s, whose estimate is one profile per layout. Only `calls` is resolved, at -0.9%. The ranges
  per order are wide (up to +18%/-18% on single scripts), which is why the single-layout reading is not reported
  as a result.
- **`luaV_execute`'s share.** It is 40% of the five scripts' cycles in both trees.

| Compile cost, one lane, CPU 2, medians of 11 | cycles | instructions |
| --- | ---: | ---: |
| `lvm.c`, `--tier1` | -0.55% (115.0 M → 114.4 M) | +0.18% |
| `sqlite3.c`, `--tier1 -O2` | +0.09% (3.307 G → 3.310 G) | +0.23% |
