# buster#2524: the sweeps' code layout, what a profile-guided build finds (2026-11-15)

Claimed in [buster#2524](https://github.com/buster14a/buster/issues/2524#issuecomment-6892645170) after
[the batching record](../node-machine-batches-2524-2026-11-14): batching keeps the sweeps' code warm but loses the
predictor's handoff between sweeps on the same expression, so this round looks for warm code by making the hot code
smaller instead. Its first step bounds what a better layout can give, with a profile-guided build of main.

**The result: on `sqlite3.c`, the gate's file, the profile-guided build gains 1.0 cycle a taken node (0.6%), though it
was trained on that file. Lua gains 6.3 (4.4%) and musl 7.7 (6.0%).** It inlines the three sweeps into the timing loop
and grows T's rule function from 26.4 KB to 106.8 KB: the sweeps' hot code gets larger, not smaller, and `sqlite3.c`'s
instruction-cache and op-cache misses don't fall. So it bounds nothing on `sqlite3.c`, and this round found no layout
headroom there.

Two more findings:
- **`BUSTER_PGO` was broken on main.** Since the start's code order (#1444) the instrumented executable's link fails
  ("the start's code order placed no function"): its objects were `pgo/objects/UNIT.o`, where the order's linker script
  names `*/UNIT.c.o`. buster#2836 names them `UNIT.c.o`; `pgo2` is built with that fix (`71997da`).
- **The sweeps' hot code is about 38 KB** against the 32 KB instruction cache: 99% of their cycles fall on 605 64-byte
  lines (below). T's rule function (`node_machine_rule`, 26.4 KB) touches 292 of its lines; 90% of its cycles fall on 137.

## Builds

The 9700X (`benchpress`), Release, each in a fresh worktree:

| label | revision | what |
| --- | --- | --- |
| `m4` | buster `e62535f` | main |
| `pgo2` | buster `71997da` (`e62535f` with buster#2836's fix) | `BUSTER_PGO=1`, `BUSTER_PGO_TRAIN=scripts/train-shadow.sh`: the shadow of `sqlite3.c` alone, 3 passes, by the instrumented compiler (`scripts/build-pgo.sh`) |

`scripts/job1.sh` built `m4` and tried `pgo` at `e62535f`, which failed at the instrumented link
(`results/pgo-build.out` on the host, quoted in buster#2836); `scripts/job2.sh` built `pgo2`.

## Timings (`scripts/time-g.sh`, `scripts/time-musl.sh`, job 2)

The shadow's sweeps, 11 passes, each sweep set's least, in cycles a taken node; `m4` and `pgo2` in the same hold of the
lock, one hold a round (`sqlite3.c` and Lua; musl's each run its own hold). Medians of three rounds (two for musl), by
`scripts/medians-b.py`:

| | `sqlite3.c` T | C | X | all three | Lua all three | musl all three |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| `m4` | 95.4 | 48.3 | 32.1 | **175.3** | **143.7** | **128.5** |
| `pgo2` | 92.2 | 50.3 | 31.4 | **174.3** | **137.4** | **120.8** |

- **Every round agrees within 1.4 cycles of its median.** `pgo2`'s three `sqlite3.c` rounds are 175.4, 172.9 and
  174.3; `m4`'s are 175.3, 175.1 and 175.9.
- **On Lua and musl, X gains most:** 24.1 to 19.8 and 21.2 to 16.9.
- **The same `m4` file ran 169.2 on `sqlite3.c` in job 1** (`results/m4/time-b--*-r*.txt`, three rounds within 0.4 of
  each other) and 175.3 in job 2, hours later. Only figures within one job's interleaved rounds compare.

## Where the cycles and the misses fall (`scripts/hot.sh`, `scripts/footprint.py`)

`perf record` of the shadow of `sqlite3.c`, 40 passes, user mode: `cycles` every 20,011,
`ic_tag_hit_miss.instruction_cache_miss` and `op_cache_hit_miss.op_cache_miss` every 2,003. Each pass times T alone, T
and C, and all three, so T's code runs three times a pass, C's twice and X's once. The samples' addresses are
`results/*/hot-*.txt.gz`; `results/*/footprint-*.txt` count the 64-byte lines they fall on.

| | cycles' lines, 50/80/90/95/99% | instruction-cache misses' | op-cache misses' |
| --- | --- | --- | --- |
| `m4` | 40, 152, 266, 377, **605** | 42, 168, 291, 415, 636 | 42, 160, 285, 407, 639 |
| `pgo2` | 41, 154, 271, 398, **669** | 47, 186, 338, 488, 770 | 45, 175, 316, 459, 732 |

At `m4`, by function:

| | size | share of the sweeps' cycles | lines touched | lines holding 90% | 99% |
| --- | ---: | ---: | ---: | ---: | ---: |
| T's loop (`node_machine_type`) | 4.3 KB | 35.6% | 60 | 27 | 48 |
| T's rules (`node_machine_rule`) | 26.4 KB | 28.2% | 292 | 137 | 237 |
| C (`node_machine_contexts`) | 5.8 KB | 20.2% | 85 | 40 | 66 |
| X (`node_machine_expand`) | 5.6 KB | 7.9% | 61 | 27 | 48 |

- **The misses fall where the cycles do**, across the same few hundred lines: the sweeps' working set is larger than
  the instruction cache, not a few lines in conflict.
- **T's rules** (`scripts/attr2.sh`, `results/attribution/`, by source function): the type table's inlined queries
  (`c_types.c`, each a load of a type's column) take 27% of `node_machine_rule`'s samples on 80 lines, the argument
  memo 10% on 12, the switch itself 10% on 12, `node_machine_member` 7% on 15, `node_machine_operand_value` 7% on 71
  (it is inlined at 18 sites), `node_machine_store_rule` 7% on 28 and `node_machine_discard` 5% on 6.
- **`minsize` on `node_machine_rule`** (`results/minsize.patch`, a Develop build in the cloud container) shrinks it
  only from 26.1 KB to 23.4 KB: its size is the rules it holds, not how they're compiled.
- **`pgo2` moves no misses on `sqlite3.c`**: its sweeps (`node_shadow_time`, 19.1 KB, into which it inlined T, C and X,
  and `node_machine_rule`) take 52,269 instruction-cache miss samples against `m4`'s 47,741, and 53,504 op-cache miss
  samples against 47,449.

## Traps

- **`BUSTER_PGO` needs buster#2836** on any main since #1444.
- **The cloud container's `llvm-profdata`** is the system's (format 9) where the staged clang writes format 11, so a
  `BUSTER_PGO` build there fails at the merge; the 9700X's clang has its own beside it.
- **`addr2line -f -i`** of the Release build names `node_machine_rule` itself as the innermost function at most of its
  addresses; by source line (`addr2line -a`, `scripts/attr2.sh`) the samples land on the inlined rules' lines.
