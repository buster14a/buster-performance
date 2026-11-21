# Independent baselines for the opt-in void-literal discard

The discard candidate used a median 2.97794 fewer user-plus-kernel cycles per preprocessed token than ordinary main; each of seven paired rounds had fewer cycles. It retired a median 16,549,559 fewer user instructions. The median wall difference was −0.1175 ms and the range spanned zero. These measurements reuse the exact binaries identified in the [immediate-parent record](../README.md) and preceding [returns](../../d1779cd3f/README.md) and [reads](../../227853575/README.md) records.

| Stable binary and mode | Cycles/token | User instructions | Wall ms |
| --- | ---: | ---: | ---: |
| bd35904be, ordinary main | 931.53390 | 1,343,997,358 | 120.7215 |
| d1779cd3f, opt-in returns (A) | 929.93249 | 1,340,657,772.5 | 120.7795 |
| 227853575, opt-in local reads | 930.75761 | 1,340,753,051 | 121.0705 |
| 4d0bba342, opt-in through discards | 928.12698 | 1,327,447,787 | 120.6520 |
| d1779cd3f, same path and binary (A′) | 929.98409 | 1,340,657,784.5 | 120.8595 |

| Paired candidate minus comparator | Cycles/token, median [min, max] | Wall ms, median [min, max] |
| --- | ---: | ---: |
| Discards minus ordinary main | −2.97794 [−6.56839, −0.92624] | −0.1175 [−5.9980, +0.4460] |
| Discards minus returns A | −1.57161 [−24.64846, −0.72129] | −0.0485 [−4.6830, +0.1740] |
| Discards minus returns A′ | −2.64202 [−8.48671, +1.05449] | −0.2075 [−4.3295, +0.5150] |
| Discards minus both returns positions combined | −2.35685 [−11.79698, −1.66639] | −0.1675 [−4.5063, +0.2818] |
| Discards minus reads | −2.62813 [−7.69399, +0.01845] | −0.5190 [−0.9440, −0.0385] |
| A′ minus A (identical executable and flags) | +0.19345 [−25.70295, +7.67532] | −0.0050 [−0.5545, +0.4405] |

All 70 PMU and 70 elapsed-time processes used CPU 2 under the global 9700X lock. The five labels appear once in the first half of each round, then again in reverse order. The first-half rotation and direction change across rounds. A and A′ both call the same on-disk d1779cd3f executable with `--node-window`; the other opt-in labels use the same flag. PMU and wall ran as independent series with the frozen SQLite arguments. Wall readings use one warm-up per measured child. The warm-ups and timed children exited zero and every resulting object was nonempty. Each earlier feature-specific campaign checked the exact object hash.

The PMU samples had 5,656–5,671 page faults. Elapsed samples had 5,764–5,820 child minor faults. All were in the low-fault band observed in the [policy control experiments](../../../switch-selector-2850-2026-11-21/9700x/). Per-mapping huge-page state was not observed. Ordinary main took 132.225 ms once in round 7 (5,820 faults), and returns A reached 976.76169 cycles/token in round 6 (5,669 faults). These outliers show substantial variability even within the low-fault observations. The ranges and A/A controls retain them.

[Exact order](order.tsv) · [Timing and fault rows](samples.tsv) · [Original perf and child-time reports](measurements.tar.xz) · [Launch sequence](cumulative.sh) · [Per-process commands](cumulative-one.sh)
