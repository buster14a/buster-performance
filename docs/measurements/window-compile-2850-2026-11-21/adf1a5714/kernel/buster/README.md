# buster raw lexer sensitivity

Each of 12 fresh processes validated the vectorized result against the scalar tokens across 1 source files, 997,054 bytes and 124,250 raw tokens. The built-in driver timed 21 internal interleaved passes. Three symmetric external rounds compare 232da75f9 with adf1a5714.

| Implementation | Metric | Paired median | Range | Rounds below zero |
| --- | --- | ---: | ---: | ---: |
| `c_tokenize` | cycles/byte | -0.0195 | [-0.0200, -0.0115] | 3/3 |
| `c_tokenize` | instructions/byte | -0.0930 | [-0.0930, -0.0930] | 3/3 |
| `c_tokenize` | kernel wall ms | -0.0030 | [-0.0035, -0.0015] | 3/3 |
| `c_tokenize_scalar` | cycles/byte | +0.0555 | [+0.0340, +0.1685] | 0/3 |
| `c_tokenize_scalar` | instructions/byte | +0.0000 | [+0.0000, +0.0000] | 0/3 |
| `c_tokenize_scalar` | kernel wall ms | +0.0125 | [+0.0070, +0.0285] | 0/3 |

[Per-process medians](samples.tsv), [order](order.tsv), [raw reports](reports.tar.xz) and [command](lexer-kernel-sensitive.sh) reproduce the table.
