# Ordinary warning-root enumeration and excluded literal subtrees

All three builds compiled frozen SQLite and the Buster compiler. Each run used one complete fresh compiler process pinned to the same Ryzen 7 9700X core.

| Whole input | Comparison | Total cycles/token | Total instructions | True elapsed ms |
| --- | --- | ---: | ---: | ---: |
| [sqlite](sqlite/README.md) | roots minus baseline | −0.4308 [−3.7135, +4.1966] | −2,581,336.5 [−2,799,984.5, −2,152,966.5] | −0.1280 [−0.8515, +0.7200] |
| [sqlite](sqlite/README.md) | excluded minus roots | −1.6786 [−4.7380, +2.4765] | −77,840.5 [−468,876.5, +507,312.5] | −0.3515 [−0.9825, +0.0240] |
| [sqlite](sqlite/README.md) | excluded minus baseline | −0.9112 [−2.4263, +1.3914] | −2,574,149.0 [−2,972,290.5, −2,292,672.0] | −0.4945 [−0.8310, +0.6345] |
| [main](main/README.md) | roots minus baseline | −3.1190 [−9.7006, +6.5606] | −16,521,922.5 [−19,507,546.5, −16,074,900.5] | −2.5965 [−6.8190, +15.3300] |
| [main](main/README.md) | excluded minus roots | −10.6557 [−14.9383, +3.6043] | −49,608,570.5 [−50,119,852.5, −43,879,372.5] | −5.4225 [−11.3925, +2.4575] |
| [main](main/README.md) | excluded minus baseline | −10.1549 [−19.7748, +8.5594] | −66,119,340.5 [−68,792,034.5, −60,240,566.0] | −3.8650 [−12.2415, +3.9375] |

The [warning-root patch](warnrootd2e.patch) and [combined patch](warnrootf40.patch) apply to the same public parent 9be958d5c. Each input has its own raw hardware reports, build receipts, warning checks and complete object receipts.

The [literal-warning qualification](f40a398f2/README.md) covers every warning byte on both larger source inputs. All three Buster builds share the documented [pre-existing missing diagnostics](clang-coverage/README.md) on choose-expression and generic-selection initializers. The [initial root selection qualification](../d2e78d10e/correctness/README.md) and [independent two-arm timing](../d2e78d10e/README.md) cover the earlier step.

The [initial three rounds](https://github.com/buster14a/buster-performance/tree/b0ba4fe87a488868c261096cabb672524ba069fa/docs/measurements/window-compile-2850-2026-11-21/warning-roots) remain in the seven-round series. The extension preserves each original process measurement and every first-three paired difference.
