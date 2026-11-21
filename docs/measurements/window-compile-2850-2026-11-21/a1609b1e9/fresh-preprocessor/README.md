# Fresh full preprocessing without the text printer

Each external process opened 21 fresh preprocessing passes on SQLite with the frozen include paths and definitions. The built-in vectorized implementation read its inputs, interned fresh tokens, refined input, processed includes and directives, and produced 716,157 output tokens from 1,234,862 input tokens. The reported counters cover the preprocessor implementation; the external driver separately measures the complete `-E -P` or `-c` command. Each of three independent rounds used both builds twice in alternating symmetric order.

| Metric | Paired median | Range | Rounds below zero |
| --- | ---: | ---: | ---: |
| total ms | -0.1450 | [-0.1705, -0.0800] | 3/3 |
| cycles/input token | -0.5900 | [-0.8050, -0.3400] | 3/3 |
| cycles/output token | -1.0250 | [-1.3800, -0.5900] | 3/3 |
| instructions/input token | -2.2300 | [-2.2300, -2.2300] | 3/3 |
| read ms | +0.0040 | [+0.0015, +0.0055] | 0/3 |
| lex ms | -0.1470 | [-0.1480, -0.1305] | 3/3 |
| refine ms | +0.0160 | [-0.0040, +0.0330] | 1/3 |
| directives ms | -0.0010 | [-0.0020, +0.0025] | 2/3 |
| main loop/setup ms | +0.0060 | [-0.0280, +0.0530] | 1/3 |

[Full commands](lexer-replay-pp.sh), [order](order.tsv), [individual medians](samples.tsv), [paired differences](paired.tsv) and [raw reports](reports.tar.xz).
