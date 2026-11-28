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

## Exported constants and diagnostic checks

Both native compiler tiers emitted the same values as Clang for all 100 exported integers. The ELF check reads the named objects and compares the bits in their declared C widths. The smaller input exports four signed and unsigned quotient or remainder values. The larger input exports 96 values at 769 bits. The baseline, candidate and Clang also rejected constant division by zero, remainder by zero and signed division of the minimum value by −1. The baseline and candidate diagnostics matched byte for byte. [Inputs, ELF objects, comparison program and diagnostics](clang-exported-results.tar.xz)

## Operand sizes through the language maximum

GMP independently checked the quotient and remainder for all 407 inputs. The native sweep covered 37 limb counts from 130 through 131,072 (8,388,608 bits) and eleven operand distributions per count. On the Ryzen 7 9700X, the candidate met or beat the old division in 407 of 407 comparisons. The slowest median candidate/baseline ratio or upper bound was 0.5906.

Both calls used a monotonic wall clock under the host lock on core 2. Every measured candidate call completed. A baseline batch exceeding the input-specific time budget contributed a conservative lower bound on its time, recorded as a negative value in the raw file. The ratio for such a round is therefore an upper bound. Of the 407 cells, 196 had only complete baseline timings, 4 had both complete timings and bounds, and 207 had only bounds. The budget was 8 ms plus 2.5 candidate pilot durations. The bound deducts a further 50 microseconds. There were 1,358 interrupted baseline rounds among 2,753 measured rounds.

[All round timings, per-size ratios, GMP checks and reproduction source](large-gmp-timings.tar.xz)

## Object compilation in both tiers

All 1,371 ordinary `-g -c` objects matched the baseline byte for byte in each tier. The two wide-integer fixtures also produced identical objects. Standard output and standard error were checked independently for each workload. A timing round took the median of three fresh invocations of each build. The cycle column is the median of five paired round ratios.

| Tier | Source | Matching objects | User cycles versus baseline |
| --- | --- | ---: | ---: |
| tier0 | Eight folds | 1 | -18.638% |
| tier0 | 48 pairs | 1 | -25.106% |
| tier0 | Lua | 34 | -0.151% |
| tier0 | SQLite | 1 | -0.416% |
| tier0 | musl | 1,336 | -0.085% |
| tier1 | Eight folds | 1 | -23.305% |
| tier1 | 48 pairs | 1 | -25.181% |
| tier1 | Lua | 34 | +0.070% |
| tier1 | SQLite | 1 | -0.017% |
| tier1 | musl | 1,336 | -0.024% |

[Per-object hashes, both streams, process timings and runner](both-tier-compilations.tar.xz)
