# The direct path's identifier lookups (buster#3583): the ceiling and ten designs on the 9700X

buster#3583 asked what the direct path's identifier lookups cost and what perfect ones would save, before building
any of its three directions (the macro's flag in the cache's slot, probes that overlap, smaller slots). This record
has the ceiling, the profile behind it and the designs measured against it. **None was kept:** the one that measured
faster on main `20f3573e` measures the same as main `09c3b79b`, whose own hash change (buster#3592's `d58cf20b`) took
out the same instructions.

- **Host:** `benchpress` (Ryzen 7 9700X), every run under `~/buster-fast-bench/exclusive.sh`, pinned to CPU 2.
- **Unit:** the frozen `sqlite3.c` with the corpus's headers and predefines, as
  [direct-speed-2850-2026-11-24](../direct-speed-2850-2026-11-24) compiles it.
- **Builds:** each variant is that record's harness (`scripts/direct_main.c` there) around the variant's
  `c_direct.c`, built in a cloud container with CI's clang 23.1.4 at the product's znver5 Release flags
  (`scripts/mkh.sh`) and shipped. The base is main `20f3573e`.
- **Readings:** `scripts/ab.sh`, the earlier record's script with this record's paths: rotated rounds of 20 compiles a
  process, the medians of the harness's stages over the rounds. The stage is lexing and preprocessing (`pre-ms`); the
  code generator's stage moves with placement alone and is not read.
- **Placement:** `scripts/mkpad.sh` builds a variant with a function of N one-byte nops ahead of the lexer's code.
  Each arm of the last four holds is 7 placements, N = 0, 48, 528, 1,584, 2,560, 4,128 and 6,000 (see "Placement").

Variant names in `results/` and the patches against main in `patches/`:

| results | patch | what |
| --- | --- | --- |
| `ceilid`, `ceilemitid`, `ceilidm`, `ceilemit` | `ceiling-replay.diff` | the ceiling: lookups replayed from a first compile's record |
| `step1` | `v1-window-vector-probe.diff` | every window's names probed when it is lexed, 16 tokens at a time, gathers |
| `b1` | `v2-masked-key-flag.diff` | key by one masked 16-byte load, no branch on the length; macro flag in the slot |
| `b1pf` | `v3-slot-prefetch.diff` | v2, and each block's slots prefetched before its loop |
| `b2` | `v4-masked-key-flag-identifier-pass.diff` | v2, and a block's names in a loop of their own ahead of the others |
| `c1` | `v5-crc32-flag.diff` | CRC32 hash, macro flag in the slot, the window's columns in registers |
| `c4` | `v5b-parallel-crc32.diff` | v5 with the two CRC32s independent and xored |
| `c3` | `v6-call-free-identifier-loop.diff` | v5, and the names the cache answers in an inner loop with no call, the emitter out of line |
| `c5` | `v7-flag-only.diff` | v5 with the multiply hash back |
| `c6` | `v8-crc32-only.diff` | v5 with the macro bit read from `macro_bits` again |
| `e1` | `v9-lazy-window-probe.diff` | v5, and a block's names probed once a window, branch-free, the emitter taking the answers |
| `final` | | v5 with a test and its comments |
| `B` | `v10-flag-on-main-09c3b79b.diff` | v5's macro flag and columns on main `09c3b79b`, its hash kept (the test included) |
| `A` | `v10b-crc32-on-flag.diff` (on v10) | `B` with v5's CRC32 hash |
| `main2` | | main `09c3b79b` |

## Result: nothing to keep on main `09c3b79b`

On main `09c3b79b` (`results/main2-wide.txt`, 7 placements each, 5 rotated rounds), the lexing stage in ms:

| | median | mean | range | user instructions |
| --- | ---: | ---: | --- | ---: |
| main `09c3b79b` | 6.911 | 6.912 | 6.890 to 6.943 | 220.44 M |
| `B`: the slot's macro flag, main's hash | 6.915 | 6.913 | 6.890 to 6.931 | 220.58 M |
| `A`: the slot's macro flag, the CRC32 hash | 6.926 | 6.910 | 6.861 to 6.943 | 221.76 M |

Main moved under this work: `d58cf20b` (buster#3592) mixes a name's last word and length into the hash only past eight
bytes, which took 1.36 M instructions out of the compile. That is where v5's gain on `20f3573e`, below, came from:
v5 read 220.44 M instructions there, as main `09c3b79b` does now. The slot's macro flag, the part `d58cf20b` did not
do, saves nothing measurable, with either hash; so does reading the bit from the record in the ceiling (below).

### v5 on main `20f3573e`

The cache's slot holds the name's macro flag beside its kind, `fast_ident_set_macro_bit` keeps it, the key's hash is
two CRC32 instructions, and the emitter holds the window's three columns in registers. Two holds of 7 placements each
(`results/final-wide.txt`, `results/attr-wide.txt`), the lexing stage in ms:

| | median | mean | range |
| --- | ---: | ---: | --- |
| main, first hold | 6.955 | 6.949 | 6.909 to 6.977 |
| v5 (`final`), first hold | 6.899 | 6.903 | 6.832 to 6.958 |
| main, second hold | 6.949 | 6.937 | 6.894 to 6.955 |
| v5 (`final`), second hold | 6.906 | 6.897 | 6.824 to 6.947 |

That is 0.04 to 0.05 ms (0.6 to 0.7%) of the stage, and 0.24 to 0.26 M of 80 M user cycles a compile (mean). User
instructions fall from 220.96 M to 220.44 M. Neither half pays alone (second hold, means): the slot's flag with the
multiply hash 6.948 ms, the CRC32 hash with the bit read from `macro_bits` 6.956. The object is the same in every
variant (`f558aaf503fcb186`).

That was a ninth of the ceiling, and main has it now by another way. The rest is not reachable by the directions
measured here; "Where the time goes" says why, and "What is left" what might.

## The ceiling (`results/ceiling-1.txt`)

The first compile of a process records every `fast_ident_lookup`'s id, kind, whether the slot held it and the name's
macro bit; later compiles take a recorded hit's answer without probing (`patches/ceiling-replay.diff`, measurement
only). A recorded miss runs the lookup as it was, so the table and the cache evolve as before and the objects are the
same. 11 rotated rounds:

| | lexing ms | user cycles | instructions | mispredicted |
| --- | ---: | ---: | ---: | ---: |
| main | 6.905 | 80.05 M | 220.96 M | 964 K |
| every lookup's hit replayed | 6.336 | 76.82 M | 216.15 M | 911 K |
| the emitter's hits replayed (`ceilemitid`) | **6.436** | 77.36 M | 217.35 M | 917 K |
| the emitter's, and its macro bit from the record | 6.700 | 78.49 M | 224.52 M | 922 K |

Perfect lookups save 0.47 ms in the emitter and 0.57 ms in all (8.2% of the stage). Taking the macro bit from the
record as well saved nothing more: the bit's load is not the cost (the variant passed the bit through a global, which
cost instructions of its own).

## Where the time goes

**Lookups by caller** (`results/counts.txt`, one compile): the emitter 241,350 (228,431 hits; 14,904 names of more than
16 bytes), the reader of directives and arguments 42,105, `fast_lex_one` 2,971. The emitter sees 27,752 macros' names,
12,627 of them one-token macros replaced where they stand; 15,125 stop its block, and the next block starts after the
macro's expansion: its 24,379 blocks hold 1,239,433 token places for about 540,000 tokens emitted.

**The profile** (`results/prof-base-*`): in `fast_pp_drain` (12.2% of user cycles, the emitter inlined), the slot's
first compare and its branch take 11.4% of the function's samples, the hash 13%, the macro bit's test 6.5%. Branch
mispredictions sample on the target after the `len <= 8` branch, the slot's compare and the macro's test.

**Fills** (`results/fills.txt`): the ceiling removes 53 K (emitter) to 72 K (all) demand fills from L2 a compile; L3
and DRAM fills do not move. The 384 KB cache lives in L2, and a lookup in four or five takes its slot from there.

The ceiling's 2.6 M cycles in the emitter are, roughly: 3.6 M instructions at the compile's 2.8 an cycle (1.3 M),
48 K mispredicted branches (0.7 M) and 53 K fills from L2 (0.6 M). The branches that cost are the macro's and the
hit's: they resolve only once the slot is loaded, and a mispredicted one drops the probes issued after it. The
`len <= 8` branch also mispredicts, but resolves as soon as the length is loaded: v2 removed 36 K of those
mispredictions and gained nothing.

## The other designs

Lexing stage, the variant against main in the same hold (ms):

| design | main | variant | |
| --- | ---: | ---: | --- |
| v1 window probe, gathers | 6.907 | 7.727 | the probe took 8.3% of user cycles where the emitter saved 4.1% |
| v2 masked key, flag | 6.895 | 6.952 | 36 K fewer mispredictions, 3.2 M more instructions |
| v3 v2 and slot prefetch | 6.945 | 7.535 | 12 M more instructions: blocks restart after macros, and each is prefetched again |
| v4 v2 and identifier pass | 6.916 | 7.016 | 52 K fewer mispredictions, 4 M more instructions |
| v6 call-free identifier loop | 6.932 (3) | 6.918 (3) | 1.75 M fewer instructions, the stage unchanged |
| v9 lazy window probe | 6.920 (3) | 7.433 (3) | 6 M more instructions, 50 K more mispredictions: two loops more a block |
| v5b parallel CRC32 | 6.924 (3) | 6.847 (3) | as v5 (6.842) |

(3): the median of three placements (0, 16, 48 nops).

- **Gathers (v1).** On the 9700X an 8-lane gather costs what its loads cost, and a probe needs five or six of them a
  name (two of the text, three of the slot, one of the macro's word). Its samples sit after the gathers. It also probed
  305 K names for about 283 K lookups: a name new to the window misses when the window is probed, and the windows that
  macro calls skip were probed for nothing.
- **Anything a block (v3, v4, v9).** The emitter's block is cut by a macro's name every 22 tokens on average, so a pass
  over a block runs twice for each token it serves, or, where it keeps its answers for the window's later blocks (v9),
  costs two more loops a block, whose exits mispredict: 24 K blocks.
- **Fewer instructions alone (v2, v6).** The lookup is not bound by its instructions: v6 took 1.75 M of them out and the
  stage did not move.

## Placement

v5's first build read 6.84 ms in three placements of 0, 16 and 48 nops, against main's 6.91. Its
final build differs from v5 only by a test and comments; the test, in the same unity file, moved the lexer's code
6,416 bytes later, and three placements of 0, 16 and 48 nops read 6.93 (`results/final-pad.txt`). The two builds'
`fast_pp_drain` are the same instructions. A move of a few kilobytes is worth 1.3% of this stage on its own, and
paddings of 16 and 48 bytes do not span it; seven placements up to 6,000 bytes do (`results/final-wide.txt`: main's
range 0.068 ms, v5's 0.126 ms).

## Checks

- **Objects.** `scripts/equiv/run.sh` of the earlier record (6,201 units; 1,196 take the direct path) gives the same
  status, diagnostics and object for every unit with main `20f3573e` and with v5's `final`, native builds.
- **`test-direct`:** 20 passed, among them a new test of the slots' macro flags (a #define, an #undef, a keyword made a
  macro, a name made a macro before its first lookup, two names sharing a slot, the cache's growth).
- **The compile's count** (`tools/ci/compile-count.sh check`): 46,561,450 at main `20f3573e`, 46,570,841 with v5's `final`, +0.020%.
- **Sanitizers.** `c_direct.c` built with `-fsanitize=address,undefined` passes `test-direct`'s 20 tests and compiles
  `sqlite3.c` to the same object without a report.

These checks are of v5's `final` on `20f3573e`; `B` and `A` compile `sqlite3.c` to the same object.

## What is left

The ceiling's 0.47 ms is a lookup's answer deciding the emitter's control flow: a macro's name (27,752 a compile)
stops the block, and its branch, like a miss's, resolves only after the slot's load. Every design here either probed
on the same path (and kept the late branch) or moved the probe ahead of the emitter (and paid for passes over blocks
that a macro cuts every 22 tokens). What could reach it is an emitter whose block does not end at a macro's name: the
names' answers for a whole window first, branch-free, and the macros' expansions spliced into the output afterwards,
so that the only branch on a macro is one a window rather than one a name. That is a redesign of how
`fast_pp_window_macro` interleaves with the emitter, not of the lookup.
