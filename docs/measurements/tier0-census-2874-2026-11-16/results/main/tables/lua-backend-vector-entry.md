| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **34.75** | **11.07** | **0.06** | **0.12** |
| … the columns' room and the labels | 18.28 | 5.62 | 0.02 | 0.05 |
| … the values' predicates (P0) | 11.41 | 3.21 | 0.02 | 0.06 |
| … the depths (P4) | 5.06 | 2.24 | 0.02 | 0.02 |
| **the selection** | **85.79** | **37.07** | **0.28** | **0.43** |
| … fusion (P1 to P3) | 20.01 | 7.78 | 0.08 | 0.11 |
| … the templates' words (selection's gather) | 19.59 | 10.38 | 0.06 | 0.22 |
| … measuring: the homes' case, lengths, positions | 23.12 | 9.86 | 0.08 | 0.04 |
| … measuring: a deferred entry's records counted | 10.59 | 4.56 | 0.03 | 0.01 |
| … the immediates' forms: the requests chosen | 4.14 | 1.62 | 0.02 | 0.02 |
| … the immediates' forms: applied to the records | 8.35 | 2.86 | 0.01 | 0.02 |
| **the homes and the frame** | **30.35** | **12.67** | **0.11** | **0.04** |
| … the references' count | 5.60 | 2.21 | 0.03 | 0.01 |
| … the homes | 5.99 | 3.36 | 0.04 | 0.01 |
| … the frame's layout | 8.55 | 3.83 | 0.03 | 0.01 |
| … the prologue and the epilogue | 10.22 | 3.27 | 0.02 | 0.01 |
| **the records' emission** | **70.01** | **23.87** | **0.16** | **0.22** |
| … expansion: hole blocks, a permute and a store an entry | 41.10 | 14.01 | 0.09 | 0.16 |
| … the deferred entries' records (calls, division, copies) | 21.04 | 7.05 | 0.05 | 0.05 |
| … the output's arrays and the code's close | 7.86 | 2.81 | 0.02 | 0.01 |
| … the x87 values' transfers (long double) | 0.01 | 0.00 | -0.00 | 0.00 |
| **the encoder** | **0.07** | **0.09** | **0.00** | **-0.00** |
| **branch sizing** | **-0.15** | **0.12** | **0.00** | **0.00** |
| … the branch columns' check | -0.03 | 0.03 | 0.00 | -0.00 |
| … the records' lengths (x86_measure) | -0.14 | 0.05 | -0.00 | 0.00 |
| … size_branches | 0.02 | 0.04 | -0.00 | -0.00 |
| **the atoms and relocations** | **0.03** | **0.04** | **0.00** | **0.00** |
| … the symbols and their names | 0.01 | 0.04 | 0.00 | 0.00 |
| … the atoms and their fixups | 0.03 | 0.01 | 0.00 | -0.00 |
| **the unwind table** | **-0.01** | **0.00** | **-0.00** | **0.00** |
| **the emission's driver** | **0.11** | **-0.14** | **-0.00** | **0.00** |
| … the bodies' loop, the windows, what the merge keeps | 0.10 | -0.12 | -0.00 | 0.00 |
| … the inline callees' table (check_tier1_inline_table) | 0.01 | 0.00 | -0.00 | 0.00 |
| … the inline asm's bodies (the assembler) | 0.01 | -0.03 | 0.00 | 0.00 |
| **Tier 0's validation (the lowering's check, in `lower`)** | **-42.34** | **-14.01** | **-0.05** | **-0.18** |
| **the process** | **-0.39** | **-0.04** | **0.00** | **-0.00** |
| **libc, caller not in the stack** | **0.01** | **-0.19** | **0.00** | **-0.03** |
| … memset | -0.02 | -0.18 | 0.00 | -0.02 |
| … memmove and memcpy | -0.01 | -0.02 | -0.00 | -0.00 |
| … memcmp | 0.00 | 0.00 | -0.00 | -0.00 |
| … strings | 0.04 | 0.00 | 0.00 | -0.00 |
| **the lowering** | **-0.08** | **-0.11** | **-0.00** | **0.00** |
| **the front end** | **0.34** | **0.29** | **-0.00** | **0.00** |
| … the preprocessor and the lexer | -0.10 | -0.04 | -0.00 | -0.01 |
| … the parser | 0.01 | 0.11 | -0.00 | -0.00 |
| … the checker | 0.41 | 0.13 | 0.00 | 0.01 |
| … the static data's plan (check_data_prepare) | 0.03 | 0.10 | -0.00 | -0.00 |
| **unmatched** | **-0.03** | **-0.02** | **-0.00** | **0.00** |
| **the row** | **220.96** | **84.79** | **0.61** | **0.81** |
| **the issue's eight parts** | **220.85** | **84.93** | **0.61** | **0.81** |
| **their share of the row, %** | **99.95** | **100.17** | **100.06** | **99.67** |
| **every sample** | **178.46** | **70.70** | **0.56** | **0.61** |
