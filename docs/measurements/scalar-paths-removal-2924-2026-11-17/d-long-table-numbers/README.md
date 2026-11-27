# Classifying long table numbers

The table classifier asks whether the spelling includes a possible splice and whether an integer converted to a floating type needs a rounding check. At the baseline, spellings beyond 64 bytes switch to a per-byte scalar implementation. The experiments use bounded, masked byte loads for every spelling. [Compiler baseline](https://github.com/buster14a/buster/tree/0a2c3034cf6093cda0f461e519ceb04484739259) · [Issue #3446](https://github.com/buster14a/buster/issues/3446)

| Input | Classifications | Count beyond 64 bytes | Spelling lengths |
| --- | ---: | ---: | --- |
| sqlite | 0 | 0 | — |
| lua | 0 | 0 | — |
| musl | 254 | 0 | 18–20 |
| fixture | 512 | 512 | 71–74 |

The 9700X gate covers ten spelling shapes at 117 lengths. At each shape and length the harness compares all 16 flag/width combinations and 32 pointer offsets against the baseline. The four timed policies each use 11 alternating samples per executable, repeated in three processes. The table counts size/shape medians that matched or beat the baseline. The four short columns have 650 cells apiece. The combined long column includes 2,080 cells.

| Candidate | Short, no work | Short, splice | Short, rounding | Short, both | All long policies |
| --- | ---: | ---: | ---: | ---: | ---: |
| Bounded blocks | 650/650 | 0/650 | 125/650 | 190/650 | 2080/2080 |
| Separate long helper | 638/650 | 63/650 | 648/650 | 127/650 | 2080/2080 |
| Unified scan | 650/650 | 133/650 | 419/650 | 316/650 | 2080/2080 |
| Separate markers | 650/650 | 530/650 | 387/650 | 229/650 | 2080/2080 |
| First block and continuation | 650/650 | 637/650 | 308/650 | 322/650 | 2080/2080 |
| Specialized first block | 650/650 | 649/650 | 569/650 | 375/650 | 1861/2080 |

The bounded-block implementation passed 50 aggregate assertions under ASan and UBSan, covering the frozen matrix and protected-page tails. Eight independent mutations were detected, including late exponents, radix and separator handling, rounding cutoffs, splice priority and an unmasked tail. The compiler's checker suite passed 838,221 checks before the final cutoff assertions. The short-size losses keep the replacement under investigation. [Candidate implementations, native timings, fixture and mutation evidence](long-table-numbers.tar.xz)
