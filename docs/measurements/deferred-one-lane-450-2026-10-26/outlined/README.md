# Outlined deferred phase: rejected timing candidate

This records exact candidate `d4db297d122fc4be18c4cf245dd1462439d884d0` against the reused
`31c4ced26abcf0393e8c8f4f138e42dfe1952ee4` baseline. It removes the separate one-lane context helper,
marks the existing `check_deferred_bodies` phase noinline, and places the identical context operations inside it.
Correctness passes, but whole-reader timings regress. It is not accepted or presented as merge-ready.

Source archive SHA256: `f1947c4b17666505cb169c3968c306b765413caff59635c8edf2921c516df71e`.
Native executable SHA256: `9cf09f798003f0ff307ef66f19189d39b8c8f0625e208e0f50d4c82bc0015210`.
The 42-source native compile phase took 34.1 seconds using six named CPUs and an explicitly six-thread wild wrapper,
under the actual shared host lock. The baseline executable remains `2a30c27d0d94cd692a8559ef47f400458021e11f02f32d8848b46254f84ce218`.

The inputs, 24-pass permutations, five paired rounds on eleven units, alternating build order and 219-program sweep
are identical to the helper comparison. There are 548 independent measurement processes and 1,096 lane rows;
`summary.tsv` has 460 complete paired/sweep result rows. The five real measurement holds last 37, 25, 2, 2 and 3
seconds, all below the approved 60-second cap. Every process and receipt exits zero. The 226 source/archive/binary
SHA rows match before and after; exact commands and host observations remain in `acceptance/`.

| SQLite reading | Baseline ns/token | Candidate ns/token | Change | Range of paired changes |
| --- | ---: | ---: | ---: | ---: |
| One lane | 121.59 | 122.96 | +1.1267% | +0.5269% to +1.5709% |
| Adaptive eight lanes | 106.35 | 107.49 | +1.0719% | +0.6494% to +1.6361% |

The source-order control rises 0.7637%, and the normalized deferred ratios also rise. SQLite dispatch falls
6,953 → 140 ns on one lane, with zero wake time, but that does not waive the whole-reader gate. Several other
representatives increase, and 34 requested-lane sweep rows exceed +2%. Full rows, source-order controls, phase
observations and paired ranges remain in `rows.tsv`, `summary.tsv` and the untouched measurement lines of `raw/`.

Native assembly confirms the common reader shrinks from 80,642 to 49,884 bytes and its stack allocation from
`0x808` to `0x6c8`. The outlined phase is 31,142 bytes with a `0x2c8` allocation; the lane callback is unchanged.
This isolates the phase but does not shrink total code: common reader plus phase is 81,026 bytes, compared with
the earlier common reader plus 89-byte helper's 80,731. Neither the footprint change nor normalization establishes
an end-to-end improvement. `assessment.md` distinguishes observed placement changes from unproven cache causes.

Exact-source local ASan/UBSan/leak checks pass all 49 fixtures and 772 checks, with no findings. Fresh bounded
call-graph capture covers 42 units, 23,568 functions and 139,099 calls, with zero disallowed cycles or split state.
Native fixtures again pass 49/772; all 220 C programs and the 2,608 frozen SQLite bodies agree with source order
and Clang. The existing unsupported-symbol feature remains recorded. No acceptance threshold or test was weakened.

Recompute with the parent record's original `summary450.c` reader, passing `raw/paired-*.log raw/sweep-*.log` in
`rows` or `summary` mode. `group450-phase.sh`, `batch450-phase.sh`, `queue450-phase.sh` and provenance scripts
preserve the method. Queued-wait owner metadata is filtered for publication; acquired receipts and observations
are retained verbatim, with unfiltered transport archives retained by the coordinator.
