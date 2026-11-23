# Tier 0's compile twin deleted (#2972)

[#2972](https://github.com/buster14a/buster/issues/2972) asked that Tier 0's vector compile (`tier0_compile`) be at
least as fast as its scalar twin (`tier0_compile_scalar`) on the smallest functions before the twin goes. The first
round of fixes ([`../c-tier0-compile-2972/`](../c-tier0-compile-2972/)) left a fixed cost of a few hundred ticks per call,
which closing would take a redesign: each vector pass batching several functions in one block. On 2026-11-23 David
chose to **cut what is cheap to cut, record the gate, and delete the twin now**, accepting the loss on 1-entry
functions for the 2.1× win over the corpora's real compiles.

All timings are from the 9700X (`benchpress`), Release, under the lock (`exclusive.sh`, each run its own hold), on CPU 2,
every benchmark process from a fresh copy of its executable. **The base is main `968a085fe`.** **The head** is that main
plus [`patches/series/`](patches/series/) (`git am`), the four commits of the pull request:

1. `Tier 0: skip the fusion passes a function gives nothing to`. This is the first cut. P2 runs only in a function
   with a kind its fusions end at (`LOAD`, `SET`, the branches, `SET_LOCAL`). P3's absorption runs only where P1 or P2
   absorbed an entry; otherwise P4 sums the raw effects.
2. `test-tier0: a frozen digest of the random programs' code`. It was recorded on the tree where the two paths still
   agreed.
3. `Tier 0: one compile path; tier0_compile_scalar deleted`. Its ~70 test uses moved to the digest, the validator,
   the interpreter, native runs and clang.
4. `Tier 0: clear the front's bitsets and the references without memset`. This is the second cut: 64-byte stores, the
   last one masked.

The pull request carries the same four commits rebased onto a later main (`747fbeff`), which touches no Tier 0 file.

Inputs ([`inputs/`](inputs/)):
- [`tiny.c`](../c-tier0-gate/tiny.c): the C8 gate's 1,000 functions of 1 entry and 1,000 of 6;
- [`tiny1.c`](inputs/tiny1.c): the 1-entry half alone;
- [`tiny6.c`](inputs/tiny6.c): the 6-entry half alone;
- `tiny1big.c` and `tiny6big.c`: 20,000 of each, for the profiles.

## Main's gap ([`results/main/`](results/main/), [`results/stages/`](results/stages/))

`benchmark-backend-source --only vector` and `--only scalar` on main ([`scripts/warm.sh`](scripts/warm.sh), three
rounds). The table gives cycles a typed entry, the three rounds, and instructions a typed entry:

| Input | Vector | Twin | Instructions, vector / twin |
| --- | --- | --- | --- |
| `tiny.c` | 308.9, 309.0, 309.6 | 208.2, 210.1, 210.4 | 1,176.5 / 1,029.5 |
| `tiny1.c` (1 entry) | 900.7, 905.0, 919.3 | 393.6, 394.3, 394.6 | 3,596.2 / 2,134.2 |
| `tiny6.c` (6 entries) | 209.8, 210.9, 211.4 | 170.1, 172.0, 177.3 | 773.2 / 845.4 |

The stage marks ([`patches/stages.patch`](patches/stages.patch), experiment only;
[`scripts/stages.sh`](scripts/stages.sh), [`scripts/stages.py`](scripts/stages.py),
[`results/stages/stages.txt`](results/stages/stages.txt)) read the TSC between compile's stages. Each mark costs about
26 ticks on both paths. The table gives ticks a call, each stage the median of three rounds (so the total, the median
of the rounds' totals, is not quite the column's sum):

| Stage | 1 entry: vector | twin | difference | 6 entries: vector | twin | difference |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| setup | 52.2 | 32.9 | +19.3 | 46.0 | 30.8 | +15.2 |
| labels, values | 38.8 | 28.0 | +10.8 | 45.8 | 27.3 | +18.5 |
| fuse (P1 to P4) | 124.7 | 30.3 | **+94.4** | 126.2 | 149.7 | −23.5 |
| front's rest | 34.9 | 26.2 | +8.7 | 38.1 | 26.7 | +11.4 |
| select | 82.9 | 34.9 | +48.0 | 101.8 | 82.0 | +19.8 |
| references | 48.2 | 28.0 | +20.2 | 68.9 | 28.7 | +40.2 |
| homes, layout | 55.0 | 52.5 | +2.5 | 91.8 | 88.7 | +3.1 |
| measure, output | 95.4 | 58.9 | +36.5 | 127.9 | 116.4 | +11.5 |
| emit | 90.3 | 39.6 | +50.7 | 111.2 | 121.9 | −10.7 |
| forms | 28.4 | 26.3 | +2.1 | 79.3 | 27.6 | +51.7 |
| the rest | 110.5 | 106.8 | +3.7 | 114.1 | 112.7 | +1.4 |
| **total** | **756.3** | **470.1** | **+286.2** | **951.9** | **812.2** | **+139.7** |

The fusion passes cost the most on a function of one entry, and it has nothing for them to do. That's the first cut.

**The gate on main** ([`patches/knob.patch`](patches/knob.patch), the C8 gate's compile knob, experiment only;
[`scripts/gate.sh`](scripts/gate.sh), [`scripts/gate2.py`](scripts/gate2.py),
[`results/gate-main/gate2.txt`](results/gate-main/gate2.txt)). Compile's ticks are taken with the twin (`0x1`) and with
the vector path (`0`) in one executable, five rounds in turn. The inputs are `-c --verify --lanes 1` of sqlite3.c, Lua
5.4.8, musl's 1,336 units, buster's `main.c` and `tiny.c` ([`scripts/objects.sh`](scripts/objects.sh)). The k-th call
pairs across runs, each call the median of its five rounds. The table gives the twin's ticks over the vector path's,
sums by bin:

| Entries | Calls | Vector, ticks a call | Twin | Twin / vector |
| --- | ---: | ---: | ---: | ---: |
| 0 to 1 | 41 | 3,619 | 3,222 | **0.890** |
| 2 to 3 | 192 | 3,370 | 3,563 | 1.057 |
| 4 to 7 | 866 | 4,539 | 5,225 | 1.151 |
| 8 to 15 | 1,147 | 5,007 | 6,876 | 1.373 |
| 16 to 63 | 2,587 | 4,417 | 9,260 | 2.097 |
| 64 to 255 | 2,322 | 7,524 | 21,222 | 2.821 |
| 256 to 1,023 | 768 | 18,264 | 61,607 | 3.373 |
| 1,024 and up | 121 | 206,907 | 481,393 | 2.327 |
| **the corpora** | **8,044** | | | **2.099** (2.448 without call 0) |
| `tiny.c`, 1 entry | 1,000 | 969 | 601 | 0.620 |
| `tiny.c`, 6 entries | 1,000 | 1,136 | 1,035 | 0.911 |

Each run's first call (sqlite3.c's first function, of 6 entries) pays the process's one-time costs: the tables' and arenas' first use,
25 M ticks on both paths. `gate2.py` sets aside any call above 50,000 ticks an entry, which is that call alone. The
objects of the two masks are the same: 1,373 of 1,373 ([`results/gate-main/objects.txt`](results/gate-main/objects.txt)).

## The cuts

**Cut 1, the fusion passes skipped** ([`results/cut1/`](results/cut1/): main plus commit 1, warm as above). The table
gives cycles a typed entry, and instructions:

| Input | Vector, main | Vector, cut 1 | Twin | Instructions, main / cut 1 / twin |
| --- | ---: | ---: | ---: | --- |
| `tiny.c` | 309.0 | 270.8 | 207.4 | 1,176.5 / 1,072.6 / 1,029.5 |
| `tiny1.c` | 905.0 | 762.8 | 401.0 | 3,596.2 / 3,190.2 / 2,134.2 |
| `tiny6.c` | 210.9 | 191.9 | 173.3 | 773.2 / 719.7 / 845.4 |

**Cut 2, the clears.** The bit columns and the references' counts are a few cache lines for a small function. A call of
the C library's `memset` cost more than clearing them with 64-byte stores.

**The gate with cut 1** ([`results/gate-cut/`](results/gate-cut/)): *pending; the 9700X queue.*

**The head, warm** ([`scripts/head.sh`](scripts/head.sh), [`results/head/`](results/head/)): *pending; the 9700X queue.*

## What is left

The vector compile still loses on functions of 1 entry: after the cuts, about 1.9× the twin's cycles warm on
`tiny1.c`. It is a chain of about a dozen passes, each a block's work ending in a store that the next reads
([`../c-tier0-compile-2972/`](../c-tier0-compile-2972/)'s "What is left"). The corpora have 41 such calls in 8,044, and
the vector path wins everything from 2 entries on. Closing the gap needs several small functions in one block of the
passes. #2972's comments record that as the follow-up, not started here.

## The head against main

- **Objects:** *pending.*
- **Tests**, on the PR's head in a cloud container (Develop; the 9700X has no spare lock time for them):
  - `test-tier0` and `test-tier0 --cross-check`;
  - `test-tier0-inline`, `test-unwind`, `test-emitted-code`, `test-ir-lowering`, `test-x86-target-selection`;
  - the builtins' lowering and helper tests, `test-tier1-pipeline`, `test-check-lanes`,
    `test-c-testsuite --self-test`;
  - `test-checker` parts 1 to 8;
  - `./build.sh check-call-graph --config Release` (0 cycles);
  - a `BUSTER_SANITIZER=undefined` build over the same tests and checker part 8, with no runtime errors.
