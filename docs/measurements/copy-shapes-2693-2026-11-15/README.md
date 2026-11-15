# An aggregate copy's pieces by its source, Buster #2693

Compiler issue: [#2693](https://github.com/buster14a/buster/issues/2693), part of
[#1375](https://github.com/buster14a/buster/issues/1375). Compiler PR: [#2817](https://github.com/buster14a/buster/pull/2817), commits
`46abbb01d228a64d7fdc7c42a19addc25e0b6213` (the first pass) and `14fb7f839fc37f3ee574179c752ea239202f3b52` (the
second) on main `2ebfe68a856613e300231520af5e7ec5627708b6`.

A copy of a struct just built by 8-byte stores can't take a 16-byte load's data from them: the load waits for
the stores to reach the cache. Before the PR, Tier 0 copied past 32 bytes by 16-byte loads and stores, and Tier 1
copied everything by 8-byte ones, which forward but double the stores. #1375's record measured both sides of that
trade on two kernels. This record first measures the copy's shapes alone, against five ways of writing its source
(`shapes/`), and then the PR's two tiers on #1375's kernels, compile times and code sizes (`harness/`).

## Host

The Ryzen 7 9700X (`benchpress`), Linux 6.18.50, CPU 2, governor and EPP `performance`, clang 23.1.1, perf
7.2.9 (`results/receipts.txt`). Every run took the 9700X's lock (`exclusive.sh`) for itself, with its timeout
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

#1375's kernels (its record's `kassign.c`, `kcold.c` and drivers, unchanged): `assignN` builds a struct of N longs by
8-byte stores in a loop and copies it to `*out`; `coldN` copies `*in` from a table nothing has written since the
start; 20 M calls each. N is 4 (32 bytes, which the PR leaves alone), 5 (40, whose last piece overlaps), 6, 8, 16
and 32. `build-kernels.sh` compiles each by main's and head's compilers (`-c -O0`, and with `--tier1`) and by clang
`-O0`, each linked with its clang `-O2` driver; every binary's checksum is clang's. `measure-one.sh` runs each under
`perf stat -r 10` on CPU 2 (`kernels.tsv`: binary, ms, cycles, perf's spread, instructions, `stli_other`, checksum,
perf's status; every status 0, the largest spread 2.3%, a clang binary's).

Two passes. The first (`record.sh`, `results/`) measured head `46abbb01`. Its `--tier1` compile of `sqlite3.c` took
1.07% more instructions than main's (below), so the PR's `14fb7f83` changed Tier 1 alone, and the second pass
(`record2.sh`, `results/second/`) rebuilt head there and measured its Tier 1 kernels and compiles against main's
again. Its Tier 0 kernel objects are the first pass's, byte for byte (`second/tier0-objects.txt`), so Tier 0's rows
below are the first pass's and Tier 1's the second's.

Millions of user cycles, the mean of 10:

| kernel | bytes | main T0 | head T0 | head / main | main T1 | head T1 | head / main | clang `-O0` |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| assign | 32 | 292.9 | 299.1 | 1.021 | 154.3 | 154.3 | 1.000 | 590.7 |
| assign | 40 | 688.8 | **296.8** | **0.431** | 191.1 | 191.1 | 1.000 | 500.0 |
| assign | 48 | 728.5 | **345.4** | **0.474** | 227.9 | 227.9 | 1.000 | 647.2 |
| assign | 64 | 810.7 | **441.0** | **0.544** | 325.0 | 326.9 | 1.006 | 704.4 |
| assign | 128 | 1,149.7 | **830.3** | **0.722** | 714.5 | 718.9 | 1.006 | 1,011.2 |
| assign | 256 | 1,840.2 | 1,784.0 | 0.969 | 1,000.8 | 1,003.8 | 1.003 | 1,533.8 |
| cold | 32 | 80.8 | 80.8 | 1.000 | 80.7 | 80.7 | 1.000 | 97.3 |
| cold | 40 | 100.4 | 100.4 | 1.000 | 100.4 | 100.4 | 1.000 | 260.4 |
| cold | 48 | 82.8 | 82.8 | 1.000 | 107.6 | **83.5** | **0.776** | 232.4 |
| cold | 64 | 100.4 | 100.4 | 1.000 | 120.4 | **100.4** | **0.834** | 218.4 |
| cold | 128 | 110.7 | 110.7 | 1.000 | 193.6 | **110.0** | **0.568** | 220.4 |
| cold | 256 | 201.0 | 200.9 | 1.000 | 359.4 | **201.6** | **0.561** | 242.5 |

- **Tier 0** loads the struct just built (`b`, a local) as 8-byte halves: 0.43 to 0.72 times main's cycles from 40
  to 128 bytes, and 0.97 at 256, where the 32 stores that build it dominate. At 64 bytes it takes 0.63 times clang
  `-O0`'s cycles, at 128 0.82. Its cold copies (`*in`, through a pointer) keep 16-byte loads: the same code as
  main's, the same cycles. At 32 bytes the code is main's too (8-byte pieces), and the 2.1% is the run's (main's
  spread 1.35%).
- **Tier 1** copies `*in` by 16-byte pieces: 0.56 to 0.83 times main's cycles from 48 to 256 bytes, which is now
  Tier 0's within 1%, and below clang `-O0`'s at every size. At 40 bytes (16, 16 and an overlapping 16) the cycles
  are the same with 4 fewer instructions a copy. Its copies of the local `b` keep their 8-byte pieces (the same
  cycles within 0.6%); halves there are #2818.
- `stli_other` rose in Tier 0's `assign` rows (61.0 to 114.5 M at 40 bytes) while their cycles fell: halves replay
  where the loop's last stores are still in flight. #1375's record saw the same (it counts replays, not stalls).

The kernel builds took one hold; each kernel's five binaries one hold (the first pass), each family's twelve Tier 1
binaries one (the second); each input's compiles by both trees one hold per tier. `holds.txt` has all 98 holder lines,
every one this run's (`claude-2693`).

## Compile time and code size

`compile-one.sh`: `-c --lanes 1` of `sqlite3.c` (SHA-256 `0a409f16…`) and main's own `src/buster/compiler/main.c`
(`-march=native -Isrc -fwrapv -funsigned-char -fno-strict-aliasing -DBUSTER_COMPLETE_DRIVER=1`), pinned to CPU 2,
`perf stat -r 5`, and the object's `.text` bytes. Tier 0's are the first pass's, Tier 1's the second's (head
`14fb7f83`). Millions of cycles and instructions:

| input | tier | main cycles | head cycles | head / main | main instructions | head instructions | head / main | `.text` main | head |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `sqlite3.c` | 0 | 596.07 (±0.49%) | 590.74 (±0.15%) | 0.991 | 1,349.50 | 1,349.52 | 1.000013 | 1,242,968 | 1,243,048 |
| `main.c` | 0 | 8,063.30 (±1.92%) | 7,894.44 (±0.03%) | 0.979 | 21,270.20 | 21,264.12 | 0.999714 | 1,897,278 | 1,900,734 |
| `sqlite3.c` | 1 | 3,351.78 (±0.47%) | 3,337.91 (±0.04%) | 0.996 | 8,206.96 | 8,207.03 | 1.000008 | 1,521,400 | 1,520,488 |
| `main.c` | 1 | 11,284.70 (±0.07%) | 11,266.55 (±0.06%) | 0.998 | 30,371.43 | 30,364.59 | 0.999775 | 1,801,230 | 1,801,054 |

- The instructions move by 0.03% at most. The cycles fall by 0.2% to 2.1%, which five runs of one placement don't
  separate from the run (main's Tier 0 `main.c` spread ±1.92%): the instructions are the firmer comparison.
- Tier 0's code grows by 80 bytes on `sqlite3.c` and 3,456 on `main.c`: a local's copy past 32 bytes takes a third
  record per 16 bytes (`movhps`). Tier 1's shrinks by 912 and 176 bytes: a cold copy's 16-byte pieces are half
  the instructions.
- **The first pass's Tier 1** (head `46abbb01`, `results/compile.tsv`): `sqlite3.c` took 8,294.91 M instructions
  against main's 8,206.94 M (1.0107) and 3,377.06 M cycles against 3,343.53 M (1.0100). Callgrind, on the x86-64
  host build in the cloud (`valgrind --tool=callgrind` under `ulimit -v 120000000`), put it in `ir_optimize_sroa`,
  0.96 M instructions on main and 142.3 M on that head: the inliner's pass (`check_tier1_inline_expand`) runs SROA on
  any body whose IR has vectors, and a cold copy's `v4i32` pieces made `sqlite3VdbeExec` one. `14fb7f83` takes the
  vectors from the body's source and its expanded callees' instead; callgrind then counted 19,338.7 M instructions
  against main's 19,353.3 M, and the second pass above.

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
- The compile timings are five runs of one placement each; the instructions are the firmer comparison.
- The callgrind counts are the cloud container's x86-64 host build's (Develop), not the 9700X's Release build: they
  located the cost, and the second pass measured it.
