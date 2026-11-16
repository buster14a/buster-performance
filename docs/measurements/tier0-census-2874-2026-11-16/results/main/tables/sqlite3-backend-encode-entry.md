| part | instructions | cycles | mispredicts | fills |
| --- | ---: | ---: | ---: | ---: |
| **the stream's decode** | **-0.10** | **-0.10** | **-0.00** | **-0.00** |
| … the columns' room and the labels | -0.14 | -0.08 | -0.00 | 0.00 |
| … the values' predicates (P0) | 0.01 | -0.02 | 0.00 | -0.00 |
| … the depths (P4) | 0.03 | -0.00 | -0.00 | 0.00 |
| **the selection** | **-0.16** | **0.12** | **0.00** | **-0.00** |
| … fusion (P1 to P3) | -0.18 | 0.01 | 0.00 | -0.00 |
| … the templates' words (selection's gather) | -0.02 | 0.03 | -0.00 | 0.00 |
| … measuring: the homes' case, lengths, positions | -0.08 | 0.03 | -0.00 | 0.00 |
| … measuring: a deferred entry's records counted | 0.03 | -0.00 | 0.00 | 0.00 |
| … the immediates' forms: the requests chosen | 0.15 | 0.00 | 0.00 | 0.00 |
| … the immediates' forms: applied to the records | -0.05 | 0.05 | -0.00 | -0.00 |
| **the homes and the frame** | **-0.32** | **-0.03** | **-0.00** | **-0.00** |
| … the references' count | -0.08 | -0.01 | 0.00 | 0.00 |
| … the homes | 0.03 | 0.02 | 0.00 | -0.00 |
| … the frame's layout | -0.26 | -0.10 | -0.00 | -0.00 |
| … the prologue and the epilogue | -0.02 | 0.06 | -0.00 | -0.00 |
| **the records' emission** | **0.24** | **-0.08** | **-0.00** | **-0.00** |
| … expansion: hole blocks, a permute and a store an entry | 0.20 | -0.02 | -0.00 | -0.00 |
| … the deferred entries' records (calls, division, copies) | -0.03 | -0.07 | -0.00 | -0.00 |
| … the output's arrays and the code's close | 0.06 | 0.02 | 0.00 | -0.00 |
| … the x87 values' transfers (long double) | 0.00 | -0.00 | 0.00 | 0.00 |
| **the encoder** | **13.73** | **3.60** | **0.01** | **0.04** |
| **branch sizing** | **11.42** | **5.14** | **0.02** | **0.06** |
| … the branch columns' check | 0.02 | -0.00 | -0.00 | -0.00 |
| … the records' lengths (x86_measure) | 7.48 | 3.12 | 0.01 | 0.03 |
| … size_branches | 3.91 | 2.02 | 0.01 | 0.02 |
| **the atoms and relocations** | **-0.01** | **-0.01** | **0.00** | **0.00** |
| … the symbols and their names | -0.01 | 0.01 | 0.00 | 0.00 |
| … the atoms and their fixups | -0.01 | -0.02 | 0.00 | 0.00 |
| **the unwind table** | **-0.00** | **0.00** | **0.00** | **-0.00** |
| **the emission's driver** | **-0.03** | **-0.02** | **0.00** | **-0.00** |
| … the bodies' loop, the windows, what the merge keeps | -0.01 | -0.02 | -0.00 | -0.00 |
| … Tier 0's splice of always_inline callees | -0.02 | 0.01 | 0.00 | -0.00 |
| … the inline callees' table (check_tier1_inline_table) | 0.00 | -0.01 | 0.00 | -0.00 |
| … the inline asm's bodies (the assembler) | 0.00 | -0.00 | 0.00 | 0.00 |
| **Tier 0's validation (the lowering's check, in `lower`)** | **-31.75** | **-12.72** | **-0.10** | **-0.19** |
| **the process** | **0.98** | **1.09** | **0.01** | **0.15** |
| **libc, caller not in the stack** | **0.22** | **0.36** | **0.00** | **0.06** |
| … memset | -0.03 | -0.05 | -0.00 | -0.01 |
| … memmove and memcpy | 0.24 | 0.42 | 0.00 | 0.07 |
| … memcmp | 0.01 | 0.00 | -0.00 | 0.00 |
| … strings | 0.00 | -0.01 | -0.00 | 0.00 |
| **the lowering** | **-0.01** | **-0.02** | **0.00** | **-0.00** |
| **the front end** | **0.11** | **-0.16** | **-0.00** | **0.00** |
| … the preprocessor and the lexer | -0.01 | -0.09 | -0.00 | -0.00 |
| … the parser | -0.00 | -0.00 | 0.00 | 0.00 |
| … the checker | 0.11 | -0.08 | 0.00 | 0.00 |
| … the static data's plan (check_data_prepare) | 0.01 | 0.01 | -0.00 | 0.00 |
| **unmatched** | **-0.01** | **-0.01** | **-0.00** | **-0.00** |
| **the row** | **24.76** | **8.61** | **0.03** | **0.09** |
| **the issue's eight parts** | **24.79** | **8.63** | **0.03** | **0.09** |
| **their share of the row, %** | **100.13** | **100.22** | **99.75** | **100.37** |
| **every sample** | **-5.69** | **-2.84** | **-0.07** | **0.11** |
