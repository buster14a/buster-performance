# Tier 0: each pass over a window's bodies before the next (buster#2874's piece A), 2026-11-23

[buster#2874](https://github.com/buster14a/buster/issues/2874), after
[the census of what Tier 0's cycles wait on](../tier0-causes-2874-2026-11-23/README.md): a third of Tier 0's dispatch
slots had no uop from the front end, because a function's compile walks about 44 KB of code and each pass's code was
fetched and decoded again for every function. The piece's specification and gate are in
[the issue](https://github.com/buster14a/buster/issues/2874#issuecomment-7113394397).

**What changed** (the pull request's commit, on main `b7d0b5ed`):

- `tier0_generate` is five passes over a job (`Tier0Job`: what one function's passes hand each other): the front with
  selection, the homes and frame, measuring with the output's room, emission, then the forms with what the code keeps.
- `tier0_compile_batch` runs each pass over every function of a batch before the next pass. A batch is at most 32
  functions and takes no more once it holds 2,048 entries. `tier0_compile` is a batch of one, through the same passes.
- The C driver's code half prepares a window's bodies (each one's tier and its inline splice), has Tier 0 compile them
  together, then makes each body's code after Tier 0 in order. With `--tier1` or the scalar path a group is one body.

## The A/B (`results/ab-batch1`)

`-c sqlite3.c`, the 9700X, CPU 2, under the lock, main `b7d0b5ed` (`a`) and the piece (`b`) in turn, medians of 11, ms.
Both built from the same tree, Release, `BUSTER_HOST_ARCH=znver5` (`binaries.sha256`).

| stage | main | the piece | change |
| --- | ---: | ---: | ---: |
| `tier0` | 3.971 | 3.662 | -0.309 |
| `emit-setup` | 0.671 | 0.663 | -0.008 |
| `branch-sizing` | 0.408 | 0.393 | -0.015 |
| `encode` | 0.327 | 0.304 | -0.023 |
| `unwind` | 0.219 | 0.170 | -0.049 |
| `code-atoms` | 0.299 | 0.295 | -0.004 |
| `publish-data` | 0.307 | 0.305 | -0.002 |
| `object-build` | 0.393 | 0.394 | +0.001 |
| `object-write` | 0.159 | 0.159 | +0.000 |
| the row, `tier0` to `object-write` | 6.744 | 6.371 | -0.373 |
| `lower` | 11.358 | 11.379 | +0.021 |
| the compile | 113.005 | 112.612 | -0.393 |

- Every round of the piece's `tier0` (3.622 to 3.715) is below every round of main's (3.937 and up; one round of
  main's read 10.6, another process's time). Both objects are the same (`objects.sha256`).
- The host had other sessions' work on its other CPUs through the hold (a load of 4 to 5, `busy-*.txt`).
- **Against the gate:** `tier0` 0.40 ms lower or more, refuted under 0.15: **missed, not refuted**, 0.31.
- Branch sizing, the encoder and the unwind rows are 0.09 ms faster together: they now run for one body after another
  with no Tier 0 between two bodies.
- With `--emit-window=8192` to both (`results/ab-batch1-w8192`, medians of 7): `tier0` 4.007 against 3.697, the same
  0.31. A window of 2,048 tokens already makes groups of 12.5 bodies on average on `sqlite3.c` (208 groups for 2,602
  bodies, 86% of the bodies in groups of nine or more).

## The batch's limits (`results/scan1`)

One executable (`tune`: the piece with `scripts/batch-knobs.patch`, which reads the limits from the environment),
`-c sqlite3.c`, medians of 7 in turn, every object the same:

| a batch's functions | its entries | `tier0`, ms |
| ---: | ---: | ---: |
| 1 | | 3.988 |
| 2 | | 3.878 |
| 4 | | 3.757 |
| 8 | | 3.711 |
| 32 | 256 | 3.780 |
| 32 | 512 | 3.714 |
| 32 | 1,024 | 3.708 |
| 32 | 2,048 | 3.679 |
| 32 | 4,096 | 3.688 |
| 32 | no limit | 3.690 |

A batch of one function is main's order in the piece's executable: 3.99 ms. The gain is there by eight functions or
1,024 entries, and larger batches read the same, so the columns' distance between passes costs nothing measurable.

## The passes by cause, in batches (`results/census2-group32`, `census2-group0`)

The census's method, on `tune`: `benchmark-backend-source --only vector` on `sqlite3.c`, the functions compiled 32 a
batch (`BUSTER_TIER0_GROUP=32`) and one at a time (`=0`), a run a stop and an event pair, an entry. The stops are the
batch's passes.

| | cycles | uops | slots retired | front end empty | back end stalled | op cache misses | L1I misses | uops from the decoder | L1D fills |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| one function at a time | 50.29 | 171.6 | 43% | 33% | 20% | 9.87 | 4.28 | 30% | 1.25 |
| 32 functions a batch | 45.81 | 169.2 | 46% | 15% | 32% | 2.25 | 1.06 | 4% | 2.07 |

By pass, 32 functions a batch:

| pass | cycles | instructions | uops | retired | front end empty | back end stalled | mispredicted | op cache misses | L1I misses | L1D fills |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| the front and selection | 16.50 | 58.3 | 66.4 | 50% | 8% | 38% | 0.050 | 0.24 | 0.11 | 0.74 |
| homes, frame | 4.71 | 12.2 | 11.7 | 31% | 43% | 9% | 0.074 | 0.62 | 0.13 | 0.07 |
| measuring, the output's room | 7.84 | 23.8 | 26.3 | 42% | 14% | 38% | 0.043 | 0.55 | 0.29 | 0.36 |
| emission | 12.72 | 43.5 | 50.3 | 49% | 15% | 28% | 0.076 | 0.71 | 0.41 | 0.63 |
| the forms and the rest | 4.04 | 14.9 | 14.4 | 45% | 14% | 36% | 0.023 | 0.11 | 0.12 | 0.28 |
| **Tier 0** | 45.81 | 152.7 | 169.2 | 46% | 15% | 32% | 0.266 | 2.25 | 1.06 | 2.07 |

- **The code's misses went:** the op cache's from 9.9 to 2.3 an entry, the first-level instruction cache's from 4.3 to
  1.1, the decoder's share of the uops from 30% to 4%.
- **The cycles went from 50.3 to 45.8, 9% less, not the third the front end's slots suggested.** The slots the front
  end left empty fell from 33% to 15%, and those the back end stalled rose from 20% to 32%: with the front end
  feeding it, Tier 0 waits on its own work. 19.9 of the 45.8 cycles an entry retire nothing, 12.0 of them with the
  oldest op not executed yet and 5.4 with it waiting for a load (`table.txt`'s `noretire-*` rows).
- **What is left** is the passes' own uops (169 an entry) and their chains: the three gathers are 10 microcoded uops
  an entry, a block of emission is about 400 uops with a chain through its eight lanes' choice fields, and a function
  still has about 1,500 cycles of fixed cost.

## Then the three gathers as eight loads each: refuted (`results/loads1`)

The census counted 10 microcoded uops an entry, 16 in the long bodies, all the three gathers': selection's slot words,
the homes past 32 locals, and measuring's case words. `scripts/loads-knob.patch` (on `tune`: `tune2`) makes each one
eight loads put together in registers (`tier0_load_qwords`), by a bit of `BUSTER_TIER0_LOADS`. One executable,
`-c sqlite3.c`, medians of 7 in turn, every object the same (`table.txt`):

| the gathers replaced | `tier0`, ms |
| --- | ---: |
| none | 3.695 |
| selection's (1) | 3.686 |
| the homes' (2) | 3.674 |
| measuring's (4) | 3.681 |
| all three (7) | 3.683 |

And the benchmark in batches of 32 (`benchmark.txt`: cycles, uops retired and microcoded uops an entry):

| | every function | | | 512 entries or more | | |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| the gathers replaced | cycles | uops | microcoded | cycles | uops | microcoded |
| none | 45.90 | 170.1 | 10.18 | 35.76 | 150.6 | 16.07 |
| all three | 45.81 | 170.9 | 0.74 | 35.63 | 150.5 | 0.56 |

The microcoded uops go and nothing else moves: on the 9700X a gather of eight costs what eight loads and their
inserts cost. Nothing lands.

## Then emission's side work in loops after its blocks (piece B): refuted (`results/ab-lists`)

[Specified here](https://github.com/buster14a/buster/issues/2874#issuecomment-7115512468). A block of emission is
about 400 uops for 8 entries, and its choice requests' contexts go through a chain of its eight lanes' records. The
piece (`scripts/emission-lists.patch`, on `tune2`: `tune3`) lists a block's entries with a choice request, a branch or
a reference (three compressed stores of entry numbers) and does each list's work in a scalar loop after the blocks,
in a function without deep entries.

`-c sqlite3.c`, `tune2` (`a`) against `tune3` (`b`), medians of 11 in turn, both objects the same:

| stage | before | the piece | change |
| --- | ---: | ---: | ---: |
| `tier0` | 3.696 | 3.808 | +0.112 |
| the row | 6.408 | 6.511 | +0.103 |

Every round of the piece (3.770 to 3.838) is above every round before it (3.682 to 3.732). The gate was 0.15 ms
lower, refuted under 0.05: **refuted**, 0.11 ms slower. The block's vector side work (four compressed columns of a
request, two of a branch) costs less than a scalar loop over `sqlite3.c`'s 50,712 requests and its branches, and the
block was not waiting on the lanes' chain. The piece is exact (2,951 compiles and 4,492 at the AVX targets the same as
main's, `test-tier0 --cross-check` passing), and it doesn't land.

## Then five reorderings of the passes' chains, a knob each: one pays (`results/chain1`)

In batches the back end stalls 32% of Tier 0's slots, so five places where a block's work goes through a chain or
waits for a gather were reordered, each behind a bit of `BUSTER_TIER0_CHAIN` in one executable (`tune4`:
`scripts/tune4.patch` on main `b7d0b5ed`), each exact: every value of the knob gives main's object for `sqlite3.c`,
and with all five on, 2,951 compiles and 4,492 at the AVX targets are the same as main's and `test-tier0
--cross-check` passes (21,676,047 checks).

`-c sqlite3.c`, medians of 9 in turn (`table.txt`), and the benchmark in batches of 32 (`benchmark.txt`, cycles an
entry):

| the bit | what | `tier0`, ms | cycles an entry | in bodies of 512 entries or more |
| ---: | --- | ---: | ---: | ---: |
| 0 | none | 3.717 | 46.38 | 36.18 |
| 1 | the labels' bits from bytes stored through the targets, then packed 64 at a time | 3.712 | 46.42 | 36.25 |
| 2 | the depths' carry from a sum of the block's effects, off the scan's last lane | 3.720 | 46.34 | 36.22 |
| 4 | selection's words gathered a block ahead | 3.673 | 45.74 | 35.46 |
| 8 | the references counted in two tables by turns (256 locals or fewer) | 3.733 | 46.47 | 36.17 |
| 16 | emission's hole blocks computed a block ahead | 3.722 | 46.32 | 36.13 |
| 31 | all five | 3.684 | 45.87 | 35.50 |

Four move nothing: those chains were not what their loops waited on. Selection's gather is: gathered while the block
before it is worked on, selection is 0.6 to 0.7 cycles an entry faster, 0.04 ms of `tier0`. It goes on as piece C,
without a knob, with an A/B of its own.

## How often a statement's shape repeats (`results/shapes`, `scripts/shapes.py`)

Whether a memo could stand in for the front's passes. The tuning build dumps each function's entries as selection
leaves them (`BUSTER_TIER0_DUMP_FILE` in `scripts/tune4.patch`). A statement is a run of entries between two points
where both value stacks are empty; its key is what the front's passes read of it (each entry's kind, class and label
bit, the predicates of the values the fusion tests, a call's effect on the stacks), its answer what selection leaves
(the fusion's key, the absorbed mark, the depths, the word).

| | statements | entries each | distinct | entries in a statement seen before | with a table a unit |
| --- | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 92,060 | 4.03 | 12,309 | 66.4% | 66.4% |
| Lua 5.4.8, 32 units | 22,044 | 3.99 | 3,654 | 64.9% | 51.8% |
| musl, 1,304 units | 47,358 | 4.05 | 8,233 | 60.9% | 29.9% |

- A quarter of the entries are in statements seen once (25.0%, 25.8%, 27.8%), and the commonest 256 shapes hold 43%,
  52% and 39% of the entries.
- Blocks of 8 entries keyed with the 5 entries around them repeat for 3.3% of `sqlite3.c`'s entries.
- This key is not yet enough: 4.7% of `sqlite3.c`'s entries (4.4%, 5.8%) are in statements whose key has two
  answers, so the rates above are upper bounds.
- So a memo of statements would skip the front's passes for at most two thirds of a large unit's entries and under a
  third of a small unit's, and nothing of the homes, measuring or emission, which depend on the function's locals.

## Exactness and tests

- **Objects** (`scripts/exact.sh`, `scripts/exact-avx.sh`, the piece against main `b7d0b5ed`, both built `native` in a
  cloud container): 2,944 compiles the same (1,937 built) of `sqlite3.c` with and without `-g`, Lua 5.4.8, musl's
  units, `main.c` and `tests/**/*.c`; and 4,478 (2,476 built) of musl's units at `x86-64-v3` and `tests/**/*.c` at
  `x86-64-v3` and `znver5`.
- **`test-tier0 --cross-check`:** 21,796,335 checks, 0 failed. Its new `batch` check compiles each program's functions
  together, the list taken again until it is past a batch's 32 functions, and requires each one's code to be its own
  compile's (120,288 checks).
- **CI's inventory** (`tools/ci/correctness.tests`), the 56 blocks that reach Tier 0 or the emission (the lanes, the
  driver's sixteen parts, c-testsuite by both tiers, the per-file jobs, the frozen sources' comparisons, the call
  graph): 55 pass in a cloud container; the other needs `perf`, which the container lacks.

## Files

- `scripts/ab.sh`, `abtable.sh`: the A/B and its table; `scan.sh`: the limits; `census2.sh`: the passes by cause;
  `run-tune.sh`: the holds; `census_table.py`, `census_summary.py`: the census's tables.
- `scripts/batch-knobs.patch`: on the piece, the limits from `BUSTER_TIER0_BATCH_JOBS` and `BUSTER_TIER0_BATCH_ENTRIES`,
  the benchmark's batches (`BUSTER_TIER0_GROUP`), the stop (`BUSTER_TIER0_STOP`) and the raw events. Not for main.
- `scripts/emission-lists.patch`: piece B, refuted. Not for main.
- `scripts/loads-knob.patch`, `knobs.sh`: the gathers as loads, by `BUSTER_TIER0_LOADS`, and its runs. Not for main.
- `scripts/exact.sh`, `exact-avx.sh`: the objects' comparison, as the records before this one have them.
- `scripts/tune4.patch`, `run-chain.sh`: the whole tuning tree against main `b7d0b5ed` (the piece, the limits' and
  the gathers' knobs, the chains' knobs and the entries' dump). Not for main.
- `scripts/shapes.py`: the statements' census from the dumps.
- `results/ab-batch1`, `ab-batch1-w8192`, `ab-lists`: each run's `--time-stages`, the tables, the objects' hashes;
  `results/scan1`, `results/loads1`, `results/chain1`: the tables and `stages.tar.zst`; `results/census2-*`: a line a
  run, `table.txt` (every event by pass), `summary.md`; `results/shapes`: the census's output a corpus.
