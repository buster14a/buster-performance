# Tier 0: the deferred entries in loops of their own (buster#2874's piece 5a), 2026-11-23

[buster#2874](https://github.com/buster14a/buster/issues/2874), on the branch of
[buster#3403](https://github.com/buster14a/buster/pull/3403) after its VEX scan (`c4cec46e`).

**Why.** In [the VEX scan's record](../tier0-vex-scan-2874-2026-11-23/), measuring's hottest lines were its popcounts and
the deferred entries' counts, and selection's and measuring's mispredictions (the row's record) were their loops over a
block's deferred lanes: each pass handled a block's deferred entries (calls above all) one at a time, inside its loop
over the blocks, so that the loop's end at a block's last deferred lane mispredicted and the blocks behind it waited
for the calls' table lookups.

**What changed** (`scripts/deferred-loops.patch`, the pull request's commit):

- **Selection** lists a block's deferred entries (`vpcompressd` of their indices into `Tier0Entries.deferred_entries`)
  and takes their touches (a call's saves and floating arguments, division's fixed registers, ...) in a loop of its own
  after the blocks, in entry order.
- **Measuring** is three loops: the blocks' words resolved to their homes' cases, a template's length from its word,
  the deferred entries listed and the popcounts, with no branch on a block's words; the listed entries' lengths from
  the thread's table of calls or `tier0_count_deferred`; and the positions, the lengths' prefix sums (into
  `Tier0Entries.lengths`, which the vector path didn't use).
- **Fusion** counts a call's arguments' stacks 64 classes at a time (`tier0_raw_effects`), as selection counts its
  floating arguments, where it went a class at a time.

## The A/Bs (`-c sqlite3.c`, the 9700X, CPU 2, under the lock, medians of 11 in turn, ms)

| | the VEX scan's commit (`bin/vex2`) | the change | `tier0` |
| --- | ---: | ---: | ---: |
| measuring alone in three loops (`results/ab-measure3`) | 4.736 | 4.604 | -0.132 |
| and selection's touches after its blocks (`results/ab-split`) | 4.712 | 4.473 | -0.239 |
| **and the calls' effects 64 classes at a time** (`results/ab-split2`) | **4.642** | **4.317** | **-0.325** |

- The first two ran while another session's `addr2line` (unpinned, outside the lock) took CPU 2 at times: their
  `lower` read 12.2 ms against 11.5 an hour before, and both executables slowed. Round by round the change led in 10
  of 11 rounds in the first (`results/ab-measure3`) and in 11 of 11 in the second (`results/ab-split`).
- The last ran on a quiet host (`busy-before.txt`): every round of the change, 4.281 to 4.415 after its first two
  (4.545 and 4.615, the new executable's pages cold), against 4.607 to 4.724 for `bin/vex2`.
- Every other stage within 0.01 ms but `lower` (-0.14 in the last, a stage the change doesn't touch). Each pair of
  objects the same (`objects.sha256`).

## Exactness and tests

- **Objects** (`scripts/exact.sh`, `scripts/exact-avx.sh`, against `bin/vex2`'s source built `native`): 2,928 compiles
  the same (1,925 built) of `sqlite3.c` with and without `-g`, Lua 5.4.8, musl's 1,337 units, `main.c` and
  `tests/**/*.c`; and 4,446 (2,452 built) of musl's units at `x86-64-v3` and `tests/**/*.c` at `x86-64-v3` and
  `znver5`.
- **`test-tier0 --cross-check`:** 21,675,530 checks, 0 failed. Its new "call effects" check compares a call's effects
  with the stacks' definition for calls and tail calls of 0 to 200 arguments, every class among them, around each
  64-class boundary, direct and indirect.

## Files

- `scripts/`: `deferred-loops.patch`; `ab.sh`, `abtable.sh`; `exact.sh`, `exact-avx.sh`.
- `results/`: the A/Bs' stage clocks, tables (`table.txt`), objects' hashes and the host's processes before and after.
