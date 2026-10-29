# Tier 1's batched immediates and load folds, Buster #141

Compiler branch: `claude/solve-141-tier1-semantics` of buster14a/buster (buster#846), for
[this claim of a piece of #141](https://github.com/buster14a/buster/issues/141#issuecomment-6489451460), the last of #221.

The branch checks that every record Tier 1 emits has a covered form, chooses the selector's immediates' forms a
function's 32 requests at a time through `x86_choose_forms` (the scalar path choosing each as it comes), and folds a
load into its consumer past the nodes between them that aren't memory barriers (stores, calls, volatile accesses), from
a pass of each node's last barrier. This record measures `benchmark-tier1-select` on the 9700X, which is where the
branch's first head was found to slow the plan, the diagnosis, and the fixed heads.

## Sources and host

Each tree is a `git archive` of its commit (`trees.txt`), extracted into a fresh directory on the 9700X and built there
by `BUSTER_DEBUG_INFO=0 ./build.sh` (`logs/first-rounds/build-*.log`) or `./build.sh shifts` (the placements'
`shifts-build-*.log`):

- **main `d11a91d2`**, the branch's base, against **`da2de4d9`**, its first head (the coverage checks, the batched
  choice, the fold with its barriers kept in the plan's pass over the nodes), and against **`589d8641`**, the barriers
  a vectorized pass of their own;
- **main `0dd6fbc3`**, after #838 merged, against **`ba283ca7`**, the branch with main merged and the load test in the
  selector's old shape: the final head.

The receipts (`logs/receipt-first.txt`, `logs/receipt.txt`): the AMD Ryzen 7 9700X, its kernel, clang 23.1.1, CPU 2's
governor and energy preference (performance), the trees' commits and every executable's SHA-256.

## Method

`benchmark-tier1-select` times three synthetic shapes (`chain`, `wide`, `pressure`, 16,448 to 24,640 IR nodes over 32
functions) through the plan alone (`selection`) and through the whole pipeline (`complete`: plan, liveness, required
locations, allocation, frame, fragments, branch sizing and encoding), by the scalar twin and the vector path, in ns per
IR node, the median of 7 passes of samples of at least 5 ms. Every row's records, code bytes, unknown costs, spills
and peaks must be the same in every run, which `scripts/summarize.py` checks ("structure").

- **First rounds** (`scripts/all.sh`, `logs/first-rounds/`): both trees' builds, the head's Tier 1 suites and
  `test-x86-semantics`, each in a hold of its own, then five rounds, each one hold, of the full run and of the vector
  path after 200 ms of the scalar twin (`--only vector --after-scalar 200`), both trees in an order alternating by round.
- **Placements** (`scripts/shifts.sh`, `logs/placements-*/`): the benchmark's unit (`tier1_select_benchmark.c`, which
  has its own copies of the selector and the emitter) built at six placements over a page (`./build.sh shifts`, 0 to
  3,520 bytes, multiples of its 64-byte alignment), then three rounds, each one hold, of the full run by every
  placement of main, the head and main again (the comparison's floor), the placements in an order rotating by round.
  `summarize.py` takes each placement's median of the rounds, each build's median of its placements, the placements'
  spread, and each build's change against main with its range over the placements as `docs/profiling.md`'s method
  takes it: each of the build's placements' medians against each of main's, 36 pairs, which pair nothing, since a
  shift of one tree isn't the same placement as that shift of another. A change is outside the comparison's floor
  when it is beyond main again's against main and its range excludes 0.
- **Diagnosis** (`logs/laptop-instructions.txt`): on the laptop's Zen 4, the benchmark's unit with
  `scripts/fixed_patch.py`, which runs one row a fixed number of times, under `perf stat`: instructions per node (exact,
  the difference of 140 and 40 runs) and cycles (the least of five runs) of the trees and of variants built to find the
  cost; and on the 9700X, Zen 5's front-end counters of the final head at the placement that ran slow
  (`logs/counters-704.txt`).

Every 9700X build and measurement ran pinned to CPU 2 in holds of the host's lock. The lock's waiting messages, which
name other sessions' and CI jobs' commands and links, are left out of the logs: each locked log starts at its
command's first line, and the scripts' outputs (`all.out`, `shifts.out`) keep only the lines the scripts print
(`scripts/clean_logs.py`).

## Results

Each row's change below is the head's median against main's, with its range over all 36 placement pairs, and "outside
the floor" by the method's criterion (`summarize.py` prints it per row).

**The first head** (`da2de4d9`) was slower outside the floor on nine of the twelve rows
(`logs/placements-da2de4d9/summary.txt`): the plan by the scalar twin `chain` +10.0% (+8.8% to +11.0%), `pressure`
+5.2% (+4.4% to +7.3%) and `wide` +1.2% (+0.6% to +2.1%), by the vector path +3.3%, +2.8% and +1.5%; and the whole
pipeline `chain`'s scalar twin +2.9%, `wide`'s +3.6% and its vector path +4.2% (+3.5% to +5.5%). The laptop's counts
put it in the plan's pass over the nodes: 37 to 42 instructions more per node on every shape and path, on the lines of
the pass's depth, level and operand walk. The barriers' store in that pass made the operands' walk after it reload the
function's columns (the build's `-fno-strict-aliasing`); as a loop of their own, the same barriers cost 5 to 8
instructions per node.

**`589d8641`**, the barriers a pass of their own (a running maximum 16 nodes at a time, with the loop as its scalar
twin), made the vector path faster outside the floor for `chain` and `pressure` (`logs/placements-589d8641/summary.txt`):
the plan -1.25% (-7.36% to -0.16%) and -1.79% (-5.43% to -0.61%), the whole pipeline -1.60% (-3.74% to -0.03%) and
-1.09% (-2.56% to -0.55%); `wide`'s were within it. The scalar twin's plan was +5.9% and +3.8% in the median for
`chain` and `pressure`, within the floor (its ranges, -0.96% to +6.90% and -0.66% to +4.70%, include 0), though it ran
only 2 to 5 instructions per node more. On the laptop, removing the barrier pass didn't recover its cycles, and
restoring the load test's old shape (the right operand's load, or a commutative operation's left where the right isn't
a load, rather than also the left after a right load that can't fold) did: that test changed the registers and frame of
the plan, which the benchmark inlines, by more than its 2.75 instructions per node account for.

**The final head** (`ba283ca7`, with that test and main `0dd6fbc3` merged) against main `0dd6fbc3`
(`logs/placements-ba283ca7/summary.txt`), ns per IR node, each build's median over its six placements:

| Shape | Phase | Path | main | head | Change (all pairs) | main again | Floor |
| --- | --- | --- | ---: | ---: | ---: | ---: | --- |
| chain | plan | scalar | 25.992 | 25.596 | -1.52% (-6.71 to +0.32) | -0.68% | within |
| chain | plan | vector | 27.758 | 27.063 | -2.50% (-7.85 to -1.63) | -0.23% | outside |
| pressure | plan | scalar | 26.992 | 26.455 | -1.99% (-4.33 to +0.48) | -0.64% | within |
| pressure | plan | vector | 26.547 | 25.886 | -2.49% (-6.32 to -0.29) | -0.80% | outside |
| wide | plan | scalar | 27.434 | 26.886 | -1.99% (-3.39 to -1.32) | -0.01% | outside |
| wide | plan | vector | 24.274 | 23.668 | -2.50% (-3.70 to -1.59) | +0.13% | outside |
| chain | pipeline | scalar | 100.267 | 98.422 | -1.84% (-2.95 to +11.40) | +0.45% | within |
| chain | pipeline | vector | 89.196 | 87.341 | -2.08% (-4.28 to +5.42) | +2.17% | within |
| pressure | pipeline | scalar | 186.964 | 185.565 | -0.75% (-1.84 to +33.87) | +0.24% | within |
| pressure | pipeline | vector | 149.493 | 146.792 | -1.81% (-2.59 to +20.72) | +0.15% | within |
| wide | pipeline | scalar | 108.466 | 108.183 | -0.26% (-1.33 to +19.07) | +0.05% | within |
| wide | pipeline | vector | 79.058 | 78.639 | -0.53% (-1.41 to +1.68) | -0.02% | within |

The plan is faster outside the floor on four rows: the vector path's three shapes and `wide`'s scalar twin. Every other
row's median is lower than main's (-0.26% to -2.08%), within the floor: no row is slower. The pipeline's ranges reach
+1.7% to +33.9% through one of the head's placements, its code 704 bytes later, whose runs were slower in all three
rounds (`pressure`'s scalar twin 248.7 ns against 184.9 to 186.6 at its other placements, its vector path 178.9 against
146.5 to 147.9), where main's at the same shift weren't. The 9700X's counters of that executable
(`logs/counters-704.txt`; its runs are timed, so it completes fewer instructions in about the same cycles) show 1.37% of
its dispatched operations coming from the legacy decoders, the rest from the op cache, against 0.94% at shift 0 and
main's 0.99% at 704: the op cache missing on that layout's hot code, a placement of that executable rather than work
the change adds.

The records are the same: every row's structure is main's in every run, and `test-tier1-select --manifest` lists the
same records.

## Limits

The benchmark's shapes are synthetic and hold no loads, so the fold itself never fires in them: these figures are the
batched choice's and the barrier pass's costs, not the fold's gains. No source corpus runs Tier 1 yet. The laptop's
diagnosis used its Zen 4, whose cycles are noisier (the least of five runs is reported); its instruction counts are
exact.
