# Fresh full preprocessing without the text printer

Each external process opened 21 fresh preprocessing passes on SQLite with the frozen include paths and definitions. The built-in vectorized implementation read its inputs, interned fresh tokens, refined input, processed includes and directives, and produced 716,157 output tokens from 1,234,862 input tokens. The reported counters cover the preprocessor implementation; the external driver separately measures the complete `-E -P` or `-c` command. Each of three independent rounds used both builds twice in alternating symmetric order.

| Metric | Paired median | Range | Rounds below zero |
| --- | ---: | ---: | ---: |
| total ms | -0.0550 | [-0.0650, -0.0170] | 3/3 |
| cycles/input token | -0.2700 | [-0.4300, -0.0550] | 3/3 |
| cycles/output token | -0.4700 | [-0.7350, -0.1000] | 3/3 |
| instructions/input token | -2.2300 | [-2.2300, -2.2300] | 3/3 |
| read ms | -0.0020 | [-0.0040, -0.0010] | 3/3 |
| lex ms | -0.0815 | [-0.0855, -0.0635] | 3/3 |
| refine ms | +0.0075 | [+0.0040, +0.0195] | 0/3 |
| directives ms | +0.0025 | [-0.0015, +0.0035] | 1/3 |
| main loop/setup ms | +0.0085 | [-0.0115, +0.0455] | 1/3 |

[Full commands](lexer-aggregate-pp.sh), [order](order.tsv), [individual medians](samples.tsv), [paired differences](paired.tsv) and [raw reports](reports.tar.xz).
