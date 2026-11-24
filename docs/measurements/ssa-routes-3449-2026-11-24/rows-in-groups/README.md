# SSA's rows in bounded groups (buster #3449, piece 1)

buster#3449 asks for the dense SSA constructor to handle large functions within bounded memory, so that the bounded
construction (`ssa_construct_bounded`, Braun et al.'s on-demand reads) can go. This record is its first piece: the
constructor's exit rows (`last`, a u32 a block and local) become a buffer of at most 256 KiB, a group of chunks of 16
locals for every reachable block, taken a group at a time. Base: buster main `c61e37a11447e379f959c396b6d7abd2c99516f4`.

## Census (cloud container, indicative only)

`patches/census-ssa.patch` printed each promotion's route, size, ticks and scratch peak during `--tier1 -c` of
sqlite3.c, Lua and musl (`scripts/census.sh`). Of 6,704 promotions (default passes), 7 take the bounded construction,
all by `ssa_dense_fits`' cell cap (blocks times locals over 131,072); none by the frontier budget. With the cap lifted,
main's dense constructor is faster than the bounded one on six of them and 3.4x slower on Lua's 1,509 x 654 function,
where initialising its blocks-times-locals `last` (with first-touch faults) costs 3.3 M of its 5.3 M ticks. The figures
are in buster#3449's census comment.

## Attempts, all on the 9700X under exclusive.sh

Each gate is `scripts/gate3.sh` (`scripts/one-hold2.sh`): seven rounds in one locked run of `--tier1 -c` of sqlite3.c,
Lua and musl on one lane, CPU 2, default passes and `--tier1-passes=+all`, each setting's order turning each round;
round 1's objects compared. Ticks are TSC ticks a promoted function (`patches/ticks.patch`: the whole promotion;
`patches/ticks2.patch`: also the construction alone, column 4), compared by per-function medians in cell bins
(`scripts/compare.py`, `scripts/compare2.py`). Every attempt's objects were identical to the base's (1,371 of 1,371).

| gate | head | patch | whole promotion, default / +all | construction alone | verdict |
|---|---|---|---|---|---|
| r1 | dominator-tree walk, element gathers and scatters | rename.patch | 1.037 / 1.036, slower in every bin | | slower |
| r2 | the walk in chunks of 16 | rename2.patch | 1.034 / 1.032, every bin | | slower |
| r3 | r2, and r2 with the walk `noinline` | rename2/3 | 1.024 / | 1.163 (1.145) | slower: the construction itself |
| r4 | main's rows, grouped, writes from a list | rename4.patch | 1.022 / 1.016 | 1.091, 1.22 below 64 cells | slower |
| r5 | r4, the list sized by blocks x chunks | rename5.patch | 1.012 / 1.012 | 1.062, 1.155 below 64 cells | slower |
| r6 | first group written by the scan as main's rows | rename6.patch | 0.997 / 0.994 | 1.035 | see r7 |
| r7 | r6 again, with a control (a copy of the base's file) | rename6.patch | 0.9954 / 0.9936 | | parity below 64 cells, faster above |

The walk (r1 to r3) kept the per-block work of a stack, a log and a merge that main's rows don't have; `perf` (r3,
`scripts/perf-r3.sh`) spread it over the walk's lines. r4 and r5 showed that a footprint the small functions didn't
need (a list sized by instructions) cost them more than its work.

r7, by bin of cells (whole promotion, ratio to the base; the control is the base's own file copied):

| cells | head default | control default | head +all | control +all |
|---|---|---|---|---|
| 0-64 | 1.0018 | 0.9966 | 1.0004 | 0.9982 |
| 64-256 | 0.9956 | 0.9989 | 0.9909 | 0.9986 |
| 256-1024 | 0.9949 | 0.9998 | 0.9914 | 0.9990 |
| 1024-4096 | 0.9943 | 1.0006 | 0.9924 | 0.9996 |
| 4096-16384 | 0.9935 | 1.0000 | 0.9923 | 0.9996 |
| 16384-65536 | 0.9936 | 0.9992 | 0.9931 | 1.0014 |
| 65536- | 0.9871 | 1.0009 | 0.9897 | 1.0010 |
| total | 0.9954 | 0.9992 | 0.9936 | 0.9991 |

`logs/` has every gate's comparison and status; `ticks.tar.xz` the raw per-function ticks of r1 to r7.

## Mutation (cloud container)

`mutation/mutants.py`: 16 mutants of the grouped rows and the scan's split (r6's code), each built and run against
test-ssa (which builds every generated CFG with its rows in groups of one chunk, 128 bytes and 1 KiB, and compares them
with the one group's phis and replacements), test-ssa-ir, test-ssa-source over c-testsuite's subset and
`test-ssa-source --generate 48` (`mutation/run.py`). test-ssa kills 13 of 15 (g01 to g08, g10 to g13, g15); g00 is the
unchanged control. Two survive as equivalent: g09 lets an exposed read take a lane one past its group, which the next
group (that read's own) always overwrites, and no slot sits past the last group; g14 makes a group one chunk wider,
with the buffer sized from the same group, so only the 256 KiB budget is passed. `mutation/results.txt` has the round.
