# Folding `lower.validate` into Tier 0's own analysis, measured and refuted, 2026-11-23

[buster#3394](https://github.com/buster14a/buster/issues/3394) is step 4's piece 7 of
[buster#2874](https://github.com/buster14a/buster/issues/2874). The first record,
[`tier0-validate-3394-2026-11-23`](../tier0-validate-3394-2026-11-23/README.md), made the validator itself faster
(buster PR #3410). It concluded that 0.5 ms would need validation folded into Tier 0's own analysis.

This record measures that fold before building it. The fold has two possible directions:

- Tier 0's passes check the stream's rules as they compute labels, values, fusion and effects, and depths.
- Validation's results feed those passes so they don't recompute them.

**The result: the fold is refuted.** Running the validator where Tier 0 runs makes the row slower by itself. The work
the two share is at most 0.29 ms, and about 0.1 ms realistically. The gate asks for 0.58 ms.

## Setup

- **The 9700X:** CPU 2, under the lock, one hold a set (`scripts/queue.sh`).
- **Builds:** main `56a9bfc6`, Release, `BUSTER_HOST_ARCH=znver5`, `BUSTER_DEBUG_INFO=0`. They were built in a cloud
  container with CI's staged toolchain (LLVM 23.1.4) and copied over stripped (`binaries.sha256`).
- **Input:** the frozen corpus of `tools/ci/fetch-corpus.sh` (archive `ceb39bf9…`). `-c sqlite3.c` uses the first
  record's flags and covers 2,602 bodies.
- **Measurement:** `--time-stages`, medians of 11 (`scripts/stages.sh`, `scripts/table.sh`).
- **Laps:** TSC laps from the experiment patch (`patches/laps-and-move-experiment.patch`), summed over the compile and
  printed with the stage clock.

## What Tier 0's analysis costs (laps, `laps2` and `stay3`)

| part | ms | what it computes |
| --- | ---: | --- |
| `tier0_validate` in the lowering | 0.854 | (of `lower.validate`'s 1.083) |
| `tier0_vector_labels` | 0.077 | the targets' bits |
| `tier0_vector_values` | 0.124 to 0.130 | P0: each value's predicates (fits an imm32, a shift count, zero, a SIB scale…) |
| `tier0_vector_fuse` | 0.391 to 0.425 | P1 and P2: raw effects, leaf and compound fusions |
| `tier0_vector_depths` | 0.078 to 0.081 | P3 and P4: absorbers, the folded effects, the integer and floating depths |
| `tier0_generate` | 2.95 | selection, homes, measuring, emission |

**What the validator computes that Tier 0 also computes:**

- the column loads and the kind lookups;
- the control entries' targets (Tier 0's labels);
- the prefix sums of each entry's effects.

Tier 0's depths are two stacks, integer and floating, after fusion's absorbers fold their effects. The validator's
depth is one stack of every class before fusion, so neither can take the other's depths as they are.

**What the validator computes that Tier 0 doesn't:**

- each operand's producer (the two doubling searches);
- the class rules on the producers' classes;
- the values' bounds by kind;
- the locals' and calls' tables;
- the arrivals' stacks.

The first record puts the producer searches and the rules at about 600 of the block's instructions. These would move
into Tier 0's passes unchanged. A fold can't remove them.

So the fold's saving is at most one copy of the shared work. Tier 0's copy costs at most labels + depths + values =
0.29 ms, even taking all three passes as shared. Realistically it is about 0.1 ms: the labels and the loads.

## Running the validator where Tier 0 runs (`move3` against `stay3`, one binary, one hold)

The `move` binary takes `BUSTER_3394_MOVE=1`, under which the lowering skips `tier0_validate` and
`tier0_compile_entries` runs `tier0_validate_entries` on each function before its passes. This is where a fold would
run the checks, and it shares nothing yet. It measures what the move alone costs.

| | validation in the lowering (`stay3`) | validation in Tier 0 (`move3`) | main (`main3`) |
| --- | ---: | ---: | ---: |
| `lower.validate` | 1.087 | 0.217 | 1.085 |
| `tier0` | 4.073 | 5.025 | 4.029 |
| sum | 5.160 | 5.242 | 5.114 |
| the validator's lap | 0.855 | 0.968 | |
| `tier0_vector_labels` | 0.077 | 0.070 | |
| object | `c36d1199…` | `c36d1199…` | `c36d1199…` |

The sums of `lower.validate` and `tier0`, run by run:

- `stay3`: 5.13 to 5.20;
- `move3`: 5.20 to 5.28;
- `main3`: 5.07 to 5.20.

Every moved run is above the median of validation in the lowering.

The validator takes 13% longer inside Tier 0 (0.968 against 0.855 ms). Tier 0's passes and `tier0_generate`
evict its tables and code between one function and the next, as the validator does to Tier 0's. That is the coldness
step 4's row already shows: a warm Tier 0 takes 51 cycles an entry against 71. The labels pass gains 0.007 ms from
the kinds the validator just loaded.

## The projection, and the gate

A complete fold changes the row (`lower.validate` + `tier0`) by:

- the move's cost, +0.08 ms (measured);
- less the shared work removed: −0.29 ms at the very most, about −0.1 ms realistically.

That comes to −0.21 to +0.0 ms.

**The gate.** Measured on the row's sum, since moving the work out of `lower.validate` isn't a saving by itself. The
row has to fall by what takes `lower.validate` from 1.08 to 0.5 ms: 0.58 ms. It is refuted below 0.2 ms. The
projection's best case is at the refutation line and its realistic case is far under it, so the fold is **refuted**.
It wasn't built.

The fold also carries costs the projection leaves out:

- The lowering validates every function that Tier 1, the inliner's spliced streams, the interpreters and the other
  consumers read. A fold into Tier 0 would keep a validator for them anyway, so there would be two places to keep exact.
- A refusal would move from the lowering's ordered failure (`check_lower_finish`'s frame stage) to the emission's
  lanes, and the diagnostics would have to be ordered again.

## What remains for #3394

The first record's list stands:

- `abi_assign`'s per-call loops in vector (#3375), about 0.15 ms;
- a producer formulation that breaks the doubling searches' dependency chain (the blocks' 0.59 ms);
- the lap's coldness, which the move shows is not cured by running the validator beside Tier 0.

## Files

- `scripts/`: `queue.sh`, `stages.sh` and `table.sh`, as run.
- `patches/laps-and-move-experiment.patch`: the laps (`LAP3394`, printed with `--time-stages`) and `BUSTER_3394_MOVE`,
  on main `56a9bfc6`. It is an experiment and not for merging.
- `results.tar.zst`: `main1`, `laps1` (laps not printed: the process exits without destructors; fixed in `laps2`),
  `laps2`, `stay3`, `move3` and `main3`, each run's stage clock with each hold's `busy-before.txt` and `busy-after.txt`
  (nothing busy).
- `binaries.sha256`: `main`, `laps` (as in `laps2`) and `move` (as in `stay3` and `move3`).
