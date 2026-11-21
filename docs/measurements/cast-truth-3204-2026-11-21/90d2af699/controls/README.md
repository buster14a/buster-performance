# Seven-round musl controls for the cast cost observation

The initial seven-round A-B-B-A reading of the Release pair produced a median **+1.77176** first-pass TSC ticks per swept context record (−4.39510 to +11.38406), above the no-increase target and +0.20 refutation threshold. The extra controls below used the same frozen input with 377,187 context records, CPU 2 and the same exclusive host lock. Every invocation passed its shadow checks.

| Order and binaries | Initial C loop, median [min, max] | Second C loop on the same chunk, median [min, max] |
| --- | ---: | ---: |
| A-A-A-A, distinct copies of the same #3213 executable, center minus outer | −0.20690 [−4.50348, +1.04368] | +0.02304 [−0.26204, +0.10777] |
| B-A-A-B, address-only candidate at outer positions, candidate minus #3213 | +0.10810 [−3.91216, +2.31312] | +0.08332 [−0.00811, +1.68966] |

The order reversal put the initial median below the refutation threshold, and the identical-binary control also showed differences on the scale of that threshold. The observed direction and magnitude of the initial read were sensitive to the experiment. The original T5 verdict remains recorded with its actual protocol. [Identical-binary reports](aa90.tar.xz) and [reversed-order reports](ba90.tar.xz).
