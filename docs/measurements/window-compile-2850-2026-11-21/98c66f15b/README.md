# Skipping inactive binding-usage diagnostics on frozen SQLite

Skipping inactive binding-usage diagnostics on default SQLite compilation saved 1.741 ms and 11.82 total cycles per preprocessed token at the paired median. All seven independent wall pairs and every PMU pair favored the candidate. The compiler retired 17.84 million fewer user instructions per translation unit and reduced process faults by a median of 29 in the PMU series.

The [five warning-policy controls](warning-controls.tsv) compare complete status, object presence, object bytes and diagnostics. Both compilers rejected `-Wall -Wextra -Werror` with the same 3,771 diagnostic bytes and no object. Default, `-Wall -Wextra`, `-Werror` and `-Werror=unused-variable` succeeded with identical objects and output. The [original diagnostic texts](warning-reports.tar.xz), [full user and kernel differences](paired-summary.tsv) and [exact source patch](source.patch) accompany the measurements.

Under the default option set, none of the binding-usage diagnostics can be emitted. The candidate skips the corresponding per-translation-unit analysis when artifacts are requested and the diagnostics are inactive. Both modes compile the complete frozen SQLite source through ordinary `-c`. The baseline is f0a204a9c and the candidate is 98c66f15b.

| Mode | Median cycles/token | Median user instructions | Median wall ms |
| --- | ---: | ---: | ---: |
| baseline | 937.8674 | 1,347,031,909.0 | 121.6070 |
| candidate | 925.8009 | 1,329,189,106.5 | 119.8860 |

| Paired difference | Cycles/token, median [min, max] | User instructions, median | Wall ms, median [min, max] |
| --- | ---: | ---: | ---: |
| candidate minus baseline | −11.8217 [−25.3960, −6.7530] | −17,842,803.5 | −1.7410 [−2.0840, −1.2295] |

PMU fault counts ranged from 5,662 to 5,695. The independent wall series recorded 5,769 to 5,802 minor faults and zero major faults.

The comparisons use two observations per mode in each rotated, symmetric round. The paired table takes the median of within-round differences between the two-position means. Cycles include user and kernel execution and use the frozen SQLite denominator of 716,136 preprocessed tokens. All PMU events ran at 100% enabled time.

Each of the 60 successful compiles yielded a 2,061,192-byte object with SHA-256 `efcbc038fe65fd93722230ce222f8d761948b9e59c491ca9ce4ec081cc4ce1aa`. Default diagnostics were empty. All `-Wall -Wextra` compilations had identical output, with 3,701 bytes on stderr.

| Modes | Source revision | Release executable SHA-256 |
| --- | --- | --- |
| baseline | `f0a204a9c335d6527979834e2d3bdd6af630c224` | `128c7c958386ed9b443ad33c220ad2b97888b8fe155d52ca79a19866283d333d` |
| candidate | `98c66f15b1dc3ab3aa5f5b3116fe3c9f7de0ac36` | `a389011a63e49d4bda1d94cb285aabbd8b9797dcaa6f110ca3448070f3c8e465` |

The [frozen driver method](../paired-driver/README.md), [mode selectors](unused-study-config.sh), [command and object checks](unused-study-one.sh), [native build receipts](builds.tsv), [full order](order.tsv), [PMU and wall records](samples.tsv), [original reports](reports.tar.xz), [object receipts](objects.tsv) and [warning receipts](diagnostics.tsv) identify the exact inputs, command lines and outputs.

The [complete correctness packet](correctness/README.md) includes 208,884 pinned-Clang driver checks, 210,487 focused checker checks, 59 same-image warning-policy comparisons and a 200-pair source/CLI differential.
