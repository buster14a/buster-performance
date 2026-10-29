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
  spread, and each build's change against main with its range over the placements.
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

**The first head** (`da2de4d9`) was slower in the plan, at every placement and beyond main again's floor
(`logs/placements-da2de4d9/summary.txt`): `chain` +10.0% by the scalar twin and +3.3% by the vector path, `pressure`
+5.2% and +2.8%, `wide` +1.2% and +1.5%; and `wide`'s whole pipeline +4.2% by the vector path. The laptop's counts
put it in the plan's pass over the nodes: 37 to 42 instructions more per node on every shape and path, on the lines of
the pass's depth, level and operand walk. The barriers' store in that pass made the operands' walk after it reload the
function's columns (the build's `-fno-strict-aliasing`); as a loop of their own, the same barriers cost 5 to 8
instructions per node.

**`589d8641`**, the barriers a pass of their own (a running maximum 16 nodes at a time, with the loop as its scalar
twin), made the vector path faster than main at every placement (`logs/placements-589d8641/summary.txt`): the plan
-1.2% to -1.8%, the whole pipeline -0.3% to -1.6%. The scalar twin's plan stayed +0.5% to +5.9% slower, though it ran
only 2 to 5 instructions per node more. On the laptop, removing the barrier pass didn't recover its cycles, and
restoring the load test's old shape (the right operand's load, or a commutative operation's left where the right isn't
a load, rather than also the left after a right load that can't fold) did: that test changed the registers and frame of
the plan, which the benchmark inlines, by more than its 2.75 instructions per node account for.

**The final head** (`ba283ca7`, with that test and main `0dd6fbc3` merged) against main `0dd6fbc3`
(`logs/placements-ba283ca7/summary.txt`), ns per IR node, each build's median over its six placements, the change's
range over the placements in parentheses:

| Shape | Phase | Path | main | head | Change | main again |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| chain | plan | scalar | 25.992 | 25.596 | -1.52% (-6.22 to +0.20) | -0.68% |
| chain | plan | vector | 27.758 | 27.063 | -2.50% (-7.80 to -1.83) | -0.23% |
| pressure | plan | scalar | 26.992 | 26.455 | -1.99% (-3.54 to -0.60) | -0.64% |
| pressure | plan | vector | 26.547 | 25.886 | -2.49% (-5.75 to -1.02) | -0.80% |
| wide | plan | scalar | 27.434 | 26.886 | -1.99% (-2.59 to -1.34) | -0.01% |
| wide | plan | vector | 24.274 | 23.668 | -2.50% (-3.50 to -1.59) | +0.13% |
| chain | pipeline | scalar | 100.267 | 98.422 | -1.84% (-2.24 to +11.40) | +0.45% |
| chain | pipeline | vector | 89.196 | 87.341 | -2.08% (-4.07 to +5.42) | +2.17% |
| pressure | pipeline | scalar | 186.964 | 185.565 | -0.75% (-1.78 to +33.67) | +0.24% |
| pressure | pipeline | vector | 149.493 | 146.792 | -1.81% (-2.42 to +20.45) | +0.15% |
| wide | pipeline | scalar | 108.466 | 108.183 | -0.26% (-1.01 to +18.98) | +0.05% |
| wide | pipeline | vector | 79.058 | 78.639 | -0.53% (-1.11 to +1.40) | -0.02% |

The plan is faster at every placement by the vector path, and at all but one by the scalar twin (`chain` +0.20% at
one). The whole pipeline is faster at five of the six placements on every row; at the sixth, the head's code 704 bytes
later, its runs were slower in all three rounds (`pressure`'s scalar twin 248.6 against 184.8 to 186.9 ns at the other
placements, its vector path 178.7 against 146.1 to 148.0), where main's at the same shift weren't. The 9700X's
counters of that executable (`logs/counters-704.txt`; its runs are timed, so it completes fewer instructions in about
the same cycles) show it dispatching 1.28% of its operations from the legacy decoders against 0.87% at shift 0 and
main's 0.92% at 704: the op cache missing on that layout's hot code, a placement of that executable rather than work
the change adds.

The records are the same: every row's structure is main's in every run, and `test-tier1-select --manifest` lists the
same records.

## Limits

The benchmark's shapes are synthetic and hold no loads, so the fold itself never fires in them: these figures are the
batched choice's and the barrier pass's costs, not the fold's gains. No source corpus runs Tier 1 yet. The laptop's
diagnosis used its Zen 4, whose cycles are noisier (the least of five runs is reported); its instruction counts are
exact.
