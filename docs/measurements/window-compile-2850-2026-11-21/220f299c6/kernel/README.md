# Frozen SQLite lexer kernel

Each of 28 fresh processes ran the production `benchmark-lexer` driver over the same 9,507,037 bytes of SQLite source (SHA-256 `0a409f1633283fa31a9126b11fbfd64a1991c5d30defad07e5745d4667f5e23d`). Every process confirmed identical vectorized and scalar token streams and reported 21 interleaved passes over 1,166,437 raw lexer tokens. The built-in driver reports kernel-only wall, cycles and instructions per input byte. Each process provides one median for each implementation. Seven external paired rounds alternated ABBA and BAAB order across two stock Release builds.

| Implementation | Metric | Paired median | Paired range | Rounds below zero |
| --- | --- | ---: | ---: | ---: |
| `c_tokenize` | cycles/byte | -0.0110 | [-0.0295, -0.0060] | 7/7 |
| `c_tokenize` | instructions/byte | -0.0330 | [-0.0330, -0.0330] | 7/7 |
| `c_tokenize` | wall ms | -0.0180 | [-0.0500, -0.0080] | 7/7 |
| `c_tokenize_scalar` | cycles/byte | +0.0285 | [-0.0200, +0.0775] | 3/7 |
| `c_tokenize_scalar` | instructions/byte | +0.0000 | [+0.0000, +0.0000] | 0/7 |
| `c_tokenize_scalar` | wall ms | +0.0535 | [-0.0310, +0.1325] | 3/7 |

The scalar control uses the same corpus and driver. [Per-process measurements](samples.tsv), [differences by round](paired.tsv), [raw tool reports](reports.tar.xz), [execution order](order.tsv) and the [exact invocation](lexer-kernel.sh) are included.
