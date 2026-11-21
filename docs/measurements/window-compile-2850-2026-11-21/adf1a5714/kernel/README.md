# Four-stage frozen SQLite lexer kernel

Each independent process ran 21 built-in interleaved kernel passes over the same 9,507,037 source bytes and 1,166,437 raw tokens. Every vectorized token stream equalled the scalar reference. The 7 rotated symmetric rounds included two fresh processes per source per round, giving 56 total. The paired figures compare the mean of the two native process medians in each round.

| Lexer | Comparison | Metric | Paired median | Paired range | Rounds below zero |
| --- | --- | --- | ---: | ---: | ---: |
| `c_tokenize` | lookahead minus baseline | cycles/byte | -0.0085 | [-0.0355, +0.0015] | 6/7 |
| `c_tokenize` | lookahead minus baseline | instructions/byte | -0.0330 | [-0.0330, -0.0330] | 7/7 |
| `c_tokenize` | lookahead minus baseline | kernel wall ms | -0.0140 | [-0.0605, +0.0030] | 6/7 |
| `c_tokenize` | carried minus lookahead | cycles/byte | +0.0015 | [-0.0045, +0.0110] | 3/7 |
| `c_tokenize` | carried minus lookahead | instructions/byte | -0.0100 | [-0.0100, -0.0100] | 7/7 |
| `c_tokenize` | carried minus lookahead | kernel wall ms | +0.0025 | [-0.0070, +0.0185] | 3/7 |
| `c_tokenize` | writer minus carried | cycles/byte | -0.0310 | [-0.0375, -0.0170] | 7/7 |
| `c_tokenize` | writer minus carried | instructions/byte | -0.2010 | [-0.2010, -0.2010] | 7/7 |
| `c_tokenize` | writer minus carried | kernel wall ms | -0.0535 | [-0.0650, -0.0315] | 7/7 |
| `c_tokenize` | writer minus baseline | cycles/byte | -0.0430 | [-0.0610, -0.0195] | 7/7 |
| `c_tokenize` | writer minus baseline | instructions/byte | -0.2440 | [-0.2440, -0.2440] | 7/7 |
| `c_tokenize` | writer minus baseline | kernel wall ms | -0.0730 | [-0.1040, -0.0335] | 7/7 |
| `c_tokenize_scalar` | lookahead minus baseline | cycles/byte | +0.0255 | [+0.0135, +0.0385] | 0/7 |
| `c_tokenize_scalar` | lookahead minus baseline | instructions/byte | +0.0000 | [+0.0000, +0.0000] | 0/7 |
| `c_tokenize_scalar` | lookahead minus baseline | kernel wall ms | +0.0470 | [+0.0240, +0.0645] | 0/7 |
| `c_tokenize_scalar` | carried minus lookahead | cycles/byte | +0.0915 | [+0.0390, +0.1955] | 0/7 |
| `c_tokenize_scalar` | carried minus lookahead | instructions/byte | +0.0000 | [+0.0000, +0.0000] | 0/7 |
| `c_tokenize_scalar` | carried minus lookahead | kernel wall ms | +0.1525 | [+0.0735, +0.3380] | 0/7 |
| `c_tokenize_scalar` | writer minus carried | cycles/byte | -0.1010 | [-0.2030, -0.0685] | 7/7 |
| `c_tokenize_scalar` | writer minus carried | instructions/byte | +0.0000 | [+0.0000, +0.0000] | 0/7 |
| `c_tokenize_scalar` | writer minus carried | kernel wall ms | -0.1725 | [-0.3560, -0.1085] | 7/7 |
| `c_tokenize_scalar` | writer minus baseline | cycles/byte | +0.0090 | [+0.0000, +0.0180] | 0/7 |
| `c_tokenize_scalar` | writer minus baseline | instructions/byte | +0.0000 | [+0.0000, +0.0000] | 0/7 |
| `c_tokenize_scalar` | writer minus baseline | kernel wall ms | +0.0130 | [+0.0005, +0.0335] | 0/7 |

[Per-process medians](samples.tsv), [paired differences](paired.tsv), [raw reports](reports.tar.xz), [execution order](order.tsv) and [full commands](lex-aggregate-kernel.sh) identify the runs.
