# Branch sizing on small functions (buster#2946, PR buster#3378)

[buster#2946](https://github.com/buster14a/buster/issues/2946) asks for branch
sizing's vector ranks phase, and the write after it, to stop losing to the
removed scalar path's figures on small functions. This record holds the 9700X
measurements behind [buster#3378](https://github.com/buster14a/buster/pull/3378)
and the variants that were tried and dropped.

## Setup

- Host: benchpress (Ryzen 7 9700X), every run under
  `~/buster-fast-bench/exclusive.sh` with `EXCLUSIVE_OWNER=claude-2946`, each
  `taskset -c 2`, Release builds by `./build.sh --config Release` with the
  9700X job's toolchain (Clang 23.1.4).
- Base: buster `9d927943` (`origin/main` when the branch was cut).
  PR: the branch's source at `10c1da90`
  (`claude/branch-sizing-small-2946`). The measured tree was `bb77b265` with
  that commit's change applied; its `branch_sizing.c` differs from
  `10c1da90`'s in two comments alone, the code being identical, and
  `logs/pr-compiler.txt` has the executable's hash.
- `benchmark-branch-sizing` with no arguments: every row, medians of 21
  samples. Three processes each, base and PR interleaved
  (base-1, pr-1, base-2, …), so a change in the host's state hits both.
  `logs/bench-base-*.log` and `logs/bench-pr-*.log` keep each process's whole
  output, with `/proc/loadavg` and the busiest processes before and after it,
  inside the lock.
- The tables below are medians over the three processes, in cycles per branch.
- The scalar columns are from
  [scalar-paths-removal-2924-2026-11-17](../scalar-paths-removal-2924-2026-11-17/c-branch-sizing-gate),
  #2924's gate, which measured `size_branches_scalar`'s phases on main
  `0e8342dd7` before the scalar path was removed.

## What the PR changes

- The ranks' table is built in registers for functions of fewer than 512
  records (at most 16 entries, a register's dwords), without the byte map, its
  `memset`, its store per branch or the gathers of the table just stored.
  Functions of up to 16 branches count each rank directly instead of looking
  it up.
- Setup no longer copies D0 into the displacement column (the rounds write it,
  and the write reads it only after a round) and no longer zeroes the round
  before's prefix sums (only the worklist reads them).
- A function no branch grew in skips the offsets pass and takes the write's
  displacements from D0.

## Whole path and the caller's path

`size_branches` is sizing alone; `size_encode` is sizing and the final encode
in one timed interval, what the code generator pays.

| Row | `size_branches` base → PR | `size_encode` base → PR |
| --- | --- | --- |
| tier0-40 | 66.25 → 63.16 (−4.7%) | 103.83 → 100.67 (−3.0%) |
| tier0-250 | 41.97 → 41.70 (−0.6%) | 69.97 → 69.40 (−0.8%) |
| tier0-2000 | 37.87 → 38.04 (+0.4%) | 66.65 → 67.32 (+1.0%) |
| tier0-10000 | 40.31 → 40.19 (−0.3%) | 69.34 → 69.39 (+0.1%) |
| tier0-mix | 54.69 → 52.46 (−4.1%) | 88.48 → 85.54 (−3.3%) |
| optimized-40 | 55.74 → 52.73 (−5.4%) | 84.47 → 81.37 (−3.7%) |
| optimized-250 | 35.95 → 36.01 (+0.2%) | 57.68 → 57.33 (−0.6%) |
| optimized-2000 | 33.15 → 33.25 (+0.3%) | 54.71 → 55.67 (+1.8%) |
| optimized-10000 | 35.21 → 35.05 (−0.5%) | 57.25 → 57.23 (−0.0%) |
| chain-forward | 194.32 → 194.73 (+0.2%) | 241.99 → 241.98 (−0.0%) |
| chain-backward | 195.38 → 195.66 (+0.1%) | 242.97 → 242.84 (−0.1%) |

The 40-record rows and the mix of sqlite3's -O0 function sizes, which is where
#2946 says most of a compile's functions are, gain 4.1 to 5.4% of sizing and
3.0 to 3.7% of the caller's path. The two 2000-record rows' `size_encode` is
1.0 and 1.8% slower while their sizing is within 0.4%; the encode's own code is
untouched, so that is the unit's code placement, not a change in its work.

## Phases

The benchmark times a phase as the difference between a run through it and a
run that stops before it, so a phase holds the stores of the phases before it
that have not reached the cache. Base → PR, with #2924's scalar figure in
brackets:

| Row | ranks | write |
| --- | --- | --- |
| tier0-40 | 5.34 → 4.15 [2.68] | 8.10 → 7.24 [2.96] |
| tier0-250 | 3.87 → 2.01 [5.01] | 2.70 → 2.77 [2.54] |
| tier0-2000 | 2.87 → 2.92 [4.91] | 1.94 → 1.87 [1.66] |
| tier0-10000 | 2.95 → 2.93 [5.13] | 2.62 → 2.61 [2.61] |
| tier0-mix | 4.72 → 3.26 [6.99] | 4.67 → 4.80 [3.11] |
| optimized-40 | 6.23 → 4.73 [3.38] | 6.64 → 6.49 [2.02] |
| optimized-250 | 3.62 → 2.07 [4.16] | 2.69 → 2.44 [3.12] |
| optimized-2000 | 2.63 → 2.67 [4.07] | 1.93 → 1.92 [2.69] |
| optimized-10000 | 2.78 → 2.74 [5.58] | 2.53 → 2.54 [2.77] |
| chain-forward | 3.34 → 3.41 [5.87] | 2.68 → 2.67 [2.68] |
| chain-backward | 3.35 → 3.44 [5.64] | 2.73 → 2.68 [2.91] |

Ranks is below the scalar figure in nine of the eleven rows; the two 40-record
rows stay above it. The write is at or below it in six rows and above it on the
40-record rows and the mix. So #2946's "done when" is not met and the issue
stays open.

Two measurements separate a phase's own work from the stores it inherits:

- A variant that moved the growth columns and the first prefix sums out of
  setup into a pass of their own, after it, left the same ranks code reading
  1.2 to 1.5 cycles per branch on the 40-record rows. The 2.6 cycles that
  moved with those stores were setup's, paid in the ranks interval. That pass
  cost the functions of 250 records 2% of the whole path (41.03 against 42.89
  on tier0-250, 35.48 against 36.59 on optimized-250), so it is not in the PR.
- A variant that ends every run with an `mfence`, so each phase pays only for
  its own stores, left the 8-branch write (below) at 3.6 to 3.9 cycles per
  branch on the 40-record rows, against 3.5 to 3.8 without the fence: the
  write's own passes of stores, not stores inherited from earlier phases.

## Variants tried and dropped

Single processes, medians of 21 samples, measured against the same base.

- **The write 8 branches a pass**, with the lanes past the last branch storing
  to sink records so that every pass stores 8. The write's loop ends at a
  branch the predictor misses 0.64 times per 40-record function, since their
  branch counts vary; perf counted 836,000 extra mispredicts over the pool
  against 48,000 with the fixed-width passes. It took 0.3 cycles per branch
  off the write phase and 1.4 to 3.5% off sizing on the 40-record rows, but
  `size_encode` was 1 to 5% slower in nine of the eleven rows (tier0-mix 91.52
  against 88.80, optimized-250 60.28 against 57.53):
  `logs/variant-8-branch-write-1.log`.
- **The write leaving the forms alone** where no branch grew (the displacements
  alone, from D0). Sizing was 1.5% faster and `size_encode` 5 to 6% slower on
  the 40-record rows (tier0-40 108.77 against 102.10), since the encode reads
  every record's form straight after:
  `logs/variant-loop-write-no-forms-1.log`.
- **A 2-byte mask of the jmps per 16 branches** in place of setup's
  growth-if-long column, expanded by the rounds. Slower in every row measured
  (tier0-40 60.80 against 60.28, tier0-250 41.36 against 41.03).
- **`branch_sizing_first_vector` inlined** into the driver, to see whether the
  deferring pass's cost was its call and loop setup. It was not: tier0-250
  stayed at 42.81 against 42.89.

## Correctness

`test-branch-sizing --cross-check` on the PR's build on benchpress: 404
functions printed as GNU as source, 404 compared, 404 the same, with 99,019
long branches; every other check 0 failed (`logs/cross-check.log`). The new
small-functions check (every record count up to 608, a branch every 1 to 4
records, far targets) fails 269 of its 17,667 checks on a one-lane mutation of
the register build that the random functions catch only 7 times.

## Direct target growth and isolated record writes

The complete compiler uses 16-lane target comparisons for functions with fewer than 512 records and at most 16 branches. It computes each target’s growth directly from the long branches. Only entry to the worklist requires numerical ranks. All-short functions with one packet scatter their final displacements during setup. The other functions count their long branches by packet and publish the final records in branch order.

The table gives the production benchmark’s median phase differences in cycles per branch. Each whole-path change divides candidate cycles by parent cycles for the same seed and takes the median of the three paired ratios. The archived scalar columns are the original three-process measurements. The executable baseline is cc7d4ffb4. Negative near-zero phase differences occur because two separate benchmark runs estimate each phase.

| Row | Scalar ranks | New ranks | Scalar write | New write | Sizing | Sizing and encoding |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| tier0-40 | 2.39 | -0.14 | 3.13 | 2.23 | -7.834% | -3.955% |
| optimized-40 | 3.38 | -0.19 | 3.01 | 2.25 | -6.347% | -1.910% |
| tier0-250 | 5.60 | 1.94 | 2.82 | 2.53 | -0.620% | -0.636% |
| optimized-250 | 5.13 | 2.00 | 2.67 | 2.32 | -1.035% | -1.366% |
| tier0-2000 | 5.59 | 2.96 | 1.66 | 1.98 | -0.237% | +1.353% |
| optimized-2000 | 5.20 | 2.67 | 1.87 | 2.01 | +0.030% | +1.652% |
| tier0-10000 | 4.59 | 2.96 | 2.61 | 2.55 | -0.668% | -0.354% |
| optimized-10000 | 5.34 | 2.79 | 2.52 | 2.48 | -0.339% | -0.190% |
| tier0-mix | 7.49 | 1.05 | 3.75 | 2.77 | -2.265% | -1.566% |
| chain-forward | 5.87 | 3.34 | 2.68 | 2.70 | -0.169% | -0.082% |
| chain-backward | 5.64 | 3.38 | 2.91 | 2.66 | -0.072% | -0.041% |

The first replay runs both writers on identical prepared columns for every function. Its same-binary control uses the parent writer for both labels. The second replay also models the one-packet scatter for all-short functions, loading the already prepared record indices and displacements from memory. In the compiler these values are already in registers. Each replay resets the records, alternates order nine times per seed, validates every final form and displacement, checks the total long branches and records user cycles and instructions. The “packet” writer extracts form changes from a packet mask. The submitted “separate count” writer counts masks before storing.

| Row | Identical writer control | Both writers called, packet | Both writers called, separate count | With all-short scatter, packet | With all-short scatter, separate count |
| --- | ---: | ---: | ---: | ---: | ---: |
| tier0-40 | -1.136% | -0.131% | -0.192% | -20.406% | -24.405% |
| optimized-40 | -1.133% | +5.973% | +6.759% | -16.060% | -17.801% |
| tier0-250 | +0.098% | -1.505% | +0.614% | -3.494% | -1.803% |
| optimized-250 | +0.263% | -3.935% | -0.467% | -2.463% | -2.159% |
| tier0-2000 | -0.586% | -10.655% | -1.704% | -7.780% | -3.439% |
| optimized-2000 | -0.459% | -16.275% | -5.160% | -13.345% | -6.068% |
| tier0-10000 | -0.204% | -2.980% | +0.827% | -3.538% | -0.138% |
| optimized-10000 | -0.111% | -5.485% | +0.205% | -4.947% | +0.059% |
| tier0-mix | +0.663% | -3.943% | -4.613% | -8.103% | -5.879% |
| chain-forward | -2.089% | -4.413% | +2.158% | +5.112% | -0.084% |
| chain-backward | -1.317% | -5.733% | -3.395% | +4.596% | -2.022% |

The standalone builds use the production benchmark source with the same two candidate implementations. They measure how much whole-path results vary between the standalone and completely linked executables.

| Row | Packet sizing | Packet sizing and encoding | Separate count sizing | Separate count sizing and encoding |
| --- | ---: | ---: | ---: | ---: |
| tier0-40 | -6.803% | -3.346% | -7.535% | -3.931% |
| optimized-40 | -6.668% | -1.641% | -6.918% | -2.097% |
| tier0-250 | -0.762% | +1.041% | -1.170% | -1.574% |
| optimized-250 | -1.251% | -1.118% | -1.958% | -1.831% |
| tier0-2000 | -0.525% | -1.170% | -0.422% | -0.811% |
| optimized-2000 | -0.332% | +1.660% | -0.543% | -0.542% |
| tier0-10000 | -0.347% | -0.756% | -0.743% | -0.398% |
| optimized-10000 | -0.085% | -0.592% | -0.424% | -0.172% |
| tier0-mix | -2.568% | -2.138% | -2.728% | -2.332% |
| chain-forward | -0.247% | -0.183% | -0.175% | -0.169% |
| chain-backward | -0.112% | -0.434% | -0.169% | -0.107% |

Five paired rounds measured three fresh full debug compilations per executable in every round. Each candidate produced the same 1,371 debug objects, stdout and diagnostics at each tier. Each passed three seeded branch suites, including the GNU assembler byte comparison on 404 functions per seed, forced worklists, guarded inputs and scratch exhaustion.

| Corpus | Objects | Packet Tier 0 | Packet Tier 1 | Separate count Tier 0 | Separate count Tier 1 |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 34 | +0.201% | +0.290% | +0.016% | +0.425% |
| sqlite | 1 | -0.071% | +0.173% | -0.243% | +0.203% |
| musl | 1336 | +0.069% | +0.115% | -0.163% | +0.363% |

All eleven rank phases cleared the archived scalar values. On both 40-record rows the isolated final write and the complete sizing-and-encoding path improved. The 2,000-record rows used more cycles for sizing and encoding in the shipping compiler, and all three whole Tier 1 compiles used more cycles. The direct-span change remains under qualification.

[Compiler patch, benchmark sources, GNU checks, object hashes and raw native samples](direct-target-growth.tar.xz)

## Counting long branches in the relaxation round

The stable round already has the mask of promoted branches for every packet. Counting the mask there removes a pass over growths before the final record stores. The complete compiler and two standalone builds measured the same eleven workloads against their respective parent. All percentages are medians of three paired seed ratios. The second standalone implementation also scatters final displacements and promotes the long record forms by masked gather and scatter.

| Row | Compiler sizing | Compiler sizing and encoding | Standalone sizing | Standalone sizing and encoding | Standalone scatter sizing | Standalone scatter sizing and encoding |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| tier0-40 | -4.116% | -1.075% | -6.398% | -1.848% | -4.636% | -2.410% |
| optimized-40 | -4.147% | +0.061% | -6.172% | -0.110% | -3.525% | -0.380% |
| tier0-250 | -0.455% | +0.636% | -1.573% | +7.224% | +3.106% | +11.936% |
| optimized-250 | -1.275% | -0.532% | -2.473% | +6.644% | +3.668% | +9.336% |
| tier0-2000 | -0.523% | +2.297% | -0.708% | -1.891% | +5.346% | +1.359% |
| optimized-2000 | -0.634% | +2.196% | -1.175% | -0.668% | +5.549% | +3.488% |
| tier0-10000 | -0.919% | +1.273% | -1.168% | -0.100% | +3.462% | +2.907% |
| optimized-10000 | -1.080% | +0.844% | -1.220% | -0.968% | +3.593% | +2.057% |
| tier0-mix | -1.400% | +0.151% | -2.851% | -2.147% | -0.171% | +1.152% |
| chain-forward | -0.334% | -0.148% | -0.113% | -0.194% | +0.658% | +0.556% |
| chain-backward | -0.210% | -0.049% | -0.246% | -0.185% | +0.936% | +0.759% |

The complete compiler improved sizing on every row. Sizing plus encoding still took more cycles on both 2,000-record rows. The six production comparisons below used five paired rounds of three processes and verified every debug object, stdout and stderr. The three GNU assembler comparisons matched on all 404 functions per seed.

| Corpus | Tier 0 | Tier 1 |
| --- | ---: | ---: |
| lua | -0.160% | +0.174% |
| sqlite | -0.188% | +0.190% |
| musl | -0.035% | +0.149% |

[Round-count changes, benchmark commands, GNU comparisons, object hashes and raw timing logs](round-count.tar.xz)
