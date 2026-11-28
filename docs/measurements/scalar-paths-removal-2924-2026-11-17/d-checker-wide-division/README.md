# Vector quotient digits for wide integer constant folding

The checker uses wide arithmetic for integer constants wider than 128 bits. The original division processed one dividend bit per iteration and scanned the full limb array to shift, compare or subtract. The candidate divides in base 2³², estimates each quotient digit from normalized leading digits, and subtracts eight partial products per vector. Masked tails protect short windows. A high estimate restores the divisor in vector groups of sixteen digits.

## Reach through compiler entry points

A shared-memory counter in the division recorded work from the checker and compiler workers. The ordinary Tier 1 object compilations found zero wide divisions in Lua, SQLite and musl. A positive source contains signed and unsigned 193- and 257-bit constants, static assertions, and exported quotient and remainder values.

| Entry | Divisions | Total 64-bit limbs | Divisors at most 64 bits | Maximum limbs |
| --- | ---: | ---: | ---: | ---: |
| Lua compilation | 0 | 0 | 0 | 0 |
| SQLite compilation | 0 | 0 | 0 | 0 |
| musl compilation | 0 | 0 | 0 | 0 |
| Positive compilation | 8 | 36 | 4 | 5 |
| Positive static data dump | 8 | 36 | 4 | 5 |
| Positive typed dump | 8 | 36 | 4 | 5 |

## Native size gate and independent answers

The integrated source met or beat the old division in 473/473 comparisons at legal limb counts 3–129 on the Ryzen 7 9700X. The median candidate/baseline ratio across those comparisons was 0.0288 and the slowest was 0.9464. The sweep measured all limb counts 3–33 and twelve additional boundaries, with eleven operand distributions. The raw records include 1–2 limbs as out-of-domain controls. Each observation used seven interleaved timings per seed and the table result uses the median of three seed ratios. All native measurements used Release flags on core 2 under the exclusive host lock.

Python arbitrary-precision division checked both results and verified that both inputs stayed unchanged. Independently protected start and end placements covered all four arrays. The integrated source passed 11,162 cases through 131,072 limbs, the 8,388,608-bit language maximum. The native checker passed 838,223 checks. The added checker unit tests construct dividend = quotient × divisor + remainder and explicitly exercise one- and two-step quotient corrections.

The guarded oracle rejected nine deliberate changes covering borrow propagation, carry propagation, the high product, top-digit borrow, a missing correction, normalization, chunk ordering, quotient position and a tail overread. The protected page caught the overread.

| Tier 0 complete compile | Median user cycles versus baseline |
| --- | ---: |
| Original positive, 8 folds | -18.638% |
| 48 pairs of 769-bit operands with exported results and independent static assertions | -25.106% |

Each compile comparison used five paired rounds of three complete invocations. Both source programs also produced identical static-data dumps with the baseline and candidate.

[Native measurements, sources, mutation results and guarded oracle](wide-division-native.tar.xz)
