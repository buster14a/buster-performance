# SQLite lexer direct comparisons

Three independent external rounds each ran two fresh processes per source. Each native process returned the medians of 21 internal benchmark passes. The comparisons use the two observations per mode per round.

| Mode comparison | Implementation | Metric | Median | Range | Rounds below zero |
| --- | --- | --- | ---: | ---: | ---: |
| aggregate minus baseline | `c_tokenize` | ms | -0.0555 | [-0.0690, -0.0510] | 3/3 |
| aggregate minus baseline | `c_tokenize` | cycles/byte | -0.0320 | [-0.0400, -0.0295] | 3/3 |
| aggregate minus baseline | `c_tokenize` | instructions/byte | -0.2440 | [-0.2440, -0.2440] | 3/3 |
| aggregate minus baseline | `c_tokenize_scalar` | ms | +0.0660 | [+0.0385, +0.1445] | 0/3 |
| aggregate minus baseline | `c_tokenize_scalar` | cycles/byte | +0.0405 | [+0.0260, +0.0880] | 0/3 |
| aggregate minus baseline | `c_tokenize_scalar` | instructions/byte | +0.0000 | [+0.0000, +0.0000] | 0/3 |
| lean minus baseline | `c_tokenize` | ms | -0.0580 | [-0.0735, -0.0550] | 3/3 |
| lean minus baseline | `c_tokenize` | cycles/byte | -0.0340 | [-0.0425, -0.0320] | 3/3 |
| lean minus baseline | `c_tokenize` | instructions/byte | -0.2380 | [-0.2380, -0.2380] | 3/3 |
| lean minus baseline | `c_tokenize_scalar` | ms | +0.0150 | [-0.0465, +0.0585] | 1/3 |
| lean minus baseline | `c_tokenize_scalar` | cycles/byte | +0.0100 | [-0.0290, +0.0335] | 1/3 |
| lean minus baseline | `c_tokenize_scalar` | instructions/byte | +0.0000 | [+0.0000, +0.0000] | 0/3 |
| lean minus aggregate | `c_tokenize` | ms | -0.0040 | [-0.0045, -0.0025] | 3/3 |
| lean minus aggregate | `c_tokenize` | cycles/byte | -0.0025 | [-0.0025, -0.0020] | 3/3 |
| lean minus aggregate | `c_tokenize` | instructions/byte | +0.0060 | [+0.0060, +0.0060] | 0/3 |
| lean minus aggregate | `c_tokenize_scalar` | ms | -0.0860 | [-0.1125, -0.0235] | 3/3 |
| lean minus aggregate | `c_tokenize_scalar` | cycles/byte | -0.0545 | [-0.0695, -0.0160] | 3/3 |
| lean minus aggregate | `c_tokenize_scalar` | instructions/byte | +0.0000 | [+0.0000, +0.0000] | 0/3 |

[Execution order](order.tsv), [individual observations](samples.tsv), [paired differences](paired.tsv), [raw driver reports](reports.tar.xz) and [invocation](lexer-lean-subsystems.sh) identify the experiment.
