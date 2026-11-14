# Named results built where the hidden pointer points, Buster #1375

Compiler issue: [#1375](https://github.com/buster14a/buster/issues/1375). Compiler PR:
[#2675](https://github.com/buster14a/buster/pull/2675), commit `01ac691517dc4ed1368119da4992fe968e146914` on main
`b7a95eedbe16fbd8434654f192f8f7aab76c56e5`.

The PR builds a function's named result where its hidden pointer points. Such a function returns a struct or union in
memory, and every one of its returns names the same automatic object. Clang's NRVO does the same at `-O0`. The object's
returns then copy nothing. Before, Tier 0 copied a result of more than 32 bytes in 16-byte `movups` pieces, which
couldn't take their data from the 8-byte stores that had just built it. Tier 1 copied it in 8-byte pieces.

## Trees and binaries

All three were built on the 9700X with `./build.sh` (Release, `-march=native`, which is znver5 there); their
executables' SHA-256 values are in `results/receipts.txt`.

- **main**: a clone of `buster14a/buster` at `b7a95eed` with no changes (`git status` empty).
- **head**: main with the PR's patch applied. Its `src/` is identical to commit `01ac6915`: `git diff --stat
  01ac6915 -- src` against the tree printed nothing. The tree lacks only the commit's two documentation edits
  (`docs/c-checker.md`, `docs/commands/checker.md`), which don't reach the executable. The scripts and receipts
  call it `nrvo`.
- **narrow**: head with Tier 0's `BUSTER_TIER0_COPY_NARROW_BYTES` set from 32 to 256 (the diff is in
  `results/receipts.txt`). Every Tier 0 inline copy then moves 8 bytes at a time, as Tier 1's do. This is an
  experiment for the question of whether copies past 32 bytes need narrower pieces too. It is not proposed.

## Host and method

The Ryzen 7 9700X (`benchpress`), Linux 6.18.50, CPU 2 with governor and EPP `performance`, clang 23.1.1, perf 7.2.9
(`results/receipts.txt`, written by `harness/record.sh` before its first run).

**Kernels** (`harness/k*.c`, each linked with its own driver `harness/d*.c`, compiled by clang `-O2`):

- `k24`, `k64` and `k16`: the issue's three. `k24` is a 24-byte struct built field by field and returned through the
  hidden pointer, 50 M calls. `k64` is a 64-byte struct filled in a loop and returned, then read in the caller, 20 M
  calls. `k16` is a 16-byte struct returned in registers, 81.9 M calls. NRVO doesn't apply to `k16`.
- `assignN`: a struct of N longs built by 8-byte stores, then copied to `*out` (the copy reads the stores just made),
  20 M calls.
- `coldN`: a struct of N longs copied from a table that nothing has written since the start, 20 M calls.

Each kernel is compiled by each tree's compiler (`-c -O0` for Tier 0 and `-c -O0 --tier1` for Tier 1) and by clang
`-O0` (`harness/build-kernels.sh`). Every driver prints a checksum, and every binary's checksum is the same as
clang's (`results/kernels.tsv`, column 7).

**Lock:** every step took the 9700X's lock for itself alone: each of the three kernel builds, each of the 45 measured
binaries and each of the 8 compile timings. That is 56 holds, and each one's first act appended the holder line to
`results/holds.txt`. All 56 lines name this run (`claude-1375`) and its command. `exclusive.sh`'s waiting messages,
which name other sessions, are not kept; nothing else was in that log.

**Measured:** `harness/measure-one.sh` runs a binary once for its checksum, then `perf stat -r 10` of `cycles:u`,
`instructions:u`, `ls_bad_status2.stli_other:u` (loads that couldn't take an older store's data) and `task-clock`,
pinned to CPU 2. Its columns are: binary, ms, cycles, cycles' ± (perf's spread over the 10 runs), instructions,
`stli_other`, checksum and perf's exit status. Every status is 0, and the largest spread is 2.6% (a clang binary).

**Compile time** (`harness/compile-one.sh`): `-c --lanes 1` by main's and head's compilers, pinned to CPU 2,
`perf stat -r 5`. The inputs are the frozen corpus's `sqlite3.c` (SHA-256 `0a409f16…`, in the receipts) and main's own
`src/buster/compiler/main.c`, by both tiers (`results/compile.tsv`).

## Results

Millions of user-mode cycles, the mean of 10 runs:

| kernel | main T0 | head T0 | main T1 | head T1 | clang `-O0` |
| --- | ---: | ---: | ---: | ---: | ---: |
| `k_sret`, 24 bytes, 50 M calls | 382.6 | **247.0** | 251.0 | **203.9** | 200.4 |
| `mk`, 64 bytes, 20 M calls | 829.5 | **426.5** | 334.6 | **196.4** | 513.3 |
| `padd`, 16 bytes in registers, 81.9 M calls | 915.4 | 915.4 | 1,364.6 | 1,364.7 | 813.7 |

- `mk`'s loads that couldn't forward: Tier 0 80.1 M → 0.4 M (4 a call to none), Tier 1 343.9 M → 21.3 M. The
  issue's 64-byte return now takes 0.83 times clang `-O0`'s cycles in Tier 0 and 0.38 times in Tier 1.
- `k_sret` in Tier 1 is clang `-O0`'s (1.017 times). In Tier 0 the copy is gone (2.30 G → 1.80 G instructions);
  what's left of its 1.23 times is Tier 0's address arithmetic and the clear before the fields' stores. Tier 0's
  `stli_other` rose from 12.8 M to 28.9 M, which is 0.6 a call, while the cycles fell 35%.
- `padd` returns in registers, which the PR doesn't change: the same cycles. Its Tier 1 cost is the by-value
  arguments' and result's staging (#1189), not forwarding.

Copies past 32 bytes that no NRVO removes. Millions of cycles; head's Tier 0 is main's within 0.4% in each row
(`main.t0` rows):

| copy | head T0 (16-byte pieces) | narrow T0 (8-byte pieces) | narrow / head | head T1 (8-byte pieces) | clang `-O0` |
| --- | ---: | ---: | ---: | ---: | ---: |
| 64 bytes, just built | 808.8 | 505.8 | 0.625 | 324.3 | 704.6 |
| 128 bytes, just built | 1,147.1 | 913.1 | 0.796 | 707.3 | 986.0 |
| 256 bytes, just built | 1,836.3 | 1,838.8 | 1.001 | 1,002.0 | 1,537.1 |
| 64 bytes, cold | 100.4 | 120.4 | 1.199 | 120.4 | 220.4 |
| 128 bytes, cold | 110.6 | 193.5 | 1.750 | 193.7 | 216.4 |
| 256 bytes, cold | 200.9 | 354.7 | 1.765 | 361.4 | 232.0 |

Copying 8 bytes at a time helps a copy of a struct that was just built, by forwarding from its stores: 37% fewer
cycles at 64 bytes and 20% at 128. It costs a cold copy 20% to 77% more, because twice as many stores make the copy
store-bound. A copy can't tell the two apart from the record's type alone, so the PR keeps Tier 0's 32-byte boundary.
Tier 1's copies are 8 bytes at a time everywhere, and they show the same split: a cold 256-byte copy takes 1.80 times
Tier 0's cycles. A width chosen from what last wrote the source is the open question.

Compile time, `-c --lanes 1`, head against main:

| input | tier | cycles | instructions |
| --- | --- | ---: | ---: |
| `sqlite3.c` | 0 | 1.018 (main ±0.18%, head ±2.17%) | 1.000061 |
| `sqlite3.c` | 1 | 0.999 | 1.000022 |
| `main.c` | 0 | 0.991 (main ±0.79%) | 1.000031 |
| `main.c` | 1 | 1.000 | 0.999762 |

`sqlite3.c` has no function that returns an aggregate in memory. Its 82 K more instructions (0.006%) are the new
per-body checks, about 40 a body. Its Tier 0 cycles' 1.8% lies within head's own spread over those five runs. The
compiler's `main.c` has 50 such functions, 40 of which take the new path.

## Exploratory run

`exploratory/` holds an earlier run of the same kernels: `run-ab.sh` and its `measure.sh`, with `perf stat -r 5`. It
included `narrow`'s Tier 1 binaries. Its `results-ab.tsv` agrees with the record's cycles within 2.8% in every buster
row that both have. The clang rows are within 2.7%, except `assign16`'s at 9.1%: clang `-O0`'s own 128-byte copy is
the noisiest binary in both runs (±1.6% in the record). It held the lock around each tree's build and once around the whole series of measured binaries, so **it is not
qualification evidence**; it is kept because it chose the record's kernels and lists.

## Limitations

- One placement of each binary. The kernels are tight loops, but the A/B rows aren't repeated across link orders or
  copies.
- `stli_other` counts load replays and can count one load more than once: Tier 1's `assign8` shows about 20 a call
  and runs faster than Tier 0's 4 a call. Read it as a direction, not a cost.
- The `narrow` tree changes Tier 0's inline copies only; a call's aggregate argument copies past 256 bytes keep 16-byte
  pieces in every tree.
