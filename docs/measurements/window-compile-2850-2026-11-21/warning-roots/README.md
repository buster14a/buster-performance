# Ordinary warning-root enumeration and excluded literal subtrees

All three builds compiled frozen SQLite and the Buster compiler. Each run used one complete fresh compiler process pinned to the same Ryzen 7 9700X core.

| Whole input | Comparison | Total cycles/token | Total instructions | True elapsed ms |
| --- | --- | ---: | ---: | ---: |
| [sqlite](sqlite/README.md) | roots minus baseline | −0.4308 [−1.0851, +0.9734] | −2,614,944.0 [−2,799,984.5, −2,581,336.5] | +0.5080 [−0.2390, +0.7200] |
| [sqlite](sqlite/README.md) | excluded minus roots | −1.6786 [−1.8846, +2.4765] | +219,624.0 [−357,346.5, +507,312.5] | −0.0855 [−0.9825, +0.0240] |
| [sqlite](sqlite/README.md) | excluded minus baseline | −0.9112 [−2.1094, +1.3914] | −2,361,712.5 [−2,972,290.5, −2,292,672.0] | −0.2150 [−0.4745, +0.6345] |
| [main](main/README.md) | roots minus baseline | +3.1176 [−9.7006, +4.9551] | −16,361,193.5 [−16,521,922.5, −16,074,900.5] | −1.6290 [−2.5965, +0.4080] |
| [main](main/README.md) | excluded minus roots | +1.1967 [−14.9383, +3.6043] | −49,452,939.0 [−50,044,440.0, −43,879,372.5] | −5.5410 [−6.9085, −1.6675] |
| [main](main/README.md) | excluded minus baseline | −8.5039 [−11.8206, +8.5594] | −65,974,861.5 [−66,119,340.5, −60,240,566.0] | −6.5005 [−8.1375, −3.2965] |

The [warning-root patch](warnrootd2e.patch) and [combined patch](warnrootf40.patch) apply to the same public parent 9be958d5c. Each input has its own raw hardware reports, build receipts, warning checks and complete object receipts.

The [literal-warning qualification](f40a398f2/README.md) covers every warning byte on both larger source inputs. All three Buster builds share the documented [pre-existing missing diagnostics](clang-coverage/README.md) on choose-expression and generic-selection initializers. The [initial root selection qualification](../d2e78d10e/correctness/README.md) and [independent two-arm timing](../d2e78d10e/README.md) cover the earlier step.
