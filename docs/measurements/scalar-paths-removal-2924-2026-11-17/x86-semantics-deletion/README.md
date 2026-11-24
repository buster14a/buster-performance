# The x86 semantics' effects and form-choice twins deleted (#2924, the x86 tables' group, piece c)

Branch `claude/2924-x86-semantics` on main `b3f3d1b26`: tests `6534b40bb`, deletion `e09973e16`, the debug checks'
records in place `f17b9a439`, one write column a function `a59d95405`.

`x86_semantics.c` loses `x86_instruction_effects_scalar`, `x86_instruction_effects_opmasks_scalar`,
`x86_instructions_effects_scalar`, `x86_instructions_effects_opmasks_scalar`, `x86_choose_forms_scalar` and
`x86_choice_have`. `x86_instruction_resolve` stays as the vector effects' route for rare records (phase D's).

## Gate: the functions alone (9700X, Release, under the lock, CPU 2)

`benchmark-x86-semantics` with a knob that calls each path on N items a call
([`semantics-batch-knob.diff`](semantics-batch-knob.diff), [`knob2.diff`](knob2.diff); scripts `gate*.sh`; outputs in
[`gate/gate-out/`](gate/gate-out/), logs in [`gate/`](gate/)). Cycles an item:

| Items a call | Choice: twin | Choice: AVX-512 | Effects: twin | Effects: AVX-512 | Opmasks: twin | Opmasks: AVX-512 |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 (main) | 43.8 | 141.3 | 85.6 | 54.7 | | |
| 1 (head) | 49.1 | 102.2 | 82.7 | 54.8 | 82.3 | 75.6 |
| 2 (head) | 39.9 | 35.3 | 78.7 | 27.6 | | |
| 8 (main) | 22.1 | 17.7 | 79.5 | 7.3 | | 10.1 |
| 8 (head) | 22.3 | 6.8 | 80.1 | 7.3 | | 10.0 |
| whole (main) | 21.5 | 3.4 | 72.8 | 6.1 | | 8.9 |

The vector effects win at every count. The vector choice lost at 1; the head lowers its fixed cost (quarters without a
live request skipped, the candidate loop rolled with an early exit) and its single-request callers (the certificate's
kernels, the `-g` straight-line check) now defer their choices and check 32 at a time.

## Whole compiles (9700X, Release, one grant each, `ab --rounds 2 --cpu 2` around `time-runs --runs 2 --copies 2`)

sqlite3.c, `--lanes 1`, user cycles in millions, medians of 4 runs.

[`run-c3.sh`](run-c3.sh), [`logs/time2.log`](logs/time2.log), and [`run-c5.sh`](run-c5.sh),
[`logs/time3.log`](logs/time3.log) (base `b3f3d1b26`, base-again a second copy of base's binary):

| Build | `-c --tier1 -g` | `-c --tier1` | `-c` |
| --- | ---: | ---: | ---: |
| base | 6732.1 | 3446.5 | 546.3 |
| head2 `f17b9a439` | +0.27% | -0.07% | +0.42% (copies -0.18% to +0.43%) |
| head3 `a59d95405` | **-0.62%** (copies -0.68% to -0.38%) | +0.05% | -0.24% (copies -0.85% to +0.56%) |
| base-again | -0.09% | -0.00% | +0.05% |

The first head `e09973e16` read +0.55% on `-c --tier1 -g` ([`logs/time.log`](logs/time.log), `run-c.sh`, `run-c2.sh`).
[`run-c4.sh`](run-c4.sh)'s `perf record` ([`perf/`](perf/)) put it in the `-g` path's count-1 effects calls (resolve
-799 samples, `x86_instructions_effects` +725, opmasks +136, `check_tier1_debug_transfer` +252): a call a record costs
more than the scalar resolve it replaced. `a59d95405` computes each function's write column once
(`x86_instructions_effects` over its records) in the certificate and the debug checks and reads it by index; the
regression turns into a 0.6% gain. `-c --tier1` and `-c` stay at parity.

## Objects

`-c` of buster's `main.c`, every compile from one directory, is byte-identical to base's in Tier 0, `--tier1`, `-g`,
`--tier1 -g` and `--tier1 --verify` (checked in the container at each head).

## Mutants

[`mutation/`](mutation/) (`run.py` patches, rebuilds, runs the listed tests):
- the vector code ([`sem.json`](mutation/sem.json), [`sem.out`](mutation/sem.out)): 10 of 10 killed by
  `test-x86-semantics`;
- the deferred choices ([`defer*.json`](mutation/), [`defer.out`](mutation/defer.out)): 7 of 7 killed. `d3` (a full
  batch left unchecked) and `d6` (the straight-line check's final check dropped) survived the first round and were
  killed after direct tests in `test-tier1-emit`;
- the write column ([`column.json`](mutation/column.json), [`column.out`](mutation/column.out)): 4 of 4 killed (the
  flags walk never seeing a write, the prologue site reading the next record's column, the debug transfer reading
  record 0's, the value transfer seeing no write).

## Sanitizers

[`sanitizers/`](sanitizers/): ASan, UBSan and MSan builds over the area's tests at `e09973e16`/`f17b9a439` (`sansem*`),
and at `a59d95405` (`head3-*`). MSan's first run flagged opmask outputs read before written: `vpmovqw`'s masked
down-convert store is not modelled by MSan, so the tests' and the certificate's opmask arrays are zero-initialised.
