| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **-0.17** | **0.02** | **-0.00** | **-0.00** |
| … the columns' room and the labels | -0.25 | -0.08 | -0.00 | -0.00 |
| … the values' predicates (P0) | 0.08 | 0.07 | -0.00 | -0.00 |
| … the depths (P4) | 0.00 | 0.04 | 0.00 | 0.00 |
| **the selection** | **-0.04** | **0.07** | **0.00** | **-0.00** |
| … fusion (P1 to P3) | 0.23 | 0.10 | 0.00 | -0.00 |
| … the templates' words (selection's gather) | -0.08 | -0.06 | -0.00 | -0.00 |
| … measuring: the homes' case, lengths, positions | -0.04 | 0.02 | -0.00 | 0.00 |
| … measuring: a deferred entry's records counted | 0.00 | 0.01 | -0.00 | 0.00 |
| … the immediates' forms: the requests chosen | -0.13 | -0.01 | 0.00 | 0.00 |
| … the immediates' forms: applied to the records | -0.03 | 0.01 | 0.00 | -0.00 |
| **the homes and the frame** | **-0.31** | **0.16** | **0.00** | **0.00** |
| … the references' count | 0.03 | -0.05 | 0.00 | 0.00 |
| … the homes | -0.07 | 0.16 | 0.00 | -0.00 |
| … the frame's layout | -0.33 | -0.07 | 0.00 | 0.00 |
| … the prologue and the epilogue | 0.06 | 0.11 | -0.00 | 0.00 |
| **the records' emission** | **-0.21** | **-0.28** | **-0.00** | **-0.00** |
| … expansion: hole blocks, a permute and a store an entry | -0.24 | -0.09 | -0.00 | -0.00 |
| … the deferred entries' records (calls, division, copies) | -0.07 | -0.12 | -0.00 | -0.00 |
| … the output's arrays and the code's close | 0.10 | -0.08 | 0.00 | -0.00 |
| … the x87 values' transfers (long double) | 0.00 | 0.00 | 0.00 | 0.00 |
| **the encoder** | **16.73** | **4.54** | **0.00** | **0.08** |
| **branch sizing** | **13.92** | **6.32** | **0.00** | **0.11** |
| … the branch columns' check | -0.04 | 0.00 | -0.00 | -0.00 |
| … the records' lengths (x86_measure) | 9.79 | 4.16 | 0.00 | 0.08 |
| … size_branches | 4.17 | 2.16 | 0.00 | 0.03 |
| **the atoms and relocations** | **-0.11** | **0.07** | **0.00** | **0.00** |
| … the symbols and their names | -0.06 | 0.06 | -0.00 | 0.00 |
| … the atoms and their fixups | -0.05 | 0.01 | 0.00 | -0.00 |
| **the unwind table** | **-0.01** | **0.02** | **-0.00** | **0.00** |
| **the emission's driver** | **0.13** | **0.01** | **0.00** | **0.00** |
| … the bodies' loop, the windows, what the merge keeps | 0.11 | 0.02 | 0.00 | 0.00 |
| … the inline callees' table (check_tier1_inline_table) | 0.01 | 0.01 | -0.00 | 0.00 |
| … the inline asm's bodies (the assembler) | 0.02 | -0.02 | -0.00 | 0.00 |
| **Tier 0's validation (the lowering's check, in `lower`)** | **-42.67** | **-14.06** | **-0.05** | **-0.18** |
| **the process** | **0.75** | **1.32** | **0.00** | **0.25** |
| **libc, caller not in the stack** | **0.13** | **0.10** | **-0.00** | **0.03** |
| … memset | 0.03 | -0.05 | -0.00 | -0.02 |
| … memmove and memcpy | 0.08 | 0.16 | -0.00 | 0.04 |
| … memcmp | 0.00 | 0.01 | -0.00 | 0.00 |
| … strings | 0.02 | -0.02 | 0.00 | 0.00 |
| **the lowering** | **-0.03** | **-0.08** | **-0.00** | **-0.00** |
| **the front end** | **0.59** | **-0.02** | **-0.00** | **-0.00** |
| … the preprocessor and the lexer | 0.30 | -0.03 | -0.00 | 0.00 |
| … the parser | 0.03 | 0.18 | 0.00 | -0.00 |
| … the checker | 0.25 | -0.15 | -0.00 | -0.00 |
| … the static data's plan (check_data_prepare) | 0.01 | -0.02 | 0.00 | -0.00 |
| **unmatched** | **0.03** | **-0.02** | **0.00** | **0.00** |
| **the row** | **29.93** | **10.92** | **0.01** | **0.19** |
| **the issue's eight parts** | **29.81** | **10.90** | **0.01** | **0.18** |
| **their share of the row, %** | **99.57** | **99.77** | **99.85** | **98.56** |
| **every sample** | **-11.28** | **-1.83** | **-0.05** | **0.28** |
