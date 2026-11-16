| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **38.16** | **12.19** | **0.06** | **0.16** |
| … the columns' room and the labels | 18.47 | 6.22 | 0.03 | 0.07 |
| … the values' predicates (P0) | 13.65 | 3.62 | 0.02 | 0.06 |
| … the depths (P4) | 6.04 | 2.35 | 0.02 | 0.03 |
| **the selection** | **86.81** | **36.51** | **0.26** | **0.49** |
| … fusion (P1 to P3) | 20.52 | 7.70 | 0.06 | 0.13 |
| … the templates' words (selection's gather) | 21.25 | 11.30 | 0.07 | 0.25 |
| … measuring: the homes' case, lengths, positions | 21.49 | 9.19 | 0.08 | 0.03 |
| … measuring: a deferred entry's records counted | 9.27 | 4.29 | 0.04 | 0.02 |
| … the immediates' forms: the requests chosen | 4.11 | 1.43 | 0.02 | 0.03 |
| … the immediates' forms: applied to the records | 10.16 | 2.61 | 0.01 | 0.03 |
| **the homes and the frame** | **29.93** | **12.57** | **0.11** | **0.04** |
| … the references' count | 5.79 | 2.51 | 0.02 | 0.01 |
| … the homes | 6.65 | 3.07 | 0.04 | 0.01 |
| … the frame's layout | 7.76 | 3.45 | 0.03 | 0.00 |
| … the prologue and the epilogue | 9.73 | 3.55 | 0.02 | 0.02 |
| **the records' emission** | **111.67** | **36.76** | **0.34** | **0.31** |
| … expansion: hole blocks, a permute and a store an entry | 41.42 | 13.59 | 0.09 | 0.21 |
| … the deferred entries' records (calls, division, copies) | 17.95 | 6.59 | 0.06 | 0.06 |
| … the output's arrays and the code's close | 9.09 | 3.34 | 0.02 | 0.01 |
| … the x87 values' transfers (long double) | 43.21 | 13.24 | 0.17 | 0.03 |
| **the encoder** | **-0.09** | **0.00** | **0.00** | **0.00** |
| **branch sizing** | **0.03** | **0.05** | **-0.00** | **-0.00** |
| … the branch columns' check | 0.01 | -0.02 | -0.00 | -0.00 |
| … the records' lengths (x86_measure) | 0.07 | -0.03 | -0.00 | -0.00 |
| … size_branches | -0.05 | 0.10 | -0.00 | -0.00 |
| **the atoms and relocations** | **0.21** | **-0.23** | **-0.00** | **-0.00** |
| … the symbols and their names | 0.22 | -0.26 | 0.00 | -0.00 |
| … the atoms and their fixups | -0.01 | 0.02 | -0.00 | -0.00 |
| **the unwind table** | **-0.00** | **0.01** | **-0.00** | **-0.00** |
| **the emission's driver** | **0.00** | **-0.24** | **-0.00** | **-0.00** |
| … the bodies' loop, the windows, what the merge keeps | -0.14 | -0.06 | -0.00 | -0.00 |
| … the inline callees' table (check_tier1_inline_table) | 0.01 | -0.00 | -0.00 | 0.00 |
| … the inline asm's bodies (the assembler) | 0.13 | -0.18 | -0.00 | -0.00 |
| **the static data's atoms** | **0.00** | **0.00** | **0.00** | **0.00** |
| **Tier 0's validation (the lowering's check, in `lower`)** | **-43.98** | **-15.90** | **-0.13** | **-0.22** |
| **the process** | **1.62** | **0.40** | **0.00** | **-0.03** |
| **libc, caller not in the stack** | **-0.19** | **-0.03** | **0.00** | **0.06** |
| … memset | -0.05 | 0.04 | -0.00 | 0.06 |
| … memmove and memcpy | -0.08 | -0.05 | -0.00 | 0.00 |
| … memcmp | 0.02 | 0.01 | -0.00 | 0.00 |
| … strings | -0.07 | -0.03 | 0.00 | 0.00 |
| **the lowering** | **-0.21** | **0.14** | **0.00** | **0.00** |
| **the front end** | **-2.26** | **0.07** | **-0.00** | **0.05** |
| … the preprocessor and the lexer | -0.75 | -0.03 | -0.00 | -0.00 |
| … the parser | -0.45 | 0.09 | 0.00 | 0.01 |
| … the checker | -0.97 | 0.02 | -0.00 | 0.04 |
| … the static data's plan (check_data_prepare) | -0.08 | 0.00 | 0.00 | 0.00 |
| **unmatched** | **-0.10** | **-0.01** | **-0.00** | **0.00** |
| **the row** | **266.72** | **97.62** | **0.77** | **1.00** |
| **the issue's eight parts** | **266.72** | **97.85** | **0.77** | **1.00** |
| **their share of the row, %** | **100.00** | **100.23** | **100.27** | **100.37** |
| **every sample** | **221.60** | **82.29** | **0.65** | **0.86** |
