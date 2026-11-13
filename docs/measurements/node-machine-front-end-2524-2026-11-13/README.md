# The node machine's sweeps: their front end, and T's rare paths out of line (#2524's step 1, 2026-11-13)

This record is for [buster#2524](https://github.com/buster14a/buster/issues/2524)'s step 1, the pull request that takes
T's rare paths out of its loop's line. `docs/node-machine.md`'s "The sweeps' front end: T's rare paths out of line"
section summarizes it.

The sweeps are bound by fetching their code, not by their instructions. Timed one sweep set at a time on `sqlite3.c` at
main `b7a95eed`, T leaves 29% of its dispatch slots empty for want of ops from the front end, C 52% and X 59%, and the
three miss the L1 instruction cache 18.4 times a taken node. Half of T's misses fall on 12 of the 141 64-byte lines of its
code that missed, the loop's common path, among which the loop had its rare paths inlined. A build with profile-guided
optimization trained on the shadow bounds what a layout can give: the three sweeps 10% faster on `sqlite3.c` and 16% on
Lua, which it wasn't trained on. Moving T's rare paths out of line by hand (`__attribute__((cold, noinline))` and
`__builtin_expect`) takes 13 cycles a node off T on both inputs, on the same instructions, at every placement tried.

Everything timed ran on the Ryzen 7 9700X (`benchpress`), each run in a hold of the lock, pinned to CPU 2, with the scripts in
`scripts/`. `time.sh`, `corpora.sh`, `ab.sh`, `medians.py`, `build-patch.sh` and `lock.sh` are
[the T loop record](../node-machine-t-loop-2524-2026-11-13/)'s. `results/env.txt` has the kernel, clang, perf and the
CPU's governor.

## Versions

| label | what | source |
| --- | --- | --- |
| `m3` | main | [`b7a95eed`](https://github.com/buster14a/buster/commit/b7a95eedbe16fbd8434654f192f8f7aab76c56e5) |
| `only` | main, and `BUSTER_NODE_SHADOW_ONLY=k` to time one sweep set alone (0: T, 1: T and C, 2: all three) | `patches/only.patch` on `m3` |
| `pgo-shadow` | `only` built with `BUSTER_PGO=1` and `BUSTER_PGO_TRAIN=scripts/train-shadow.sh` (the shadow of `sqlite3.c` alone) | `build-pgo.sh` |
| `e1` | `only` and T's rare paths out of line | `patches/e1.patch` on `m3` (it holds `only.patch` too) |
| **`pr`** | the pull request's code: `e1` without `only.patch` | [`050a73cf`](https://github.com/buster14a/buster/commit/050a73cfcc259100a72e6ecba287f04b36ee95a8) |
| `only-sN`, `e1-sN` | `only` and `e1` with N bytes of padding before the checker unit's code (`./build.sh shifts`), N = 0, 1,024, 2,112, 3,136 | `build-shifts.sh` |

Each build is `results/LABEL/build.log` (the shifted builds' is `results/only-shifts/build.log` and
`results/e1-shifts/build.log`), the lock's waiting lines removed; its binary's hash is `results/LABEL/compiler.sha256` and
its revision and patch hashes `results/LABEL/revision.txt`. `only.patch` changes `node_shadow_time` alone, and its
`getenv` runs once a timing. The pull request's later commit changes a comment alone.

## Where the sweeps' cycles go (`explore-sets.sh`, `scripts/sets.py`)

`perf stat` of `cycles`, `instructions`, `de_no_dispatch_per_slot.no_ops_from_frontend`,
`ic_tag_hit_miss.instruction_cache_miss` and `ex_ret_brn_misp`, user mode, with `--passes 0` and with `--passes 40` timing
one sweep set alone; each set's 40 passes, less `--passes 0`, per machine-taken evaluated node (258,466 on `sqlite3.c`,
57,954 on Lua). T is set 0, C set 1 less set 0, X set 2 less set 1. The five events share the core's counters by turns (the
NMI watchdog holds one), so each figure is a difference of two processes' scaled counts and moves by up to a tenth between
runs; `results/sets.txt` has every run and the medians. The empty-slot share is the front end's empty slots over eight a
cycle.

| `sqlite3.c`, medians of 3 (`only`) | cycles | instructions | empty slots | share | L1i misses | mispredicted |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| T | 100.5 | 324.7 | 232.0 | 29% | 7.2 | 0.8 |
| C | 53.4 | 191.9 | 220.3 | 52% | 5.9 | 0.4 |
| X | 37.4 | 105.3 | 176.4 | 59% | 5.1 | 0.4 |
| all three | 190.4 | 621.5 | 627.9 | 41% | 18.4 | 1.6 |
| **`pgo-shadow`, one run** | | | | | | |
| T | 88.0 | 308.1 | 231.7 | 33% | 3.6 | 0.8 |
| C | 47.2 | 183.2 | 158.0 | 42% | 2.3 | 0.4 |
| X | 35.6 | 102.0 | 161.2 | 57% | 1.5 | 0.4 |
| all three | 170.8 | 593.4 | 550.9 | 40% | 7.5 | 1.6 |
| **`e1`, medians of 2** | | | | | | |
| T | 85.3 | 315.9 | 212.9 | 31% | 6.3 | 0.8 |
| C | 53.9 | 192.5 | 214.3 | 50% | 5.7 | 0.4 |
| X | 37.5 | 106.9 | 187.1 | 62% | 5.0 | 0.4 |
| all three | 176.7 | 615.4 | 614.3 | 43% | 17.1 | 1.6 |

On Lua (medians of 3, `only`): T 92.2 cycles, 21% of its slots empty; C 46.2, 53%; X 25.2, 56%; all three 161.6 cycles and
20.5 misses a node. `pgo-shadow` took the three to 135.4 and 10.1 misses; `e1` to 148.0 and 18.8. Lua's per-set
instructions swing by up to half between runs (C 127 to 223 on `only`): the scaling of multiplexed counts, which is why the
comparisons below use the shadow's own counters.

- **Front end, not branches.** Over a whole 40-pass run at `e412d48e` ([the T loop record](../node-machine-t-loop-2524-2026-11-13/)'s
  `v11`), `perf stat -M PipelineL1,PipelineL2` puts 39.9% of the slots on the front end (21.9% latency, 17.9% bandwidth),
  9.8% on bad speculation (9.5% mispredictions), 18.5% on the back end and 35.1% retiring (`results/v11/bm/stat-p40.txt`;
  its profile of mispredicted branches by symbol and line is `results/v11/bm/misp-*`). The op cache missed 12.5% of the
  40 passes' accesses, less a run of none (`results/v11/fe/`). `results/only/only/` is `explore-only.sh`'s first look at
  the sets, with two event groups.
- **T's misses on its loop's lines** (`explore-icmiss.sh`, `results/only/icmiss-set0/`). A profile of
  `ic_tag_hit_miss.instruction_cache_miss` of T alone put 40% of the process's samples in `node_machine_type`; half of
  those fell on 12 of the 141 64-byte lines of its code that missed, at main's lines `c_check_node_machine_type.c:2125-2128`
  (a leaf's record), `2146` (an operand's record), `2165-2166` (the node's op and context), `2176` (a leaf's checks),
  `2188` (the first operand's record), and `c_check_node_machine.c:496` (the type words). `results/only/icmiss-set2/` is
  all three sets'; `results/only/layout/` has the three sweeps' functions' instruction addresses and their source lines by
  `addr2line`.
- **The PGO bound.** `pgo-shadow` inlined every sweep into `node_shadow_sweep` and laid the hot blocks out together: the
  instruction-cache misses fell from 18.4 to 7.5 a node on `sqlite3.c`, and C gained 6 cycles as T gained 12. Its profiles
  of cycles by address are `results/pgo-shadow/hot-sqlite/ips.txt` and `results/only/hot-sqlite/ips.txt`.

## The change, timed (`time.sh`)

11 passes, each sweep set's least, and again with `--repeat 2`; `m3` and `pr` in turn, each run in a hold of its own, six
times each (`run-front.sh` and `retime.sh`). `results/medians.txt` has every median, least and greatest. In cycles and
instructions a taken evaluated node:

| | T | T and C | T, C and X | T, C and X, two runs |
| --- | ---: | ---: | ---: | ---: |
| `sqlite3.c`, `m3` | 100.5, 345.9 | 155.2, 545.6 | 194.6, 649.6 | 340.3, 1,292.2 |
| `sqlite3.c`, **`pr`** | **87.6, 344.1** | **142.4, 543.7** | **180.9, 647.7** | **313.9, 1,288.4** |
| Lua, `m3` | 93.7, 437.7 | 141.7, 636.8 | 168.6, 738.3 | 318.6, 1,459.4 |
| Lua, **`pr`** | **80.9, 436.7** | **127.5, 635.7** | **154.1, 737.2** | **292.6, 1,457.3** |

- **T:** 12.9 cycles a node fewer on `sqlite3.c` (12.8%) and 12.8 on Lua (13.7%), on 1.8 and 1.0 instructions fewer. The
  three sweeps: 7.0% and 8.6% fewer cycles, 7.8% and 8.2% for two runs. C and X each take within 1.4 cycles of main's.
- **One of `m3`'s runs was slow throughout** (`results/m3/time-sqlite3-f3.txt`: T 119.9, its ticks slower in the same
  ratio); the medians of six are robust to it. `m3`'s first round gave up waiting for the lock and ran later as `f1`.

## Placement (`build-shifts.sh`)

`./build.sh shifts` pads the checker unit's code, which holds the node machine (`main_unit_checker.c`'s plain `.text`),
by N bytes. `only-sN` and `e1-sN` timed in turn by `time.sh`, two or three runs each (`only-s0` one), T in cycles a node:

| N | `sqlite3.c`, `only` | `sqlite3.c`, `e1` | Lua, `only` | Lua, `e1` |
| ---: | ---: | ---: | ---: | ---: |
| 0 | 100.4 | 88.5 | 92.3 | 80.5 |
| 1,024 | 99.4 | 88.4 | 91.7 | 81.0 |
| 2,112 | 98.9 | 88.8 | 92.2 | 81.8 |
| 3,136 | 100.2 | 88.3 | 92.8 | 80.9 |

The gain holds at every placement: it is the layout of T's own code, not where that code lands.

## Symbols (`results/symbols-m3-pr.txt`)

`nm -S` of the node machine's and the shadow's functions in `m3` and `pr`: `node_machine_type` goes from 13,880 bytes to
11,410, `node_machine_contexts` from 8,631 to 7,484, and four functions are new out of line: `node_machine_type_action`
(275), `node_machine_leaf_whole` (247), `node_machine_same_as_action` (803, inlined before) and
`node_machine_number_labels` (1,199, inlined before). Every other function is the same size.

## The comparison (`corpora.sh`)

`measure-node-machine --shadow --verify --passes 0` by `pr`'s compiler on the frozen `sqlite3.c`, Lua 5.4.8's 34 sources
and musl's 1,336 units, each without and with `-g` (`results/pr/verify-*.txt`): 0 differences in values, entries and the
twin on all six, status 0, with main's counts (`sqlite3.c`: 258,466 machine-taken nodes, 716 typed by the action). T's
refusals reach none of `sqlite3.c`'s expressions, one of Lua's (a callee) and 39 of musl's (leaves); C's label numbering
runs for 2,824 of `sqlite3.c`'s 51,289 taken expressions, 551 of Lua's 10,469 and 1,450 of musl's 21,622.

## `-c sqlite3.c` is unchanged (`ab.sh`)

`time-runs`, 21 runs each after 2 warm-ups in Williams order, one hold of the lock (`results/ab-m3-pr/`): 124.576 ms
against main's 124.846 ms wall (-0.22%), 601.6 M against 601.0 M user cycles (+0.10%), 1,353.36 M instructions on both.
The machine runs only under `measure-node-machine --shadow`.

## Limitations

- The per-set counts are multiplexed; they show where the cycles go, and the shadow's own counters (`time.sh`) compare the
  versions.
- `pgo-shadow` was timed once, by `perf stat`; it is a bound for the layout, not a candidate: it lays the whole compiler
  out by one input's profile.
- Each version's timings are its own processes, interleaved with the others'; cycles move by a few percent between processes
  of one executable.
