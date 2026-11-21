# Seven-round musl controls for the cast cost observation

The initial seven-round A-B-B-A reading of the Release pair produced a median **+1.77176** first-pass TSC ticks per swept context record (−4.39510 to +11.38406), above the no-increase target and +0.20 refutation threshold. The extra controls below used the same frozen input with 377,187 context records, CPU 2 and the same exclusive host lock. Every invocation passed its shadow checks.

| Order and binaries | Initial C loop, median [min, max] | Second C loop on the same chunk, median [min, max] |
| --- | ---: | ---: |
| A-A-A-A, distinct copies of the same #3213 executable, center minus outer | −0.20690 [−4.50348, +1.04368] | +0.02304 [−0.26204, +0.10777] |
| B-A-A-B, address-only candidate at outer positions, candidate minus #3213 | +0.10810 [−3.91216, +2.31312] | +0.08332 [−0.00811, +1.68966] |

The order reversal put the initial median below the refutation threshold, and the identical-binary control also showed differences on the scale of that threshold. The observed direction and magnitude of the initial read were sensitive to the experiment. The original T5 verdict remains recorded with its actual protocol. [Identical-binary reports](aa90.tar.xz) and [reversed-order reports](ba90.tar.xz).

## Both C-loop functions in the same executable

A diagnostic build of the 90d2af699 implementation included the before and after C-loop functions and selected the one to call outside the timed interval. Each of seven rounds used a fresh executable copy shared by its four positions. Odd rounds used A-B-B-A and even rounds used B-A-A-B. All 28 musl checks exited zero. The candidate minus old loop had a median −0.11798 first-run ticks per context record (range −1.48964 to +5.69898) and +0.12891 on the repeat (−1.40853 to +0.42817). The large +1.77176 median from the original release pair did not reproduce under this control. The [separate 24c16e298 production comparison](../../24c16e298/README.md) has the qualification result for the adopted source.

The diagnostic patch applies to 0647d69ba8af4e466c89df2519dea0b382524d37 with SHA-256 37164166efc54fbd4e1a427a7c2d204981d2f7207e417c1e6f2d0874e4e47252. The diagnostic executable hashes to 5e4a21d5a633fe4f78ba725048f945e5debe455bf7bd91c9d47b73ae5821ed47. [Patch](same-image.patch) · [Launch script](same-image.sh) · [Individual reports](same-image.tar.xz)
