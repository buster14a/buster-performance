# An aggregate copy's pieces by its source, Buster #2693

Compiler issue: [#2693](https://github.com/buster14a/buster/issues/2693), part of
[#1375](https://github.com/buster14a/buster/issues/1375). Compiler PR: [#2817](https://github.com/buster14a/buster/pull/2817), commit
`46abbb01d228a64d7fdc7c42a19addc25e0b6213` on main `2ebfe6879e3f2cd3ea65a6ab8b1a16fa09e95b65`.

A copy of a struct just built by 8-byte stores can't take a 16-byte load's data from them: the load waits for
the stores to reach the cache. Before the PR, Tier 0 copied past 32 bytes by 16-byte loads and stores, and Tier 1
copied everything by 8-byte ones, which forward but double the stores. #1375's record measured both sides of that
trade on two kernels. This record first measures the copy's shapes alone, against five ways of writing its source
(`shapes/`), and then the PR's two tiers on #1375's kernels, compile times and code sizes (`harness/`).

## Host

The Ryzen 7 9700X (`benchpress`), Linux 6.18.50, CPU 2, governor and EPP `performance`, clang 23.1.1, perf
7.2.9 (the pending run's `results/receipts.txt` records them). Every run took the 9700X's lock (`exclusive.sh`) for itself, with its timeout
inside the hold.

## The shapes (`shapes/`)

`gen.c` writes `kernels.s`: an assembly kernel for each source, size (16 to 256 bytes) and shape, so that
nothing but the shape differs. `bench.c` runs each kernel 20 M times (2.5 M for `far`) in #1375's drivers' loops
(a fixed destination read back after the call for a built source; 64 cold sources and destinations for the
others), the shapes in a rotating order over 5 repeats, and reads user cycles, instructions and
`ls_bad_status2.stli_other` (event 0x24, umask 2: loads that couldn't take an older store's data) with
`perf_event_open`. It prints each one's median per call (`results.tsv`: source, size, shape, median cycles,
minimum, maximum, median instructions, median `stli_other`, checksum). Both were built on the 9700X by `clang
-O2`.

The shapes, per 16 bytes or per 8:

- `n8`: an 8-byte general load and store per 8 bytes (Tier 1's, and Tier 0's up to 32 bytes);
- `w16`: a 16-byte `movups` load and store (Tier 0's past 32 bytes before the PR);
- `h16`: two 8-byte loads into an XMM register's halves (`movq`, `movhps`) and a 16-byte `movups` store;
- `p16`: two `movq` loads, `punpcklqdq`, a 16-byte store;
- `w32` and `h32`: `w16` and `h16` at 32 bytes (`vmovdqu`; two halves' pairs joined by `vinserti128`).

The sources:

- `built`: a stack object written by 8-byte stores just before the copy (a struct of longs built field by field);
- `built4`: the same written by 4-byte stores (a struct of ints);
- `copied`: a stack object a `w16` copy from a cold source just wrote (the cycles include that copy);
- `far`: `built`, then a 64-deep `imul` chain that the copy's source address waits for (the cycles include the
  chain, which successive calls overlap);
- `cold`: a table nothing has written since the start.

Cycles per copy, the median of 5:

| source | bytes | `n8` | `w16` | `h16` | `p16` | `w32` | `h32` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| built | 16 | 6.00 | 24.00 | 6.00 | 6.00 | | |
| built | 32 | 6.00 | 27.00 | 6.00 | 6.00 | 27.00 | 6.00 |
| built | 64 | 8.67 | 28.00 | 7.35 | 7.13 | 29.00 | 7.19 |
| built | 128 | 16.59 | 32.00 | 12.88 | 13.50 | 32.00 | 13.00 |
| built | 256 | 33.34 | 40.00 | 25.00 | 25.49 | 39.00 | 24.54 |
| cold | 64 | 7.00 | 7.00 | 7.00 | 7.00 | 7.00 | 7.00 |
| cold | 128 | 10.06 | 7.00 | 9.50 | 9.50 | 7.00 | 9.22 |
| cold | 256 | 18.98 | 10.29 | 17.51 | 17.75 | 7.05 | 17.32 |
| copied | 64 | 8.97 | 7.00 | 10.10 | 10.05 | 21.00 | 9.97 |
| copied | 128 | 16.85 | 11.48 | 18.94 | 19.19 | 22.96 | 19.06 |
| copied | 256 | 30.49 | 20.64 | 32.73 | 32.78 | 28.15 | 32.75 |
| far | 64 | 91.08 | 77.74 | 77.69 | 76.30 | 78.13 | 78.06 |
| far | 128 | 108.53 | 81.82 | 81.50 | 82.39 | 81.58 | 82.32 |
| far | 256 | 130.77 | 91.70 | 118.65 | 118.24 | 89.42 | 118.22 |
| built4 | 64 | 23.05 | 31.00 | 34.00 | 34.00 | 31.00 | 34.90 |
| built4 | 128 | 32.29 | 39.00 | 42.00 | 42.00 | 39.00 | 42.18 |
| built4 | 256 | 54.84 | 55.00 | 57.22 | 57.02 | 55.00 | 58.31 |

`results.tsv` has the 16- and 32-byte rows of every source too: up to 32 bytes `n8` is never slower than the
others but in `far` (81.33 against `w16`'s 75.34 at 32 bytes), where every shape's copy waits for the chain.

- **No one shape serves every source.** `h16` copies a struct just built in 0.26 to 0.63 times `w16`'s cycles
  (no failed forwards, against 8 to 24 a call), and in 0.75 to 0.85 times `n8`'s. But a cold source's copy is
  bound by its loads, not its stores: at 256 bytes `h16`'s 32 loads take 17.51 cycles, `n8`'s 32 loads and 32
  stores 18.98, and `w16`'s 16 of each 10.29.
- **The issue's question:** a wide load after narrow stores that have retired costs nothing (`far`: no
  `stli_other` for any shape, `w16` as fast as `h16` at 64 and 128 bytes and 0.77 times its cycles at 256).
  Only stores still in flight matter.
- **A source a 16-byte copy wrote** forwards to 8-byte halves (`stli_other` 0.13 a call or less), but `w16`
  copies it in 0.61 to 0.69 times `h16`'s cycles. 32-byte loads from it fail (`w32`, 2.7 to 15.5 a call).
- **4-byte stores** fail every shape's 8- and 16-byte loads; `n8` is the least slow.
- `p16` is `h16` within 5%; `h32` and `w32` are `h16` and `w16` within 4%, but on cold sources (`w32` 7.05 at 256 bytes) and a source a 16-byte copy wrote.

So the PR chooses by the source, as #1375's design (comment 6721282513, section 6) and the issue say. The
lowering builds a local by its fields' stores, often just before a copy reads it, so a copy from a local loads
`h16`'s halves; any other source keeps `w16`.

The `built` rows come from an earlier run of the same kernels with one hold per size (`bench SOURCE SIZE`); the
others from `run.sh`, one hold per source. The first run of `run.sh` timed out waiting for the lock (its
`timeout 600` was outside the hold); `run.sh` now has it inside.

## The PR's tiers (`harness/`)

Pending: `harness/record.sh` is queued for the 9700X's lock (main `2ebfe687` against head `46abbb01`, #1375's
assign and cold kernels at 32 to 256 bytes, both tiers and clang `-O0`). This section gets its tables, and
`results/` its receipts, holds and binaries' hashes, when the run lands.

## Compile time and code size

Pending, from the same run: `-c --lanes 1` of `sqlite3.c` and the compiler's `main.c` by both trees in both
tiers, `perf stat -r 5`, and each object's `.text` bytes.

## The Zen 5 model's rows

`results/zen5-movhps.txt`: `measure-x86-zen5 --missing --table` by the PR's first commit's compiler (`a63e6d3f`),
which measured the two cases the PR's `x86_zen5_rows.c` added: `movhps xmm, m64` with a base, 6.5 cycles from the
address (4.5 more than the register path) and 0.5 cycles' reciprocal throughput, one retired op and one FP op;
with an index, 7.5 (5.5). The rest of the table it printed was the committed one, which it didn't measure.

## Limitations

- One placement of each binary; the kernels are tight loops.
- `stli_other` counts load replays and can count one load more than once; read it as a direction.
- The shapes' kernels are idealized: the source built by straight stores, not Tier 0's loop. #1375's kernels
  (`harness/`) are the compilers' own code.
