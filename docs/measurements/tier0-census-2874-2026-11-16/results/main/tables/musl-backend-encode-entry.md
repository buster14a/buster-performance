| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **-0.03** | **-0.24** | **-0.00** | **-0.00** |
| … the columns' room and the labels | -0.13 | -0.14 | -0.00 | -0.00 |
| … the values' predicates (P0) | 0.13 | -0.04 | -0.00 | -0.00 |
| … the depths (P4) | -0.02 | -0.05 | -0.00 | 0.00 |
| **the selection** | **-0.18** | **-0.11** | **-0.00** | **-0.00** |
| … fusion (P1 to P3) | -0.25 | 0.00 | 0.00 | 0.00 |
| … the templates' words (selection's gather) | 0.03 | 0.08 | 0.00 | -0.00 |
| … measuring: the homes' case, lengths, positions | -0.04 | -0.11 | -0.00 | 0.00 |
| … measuring: a deferred entry's records counted | -0.04 | -0.12 | 0.00 | 0.00 |
| … the immediates' forms: the requests chosen | 0.14 | -0.03 | -0.00 | -0.00 |
| … the immediates' forms: applied to the records | -0.02 | 0.07 | 0.00 | 0.00 |
| **the homes and the frame** | **-1.49** | **-0.29** | **-0.00** | **-0.01** |
| … the references' count | -0.05 | -0.00 | 0.00 | -0.00 |
| … the homes | -0.23 | 0.01 | -0.00 | 0.00 |
| … the frame's layout | -1.09 | -0.32 | -0.00 | -0.01 |
| … the prologue and the epilogue | -0.12 | 0.03 | 0.00 | 0.00 |
| **the records' emission** | **0.52** | **0.13** | **-0.00** | **0.00** |
| … expansion: hole blocks, a permute and a store an entry | 0.06 | -0.13 | 0.00 | -0.00 |
| … the deferred entries' records (calls, division, copies) | 0.30 | 0.08 | -0.00 | 0.00 |
| … the output's arrays and the code's close | 0.14 | 0.14 | 0.00 | 0.00 |
| … the x87 values' transfers (long double) | 0.02 | 0.04 | -0.00 | 0.00 |
| **the encoder** | **17.15** | **4.77** | **0.01** | **0.06** |
| **branch sizing** | **14.63** | **6.45** | **0.02** | **0.08** |
| … the branch columns' check | 0.02 | -0.03 | 0.00 | -0.00 |
| … the records' lengths (x86_measure) | 10.23 | 4.09 | 0.01 | 0.06 |
| … size_branches | 4.38 | 2.38 | 0.01 | 0.02 |
| **the atoms and relocations** | **-0.29** | **-0.09** | **0.00** | **-0.00** |
| … the symbols and their names | -0.24 | -0.12 | 0.00 | -0.00 |
| … the atoms and their fixups | -0.05 | 0.04 | -0.00 | -0.00 |
| **the unwind table** | **0.01** | **0.01** | **-0.00** | **0.00** |
| **the emission's driver** | **-0.55** | **-0.40** | **-0.00** | **-0.01** |
| … the bodies' loop, the windows, what the merge keeps | 0.03 | -0.07 | -0.00 | -0.00 |
| … the inline callees' table (check_tier1_inline_table) | -0.02 | -0.01 | -0.00 | 0.00 |
| … the inline asm's bodies (the assembler) | -0.57 | -0.32 | -0.00 | -0.01 |
| **the static data's atoms** | **-0.00** | **0.00** | **0.00** | **0.00** |
| **Tier 0's validation (the lowering's check, in `lower`)** | **-45.46** | **-16.37** | **-0.13** | **-0.23** |
| **the process** | **2.34** | **0.85** | **0.01** | **0.19** |
| **libc, caller not in the stack** | **0.11** | **0.17** | **-0.00** | **0.13** |
| … memset | 0.10 | -0.09 | -0.00 | 0.07 |
| … memmove and memcpy | 0.16 | 0.35 | -0.00 | 0.07 |
| … memcmp | 0.00 | 0.01 | -0.00 | 0.00 |
| … strings | -0.16 | -0.09 | 0.00 | -0.00 |
| **the lowering** | **-0.01** | **0.26** | **0.00** | **0.00** |
| **the front end** | **-0.99** | **0.43** | **-0.00** | **0.04** |
| … the preprocessor and the lexer | -0.65 | 0.23 | 0.00 | 0.00 |
| … the parser | -0.08 | 0.31 | 0.00 | 0.00 |
| … the checker | -0.17 | -0.12 | -0.00 | 0.04 |
| … the static data's plan (check_data_prepare) | -0.10 | 0.01 | 0.00 | 0.00 |
| **unmatched** | **-0.35** | **-0.14** | **-0.00** | **0.00** |
| **the row** | **29.77** | **10.23** | **0.03** | **0.13** |
| **the issue's eight parts** | **30.31** | **10.62** | **0.03** | **0.14** |
| **their share of the row, %** | **101.82** | **103.84** | **117.07** | **103.83** |
| **every sample** | **-14.61** | **-4.57** | **-0.10** | **0.26** |
