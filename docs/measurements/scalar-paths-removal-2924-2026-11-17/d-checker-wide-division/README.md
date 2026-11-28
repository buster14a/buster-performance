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

## Baseline and wide quotient digits in balanced whole compilations

In each of eight rounds, two baseline labels and two candidate labels each ran four fresh compilations. The launch order rotated. The candidate column is the median ratio of the two candidate cycle counts combined to the two baseline counts combined. The last two columns compare the paired labels of the same executable and show variation within this experiment.

| Tier | Corpus | Candidate user cycles | Rounds meeting baseline | Baseline label 2 vs. 1 | Candidate label 2 vs. 1 |
| --- | --- | ---: | ---: | ---: | ---: |
| tier0 | lua | -0.008% | 4/8 | -0.063% | -0.104% |
| tier0 | sqlite | -0.337% | 7/8 | -0.034% | -0.163% |
| tier0 | musl | -0.190% | 6/8 | -0.041% | -0.147% |
| tier1 | lua | +0.053% | 0/8 | -0.049% | -0.018% |
| tier1 | sqlite | -0.006% | 4/8 | -0.063% | +0.048% |
| tier1 | musl | +0.140% | 1/8 | +0.045% | +0.122% |

The candidate median met baseline in 4 of the six configurations. All 48 process groups finished successfully.

[Round medians, complete process records and runner](wide-digits-balanced.tar.xz)

## Wide division with a cold, non-inlined entry

Placing the divider among the compiler's cold functions changes code generation and placement. On the native 9700X, its small-width candidate/baseline ratio met the original bit-at-a-time divider in 473/473 legal size/shape combinations through 129 limbs. The median ratio was 0.0266 and the slowest was 0.9365. At 37 larger widths through 131,072 limbs, all 407 measured ratios or conservative upper bounds were at or below 0.5886. GMP checked quotient and remainder. Of these cells, 200 had exact baseline timings throughout and 207 had baseline timeouts throughout. The timer interrupted 1,353 baseline batches.

The guarded arithmetic oracle checked 11,162 cases and rejected all nine injected faults. The native checker passed 838,223 checks. Clang agreed on all 100 exported values at each compiler tier and rejected the three erroneous expressions. The new and original compilers emitted identical diagnostics on the erroneous inputs.

The seven-way independent comparison found lower median cycles on all three Tier 1 corpora and on Tier 0 musl. Tier 0 Lua and SQLite still took 0.052% and 0.084% more user cycles than the mean of the two parent executables in the same rounds. [Independent rebuild controls and whole-compiler measurements](../whole-compile-rebuild/README.md)

[Arithmetic timings, sources, protected-memory faults, native checker and Clang receipts](cold-division-arithmetic.tar.xz)

## Compiler outputs and paired timings for the cold divider

The candidate and original emitted identical debug objects, standard output and diagnostics for each workload at each tier. The cycle changes are median paired ratios over five rounds. Each executable ran three fresh one-lane compilations per round. The positive fixture has eight wide folds and the heavy fixture has 48 quotient/remainder pairs.

| Workload | Objects per tier | Tier 0 compile | Tier 1 compile |
| --- | ---: | ---: | ---: |
| positive | 1 | -19.618% | -22.801% |
| heavy | 1 | -25.579% | -25.233% |
| lua | 34 | +0.005% | -0.180% |
| sqlite | 1 | +0.020% | -0.103% |
| musl | 1336 | -0.123% | -0.099% |

[Object and stream hashes, process samples and runner](cold-division-compiler-outputs.tar.xz)

## Cold wide division in balanced whole compilations

In each of eight rounds, two baseline labels and two candidate labels each ran four fresh compilations. The launch order rotated. The candidate column is the median ratio of the two candidate cycle counts combined to the two baseline counts combined. The last two columns compare the paired labels of the same executable and show variation within this experiment.

| Tier | Corpus | Candidate user cycles | Rounds meeting baseline | Baseline label 2 vs. 1 | Candidate label 2 vs. 1 |
| --- | --- | ---: | ---: | ---: | ---: |
| tier0 | lua | -0.102% | 7/8 | -0.107% | +0.013% |
| tier0 | sqlite | +0.216% | 2/8 | +0.153% | -0.139% |
| tier0 | musl | -0.173% | 8/8 | +0.036% | -0.046% |
| tier1 | lua | -0.094% | 8/8 | +0.043% | +0.067% |
| tier1 | sqlite | -0.055% | 7/8 | -0.009% | +0.029% |
| tier1 | musl | -0.112% | 7/8 | -0.035% | -0.015% |

The candidate median met baseline in 5 of the six configurations. All 48 process groups finished successfully.

[Round medians, complete process records and runner](cold-division-balanced.tar.xz)

## Reusing the materialized dividend for the second output

The caller reused the materialized dividend as its temporary quotient or remainder. This removed one arena allocation. Both sides of the small comparison included copying the same input limbs into writable storage before division. Each cell is the median paired ratio over three seeds. The two sizes below three limbs go through the ordinary narrow folder and are excluded.

| Layout | Cells meeting scalar | Median ratio | Slowest ratio |
| --- | ---: | ---: | ---: |
| Dividend becomes remainder | 456/473 | 0.0291 | 1.4191 |
| Dividend becomes quotient | 455/473 | 0.0294 | 1.4406 |
| Separate scratch input, current vector core | 455/473 | 0.0294 | 1.4307 |

GMP independently verified both outputs at each of 37 larger widths through 131,072 limbs, for eleven operand shapes in each orientation. As in the previous large sweep, an interrupted scalar batch supplies a conservative upper bound on the ratio.

| Caller operation | Cells meeting scalar | Slowest ratio or upper bound | Interrupted scalar batches |
| --- | ---: | ---: | ---: |
| quotient | 407/407 | 0.5888 | 1353 |
| remainder | 407/407 | 0.6023 | 1353 |

The native checker passed 838,227 checks. Clang agreed on 100 exported data values at each tier and rejected all three erroneous expressions. All 1,371 ordinary debug objects per tier and both explicit wide fixtures matched the parent, as did stdout and diagnostics. The table gives the median of five paired whole-compile cycle measurements.

| Workload | Objects | Tier 0 | Tier 1 |
| --- | ---: | ---: | ---: |
| positive | 1 | -20.056% | -6.366% |
| heavy | 1 | -25.343% | -24.237% |
| lua | 34 | +0.086% | +0.328% |
| sqlite | 1 | +0.080% | +0.134% |
| musl | 1336 | -0.073% | +0.315% |

[Production patch, arithmetic fixtures, GMP and compiler comparisons, hashes and process counters](wide-division-reused-dividend.tar.xz)

## Compare and divide on a writable dividend

The ordinary folder materializes its operands before starting division. Each routine in this comparison pays for a copy of the dividend into writable storage. The six alternatives reuse that storage for the remainder. All three seeds ran eleven operand distributions at each of 43 eligible widths, from 3 through 129 limbs. Each ratio divides candidate cycles by scalar cycles for the same seed and cell. The table summarizes the median across seeds for each cell.

| Routine | Cells meeting scalar | Median ratio | Slowest ratio |
| --- | ---: | ---: | ---: |
| Forward comparison | 458/473 | 0.0291 | 1.4476 |
| Reverse comparison | 466/473 | 0.0296 | 1.2261 |
| Count both lengths during reverse comparison | 467/473 | 0.0294 | 1.2261 |
| Clear quotient during comparison | 466/473 | 0.0283 | 1.3198 |
| Outline normalized quotient estimation | 466/473 | 0.0283 | 1.3164 |
| Keep the comparison entry hot | 466/473 | 0.0283 | 1.3164 |

[Compiler flags, implementations, checked driver, raw cycle counts and summary script](wide-division-in-place-comparison.tar.xz)
