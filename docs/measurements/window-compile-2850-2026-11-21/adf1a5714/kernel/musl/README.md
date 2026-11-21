# musl raw lexer sensitivity

Each of 12 fresh processes validated the vectorized result against the scalar tokens across 1,606 source files, 2,079,106 bytes and 523,845 raw tokens. The built-in driver timed 21 internal interleaved passes. Three symmetric external rounds compare 232da75f9 with adf1a5714.

| Implementation | Metric | Paired median | Range | Rounds below zero |
| --- | --- | ---: | ---: | ---: |
| `c_tokenize` | cycles/byte | -0.0280 | [-0.0325, -0.0220] | 3/3 |
| `c_tokenize` | instructions/byte | -0.1990 | [-0.1990, -0.1990] | 3/3 |
| `c_tokenize` | kernel wall ms | -0.0105 | [-0.0125, -0.0085] | 3/3 |
| `c_tokenize_scalar` | cycles/byte | +0.1770 | [+0.1765, +0.2630] | 0/3 |
| `c_tokenize_scalar` | instructions/byte | +0.0000 | [+0.0000, +0.0000] | 0/3 |
| `c_tokenize_scalar` | kernel wall ms | +0.0675 | [+0.0655, +0.0950] | 0/3 |

[Per-process medians](samples.tsv), [order](order.tsv), [raw reports](reports.tar.xz) and [command](lexer-kernel-sensitive.sh) reproduce the table.
