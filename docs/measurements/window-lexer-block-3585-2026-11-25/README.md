# The window lexer's 64-byte block (buster#3585): counts, ceilings, a leaner block, and what bounds it in the compile

[buster#3585](https://github.com/buster14a/buster/issues/3585) asked about `fast_pp_lex_window` (`c_direct_lex.c`),
the direct path's lexer of raw tokens, 8% of the compile of the frozen `sqlite3.c`: its block spills, has 15% of the
loads that fail to forward, and its instructions a block were unknown. This record has the counts, the ceilings, the
redesign's steps and the probes that show what the block waits on in the compile.

- **Host:** `benchpress` (Ryzen 7 9700X), every run under `~/buster-fast-bench/exclusive.sh`, CPU 2, the object on
  `/dev/shm`. Base: buster main `20f3573e`.
- **Unit:** the frozen `sqlite3.c` (9,507,037 bytes) with the corpus's headers and predefines, as
  `tools/ci/compile-count.sh count` compiles it.
- **Builds:** in a cloud container with CI's clang 23.1.4, `-march=znver5`, shipped to the host:
  `scripts/mkv.sh` (the harness `direct_main.c` of buster-performance's `direct-speed-2850-2026-11-24` around a
  tree's `c_direct.c`, and the microbenchmark), `scripts/mkpad.sh` (the harness with a 0, 16 or 32-byte function
  linked ahead of `c_direct.c`: three placements of each arm), and the products by
  `BUSTER_HOST_ARCH=znver5 BUSTER_DEBUG_INFO=0 ./build.sh --config Release`.
- **Scripts:** `scripts/ab.sh` (the harness, rotated rounds, 20 compiles a process: per-compile medians of the
  counters and of the stages), `scripts/ab-product.sh` (the product, one compile a process), `scripts/micro.sh` (the
  microbenchmark), `scripts/prof.sh`, `scripts/lbr.sh` (branch records, cache fills), `scripts/stlf.sh` (forwarding
  failures by function), `scripts/final.sh` (the last hold). `probes/` has the experiments' patches.

## Counts at main (`results/counts.txt`)

`scripts/patch_count.py`'s counters in a copy of main's sources (counts, not times; the object is unchanged):

| | |
| --- | ---: |
| windows (line windows: a directive's or an argument's line) | 20,787 (14,028) |
| blocks (in line windows) | 86,025 (17,329) |
| full blocks (64 bytes, no stop) | 36,113 |
| tokens from blocks | 745,592 (8.7 a block) |
| bytes lexed by blocks | 3.42 MB |
| block comments that stop a block (bytes) | 24,384 (3.44 MB) |
| ... of at most 64 bytes, closing in their own block, in the next | 17,017, 9,286, 9,525 |
| line windows' ends, directive stops, strings, character constants, `/` operators | 13,282, 6,620, 2,576, 1,697, 495 |
| blocks with a token marked for `fast_lex_one` | 972 |

## Where the function's time goes at main (`results/profile-main/`)

Per compile, the harness: 80.1 M user cycles, 221 M instructions, 0.97 M mispredicted branches, 0.54 M forwarding
failures. `fast_pp_lex_window` has 8.3% of the cycles (6.6 M), 8.9% of the instructions (19.6 M), 6.5% of the
mispredictions and 8.6% of the forwarding failures (46 K). By address: the block loop 74% of its cycles (57 cycles and
about 173 instructions a block), the comment skipper 10.6%, the prologue 5.2% (16 tables loaded a window), the stop's
dispatch 3%.

## Ceilings (`results/micro-ceil.txt`)

`scripts/lexbench.c` runs the real `fast_pp_lex_window` over `sqlite3.c` stripped by `scripts/sanitize.py` of every
byte a block stops at (4.85 MB, every block full, 14.6 tokens a block), window after window, 200 passes a process.
Per block, the medians of 5 rotated rounds, `probes/ceil.py` on main:

| main `20f3573e` | cycles | instructions | forwarding failures / 1000 blocks |
| --- | ---: | ---: | ---: |
| the block | 38.0 | 185.4 | 157 to 564 (by where the window's arrays sit) |
| no stores (the packed vectors folded into a sink) | 32.9 | 151.0 | 5 |
| the masks only (no compress, no stores) | 29.1 | 131.9 | 4 |
| the loads, the class lookup and the stop only | 3.7 | 23.1 | 0 |
| four stores of the bytes only | 6.0 | 8.7 | 24 |

The masks are 25 of the 38 cycles; the stores and their marked tokens about 5. The loads that fail to forward come
from the window's stores (none without them), and their count moves threefold with the arrays' offset in their pages.

## The redesign's steps

The block computes the class of the byte after each byte by a second lookup on the bytes one further on (the `p + 1`
load it already had), masked to 0 for bytes of 128 and more: a run's end, a `.` that goes on as a number and a pair's
second character come from it, with no shift across the block's end and no lookups of the next block's first byte. A
pair's index is the first character's class or'ed with the next class's low bits (one `vpternlogd`). The pairs' even
places and the marked tokens are taken only on a rare branch (two candidates touch, one is at the last byte, or a `.`
goes on: 1.3% of the microbenchmark's blocks). A token's last byte is a run's last, a punctuator's only or a pair's
second, so one compress of the last bytes gives every token's length (no `pext`, no expand). The window's arrays are
one region addressed by one register; first bytes are 16-bit offsets from the window's first byte (one store of 32
tokens a block instead of two of 16), and a window stops before its tokens are 64 KB from its first byte. The carried
run's token is the window's last, so no index is carried; nor is `tail_run` (the byte before the stop says it).

| step | micro cycles / instructions a block | the compile's lexing stage, ms |
| --- | ---: | --- |
| main | 38.0 / 185.4 | |
| v1: the next byte's classes, rare pairs, lengths from last bytes | 36.8 / 144.6 | the long-run check became a branch on the carry: 443 mispredictions / 1000 blocks |
| v2: one region, the long-run check without a branch | 30.8 / 147.6 | 6.897 against main's 6.937 (one placement) |
| v3: no `tail_run` | 31.1 / 143.6 | 6.884 against 6.950; another hold 6.966 against 6.955 |
| v4: 16-bit first bytes | 30.4 / 138.7 | three placements: 6.891, 6.962, 6.925 against main's 6.927, 6.970, 6.943 |
| v5: the tests masked by the stop's mask | 33.5 / 130.6 | not kept |
| v6: a comment that closes in its block, from the block's bytes | | three placements: 6.893, 6.924, 6.894 against 6.931, 6.968, 6.922 |
| v7: `prefetcht0` 1 KB ahead | | two placements: 6.865, 6.909 against v6's 6.906, 6.942 and main's 6.946, 6.956 |

`results/ab-*.txt` have the holds. Clang still keeps the text's base, the window's pointer and the file's size limit
on the stack in v4 (reloaded, never stored in the loop), where main also stored the text's pointer, `bol` and the
block's stop through the stack each block.

## What the block waits on in the compile (`results/ab-probes.txt`, `ab-twice.txt`, `profile-v2/`)

The microbenchmark's 20% is a third of a percent of the stage at most, within what placement moves it (the code
generator's stage, which no step touches, reads 8.57 to 8.70 ms across builds). The probes, in the compile:

- **Doubling the block's arithmetic** (`probes/dup.py` on v3: its masks and compresses again from an opaque copy of
  its bytes, 6.2 M instructions more) costs 0.185 ms: 12 cycles a block, what it costs in the microbenchmark. Adding
  arithmetic is exposed.
- **Nine cycles more on the stop's chain** (`probes/lat.py`: three dependent `imul` on `limit`) cost 0.066 ms, about 80%
  of 9 cycles times the 50 K blocks that stop.
- **Lexing every window twice** (`probes/twice.py`): the second pass costs main 5.52 M cycles and 20.1 M instructions,
  v4 4.59 M and 16.5 M (17% less), v6 4.30 M (22% less), and mispredicts 21 K to 24 K a compile, under half the first
  pass's. The leaner code is faster where the text is in the first-level cache and the branches have been seen once;
  the first pass is bound by what the second doesn't pay.
- **Branch records** (`scripts/lbr.sh` on v2): the comment skipper's loop exit mispredicts 38% of its executions, about
  once a comment, the block's exit 18%, then the stop's dispatch (`#`, `/`). The function's demand fills are 25 K a
  compile, nearly all from the second-level cache.
- **Forwarding failures** move with placement, not with time: the same source read 466 K to 699 K a compile across
  three placements, with no stage difference, since `.rodata` moves with the code and the tables' and arrays' page
  offsets with it. The arrays can't be kept apart from the text's page offsets: the text sweeps every offset.

## Result

The branch (v7 with its comments, buster `claude/gallant-maxwell-71ox7x`) against main `20f3573e` in one hold
(`results/final.txt`, `scripts/final.sh`, load average 0.0):

| | main | the branch | |
| --- | ---: | ---: | ---: |
| the product's `-c`, wall (21 rotated runs, one compile a process) | 16.420 ms | 16.340 ms | -0.5% |
| user cycles | 81.36 M | 80.96 M | -0.49% |
| user instructions | 221.07 M | 219.49 M | -0.71% |
| mispredicted branches | 971.8 K | 978.1 K | +0.6% |
| lexing and preprocessing (the harness, 9 rounds, three placements each) | 6.925, 6.943, 6.948 ms | 6.879, 6.918, 6.918 ms | -0.5% |
| the harness's user cycles (mean of the placements) | 80.00 M | 79.72 M | -0.35% |
| the microbenchmark's block | 38.07 cycles, 185.4 instructions | 30.67 cycles, 140.6 instructions | -19%, -24% |
| ... its mispredictions and forwarding failures / 1000 blocks | 23.6, 565 | 11.4, 108 | |
| the object | `f558aaf503fcb186` | the same | |

Every placement of the branch reads below every placement of main. The block's own work is a fifth smaller; the
compile gains half a percent, because a block that stops waits on its stop's chain and on mispredictions (the probes
above), which the arithmetic doesn't shorten.

**What is left**, by the probes: the comment skipper's exit mispredicts about once a comment (24 K a compile), the
block's exit at a stop 18% of the time, and a stopped block's chain (the load, the class lookup, the stop mask, its
move to a general register, the count of zeros, the next address) is exposed in full. A comment that closes in its
block is now passed from the block's bytes (v6, -0.03 ms); the other 15 K comments still go to the skipper. The
window's prologue loads 16 tables for each of 20.8 K windows, 14 K of them a directive's line.

## Checked (`results/checks.txt`, `results/faults.txt`)

- **The windows, against main's lexer** (`scripts/lexdump.c`, one hash a window of its tokens, count, stop, end and
  line state): 478,677 windows of `sqlite3.c`, 827,405 of `shell.c`, 465,389 of buster's `tests/`, and 6.2 M of the
  fuzz texts of `scripts/fuzzgen.py` and `fuzzgen2.py` from every byte, the same. Two differences by design: a window
  past 64 KB stops earlier, and a punctuator at a block's last byte before a byte of 128 or more that reads as a pair's
  second character in seven bits (`+\xBD`) is plain here where main marked it for `fast_lex_one`, which lexes it the
  same.
- **The preprocessor's output** (`scripts/ppdump.c`): 400 fuzz texts (182 taken, 76,509 tokens; 218 bail out with
  main's reason) and a text with comments, blanks and a literal over 64 KB, the same.
- **test-direct** has three new comment cases (`a/*/ b */c`, `x/ *y/**/`, `a*/**/b`), the next byte's class table
  against the tables it restates, and tokens just past and far past 64 KB from a window's first byte.
  `scripts/lexer-faults.py` builds 42 single-line faults of the block, its readers and the skipper into test-direct;
  all 42 fail it (one more, `.` tokens marked too often, is harmless: fast_lex_one lexes them the same).
- **The equivalence corpus** of `direct-speed-2850-2026-11-24` (its `scripts/equiv/run.sh`: buster's `tests/`,
  c-testsuite, Lua 5.4.8, musl 1.2.5, `sqlite3.c` and `shell.c` in 14 configurations): 6,201 units, status,
  diagnostics and objects identical to main's, 1,196 of them on the direct path; after rebasing onto main `09c3b79b`,
  identical again, 1,900 on the direct path.
- **Sanitizers:** ASan+UBSan and MSan builds of the unit pass test-direct; ASan+UBSan over `sqlite3.c` gives the
  same object, and over the fuzz texts the same output.
- **The compile's count** (`tools/ci/compile-count.sh check`): 46,561,450 at main, 46,552,298 on the branch, -0.019%.
