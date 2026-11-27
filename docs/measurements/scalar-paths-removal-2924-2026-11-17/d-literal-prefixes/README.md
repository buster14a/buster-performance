# Preprocessor literal prefixes in old C language modes

Before C11 the preprocessor splits u, U and u8 prefixed literals into an identifier and an ordinary literal. C11 and C17 still split u8 character constants. The original code counts matches by token kind, then walks backwards to expand in place. The two source byte positions on the splice before a quote can differ. The checks compare both positions, the start-of-line flag and the token kind. [Compiler baseline](https://github.com/buster14a/buster/tree/2e4400b66b351a989625acbcb80ba079cbb31310) · [Issue #3439](https://github.com/buster14a/buster/issues/3439)

| Input | Scans | Tokens examined | Splits | Unknown tokens | Splits from unknown |
| --- | ---: | ---: | ---: | ---: | ---: |
| lua | 3,101 | 1,551,479 | 0 | 0 | 0 |
| sqlite | 232 | 1,234,862 | 0 | 0 | 0 |
| musl | 23,153 | 16,498,273 | 0 | 0 | 0 |
| suite | 251,923 | 55,507,766 | 13,265 | 54,665 | 161 |
| fixture | 2 | 1,820 | 8 | 3 | 3 |

The application inputs paid for the scan without splitting a token. The full preprocessor suite and the small fixture reached both kinds of split. The table below covers three locked 9700X Release measurements at each size from zero to 66 and five positions centered on 128, 256, 512 and 1,024. The two old-language policies were timed. The oracle checks protected input ends, output canaries and fixed token columns, including old-mode splices.

| Candidate | Sizes and policies at parity or faster | Median candidate / baseline | Worst ratio |
| --- | ---: | ---: | ---: |
| Block search | 128/1,740 | 4.308 | 25.676 |
| Contiguous spelling | 262/1,914 | 1.869 | 18.074 |
| Eight token pairs | 202/1,914 | 2.035 | 19.890 |

The first attempt finds marked token blocks and moves each unmarked span. The second recognizes a physically contiguous prefix before scanning a spliced spelling. The third gathers up to eight spellings and compresses the resulting identifier and literal pairs into all three token columns. The bounds oracle passed 20,880 comparisons on the original ten shapes and 22,968 on the eleven-shape follow-ups. All three retained measured losses. [Drivers, implementations, raw timings and checks](prefix-expansion.tar.xz)

## Emitting old-language tokens in the lexer

These candidates remove the full prefix-count and backward-expansion passes. The lexer keeps the identifier and quote positions separate when the selected C language version excludes a prefix. The second candidate also emits the identifier immediately when an unusual spelling takes the existing slow path. Both passed 31,320 guarded comparisons across 15 spelling shapes, three language policies and eight source alignments. Both passed all 419 preprocessor fixtures and the 4,795-child Clang suite.

| Implementation | Cells at parity or faster | Median candidate / baseline | Worst ratio |
| --- | ---: | ---: | ---: |
| Language-aware vector masks | 1,368/2,610 | 1.000 | 1.589 |
| Direct emission for unusual spellings | 1,832/2,610 | 0.945 | 1.147 |

The timed cells cover two old-language policies and 87 sizes, with three independent locked measurements per cell. The second implementation also ran through four complete preprocessing commands. Values below give the median paired change in user cycles over five interleaved rounds of six processes per build. Output and diagnostics matched in each comparison.

| Old-mode fixture | Lua | SQLite | musl |
| ---: | ---: | ---: | ---: |
| -1.350% | +0.078% | -0.112% | -0.418% |

Both versions still lose on individual sizes. [Patches, drivers, results and test receipts](producer-prefixes.tar.xz)
