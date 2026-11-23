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

## Then the calls' memo keys and hashes eight at a time (piece 5e), refuted (`results/ab-hash2`)

`scripts/memo-hashes.patch`, on buster#3408's head `5a122ed6` (main `3431ed34` with 5c and 5d): measuring's loop over
the deferred entries built eight listed calls' keys, hashed them in one vector (the same SplitMix64 hash: each key's
sum the neighbouring quadwords', the 128-bit lanes' and the halves' pairs, every one of 1.6 million random keys' hashes
the scalar one's), fetched their slots' lines and then probed each in order; and a call's entry in the table went to its
place in the deferred list, which emission's loop read in order. In the profile of `5a122ed6` the memo's lookup was 4.8%
of Tier 0's samples, a third of them on the hash's chain.

| | `5a122ed6` (`bin/base5e`) | the piece (`bin/hash`) | change |
| --- | ---: | ---: | ---: |
| `tier0` | 4.034 | 4.072 | +0.038 |

Every round: the base 4.026 to 4.112, the piece 4.041 to 4.145. Both objects the same. The keys' and hashes' arrays
of eight and the loops over them cost more than the hash's latency they took out of the probes' chain; dropped.

## Then emission's branch targets after its blocks (piece 4b on main, `results/ab-targets2`)

[`tier0-vex-scan-2874-2026-11-23`](../tier0-vex-scan-2874-2026-11-23/README.md)'s piece 4b, on main `8d3002eb2`
(`scripts/branch-targets.patch`, the pull request's commit): emission's blocks store a template branch's target as its
entry, with a bit no record index has, and `tier0_branch_targets` puts the entries' positions in their place once every
block, deferred entry and the epilogue are written, 16 targets a gather, where each block gathered the positions
(about 46 thousand gathers on `sqlite3.c`, about 1,700 now). Main (`bin/main3`) against it (`bin/targets2`), on a quiet
host:

| stage | main `8d3002eb2` | the piece | change |
| --- | ---: | ---: | ---: |
| `tier0` | 4.085 | 4.015 | -0.070 |
| `emit-setup` | 1.056 | 1.046 | -0.010 |
| `encode` | 0.350 | 0.328 | -0.022 |
| the compile | 114.285 | 113.909 | -0.376 |

Every round: main's `tier0` 4.050 to 4.190, the piece's 3.985 to 4.072. Both objects the same. On the memo's branch,
before pieces 5a to 5d, it read -0.040 (the first record). `check-program` reads 23.4 in both: main has
buster14a/buster#3405.

Exact against main `8d3002eb2` (both built `native`): 2,944 compiles the same (1,937 built) on the corpora, and 4,478
(2,476 built) at the AVX targets. `test-tier0 --cross-check`: 21,675,803 checks, 0 failed; its branch chain takes 271
entries as well as 13 (270 targets: a count whose low byte, 14, is under a vector's 16, where `_bzhi_u32`'s mask once
wrapped).

## Main through the children's pull requests (`results/ab-main4`)

Main `8d3002eb2` (`bin/main3`) against `25b16886a` (`bin/main4`: buster14a/buster#3407's unit parts, #3411's branch
targets, #3410's validation, and two other merges), medians of 11 in turn, both objects the same:

| stage | `8d3002eb2` | `25b16886a` | change |
| --- | ---: | ---: | ---: |
| `lower.validate` | 1.148 | 1.073 | -0.075 |
| `tier0` | 4.073 | 4.055 | -0.018 |
| `emit-setup` | 1.061 | 0.661 | -0.400 |
| `publish-data` | 0.490 | 0.309 | -0.181 |
| the row, `tier0` to `object-write` | 7.464 | 6.849 | -0.615 |
| the compile | 113.882 | 112.679 | -1.203 |

`tier0` moved 0.018 where #3411 alone read -0.070 against `8d3002eb2`: the merges between move its build by a few
hundredths, as between any two builds. The row is about 51 cycles a token (6.849 ms at 5.45 GHz over 716,136 tokens).

## Then measuring takes selection's list (piece 5f, `results/ab-p5f`)

`scripts/measuring-list.patch` (the pull request's commit), on main `25b16886a`: in a function without deep entries
selection's list of deferred entries is measuring's (only `tier0_select_deep` defers an entry after selection, and no
template's case word is deferred), so selection keeps the list's count, measuring counts those entries first
(`tier0_measure_listed`), and its words' loop takes a deferred lane's length from that loop and each block's positions
as its lengths' prefix sums from a carry; the listing and the third loop over the lengths go. A function with deep
entries lists, counts and sums as before.

| stage | main `25b16886a` | the piece | change |
| --- | ---: | ---: | ---: |
| `tier0` | 4.030 | 3.965 | -0.065 |
| the compile | 112.665 | 112.532 | -0.133 |

Every round: main 3.998 to 4.059, the piece 3.947 to 4.025 (its first round; the other ten 3.947 to 3.981). Both
objects the same. Exact against main (both `native`): 2,944 compiles the same (1,937 built) and 4,478 (2,476 built) at
the AVX targets; `test-tier0 --cross-check` 21,676,047 checks, 0 failed.

## Main's `check-program` between `e5c975f1` and `3431ed34` (`results/ab-mainmove`)

The same Tier 0 code (5c and 5d) on main `e5c975f1`'s base (`bin/access`) and on `3431ed34` (`bin/base5e`), medians
of 11 in turn, both objects the same:

| stage | `e5c975f1`'s base | `3431ed34` | change |
| --- | ---: | ---: | ---: |
| `check-program` | 23.046 | 34.138 | +11.092 |
| `lower` | 11.407 | 11.633 | +0.226 |
| `tier0` | 4.047 | 4.060 | +0.013 |
| the compile | 114.688 | 125.795 | +11.107 |

Every round: `check-program` 22.83 to 24.80 on the first, 33.96 to 34.25 on the second. A first A/B of the piece
against `bin/access` (`results/ab-hash`, not kept) read this move as the piece's; main's own merges made it. A build
of merge `061effd6c`, the eighth of the sixteen, read 34 already (`check-program` 33.85 to 34.22 in 5 rounds against
22.92 to 25.66). The cause is buster14a/buster#3381 (`94ec1ca8c`, the third), which had every discarded statement
ask for the unit's expansion history, and so preprocess the unit a second time; buster14a/buster#3405 (merged at
15:25Z, after `3431ed34`) takes it back ([`takeover-2850-2026-11-23`](../takeover-2850-2026-11-23/README.md)). Main
from `a5e760845` on has the fix.

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

- `scripts/`: `deferred-loops.patch`, `deferred-emission.patch`, `columns-pushes.patch`, `lists.patch`,
  `memo-hashes.patch` (refuted), `branch-targets.patch`, `measuring-list.patch`; `ab.sh`,
  `abtable.sh`; `exact.sh`, `exact-avx.sh`.
- `results/`: the A/Bs' stage clocks, tables (`table.txt`), objects' hashes and the host's processes before and after.
