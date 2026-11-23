# Tier 0: the deferred entries in loops of their own (buster#2874's pieces 5a to 5d), 2026-11-23

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

## Then emission's (`results/ab-emit`, buster#3403's commit `b3e3ba79`, `scripts/deferred-emission.patch`)

Emission wrote a block's deferred entries (the calls' records from the memo above all) in its loop over the blocks
too. In a function without deep entries it now writes them after the blocks, in order, from measuring's list; their
references go to a column of their own and then into the templates' by instruction, from the end, which keeps the
entries' order. A function with deep entries keeps them in the blocks' loop (their branches and choice requests go
with the templates').

| | the commit above (`bin/split2`) | the change (`bin/emit`) | change |
| --- | ---: | ---: | ---: |
| `tier0` | 4.313 | 4.156 | -0.157 |

On a quiet host: every round of the change (4.120 to 4.205) below every round of the base (4.279 to 4.372). Both
objects the same.

## Then a body's columns in a few pushes, and the remaining lanes in lists (pieces 5c and 5d)

- **5c** (`scripts/columns-pushes.patch`, `results/ab-push`): each column of a body's scratch and output took a push
  of the arena, about 30 a body, about 250 cycles a body in the profile. `tier0_column` carves a push's columns:
  the entries' columns in one push, the homes and references' counts in one, the choice requests' columns and the
  deferred entries' references in one, and the output's in one. Emission writes the deferred entries' references in
  place where no template has one, with nothing to merge.
- **5d** (`scripts/lists.patch`, `results/ab-access`): fusion's global entries' accesses, fusion's calls' effects and
  the labels' branch targets were loops over a block's lanes inside a loop over the blocks; each is a list and a loop
  of its own now.

| | before | after | `tier0` |
| --- | ---: | ---: | ---: |
| 5c (`bin/emit` against `bin/push`) | 4.138 | 4.084 | -0.054 |
| 5d (`bin/push` against `bin/access`) | 4.081 | 4.053 | -0.028 |

Each on a quiet host, medians of 11 in turn, both objects the same; each exact on the corpora (2,928 compiles) and at
the AVX targets (4,446) against the commit before it, `test-tier0 --cross-check` passing.

## The pull request's head against main (`results/ab-main2-emit`, medians of 11 in turn, ms)

Main `e5c975f1` (`bin/main2`) against buster#3403's head `b3e3ba79` (`bin/emit`: the calls' memo, the VEX scan, and
the deferred entries in loops of their own in selection, measuring and emission), on a quiet host:

| stage | main | the pull request | change |
| --- | ---: | ---: | ---: |
| `tier0` | 5.027 | 4.150 | -0.877 |
| `emit-setup` | 1.028 | 1.030 | +0.002 |
| `branch-sizing` | 0.421 | 0.420 | -0.001 |
| `encode` | 0.340 | 0.338 | -0.002 |
| `unwind` | 0.217 | 0.219 | +0.002 |
| `code-atoms` | 0.309 | 0.306 | -0.003 |
| `publish-data` | 0.503 | 0.500 | -0.003 |
| `object-build` | 0.408 | 0.397 | -0.011 |
| `object-write` | 0.143 | 0.153 | +0.010 |
| the compile | 116.013 | 114.889 | -1.124 |

Every round: main's `tier0` 5.000 to 5.063, the pull request's 4.121 to 4.179. Both objects the same. The row (the
stages from `tier0` to `object-write`) is 7.51 ms, about 57 cycles a token at 5.45 GHz over the 716,136 tokens, against
the gate's 10.

## Exactness and tests

- **Objects** (`scripts/exact.sh`, `scripts/exact-avx.sh`, each change against the commit before it, both built
  `native`): 2,928 compiles the same (1,925 built) of `sqlite3.c` with and without `-g`, Lua 5.4.8, musl's 1,337 units,
  `main.c` and `tests/**/*.c`; and 4,446 (2,452 built) of musl's units at `x86-64-v3` and `tests/**/*.c` at
  `x86-64-v3` and `znver5`.
- **`test-tier0 --cross-check`:** 21,675,530 checks, 0 failed (21,675,531 with emission's). Its new "call effects"
  check compares a call's effects with the stacks' definition for calls and tail calls of 0 to 200 arguments, every
  class among them, around each 64-class boundary, direct and indirect.
- **The call graph:** 0 cycles at each commit.

## Files

- `scripts/`: `deferred-loops.patch`, `deferred-emission.patch`, `columns-pushes.patch`, `lists.patch`; `ab.sh`,
  `abtable.sh`; `exact.sh`, `exact-avx.sh`.
- `results/`: the A/Bs' stage clocks, tables (`table.txt`), objects' hashes and the host's processes before and after.
