# SQLite pp direct comparisons

Three independent external rounds each ran two fresh processes per source. Each native process returned the medians of 21 internal benchmark passes. The comparisons use the two observations per mode per round.

| Mode comparison | Implementation | Metric | Median | Range | Rounds below zero |
| --- | --- | --- | ---: | ---: | ---: |
| aggregate minus baseline | `preprocessor` | ms | -0.1275 | [-0.1355, -0.1195] | 3/3 |
| aggregate minus baseline | `preprocessor` | cycles/input token | -0.5750 | [-0.5900, -0.5300] | 3/3 |
| aggregate minus baseline | `preprocessor` | instructions/input token | -2.2300 | [-2.2300, -2.2300] | 3/3 |
| lean minus baseline | `preprocessor` | ms | -0.1865 | [-0.2095, -0.1850] | 3/3 |
| lean minus baseline | `preprocessor` | cycles/input token | -0.7750 | [-0.8500, -0.7500] | 3/3 |
| lean minus baseline | `preprocessor` | instructions/input token | -2.1800 | [-2.1800, -2.1800] | 3/3 |
| lean minus aggregate | `preprocessor` | ms | -0.0655 | [-0.0740, -0.0590] | 3/3 |
| lean minus aggregate | `preprocessor` | cycles/input token | -0.1850 | [-0.3200, -0.1750] | 3/3 |
| lean minus aggregate | `preprocessor` | instructions/input token | +0.0500 | [+0.0500, +0.0500] | 0/3 |

[Execution order](order.tsv), [individual observations](samples.tsv), [paired differences](paired.tsv), [raw driver reports](reports.tar.xz) and [invocation](lexer-lean-subsystems.sh) identify the experiment.
