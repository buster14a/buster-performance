# #3450 / #2924 phase D: Tier 1 BURS's per-lane classify

The gate record of buster14a/buster#3493 (`claude/2924-tier1-burs`). Session: `session_01EgbxndFreFrJqAywiEGoue`.
`tier1-burs-census/` has the census that chose the route.

Main's `tier1_burs_classify_vector` sent three kinds of lanes to a scalar `tier1_burs_classify_node`, one lane at a
time:
- stack addresses;
- addresses whose constant index or offset passed 32 bits;
- floating == and !=.

The PR classifies the first two in the vector kernel and deletes the scalar classifier. Floating == and != keep
`tier1_burs_equality`, whose bounded walk candidate generation shares.

## How it was measured

Each run is `benchmark-tier1-select-source` on sqlite3.c and Lua 5.4.8, on the 9700X under `exclusive.sh`, on CPU 2,
with znver5 Release binaries (`BUSTER_DEBUG_INFO=0`). Base and head alternate, one locked run each. The benchmark
first checks every function's classes, states and rules against their definitions (`mismatches`), then times
selection per IR instruction. Its `select` row gives:
- ns/instr;
- cyc/instr, the column compared below;
- ins/instr;
- cyc/entry;
- IPC;
- thr/instr.

| log | base | head | result |
| --- | --- | --- | --- |
| `run.log` | main f44baa726 | the reviewed head | void: both shipped binaries lacked the execute bit, and the script's grep hid "Permission denied" |
| `run2.log` | main f44baa726 | 59af7596a (after review) | head slower in all 6 pairs |
| `run3.log` | main d6daf644d (the tree 831eeb5f6 merged) | 48f5d1728 (the slot table) | parity |

`run2.sh` and `run3.sh` check that each binary runs and print each run's exit status. Every run exited 0, with 0
mismatches.

## run2: four gathers a block

Cycles per IR instruction, three rounds:

| | base | head | medians |
| --- | --- | --- | --- |
| sqlite3.c | 373.01, 373.30, 372.21 | 373.92, 374.38, 374.84 | +0.37% |
| Lua | 390.98, 390.42, 392.01 | 393.68, 392.02, 392.39 | +0.36% |

The ranges don't overlap, and instructions rose from 963.65 to 964.07 a node. The cause was the frame-object path:
every block with a stack address gathered its slot records with four masked qword gathers (sizes and second qwords,
both halves) for the one or two lanes such blocks usually have. Main's scalar classifier read them with a few loads.

## run3: the slot table

48f5d1728 classifies a function's first 64 slots once, eight 16-byte records a step, split by two `vpermt2q`, into a
64-bit mask. Each block's stack addresses then read their bit with two `vpsrlvd` (by the slot, and by the slot minus
32; a count of 32 or more gives 0). Functions with more slots keep the gathers. Each form is the only code for its
range. The tests run the slots fixture at 23, 32, 33, 63, 64, 65 and 100 slots, and three mutants were built:
- the boundary moved to 65: killed;
- the high dword's shift by 31: killed;
- the boundary moved to 63: equivalent, since both forms give the same classes.

| | base | head | medians |
| --- | --- | --- | --- |
| sqlite3.c | 375.77, 374.22, 373.66 | 373.41, 372.43, 374.69 | 374.22 → 373.41 (-0.22%) |
| Lua | 395.86, 400.62, 390.84 | 392.24, 391.12, 391.90 | 395.86 → 391.90 (-1.0%) |

- **Pairs:** four of six favor the head; round 3 reads +0.28% (sqlite3.c) and +0.27% (Lua).
- **Noise:** base's Lua rounds 1 and 2 ran under interference (thr/instr 22.2 and 27.8 against about 10 elsewhere), so
  Lua's median gain is mostly noise.
- **Instructions:** 963.69 to 964.95 a node, from the table build per function and the per-block shifts; cycles don't
  follow.
- **Reading:** parity within ±0.3% on the whole selection pass, against run2's consistent +0.37%.

**Objects:** all 1,371 objects of sqlite3.c, Lua and musl under `--tier1 -c --lanes 1` are byte-identical between the
branch's heads and main (`tier1-burs-census/objects.sh`).
